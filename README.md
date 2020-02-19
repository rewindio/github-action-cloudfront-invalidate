# github-action-cloudfront-invalidate

Github action to invalidate a path in an AWS Cloudfront distribution.  This is heavily based on the excellent work from [Jake Jarvis](https://github.com/jakejarvis) with his [sync action](https://github.com/jakejarvis/s3-sync-action)

## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```bash
name: Invalidate Cloudfront
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@master

    - name: Invalidate Cloudfront
      uses: docker://rewindio/github-action-cloudfront-invalidate
      env:
        DISTRIBUTION_ID: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
        PATH_TO_INVALIDATE: /myfolder/myfile.png
        AWS_REGION: us-east-1
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### Environment Variables

| Key | Value | Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `DISTRIBUTION_ID` | The ID of the cloudfront distribution to create the invalidation for | `env` | **Yes** |
| `PATH_TO_INVALIDATE` | Path to invalidate. For example, `/myfolder/myfile.png`. | `env` | **Yes** |
| `AWS_REGION` | The region where you created your bucket in. For example, `us-east-1`. Defaults to `us-east-1` if not specified | `env` | **No** |

### Required Secret Variables

The following variables should be added as "secrets" in the action's configuration.

| Key | Value | Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | `secret` | **Yes** |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | `secret` | **Yes** |

## License

This project is distributed under the [MIT license](LICENSE.md).
