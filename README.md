# Snipe-IT API Cookbook

[![Build Status](https://dev.azure.com/office/APEX/_apis/build/status/Snipe-IT%20API%20Cookbook)](https://dev.azure.com/office/APEX/_build/latest?definitionId=4257)

Provides Chef Custom Resources for accessing the Snipe-IT REST API.

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
- `['snipeit']['api']['token']` - [JSON Web Token](https://jwt.io/) used to authenticate with the API. See [Generate an API Token](#generate-an-api-token). Default is `nil`.

## Resources

### General Properties

These properties are available in all resources:

- `:token`, String
- `:url`, String, default: `node['snipeit']['api']['instance']`

### `asset`

#### Actions

- `:create`, default: `true`

#### Properties

- `:asset_tag`, String, name_property: true
- `:location`, String
- `:model`, String, required: true
- `:purchase_date`, String
- `:serial_number`, String, required: true
- `:status`, String, required: true
- `:supplier`, String

### `category`

#### Actions

- `:create`, default: `true`

#### Properties

- `:category`, String, name_property: true
- `:category_type`, String, required: true

### `location`

#### Actions

- `:create`, default: `true`

#### Properties

- `:location`, String, name_property: true
- `:address`, String
- `:city`, String
- `:state`, String
- `:zip`, String
- `:country`, String, default: 'US'
- `:currency`, String, default: 'USD'

### `manufacturer`

#### Actions

- `:create`, default: `true`

#### Properties

- `:manufacturer`, String, name_property: true
- `:website`, String

### `model`

#### Actions

- `:create`, default: `true`

#### Properties

- `:model`, String, name_property: true
- `:model_number`, String
- `:manufacturer`, String
- `:category`, String
- `:eol`, Integer
- `:fieldset`, String

## Usage

This cookbook expects that you already have a Snipe-IT installation configured, and an API token generated. If you're looking for a cookbook that installs Snipe-IT, see the [Snipe-IT Cookbook](https://supermarket.chef.io/cookbooks/snipe-it).

### Generate an API Token

Please reference the [Snipe-IT documentation for the API](https://snipe-it.readme.io/v4.6.3/reference#generating-api-tokens) on how to generate a token.

You can pass the API key to your Chef run with:

- the `token` property in the resource block
- setting the `['snipeit']['api']['token']` node attribute
- creating Chef Vault, or a data bag under `snipe-it/api` with the token value assigned to `key`.

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
