From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] crypto: sunxi-ss: mark sun4i_hash() static
Date: Sat, 24 Sep 2016 12:28:46 +0800
Message-ID: <1474691326-15541-1-git-send-email-baoyou.xie@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn
To: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34229 "EHLO
        mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcIXE3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Sep 2016 00:29:01 -0400
Received: by mail-pa0-f52.google.com with SMTP id wk8so45840675pab.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2016 21:29:01 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/crypto/sunxi-ss/sun4i-ss-hash.c:168:5: warning: no previous prototype for 'sun4i_hash' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
So this patch marks it 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 1afeb8e..0de2f62 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -165,7 +165,7 @@ int sun4i_hash_import_sha1(struct ahash_request *areq, const void *in)
  * write remaining data in op->buf
  * final state op->len=56
  */
-int sun4i_hash(struct ahash_request *areq)
+static int sun4i_hash(struct ahash_request *areq)
 {
 	u32 v, ivmode = 0;
 	unsigned int i = 0;
-- 
2.7.4
