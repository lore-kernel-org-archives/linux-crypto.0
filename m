From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] crypto: sun4i-ss: mark sun4i_hash() static
Date: Sun, 18 Sep 2016 20:52:44 +0800
Message-ID: <1474203164-14884-1-git-send-email-baoyou.xie@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn
To: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
