# pdiffy

pdiffy is a perceptual difference tool used to compare images for differences. This tool is primarily aimed at web developement
for comparing different states of a website.

## Getting Started
Install the module with: `npm install -g pdiffy`

## Documentation
Run `pdiffy` to start the interface and web server.

You can run a schedule process that creates `sessions` at different intervals.
Screen shots taken get embedded into the session file.
The session can be imported into the interface.

Run `pdiffy schedule [path]` to run a schedule.

**Currently the schedule processing does not perform differences**

Run `pdiffy combine [sessions] -o [output]` to combine multiple session files.

**This does not delete the original session files. This feature is coming**

Run `pdiffy difference [paths | urls] -o [output] -t [threshold] -m [mode]` to perform differences
and output the file. Path can be a URL or path to an image file or any combination of the two.

### Schedule Options

#### output
The path to the file you want to save to. Make sure node has
permissions to write to this destination. This must have the
extension `.pdiffy` in order for it to be able to be imorted into
the interface.

#### schedule
pdiffy uses [node-schdule](https://github.com/mattpat/node-schedule)
to schedule jobs. This uses the object literal syntax. Please refer to
it's documentation. If the schedule is absent then the job occurs only
once.

#### interval
Interval is similar to schedule except instead of schedule a time it executes every N minutes.
If schedule and interval are present, schedule takes priority.

#### timestamp
Whether to add a timestamp to the filename. This is true by default
when the schedule option is present.

#### options
pdiffy uses [node-webshot](https://github.com/brenden/node-webshot)
to take screen shots. These options are just passed through to node-webshot.

#### captures
An array of captures. These contain the following parameters:
- `Object` options: Overrides the global webshot options
- `String|Array` url: The url to capture or if an array or urls are passed those pages will
   be captured and a difference will be performed from each of them.

### Using Progmatically
`var pdiffy = require("pdiffy");`

#### Methods
##### startServer()
Starts the server for the interface. Returns with a method `killServer`.

##### capture(config, callback)
- `Object` config - config object
- `Function` callback - callback function

Takes a config schedule object. This will only execute the capture once.
Use `runSchedule()` when wanting to start a schedule.

##### writeSession(config, session, callback)
- `Object` config - config object
- `Object` session - The session object to write to disk
- `Function` callback - callback function

Writes a session to disk based on the configuration object.

##### runSchedule(config, callback)
- `Object` config - config object
- `Function` callback - callback function

Runs the schedule based on the schedule config object.

##### runInterval(config, callback)
- `Object` config - config object
- `Function` callback - callback function

Runs the job every N minutes.

#### combine(sessionPaths, outputPath)
- `Array` sessionPaths - array of session paths
- `String` outputPath - path to write to disk

Combine multiple session files.

## Examples
Heres an example schedule file (json):
```json
{
  "output": "path/to/session/file.pdiffy",
  "schedule": {
    "minutes": 30
  },
  "options": {
    "shotSize": {
      "width": "all",
      "height": "all"
    }
  },
  "captures": [
    {
      "options": {},
      "url": "http://google.com"
    }, {
      "options": {},
      "url": "http://cnn.com"
    }, {
      "options": {},
      "url": "http://espn.com"
    }
  ] 
}
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. 
Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
v0.1.0 stable release

## License
Copyright (c) 2013 Steven Sojka. Licensed under the MIT license.`

