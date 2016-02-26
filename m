From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/3] KEYS: Use crypto rsa pkcs1pad module for software
 public keys
Date: Fri, 26 Feb 2016 15:23:33 +0000
Message-ID: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, balrogg@googlemail.com,
	keyrings@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbcBZPXf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 10:23:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Here's a set of patches that change the software public key asymmetric key
subtype to use the RSA pkcs1pad module in the crypto layer.  I've merged
together mine and Tadeusz's patches.

I have not included Tadeusz's original three patches that converted to
using the raw rsa module in this set, but they're prerequisites for this.

David
---
David Howells (2):
      akcipher: Move the RSA DER encoding check to the crypto layer
      X.509: Make algo identifiers text instead of enum

Tadeusz Struk (1):
      crypto: Add hash param to pkcs1pad


 crypto/asymmetric_keys/Kconfig            |    7 -
 crypto/asymmetric_keys/Makefile           |    1 
 crypto/asymmetric_keys/mscode_parser.c    |   14 +-
 crypto/asymmetric_keys/pkcs7_parser.c     |   18 +-
 crypto/asymmetric_keys/pkcs7_verify.c     |    8 -
 crypto/asymmetric_keys/public_key.c       |  120 ++++++++++++----
 crypto/asymmetric_keys/rsa.c              |  224 -----------------------------
 crypto/asymmetric_keys/verify_pefile.c    |    4 -
 crypto/asymmetric_keys/verify_pefile.h    |    2 
 crypto/asymmetric_keys/x509_cert_parser.c |   26 ++-
 crypto/asymmetric_keys/x509_public_key.c  |   17 +-
 crypto/rsa-pkcs1pad.c                     |  182 ++++++++++++++++++++----
 include/crypto/public_key.h               |   32 +---
 init/Kconfig                              |    2 
 kernel/module_signing.c                   |    6 +
 security/integrity/digsig_asymmetric.c    |    7 -
 16 files changed, 305 insertions(+), 365 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/rsa.c
