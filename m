From: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: [RFC PATCH] crypto: Alchemy AES engine driver
Date: Thu,  6 May 2010 17:50:45 +0200
Message-ID: <1273161045-21945-1-git-send-email-manuel.lauss@gmail.com>
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
	Manuel Lauss <manuel.lauss@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:57898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab0EFPuu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 May 2010 11:50:50 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2265627fgg.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 May 2010 08:50:48 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver for the AES engine in ECB and CBC modes found on some
Alchemy Au1200/Au1300 SoCs.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---

lightly "tested" with the tcrypt module on Au1200;  I have no idea whether
it really works correctly:

# modprobe alchemy-aes
alg: skcipher: setkey failed on test 2 for ecb-aes-alchemy: flags=200000
# modprobe tcrypt mode=10
alg: skcipher: setkey failed on test 3 for cbc-aes-alchemy: flags=0
alg: skcipher: Failed to load transform for cbc(aes): -2
alg: skcipher: Failed to load transform for cbc(aes): -2
tcrypt: one or more tests failed!
FATAL: Error inserting tcrypt (/lib/modules/2.6.34-rc6-db1200-00214-g9f84af9/kernel/crypto/tcrypt.ko): Unknown symbol in module, or unknown parameter (see dmesg)

The error in "test 3 for cbc-aes-alchemy" probably comes from the inability
to process keys larger than 128 bits.

Please have a look.
 Thanks!

 drivers/crypto/Kconfig       |    8 +
 drivers/crypto/Makefile      |    1 +
 drivers/crypto/alchemy-aes.c |  579 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 588 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/alchemy-aes.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b08403d..7705b13 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -222,4 +222,12 @@ config CRYPTO_DEV_PPC4XX
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
+config CRYPTO_DEV_ALCHEMY_AES
+	tristate "Au1200/Au1300 AES engine"
+	depends on MACH_ALCHEMY
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  Driver for the AES engine in Alchemy Au1200/Au1300 series SoCs.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6ffcb3f..624777f 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
+obj-$(CONFIG_CRYPTO_DEV_ALCHEMY_AES) += alchemy-aes.o
diff --git a/drivers/crypto/alchemy-aes.c b/drivers/crypto/alchemy-aes.c
new file mode 100644
index 0000000..14e8ace
--- /dev/null
+++ b/drivers/crypto/alchemy-aes.c
@@ -0,0 +1,579 @@
+/*
+ * alchemy-aes.c -- Driver for the Alchemy Au1200/Au1300 AES engine.
+ *
+ * (c) 2010 Manuel Lauss <manuel.lauss@gmail.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/resource.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+
+#include <asm/mach-au1x00/au1000.h>
+#include <asm/mach-au1x00/au1xxx_dbdma.h>
+
+/*#define DEBUG*/
+
+#ifdef DEBUG
+#define DBG(x...) printk(KERN_ALERT "AES: " x)
+#define DBGHEX(x...)	print_hex_dump(x)
+#else
+#define DBG(x...)
+#define DBGHEX(x...)
+#endif
+
+#define DRVNAME	"alchemy-aes"
+
+/* the AES engine likes the number 16 */
+#define ALCHEMY_AES_KEY_SIZE	16
+#define ALCHEMY_AES_IV_SIZE	16
+#define ALCHEMY_AES_BLK_SIZE	16
+#define ALCHEMY_AES_DDMA_DSCRS	16
+
+/* register offsets */
+#define AES_STATUS	0x00
+#define AES_INDATA	0x04
+#define AES_OUTDATA	0x08
+#define AES_INTCAUSE	0x0c
+#define AES_CONFIG	0x10
+
+#define AES_S_PS	0x01	/* start crypto */
+#define AES_S_IE	0x02	/* int enable */
+#define AES_S_CR_1	0x00	/* periph. clock  */
+#define AES_S_CR_2	0x04	/* periph. clock div 2 */
+#define AES_S_CR_4	0x08	/* periph. clock div 4 */
+#define AES_S_CR_8	0x0c	/* periph. clock div 8 */
+#define AES_S_CR_MASK	0x0c
+#define AES_S_OUT	0x10	/* set if out fifo has space */
+#define AES_S_IN	0x20	/* set if in fifo has space */
+
+#define AES_CAUSE_RDY	0x01	/* process complete */
+#define AES_CAUSE_OVR	0x02	/* in fifo overflow */
+#define AES_CAUSE_UND	0x04	/* out fifo underflow */
+
+#define AES_C_ED	0x01	/* set to DE/clear to ENcrypt */
+#define AES_C_IKG	0x02	/* do internal key generation */
+#define AES_C_RPK	0x04	/* replay key (output 10th key) */
+#define AES_C_RK	0x08	/* reuse internal key store */
+#define AES_C_UC	0x10	/* undefined block count */
+#define AES_C_OP_ECB	0x00
+#define AES_C_OP_CBC	0x20
+#define AES_C_OP_CFB	0x40
+#define AES_C_OP_OFB	0x60
+#define AES_C_OP_MASK	0x60
+
+
+struct alchemy_aes_priv {
+	void __iomem *base;
+	int irq;
+
+	/* dbdma */
+	u32 dmatx;
+	u32 dmarx;
+	int txid;
+	int rxid;
+
+	unsigned char key[ALCHEMY_AES_KEY_SIZE];
+
+	struct completion done;
+	struct list_head alg_list;
+	struct resource *ioarea;
+};
+
+/* need to improvise to stash private data */
+struct alchemy_aes_alg {
+	struct crypto_alg alg;
+	struct alchemy_aes_priv *priv;
+	struct list_head entry;
+};
+
+#define crypto_alg_to_alchemy(a) \
+	container_of(a, struct alchemy_aes_alg, alg)
+
+
+/* 8 bit memory device */
+static dbdev_tab_t alchemy_aes_mem_dbdev = {
+	.dev_id		= DSCR_CMD0_ALWAYS,
+	.dev_flags	= DEV_FLAGS_ANYUSE,
+	.dev_tsize	= 0,
+	.dev_devwidth	= 8,
+	.dev_physaddr	= 0x00000000,
+	.dev_intlevel	= 0,
+	.dev_intpolarity = 0,
+};
+static int __alchemy_aes_memid;
+
+/**********************************************************************/
+
+static inline void aes_write(struct alchemy_aes_priv *p, int reg,
+			     unsigned long val)
+{
+	__raw_writel(val, p->base + reg);
+}
+
+static inline unsigned long aes_read(struct alchemy_aes_priv *p, int reg)
+{
+	return __raw_readl(p->base + reg);
+}
+
+static inline void aes_infifo_write(struct alchemy_aes_priv *p,
+				    unsigned long data)
+{
+	/* poll for open space */
+	while (!(aes_read(p, AES_STATUS) & AES_S_IN))
+		cpu_relax();
+	aes_write(p, AES_INDATA, data);
+}
+
+/**********************************************************************/
+
+static void alchemy_aes_dmacb(int irq, void *data)
+{
+	struct alchemy_aes_priv *p = data;
+
+	au1xxx_dbdma_stop(p->dmarx);
+	au1xxx_dbdma_stop(p->dmatx);
+
+	complete(&p->done);
+}
+
+static irqreturn_t alchemy_aes_irq(int irq, void *data)
+{
+	struct alchemy_aes_priv *p = data;
+	unsigned long istat;
+
+	istat = aes_read(p, AES_INTCAUSE);
+	aes_write(p, AES_INTCAUSE, 0);
+
+	if (istat & AES_CAUSE_RDY)
+		complete(&p->done);
+	/* fifo over/underruns shouldn't happen with DMA */
+
+	return IRQ_HANDLED;
+}
+
+/**********************************************************************/
+
+static int alchemy_aes_crypt(struct blkcipher_desc *desc,
+			     struct scatterlist *sdst,
+			     struct scatterlist *ssrc,
+			     unsigned int nbytes,
+			     unsigned long cryptmode)
+{
+	struct crypto_alg *alg = desc->tfm->base.__crt_alg;
+	struct alchemy_aes_alg *aa = crypto_alg_to_alchemy(alg);
+	struct alchemy_aes_priv *p = aa->priv;
+	struct blkcipher_walk walk;
+	int ret, i, blks, len;
+	unsigned long k;
+	dma_addr_t src, dst;
+	unsigned char *iv;
+
+	DBG("crypt: ALG %s base %p nbytes %d mode %08lx\n",
+	    alg->cra_name, p->base, nbytes, cryptmode);
+
+	blkcipher_walk_init(&walk, sdst, ssrc, nbytes);
+	ret = blkcipher_walk_virt(desc, &walk);
+	iv = walk.iv;
+
+	/* create DMA descriptor lists */
+	i = blks = 0;
+	au1xxx_dbdma_reset(p->dmatx);
+	au1xxx_dbdma_reset(p->dmarx);
+	while ((nbytes = walk.nbytes)) {
+		src = (dma_addr_t)virt_to_phys(walk.src.virt.addr);
+		dst = (dma_addr_t)virt_to_phys(walk.dst.virt.addr);
+
+		blks += nbytes / ALCHEMY_AES_BLK_SIZE;
+		len = nbytes - (nbytes % ALCHEMY_AES_BLK_SIZE);
+
+		DBG("SRC %p DST %p bytes %d blks %d dscr %d len %d\n",
+		    (void *)src, (void *)dst, nbytes, blks, i, len);
+		DBGHEX(KERN_ERR, "AES DATA ", 0, 16, 1, walk.src.virt.addr,
+		       len, false);
+
+		nbytes -= len;
+		ret = blkcipher_walk_done(desc, &walk, nbytes);
+
+		/* let DBDMA interrupt when last block of data has been
+		 * fetched from AES output fifo.
+		 */
+		au1xxx_dbdma_put_dest(p->dmarx, dst, len,
+				      walk.nbytes ? 0 : DDMA_FLAGS_IE);
+		au1xxx_dbdma_put_source(p->dmatx, src, len, 0);
+
+		if (++i > ALCHEMY_AES_DDMA_DSCRS) {
+			ret = -ENOMEM;
+			printk(KERN_ERR DRVNAME ": DMA descriptor limit"
+				" reached!\n");
+			goto out;
+		}
+	}
+
+	/* drain output fifo, clear interrupts, configure and enable */
+	init_completion(&p->done);
+	for (i = 0; i < 8; i++)
+		k = aes_read(p, AES_OUTDATA);
+	aes_write(p, AES_INTCAUSE, 0);
+	aes_write(p, AES_CONFIG, cryptmode);
+	aes_write(p, AES_STATUS, AES_S_PS | AES_S_IE);	/* start engine */
+
+	/* block count comes first */
+	if (!(cryptmode & AES_C_UC)) {
+		DBG("BLKCNT %d\n", blks);
+		aes_infifo_write(p, blks);
+	}
+
+	/* then new key if necessary */
+	if (!(cryptmode & AES_C_RK)) {
+		DBGHEX(KERN_ERR, "AES: KEY ", 0, 16, 1, p->key, 16, false);
+
+		k = (p->key[0] << 24) | (p->key[1] << 16) |
+		    (p->key[2] <<  8) |  p->key[3];
+		aes_infifo_write(p, k);
+		k = (p->key[4] << 24) | (p->key[5] << 16) |
+		    (p->key[6] <<  8) |  p->key[7];
+		aes_infifo_write(p, k);
+		k = (p->key[8]  << 24) | (p->key[9]  << 16) |
+		    (p->key[10] <<  8) |  p->key[11];
+		aes_infifo_write(p, k);
+		k = (p->key[12] << 24) | (p->key[13] << 16) |
+		    (p->key[14] <<  8) |  p->key[15];
+		aes_infifo_write(p, k);
+	}
+
+	/* then IV for non-ECB modes */
+	if ((cryptmode & AES_C_OP_MASK) != AES_C_OP_ECB) {
+		DBGHEX(KERN_ERR, "AES: IV  ", 0, 16, 1, iv, 16, false);
+
+		k = (iv[0] << 24) | (iv[1] << 16) |
+		    (iv[2] <<  8) |  iv[3];
+		aes_infifo_write(p, k);
+		k = (iv[4] << 24) | (iv[5] << 16) |
+		    (iv[6] <<  8) |  iv[7];
+		aes_infifo_write(p, k);
+		k = (iv[8]  << 24) | (iv[9]  << 16) |
+		    (iv[10] <<  8) |  iv[11];
+		aes_infifo_write(p, k);
+		k = (iv[12] << 24) | (iv[13] << 16) |
+		    (iv[14] <<  8) |  iv[15];
+		aes_infifo_write(p, k);
+	}
+
+	/* DMA engine does data transfer */
+	au1xxx_dbdma_start(p->dmarx);
+	au1xxx_dbdma_start(p->dmatx);
+	ret = wait_for_completion_interruptible(&p->done);
+
+out:
+	aes_write(p, AES_STATUS, 0);
+	au1xxx_dbdma_stop(p->dmatx);
+	au1xxx_dbdma_stop(p->dmarx);
+
+	/* read replayed key if necessary */
+	if ((!ret) && ((cryptmode & AES_C_OP_MASK) == AES_C_OP_ECB) &&
+	    (cryptmode & (AES_C_ED | AES_C_RPK)) &&
+	    (!(cryptmode & AES_C_UC))) {
+		k = aes_read(p, AES_OUTDATA);
+		k = aes_read(p, AES_OUTDATA);
+		k = aes_read(p, AES_OUTDATA);
+		k = aes_read(p, AES_OUTDATA);
+		/* FIXME: does cryptoapi acutally want it? */
+	}
+
+	return ret;
+}
+
+static int alchemy_aes_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int len)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct alchemy_aes_alg *aa = crypto_alg_to_alchemy(alg);
+	struct alchemy_aes_priv *p = aa->priv;
+
+	DBGHEX(KERN_ERR, "AES: SETKEY ", 0, 16, 1, key, len, false);
+
+	if (len != AES_KEYSIZE_128) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	memcpy(p->key, key, ALCHEMY_AES_KEY_SIZE);
+	return 0;
+}
+
+static int alchemy_aes_ecb_enc(struct blkcipher_desc *desc,
+			       struct scatterlist *dst,
+			       struct scatterlist *src,
+			       unsigned int nbytes)
+{
+	return alchemy_aes_crypt(desc, dst, src, nbytes,
+				 AES_C_OP_ECB);
+}
+
+static int alchemy_aes_ecb_dec(struct blkcipher_desc *desc,
+			       struct scatterlist *dst,
+			       struct scatterlist *src,
+			       unsigned int nbytes)
+{
+	return alchemy_aes_crypt(desc, dst, src, nbytes,
+				 AES_C_OP_ECB | AES_C_ED);
+}
+
+static struct crypto_alg alchemy_aes_ecb_alg = {
+	.cra_name		=	"ecb(aes)",
+	.cra_driver_name	=	"ecb-aes-alchemy",
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= ALCHEMY_AES_KEY_SIZE,
+			.max_keysize	= ALCHEMY_AES_KEY_SIZE,
+			.setkey		= alchemy_aes_setkey,
+			.encrypt	= alchemy_aes_ecb_enc,
+			.decrypt	= alchemy_aes_ecb_dec,
+		},
+	},
+};
+
+static int alchemy_aes_cbc_enc(struct blkcipher_desc *desc,
+			       struct scatterlist *dst,
+			       struct scatterlist *src,
+			       unsigned int nbytes)
+{
+	return alchemy_aes_crypt(desc, dst, src, nbytes,
+				 AES_C_OP_CBC);
+}
+
+static int alchemy_aes_cbc_dec(struct blkcipher_desc *desc,
+			       struct scatterlist *dst,
+			       struct scatterlist *src,
+			       unsigned int nbytes)
+{
+	return alchemy_aes_crypt(desc, dst, src, nbytes,
+				 AES_C_OP_CBC | AES_C_ED);
+}
+
+static struct crypto_alg alchemy_aes_cbc_alg = {
+	.cra_name		=	"cbc(aes)",
+	.cra_driver_name	=	"cbc-aes-alchemy",
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= ALCHEMY_AES_KEY_SIZE,
+			.max_keysize	= ALCHEMY_AES_KEY_SIZE,
+			.ivsize		= ALCHEMY_AES_IV_SIZE,
+			.setkey		= alchemy_aes_setkey,
+			.encrypt	= alchemy_aes_cbc_enc,
+			.decrypt	= alchemy_aes_cbc_dec,
+		},
+	},
+};
+
+static int __init add_algo(struct alchemy_aes_priv *p,
+			   struct crypto_alg *calg)
+{
+	struct alchemy_aes_alg *alg;
+	int ret;
+
+	alg = kzalloc(sizeof(struct alchemy_aes_alg), GFP_KERNEL);
+	if (!alg)
+		return -ENOMEM;
+
+	alg->priv = p;
+	alg->alg.cra_priority = 300;
+	alg->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->alg.cra_blocksize = ALCHEMY_AES_BLK_SIZE;
+	alg->alg.cra_ctxsize = 0;
+	alg->alg.cra_alignmask = 3;
+	alg->alg.cra_type = &crypto_blkcipher_type;
+	alg->alg.cra_module = THIS_MODULE;
+	INIT_LIST_HEAD(&alg->alg.cra_list);
+	alg->alg.cra_u.blkcipher = calg->cra_u.blkcipher;
+	sprintf(alg->alg.cra_name, "%s", calg->cra_name);
+	sprintf(alg->alg.cra_driver_name, "%s", calg->cra_driver_name);
+
+	list_add_tail(&alg->entry, &p->alg_list);
+
+	ret = crypto_register_alg(&alg->alg);
+	if (ret) {
+		list_del(&alg->entry);
+		kfree(alg);
+	}
+	return ret;
+}
+
+static void delete_algos(struct alchemy_aes_priv *p)
+{
+	struct alchemy_aes_alg *a, *n;
+
+	list_for_each_entry_safe(a, n, &p->alg_list, entry) {
+		list_del(&a->entry);
+		crypto_unregister_alg(&a->alg);
+		kfree(a);
+	}
+}
+
+static int __init alchemy_aes_probe(struct platform_device *pdev)
+{
+	struct resource *r;
+	struct alchemy_aes_priv *p;
+	int ret;
+
+	p = kzalloc(sizeof(struct alchemy_aes_priv), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	ret = -ENODEV;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		goto out1;
+
+	p->ioarea = request_mem_region(r->start, resource_size(r),
+					DRVNAME);
+	if (!p->ioarea)
+		goto out1;
+
+	p->base = ioremap_nocache(r->start, resource_size(r));
+	if (!p->base)
+		goto out2;
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!r)
+		goto out3;
+	p->irq = r->start;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_DMA, "dmatx");
+	if (!r) {
+		r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+		if (!r)
+			goto out3;
+	}
+	p->txid = r->start;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_DMA, "dmarx");
+	if (!r) {
+		r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+		if (!r)
+			goto out3;
+	}
+	p->rxid = r->start;
+
+	p->dmatx = au1xxx_dbdma_chan_alloc(__alchemy_aes_memid, p->txid,
+					    alchemy_aes_dmacb, p);
+	if (!p->dmatx)
+		goto out3;
+
+	p->dmarx = au1xxx_dbdma_chan_alloc(p->rxid, __alchemy_aes_memid,
+					    alchemy_aes_dmacb, p);
+	if (!p->dmarx)
+		goto out4;
+
+	au1xxx_dbdma_ring_alloc(p->dmatx, ALCHEMY_AES_DDMA_DSCRS);
+	au1xxx_dbdma_ring_alloc(p->dmarx, ALCHEMY_AES_DDMA_DSCRS);
+
+	aes_write(p, AES_STATUS, 0);
+	aes_write(p, AES_CONFIG, 0);
+	aes_write(p, AES_INTCAUSE, 0);
+
+	ret = request_irq(p->irq, alchemy_aes_irq, IRQF_DISABLED,
+			  DRVNAME, p);
+	if (ret)
+		goto out5;
+
+	INIT_LIST_HEAD(&p->alg_list);
+
+	ret = add_algo(p, &alchemy_aes_ecb_alg);
+	if (ret)
+		goto out6;
+
+	ret = add_algo(p, &alchemy_aes_cbc_alg);
+	if (ret)
+		goto out6;
+
+	platform_set_drvdata(pdev, p);
+	return 0;
+
+out6:
+	delete_algos(p);
+	free_irq(p->irq, p);
+out5:
+	au1xxx_dbdma_chan_free(p->dmarx);
+out4:
+	au1xxx_dbdma_chan_free(p->dmatx);
+out3:
+	iounmap(p->base);
+out2:
+	release_resource(p->ioarea);
+	kfree(p->ioarea);
+out1:
+	kfree(p);
+	return ret;
+}
+
+static int __exit alchemy_aes_remove(struct platform_device *pdev)
+{
+	struct alchemy_aes_priv *p = platform_get_drvdata(pdev);
+
+	delete_algos(p);
+
+	au1xxx_dbdma_stop(p->dmatx);
+	au1xxx_dbdma_stop(p->dmarx);
+
+	aes_write(p, AES_STATUS, 0);
+	aes_write(p, AES_CONFIG, 0);
+	aes_write(p, AES_INTCAUSE, 0);
+
+	free_irq(p->irq, p);
+	au1xxx_dbdma_chan_free(p->dmarx);
+	au1xxx_dbdma_chan_free(p->dmatx);
+	iounmap(p->base);
+	release_resource(p->ioarea);
+	kfree(p->ioarea);
+	kfree(p);
+
+	return 0;
+}
+
+static struct platform_driver alchemy_aes_driver = {
+	.driver.name	= DRVNAME,
+	.driver.owner	= THIS_MODULE,
+	.probe		= alchemy_aes_probe,
+	.remove		= __devexit_p(alchemy_aes_remove),
+};
+
+static int __init alchemy_aes_load(void)
+{
+	/* FIXME: hier sollte auch noch der PRId des prozessors getestet
+	 * werden; Au1210 (0x0503xxxx) und einige Au1300 haben lt. Daten-
+	 * blatt keine AES engine.
+	 */
+
+	/* need to do 8bit accesses to memory to get correct data */
+	__alchemy_aes_memid = au1xxx_ddma_add_device(&alchemy_aes_mem_dbdev);
+	if (!__alchemy_aes_memid)
+		return -ENODEV;
+
+	return platform_driver_register(&alchemy_aes_driver);
+}
+
+static void __exit alchemy_aes_unload(void)
+{
+	if (__alchemy_aes_memid)
+		au1xxx_ddma_del_device(__alchemy_aes_memid);
+	platform_driver_unregister(&alchemy_aes_driver);
+}
+
+module_init(alchemy_aes_load);
+module_exit(alchemy_aes_unload);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Alchemy Au1200 AES engine driver");
+MODULE_AUTHOR("Manuel Lauss <manuel.lauss@gmail.com>");
-- 
1.7.0.4

