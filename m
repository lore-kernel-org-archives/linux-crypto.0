From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 0/8] KEYS: keyctl operations for asymmetric keys [ver 3]
Date: Wed, 11 May 2016 15:21:52 +0100
Message-ID: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbcEKOV4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 10:21:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Here's a set of patches that provides keyctl access for asymmetric keys,
including a query function, and functions to do encryption, decryption,
signature creation and signature verification.

I've added a PKCS#8 asymmetric key parser so that you can load an RSA private
key into the kernel.  Currently only DER-encoded and unencrypted PKCS#8 is
supported.  Encryption and verification can use a public key from an X.509
cert, but signing and decryption require a private key, though encryption and
verification can use that too.

Example usage:

	j=`openssl pkcs8 -in ~/pkcs7/firmwarekey2.priv -topk8 -nocrypt -outform DER | \
	    keyctl padd asymmetric foo @s`
	echo -n abcdefghijklmnopqrst >/tmp/data
	keyctl pkey_encrypt $j 0 /tmp/data enc=pkcs1 >/tmp/enc
	keyctl pkey_decrypt $j 0 /tmp/enc enc=pkcs1 >/tmp/dec
	cmp /tmp/data /tmp/dec
	keyctl pkey_sign $j 0 /tmp/data enc=pkcs1 hash=sha1 >/tmp/sig
	keyctl pkey_verify $j 0 /tmp/data /tmp/sig enc=pkcs1 hash=sha1

The kernel patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl

The keyutils changes needed can be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=pkey

David
---
David Howells (8):
      KEYS: Provide key type operations for asymmetric key ops
      KEYS: Provide keyctls to drive the new key type ops for asymmetric keys
      KEYS: Provide missing asymmetric key subops for new key type ops
      KEYS: Make the X.509 and PKCS7 parsers supply the sig encoding type
      KEYS: Provide software public key query function
      KEYS: Allow the public_key struct to hold a private key
      KEYS: Implement encrypt, decrypt and sign for software asymmetric key
      KEYS: Implement PKCS#8 RSA Private Key parser


 Documentation/crypto/asymmetric-keys.txt  |   33 ++-
 Documentation/security/keys.txt           |  224 +++++++++++++++++++
 crypto/asymmetric_keys/Kconfig            |   10 +
 crypto/asymmetric_keys/Makefile           |   13 +
 crypto/asymmetric_keys/asymmetric_keys.h  |    3 
 crypto/asymmetric_keys/asymmetric_type.c  |   60 +++++
 crypto/asymmetric_keys/pkcs7_parser.c     |    1 
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs8.asn1         |   24 ++
 crypto/asymmetric_keys/pkcs8_parser.c     |  184 ++++++++++++++++
 crypto/asymmetric_keys/public_key.c       |  196 +++++++++++++++--
 crypto/asymmetric_keys/restrict.c         |    2 
 crypto/asymmetric_keys/signature.c        |  112 ++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |   21 +-
 include/crypto/public_key.h               |   14 +
 include/keys/asymmetric-subtype.h         |   10 +
 include/linux/key-type.h                  |   11 +
 include/linux/keyctl.h                    |   47 ++++
 include/uapi/linux/keyctl.h               |   31 +++
 security/integrity/digsig_asymmetric.c    |    2 
 security/keys/Makefile                    |    1 
 security/keys/compat.c                    |   15 +
 security/keys/internal.h                  |   39 +++
 security/keys/keyctl.c                    |   23 ++
 security/keys/keyctl_pkey.c               |  335 +++++++++++++++++++++++++++++
 25 files changed, 1364 insertions(+), 49 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pkcs8.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs8_parser.c
 create mode 100644 include/linux/keyctl.h
 create mode 100644 security/keys/keyctl_pkey.c
