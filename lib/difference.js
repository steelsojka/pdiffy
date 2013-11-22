var checkDifference, checkThreshold, compare, compute, getPixel, isServer;

isServer = typeof module !== 'undefined';

compare = function(pixels) {
  var pix, x, y, _i, _j, _ref, _ref1;
  pix = [];
  for (x = 0, len = pixels.length; x < len; x++) {
    for (y = 0, len2 = pixels.length; y < len2; y++) {
      pix.push(Math.abs(pixels[x] - pixels[y]));
    }
  }
  return Math.max.apply(Math, pix);
};

getPixel = function(arr, i) {
  var output, pix, _i;
  output = [];
  for (_i = arr.length - 1; _i >= 0; _i += -1) {
    pix = arr[_i] || 0;
    output.unshift(pix.data.data[i]);
  }
  return output;
};

checkDifference = function(r, g, b) {
  return r > 0 || g > 0 || b > 0;
};

checkThreshold = function(r, g, b, threshold) {
  return r <= threshold && g <= threshold && b <= threshold;
};

compute = function(options) {
  var b, context, contextData, data, g, i, imageData, isDifferent, isUnderThreshold, maxLength, maxValue, mode, outputData, r, threshold, _i;
  data = options.imageData;
  outputData = {
    numberOfSamePixels: 0,
    numberOfDifferentPixels: 0,
    totalPixels: 0
  };
  context = options.contextData;
  contextData = context.data;

  maxLength = Math.max.apply(Math, data.map(function(a) {
    return a.data.data.length;
  }));
  
  mode = options.mode;
  threshold = options.threshold || 0;

  for (i = _i = 0; _i < maxLength; i = _i += 4) {
    r = compare(getPixel(data, i));
    g = compare(getPixel(data, i + 1));
    b = compare(getPixel(data, i + 2));
    isDifferent = checkDifference(r, g, b);
    isUnderThreshold = checkThreshold(r, g, b, threshold);

    if (isUnderThreshold) {
      r = g = b = 0;
      outputData.numberOfSamePixels++;
    } else {
      outputData.numberOfDifferentPixels++;
      if (mode === "heatmap" && isDifferent) {
        maxValue = Math.max(r, g, b);
        r = g = maxValue;
        b = 0;
      } else if (mode === "block" && isDifferent) {
        r = g = 255;
        b = 0;
      }
    }

    contextData[i] = r;
    contextData[i + 1] = g;
    contextData[i + 2] = b;
    contextData[i + 3] = 255;
    outputData.totalPixels++;
  }

  imageData = {
    event: "done",
    id: options.id,
    data: context,
    y: options.startY,
    block: options.block,
    stats: outputData
  };

  if (isServer) {
    return imageData;
  } else {
    self.postMessage(imageData);
    self.close();
  }
};

if (isServer) {
  module.exports.compute = compute;
} else {
  self.addEventListener('message', function(e) {
    return compute(e.data);
  });
}

