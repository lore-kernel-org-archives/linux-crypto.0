From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/10] KEYS: Change how keys are determined to be trusted
Date: Wed, 21 Oct 2015 16:13:15 +0100
Message-ID: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbJUPNT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 11:13:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Here's a set of patches that changes how keys are determined to be trusted
- currently, that's a case of whether a key has KEY_FLAG_TRUSTED set upon
it.  A keyring can then have a flag set (KEY_FLAG_TRUSTED ONLY) that
indicates that only keys with this flag set may be added to that keyring.

Further, any time an X.509 certificate is instantiated without this flag
set, the certificate is judged against the contents of the system trusted
keyring to determine whether KEY_FLAG_TRUSTED should be set upon it.

With these patches, KEY_FLAG_TRUSTED is removed.  The kernel may add
implicitly trusted keys to a trusted-only keyring by asserting
KEY_ALLOC_TRUSTED when the key is created, but otherwise the key will only
be allowed to be added to the keyring if it can be verified by a key
already in that keyring.  The system trusted keyring is not then special in
this sense and other trusted keyrings can be set up that are wholly
independent of it.

To make this work, we have to retain sufficient data from the X.509
certificate that we can then verify the signature at need.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-trust

and are tagged with:

	keys-trust-20151021

David
---
David Howells (10):
      KEYS: Generalise system_verify_data() to provide access to internal content
      PKCS#7: Make trust determination dependent on contents of trust keyring
      KEYS: Add facility to check key trustworthiness upon link creation
      KEYS: Allow authentication data to be stored in an asymmetric key
      KEYS: Add identifier pointers to public_key_signature struct
      X.509: Retain the key verification data
      X.509: Extract signature digest and make self-signed cert checks earlier
      PKCS#7: Make the signature a pointer rather than embedding it
      X.509: Move the trust validation code out to its own file
      KEYS: Move the point of trust determination to __key_link()


 Documentation/security/keys.txt           |   17 ++
 arch/x86/kernel/kexec-bzimage64.c         |   18 --
 certs/system_keyring.c                    |   49 +++--
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/Makefile           |    4 
 crypto/asymmetric_keys/asymmetric_keys.h  |    2 
 crypto/asymmetric_keys/asymmetric_type.c  |   22 ++
 crypto/asymmetric_keys/mscode_parser.c    |   21 +-
 crypto/asymmetric_keys/pkcs7_key_type.c   |   64 +++---
 crypto/asymmetric_keys/pkcs7_parser.c     |   59 +++--
 crypto/asymmetric_keys/pkcs7_parser.h     |   11 -
 crypto/asymmetric_keys/pkcs7_trust.c      |   44 ++--
 crypto/asymmetric_keys/pkcs7_verify.c     |  108 ++++------
 crypto/asymmetric_keys/public_key.c       |   43 ++++
 crypto/asymmetric_keys/public_key.h       |    6 +
 crypto/asymmetric_keys/public_key_trust.c |  180 +++++++++++++++++
 crypto/asymmetric_keys/verify_pefile.c    |   40 +---
 crypto/asymmetric_keys/verify_pefile.h    |    5 
 crypto/asymmetric_keys/x509_cert_parser.c |   53 +++--
 crypto/asymmetric_keys/x509_parser.h      |   12 -
 crypto/asymmetric_keys/x509_public_key.c  |  312 +++++++++--------------------
 include/crypto/pkcs7.h                    |    6 -
 include/crypto/public_key.h               |   28 +--
 include/keys/asymmetric-subtype.h         |    6 -
 include/keys/asymmetric-type.h            |    8 -
 include/keys/system_keyring.h             |    7 -
 include/linux/key-type.h                  |   10 +
 include/linux/key.h                       |   12 +
 include/linux/verification.h              |   49 +++++
 include/linux/verify_pefile.h             |   22 --
 kernel/module_signing.c                   |    5 
 security/integrity/digsig_asymmetric.c    |    5 
 security/keys/key.c                       |   44 +++-
 security/keys/keyring.c                   |   18 +-
 34 files changed, 735 insertions(+), 556 deletions(-)
 create mode 100644 crypto/asymmetric_keys/public_key_trust.c
 create mode 100644 include/linux/verification.h
 delete mode 100644 include/linux/verify_pefile.h
