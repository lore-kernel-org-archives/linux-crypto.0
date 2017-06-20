From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 20 Jun 2017 10:58:19 +0200
Message-ID: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
 maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The Security System have a PRNG, this patch add support for it via
crypto_rng.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/Kconfig                  |  8 +++++
 drivers/crypto/sunxi-ss/Makefile        |  1 +
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 30 ++++++++++++++++++
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 56 +++++++++++++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sun4i-ss.h      |  9 ++++++
 5 files changed, 104 insertions(+)
 create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-prng.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ab82536d64e2..bde0b102eb70 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -618,6 +618,14 @@ config CRYPTO_DEV_SUN4I_SS
 	  To compile this driver as a module, choose M here: the module
 	  will be called sun4i-ss.
 
+config CRYPTO_DEV_SUN4I_SS_PRNG
+	bool "Support for Allwinner Security System PRNG"
+	depends on CRYPTO_DEV_SUN4I_SS
+	select CRYPTO_RNG
+	help
+	  Select this option if you to provides kernel-side support for
+	  the Pseudo-Random Number Generator found in the Security System.
+
 config CRYPTO_DEV_ROCKCHIP
 	tristate "Rockchip's Cryptographic Engine driver"
 	depends on OF && ARCH_ROCKCHIP
diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
index 8f4c7a273141..ccb893219079 100644
--- a/drivers/crypto/sunxi-ss/Makefile
+++ b/drivers/crypto/sunxi-ss/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sun4i-ss.o
 sun4i-ss-y += sun4i-ss-core.o sun4i-ss-hash.o sun4i-ss-cipher.o
+sun4i-ss-$(CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG) += sun4i-ss-prng.o
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 02ad8256e900..d6bb2991c000 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -213,6 +213,23 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		}
 	}
 },
+#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
+{
+	.type = CRYPTO_ALG_TYPE_RNG,
+	.alg.rng = {
+		.base = {
+			.cra_name		= "stdrng",
+			.cra_driver_name	= "sun4i_ss_rng",
+			.cra_priority		= 300,
+			.cra_ctxsize		= 0,
+			.cra_module		= THIS_MODULE,
+		},
+		.generate               = sun4i_ss_prng_generate,
+		.seed                   = sun4i_ss_prng_seed,
+		.seedsize               = SS_SEED_LEN,
+	}
+},
+#endif
 };
 
 static int sun4i_ss_probe(struct platform_device *pdev)
@@ -355,6 +372,13 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 				goto error_alg;
 			}
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			err = crypto_register_rng(&ss_algs[i].alg.rng);
+			if (err) {
+				dev_err(ss->dev, "Fail to register %s\n",
+					ss_algs[i].alg.rng.base.cra_name);
+			}
+			break;
 		}
 	}
 	platform_set_drvdata(pdev, ss);
@@ -369,6 +393,9 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&ss_algs[i].alg.hash);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			crypto_unregister_rng(&ss_algs[i].alg.rng);
+			break;
 		}
 	}
 	if (ss->reset)
@@ -393,6 +420,9 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&ss_algs[i].alg.hash);
 			break;
+		case CRYPTO_ALG_TYPE_RNG:
+			crypto_unregister_rng(&ss_algs[i].alg.rng);
+			break;
 		}
 	}
 
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
new file mode 100644
index 000000000000..3941587def6b
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
@@ -0,0 +1,56 @@
+#include "sun4i-ss.h"
+
+int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
+		       unsigned int slen)
+{
+	struct sun4i_ss_alg_template *algt;
+	struct rng_alg *alg = crypto_rng_alg(tfm);
+
+	algt = container_of(alg, struct sun4i_ss_alg_template, alg.rng);
+	memcpy(algt->ss->seed, seed, slen);
+
+	return 0;
+}
+
+int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen)
+{
+	struct sun4i_ss_alg_template *algt;
+	struct rng_alg *alg = crypto_rng_alg(tfm);
+	int i;
+	u32 v;
+	u32 *data = (u32 *)dst;
+	const u32 mode = SS_OP_PRNG | SS_PRNG_CONTINUE | SS_ENABLED;
+	size_t len;
+	struct sun4i_ss_ctx *ss;
+	unsigned int todo = (dlen / 4) * 4;
+
+	algt = container_of(alg, struct sun4i_ss_alg_template, alg.rng);
+	ss = algt->ss;
+
+	spin_lock(&ss->slock);
+
+	writel(mode, ss->base + SS_CTL);
+
+	while (todo > 0) {
+		/* write the seed */
+		for (i = 0; i < SS_SEED_LEN / 4; i++)
+			writel(ss->seed[i], ss->base + SS_KEY0 + i * 4);
+
+		/* Read the random data */
+		len = min_t(size_t, SS_DATA_LEN, todo);
+		readsl(ss->base + SS_TXFIFO, data, len / 4);
+		data += len / 4;
+		todo -= len;
+
+		/* Update the seed */
+		for (i = 0; i < SS_SEED_LEN / 4; i++) {
+			v = readl(ss->base + SS_KEY0 + i * 4);
+			ss->seed[i] = v;
+		}
+	}
+
+	writel(0, ss->base + SS_CTL);
+	spin_unlock(&ss->slock);
+	return dlen;
+}
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index a0e1efc1cb2a..293632b1cf27 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -32,6 +32,7 @@
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/internal/rng.h>
+#include <crypto/rng.h>
 
 #define SS_CTL            0x00
 #define SS_KEY0           0x04
@@ -127,6 +128,9 @@
 #define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
 #define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
 
+#define SS_SEED_LEN (192 / 8)
+#define SS_DATA_LEN (160 / 8)
+
 struct sun4i_ss_ctx {
 	void __iomem *base;
 	int irq;
@@ -136,6 +140,7 @@ struct sun4i_ss_ctx {
 	struct device *dev;
 	struct resource *res;
 	spinlock_t slock; /* control the use of the device */
+	u32 seed[SS_SEED_LEN / 4];
 };
 
 struct sun4i_ss_alg_template {
@@ -144,6 +149,7 @@ struct sun4i_ss_alg_template {
 	union {
 		struct skcipher_alg crypto;
 		struct ahash_alg hash;
+		struct rng_alg rng;
 	} alg;
 	struct sun4i_ss_ctx *ss;
 };
@@ -201,3 +207,6 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen);
 int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen);
+int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int dlen);
+int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-- 
2.13.0
