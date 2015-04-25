This is a scraper for the DC Board of Elections' results website, so that civic hackers, media organizations, campaigns, and others can grab usable returns immediately (official CSVs are usually posted on about a 24 hour delay).

You'll need to be able to run Ruby scripts, which this is. If you're on a Mac, you're all set. If you're on Linux, you probably don't need my help. If you're on Windows, you can use [RubyInstaller](http://rubyinstaller.org) to get started, however, the instructions below will need to be adapted for your use.

(The scraper was written, and has only been tested with Ruby 2.1.3. No obvious reason it shouldn't work elsewhere, but if you're getting errors, this could be why.)

We'll use the command line to make the magic happen. If you're on a Mac, this means you need to open the Terminal application.

First, let's download the project by clicking the Download ZIP button at right. Unzip it, and move the project wherever you'd like it to live on your computer.

Now, using the command line, we need to navigate to the project directory using the `cd` command. So if I stored the project on my Desktop, I'd run:

```
cd Desktop/dcboe-scraper
```

This project depends on other open source tools to run. We can install them with one command by running:

```
bundle install
```

All the customization we need to do happens in the `setup.json` file. Here, we need to copy the URL of the election results page, and list the races and candidates we want to scrape, in the format shown. If you need help, take a look at this [w3schools guide](http://www.w3schools.com/json/).

Once we're done, we run the script:

```
./scraper.rb
```

A CSV for each race will be generated in the `output` directory.
