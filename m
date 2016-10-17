From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: gcm - Fix error return code in crypto_gcm_create_common()
Date: Mon, 17 Oct 2016 15:10:06 +0000
Message-ID: <1476717006-10086-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33284 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753104AbcJQPKW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 11:10:22 -0400
Received: by mail-pa0-f68.google.com with SMTP id hh10so9340745pac.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2016 08:10:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -EINVAL from the invalid alg ivsize error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 crypto/gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index f624ac9..39c261d 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -672,11 +672,11 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
 	/* We only support 16-byte blocks. */
+	err = -EINVAL;
 	if (crypto_skcipher_alg_ivsize(ctr) != 16)
 		goto out_put_ctr;
 
 	/* Not a stream cipher? */
-	err = -EINVAL;
 	if (ctr->base.cra_blocksize != 1)
 		goto out_put_ctr;
