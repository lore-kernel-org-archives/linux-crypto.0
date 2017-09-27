From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] KEYS: Fixes and crypto fixes
Date: Wed, 27 Sep 2017 22:19:24 +0100
Message-ID: <28036.1506547164@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Halcrow <mhalcrow@google.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-ID: <28035.1506547164.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

Can you pull these and pass them on to Linus.  There are two sets of
patches here:

 (1) A bunch of core keyrings bug fixes from Eric Biggers.

 (2) Fixing big_key to use safe crypto from Jason A. Donenfeld.

There are more patches to come from Eric, but I haven't reviewed at them
yet, so I haven't included them here.  Thanks to Eric for reviewing the
keyrings code.

David
---
The following changes since commit ebb2c2437d8008d46796902ff390653822af6cc4:

  Merge tag 'mmc-v4.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc (2017-09-18 08:44:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20170927

for you to fetch changes up to 428490e38b2e352812e0b765d8bceafab0ec441d:

  security/keys: rewrite all of big_key crypto (2017-09-25 23:31:58 +0100)

----------------------------------------------------------------
Keyrings fixes

----------------------------------------------------------------
Eric Biggers (10):
      KEYS: fix cred refcount leak in request_key_auth_new()
      KEYS: don't revoke uninstantiated key in request_key_auth_new()
      KEYS: fix key refcount leak in keyctl_assume_authority()
      KEYS: fix key refcount leak in keyctl_read_key()
      KEYS: fix writing past end of user-supplied buffer in keyring_read()
      KEYS: prevent creating a different user's keyrings
      KEYS: prevent KEYCTL_READ on negative key
      KEYS: reset parent each time before searching key_user_tree
      KEYS: restrict /proc/keys by credentials at open time
      KEYS: use kmemdup() in request_key_auth_new()

Jason A. Donenfeld (2):
      security/keys: properly zero out sensitive key material in big_key
      security/keys: rewrite all of big_key crypto

 include/linux/key.h              |   2 +
 security/keys/Kconfig            |   4 +-
 security/keys/big_key.c          | 139 ++++++++++++++++++---------------------
 security/keys/internal.h         |   2 +-
 security/keys/key.c              |   6 +-
 security/keys/keyctl.c           |  13 ++--
 security/keys/keyring.c          |  37 ++++++-----
 security/keys/proc.c             |   8 +--
 security/keys/process_keys.c     |   6 +-
 security/keys/request_key_auth.c |  74 ++++++++++-----------
 10 files changed, 139 insertions(+), 152 deletions(-)
