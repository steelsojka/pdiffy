describe("difference.js", function() {
  var difference = require(__dirname + "/../../lib/difference");
  var img1 = {data: {data: [
    0,0,0,255, 
    0,0,0,255,
    128,128,128,255,
    0,0,0,255,
    0,0,0,255
  ]}};
  var img2 = {data: {data: [
    255,255,255,255,
    0,0,0,255,
    156,156,156,255,
    0,0,0,255,
    255,255,255,255
  ]}};

  it("should perform a difference with block mode and threshold of 0", function() {
    var diffImg = {data: []};
    var output = difference.compute({
      imageData: [img1, img2],
      contextData: diffImg,
      threshold: 0,
      mode: "block",
      id: 1,
      block: 0,
      startY: 0
    });

    compare(output.data.data, [
      255,255,0,255,
      0,0,0,255,
      255,255,0,255,
      0,0,0,255,
      255,255,0,255
    ]);

  });

  it("should perform a difference with heatmap mode and threshold of 0", function() {
    var diffImg = {data: []};
    var output = difference.compute({
      imageData: [img1, img2],
      contextData: diffImg,
      threshold: 0,
      mode: "heatmap",
      id: 1,
      block: 0,
      startY: 0
    });

    compare(output.data.data, [
      255,255,0,255,
      0,0,0,255,
      28,28,0,255,
      0,0,0,255,
      255,255,0,255
    ]);

  });

  it("should perform a difference with subtraction mode and threshold of 0", function() {
    var diffImg = {data: []};
    var output = difference.compute({
      imageData: [img1, img2],
      contextData: diffImg,
      threshold: 0,
      id: 1,
      block: 0,
      startY: 0
    });

    compare(output.data.data, [
      255,255,255,255,
      0,0,0,255,
      28,28,28,255,
      0,0,0,255,
      255,255,255,255
    ]);

  });

  it("should perform a difference with subtraction mode and threshold of 50", function() {
    var diffImg = {data: []};
    var output = difference.compute({
      imageData: [img1, img2],
      contextData: diffImg,
      threshold: 50,
      id: 1,
      block: 0,
      startY: 0
    });

    compare(output.data.data, [
      255,255,255,255,
      0,0,0,255,
      0,0,0,255,
      0,0,0,255,
      255,255,255,255
    ]);

  });

  function compare(actual, expected) {
    for (var i = 0; i < actual.length; i++) {
      expect(actual[i]).toBe(expected[i]);
    }
  }

});
