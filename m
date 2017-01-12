From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 4/6] crypto: simd - Add bulk request support
Date: Thu, 12 Jan 2017 13:59:56 +0100
Message-ID: <60721f64148bc1159c718d689dc356e8291f3dcc.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35264 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdALNAw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:52 -0500
Received: by mail-wj0-f194.google.com with SMTP id ey1so1788891wjd.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:51 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds proper support for the new bulk requests to the SIMD helpers.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/simd.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/crypto/simd.c b/crypto/simd.c
index 8820337..2ae5930 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -100,6 +100,64 @@ static int simd_skcipher_decrypt(struct skcipher_request *req)
 	return crypto_skcipher_decrypt(subreq);
 }
 
+static int simd_skcipher_encrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_bulk_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_bulk_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_skcipher_child(ctx->cryptd_tfm);
+
+	skcipher_bulk_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_encrypt_bulk(subreq);
+}
+
+static int simd_skcipher_decrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_bulk_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_bulk_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_skcipher_child(ctx->cryptd_tfm);
+
+	skcipher_bulk_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_decrypt_bulk(subreq);
+}
+
+static unsigned int simd_skcipher_reqsize_bulk(struct crypto_skcipher *tfm,
+					       unsigned int maxmsgs)
+{
+	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *tfm_cryptd, *tfm_child;
+	unsigned int reqsize_cryptd, reqsize_child;
+
+	tfm_cryptd = &ctx->cryptd_tfm->base;
+	tfm_child = cryptd_skcipher_child(ctx->cryptd_tfm);
+
+	reqsize_cryptd = crypto_skcipher_bulk_reqsize(tfm_cryptd, maxmsgs);
+	reqsize_child = crypto_skcipher_bulk_reqsize(tfm_child, maxmsgs);
+	return sizeof(struct skcipher_bulk_request) +
+			max(reqsize_cryptd, reqsize_child);
+}
+
 static void simd_skcipher_exit(struct crypto_skcipher *tfm)
 {
 	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -187,6 +245,9 @@ struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
 	alg->setkey = simd_skcipher_setkey;
 	alg->encrypt = simd_skcipher_encrypt;
 	alg->decrypt = simd_skcipher_decrypt;
+	alg->encrypt_bulk = simd_skcipher_encrypt_bulk;
+	alg->decrypt_bulk = simd_skcipher_decrypt_bulk;
+	alg->reqsize_bulk = simd_skcipher_reqsize_bulk;
 
 	err = crypto_register_skcipher(alg);
 	if (err)
-- 
2.9.3
