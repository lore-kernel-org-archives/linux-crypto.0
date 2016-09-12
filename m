From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] crypto: squash lines for simple wrapper functions
Date: Tue, 13 Sep 2016 04:27:54 +0900
Message-ID: <1473708474-32359-1-git-send-email-yamada.masahiro@socionext.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove unneeded variables and assignments.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 crypto/crct10dif_generic.c |  5 +----
 crypto/mcryptd.c           |  7 +------
 drivers/crypto/hifn_795x.c | 12 ++----------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index c1229614..8e94e29 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -107,10 +107,7 @@ static struct shash_alg alg = {
 
 static int __init crct10dif_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_shash(&alg);
-	return ret;
+	return crypto_register_shash(&alg);
 }
 
 static void __exit crct10dif_mod_fini(void)
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 86fb59b..94ee44a 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -612,12 +612,7 @@ EXPORT_SYMBOL_GPL(mcryptd_alloc_ahash);
 
 int ahash_mcryptd_digest(struct ahash_request *desc)
 {
-	int err;
-
-	err = crypto_ahash_init(desc) ?:
-	      ahash_mcryptd_finup(desc);
-
-	return err;
+	return crypto_ahash_init(desc) ?: ahash_mcryptd_finup(desc);
 }
 
 int ahash_mcryptd_update(struct ahash_request *desc)
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index eee2c7e..e09d405 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -636,20 +636,12 @@ struct hifn_request_context {
 
 static inline u32 hifn_read_0(struct hifn_device *dev, u32 reg)
 {
-	u32 ret;
-
-	ret = readl(dev->bar[0] + reg);
-
-	return ret;
+	return readl(dev->bar[0] + reg);
 }
 
 static inline u32 hifn_read_1(struct hifn_device *dev, u32 reg)
 {
-	u32 ret;
-
-	ret = readl(dev->bar[1] + reg);
-
-	return ret;
+	return readl(dev->bar[1] + reg);
 }
 
 static inline void hifn_write_0(struct hifn_device *dev, u32 reg, u32 val)
-- 
1.9.1
