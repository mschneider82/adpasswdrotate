# adpasswdrotate
Script to rotate Active Directory password n-times

this overwrites the AD password history (default 24 passwords), so you should be able to use a old password or the current one, whatever the PW Policy says.

Feel free to summit a PR to make the code nicer.

```bash
docker run -it --rm mschneider82/adpasswdrotate:latest
```

You can use it, but it’s at your own risk.
