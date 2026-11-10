# AnonymousAuthorization

Enable Anonymous authorization for resource by access_code(password)

## Usage

Include `AnonymousAuthorization::AccessGuard` in the controller and call
`authorize_anonymous_access(resource)` after loading the protected resource.

`AnonymousAuthorization::AuthorizationSession.new(session:)` manages the browser's
resource grants with `authorize(resource, expires_at: nil)`, `authorized?(resource)`
and `clear(resource)`. It does not authenticate users or validate access codes;
call `authorize` only after `AccessCodeService#authorize?` has validated the submitted code.

Authorization initializes the Rails session only when necessary. Reads and clearing
never create a session. Grants stay in `Rails.cache`, use the `anon_auth:` key prefix,
and expire after one day by default; reads do not extend expiry. Changing a resource's
access code invalidates existing grants. Session-ID digests and full resource GlobalIDs
isolate browsers and resources without adding business fields to the cookie.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "anonymous_authorization", git: "git@github.com:as181920/anonymous_authorization.git", branch: "main"
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
