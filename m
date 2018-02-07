From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/9] PKCS#7 / X.509 fixes and cleanups
Date: Tue,  6 Feb 2018 17:10:03 -0800
Message-ID: <20180207011012.5928-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:41398 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeBGBPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 20:15:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Hi David, here is another set of fixes and cleanups for the PKCS#7 and
X.509 code:

Patches 1-5 fix the BUG_ON() in public_key_verify_signature() reported
by Paolo Valente as well as several other bugs I found.  Notably both
the PKCS#7 certificate chain verification and certificate blacklisting
were broken.  With the certificate chaining bug (introduced in v4.7) it
is almost possible to bypass PKCS#7 signature verification completely,
though I couldn't quite make it work.

Patches 6-9 remove dead code related to the unsupported_key and
unsupported_sig flags on struct x509_certificate's.  It's possible these
flags should be fixed instead, so that we handle unrecognized or
unsupported algorithms more gracefully.  But evidently no one is
complaining about the current behavior, and removing the dead code is
strictly an improvement as it doesn't actually change the behavior...

Eric Biggers (9):
  PKCS#7: fix certificate chain verification
  PKCS#7: fix certificate blacklisting
  PKCS#7: fix direct verification of SignerInfo signature
  X.509: fix BUG_ON() when hash algorithm is unsupported
  X.509: fix NULL dereference when restricting key with unsupported_sig
  PKCS#7: remove unnecessary check for NULL sinfo->sig->hash_algo
  X.509: remove never-set ->unsupported_key flag
  X.509: remove dead code that set ->unsupported_sig
  X.509: self_signed implies !unsupported_sig

 crypto/asymmetric_keys/pkcs7_trust.c     |  1 +
 crypto/asymmetric_keys/pkcs7_verify.c    | 36 +++++++++-----------------------
 crypto/asymmetric_keys/public_key.c      |  4 +++-
 crypto/asymmetric_keys/restrict.c        | 21 ++++++++++++-------
 crypto/asymmetric_keys/x509_parser.h     |  3 +--
 crypto/asymmetric_keys/x509_public_key.c | 18 ----------------
 6 files changed, 28 insertions(+), 55 deletions(-)

-- 
2.16.0.rc1.238.g530d649a79-goog
