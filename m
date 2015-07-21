From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix invalid check for RSA keylen in fips mode
Date: Mon, 20 Jul 2015 17:18:27 -0700
Message-ID: <20150721001827.24523.30789.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:15932 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbbGUATB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 20:19:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The condition checking allowed key length was invalid.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 13a76a0..557a740 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -443,7 +443,7 @@ int qat_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	ctx->key_sz = vlen;
 	ret = -EINVAL;
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (ctx->key_sz != 256 || ctx->key_sz != 384)) {
+	if (fips_enabled && (ctx->key_sz != 256 && ctx->key_sz != 384)) {
 		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
 		goto err;
 	}
@@ -510,7 +510,7 @@ int qat_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
 		goto err;
 
 	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (vlen != 256 || vlen != 384)) {
+	if (fips_enabled && (vlen != 256 && vlen != 384)) {
 		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
 		goto err;
 	}
