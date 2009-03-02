From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: [WIP] crypto: add support for Orion5X crypto engine
Date: Mon, 2 Mar 2009 23:10:58 +0100
Message-ID: <20090302221058.GA11493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40482 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbZCBWLG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2009 17:11:06 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

This is my current status of an async crypto driver for the Orion5X crypto
unit. The driver uses the crypto accelerator. The data is copied via
memcpy() and will be replaced with idma once the infrastructure around
it is working. This patch depends on "arm/orion5x: add sram support for
crypto" posted earler to the arm ml [0].

The only functional part is ecb-aes in encryption mode. The decryption
seems to work in 16 byte key mode. According to the spec [1] the
decryption key is different and has to be computed by the HW.
Chapter 11.1.4 says, that the decryption key is computed by performing a
dummy encrypt operation. This does not alter my key at all. Point 1 on
the next side is referring to the AesKeyRdMode bit which must be set
prior reading the key. I can't find a definition of this bit so I guess
the spec is out of date here.
The register definition of the decryption unit has a bit called AesDecMakeKey.
Setting this bit alters the dec key after writing to it and reading it
back. The dummy decryption seems not to be required. However, with this key
the result of the decrypt operation does not match the expecting result.
The errata [2] in chapter 3.2 says that the computed key may be wrong. The
work around is to "write the first key twice". This did not help, so I must
have done it wrong. However if I write parts of the again I get
different results which are wrong.
However a SW calculation is also possible.
Chapter 11.1.4 in [1] says, that the decrypt key is the last 16/24/32 bytes
created by the expansion algorithm. So I picked the key expand routine
from generic aes module and just passed the crypto test for decryption
with a 16 byte long key. The other two key sizes failed. Probably the
the key slots are different. Currently I have no idea what's wrong.

[0] http://lists.arm.linux.org.uk/lurker/message/20090301.231447.6af0663c.en.html
[1] 88F5182, Doc. No. MV-S103345-01, Rev. C, April 29, 2008, Preliminary
[2] 88F5182, Doc. No. MV-S500802-00, Rev. E, April 29, 2008, Preliminary

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/Kconfig      |    9 +
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/mav_crypto.c |  578 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 588 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/mav_crypto.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 01afd75..514fe78 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -157,6 +157,15 @@ config S390_PRNG
 	  ANSI X9.17 standard. The PRNG is usable via the char device
 	  /dev/prandom.
 
+config CRYPTO_DEV_MARVELL_CRYPTO_ENGINE
+	tristate "Marvell's Cryptographic Engine"
+	depends on PLAT_ORION
+	select CRYPTO_ALGAPI
+	select CRYPTO_AES
+	help
+	  This driver allows you utilize the cryptographic engine which can be
+	  found on certain SoC like QNAP's TS-209.
+
 config CRYPTO_DEV_HIFN_795X
 	tristate "Driver HIFN 795x crypto accelerator chips"
 	select CRYPTO_DES
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 9bf4a2b..9c7053c 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_MARVELL_CRYPTO_ENGINE) += mav_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
diff --git a/drivers/crypto/mav_crypto.c b/drivers/crypto/mav_crypto.c
new file mode 100644
index 0000000..969edcf
--- /dev/null
+++ b/drivers/crypto/mav_crypto.c
@@ -0,0 +1,578 @@
+/*
+ * Support for Marvell's crypto engine which can be found on some Orion5X
+ * boards.
+ *
+ * Author: Sebastian Andrzej Siewior < sebastian at breakpoint dot cc >
+ * License: GPL
+ *
+ */
+#include <linux/io.h>
+#include <linux/crypto.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+
+struct crypto_priv {
+	void __iomem *reg;
+	void __iomem *sram;
+	wait_queue_head_t wq;
+	int irq;
+};
+
+static struct crypto_priv *cpg;
+
+static void reg_write(void __iomem *mem, u32 val)
+{
+	__raw_writel(val, mem);
+}
+
+static u32 reg_read(void __iomem *mem)
+{
+	return __raw_readl(mem);
+}
+
+#define DIGEST_INITIAL_VAL_A	0xdd00
+#define DES_CMD_REG		0xdd58
+
+#define SEC_ACCEL_CMD		0xde00
+#define SEC_CMD_EN_SEC_ACCL0	(1 << 0)
+#define SEC_CMD_EN_SEC_ACCL1	(1 << 1)
+#define SEC_CMD_DISABLE_SEC	(1 << 2)
+
+#define SEC_ACCEL_DESC_P0	0xde04
+#define SEC_DESC_P0_PTR(x)	(x)
+
+#define SEC_ACCEL_DESC_P1	0xde14
+#define SEC_DESC_P1_PTR(x)	(x)
+
+#define SEC_ACCEL_CFG		0xde08
+#define SEC_CFG_STOP_DIG_ERR	(1 << 0)
+#define SEC_CFG_CH0_W_IDMA	(1 << 7)
+#define SEC_CFG_CH1_W_IDMA	(1 << 8)
+#define SEC_CFG_ACT_CH0_IDMA	(1 << 9)
+#define SEC_CFG_ACT_CH1_IDMA	(1 << 10)
+
+#define SEC_ACCEL_STATUS	0xde0c
+#define SEC_ST_ACT_0		(1 << 0)
+#define SEC_ST_ACT_1		(1 << 1)
+
+
+#define SEC_ACCEL_INT_STATUS	0xde20
+#define SEC_INT_AUTH_DONE	(1 << 0)
+#define SEC_INT_DES_E_DONE	(1 << 1)
+#define SEC_INT_AES_E_DONE	(1 << 2)
+#define SEC_INT_AES_D_DONE	(1 << 3)
+#define SEC_INT_ENC_DONE	(1 << 4)
+#define SEC_INT_ACCEL0_DONE	(1 << 5)
+#define SEC_INT_ACCEL1_DONE	(1 << 6)
+#define SEC_INT_ACC0_IDMA_DONE	(1 << 7)
+#define SEC_INT_ACC1_IDMA_DONE	(1 << 8)
+
+#define SEC_ACCEL_INT_MASK	0xde24
+
+
+#define AES_KEY_LEN	(8 * 4)
+
+struct sec_accel_config {
+
+	u32 config;
+#define CFG_OP_MAC_ONLY		(0)
+#define CFG_OP_CRYPT_ONLY	(1)
+#define CFG_OP_MAC_CRYPT	(2)
+#define CFG_OP_CRYPT_MAC	(3)
+#define CFG_MACM_MD5		(4 << 4)
+#define CFG_MACM_SHA1		(5 << 4)
+#define CFG_MACM_HMAC_MD5	(6 << 4)
+#define CFG_MACM_HMAC_SHA1	(7 << 4)
+#define CFG_ENCM_DES		(1 << 8)
+#define CFG_ENCM_3DES		(2 << 8)
+#define CFG_ENCM_AES		(3 << 8)
+#define CFG_DIR_ENC		(0 << 12)
+#define CFG_DIR_DEC		(1 << 12)
+#define CFG_ENC_MODE_ECB	(0 << 16)
+#define CFG_ENC_MODE_CBC	(1 << 16)
+#define CFG_3DES_EEE		(0 << 20)
+#define CFG_3DES_EDE		(1 << 20)
+#define CFG_AES_LEN_128		(0 << 24)
+#define CFG_AES_LEN_192		(1 << 24)
+#define CFG_AES_LEN_256		(2 << 24)
+
+	u32 enc_p;
+#define ENC_P_SRC(x)		(x)
+#define ENC_P_DST(x)		((x) << 16)
+
+	u32 enc_len;
+#define ENC_LEN(x)		(x)
+
+	u32 enc_key_p;
+#define ENC_KEY_P(x)		(x)
+
+	u32 enc_iv;
+#define ENC_IV_BUF_POINT(x)	((x) << 16)
+
+	u32 mac_src_p;
+#define MAC_SRC_DATA_P(x)	(x)
+#define MAC_SRC_TOTAL_LEN(x)	((x) << 16)
+
+	u32 mac_digest;
+	u32 mac_iv;
+}__attribute__ ((packed));
+
+struct mav_ctx {
+	struct sec_accel_config op;
+	u8 aes_key[AES_KEY_LEN];
+	u32 key_columns[8];
+	u32 key_out[8];
+	int key_len;
+	int hw_key_len;
+	u32 need_calc_dec_key;
+};
+
+static void hex_dump(unsigned char *info, unsigned char *buf, unsigned int len)
+{
+	printk(KERN_ERR "%s\n", info);
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			buf, len, false);
+	printk(KERN_CONT "\n");
+}
+
+#define CRYPTOE_AES_E_DATA0		0xddac
+#define CRYPTOE_AES_E_DATA1		0xdda8
+#define CRYPTOE_AES_E_DATA2		0xdda4
+#define CRYPTOE_AES_E_DATA3		0xdda0
+
+#define CRYPTOE_AES_E_KEY0		0xdd9c
+#define CRYPTOE_AES_E_KEY1		0xdd98
+#define CRYPTOE_AES_E_KEY2		0xdd94
+#define CRYPTOE_AES_E_KEY3		0xdd90
+#define CRYPTOE_AES_E_KEY4		0xdd8c
+#define CRYPTOE_AES_E_KEY5		0xdd88
+#define CRYPTOE_AES_E_KEY6		0xdd84
+#define CRYPTOE_AES_E_KEY7		0xdd80
+
+#define CRYPTOE_AES_D_DATA0		0xddec
+#define CRYPTOE_AES_D_DATA1		0xdde8
+#define CRYPTOE_AES_D_DATA2		0xdde4
+#define CRYPTOE_AES_D_DATA3		0xdde0
+
+#define CRYPTOE_AES_D_KEY0		0xdddc
+#define CRYPTOE_AES_D_KEY1		0xddd8
+#define CRYPTOE_AES_D_KEY2		0xddd4
+#define CRYPTOE_AES_D_KEY3		0xddd0
+#define CRYPTOE_AES_D_KEY4		0xddcc
+#define CRYPTOE_AES_D_KEY5		0xddc8
+#define CRYPTOE_AES_D_KEY6		0xddc4
+#define CRYPTOE_AES_D_KEY7		0xddc0
+
+#define CRYPTOE_AES_ECMD		0xddb0
+
+#define CRYPTOE_AES_DCMD		0xddf0
+#define CRYPTOE_AES_CMD_LEN_128		(0 << 0)
+#define CRYPTOE_AES_CMD_LEN_192		(1 << 0)
+#define CRYPTOE_AES_CMD_LEN_256		(2 << 0)
+#define CRYPTOE_AES_DCMD_MAKE_D_KEY	(1 << 2)
+#define CRYPTOE_AES_CMD_READY		(1 << 31)
+static int compute_hw_dec_key(struct mav_ctx *ctx)
+{
+	struct crypto_aes_ctx gen_aes_key;
+	int timeout = 5;
+	int status;
+	int i;
+	int ret;
+	int dec_key_start;
+
+	if (!ctx->need_calc_dec_key)
+		return 0;
+#if 0
+#if 0
+	reg_write(cpg->reg + CRYPTOE_AES_DCMD, ctx->hw_key_len);
+
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY0, ctx->key_columns[0]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY1, ctx->key_columns[1]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY2, ctx->key_columns[2]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY3, ctx->key_columns[3]);
+
+#endif
+	reg_write(cpg->reg + CRYPTOE_AES_DCMD, ctx->hw_key_len | CRYPTOE_AES_DCMD_MAKE_D_KEY);
+
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY0, ctx->key_columns[0]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY1, ctx->key_columns[1]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY2, ctx->key_columns[2]);
+	reg_write(cpg->reg + CRYPTOE_AES_D_KEY3, ctx->key_columns[3]);
+
+	if (ctx->key_len >= AES_KEYSIZE_192) {
+		reg_write(cpg->reg + CRYPTOE_AES_D_KEY4, ctx->key_columns[4]);
+		reg_write(cpg->reg + CRYPTOE_AES_D_KEY5, ctx->key_columns[5]);
+	}
+
+	if (ctx->key_len > AES_KEYSIZE_192) {
+		reg_write(cpg->reg + CRYPTOE_AES_D_KEY6, ctx->key_columns[6]);
+		reg_write(cpg->reg + CRYPTOE_AES_D_KEY7, ctx->key_columns[7]);
+	}
+
+#if 1
+	reg_write(cpg->reg + CRYPTOE_AES_D_DATA0, 0);
+	reg_write(cpg->reg + CRYPTOE_AES_D_DATA1, 0);
+	reg_write(cpg->reg + CRYPTOE_AES_D_DATA2, 0);
+	reg_write(cpg->reg + CRYPTOE_AES_D_DATA3, 0);
+
+	do {
+		status = reg_read(cpg->reg + CRYPTOE_AES_DCMD);
+		if (status & CRYPTOE_AES_CMD_READY)
+			break;
+		timeout--;
+		if (!timeout)
+			break;
+		ndelay(1);
+	} while (1);
+
+	if (!timeout) {
+		printk(KERN_ERR "dec key not computed %d.\n", i);
+		return -ETIMEDOUT;
+#endif
+	}
+
+	ctx->key_out[0] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY0);
+	ctx->key_out[1] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY1);
+	ctx->key_out[2] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY2);
+	ctx->key_out[3] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY3);
+	if (ctx->key_len >= AES_KEYSIZE_192) {
+		ctx->key_out[4] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY4);
+		ctx->key_out[5] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY5);
+	}
+	if (ctx->key_len > AES_KEYSIZE_192) {
+		ctx->key_out[6] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY6);
+		ctx->key_out[7] = reg_read(cpg->reg + CRYPTOE_AES_D_KEY7);
+	}
+
+	hex_dump("Key in : ", (unsigned char *)&ctx->key_columns[0], 8 * 4);
+	hex_dump("Key out: ", (unsigned char *)&ctx->key_out[0], 8 * 4);
+#endif
+
+	ctx->need_calc_dec_key = 0;
+	memset(&gen_aes_key, 0, sizeof(gen_aes_key));
+	ret = crypto_aes_expand_key(&gen_aes_key, ctx->key_columns, ctx->key_len);
+	if (ret < 0) {
+		printk(KERN_ERR "Crap: %d\n", ret);
+		return -ETIMEDOUT;
+	}
+
+	/* XXX 16byte key do work, the other two don't */
+	switch (ctx->key_len) {
+	case AES_KEYSIZE_128:
+		dec_key_start = ctx->key_len + 24;
+		break;
+	case AES_KEYSIZE_192:
+		dec_key_start = ctx->key_len + 24;
+		break;
+	case AES_KEYSIZE_256:
+		dec_key_start = ctx->key_len + 20;
+		break;
+	default:
+		return -EINVAL;
+	}
+	memcpy(ctx->key_out, &gen_aes_key.key_enc[dec_key_start], 8 * 4);
+	hex_dump("Key enc:  ", (unsigned char *)gen_aes_key.key_enc, AES_MAX_KEYLENGTH);
+	hex_dump("Key dec:  ", (unsigned char *)gen_aes_key.key_dec, AES_MAX_KEYLENGTH);
+	hex_dump("The copy: ", (unsigned char *)ctx->key_out, 8 * 4);
+	return 0;
+}
+
+static int mav_setkey_aes_ecb(struct crypto_ablkcipher *cipher, const u8 *key,
+		unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct mav_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	printk(KERN_ERR "%s() keylen: %d\n", __func__, len);
+	ctx->op.config = CFG_OP_CRYPT_ONLY | CFG_ENCM_AES | CFG_ENC_MODE_ECB;
+
+	switch (len) {
+		case AES_KEYSIZE_128:
+			ctx->op.config |= CFG_AES_LEN_128;
+			ctx->hw_key_len = CRYPTOE_AES_CMD_LEN_128;
+			break;
+
+		case AES_KEYSIZE_192:
+			ctx->op.config |= CFG_AES_LEN_192;
+			ctx->hw_key_len = CRYPTOE_AES_CMD_LEN_192;
+			break;
+
+		case AES_KEYSIZE_256:
+			ctx->op.config |= CFG_AES_LEN_256;
+			ctx->hw_key_len = CRYPTOE_AES_CMD_LEN_256;
+			break;
+		default:
+			crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+			return -EINVAL;
+	}
+	ctx->key_len = len;
+	ctx->need_calc_dec_key = 1;
+
+	memcpy(ctx->aes_key, key, AES_KEY_LEN);
+	memcpy(ctx->key_columns, key, AES_KEY_LEN);
+	hex_dump("Key #1: ", ctx->aes_key, AES_KEY_LEN);
+	return 0;
+}
+
+static void mav_exec_aes_crypt(struct ablkcipher_request *req, int dec_key)
+{
+	struct mav_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	signed long time_out;
+	void *src_p;
+	void *dst_p;
+	DEFINE_WAIT(wait);
+
+	printk(KERN_ERR "%s()\n", __func__);
+	src_p = sg_virt(req->src);
+	dst_p = sg_virt(req->dst);
+	/*
+	 * currently just POC and that means:
+	 * - data is copied via memcpy() into SRAM and back
+	 * - the SG list may have only one entry
+	 * - we must not be called from ATOMIC context
+	 * - request len must be <= 4066 bytes
+	 */
+	BUG_ON(!src_p);
+	BUG_ON(!dst_p);
+	BUG_ON(req->src->length != req->nbytes);
+	BUG_ON(req->nbytes > 4066);
+
+	prepare_to_wait(&cpg->wq, &wait, TASK_INTERRUPTIBLE);
+
+	/*
+	 * /-----------\ 0
+	 * | ACCEL CFG |	4 * 8
+	 * |-----------| 0x20
+	 * | CRYPT KEY |	8 * 4
+	 * |-----------| 0x40
+	 * |  DATA IN  |	16 * x
+	 * |-----------| 0x40 (inplace operation)
+	 * |  DATA OUT |	16 * x
+	 * \-----------/
+	 */
+#define SRAM_CONFIG		(0x00)
+#define SRAM_DATA_KEY_P		(0x20)
+#define SRAM_DATA_IN_START	(0x40)
+#define SRAM_DATA_OUT_START	(0x40)
+
+	ctx->op.enc_p = ENC_P_SRC(SRAM_DATA_IN_START) |
+		ENC_P_DST(SRAM_DATA_OUT_START);
+	ctx->op.enc_key_p = SRAM_DATA_KEY_P;
+	ctx->op.enc_len = req->nbytes;
+
+	memcpy(cpg->sram + SRAM_CONFIG, &ctx->op,
+			sizeof(struct sec_accel_config));
+	memcpy(cpg->sram + SRAM_DATA_IN_START, src_p, req->nbytes);
+	if (dec_key)
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->key_out, AES_KEY_LEN);
+	else
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_key, AES_KEY_LEN);
+
+	hex_dump("KEY: #2", cpg->sram + SRAM_DATA_KEY_P, AES_KEY_LEN);
+	hex_dump("SRC: #1", cpg->sram + SRAM_DATA_IN_START, req->nbytes);
+	hex_dump("DST: #1 ", cpg->sram + SRAM_DATA_OUT_START, req->nbytes);
+
+	reg_write(cpg->reg + SEC_ACCEL_DESC_P0, SRAM_CONFIG);
+	reg_write(cpg->reg + SEC_ACCEL_INT_MASK, SEC_INT_ACCEL0_DONE);
+	reg_write(cpg->reg + SEC_ACCEL_CMD, SEC_CMD_EN_SEC_ACCL0);
+
+	time_out = schedule_timeout(HZ * 5);
+	if (!time_out)
+		printk(KERN_ERR "Timeout occured, no interrupt :/\n");
+
+	hex_dump("DST: #2 ", cpg->sram + SRAM_DATA_OUT_START, req->nbytes);
+	memcpy(dst_p, cpg->sram + SRAM_DATA_OUT_START, req->nbytes);
+	finish_wait(&cpg->wq, &wait);
+	printk(KERN_ERR "%s() done\n", __func__);
+}
+
+static int mav_enc_aes_ecb(struct ablkcipher_request *req)
+{
+	struct mav_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
+	printk(KERN_ERR "%s()\n", __func__);
+	ctx->op.config &= ~CFG_DIR_DEC;
+	ctx->op.config |= CFG_DIR_ENC;
+
+	mav_exec_aes_crypt(req, 0);
+	return 0;
+}
+
+static int mav_dec_aes_ecb(struct ablkcipher_request *req)
+{
+	struct mav_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
+	printk(KERN_ERR "%s()\n", __func__);
+	compute_hw_dec_key(ctx);
+
+	ctx->op.config &= ~CFG_DIR_ENC;
+	ctx->op.config |= CFG_DIR_DEC;
+
+	mav_exec_aes_crypt(req, 1);
+	return 0;
+}
+
+static int mav_cra_init(struct crypto_tfm *tfm)
+{
+
+	printk(KERN_ERR "%s()\n", __func__);
+	return 0;
+}
+
+irqreturn_t crypto_int(int irq, void *priv)
+{
+	struct crypto_priv *cp = priv;
+	u32 val;
+
+	val = reg_read(cpg->reg + SEC_ACCEL_INT_STATUS);
+	printk(KERN_ERR "%s() %08x\n", __func__, val);
+	reg_write(cpg->reg + SEC_ACCEL_INT_MASK, 0);
+	if (!(val & SEC_INT_ACCEL0_DONE))
+		return IRQ_NONE;
+	wake_up(&cpg->wq);
+
+	return IRQ_HANDLED;
+}
+
+struct crypto_alg mav_aes_alg = {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "mav-ecb-aes",
+	.cra_priority	= 300,
+	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize	= 16,
+	.cra_ctxsize	= sizeof(struct mav_ctx),
+	.cra_alignmask	= 7,
+	.cra_type	= &crypto_ablkcipher_type,
+	.cra_module	= THIS_MODULE,
+	.cra_init	= mav_cra_init,
+	.cra_u		= {
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	mav_setkey_aes_ecb,
+			.encrypt	=	mav_enc_aes_ecb,
+			.decrypt	=	mav_dec_aes_ecb,
+		},
+	},
+};
+
+static int m_probe(struct platform_device *pdev)
+{
+	struct crypto_priv *cp;
+	struct resource *res;
+	int irq;
+	int ret;
+
+	if (cpg) {
+		printk(KERN_ERR "Second crypto dev?\n");
+		return -EBUSY;
+	}
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	if (!res)
+		return -ENODEV;
+
+	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	init_waitqueue_head(&cp->wq);
+	printk(KERN_ERR "regs @%x\n", res->start);
+	cp->reg = ioremap(res->start, res->end - res->start + 1);
+	if (!cp->reg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	printk(KERN_ERR "regs remap @%p\n", cp->reg);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
+	if (!res) {
+		ret = -ENODEV;
+		goto err_unmap_reg;
+	}
+	printk(KERN_ERR "sram @%x\n", res->start);
+
+	cp->sram = ioremap(res->start, res->end - res->start + 1);
+	if (!cp->sram) {
+		ret = -ENOMEM;
+		goto err_unmap_reg;
+	}
+
+	memset(cp->sram, 0, 8 * 1024);
+	printk(KERN_ERR "sram remap @%p\n", cp->sram);
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0 || irq == NO_IRQ) {
+		ret = irq;
+		goto err_unmap_sram;
+	}
+	cp->irq = irq;
+
+	ret = request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->dev), cp);
+	if (ret)
+		goto err_unmap_sram;
+
+	platform_set_drvdata(pdev, cp);
+	cpg = cp;
+
+	ret = crypto_register_alg(&mav_aes_alg);
+	if (ret) {
+		printk(KERN_ERR "Reg of algo failed: %d\n", ret);
+		goto err_reg;
+	}
+	return 0;
+err_reg:
+	free_irq(irq, cp);
+err_unmap_sram:
+	iounmap(cp->sram);
+err_unmap_reg:
+	iounmap(cp->reg);
+err:
+	kfree(cp);
+	cpg = NULL;
+	platform_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+static int m_remove(struct platform_device *pdev)
+{
+	struct crypto_priv *cp = platform_get_drvdata(pdev);
+
+	crypto_unregister_alg(&mav_aes_alg);
+	free_irq(cp->irq, cp);
+	iounmap(cp->sram);
+	iounmap(cp->reg);
+	kfree(cp);
+	cpg = NULL;
+	return 0;
+}
+
+static struct platform_driver marvell_crypto = {
+	.probe          = m_probe,
+	.remove         = m_remove,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mav,orion5x-crypto",
+	},
+};
+
+static int __init crypto_init(void)
+{
+	return platform_driver_register(&marvell_crypto);
+}
+module_init(crypto_init);
+
+static void __exit crypto_exit(void)
+{
+	platform_driver_unregister(&marvell_crypto);
+}
+
+module_exit(crypto_exit);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior <sebastian@breakpoint.cc>");
+MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
+MODULE_LICENSE("GPL");
-- 
1.6.0.6

