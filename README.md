# spec-ref-lib

Command line library for rspec

## Installation
`gem install spec-ref-lib`

## Usage

### Commands
`spec-ref-lib`
Displays a menu and asks for an input. 
1. matchers
2. doubles
3. subject
4. other

`spec-ref-lib -m <keyword>``` or ```spec-ref-lib --method <keyword>`
If a keyword is matched the example is shown

After an example is displayed pressing return will restart the menu.
At any time typing 'q' will exit the tool.

### Custom Setup
The tool will use the default json config from the github repo.

To force the tool to use a custom json file create an environment variable (SPEC_REF_LIB) with the absolute path to the loaction of your custom json file.
`export SPEC_REF_LIB=/Users/mycompname/somefile/myCustomJsonSpecLibFile.json`

### Json Structure

```
{
  "categories": [
    {
      "name": "GROUP NAME",
      "categories": [
        {
          "name":"METHOD NAME",
          "example": "STRING VERSION OF EXAMPLE TO BE SHOWN"
          "keywords": ["KEYWORD STRING","KEYWORD STRING"]
        }
      ]
    }
  ]
}
```

