From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/2] crypto: KEYS: convert public key to akcipher api
Date: Wed, 09 Dec 2015 15:52:26 -0800
Message-ID: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch set converts the module verification and digital signature
code to the new akcipher API.
RSA implementation has been removed from crypto/asymmetric_keys and the
new API is used for cryptographic primitives.
There is no need for MPI above the akcipher API anymore.
Modules can be verified with software as well as HW RSA implementations.

Patches generated against cryptodev-2.6
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
 crypto/asymmetric_keys/rsa.c              |  211 +++++++++++------------------
 crypto/asymmetric_keys/x509_cert_parser.c |   37 +----
 crypto/asymmetric_keys/x509_public_key.c  |   17 +-
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 -
 include/crypto/public_key.h               |   49 ++-----
 security/integrity/digsig_asymmetric.c    |   10 -
 13 files changed, 138 insertions(+), 315 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1

--
TS
