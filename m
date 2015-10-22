From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/4] crypto: hifn_795x: remove the hifn_test function
Date: Thu, 22 Oct 2015 08:51:50 +0200
Message-ID: <1445496712-5654-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445496712-5654-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The hifn_test function is redundant with test done at register time by
the crypto API, so remove it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/hifn_795x.c | 58 ----------------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 079b995..e6bc825 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1650,60 +1650,6 @@ err_out_exit:
 	return err;
 }
 
-static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
-{
-	int n, err;
-	u8 src[16];
-	struct hifn_context ctx;
-	struct hifn_request_context rctx;
-	u8 fips_aes_ecb_from_zero[16] = {
-		0x66, 0xE9, 0x4B, 0xD4,
-		0xEF, 0x8A, 0x2C, 0x3B,
-		0x88, 0x4C, 0xFA, 0x59,
-		0xCA, 0x34, 0x2B, 0x2E};
-	struct scatterlist sg;
-
-	memset(src, 0, sizeof(src));
-	memset(ctx.key, 0, sizeof(ctx.key));
-
-	ctx.dev = dev;
-	ctx.keysize = 16;
-	rctx.ivsize = 0;
-	rctx.iv = NULL;
-	rctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
-	rctx.mode = ACRYPTO_MODE_ECB;
-	rctx.type = ACRYPTO_TYPE_AES_128;
-	rctx.walk.cache[0].length = 0;
-
-	sg_init_one(&sg, &src, sizeof(src));
-
-	err = hifn_setup_dma(dev, &ctx, &rctx, &sg, &sg, sizeof(src), NULL);
-	if (err)
-		goto err_out;
-
-	dev->started = 0;
-	msleep(200);
-
-	dprintk("%s: decoded: ", dev->name);
-	for (n=0; n<sizeof(src); ++n)
-		dprintk("%02x ", src[n]);
-	dprintk("\n");
-	dprintk("%s: FIPS   : ", dev->name);
-	for (n=0; n<sizeof(fips_aes_ecb_from_zero); ++n)
-		dprintk("%02x ", fips_aes_ecb_from_zero[n]);
-	dprintk("\n");
-
-	if (!memcmp(src, fips_aes_ecb_from_zero, sizeof(fips_aes_ecb_from_zero))) {
-		printk(KERN_INFO "%s: AES 128 ECB test has been successfully "
-				"passed.\n", dev->name);
-		return 0;
-	}
-
-err_out:
-	printk(KERN_INFO "%s: AES 128 ECB test has been failed.\n", dev->name);
-	return -1;
-}
-
 static int hifn_start_device(struct hifn_device *dev)
 {
 	int err;
@@ -2658,10 +2604,6 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_out_free_irq;
 
-	err = hifn_test(dev, 1, 0);
-	if (err)
-		goto err_out_stop_device;
-
 	err = hifn_register_rng(dev);
 	if (err)
 		goto err_out_stop_device;
-- 
2.4.10
