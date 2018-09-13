From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH 4/4] crypto: s5p-sss: Add aes-ctr support
Date: Thu, 13 Sep 2018 09:58:42 +0200
Message-ID: <20180913075901eucas1p2dfb1900b71d70ee64a9d51eb4c8b61fd~T5q-ljNj41220012200eucas1p2N@eucas1p2.samsung.com>
References: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180913075901eucas1p2dfb1900b71d70ee64a9d51eb4c8b61fd@eucas1p2.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add support for aes counter(ctr) block cipher mode of operation for
Exynos Hardware. In contrast to ecb and cbc modes, aes-ctr allows
encyption/decryption for request sizes not being a multiple of 16(bytes).

Hardware requires block sizes being a multiple of 16(bytes). In order to
achieve this, copy request source and destination memory, and align it's size
to 16. That way hardware processes additional bytes, that are omitted
when copying the result back to its original destination.

Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.19-rc2 with crypto
run-time self test testmgr and with tcrypt module:
insmod tcrypt.ko sec=1 mode=500.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 817a4b2b71e6..cfa104f6e468 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1814,7 +1814,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 };
 
 static void s5p_set_aes(struct s5p_aes_dev *dev,
-			const u8 *key, const u8 *iv,
+			const u8 *key, const u8 *iv, const u8 *ctr,
 			unsigned int keylen)
 {
 	void __iomem *keystart;
@@ -1822,6 +1822,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	if (iv)
 		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
+	if (ctr)
+		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_CNT_DATA(0), ctr, 0x10);
+
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
 	else if (keylen == AES_KEYSIZE_192)
@@ -1903,8 +1906,9 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	u32 aes_control;
 	unsigned long flags;
 	int err;
-	u8 *iv;
+	u8 *iv, *ctr;
 
+	/* This sets bit [13:12] to 00, which selects 128-bit counter */
 	aes_control = SSS_AES_KEY_CHANGE_MODE;
 	if (mode & FLAGS_AES_DECRYPT)
 		aes_control |= SSS_AES_MODE_DECRYPT;
@@ -1912,11 +1916,14 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CBC) {
 		aes_control |= SSS_AES_CHAIN_MODE_CBC;
 		iv = req->info;
+		ctr = NULL;
 	} else if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CTR) {
 		aes_control |= SSS_AES_CHAIN_MODE_CTR;
-		iv = req->info;
+		iv = NULL;
+		ctr = req->info;
 	} else {
 		iv = NULL; /* AES_ECB */
+		ctr = NULL;
 	}
 
 	if (dev->ctx->keylen == AES_KEYSIZE_192)
@@ -1948,7 +1955,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 		goto outdata_error;
 
 	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
-	s5p_set_aes(dev, dev->ctx->aes_key, iv, dev->ctx->keylen);
+	s5p_set_aes(dev, dev->ctx->aes_key, iv, ctr, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  dev->sg_src);
 	s5p_set_dma_outdata(dev, dev->sg_dst);
@@ -2026,7 +2033,8 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 	struct s5p_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	struct s5p_aes_dev *dev = ctx->dev;
 
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
+	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE) &&
+			((mode & FLAGS_AES_MODE_MASK) != FLAGS_AES_CTR)) {
 		dev_err(dev->dev, "request size is not exact amount of AES blocks\n");
 		return -EINVAL;
 	}
@@ -2073,6 +2081,11 @@ static int s5p_aes_cbc_decrypt(struct ablkcipher_request *req)
 	return s5p_aes_crypt(req, FLAGS_AES_DECRYPT | FLAGS_AES_CBC);
 }
 
+static int s5p_aes_ctr_crypt(struct ablkcipher_request *req)
+{
+	return s5p_aes_crypt(req, FLAGS_AES_CTR);
+}
+
 static int s5p_aes_cra_init(struct crypto_tfm *tfm)
 {
 	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -2127,6 +2140,28 @@ static struct crypto_alg algs[] = {
 			.decrypt	= s5p_aes_cbc_decrypt,
 		}
 	},
+	{
+		.cra_name		= "ctr(aes)",
+		.cra_driver_name	= "ctr-aes-s5p",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct s5p_aes_ctx),
+		.cra_alignmask		= 0x0f,
+		.cra_type		= &crypto_ablkcipher_type,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= s5p_aes_cra_init,
+		.cra_u.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= s5p_aes_setkey,
+			.encrypt	= s5p_aes_ctr_crypt,
+			.decrypt	= s5p_aes_ctr_crypt,
+		}
+	},
 };
 
 static int s5p_aes_probe(struct platform_device *pdev)
-- 
2.7.4
