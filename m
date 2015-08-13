From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/2] crypto: KEYS: convert public key to the akcipher API
Date: Wed, 12 Aug 2015 20:54:33 -0700
Message-ID: <20150813035433.25108.3065.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, tadeusz.struk@intel.com, steved@redhat.com,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbHMDzk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 23:55:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the module verification code to the new akcipher API.
RSA implementation from crypto/asymmetric_keys has been removed and the
new API is used for cryptographic primitives. The signature verification
has been moved into a new crypto/asymmetric_keys/rsa_pkcs1_v1_5.c file.
There is no need for MPI above the API anymore.
Modules can be verified with software as well as HW rsa implementations.

Also changed qat rsa implementation not to move data inside
the output buff similarly to SW.

---

Tadeusz Struk (2):
      crypto: KEYS: convert public key to the akcipher API
      crypto: qat - Don't move data inside output buffer


 crypto/asymmetric_keys/Kconfig                |    2 
 crypto/asymmetric_keys/Makefile               |    7 -
 crypto/asymmetric_keys/pkcs7_parser.c         |   12 -
 crypto/asymmetric_keys/pkcs7_trust.c          |    2 
 crypto/asymmetric_keys/pkcs7_verify.c         |    2 
 crypto/asymmetric_keys/public_key.c           |   59 +----
 crypto/asymmetric_keys/public_key.h           |   36 ---
 crypto/asymmetric_keys/rsa.c                  |  278 -------------------------
 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c       |  232 +++++++++++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c     |   37 +--
 crypto/asymmetric_keys/x509_public_key.c      |   17 +-
 crypto/asymmetric_keys/x509_rsakey.asn1       |    4 
 drivers/crypto/qat/qat_common/qat_asym_algs.c |    3 
 include/crypto/public_key.h                   |   48 +---
 kernel/module_signing.c                       |   56 ++---
 security/integrity/digsig_asymmetric.c        |   11 -
 16 files changed, 304 insertions(+), 502 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/rsa.c
 create mode 100644 crypto/asymmetric_keys/rsa_pkcs1_v1_5.c
 delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1

--
