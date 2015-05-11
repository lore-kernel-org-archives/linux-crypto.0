From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 22/24] crypto: qat - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:09 +0800
Message-ID: <E1YrkJl-0001G6-Gk@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42121 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbbEKJsN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:13 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJm-0000MD-LG
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:10 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qat/qat_common/qat_algs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 070abcd..dc231b8 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1094,8 +1094,9 @@ static int qat_alg_aead_init(struct crypto_tfm *tfm,
 		return -EFAULT;
 	spin_lock_init(&ctx->lock);
 	ctx->qat_hash_alg = hash;
-	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
-				sizeof(struct qat_crypto_request);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct aead_request) +
+		sizeof(struct qat_crypto_request));
 	ctx->tfm = tfm;
 	return 0;
 }
