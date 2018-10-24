# Snipe-IT API Cookbook

Provides Chef Custom Resources for accessing the Snipe-IT REST API.

If you're looking for a cookbook that installs Snipe-IT, see the [Snipe-IT Cookbook](https://supermarket.chef.io/cookbooks/snipe-it).

## Requirements

### Chef

- Chef 14.0+

### Cookbooks

- chef-sugar
- chef-vault

### Environment

Tested with **Snipe-IT v4.6.4** on **Ubuntu 16.04**.

## Attributes

- `['snipeit']['api']['instance']` - the URL for your Snipe-IT installation. Default is `http://snipe-it.mycompany.com`
- `['snipeit']['api']['token']` - [JSON Web Token](https://jwt.io/) used to authenticate with the API. See [Generating an API Token](#generating-api-token). Default is `nil`.

## Usage

This cookbook expects that you already have a Snipe-IT installation configured, and an API token generated.

### Generating an API Token

Please reference the [Snipe-IT documentation for the API](https://snipe-it.readme.io/v4.6.3/reference#generating-api-tokens) on how to generate a token.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit [https://cla.microsoft.com](https://cla.microsoft.com).

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
