From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: rsa - fix invalid check for keylen in fips mode
Date: Mon, 20 Jul 2015 17:18:26 -0700
Message-ID: <20150721001826.24499.51560.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:21345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbbGUAS7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 20:18:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The condition checking allowed key length was invalid.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 3e8e0a9..8d96ce9 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -28,7 +28,7 @@ int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 		return -ENOMEM;
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->n) != 256 ||
+	if (fips_enabled && (mpi_get_size(key->n) != 256 &&
 			     mpi_get_size(key->n) != 384)) {
 		pr_err("RSA: key size not allowed in FIPS mode\n");
 		mpi_free(key->n);
@@ -62,7 +62,7 @@ int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 		return -ENOMEM;
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (mpi_get_size(key->d) != 256 ||
+	if (fips_enabled && (mpi_get_size(key->d) != 256 &&
 			     mpi_get_size(key->d) != 384)) {
 		pr_err("RSA: key size not allowed in FIPS mode\n");
 		mpi_free(key->d);
