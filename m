From: Marc St-Jean <stjeanma@pmc-sierra.com>
Subject: [PATCH 12/12] drivers: PMC MSP71xx security engine driver
Date: Thu, 14 Jun 2007 16:12:53 -0600
Message-ID: <200706142212.l5EMCrc7024809@pasqua.pmc-sierra.bc.ca>
Cc: linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-mips-bounce@linux-mips.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-Id: linux-crypto.vger.kernel.org

[PATCH 12/12] drivers: PMC MSP71xx security engine driver

Patch to add an security engien driver for the PMC-Sierra MSP71xx devices.

Thanks,
Marc

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
---
First post of patch.

 crypto/Kconfig              |   40 
 crypto/Makefile             |    8 
 drivers/crypto/Kconfig      |   18 
 drivers/crypto/Makefile     |    1 
 drivers/crypto/pmcmsp_sec.c | 2456 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 2519 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 086fcec..33bdec6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -68,12 +68,32 @@ config CRYPTO_MD5
 	help
 	  MD5 message digest algorithm (RFC1321).
 
+config CRYPTO_MD5_HW
+	tristate
+	default n
+
+config CRYPTO_MD5_SW
+	tristate
+	default y if (CRYPTO_MD5_HW = n && CRYPTO_MD5 = y)
+	default m if ((CRYPTO_MD5_HW = m || CRYPTO_MD5_HW = n) && \
+			CRYPTO_MD5 = m)
+
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_ALGAPI
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
+config CRYPTO_SHA1_HW
+	tristate
+	default n
+
+config CRYPTO_SHA1_SW
+	tristate
+	default y if (CRYPTO_SHA1_HW = n && CRYPTO_SHA1 = y)
+	default m if ((CRYPTO_SHA1_HW = m || CRYPTO_SHA1_HW = n) && \
+			CRYPTO_SHA1 = m)
+
 config CRYPTO_SHA256
 	tristate "SHA256 digest algorithm"
 	select CRYPTO_ALGAPI
@@ -177,6 +197,16 @@ config CRYPTO_DES
 	help
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
 
+config CRYPTO_DES_HW
+	tristate
+	default n
+
+config CRYPTO_DES_SW
+	tristate
+	default y if (CRYPTO_DES_HW = n && CRYPTO_DES = y)
+	default m if ((CRYPTO_DES_HW = m || CRYPTO_DES_HW = n) && \
+			CRYPTO_DES = m)
+
 config CRYPTO_FCRYPT
 	tristate "FCrypt cipher algorithm"
 	select CRYPTO_ALGAPI
@@ -283,6 +313,16 @@ config CRYPTO_AES
 
 	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
 
+config CRYPTO_AES_HW
+	tristate
+	default n
+
+config CRYPTO_AES_SW
+	tristate
+	default y if (CRYPTO_AES_HW = n && CRYPTO_AES = y)
+	default m if ((CRYPTO_AES_HW = m || CRYPTO_AES_HW = n) && \
+			CRYPTO_AES = m)
+
 config CRYPTO_AES_586
 	tristate "AES cipher algorithms (i586)"
 	depends on (X86 || UML_X86) && !64BIT
diff --git a/crypto/Makefile b/crypto/Makefile
index 12f93f5..b337967 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -17,8 +17,8 @@ obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
-obj-$(CONFIG_CRYPTO_MD4) += md4.o
-obj-$(CONFIG_CRYPTO_MD5) += md5.o
+obj-$(CONFIG_CRYPTO_MD5_SW) += md5.o
+obj-$(CONFIG_CRYPTO_SHA1_SW) += sha1.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
@@ -29,13 +29,13 @@ obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
-obj-$(CONFIG_CRYPTO_DES) += des.o
+obj-$(CONFIG_CRYPTO_DES_SW) += des.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
-obj-$(CONFIG_CRYPTO_AES) += aes.o
+obj-$(CONFIG_CRYPTO_AES_SW) += aes.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ff8c4be..bbda463 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -66,4 +66,22 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
+config CRYPTO_PMCMSP
+	tristate "Support for PMCMSP on-chip IPSEC engine"
+	depends on CRYPTO && PMC_MSP
+
+config CRYPTO_PMCMSP_CIPHER
+	bool "Accelerate ciphers (AES, DES, 3DES)"
+	depends on CRYPTO_PMCMSP
+	default y
+	select CRYPTO_AES_HW
+	select CRYPTO_DES_HW
+
+config CRYPTO_PMCMSP_HASH
+	bool "Accelerate hashes (MD5, SHA1)"
+	depends on CRYPTO_PMCMSP
+	default y
+	select CRYPTO_MD5_HW
+	select CRYPTO_SHA1_HW
+
 endmenu
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6059cf8..aa6fdc4 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
+obj-$(CONFIG_CRYPTO_PMCMSP) += pmcmsp_sec.o
diff --git a/drivers/crypto/pmcmsp_sec.c b/drivers/crypto/pmcmsp_sec.c
new file mode 100644
index 0000000..b522101
--- /dev/null
+++ b/drivers/crypto/pmcmsp_sec.c
@@ -0,0 +1,2456 @@
+/*
+ * PMC-Sierra MSP security engine driver for linux
+ *
+ * Copyright 2000-2007 PMC-Sierra, Inc
+ *
+ * Driver for use with second, newer version of PMC security engine.
+ * Implements the Crypto API for aes, des, des3, md5 and sha1.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ * WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ * NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ * USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the  GNU General Public License along
+ * with this program; if not, write  to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+
+#include <crypto/algapi.h>
+
+#include <msp_regs.h>
+#include <msp_regops.h>
+#include <msp_int.h>
+#include <msp_prom.h>
+
+/**************************************************************************
+ * Constants
+ */
+
+/* switches to turn on manual debug features - normally off */
+/* #define DEBUG */
+/* #define DEBUG_VERBOSE */
+/* #define DUMP_WQ_ENTRIES */
+/* #define DUMP_SA */
+/* #define DUMP_CQ_ENTRIES */
+
+#define PREFIX			"pmcmcsp_sec: "
+
+/* SoC Reset registers */
+#define MSPRST_STS		0x00
+#define MSPRST_SET		0x04
+#define MSPRST_CLR		0x08
+
+/* Random Number Generator registers */
+#define SEC_RNG_CNF		0x084
+#define SEC_RNG_VAL		0x094
+
+/* Security Engine registers */
+#define SEC2_REG		0x200
+
+/* number of hardware queues */
+#define HW_NR_WORK_QUEUES	2
+#define HW_NR_COMP_QUEUES	2
+
+/* flags field values for SA struct */
+#define SAFLG_MODE_MASK		0x7
+#define SAFLG_MODE_ESP_IN	0
+#define SAFLG_MODE_ESP_OUT	1
+#define SAFLG_MODE_HMAC		2
+#define SAFLG_MODE_HASH_PAD	3
+#define SAFLG_MODE_HASH		4
+#define SAFLG_MODE_CRYPT	5
+
+#define SAFLG_SI		0x80	/* increment sequence number */
+#define SAFLG_CRI		0x100	/* Create IV */
+#define SAFLG_CPI		0x200	/* Compare ICV */
+#define SAFLG_EM		0x400	/* ESP Manual Mode */
+#define SAFLG_CV		0x800	/* Use Chaining Variables */
+
+#define SAFLG_HASH_MASK		0xe000
+#define SAFLG_MD5_96		0x0000
+#define SAFLG_MD5		0x2000
+#define SAFLG_SHA1_96		0x4000
+#define SAFLG_SHA1		0x6000
+#define SAFLG_HASHNULL		0x8000
+
+#define SAFLG_KEYS_MASK		0x70000
+#define SAFLG_DES_K1_DECRYPT	0x10000
+#define SAFLG_DES_K2_DECRYPT	0x20000
+#define SAFLG_DES_K3_DECRYPT	0x40000
+
+#define SAFLG_AES_DECRYPT	SAFLG_DES_K1_DECRYPT
+#define SAFLG_AES_ENCRYPT	0
+#define SAFLG_DES_DECRYPT	SAFLG_DES_K1_DECRYPT
+#define SAFLG_DES_ENCRYPT	0
+#define SAFLG_EDE_ENCRYPT	(SAFLG_DES_K2_DECRYPT)
+#define SAFLG_EDE_DECRYPT	(SAFLG_DES_K1_DECRYPT | SAFLG_DES_K3_DECRYPT)
+
+#define SAFLG_BLK_MASK		0x380000
+#define SAFLG_ECB		0
+#define SAFLG_CTR		0x080000
+#define SAFLG_CBC_ENCRYPT	0x100000
+#define SAFLG_CBC_DECRYPT	0x180000
+#define SAFLG_CFB_ENCRYPT	0x200000
+#define SAFLG_CFB_DECRYPT	0x280000
+#define SAFLG_OFB		0x300000
+
+#define SAFLG_CRYPT_TYPE_MASK	0x1C00000
+#define SAFLG_DES		0
+#define SAFLG_DES3		0x0400000
+#define SAFLG_AES_128		0x0800000
+#define SAFLG_AES_192		0x0C00000
+#define SAFLG_AES_256		0x1000000
+#define SAFLG_CRYPTNULL		0x1400000
+
+/* control word */
+#define SEC2_WE_CTRL_SZ		0x0ff
+#define SEC2_WE_CTRL_CQ		0x100
+#define SEC2_WE_CTRL_GI		0x800
+#define SEC2_WE_CTRL_AKO	0x8000
+#define SEC2_WE_CTRL_NXTHDR_SHF	16
+#define SEC2_WE_CTRL_PADLEN_SHF	24
+
+/* scatter/gather flags */
+#define SEC2_WE_SG_SCATTER	0x80000000
+#define SEC2_WE_SG_SOP		0x40000000
+#define SEC2_WE_SG_EOD		0x20000000
+#define SEC2_WE_SG_EOP		0x10000000
+#define SEC2_WE_SG_SIZE		0x00001FFF
+
+/* queue sizes must be powers of two */
+#define SEC_WORK_Q_SIZE		256
+#define SEC_WORK_Q_MASK		(SEC_WORK_Q_SIZE - 1)
+#define SEC_COMP_Q_SIZE		512
+#define SEC_COMP_Q_MASK		(SEC_COMP_Q_SIZE - 1)
+
+#define WQE_MAGIC	0x11223344/* use to validate work element */
+#define CQE_SIZE	(4 * 4)	/* size completion element in bytes */
+#define WQE_MAX_BUF	16	/* max number of scatter/gather bufs */
+#define WQE_HDR_SIZE	4	/* size of work desc header in words */
+#define WQE_DESC_SIZE(sg_count)		(WQE_HDR_SIZE + ((sg_count) * 2))
+				/* work descriptor size in words */
+#define WQE_DESC_SIZE_BYTES(sg_count)	(WQE_DESC_SIZE(sg_count) << 2)
+				/* work descriptor size in bytes */
+#define WQE_LAST	1	/* signals last scatter/gather buffer */
+#define WQE_SLEEP	1	/* sleep while waiting for completion */
+#define WQE_POLL	0	/* poll while waiting for completion */
+
+/* crypt directions and modes */
+#define CRYPT_DIRECTION_ENCRYPT	0x00000000
+#define CRYPT_DIRECTION_DECRYPT	0x00000001
+
+#define CRYPTO_TFM_MODE_OTHER	0x00000000
+#define CRYPTO_TFM_MODE_ECB	0x00000001
+#define CRYPTO_TFM_MODE_CBC	0x00000002
+
+/**************************************************************************
+ * Structures
+ */
+
+/*
+ * Requests to the hardware are placed in a "work queue".
+ * indications of completion are placed in a "completion queue".
+ *
+ * This structure describes the hardware's picture of a queue.
+ */
+struct sec2_q_regs {
+	/*
+	 * The registers live across a bus; shadow the registers
+	 * whenever possible, access them only when necessary.
+	 */
+	unsigned int	*ofst_ptr;	/* Hardware writes a copy of the in
+					 * or out register to the location
+					 * pointed to by this register (out
+					 * for work queue, in for completion
+					 * queue). Software uses this as a
+					 * shadow of register in main mem.
+					 */
+
+	unsigned int	avail;	/* space available in queue */
+
+	unsigned char	*base;	/* base address of queue
+				 * Must be aligned on the boundary
+				 * of the size of the buffer.
+				 * i.e. base & (size-1) == 0
+				 */
+	unsigned int	size;	/* size of buffer */
+	unsigned int	in;	/* offset of in address */
+				/* actual in is at base + in */
+	unsigned int	out;	/* offset of head address */
+				/* actual out is at base + out */
+};
+
+struct sec2_regs {
+	unsigned int		res1[5];
+
+	unsigned int		sis;	/* Solo Interupt Status */
+
+				#define SEC2_INT_CQ0		0x000001
+				#define SEC2_INT_CQ1		0x000002
+				#define SEC2_INT_BAD_ADDR	0x000004
+				#define SEC2_INT_HASH_NON_64	0x000008
+				#define SEC2_INT_DES_NON_8	0x000010
+				#define SEC2_INT_AES_NON_16	0x000020
+				#define SEC2_INT_WQ0_HIGH	0x000040
+				#define SEC2_INT_WQ1_HIGH	0x000080
+				#define SEC2_INT_CQ0_HIGH	0x000100
+				#define SEC2_INT_CQ1_HIGH	0x000200
+				#define SEC2_INT_WQ0_FULL	0x000400
+				#define SEC2_INT_WQ1_FULL	0x000800
+				#define SEC2_INT_CQ0_FULL	0x001000
+				#define SEC2_INT_CQ1_FULL	0x002000
+				#define SEC2_INT_WQ0_EMPTY	0x004000
+				#define SEC2_INT_WQ1_EMPTY	0x008000
+				#define SEC2_INT_CQ0_EMPTY	0x010000
+				#define SEC2_INT_CQ1_EMPTY	0x020000
+				#define SEC2_INT_BAD_GATHER	0x040000
+				#define SEC2_INT_ICV_COMP_ERR	0x080000
+				#define SEC2_INT_MBX_ENABLE	0x100000
+				#define SEC2_INT_OFFSET_ERR	0x10000000
+				#define SEC2_INT_GS_BALANCE_ERR	0x20000000
+				#define SEC2_INT_EOD_MARK_ERR	0x40000000
+
+	unsigned int		esr;	/* Engine Status Register */
+
+				#define SEC2_ESR_DMA_IDLE	0x01
+				#define SEC2_ESR_DMA_DONE	0x02
+				#define SEC2_ESR_HASH_IDLE	0x04
+				#define SEC2_ESR_HASH_DONE	0x08
+				#define SEC2_ESR_DES_IDLE	0x10
+				#define SEC2_ESR_DES_DONE	0x20
+				#define SEC2_ESR_AES_IDLE	0x40
+				#define SEC2_ESR_AES_DONE	0x80
+
+	unsigned int		ier;	/* Interrupt Enable Register */
+
+				/*
+				 * ier uses same bits as sis
+				 */
+
+	unsigned int		res2[3];
+	unsigned int		rst;	/* Reset Register */
+
+				#define SEC2_RST_DMA		0x01
+				#define SEC2_RST_HASH		0x02
+				#define SEC2_RST_DES		0x04
+				#define SEC2_RST_AES		0x08
+				#define SEC2_RST_MASTER		0x0F
+
+	unsigned int		res3;
+	struct sec2_q_regs	wq[2];	/* work queues */
+	struct sec2_q_regs	cq[2];	/* completion queues */
+	unsigned int		dwpd;	/* "Duet Write Protection Disable" */
+	unsigned int		sget;	/* "SRAM GSE End Tag" */
+	unsigned int		aesc[4];/* AES Counter mode Counter */
+	unsigned int		aesk[8];/* AES Last Expanded Key */
+};
+
+/* security association structure */
+struct sec2_sa {
+	unsigned int		flags;
+	unsigned int		esp_spi;
+	unsigned int		esp_sequence;
+	unsigned int		hash_chain_a[5];
+	unsigned int		crypt_keys[8];
+	unsigned int		hash_chain_b[5];
+	unsigned int		hash_init_len[2];
+	unsigned int		crypt_iv[4];
+	unsigned int		proto_ip[5];
+};
+
+/* local state structures maintained by Crypto API */
+struct msp_crypto {
+	struct sec2_sa		sa;
+	struct sec2_sa		aes_decrypt_sa;
+	struct sec2_sa		des_decrypt_sa;
+	unsigned int		keysize;
+};
+
+/* local state structures maintained by Crypto API */
+struct msp_hash {
+	struct sec2_sa		sa;
+	unsigned int		resultsize;
+	u8			*data;
+	unsigned int		data_size;
+	int			data_needs_free;
+};
+
+/* local structure used to control work queue */
+struct workq {
+	volatile struct sec2_q_regs *wq_regs;
+				/* ptr to hw regs for this queue */
+	unsigned char		*base;
+				/* ptr to slowpath base of queue */
+	dma_addr_t		base_dma_addr;
+				/* dma bus address of base of queue */
+	unsigned int		in;
+				/* new desc written at this offset */
+	wait_queue_head_t	space_wait;
+				/* tasks waiting to write into queue */
+	unsigned int		low_water;
+				/* when avail space reaches this, wake tasks */
+};
+
+/* local structure used to control completion queue */
+struct compq {
+	volatile struct sec2_q_regs *cq_regs;
+				/* ptr to hw regs for this queue */
+	unsigned char		*base;
+				/* ptr to slowpath base of queue */
+	dma_addr_t		base_dma_addr;
+				/* dma bus address of queue */
+	unsigned int		out;
+				/* new desc read from this offset */
+};
+
+/* scatter/gather info */
+struct scat_gath {
+	unsigned int		ctrl;	/* buffer control flags */
+	dma_addr_t		buf_dma_addr;
+				/* bus address of scatter/gather buffer */
+};
+
+/*
+ * Local structure used to control work descriptor while being
+ * processed by engine.
+ */
+struct desc_tent {
+	unsigned int		magic;
+				/* used to confirm really is a desc_tent */
+
+	/* temporary variables used while building work element */
+	unsigned int		is_first;
+				/* set if first gather or scatter */
+	unsigned int		do_eod_correction;
+				/* set if EOD must be 2nd to last */
+	unsigned int		ctrl;
+				/* work element control flags */
+
+	/* dma addresses needed to do dma_unmap when done */
+	dma_addr_t		sa_dma_addr;	/* bus address of SA */
+	unsigned int		sg_count;	/* count of sg buffers */
+	struct scat_gath	sg[WQE_MAX_BUF];/* list of buffers */
+
+	/* info needed to sleep or poll on result */
+	unsigned int		sleep;
+				/* set to sleep, clear to poll */
+	wait_queue_head_t	wait_q;
+				/* for waiting on completion queue */
+	volatile unsigned int	event_happened;
+				/* set wait is over */
+
+	/* completion status read from IPSEC engine. 0 if success */
+	volatile unsigned int	comp_status;
+};
+
+/**************************************************************************
+ * Private functions
+ */
+
+static int msp_crypto_setkey(struct crypto_tfm *tfm,
+				const u8 *key, unsigned int key_len);
+static void msp_crypto_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
+static int msp_crypto_ecb_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes);
+static int msp_crypto_cbc_encrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes);
+static void msp_crypto_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
+static int msp_crypto_ecb_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes);
+static int msp_crypto_cbc_decrypt(struct blkcipher_desc *desc,
+		       struct scatterlist *dst, struct scatterlist *src,
+		       unsigned int nbytes);
+
+static void msp_crypto_md5_init(struct crypto_tfm *tfm);
+static void msp_crypto_md5_update(struct crypto_tfm *tfm,
+				const u8 *data, unsigned int len);
+static void msp_crypto_md5_final(struct crypto_tfm *tfm, u8 *out);
+
+static void msp_crypto_sha1_init(struct crypto_tfm *tfm);
+static void msp_crypto_sha1_update(struct crypto_tfm *tfm,
+				const u8 *data, unsigned int len);
+static void msp_crypto_sha1_final(struct crypto_tfm *tfm, u8 *out);
+
+static irqreturn_t msp_secv2_interrupt(int irq, void *dev_id);
+static void msp_sec2_poll_work_queue_space(void);
+static int msp_sec2_poll_completion_queues(int queue_mask, int max_req);
+
+#ifdef DEBUG
+#define DBG_SEC(a1, a2...)	printk(KERN_DEBUG "SEC: " a1, ##a2)
+#else
+#define DBG_SEC(a...)
+#endif
+
+static void dump_sec_regs(void);
+#if defined(DEBUG)
+#define debug_dump_sec_regs dump_sec_regs
+#else
+#define debug_dump_sec_regs()
+#endif
+
+#ifdef DUMP_WQ_ENTRIES
+static void dump_wq_entry(struct workq *wq);
+#else
+#define dump_wq_entry(wq)
+#endif
+
+#ifdef DUMP_CQ_ENTRIES
+static void dump_cq_entry(struct compq *cq);
+#else
+#define dump_cq_entry(cq)
+#endif
+
+#ifdef DUMP_SA
+static void dump_sa(struct sec2_sa *sa);
+#else
+#define dump_sa(sa)
+#endif
+
+/**************************************************************************
+ * Private data
+ */
+
+/*
+ * Define structures used to register IPSec engine with
+ * Linux Crypto API - this is the only public interface
+ * to this driver!
+ */
+
+/* Crypto API glue for AES functions */
+#define AES_MIN_KEY_SIZE	16 /* in u8 units */
+#define AES_MAX_KEY_SIZE	32
+#define AES_BLOCK_SIZE		16
+
+static struct crypto_alg msp_aes_alg = {
+	.cra_name		= "aes",
+	.cra_driver_name	= "aes-pmcmsp",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_aes_alg.cra_list),
+	.cra_u = {
+		.cipher = {
+			.cia_min_keysize = AES_MIN_KEY_SIZE,
+			.cia_max_keysize = AES_MAX_KEY_SIZE,
+			.cia_setkey	 = msp_crypto_setkey,
+			.cia_encrypt	 = msp_crypto_encrypt,
+			.cia_decrypt	 = msp_crypto_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_ecb_aes_alg = {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_ecb_aes_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_ecb_encrypt,
+			.decrypt	= msp_crypto_ecb_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_cbc_aes_alg = {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_cbc_aes_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_cbc_encrypt,
+			.decrypt	= msp_crypto_cbc_decrypt,
+		}
+	}
+};
+
+/* Crypto API glue for DES functions */
+#define DES_KEY_SIZE		8
+#define DES_BLOCK_SIZE		8
+
+static struct crypto_alg msp_des_alg = {
+	.cra_name		= "des",
+	.cra_driver_name	= "des-pmcmsp",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_des_alg.cra_list),
+	.cra_u = {
+		.cipher = {
+			.cia_min_keysize = DES_KEY_SIZE,
+			.cia_max_keysize = DES_KEY_SIZE,
+			.cia_setkey	 = msp_crypto_setkey,
+			.cia_encrypt	 = msp_crypto_encrypt,
+			.cia_decrypt	 = msp_crypto_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_ecb_des_alg = {
+	.cra_name		= "ecb(des)",
+	.cra_driver_name	= "ecb-des-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_ecb_des_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES_KEY_SIZE,
+			.max_keysize	= DES_KEY_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_ecb_encrypt,
+			.decrypt	= msp_crypto_ecb_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_cbc_des_alg = {
+	.cra_name		= "cbc(des)",
+	.cra_driver_name	= "cbc-des-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_cbc_des_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES_KEY_SIZE,
+			.max_keysize	= DES_KEY_SIZE,
+			.ivsize		= DES_BLOCK_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_cbc_encrypt,
+			.decrypt	= msp_crypto_cbc_decrypt,
+		}
+	}
+};
+
+/* Crypto API glue for DES3 functions */
+#define DES3_KEY_SIZE		(3 * DES_KEY_SIZE)
+#define DES3_BLOCK_SIZE		DES_BLOCK_SIZE
+
+static struct crypto_alg msp_des3_alg = {
+	.cra_name		= "des3_ede",
+	.cra_driver_name	= "des3_ede-pmcmsp",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize		= DES3_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_des3_alg.cra_list),
+	.cra_u			= {
+		.cipher = {
+			.cia_min_keysize = DES3_KEY_SIZE,
+			.cia_max_keysize = DES3_KEY_SIZE,
+			.cia_setkey	 = msp_crypto_setkey,
+			.cia_encrypt	 = msp_crypto_encrypt,
+			.cia_decrypt	 = msp_crypto_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_ecb_des3_alg = {
+	.cra_name		= "ecb(des3_ede)",
+	.cra_driver_name	= "ecb-des3_ede-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES3_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_ecb_des3_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES3_KEY_SIZE,
+			.max_keysize	= DES3_KEY_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_ecb_encrypt,
+			.decrypt	= msp_crypto_ecb_decrypt,
+		}
+	}
+};
+
+static struct crypto_alg msp_cbc_des3_alg = {
+	.cra_name		= "cbc(des3_ede)",
+	.cra_driver_name	= "cbc-des3_ede-pmcmsp",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= DES3_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct msp_crypto),
+	.cra_alignmask		= 3,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(msp_cbc_des3_alg.cra_list),
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= DES3_KEY_SIZE,
+			.max_keysize	= DES3_KEY_SIZE,
+			.ivsize		= DES3_BLOCK_SIZE,
+			.setkey		= msp_crypto_setkey,
+			.encrypt	= msp_crypto_cbc_encrypt,
+			.decrypt	= msp_crypto_cbc_decrypt,
+		}
+	}
+};
+
+/* Crypto API glue for MD5 functions */
+#define MD5_BLOCKSIZE	64
+#define MD5_DIGESTSIZE	16
+
+static struct crypto_alg msp_md5_alg = {
+	.cra_name	 = "md5",
+	.cra_driver_name = "md5-pmcmsp",
+	.cra_flags	 = CRYPTO_ALG_TYPE_DIGEST,
+	.cra_blocksize	 = MD5_BLOCKSIZE,
+	.cra_ctxsize	 = sizeof(struct msp_crypto),
+	.cra_module	 = THIS_MODULE,
+	.cra_list	 = LIST_HEAD_INIT(msp_md5_alg.cra_list),
+	.cra_u		 = {
+		.digest  = {
+			.dia_digestsize	= MD5_DIGESTSIZE,
+			.dia_init	= msp_crypto_md5_init,
+			.dia_update	= msp_crypto_md5_update,
+			.dia_final	= msp_crypto_md5_final,
+		}
+	}
+};
+
+/* Crypto API glue for SHA1 functions */
+#define SHA1_BLOCKSIZE	64
+#define SHA1_DIGESTSIZE	20
+
+static struct crypto_alg msp_sha1_alg = {
+	.cra_name	 = "sha1",
+	.cra_driver_name = "sha1-pmcmsp",
+	.cra_flags	 = CRYPTO_ALG_TYPE_DIGEST,
+	.cra_blocksize	 = SHA1_BLOCKSIZE,
+	.cra_ctxsize	 = sizeof(struct msp_crypto),
+	.cra_module	 = THIS_MODULE,
+	.cra_list	 = LIST_HEAD_INIT(msp_sha1_alg.cra_list),
+	.cra_u		 = {
+		.digest  = {
+			.dia_digestsize	= SHA1_DIGESTSIZE,
+			.dia_init	= msp_crypto_sha1_init,
+			.dia_update	= msp_crypto_sha1_update,
+			.dia_final	= msp_crypto_sha1_final,
+		}
+	}
+};
+
+/* local structures used to control work and completion queues */
+static struct workq sec_work_queues[HW_NR_WORK_QUEUES];
+static struct compq sec_comp_queues[HW_NR_COMP_QUEUES];
+
+/* IO mapped hardware registers */
+static volatile struct sec2_regs *sec2_regs;
+
+/*
+ * IPSEC engine updates head & tail registers AND copies these updates
+ * directly to SDRAM. On some architectures it is faster to access the
+ * SDRAM copies. On other architectures it is faster to access the
+ * registers directly. The SDRAM copies are not currently used in this
+ * implemention but a dummy SDRAM location must still be provided to
+ * engine.
+ */
+static void *dummy_ptr;
+static dma_addr_t dummy_dma_addr;
+
+/**************************************************************************
+ * Functions
+ */
+
+static void
+sec_destroy_queues(void)
+{
+	int i;
+	
+	for (i = 0; i < HW_NR_COMP_QUEUES; i++) {
+		struct compq *cq = &sec_comp_queues[i];
+		dma_free_coherent(NULL, SEC_COMP_Q_SIZE,
+				cq->base, cq->base_dma_addr);
+	}
+
+	for (i = 0; i < HW_NR_WORK_QUEUES; i++) {
+		struct compq *wq = &sec_comp_queues[i];
+		dma_free_coherent(NULL, SEC_WORK_Q_SIZE,
+				wq->base, wq->base_dma_addr);
+	}
+	
+	dma_free_coherent(NULL, sizeof(int), dummy_ptr, dummy_dma_addr);
+}
+
+static int
+sec_init_queues(void)
+{
+	int i;
+	struct workq *wq;
+	struct compq *cq;
+
+	/* Allocate uncached space for hw_ptr values - currently not used */
+	dummy_ptr = dma_alloc_coherent(NULL, sizeof(int), &dummy_dma_addr,
+					GFP_KERNEL);
+	DBG_SEC("Allocated dummy memory at 0x%p (0x%08x)\n",
+			dummy_ptr, dummy_dma_addr);
+
+	for (i = 0; i < HW_NR_COMP_QUEUES; i++) {
+		void *base; /* slowpath virtual address of base */
+		dma_addr_t base_dma_addr; /* DMA bus address of base */
+
+		base = dma_alloc_coherent(NULL, SEC_COMP_Q_SIZE,
+				&base_dma_addr, GFP_KERNEL);
+		DBG_SEC("Allocated CQ%d at 0x%p (0x%08x)\n",
+			i, base, base_dma_addr);
+
+		cq = &sec_comp_queues[i];
+
+		cq->cq_regs = &sec2_regs->cq[i];
+		cq->base = base;
+		cq->base_dma_addr = base_dma_addr;
+		cq->out = 0;
+
+		cq->cq_regs->ofst_ptr = (unsigned int *)dummy_dma_addr;
+		cq->cq_regs->base = (unsigned char *)cq->base_dma_addr;
+		cq->cq_regs->size = SEC_COMP_Q_SIZE;
+		cq->cq_regs->in = 0;
+		cq->cq_regs->out = 0;
+	}
+
+	for (i = 0; i < HW_NR_WORK_QUEUES; i++) {
+		void *base; /* slowpath virtual address of base */
+		dma_addr_t base_dma_addr; /* DMA bus address of base */
+
+		base = dma_alloc_coherent(NULL, SEC_WORK_Q_SIZE,
+					&base_dma_addr, GFP_KERNEL);
+		DBG_SEC("Allocated WQ%d at 0x%p (0x%08x)\n",
+			i, base, base_dma_addr);
+
+		wq = &sec_work_queues[i];
+
+		init_waitqueue_head(&wq->space_wait);
+
+		wq->wq_regs = &sec2_regs->wq[i];
+		wq->base = base;
+		wq->base_dma_addr = base_dma_addr;
+		wq->in = 0;
+		wq->low_water = SEC_WORK_Q_SIZE >> 1; /* wake when half full */
+
+		wq->wq_regs->ofst_ptr = (unsigned int *)dummy_dma_addr;
+		wq->wq_regs->base = (unsigned char *)wq->base_dma_addr;
+		wq->wq_regs->size = SEC_WORK_Q_SIZE;
+		wq->wq_regs->in = 0;
+		wq->wq_regs->out = 0;
+	}
+	debug_dump_sec_regs();
+
+	return 0;
+}
+
+static int __init
+msp_secv2_init(void)
+{
+	void *rstaddr, *rngaddr;
+	int rc = -ENOMEM;
+	char secid = identify_sec();
+
+	switch (secid) {
+	case SEC_POLO:
+		printk(KERN_ERR PREFIX
+			"Security engine found\n");
+		break;
+	case FEATURE_NOEXIST:
+		printk(KERN_ERR PREFIX
+			"Security engine not specified in "
+			"FEATURES env param\n");
+		return 0;
+	default:
+		printk(KERN_ERR PREFIX
+			"Security engine '%c' not supported\n", secid);
+		return -ENODEV;
+	}
+
+	/* Temporarily IO remap SoC and RNG registers */
+	rstaddr = ioremap_nocache(MSP_RST_BASE, MSP_RST_SIZE);
+	if (!rstaddr) {
+		printk(KERN_ERR PREFIX
+			"Unable to ioremap address 0x%08x\n", MSP_RST_BASE);
+		goto err_ioremap;
+	}
+	rngaddr = ioremap_nocache(MSP_SEC_BASE + SEC_RNG_CNF, sizeof(u32));
+	if (!rngaddr) {
+		printk(KERN_ERR PREFIX
+			"Unable to ioremap address 0x%08x\n",
+			MSP_SEC_BASE + SEC_RNG_CNF);
+		goto err_ioremap;
+	}
+
+	/* IO remap the security engine registers */
+	sec2_regs = ioremap_nocache(MSP_SEC_BASE + SEC2_REG,
+					sizeof(*sec2_regs));
+	if (!sec2_regs) {
+		printk(KERN_ERR PREFIX
+			"Unable to ioremap address 0x%08x\n",
+			MSP_SEC_BASE + SEC2_REG);
+		goto err_ioremap;
+	}
+
+	/* SoC Reset */
+	if (__raw_readl(rstaddr + MSPRST_STS) & MSP_SE_RST) {
+		__raw_writel(MSP_SE_RST, rstaddr + MSPRST_CLR);
+		while (__raw_readl(rstaddr + MSPRST_STS) & MSP_SE_RST)
+			udelay(5);
+	}
+
+	/* Software reset */
+	sec2_regs->rst |= SEC2_RST_MASTER;
+	while (sec2_regs->rst)
+		udelay(10);
+
+	/* Start random number generator */
+	__raw_writel(0x00010000, rngaddr);
+	__raw_writel(0x00000101, rngaddr);
+
+	DBG_SEC("================ Installing IPSEC Driver ================\n");
+	rc = sec_init_queues();
+	if (rc) {
+		printk(KERN_ERR PREFIX "Queue initialization failed\n");
+		goto err_queue_init;
+	}
+
+	rc = request_irq(MSP_INT_MBOX, msp_secv2_interrupt,
+			SA_SAMPLE_RANDOM, "pmcmsp_sec_hi",
+			(void *)sec2_regs);
+	if (rc) {
+		printk(KERN_WARNING PREFIX "Unable to get IRQ %d (rc=%d).\n",
+			MSP_INT_MBOX, rc);
+		goto err_high_int;
+	}
+
+	sec2_regs->ier = ~0;
+
+#ifdef CONFIG_CRYPTO_PMCMSP_CIPHER
+	/* Register AES with crypto API */
+	rc = crypto_register_alg(&msp_aes_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register AES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_aes;
+	}
+	rc = crypto_register_alg(&msp_ecb_aes_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register ECB-AES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_ecb_aes;
+	}
+	rc = crypto_register_alg(&msp_cbc_aes_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register CBC-AES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_cbc_aes;
+	}
+
+	/* Register DES with crypto API */
+	rc = crypto_register_alg(&msp_des_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register DES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_des;
+	}
+	rc = crypto_register_alg(&msp_ecb_des_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register ECB-DES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_ecb_des;
+	}
+	rc = crypto_register_alg(&msp_cbc_des_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register CBC-DES cipher "
+			"(software algorithm already loaded)\n");
+		goto err_cbc_des;
+	}
+
+	/* Register DES3 with crypto API */
+	rc = crypto_register_alg(&msp_des3_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register DES3_EDE cipher "
+			"(software algorithm already loaded)\n");
+		goto err_des3;
+	}
+	rc = crypto_register_alg(&msp_ecb_des3_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register ECB-DES3_EDE cipher "
+			"(software algorithm already loaded)\n");
+		goto err_ecb_des3;
+	}
+	rc = crypto_register_alg(&msp_cbc_des3_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register CBC-DES3_EDE cipher "
+			"(software algorithm already loaded)\n");
+		goto err_cbc_des3;
+	}
+#endif /* CONFIG_CRYPTO_PMCMSP_CIPHER */
+
+#ifdef CONFIG_CRYPTO_PMCMSP_HASH
+	/* Register MD5/SHA-1 with crypto API */
+	rc = crypto_register_alg(&msp_md5_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register MD5 hash "
+			"(software algorithm already loaded)\n");
+		goto err_md5;
+	}
+	rc = crypto_register_alg(&msp_sha1_alg);
+	if (rc) {
+		printk(KERN_ERR PREFIX
+			"Could not register SHA-1 hash "
+			"(software algorithm already loaded)\n");
+		goto err_sha1;
+	}
+#endif /* CONFIG_CRYPTO_PMCMSP_HASH */
+
+	iounmap(rngaddr);
+	iounmap(rstaddr);
+		
+	/* Okay! */
+	return 0;
+
+#ifdef CONFIG_CRYPTO_PMCMSP_HASH
+	crypto_unregister_alg(&msp_sha1_alg);
+err_sha1:
+	crypto_unregister_alg(&msp_md5_alg);
+err_md5:
+#endif /* CONFIG_CRYPTO_PMCMSP_HASH */
+
+#ifdef CONFIG_CRYPTO_PMCMSP_CIPHER
+	crypto_unregister_alg(&msp_cbc_des3_alg);
+err_cbc_des3:
+	crypto_unregister_alg(&msp_ecb_des3_alg);
+err_ecb_des3:
+	crypto_unregister_alg(&msp_des3_alg);
+err_des3:
+	crypto_unregister_alg(&msp_cbc_des_alg);
+err_cbc_des:
+	crypto_unregister_alg(&msp_ecb_des_alg);
+err_ecb_des:
+	crypto_unregister_alg(&msp_des_alg);
+err_des:
+	crypto_unregister_alg(&msp_cbc_aes_alg);
+err_cbc_aes:
+	crypto_unregister_alg(&msp_ecb_aes_alg);
+err_ecb_aes:
+	crypto_unregister_alg(&msp_aes_alg);
+err_aes:
+#endif /* CONFIG_CRYPTO_PMCMSP_CIPHER */
+	free_irq(MSP_INT_MBOX, (void *)sec2_regs);
+
+err_high_int:
+	sec_destroy_queues();
+err_queue_init:
+	iounmap(sec2_regs);
+err_ioremap:
+	if (rngaddr)
+		iounmap(rngaddr);
+	if (rstaddr)
+		iounmap(rstaddr);
+	
+	return rc;
+}
+
+static void
+msp_secv2_exit(void)
+{
+	crypto_unregister_alg(&msp_sha1_alg);
+	crypto_unregister_alg(&msp_md5_alg);
+	crypto_unregister_alg(&msp_cbc_des3_alg);
+	crypto_unregister_alg(&msp_ecb_des3_alg);
+	crypto_unregister_alg(&msp_des3_alg);
+	crypto_unregister_alg(&msp_cbc_des_alg);
+	crypto_unregister_alg(&msp_ecb_des_alg);
+	crypto_unregister_alg(&msp_des_alg);
+	crypto_unregister_alg(&msp_cbc_aes_alg);
+	crypto_unregister_alg(&msp_ecb_aes_alg);
+	crypto_unregister_alg(&msp_aes_alg);
+	
+	free_irq(MSP_INT_MBOX, (void *)sec2_regs);
+	free_irq(MSP_INT_CIC_SEC, (void *)sec2_regs);
+	
+	sec_destroy_queues();
+	
+	iounmap(sec2_regs);
+}
+
+static irqreturn_t
+msp_secv2_interrupt(int irq, void *dev_id)
+{
+	/*
+	 * TODO: This clears all interrupts, and assumes
+	 * that the cause was a completion queue update.
+	 */
+	unsigned int status;
+
+	status = sec2_regs->sis;
+	sec2_regs->sis = /* ~status */ 0;
+
+	DBG_SEC("interrupt irq %d status was %x\n", irq, status);
+
+	msp_sec2_poll_completion_queues(3, 0);
+
+	return IRQ_HANDLED;
+}
+
+
+/*
+ * sync_for_fastpath_read - sync point before reading shared structure
+ *				via fastpath
+ *
+ * input:
+ *
+ * returns:
+ *
+ * NOTE:
+ * This call is necessary if a shared control structure is accessed via
+ * uncached, fastpath. This call is not needed if uncached, slowpath is
+ * used instead.
+ *
+ * Typical call sequence:
+ * 1. read peripheral register to see if new info
+ * 2. call sync_for_fastpath_read
+ * 3. read structure via uncached, fastpath access
+ */
+static inline void
+sync_for_fastpath_read(void)
+{
+	/*
+	 * compiler memory barrier to ensure read below not moved by compiler
+	 */
+	barrier();
+
+	/*
+	 * Do a dummy read of slowpath SDRAM to ensure that share
+	 * control structure has made it all the way to SDRAM.
+	 */
+	blocking_read_reg32((u32 *)0xb0000000);
+
+	/*
+	 * memory barrier to ensure reads above complete
+	 */
+	rmb();
+}
+
+/*
+ * sync_for_fastpath_write - sync point before writing shared structure
+ *				via fastpath
+ *
+ * input:
+ *
+ * returns:
+ *
+ * NOTE:
+ * This call is necessary if a shared control structure is accessed via
+ * uncached, fastpath. This call is not needed if uncached, slowpath is
+ * used instead.
+ *
+ * Typical call sequence:
+ * 1. write shared structure via uncached, fastpath
+ * 2. call sync_for_fastpath_write
+ * 3. update peripheral register to let device know there is new info
+ *
+ */
+static inline void
+sync_for_fastpath_write(void)
+{
+	/*
+	 * compiler memory barrier to ensure read below not moved by compiler
+	 */
+	barrier();
+
+	/*
+	 * Do a dummy read of fastpath to ensure that share
+	 * control structure has made it all the way to SDRAM.
+	 */
+	blocking_read_reg32((u32 *)0xa0000000);
+
+	/*
+	 * barrier to ensure above reads/writes complete before below
+	 */
+	mb();
+}
+
+
+/*
+ * desc_start - starts creating work element
+ *
+ * input:
+ *	e_ptr - ptr to work element being built
+ *	sa_ptr - ptr to security association
+ *
+ * returns:
+ *
+ * note:
+ */
+static inline void
+desc_start(
+	struct desc_tent *const e_ptr,
+	const struct sec2_sa *const sa_ptr)
+{
+	/* check if EOD must be in 2nd to last gather */
+	e_ptr->do_eod_correction =
+		(sa_ptr->flags & SAFLG_MODE_MASK) == SAFLG_MODE_ESP_IN &&
+		(sa_ptr->flags & SAFLG_HASH_MASK) != SAFLG_HASHNULL;
+
+	/* flush SA and save dma bus address */
+	e_ptr->sa_dma_addr = dma_map_single(NULL, (void *)sa_ptr,
+						sizeof(struct sec2_sa),
+						DMA_BIDIRECTIONAL);
+
+	e_ptr->sg_count = 0;
+	e_ptr->is_first = 1;	/* expect first gather buf next */
+
+	dump_sa(sa_ptr);
+}
+
+/*
+ * desc_add_gather - adds gather buffer to work element
+ *
+ * input:
+ *	e_ptr - work element being built
+ *	buf_ptr - pointer to gather buffer
+ *	length - length of buffer in bytes
+ *	is_last - set if last gather buffer
+ *
+ * returns:
+ *
+ * NOTE:
+ *	The gather buffer is READ by the IPSEC engine
+ *	All gather buffers must be added before any scatter buffers.
+ */
+
+static inline void
+desc_add_gather(
+	struct desc_tent *const e_ptr,
+	const void *const buf_ptr,
+	unsigned int length,
+	unsigned int is_last)
+{
+	struct scat_gath *g_ptr;	/* ptr to gather buffer */
+	unsigned int ctrl;		/* gather buffer control flags */
+
+	g_ptr = &e_ptr->sg[e_ptr->sg_count];
+
+	/* flush buffer and save dma bus address */
+	ctrl = length & SEC2_WE_SG_SIZE;
+	g_ptr->buf_dma_addr = dma_map_single(NULL, (void *)buf_ptr,
+						ctrl, DMA_TO_DEVICE);
+
+	/* set flag bits needed by IPSEC engine */
+	if (e_ptr->is_first) {
+		e_ptr->is_first = 0;
+		ctrl |= SEC2_WE_SG_SOP;
+	}
+	if (is_last) {
+		e_ptr->is_first = 1; /* expect first scatter buf next */
+		ctrl |= SEC2_WE_SG_EOP;
+
+		if (e_ptr->do_eod_correction && e_ptr->sg_count != 0) {
+			/* set EOD in 2nd to last gather */
+			g_ptr[-1].ctrl |= SEC2_WE_SG_EOD;
+		} else
+			ctrl |= SEC2_WE_SG_EOD;
+	}
+
+	g_ptr->ctrl = ctrl;
+	e_ptr->sg_count++;
+}
+
+/*
+ * desc_add_scatter - adds scatter buffer to work element
+ *
+ * input:
+ *	e_ptr - work element being built
+ *	buf_ptr - pointer to scatter buffer
+ *	length - length of buffer in bytes
+ *	is_last - set if last scatter buffer
+ *
+ * returns:
+ *
+ * note:
+ *	The scatter buffer is WRITTEN by the IPSEC engine
+ *	All scatter buffers must be added after any gather buffers.
+ */
+static inline void
+desc_add_scatter(
+	struct desc_tent *const e_ptr,
+	const void *const buf_ptr,
+	unsigned int length,
+	unsigned int is_last)
+{
+	struct scat_gath *s_ptr;	/* ptr to scatter buffer */
+	unsigned int ctrl;		/* scatter buffer control flags */
+
+	s_ptr = &e_ptr->sg[e_ptr->sg_count];
+
+	/* invalidate buffer and save dma bus address */
+	ctrl = length & SEC2_WE_SG_SIZE;
+	s_ptr->buf_dma_addr = dma_map_single(NULL, (void *)buf_ptr,
+						ctrl, DMA_FROM_DEVICE);
+
+	/* set flag bits needed by IPSEC engine */
+	if (e_ptr->is_first) {
+		e_ptr->is_first = 0;
+		ctrl |= SEC2_WE_SG_SOP;
+	}
+	if (is_last)
+		ctrl |= SEC2_WE_SG_EOP | SEC2_WE_SG_EOD;
+
+	s_ptr->ctrl = ctrl | SEC2_WE_SG_SCATTER;
+	e_ptr->sg_count++;
+}
+
+/*
+ * desc_finish - finished creating work element
+ *
+ * input:
+ *	e_ptr - work element being built
+ *	ctrl - work element control flags
+ *
+ * returns:
+ *
+ * note
+ */
+static inline void
+desc_finish(struct desc_tent *const e_ptr, unsigned int ctrl)
+{
+	/* set descriptor size */
+	e_ptr->ctrl = ctrl | (WQE_DESC_SIZE(e_ptr->sg_count) - 1);
+	e_ptr->magic = WQE_MAGIC;
+}
+
+/*
+ * desc_write - write work element to IPSEC engine's work queue
+ *
+ * input:
+ *	wq - ptr to work queue
+ *	e_ptr - ptr to work element to add to work queue
+ *
+ * returns:
+ *
+ * note
+ */
+
+#define WQ_PUT_INT(base, in, val) \
+	do { \
+		*(unsigned int *)&base[in] = (unsigned int)(val); \
+		in = (in + sizeof(int)) & SEC_WORK_Q_MASK; \
+	} while (0)
+
+static inline void
+desc_write(struct workq *const wq, const struct desc_tent *const e_ptr)
+{
+	unsigned char *base_ptr;
+	unsigned int in;
+	int i;
+
+	/*
+	 * It is assumed that the avail register was just read to check
+	 * there is room in the queue for this descriptor.
+	 */
+	base_ptr = wq->base;
+	in = wq->in;
+	WQ_PUT_INT(base_ptr, in, e_ptr->sa_dma_addr);
+	WQ_PUT_INT(base_ptr, in, e_ptr->ctrl);
+	WQ_PUT_INT(base_ptr, in, e_ptr); /* write ptr to work element */
+	WQ_PUT_INT(base_ptr, in, 0);	/* unused */
+	for (i = 0; i < e_ptr->sg_count; i++) {
+		WQ_PUT_INT(base_ptr, in, e_ptr->sg[i].buf_dma_addr);
+		WQ_PUT_INT(base_ptr, in, e_ptr->sg[i].ctrl);
+	}
+
+	dump_wq_entry(wq);
+
+	/*
+	 * Ensure that descriptor data gets all the way to SDRAM BEFORE
+	 * incrementing the hardware register offset.
+	 */
+	sync_for_fastpath_write();
+
+	/*
+	 * Update hardware in offset so IPSEC engine sees new
+	 * work descriptor.
+	 */
+	wq->wq_regs->in = wq->in = in;
+}
+
+/*
+ * desc_read - read work descriptor from IPSEC engine's completion queue
+ *
+ * input:
+ *	cq - pointer to completion queue to read
+ *
+ * returns:
+ *	ptr to work descriptor or NULL if not valid
+ *
+ * NOTE:
+ *	This function handles the syncronization between engine and CPU.
+ *
+ *	Contents:
+ *		word 0: virtual kernel address of work element
+ *		word 1: unused
+ *		word 2: completion status
+ *		word 3: reserved
+ */
+static inline struct desc_tent *
+desc_read(struct compq *const cq)
+{
+	unsigned int out;
+	const unsigned int *int_ptr;
+	struct desc_tent *we_ptr;
+
+	/*
+	 * It is assumed that the avail register was just read to check
+	 * if a descriptor was really in the completion queue. Register
+	 * accesses are always slowpath so they are not syncronized to
+	 * fastpath reads (at all)!
+	 */
+
+	/*
+	 * Ensure that descriptor is really in SDRAM before reading from
+	 * fastpath.
+	 */
+	sync_for_fastpath_read();
+
+	/* read pointer to work element out of completion queue */
+	out = cq->out;
+	int_ptr = (unsigned int *)&cq->base[out];
+	we_ptr = (struct desc_tent *)int_ptr[0];
+	if (we_ptr != NULL && we_ptr->magic == WQE_MAGIC) {
+		/* read completion status out of completion queue */
+		we_ptr->comp_status = int_ptr[2];
+	} else {
+		/* ERROR: Not a valid pointer to work element! */
+		we_ptr = NULL;
+	}
+
+	/*
+	 * barrier to ensure above reads complete before below
+	 */
+	rmb();
+
+	out = (out + CQE_SIZE) & SEC_COMP_Q_MASK;
+	cq->cq_regs->out = cq->out = out;
+
+	return we_ptr;
+}
+
+/*
+ * desc_cleanup - cleanup work entry after work completed
+ *
+ * input:
+ *
+ * returns:
+ *
+ * note
+ */
+static inline void
+desc_cleanup(struct desc_tent *const e_ptr)
+{
+	int i;
+
+	dma_unmap_single(NULL, e_ptr->sa_dma_addr,
+			sizeof(struct sec2_sa), DMA_BIDIRECTIONAL);
+
+	for (i = 0; i < e_ptr->sg_count; i++) {
+		struct scat_gath *sg_ptr = &e_ptr->sg[0];
+		unsigned int buf_size;
+		unsigned int buf_ctrl;
+
+		buf_ctrl = sg_ptr->ctrl;
+		buf_size = buf_ctrl & SEC2_WE_SG_SIZE;
+		if (buf_ctrl & SEC2_WE_SG_SCATTER) {
+			dma_unmap_single(NULL, sg_ptr->buf_dma_addr,
+					buf_size, DMA_FROM_DEVICE);
+		} else {
+			dma_unmap_single(NULL, sg_ptr->buf_dma_addr,
+					buf_size, DMA_TO_DEVICE);
+		}
+		sg_ptr++;
+	}
+
+	/* filter out warnings that we are not interested in */
+	e_ptr->comp_status &=
+		(SEC2_INT_BAD_ADDR |
+		SEC2_INT_HASH_NON_64 |
+		SEC2_INT_DES_NON_8 |
+		SEC2_INT_AES_NON_16 |
+		SEC2_INT_BAD_GATHER |
+#if 0
+		/* TODO: ICV_COMP_ERR showing up erroneously */
+		SEC2_INT_ICV_COMP_ERR |
+#endif
+		SEC2_INT_OFFSET_ERR |
+		SEC2_INT_GS_BALANCE_ERR |
+		SEC2_INT_EOD_MARK_ERR);
+}
+
+/*
+ * desc_do_work - queues work element to engine and waits for completion
+ *
+ * input:
+ *	e_ptr - ptr to work element to add to queue
+ *	sleep - set if sleep, otherwise blocks
+ *
+ * returns:
+ *
+ * note
+ */
+static unsigned int
+desc_do_work(struct desc_tent *e_ptr, unsigned int sleep)
+{
+	unsigned int work_q;	/* index to work queue */
+	struct workq *wq;	/* ptr to work queue control structure */
+	unsigned int comp_q;	/* index to completion queue */
+	unsigned int comp_q_mask;	/* completion queue poll mask */
+	unsigned int flags = 0;	/* interrupt flags */
+
+	/*
+	 * TODO: Need to assign to queue depending on which CPU is running
+	 * Right now, hardcode to queue 0.
+	 */
+	work_q = comp_q = 0;
+	wq = &sec_work_queues[work_q];
+	comp_q_mask = 1;
+
+	if (comp_q == 1)
+		e_ptr->ctrl |= SEC2_WE_CTRL_CQ; /* completion queue 1 */
+
+	/* setup sleep mode */
+	if (sleep) {
+		if (in_atomic()) {
+			/* When we're atomic, we must not sleep */
+			sleep = 0;
+			DBG_SEC("in_atomic region, changing to poll mode:\n");
+		} else {
+			/* generate interrupt */
+			e_ptr->ctrl |= SEC2_WE_CTRL_GI;
+		}
+	}
+	e_ptr->sleep = sleep;
+	init_waitqueue_head(&e_ptr->wait_q);
+	e_ptr->event_happened = 0;
+	e_ptr->comp_status = ~0;
+
+	local_irq_save(flags);
+
+	/*
+	 * Read engine register to check if there is room in work queue
+	 * for new descriptor.
+	 */
+	while (wq->wq_regs->avail <= WQE_DESC_SIZE_BYTES(e_ptr->sg_count)) {
+		DBG_SEC("About to start request:\n");
+		debug_dump_sec_regs();
+		if (sleep) {
+			DBG_SEC("No space in queue; sleeping for space\n");
+			sleep_on(&wq->space_wait);
+		} else {
+			/*
+			 * Must poll both completion queues, because
+			 * we don't know which one might be holding us.
+			 */
+			msp_sec2_poll_completion_queues(3, 1);
+		}
+	}
+
+	/* write work entry to IPSEC engine and advance hw pointer */
+	desc_write(wq, e_ptr);
+
+	local_irq_restore(flags);
+
+#ifdef DEBUG_VERBOSE
+	DBG_SEC("Registers after submission:\n");
+	dump_sec_regs();
+#endif
+
+	/* now, if requested, do a poll or sleep */
+	if (sleep) {
+		DBG_SEC("SLEEP requested... waiting\n");
+		wait_event(e_ptr->wait_q, e_ptr->event_happened == 1);
+	} else {
+		/* must be poll */
+		int i = 0;
+		int rc;
+
+		DBG_SEC("POLL requested... polling\n");
+		while (e_ptr->event_happened == 0) {
+			rc = msp_sec2_poll_completion_queues(comp_q_mask, 0);
+			if (rc == -1 && i++ > 10000000) {
+				printk(KERN_ERR "******** SEC: "
+					"OPERATION TIMED OUT ******\n");
+				dump_sec_regs();
+				break;
+			}
+		}
+	}
+
+	DBG_SEC("Returning with status %x\n", e_ptr->comp_status);
+
+	return e_ptr->comp_status;
+}
+
+static int
+msp_sec2_set_aes_decrypt_key(
+	struct sec2_sa *sa,
+	int workq,
+	int compq,
+	int sleep)
+{
+	struct sec2_sa tmp_sa;
+	static char junk_buf[16];
+	unsigned int status;
+	struct desc_tent w; /* work queue element */
+
+	if ((unsigned int)workq > 1)
+		return -1;
+	if ((unsigned int)compq > 1)
+		return -1;
+
+	memset(&tmp_sa, 0, sizeof(tmp_sa));
+
+	tmp_sa.flags = sa->flags & SAFLG_CRYPT_TYPE_MASK;
+
+	/* MUST be AES type */
+	if (tmp_sa.flags < SAFLG_AES_128)
+		return -1;
+
+	tmp_sa.flags |= SAFLG_MODE_CRYPT | SAFLG_ECB;
+
+	memcpy(tmp_sa.crypt_keys, sa->crypt_keys, sizeof(sa->crypt_keys));
+
+	desc_start(&w, &tmp_sa);
+	desc_add_gather(&w, junk_buf, 16, WQE_LAST);
+	/* size -- ALWAYS 32 for SEC2_WE_CTRL_AKO */
+	desc_add_scatter(&w, sa->crypt_keys, 32, WQE_LAST);
+	desc_finish(&w, SEC2_WE_CTRL_AKO);
+	status = desc_do_work(&w, (unsigned int)sleep);
+	if (status) {
+		DBG_SEC("status 0x%x from hash in hmac preprocess(2)\n",
+			status);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+msp_sec2_poll_completion_queues(int queue_mask, int max_req)
+{
+	int q;
+	struct compq *cq;
+	int work_ct = 0;
+	int flags;
+
+	/*
+	 * 0 means no max value; MAXINT is close enough for
+	 * all practical purposes.
+	 */
+	if (max_req == 0)
+		max_req--;
+
+	cq = sec_comp_queues;
+	for (q = 0; q < HW_NR_COMP_QUEUES; q++, cq++) {
+		if (!(queue_mask & 1 << q))
+			continue;
+
+		local_irq_save(flags);
+
+		/*
+		 * Check IPSEC engine register to see if at least one
+		 * completion element is in completion queue
+		 */
+		while (SEC_COMP_Q_SIZE - cq->cq_regs->avail >= CQE_SIZE) {
+			struct desc_tent *e_ptr;
+
+			/*
+			 * If we've already exhausted max_req,
+			 * indicate we're returning with work
+			 * still to do.
+			 */
+			if (max_req == 0) {
+				msp_sec2_poll_work_queue_space();
+				local_irq_restore(flags);
+				return 1;
+			}
+
+			DBG_SEC("Getting compq entry from engine at 0x%08x\n",
+				cq->out);
+			dump_cq_entry(cq);
+			/*
+			 * Read work element from completion queue and
+			 * advance HW ptr.
+			 */
+			e_ptr = desc_read(cq);
+#ifdef DEBUG_VERBOSE
+			dump_sec_regs();
+#endif
+			if (e_ptr != NULL) {
+				desc_cleanup(e_ptr);
+
+				/* wakeup sleeper or poller */
+				e_ptr->event_happened = 1;
+				if (e_ptr->sleep)
+					wake_up(&e_ptr->wait_q);
+			}
+			max_req--;
+			work_ct++;
+		}
+		local_irq_restore(flags);
+	}
+
+	if (work_ct) {
+		msp_sec2_poll_work_queue_space();
+		return 0;	/* work done, now empty */
+	}
+
+	return -1;		/* there was nothing to do */
+}
+
+static void
+msp_sec2_poll_work_queue_space(void)
+{
+	int q;
+	struct workq *wq;
+
+	wq = sec_work_queues;
+	for (q = 0; q < HW_NR_WORK_QUEUES; q++, wq++) {
+		if (waitqueue_active(&wq->space_wait) &&
+		    wq->wq_regs->avail >= wq->low_water)
+			wake_up(&wq->space_wait);
+	}
+}
+
+/* Crypto API calls */
+static int
+msp_crypto_setkey(
+	struct crypto_tfm *tfm,
+	const u8 *key,
+	unsigned int key_len)
+{
+	struct msp_crypto *ctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+
+	DBG_SEC("Setting %u-byte key...\n", key_len);
+
+	if (key_len % 8) {
+		printk(KERN_ERR PREFIX "Key length must be 16, 24, or 32\n");
+		
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+
+	ctx->keysize = key_len;
+
+	memcpy((u8 *)(ctx->sa.crypt_keys), key, key_len);
+
+	/* Set AES decrypt key as well */
+	if (key_len >= 16) {
+		memcpy((u8 *)ctx->aes_decrypt_sa.crypt_keys, key, key_len);
+		switch (key_len) {
+		case 16:
+			ctx->aes_decrypt_sa.flags = SAFLG_AES_128;
+			break;
+		case 24:
+			ctx->aes_decrypt_sa.flags = SAFLG_AES_192;
+			break;
+		case 32:
+			ctx->aes_decrypt_sa.flags = SAFLG_AES_256;
+			break;
+		}
+		DBG_SEC("Pre-calculating %u-byte key...\n", key_len);
+		msp_sec2_set_aes_decrypt_key(&(ctx->aes_decrypt_sa), 0, 0, 1);
+	}
+
+	/* Store reversed DES3 key */
+	if (key_len == 24) {
+		ctx->des_decrypt_sa.crypt_keys[0] = ctx->sa.crypt_keys[4];
+		ctx->des_decrypt_sa.crypt_keys[1] = ctx->sa.crypt_keys[5];
+		ctx->des_decrypt_sa.crypt_keys[2] = ctx->sa.crypt_keys[2];
+		ctx->des_decrypt_sa.crypt_keys[3] = ctx->sa.crypt_keys[3];
+		ctx->des_decrypt_sa.crypt_keys[4] = ctx->sa.crypt_keys[0];
+		ctx->des_decrypt_sa.crypt_keys[5] = ctx->sa.crypt_keys[1];
+	};
+
+	return 0;
+}
+
+static void
+msp_crypto_setalg(struct msp_crypto *ctx, const char *algname)
+{
+	struct sec2_sa *sa = &ctx->sa;
+	sa->flags &= ~SAFLG_CRYPT_TYPE_MASK;
+
+	if (strstr(algname, "aes")) {
+		switch (ctx->keysize) {
+		case 16:
+			sa->flags |= SAFLG_AES_128;
+			break;
+		case 24:
+			sa->flags |= SAFLG_AES_192;
+			break;
+		case 32:
+			sa->flags |= SAFLG_AES_256;
+			break;
+		}
+	} else if (strstr(algname, "des3_ede")) {
+		sa->flags |= SAFLG_DES3;
+	} else if (strstr(algname, "des")) {
+		sa->flags |= SAFLG_DES;
+	} else {
+		printk(KERN_WARNING PREFIX
+			"Unknown algorithm '%s', defaulting to CRYPTNULL\n",
+			algname);
+		sa->flags |= SAFLG_CRYPTNULL;
+	}
+}
+
+static u8 *
+msp_crypto_cipher(
+	struct crypto_tfm *tfm,
+	u8 *out,
+	const u8 *in,
+	unsigned int nbytes,
+	const u8 *iv,
+	unsigned int direction,
+	unsigned int mode)
+{
+	struct msp_crypto *ctx = crypto_tfm_ctx(tfm);
+	struct sec2_sa *sa = &ctx->sa;
+	u32 alg;
+
+	const u8 *sptr = in;
+	u8 *dptr = out;
+
+	int crypt_modsize = crypto_tfm_alg_blocksize(tfm);
+	int maxbsize = 0xfff;
+
+	unsigned int bytesleft = nbytes;
+
+	DBG_SEC("Doing crypt of %d bytes from 0x%p to 0x%p\n",
+		nbytes, in, out);
+	msp_crypto_setalg(ctx, crypto_tfm_alg_name(tfm));
+	alg = sa->flags & SAFLG_CRYPT_TYPE_MASK;
+	if (direction == CRYPT_DIRECTION_DECRYPT) {
+		if (alg == SAFLG_AES_128 ||
+		    alg == SAFLG_AES_192 ||
+		    alg == SAFLG_AES_256)
+			/* Use Pre-calculated AES decrypt key */
+			sa = &ctx->aes_decrypt_sa;
+		else if (alg == SAFLG_DES3)
+			/* Use reversed DES decrypt key */
+			sa = &ctx->des_decrypt_sa;
+		sa->flags = alg;
+	}
+
+	sa->flags |= SAFLG_MODE_CRYPT;
+
+	if (direction == CRYPT_DIRECTION_ENCRYPT) {
+		switch (alg) {
+		case SAFLG_DES:
+			sa->flags |= SAFLG_DES_ENCRYPT;
+			break;
+		case SAFLG_AES_128:
+		case SAFLG_AES_192:
+		case SAFLG_AES_256:
+			sa->flags |= SAFLG_AES_ENCRYPT;
+			break;
+		case SAFLG_DES3:
+			sa->flags |= SAFLG_EDE_ENCRYPT;
+			break;
+		}
+	} else {
+		switch (alg) {
+		case SAFLG_DES:
+			sa->flags |= SAFLG_DES_DECRYPT;
+			break;
+		case SAFLG_AES_128:
+		case SAFLG_AES_192:
+		case SAFLG_AES_256:
+			sa->flags |= SAFLG_AES_DECRYPT;
+			break;
+		case SAFLG_DES3:
+			sa->flags |= SAFLG_EDE_DECRYPT;
+			break;
+		}
+	}
+
+	switch (mode) {
+	case CRYPTO_TFM_MODE_ECB:
+		sa->flags |= SAFLG_ECB;
+		break;
+	case CRYPTO_TFM_MODE_CBC:
+		if (direction == CRYPT_DIRECTION_ENCRYPT)
+			sa->flags |= SAFLG_CBC_ENCRYPT;
+		else
+			sa->flags |= SAFLG_CBC_DECRYPT;
+		/* Copy in IV */
+		memcpy((u8 *)sa->crypt_iv, iv, crypt_modsize);
+		break;
+	default:
+		break;
+	}
+
+	/* Do the acual operation now */
+	while (bytesleft > 0) {
+		/*
+		 * TODO: Maybe use s/g to actually pipeline these if there
+		 * are more than one?
+		 */
+		struct desc_tent w;
+		unsigned int status;
+		int bsize;
+
+		bsize = (bytesleft > maxbsize) ? maxbsize : bytesleft;
+		bsize -= bsize % crypt_modsize;
+
+		DBG_SEC("Doing crypt on %d/%d bytes\n", bsize, nbytes);
+		desc_start(&w, sa);
+		desc_add_gather(&w, sptr, bsize, WQE_LAST);
+		desc_add_scatter(&w, dptr, bsize, WQE_LAST);
+		desc_finish(&w, 0);
+		status = desc_do_work(&w, WQE_SLEEP);
+		if (status != 0)
+			panic("Encrypt/decrypt failed, status 0x%08x\n",
+				status);
+		sptr += bsize;
+		dptr += bsize;
+		bytesleft -= bsize;
+
+		if (bytesleft < crypt_modsize)
+			break;
+	}
+	DBG_SEC("Crypt operation complete (%d left)\n", (bytesleft));
+
+	return (u8 *)sa->crypt_iv;
+}
+
+static void
+msp_crypto_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	msp_crypto_cipher(tfm, dst, src, 1, NULL,
+			CRYPT_DIRECTION_ENCRYPT, CRYPTO_TFM_MODE_OTHER);
+}
+
+static int
+msp_crypto_ecb_encrypt(
+	struct blkcipher_desc *desc,
+	struct scatterlist *dst,
+	struct scatterlist *src,
+	unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+	unsigned int blksize = crypto_blkcipher_blocksize(desc->tfm);
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		msp_crypto_cipher(&desc->tfm->base,
+			walk.dst.virt.addr, walk.src.virt.addr, nbytes,
+			NULL, CRYPT_DIRECTION_ENCRYPT, CRYPTO_TFM_MODE_ECB);
+
+		nbytes &= blksize - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static int
+msp_crypto_cbc_encrypt(
+	struct blkcipher_desc *desc,
+	struct scatterlist *dst,
+	struct scatterlist *src,
+	unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+	unsigned int blksize = crypto_blkcipher_blocksize(desc->tfm);
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		u8 *iv = msp_crypto_cipher(&desc->tfm->base,
+			walk.dst.virt.addr, walk.src.virt.addr, nbytes,
+			walk.iv, CRYPT_DIRECTION_ENCRYPT, CRYPTO_TFM_MODE_CBC);
+
+		memcpy(walk.iv, iv, blksize);
+		nbytes &= blksize - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static void
+msp_crypto_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+{
+	msp_crypto_cipher(tfm, dst, src, 1, NULL,
+			CRYPT_DIRECTION_DECRYPT, CRYPTO_TFM_MODE_OTHER);
+}
+
+static int
+msp_crypto_ecb_decrypt(
+	struct blkcipher_desc *desc,
+	struct scatterlist *dst,
+	struct scatterlist *src,
+	unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+	unsigned int blksize = crypto_blkcipher_blocksize(desc->tfm);
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		msp_crypto_cipher(&desc->tfm->base,
+			walk.dst.virt.addr, walk.src.virt.addr, nbytes,
+			NULL, CRYPT_DIRECTION_DECRYPT, CRYPTO_TFM_MODE_ECB);
+
+		nbytes &= blksize - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static int
+msp_crypto_cbc_decrypt(
+	struct blkcipher_desc *desc,
+	struct scatterlist *dst,
+	struct scatterlist *src,
+	unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+	unsigned int blksize = crypto_blkcipher_blocksize(desc->tfm);
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		msp_crypto_cipher(&desc->tfm->base,
+			walk.dst.virt.addr, walk.src.virt.addr, nbytes,
+			walk.iv, CRYPT_DIRECTION_DECRYPT, CRYPTO_TFM_MODE_CBC);
+
+		nbytes &= blksize - 1;
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+
+static void
+msp_crypto_hash_init(void *ctx_arg)
+{
+	struct msp_hash *ctx = ctx_arg;
+	struct sec2_sa *sa = &ctx->sa;
+
+	DBG_SEC("Starting hash op\n");
+	sa->flags |= SAFLG_MODE_HASH_PAD;
+
+	memset(sa->hash_chain_a, 0, 20);
+
+	if (ctx->data != NULL) {
+		kfree(ctx->data);
+		ctx->data = NULL;
+	}
+	ctx->data_size = 0;
+}
+
+static void
+msp_crypto_hash_update(void *ctx_arg, const u8 *data, unsigned int len)
+{
+	struct msp_hash *ctx = ctx_arg;
+
+	if (len == 0)
+		return;
+
+	DBG_SEC("Adding %d bytes of data from 0x%p\n", len, data);
+
+	if (ctx->data == NULL) {
+		/*
+		 * First time you call hash_update, allocate and
+		 * copy the data.
+		 */
+		ctx->data = kmalloc(len, GFP_KERNEL);
+		memcpy(ctx->data, data, len);
+		ctx->data_size = len;
+	} else {
+		/* Second time, re-alloc and copy */
+		u8 *tmp = ctx->data;
+		ctx->data = kmalloc(ctx->data_size + len, GFP_KERNEL);
+		memcpy(ctx->data, tmp, ctx->data_size);
+		memcpy(ctx->data + ctx->data_size, data, len);
+		ctx->data_size += len;
+		kfree(tmp);
+	}
+}
+
+static void
+msp_crypto_hash_final(void *ctx_arg, u8 *out)
+{
+	struct msp_hash *ctx = ctx_arg;
+	struct sec2_sa *sa = &ctx->sa;
+	struct desc_tent w;
+	unsigned int status;
+
+	if (ctx->data_size == 0)
+		return;
+
+	desc_start(&w, sa);
+	desc_add_gather(&w, ctx->data, ctx->data_size, WQE_LAST);
+	desc_add_scatter(&w, out, ctx->resultsize, WQE_LAST);
+	desc_finish(&w, 0);
+	status = desc_do_work(&w, WQE_SLEEP);
+	if (status != 0)
+		printk(KERN_ERR "Hash update failed, status 0x%08x\n", status);
+	DBG_SEC("Hash operation complete\n");
+
+	if (ctx->data != NULL) {
+		kfree(ctx->data);
+		ctx->data = NULL;
+	}
+	ctx->data_size = 0;
+}
+
+static void
+msp_crypto_md5_init(struct crypto_tfm *tfm)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	struct sec2_sa *sa = &ctx->sa;
+	
+	sa->flags = SAFLG_MD5;
+	ctx->resultsize = 16;
+	msp_crypto_hash_init(ctx);
+}
+
+static void
+msp_crypto_md5_update(
+	struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	
+	msp_crypto_hash_update(ctx, data, len);
+}
+
+static void
+msp_crypto_md5_final(struct crypto_tfm *tfm, u8 *out)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	
+	msp_crypto_hash_final(ctx, out);
+}
+
+static void
+msp_crypto_sha1_init(struct crypto_tfm *tfm)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	struct sec2_sa *sa = &ctx->sa;
+	
+	sa->flags = SAFLG_SHA1;
+	ctx->resultsize = 20;
+	msp_crypto_hash_init(ctx);
+}
+
+static void
+msp_crypto_sha1_update(
+	struct crypto_tfm *tfm, const u8 *data, unsigned int len)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	
+	msp_crypto_hash_update(ctx, data, len);
+}
+
+static void
+msp_crypto_sha1_final(struct crypto_tfm *tfm, u8 *out)
+{
+	struct msp_hash *ctx = crypto_tfm_ctx(tfm);
+	
+	msp_crypto_hash_final(ctx, out);
+}
+
+/***********************************************************************
+ *
+ * IPSEC Debug Utilities - Not normally compiled in
+ *
+ ***********************************************************************/
+static void
+dump_sec_regs(void)
+{
+	int i;
+
+	printk(KERN_INFO "SEC: " "IPSEC register start\n");
+	printk(KERN_INFO "SEC:  " "%08x  sis (interrupt status)\n",
+				sec2_regs->sis);
+	printk(KERN_INFO "SEC:  " "%08x  ier (interrupt enable)\n",
+				sec2_regs->ier);
+	printk(KERN_INFO "SEC:  " "%08x  esr (engine status)\n",
+				sec2_regs->esr);
+	for (i = 0; i < HW_NR_WORK_QUEUES; i++) {
+		printk(KERN_INFO "SEC: " "----------\n");
+		printk(KERN_INFO "SEC:  " "%08x  wq%d ofst_ptr\n",
+			(int)sec2_regs->wq[i].ofst_ptr, i);
+		printk(KERN_INFO "SEC:  " "%08x  wq%d avail\n",
+			sec2_regs->wq[i].avail, i);
+		printk(KERN_INFO "SEC:  " "%08x  wq%d base\n",
+			(int)sec2_regs->wq[i].base, i);
+		printk(KERN_INFO "SEC:  " "%08x  wq%d size\n",
+			sec2_regs->wq[i].size, i);
+		printk(KERN_INFO "SEC:  " "%08x  wq%d in\n",
+			sec2_regs->wq[i].in, i);
+		printk(KERN_INFO "SEC:  " "%08x  wq%d out\n",
+			sec2_regs->wq[i].out, i);
+	}
+
+	for (i = 0; i < HW_NR_COMP_QUEUES; i++) {
+		printk(KERN_INFO "SEC: " "----------\n");
+		printk(KERN_INFO "SEC:  " "%08x  cq%d ofst_ptr\n",
+			(int)sec2_regs->cq[i].ofst_ptr, i);
+		printk(KERN_INFO "SEC:  " "%08x  cq%d avail\n",
+			sec2_regs->cq[i].avail, i);
+		printk(KERN_INFO "SEC:  " "%08x  cq%d base\n",
+			(int)sec2_regs->cq[i].base, i);
+		printk(KERN_INFO "SEC:  " "%08x  cq%d size\n",
+			sec2_regs->cq[i].size, i);
+		printk(KERN_INFO "SEC:  " "%08x  cq%d in\n",
+			sec2_regs->cq[i].in, i);
+		printk(KERN_INFO "SEC:  " "%08x  cq%d out\n",
+			sec2_regs->cq[i].out, i);
+	}
+	printk(KERN_INFO "SEC: " "IPSEC register end\n");
+}
+
+#ifdef DUMP_WQ_ENTRIES
+#define GET_INT(base, idx, val) \
+	do { \
+		val = *(unsigned int *)((base) + idx); \
+		idx = (idx + 4) & SEC_WORK_Q_MASK; \
+	} while (0)
+
+static void
+dump_wq_entry(struct workq *wq)
+{
+	int idx, i;
+	unsigned int val;
+	unsigned int desc_size;
+	unsigned int sg_size;
+
+	idx = wq->in;
+
+	printk(KERN_INFO "Work_desc_start, "
+		"sw_in=%d, hw_in=%d, hw_out=%d, avail=%d\n",
+		idx, wq->wq_regs->in, wq->wq_regs->out, wq->wq_regs->avail);
+
+	GET_INT(wq->base, idx, val);
+	printk(KERN_INFO "  %08x SA ptr\n", val);
+
+	GET_INT(wq->base, idx, val);
+	printk(KERN_INFO "  %08x ctrl, pad=%d, next_hdr=%d,",
+		val, (val >> 24) & 0xff, (val >> 16) & 0xff);
+	if (val & SEC2_WE_CTRL_AKO)
+		printk(KERN_INFO " AKO,");
+	if (val & SEC2_WE_CTRL_GI)
+		printk(KERN_INFO " GI,");
+	if (val & SEC2_WE_CTRL_CQ)
+		printk(KERN_INFO " CQ,");
+
+	desc_size = val & 0xff;
+	sg_size = desc_size - 3;
+	printk(KERN_INFO " desc_size=%d, sg_size=%d\n", desc_size, sg_size);
+
+	GET_INT(wq->base, idx, val);
+	printk(KERN_INFO "  %08x desc_tent_ptr\n", val);
+
+	GET_INT(wq->base, idx, val);
+	printk(KERN_INFO "  %08x unused\n", val);
+
+	for (i = 0; i < sg_size; i += 2) {
+		GET_INT(wq->base, idx, val);
+		printk(KERN_INFO "  %08x", val);
+
+		GET_INT(wq->base, idx, val);
+		printk(KERN_INFO " %08x ", val);
+		if (val & SEC2_WE_SG_SCATTER)
+			printk(KERN_INFO " Scat,");
+		else
+			printk(KERN_INFO " Gath,");
+
+		if (val & SEC2_WE_SG_SOP)
+			printk(KERN_INFO " SOP,");
+		if (val & SEC2_WE_SG_EOD)
+			printk(KERN_INFO " EOD,");
+		if (val & SEC2_WE_SG_EOP)
+			printk(KERN_INFO " EOP,");
+
+		printk(KERN_INFO " len=%d\n", val & 0x7ff);
+	}
+	printk(KERN_INFO "Work_desc_end, sw_in=%d, hw_in=%d\n",
+			idx, wq->wq_regs->in);
+}
+#endif
+
+#ifdef DUMP_SA
+static void
+dump_sa(struct sec2_sa *sa)
+{
+	unsigned int eng_mode;
+	int i;
+
+	printk(KERN_INFO "SA start\n");
+	printk(KERN_INFO " flags     esp_spi   esp_seq\n");
+	printk(KERN_INFO " %08x  %08x  %08x\n",
+		sa->flags, sa->esp_spi, sa->esp_sequence);
+	switch (eng_mode = sa->flags & SAFLG_MODE_MASK) {
+	case SAFLG_MODE_ESP_IN:
+		printk(KERN_INFO "   ESP_IN  ");
+		break;
+	case SAFLG_MODE_ESP_OUT:
+		printk(KERN_INFO "   ESP_OUT ");
+		break;
+	case SAFLG_MODE_HMAC:
+		printk(KERN_INFO "   HMAC    ");
+		break;
+	case SAFLG_MODE_HASH_PAD:
+		printk(KERN_INFO "  HASH+PAD ");
+		break;
+	case SAFLG_MODE_HASH:
+		printk(KERN_INFO "  HASH     ");
+		break;
+	case SAFLG_MODE_CRYPT:
+		printk(KERN_INFO "  CRYPT    ");
+		break;
+	default:
+		printk(KERN_INFO "*BAD*ENG*MODE*");
+		break;
+	}
+
+	if (eng_mode == SAFLG_MODE_ESP_OUT) {
+		printk((sa->flags & SAFLG_SI) ? " SI " : " NO_SI ");
+		printk((sa->flags & SAFLG_CRI) ? " CRI " : " NO_CRI ");
+		printk((sa->flags & SAFLG_EM) ? " EM " : "");
+	}
+
+	if (eng_mode == SAFLG_MODE_ESP_IN)
+		printk((sa->flags & SAFLG_CPI) ? " CPI " : " NO_CPI ");
+
+	if (eng_mode != SAFLG_MODE_CRYPT) {
+		printk((sa->flags & SAFLG_CV) ? " CV " : " NO_CV ");
+
+		switch (sa->flags & SAFLG_HASH_MASK) {
+		case SAFLG_MD5_96:
+			printk(KERN_INFO " MD5-96  ");
+			break;
+		case SAFLG_MD5:
+			printk(KERN_INFO " MD5 ");
+			break;
+		case SAFLG_SHA1_96:
+			printk(KERN_INFO " SHA1-96 ");
+			break;
+		case SAFLG_SHA1:
+			printk(KERN_INFO " SHA1 ");
+			break;
+		case SAFLG_HASHNULL:
+			printk(KERN_INFO " HSH_NULL ");
+			break;
+		default:
+			printk(KERN_INFO " *BAD*HASH* ");
+			break;
+		}
+	}
+
+	if (eng_mode <= SAFLG_MODE_ESP_OUT ||
+	    eng_mode == SAFLG_MODE_CRYPT) {
+		switch (sa->flags & SAFLG_CRYPT_TYPE_MASK) {
+		case SAFLG_DES:
+			printk(KERN_INFO " DES-");
+			break;
+		case SAFLG_DES3:
+			printk(KERN_INFO " DES3-");
+			break;
+		case SAFLG_AES_128:
+			printk(KERN_INFO " AES128-");
+			break;
+		case SAFLG_AES_192:
+			printk(KERN_INFO " AES192-");
+			break;
+		case SAFLG_AES_256:
+			printk(KERN_INFO " AES256-");
+			break;
+		case SAFLG_CRYPTNULL:
+			printk(KERN_INFO " CRYPTNULL-");
+			break;
+		default:
+			printk(KERN_INFO " BADCRYPT-");
+			break;
+		}
+		printk((sa->flags & SAFLG_DES_K1_DECRYPT) ? "D" : "E");
+		if ((sa->flags & SAFLG_CRYPT_TYPE_MASK) == SAFLG_DES3) {
+			printk((sa->flags & SAFLG_DES_K2_DECRYPT)? "D" : "E");
+			printk((sa->flags & SAFLG_DES_K3_DECRYPT)? "D" : "E");
+		}
+
+		switch (sa->flags & SAFLG_BLK_MASK) {
+		case SAFLG_ECB:
+			printk(KERN_INFO " ECB\n");
+			break;
+		case SAFLG_CTR:
+			printk(KERN_INFO " CTR\n");
+			break;
+		case SAFLG_CBC_ENCRYPT:
+			printk(KERN_INFO " CBC-ENCRYPT\n");
+			break;
+		case SAFLG_CBC_DECRYPT:
+			printk(KERN_INFO " CBC-DECRYPT\n");
+			break;
+		case SAFLG_CFB_ENCRYPT:
+			printk(KERN_INFO " CFB-ENCRYPT\n");
+			break;
+		case SAFLG_CFB_DECRYPT:
+			printk(KERN_INFO " CFB-DECRYPT\n");
+			break;
+		case SAFLG_OFB:
+			printk(KERN_INFO " OFB\n");
+			break;
+		default:
+			printk(KERN_INFO " BAD*BLOCK*MODE\n");
+			break;
+		}
+	} else
+		printk(KERN_INFO "\n");
+
+	printk(KERN_INFO " hash_chain_a:");
+	for (i = 0; i < 0x5; i++) {
+		if (i % 6 == 0)
+			printk(KERN_INFO "\n   %04x  ", i * 4);
+		printk(KERN_INFO "%08x  ", sa->hash_chain_a[i]);
+	}
+	printk(KERN_INFO "\n");
+
+	printk(KERN_INFO " hash_chain_b:");
+	for (i = 0; i < 0x5; i++) {
+		if (i % 6 == 0)
+			printk(KERN_INFO "\n   %04x  ", i * 4);
+		printk(KERN_INFO "%08x  ", sa->hash_chain_b[i]);
+	}
+	printk(KERN_INFO "\n");
+
+	printk(KERN_INFO " encryption keys:");
+	for (i = 0; i < 0x8; i++) {
+		if (i % 4 == 0)
+			printk(KERN_INFO "\n   %04x  ", i * 4);
+		printk(KERN_INFO "%08x ", sa->crypt_keys[i]);
+	}
+	printk(KERN_INFO "\n");
+
+	printk(KERN_INFO " Hash Initial Length:  %08x %08x\n",
+		sa->hash_init_len[0], sa->hash_init_len[1]);
+
+	printk(KERN_INFO " IV:");
+	for (i = 0; i < 0x4; i++) {
+		if (i % 4 == 0)
+			printk(KERN_INFO "\n   %04x  ", i * 4);
+		printk(KERN_INFO "%08x ", sa->crypt_iv[i]);
+	}
+	printk(KERN_INFO "\n");
+
+	printk(KERN_INFO "SA end\n");
+}
+#endif
+
+#ifdef DUMP_CQ_ENTRIES
+static void
+dump_cq_entry(struct compq *cq)
+{
+	unsigned int *ip;
+
+	ip = (unsigned int *)(cq->base + cq->out);
+
+	printk(KERN_INFO " -----> Completion entry  %08x %08x %08x %08x\n",
+		ip[0], ip[1], ip[2], ip[3]);
+}
+#endif
+
+
+module_init(msp_secv2_init);
+module_exit(msp_secv2_exit);
+
+MODULE_DESCRIPTION("PMC MSP Security Accelerator");
+MODULE_LICENSE("GPL")
