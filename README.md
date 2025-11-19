# check-list

Command line library for rspec

## Installation
`gem install check_list`

## Usage

### Commands
`check_list`

`check_list -m <keyword>``` or ```check_list --method <keyword>`
If a keyword is matched the example is shown

After an example is displayed pressing return will restart the menu.
At any time typing 'q' will exit the tool.

### Custom Setup
The tool will use the default json config from the github repo.

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

