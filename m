From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: rsa-pkcs1pad: Replace GFP_ATOMIC with GFP_KERNEL in pkcs1pad_encrypt_sign_complete
Date: Thu, 25 Jan 2018 17:57:54 +0800
Message-ID: <1516874274-11851-1-git-send-email-baijiaju1990@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:37190 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbeAYJxZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jan 2018 04:53:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

After checking all possible call chains to kzalloc here,
my tool finds that this kzalloc is never called in atomic context.
Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 crypto/rsa-pkcs1pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 2908f93..9893dbf 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -192,7 +192,7 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	if (likely(!pad_len))
 		goto out;
 
-	out_buf = kzalloc(ctx->key_size, GFP_ATOMIC);
+	out_buf = kzalloc(ctx->key_size, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!out_buf)
 		goto out;
-- 
1.7.9.5
