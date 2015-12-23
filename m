From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3 0/2] crypto: KEYS: convert public key to akcipher api
Date: Tue, 22 Dec 2015 21:12:39 -0800
Message-ID: <20151223051239.1858.7404.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39178 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbLWFQI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 00:16:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set converts the module verification and digital signature
code to the new akcipher API.
RSA implementation has been removed from crypto/asymmetric_keys and the
new API is used for cryptographic primitives.
There is no need for MPI above the akcipher API anymore.
Modules can be verified with software as well as HW RSA implementations.

Patches generated against cryptodev-2.6

Changes in v3:
- Don't include keys/asymmetric-type.h in crypto/public_key.h

Changes in v2:
- Fix the whey public_key_signature is setup. The pointer s needs to
  point to the signature instread of the signature_v2_hdr.  
- Select CRYPTO_RSA when INTEGRITY_ASYMMETRIC_KEYS is selected.

---

Tadeusz Struk (2):
      crypto: KEYS: convert public key to the akcipher api
      integrity: convert digsig to akcipher api

 crypto/asymmetric_keys/Kconfig            |    2 
 crypto/asymmetric_keys/Makefile           |    7 -
 crypto/asymmetric_keys/pkcs7_parser.c     |   12 +-
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    2 
 crypto/asymmetric_keys/public_key.c       |   64 +++------
 crypto/asymmetric_keys/public_key.h       |   36 -----
 crypto/asymmetric_keys/rsa.c              |  213 +++++++++++------------------
 crypto/asymmetric_keys/x509_cert_parser.c |   37 +----
 crypto/asymmetric_keys/x509_public_key.c  |   17 +-
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 -
 include/crypto/public_key.h               |   48 ++-----
 security/integrity/Kconfig                |    1 
 security/integrity/digsig_asymmetric.c    |   10 -
 14 files changed, 139 insertions(+), 316 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1

--
TS
