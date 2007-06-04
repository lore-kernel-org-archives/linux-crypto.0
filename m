From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Mon, 4 Jun 2007 17:42:48 +0400
Message-ID: <20070604134248.GA9645@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34154 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXFDNny (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jun 2007 09:43:54 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

This is preliminary driver for HIFN 795x crypto accelerator chip.

It is slightly restructured acrypto driver, which worked correctly, but
this one was not tested with real hardware (yet, I will do it as soon as
get back my soekris adapter).

Changelog:

take2:
 * added a lot of cryptoapi interfaces (i.e. support for all crypto
   modes and three ciphers: aes, des and 3des via cryptoapi).
   
   My cat has pissed on my domestic slippers when he saw that.
   And believe me, he does know, how to distinguish between good and
   other code. Well, I do not have a cat, but if I would, he would
   definitely piss on my slippers. The most interesting stuff starts
   from 1600+ lines. Herbert, are you sure it is ok?

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ff8c4be..9d2fffd 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -66,4 +66,16 @@ config CRYPTO_DEV_GEODE
 	  To compile this driver as a module, choose M here: the module
 	  will be called geode-aes.
 
+config CRYPTO_DEV_HIFN_795x
+	tristate "Support for HIFN 795x crypto processors"
+	depends on CRYPTO && PCI
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  Say 'Y' here to enable support for HIFN 795x crypto processor for
+	  various crypto algorithms this processor supports.
+	  
+	  To compile this driver as a module, choose M here: the module
+	  will be called hifn795x.
+
 endmenu
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6059cf8..f8c1af8 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
+obj-$(CRYPTO_DEV_HIFN_795x) += hifn_795x.o
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
new file mode 100644
index 0000000..61916bf
--- /dev/null
+++ b/drivers/crypto/hifn_795x.c
@@ -0,0 +1,2289 @@
+/*
+ * 2007+ Copyright (c) Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+ * All rights reserved.
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/crypto.h>
+
+#include <crypto/algapi.h>
+
+#include <asm/kmap_types.h>
+
+#undef dprintk
+
+#define HIFN_TEST
+#define HIFN_DEBUG
+
+#ifdef HIFN_DEBUG
+#define dprintk(f, a...) 	printk(f, ##a)
+#else
+#define dprintk(f, a...)	do {} while (0)
+#endif
+
+static atomic_t hifn_dev_number;
+
+#define ACRYPTO_OP_DECRYPT	0
+#define ACRYPTO_OP_ENCRYPT	1
+#define ACRYPTO_OP_HMAC		2
+#define ACRYPTO_OP_RNG		3
+
+#define ACRYPTO_MODE_ECB		0
+#define ACRYPTO_MODE_CBC		1
+#define ACRYPTO_MODE_CFB		2
+#define ACRYPTO_MODE_OFB		3
+
+#define ACRYPTO_TYPE_AES_128	0
+#define ACRYPTO_TYPE_AES_192	1
+#define ACRYPTO_TYPE_AES_256	2
+#define ACRYPTO_TYPE_3DES	3
+#define ACRYPTO_TYPE_DES	4
+
+#define PCI_VENDOR_ID_HIFN		0x13A3
+#define PCI_DEVICE_ID_HIFN_7955		0x0020
+#define	PCI_DEVICE_ID_HIFN_7956		0x001d
+
+/* I/O region sizes */
+
+#define HIFN_BAR0_SIZE			0x1000
+#define HIFN_BAR1_SIZE			0x2000
+#define HIFN_BAR2_SIZE			0x8000
+
+/* DMA registres */
+
+#define HIFN_DMA_CRA 			0x0C	/* DMA Command Ring Address */
+#define HIFN_DMA_SDRA 			0x1C	/* DMA Source Data Ring Address */
+#define HIFN_DMA_RRA			0x2C	/* DMA Result Ring Address */
+#define HIFN_DMA_DDRA			0x3C	/* DMA Destination Data Ring Address */
+#define HIFN_DMA_STCTL			0x40	/* DMA Status and Control */
+#define HIFN_DMA_INTREN 		0x44	/* DMA Interrupt Enable */
+#define HIFN_DMA_CFG1			0x48	/* DMA Configuration #1 */
+#define HIFN_DMA_CFG2			0x6C	/* DMA Configuration #2 */
+#define HIFN_CHIP_ID			0x98	/* Chip ID */
+
+/*
+ * Processing Unit Registers (offset from BASEREG0)
+ */
+#define	HIFN_0_PUDATA		0x00	/* Processing Unit Data */
+#define	HIFN_0_PUCTRL		0x04	/* Processing Unit Control */
+#define	HIFN_0_PUISR		0x08	/* Processing Unit Interrupt Status */
+#define	HIFN_0_PUCNFG		0x0c	/* Processing Unit Configuration */
+#define	HIFN_0_PUIER		0x10	/* Processing Unit Interrupt Enable */
+#define	HIFN_0_PUSTAT		0x14	/* Processing Unit Status/Chip ID */
+#define	HIFN_0_FIFOSTAT		0x18	/* FIFO Status */
+#define	HIFN_0_FIFOCNFG		0x1c	/* FIFO Configuration */
+#define	HIFN_0_SPACESIZE	0x20	/* Register space size */
+
+/* Processing Unit Control Register (HIFN_0_PUCTRL) */
+#define	HIFN_PUCTRL_CLRSRCFIFO	0x0010	/* clear source fifo */
+#define	HIFN_PUCTRL_STOP	0x0008	/* stop pu */
+#define	HIFN_PUCTRL_LOCKRAM	0x0004	/* lock ram */
+#define	HIFN_PUCTRL_DMAENA	0x0002	/* enable dma */
+#define	HIFN_PUCTRL_RESET	0x0001	/* Reset processing unit */
+
+/* Processing Unit Interrupt Status Register (HIFN_0_PUISR) */
+#define	HIFN_PUISR_CMDINVAL	0x8000	/* Invalid command interrupt */
+#define	HIFN_PUISR_DATAERR	0x4000	/* Data error interrupt */
+#define	HIFN_PUISR_SRCFIFO	0x2000	/* Source FIFO ready interrupt */
+#define	HIFN_PUISR_DSTFIFO	0x1000	/* Destination FIFO ready interrupt */
+#define	HIFN_PUISR_DSTOVER	0x0200	/* Destination overrun interrupt */
+#define	HIFN_PUISR_SRCCMD	0x0080	/* Source command interrupt */
+#define	HIFN_PUISR_SRCCTX	0x0040	/* Source context interrupt */
+#define	HIFN_PUISR_SRCDATA	0x0020	/* Source data interrupt */
+#define	HIFN_PUISR_DSTDATA	0x0010	/* Destination data interrupt */
+#define	HIFN_PUISR_DSTRESULT	0x0004	/* Destination result interrupt */
+
+/* Processing Unit Configuration Register (HIFN_0_PUCNFG) */
+#define	HIFN_PUCNFG_DRAMMASK	0xe000	/* DRAM size mask */
+#define	HIFN_PUCNFG_DSZ_256K	0x0000	/* 256k dram */
+#define	HIFN_PUCNFG_DSZ_512K	0x2000	/* 512k dram */
+#define	HIFN_PUCNFG_DSZ_1M	0x4000	/* 1m dram */
+#define	HIFN_PUCNFG_DSZ_2M	0x6000	/* 2m dram */
+#define	HIFN_PUCNFG_DSZ_4M	0x8000	/* 4m dram */
+#define	HIFN_PUCNFG_DSZ_8M	0xa000	/* 8m dram */
+#define	HIFN_PUNCFG_DSZ_16M	0xc000	/* 16m dram */
+#define	HIFN_PUCNFG_DSZ_32M	0xe000	/* 32m dram */
+#define	HIFN_PUCNFG_DRAMREFRESH	0x1800	/* DRAM refresh rate mask */
+#define	HIFN_PUCNFG_DRFR_512	0x0000	/* 512 divisor of ECLK */
+#define	HIFN_PUCNFG_DRFR_256	0x0800	/* 256 divisor of ECLK */
+#define	HIFN_PUCNFG_DRFR_128	0x1000	/* 128 divisor of ECLK */
+#define	HIFN_PUCNFG_TCALLPHASES	0x0200	/* your guess is as good as mine... */
+#define	HIFN_PUCNFG_TCDRVTOTEM	0x0100	/* your guess is as good as mine... */
+#define	HIFN_PUCNFG_BIGENDIAN	0x0080	/* DMA big endian mode */
+#define	HIFN_PUCNFG_BUS32	0x0040	/* Bus width 32bits */
+#define	HIFN_PUCNFG_BUS16	0x0000	/* Bus width 16 bits */
+#define	HIFN_PUCNFG_CHIPID	0x0020	/* Allow chipid from PUSTAT */
+#define	HIFN_PUCNFG_DRAM	0x0010	/* Context RAM is DRAM */
+#define	HIFN_PUCNFG_SRAM	0x0000	/* Context RAM is SRAM */
+#define	HIFN_PUCNFG_COMPSING	0x0004	/* Enable single compression context */
+#define	HIFN_PUCNFG_ENCCNFG	0x0002	/* Encryption configuration */
+
+/* Processing Unit Interrupt Enable Register (HIFN_0_PUIER) */
+#define	HIFN_PUIER_CMDINVAL	0x8000	/* Invalid command interrupt */
+#define	HIFN_PUIER_DATAERR	0x4000	/* Data error interrupt */
+#define	HIFN_PUIER_SRCFIFO	0x2000	/* Source FIFO ready interrupt */
+#define	HIFN_PUIER_DSTFIFO	0x1000	/* Destination FIFO ready interrupt */
+#define	HIFN_PUIER_DSTOVER	0x0200	/* Destination overrun interrupt */
+#define	HIFN_PUIER_SRCCMD	0x0080	/* Source command interrupt */
+#define	HIFN_PUIER_SRCCTX	0x0040	/* Source context interrupt */
+#define	HIFN_PUIER_SRCDATA	0x0020	/* Source data interrupt */
+#define	HIFN_PUIER_DSTDATA	0x0010	/* Destination data interrupt */
+#define	HIFN_PUIER_DSTRESULT	0x0004	/* Destination result interrupt */
+
+/* Processing Unit Status Register/Chip ID (HIFN_0_PUSTAT) */
+#define	HIFN_PUSTAT_CMDINVAL	0x8000	/* Invalid command interrupt */
+#define	HIFN_PUSTAT_DATAERR	0x4000	/* Data error interrupt */
+#define	HIFN_PUSTAT_SRCFIFO	0x2000	/* Source FIFO ready interrupt */
+#define	HIFN_PUSTAT_DSTFIFO	0x1000	/* Destination FIFO ready interrupt */
+#define	HIFN_PUSTAT_DSTOVER	0x0200	/* Destination overrun interrupt */
+#define	HIFN_PUSTAT_SRCCMD	0x0080	/* Source command interrupt */
+#define	HIFN_PUSTAT_SRCCTX	0x0040	/* Source context interrupt */
+#define	HIFN_PUSTAT_SRCDATA	0x0020	/* Source data interrupt */
+#define	HIFN_PUSTAT_DSTDATA	0x0010	/* Destination data interrupt */
+#define	HIFN_PUSTAT_DSTRESULT	0x0004	/* Destination result interrupt */
+#define	HIFN_PUSTAT_CHIPREV	0x00ff	/* Chip revision mask */
+#define	HIFN_PUSTAT_CHIPENA	0xff00	/* Chip enabled mask */
+#define	HIFN_PUSTAT_ENA_2	0x1100	/* Level 2 enabled */
+#define	HIFN_PUSTAT_ENA_1	0x1000	/* Level 1 enabled */
+#define	HIFN_PUSTAT_ENA_0	0x3000	/* Level 0 enabled */
+#define	HIFN_PUSTAT_REV_2	0x0020	/* 7751 PT6/2 */
+#define	HIFN_PUSTAT_REV_3	0x0030	/* 7751 PT6/3 */
+
+/* FIFO Status Register (HIFN_0_FIFOSTAT) */
+#define	HIFN_FIFOSTAT_SRC	0x7f00	/* Source FIFO available */
+#define	HIFN_FIFOSTAT_DST	0x007f	/* Destination FIFO available */
+
+/* FIFO Configuration Register (HIFN_0_FIFOCNFG) */
+#define	HIFN_FIFOCNFG_THRESHOLD	0x0400	/* must be written as 1 */
+
+/*
+ * DMA Interface Registers (offset from BASEREG1)
+ */
+#define	HIFN_1_DMA_CRAR		0x0c	/* DMA Command Ring Address */
+#define	HIFN_1_DMA_SRAR		0x1c	/* DMA Source Ring Address */
+#define	HIFN_1_DMA_RRAR		0x2c	/* DMA Result Ring Address */
+#define	HIFN_1_DMA_DRAR		0x3c	/* DMA Destination Ring Address */
+#define	HIFN_1_DMA_CSR		0x40	/* DMA Status and Control */
+#define	HIFN_1_DMA_IER		0x44	/* DMA Interrupt Enable */
+#define	HIFN_1_DMA_CNFG		0x48	/* DMA Configuration */
+#define	HIFN_1_PLL		0x4c	/* 795x: PLL config */
+#define	HIFN_1_7811_RNGENA	0x60	/* 7811: rng enable */
+#define	HIFN_1_7811_RNGCFG	0x64	/* 7811: rng config */
+#define	HIFN_1_7811_RNGDAT	0x68	/* 7811: rng data */
+#define	HIFN_1_7811_RNGSTS	0x6c	/* 7811: rng status */
+#define	HIFN_1_7811_MIPSRST	0x94	/* 7811: MIPS reset */
+#define	HIFN_1_REVID		0x98	/* Revision ID */
+#define	HIFN_1_UNLOCK_SECRET1	0xf4
+#define	HIFN_1_UNLOCK_SECRET2	0xfc
+#define	HIFN_1_PUB_RESET	0x204	/* Public/RNG Reset */
+#define	HIFN_1_PUB_BASE		0x300	/* Public Base Address */
+#define	HIFN_1_PUB_OPLEN	0x304	/* Public Operand Length */
+#define	HIFN_1_PUB_OP		0x308	/* Public Operand */
+#define	HIFN_1_PUB_STATUS	0x30c	/* Public Status */
+#define	HIFN_1_PUB_IEN		0x310	/* Public Interrupt enable */
+#define	HIFN_1_RNG_CONFIG	0x314	/* RNG config */
+#define	HIFN_1_RNG_DATA		0x318	/* RNG data */
+#define	HIFN_1_PUB_MEM		0x400	/* start of Public key memory */
+#define	HIFN_1_PUB_MEMEND	0xbff	/* end of Public key memory */
+
+/* DMA Status and Control Register (HIFN_1_DMA_CSR) */
+#define	HIFN_DMACSR_D_CTRLMASK	0xc0000000	/* Destinition Ring Control */
+#define	HIFN_DMACSR_D_CTRL_NOP	0x00000000	/* Dest. Control: no-op */
+#define	HIFN_DMACSR_D_CTRL_DIS	0x40000000	/* Dest. Control: disable */
+#define	HIFN_DMACSR_D_CTRL_ENA	0x80000000	/* Dest. Control: enable */
+#define	HIFN_DMACSR_D_ABORT	0x20000000	/* Destinition Ring PCIAbort */
+#define	HIFN_DMACSR_D_DONE	0x10000000	/* Destinition Ring Done */
+#define	HIFN_DMACSR_D_LAST	0x08000000	/* Destinition Ring Last */
+#define	HIFN_DMACSR_D_WAIT	0x04000000	/* Destinition Ring Waiting */
+#define	HIFN_DMACSR_D_OVER	0x02000000	/* Destinition Ring Overflow */
+#define	HIFN_DMACSR_R_CTRL	0x00c00000	/* Result Ring Control */
+#define	HIFN_DMACSR_R_CTRL_NOP	0x00000000	/* Result Control: no-op */
+#define	HIFN_DMACSR_R_CTRL_DIS	0x00400000	/* Result Control: disable */
+#define	HIFN_DMACSR_R_CTRL_ENA	0x00800000	/* Result Control: enable */
+#define	HIFN_DMACSR_R_ABORT	0x00200000	/* Result Ring PCI Abort */
+#define	HIFN_DMACSR_R_DONE	0x00100000	/* Result Ring Done */
+#define	HIFN_DMACSR_R_LAST	0x00080000	/* Result Ring Last */
+#define	HIFN_DMACSR_R_WAIT	0x00040000	/* Result Ring Waiting */
+#define	HIFN_DMACSR_R_OVER	0x00020000	/* Result Ring Overflow */
+#define	HIFN_DMACSR_S_CTRL	0x0000c000	/* Source Ring Control */
+#define	HIFN_DMACSR_S_CTRL_NOP	0x00000000	/* Source Control: no-op */
+#define	HIFN_DMACSR_S_CTRL_DIS	0x00004000	/* Source Control: disable */
+#define	HIFN_DMACSR_S_CTRL_ENA	0x00008000	/* Source Control: enable */
+#define	HIFN_DMACSR_S_ABORT	0x00002000	/* Source Ring PCI Abort */
+#define	HIFN_DMACSR_S_DONE	0x00001000	/* Source Ring Done */
+#define	HIFN_DMACSR_S_LAST	0x00000800	/* Source Ring Last */
+#define	HIFN_DMACSR_S_WAIT	0x00000400	/* Source Ring Waiting */
+#define	HIFN_DMACSR_ILLW	0x00000200	/* Illegal write (7811 only) */
+#define	HIFN_DMACSR_ILLR	0x00000100	/* Illegal read (7811 only) */
+#define	HIFN_DMACSR_C_CTRL	0x000000c0	/* Command Ring Control */
+#define	HIFN_DMACSR_C_CTRL_NOP	0x00000000	/* Command Control: no-op */
+#define	HIFN_DMACSR_C_CTRL_DIS	0x00000040	/* Command Control: disable */
+#define	HIFN_DMACSR_C_CTRL_ENA	0x00000080	/* Command Control: enable */
+#define	HIFN_DMACSR_C_ABORT	0x00000020	/* Command Ring PCI Abort */
+#define	HIFN_DMACSR_C_DONE	0x00000010	/* Command Ring Done */
+#define	HIFN_DMACSR_C_LAST	0x00000008	/* Command Ring Last */
+#define	HIFN_DMACSR_C_WAIT	0x00000004	/* Command Ring Waiting */
+#define	HIFN_DMACSR_PUBDONE	0x00000002	/* Public op done (7951 only) */
+#define	HIFN_DMACSR_ENGINE	0x00000001	/* Command Ring Engine IRQ */
+
+/* DMA Interrupt Enable Register (HIFN_1_DMA_IER) */
+#define	HIFN_DMAIER_D_ABORT	0x20000000	/* Destination Ring PCIAbort */
+#define	HIFN_DMAIER_D_DONE	0x10000000	/* Destination Ring Done */
+#define	HIFN_DMAIER_D_LAST	0x08000000	/* Destination Ring Last */
+#define	HIFN_DMAIER_D_WAIT	0x04000000	/* Destination Ring Waiting */
+#define	HIFN_DMAIER_D_OVER	0x02000000	/* Destination Ring Overflow */
+#define	HIFN_DMAIER_R_ABORT	0x00200000	/* Result Ring PCI Abort */
+#define	HIFN_DMAIER_R_DONE	0x00100000	/* Result Ring Done */
+#define	HIFN_DMAIER_R_LAST	0x00080000	/* Result Ring Last */
+#define	HIFN_DMAIER_R_WAIT	0x00040000	/* Result Ring Waiting */
+#define	HIFN_DMAIER_R_OVER	0x00020000	/* Result Ring Overflow */
+#define	HIFN_DMAIER_S_ABORT	0x00002000	/* Source Ring PCI Abort */
+#define	HIFN_DMAIER_S_DONE	0x00001000	/* Source Ring Done */
+#define	HIFN_DMAIER_S_LAST	0x00000800	/* Source Ring Last */
+#define	HIFN_DMAIER_S_WAIT	0x00000400	/* Source Ring Waiting */
+#define	HIFN_DMAIER_ILLW	0x00000200	/* Illegal write (7811 only) */
+#define	HIFN_DMAIER_ILLR	0x00000100	/* Illegal read (7811 only) */
+#define	HIFN_DMAIER_C_ABORT	0x00000020	/* Command Ring PCI Abort */
+#define	HIFN_DMAIER_C_DONE	0x00000010	/* Command Ring Done */
+#define	HIFN_DMAIER_C_LAST	0x00000008	/* Command Ring Last */
+#define	HIFN_DMAIER_C_WAIT	0x00000004	/* Command Ring Waiting */
+#define	HIFN_DMAIER_PUBDONE	0x00000002	/* public op done (7951 only) */
+#define	HIFN_DMAIER_ENGINE	0x00000001	/* Engine IRQ */
+
+/* DMA Configuration Register (HIFN_1_DMA_CNFG) */
+#define	HIFN_DMACNFG_BIGENDIAN	0x10000000	/* big endian mode */
+#define	HIFN_DMACNFG_POLLFREQ	0x00ff0000	/* Poll frequency mask */
+#define	HIFN_DMACNFG_UNLOCK	0x00000800
+#define	HIFN_DMACNFG_POLLINVAL	0x00000700	/* Invalid Poll Scalar */
+#define	HIFN_DMACNFG_LAST	0x00000010	/* Host control LAST bit */
+#define	HIFN_DMACNFG_MODE	0x00000004	/* DMA mode */
+#define	HIFN_DMACNFG_DMARESET	0x00000002	/* DMA Reset # */
+#define	HIFN_DMACNFG_MSTRESET	0x00000001	/* Master Reset # */
+
+#define	HIFN_PLL_7956		0x00001d18	/* 7956 PLL config value */
+
+/* Public key reset register (HIFN_1_PUB_RESET) */
+#define	HIFN_PUBRST_RESET	0x00000001	/* reset public/rng unit */
+
+/* Public base address register (HIFN_1_PUB_BASE) */
+#define	HIFN_PUBBASE_ADDR	0x00003fff	/* base address */
+
+/* Public operand length register (HIFN_1_PUB_OPLEN) */
+#define	HIFN_PUBOPLEN_MOD_M	0x0000007f	/* modulus length mask */
+#define	HIFN_PUBOPLEN_MOD_S	0		/* modulus length shift */
+#define	HIFN_PUBOPLEN_EXP_M	0x0003ff80	/* exponent length mask */
+#define	HIFN_PUBOPLEN_EXP_S	7		/* exponent lenght shift */
+#define	HIFN_PUBOPLEN_RED_M	0x003c0000	/* reducend length mask */
+#define	HIFN_PUBOPLEN_RED_S	18		/* reducend length shift */
+
+/* Public operation register (HIFN_1_PUB_OP) */
+#define	HIFN_PUBOP_AOFFSET_M	0x0000007f	/* A offset mask */
+#define	HIFN_PUBOP_AOFFSET_S	0		/* A offset shift */
+#define	HIFN_PUBOP_BOFFSET_M	0x00000f80	/* B offset mask */
+#define	HIFN_PUBOP_BOFFSET_S	7		/* B offset shift */
+#define	HIFN_PUBOP_MOFFSET_M	0x0003f000	/* M offset mask */
+#define	HIFN_PUBOP_MOFFSET_S	12		/* M offset shift */
+#define	HIFN_PUBOP_OP_MASK	0x003c0000	/* Opcode: */
+#define	HIFN_PUBOP_OP_NOP	0x00000000	/*  NOP */
+#define	HIFN_PUBOP_OP_ADD	0x00040000	/*  ADD */
+#define	HIFN_PUBOP_OP_ADDC	0x00080000	/*  ADD w/carry */
+#define	HIFN_PUBOP_OP_SUB	0x000c0000	/*  SUB */
+#define	HIFN_PUBOP_OP_SUBC	0x00100000	/*  SUB w/carry */
+#define	HIFN_PUBOP_OP_MODADD	0x00140000	/*  Modular ADD */
+#define	HIFN_PUBOP_OP_MODSUB	0x00180000	/*  Modular SUB */
+#define	HIFN_PUBOP_OP_INCA	0x001c0000	/*  INC A */
+#define	HIFN_PUBOP_OP_DECA	0x00200000	/*  DEC A */
+#define	HIFN_PUBOP_OP_MULT	0x00240000	/*  MULT */
+#define	HIFN_PUBOP_OP_MODMULT	0x00280000	/*  Modular MULT */
+#define	HIFN_PUBOP_OP_MODRED	0x002c0000	/*  Modular RED */
+#define	HIFN_PUBOP_OP_MODEXP	0x00300000	/*  Modular EXP */
+
+/* Public status register (HIFN_1_PUB_STATUS) */
+#define	HIFN_PUBSTS_DONE	0x00000001	/* operation done */
+#define	HIFN_PUBSTS_CARRY	0x00000002	/* carry */
+
+/* Public interrupt enable register (HIFN_1_PUB_IEN) */
+#define	HIFN_PUBIEN_DONE	0x00000001	/* operation done interrupt */
+
+/* Random number generator config register (HIFN_1_RNG_CONFIG) */
+#define	HIFN_RNGCFG_ENA		0x00000001	/* enable rng */
+
+
+#define HIFN_NAMESIZE			32
+#define HIFN_MAX_RESULT_ORDER		5
+
+#define	HIFN_D_CMD_RSIZE		24*4
+#define	HIFN_D_SRC_RSIZE		80*4
+#define	HIFN_D_DST_RSIZE		80*4
+#define	HIFN_D_RES_RSIZE		24*4
+
+#define HIFN_QUEUE_LENGTH		HIFN_D_CMD_RSIZE-5
+
+
+#define AES_MIN_KEY_SIZE		16
+#define AES_MAX_KEY_SIZE		32
+
+#define HIFN_DES_KEY_LENGTH		8
+#define HIFN_3DES_KEY_LENGTH		24
+#define HIFN_MAX_CRYPT_KEY_LENGTH	AES_MAX_KEY_SIZE
+#define HIFN_IV_LENGTH			8
+#define HIFN_AES_IV_LENGTH		16
+#define	HIFN_MAX_IV_LENGTH		HIFN_AES_IV_LENGTH
+
+#define HIFN_MAC_KEY_LENGTH		64
+#define HIFN_MD5_LENGTH			16
+#define HIFN_SHA1_LENGTH		20
+#define HIFN_MAC_TRUNC_LENGTH		12
+
+#define	HIFN_MAX_COMMAND	(8 + 8 + 8 + 64 + 260)
+#define	HIFN_MAX_RESULT		(8 + 4 + 4 + 20 + 4)
+
+struct hifn_desc
+{
+	volatile u32		l;
+	volatile u32		p;
+};
+
+struct hifn_dma {
+	struct hifn_desc	cmdr[HIFN_D_CMD_RSIZE+1];
+	struct hifn_desc	srcr[HIFN_D_SRC_RSIZE+1];
+	struct hifn_desc	dstr[HIFN_D_DST_RSIZE+1];
+	struct hifn_desc	resr[HIFN_D_RES_RSIZE+1];
+
+	u8			command_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_COMMAND];
+	u8			result_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_RESULT];
+
+	u64			test_src, test_dst;
+
+	/*
+	 *  Our current positions for insertion and removal from the descriptor
+	 *  rings. 
+	 */
+	volatile int		cmdi, srci, dsti, resi;
+	volatile int		cmdu, srcu, dstu, resu;
+	int			cmdk, srck, dstk, resk;
+};
+
+#define HIFN_FLAG_CMD_BUSY	(1<<0)
+#define HIFN_FLAG_SRC_BUSY	(1<<1)
+#define HIFN_FLAG_DST_BUSY	(1<<2)
+#define HIFN_FLAG_RES_BUSY	(1<<3)
+#define HIFN_FLAG_OLD_KEY	(1<<4)
+
+struct hifn_device
+{
+	char			name[HIFN_NAMESIZE];
+
+	int			irq;
+	
+	struct pci_dev		*pdev;
+	void __iomem		*bar[3];
+	
+	unsigned long		result_mem;
+	dma_addr_t		dst;
+
+	void			*desc_virt;
+	dma_addr_t		desc_dma;
+
+	u32			dmareg;
+
+	void 			*sa[HIFN_D_RES_RSIZE];
+
+	u32			ram_size;
+	u32			max_sessions;
+
+	spinlock_t		lock;
+	
+	void 			*priv;
+
+	u32			flags;
+	int			active;
+	struct delayed_work	work;
+	unsigned long		waiting;
+	unsigned long		reset;
+	unsigned long		intr;
+	unsigned long		success;
+	unsigned long		prev_success;
+	unsigned long		dequeue_failed;
+	unsigned long		break_session;
+
+	int			started;
+
+	u8			snum;
+	u8			current_key[HIFN_MAX_CRYPT_KEY_LENGTH];
+	int			current_key_len;
+	
+	struct list_head	alg_list;
+};
+
+#define	HIFN_D_LENGTH			0x0000ffff
+#define	HIFN_D_NOINVALID		0x01000000
+#define	HIFN_D_MASKDONEIRQ		0x02000000
+#define	HIFN_D_DESTOVER			0x04000000
+#define	HIFN_D_OVER			0x08000000
+#define	HIFN_D_LAST			0x20000000
+#define	HIFN_D_JUMP			0x40000000
+#define	HIFN_D_VALID			0x80000000
+
+struct hifn_base_command
+{
+	volatile u16		masks;
+	volatile u16		session_num;
+	volatile u16		total_source_count;
+	volatile u16		total_dest_count;
+};
+
+#define	HIFN_BASE_CMD_COMP		0x0100	/* enable compression engine */
+#define	HIFN_BASE_CMD_PAD		0x0200	/* enable padding engine */
+#define	HIFN_BASE_CMD_MAC		0x0400	/* enable MAC engine */
+#define	HIFN_BASE_CMD_CRYPT		0x0800	/* enable crypt engine */
+#define	HIFN_BASE_CMD_DECODE		0x2000
+#define	HIFN_BASE_CMD_SRCLEN_M		0xc000
+#define	HIFN_BASE_CMD_SRCLEN_S		14
+#define	HIFN_BASE_CMD_DSTLEN_M		0x3000
+#define	HIFN_BASE_CMD_DSTLEN_S		12
+#define	HIFN_BASE_CMD_LENMASK_HI	0x30000
+#define	HIFN_BASE_CMD_LENMASK_LO	0x0ffff
+
+/*
+ * Structure to help build up the command data structure.
+ */
+struct hifn_crypt_command 
+{
+	volatile u16 		masks;
+	volatile u16 		header_skip;
+	volatile u16 		source_count;
+	volatile u16 		reserved;
+};
+
+#define	HIFN_CRYPT_CMD_ALG_MASK		0x0003		/* algorithm: */
+#define	HIFN_CRYPT_CMD_ALG_DES		0x0000		/*   DES */
+#define	HIFN_CRYPT_CMD_ALG_3DES		0x0001		/*   3DES */
+#define	HIFN_CRYPT_CMD_ALG_RC4		0x0002		/*   RC4 */
+#define	HIFN_CRYPT_CMD_ALG_AES		0x0003		/*   AES */
+#define	HIFN_CRYPT_CMD_MODE_MASK	0x0018		/* Encrypt mode: */
+#define	HIFN_CRYPT_CMD_MODE_ECB		0x0000		/*   ECB */
+#define	HIFN_CRYPT_CMD_MODE_CBC		0x0008		/*   CBC */
+#define	HIFN_CRYPT_CMD_MODE_CFB		0x0010		/*   CFB */
+#define	HIFN_CRYPT_CMD_MODE_OFB		0x0018		/*   OFB */
+#define	HIFN_CRYPT_CMD_CLR_CTX		0x0040		/* clear context */
+#define	HIFN_CRYPT_CMD_KSZ_MASK		0x0600		/* AES key size: */
+#define	HIFN_CRYPT_CMD_KSZ_128		0x0000		/*  128 bit */
+#define	HIFN_CRYPT_CMD_KSZ_192		0x0200		/*  192 bit */
+#define	HIFN_CRYPT_CMD_KSZ_256		0x0400		/*  256 bit */
+#define	HIFN_CRYPT_CMD_NEW_KEY		0x0800		/* expect new key */
+#define	HIFN_CRYPT_CMD_NEW_IV		0x1000		/* expect new iv */
+#define	HIFN_CRYPT_CMD_SRCLEN_M		0xc000
+#define	HIFN_CRYPT_CMD_SRCLEN_S		14
+
+/*
+ * Structure to help build up the command data structure.
+ */
+struct hifn_mac_command 
+{
+	volatile u16 		masks;
+	volatile u16 		header_skip;
+	volatile u16 		source_count;
+	volatile u16 		reserved;
+};
+
+#define	HIFN_MAC_CMD_ALG_MASK		0x0001
+#define	HIFN_MAC_CMD_ALG_SHA1		0x0000
+#define	HIFN_MAC_CMD_ALG_MD5		0x0001
+#define	HIFN_MAC_CMD_MODE_MASK		0x000c
+#define	HIFN_MAC_CMD_MODE_HMAC		0x0000
+#define	HIFN_MAC_CMD_MODE_SSL_MAC	0x0004
+#define	HIFN_MAC_CMD_MODE_HASH		0x0008
+#define	HIFN_MAC_CMD_MODE_FULL		0x0004
+#define	HIFN_MAC_CMD_TRUNC		0x0010
+#define	HIFN_MAC_CMD_RESULT		0x0020
+#define	HIFN_MAC_CMD_APPEND		0x0040
+#define	HIFN_MAC_CMD_SRCLEN_M		0xc000
+#define	HIFN_MAC_CMD_SRCLEN_S		14
+
+/*
+ * MAC POS IPsec initiates authentication after encryption on encodes
+ * and before decryption on decodes.
+ */
+#define	HIFN_MAC_CMD_POS_IPSEC		0x0200
+#define	HIFN_MAC_CMD_NEW_KEY		0x0800
+
+struct hifn_comp_command 
+{
+	volatile u16 		masks;
+	volatile u16 		header_skip;
+	volatile u16 		source_count;
+	volatile u16 		reserved;
+};
+
+#define	HIFN_COMP_CMD_SRCLEN_M		0xc000
+#define	HIFN_COMP_CMD_SRCLEN_S		14
+#define	HIFN_COMP_CMD_ONE		0x0100	/* must be one */
+#define	HIFN_COMP_CMD_CLEARHIST		0x0010	/* clear history */
+#define	HIFN_COMP_CMD_UPDATEHIST	0x0008	/* update history */
+#define	HIFN_COMP_CMD_LZS_STRIP0	0x0004	/* LZS: strip zero */
+#define	HIFN_COMP_CMD_MPPC_RESTART	0x0004	/* MPPC: restart */
+#define	HIFN_COMP_CMD_ALG_MASK		0x0001	/* compression mode: */
+#define	HIFN_COMP_CMD_ALG_MPPC		0x0001	/*   MPPC */
+#define	HIFN_COMP_CMD_ALG_LZS		0x0000	/*   LZS */
+
+struct hifn_base_result 
+{
+	volatile u16 		flags;
+	volatile u16 		session;
+	volatile u16 		src_cnt;		/* 15:0 of source count */
+	volatile u16 		dst_cnt;		/* 15:0 of dest count */
+};
+
+#define	HIFN_BASE_RES_DSTOVERRUN	0x0200	/* destination overrun */
+#define	HIFN_BASE_RES_SRCLEN_M		0xc000	/* 17:16 of source count */
+#define	HIFN_BASE_RES_SRCLEN_S		14
+#define	HIFN_BASE_RES_DSTLEN_M		0x3000	/* 17:16 of dest count */
+#define	HIFN_BASE_RES_DSTLEN_S		12
+
+struct hifn_comp_result 
+{
+	volatile u16 		flags;
+	volatile u16 		crc;
+};
+
+#define	HIFN_COMP_RES_LCB_M		0xff00	/* longitudinal check byte */
+#define	HIFN_COMP_RES_LCB_S		8
+#define	HIFN_COMP_RES_RESTART		0x0004	/* MPPC: restart */
+#define	HIFN_COMP_RES_ENDMARKER		0x0002	/* LZS: end marker seen */
+#define	HIFN_COMP_RES_SRC_NOTZERO	0x0001	/* source expired */
+
+struct hifn_mac_result 
+{
+	volatile u16 		flags;
+	volatile u16 		reserved;
+	/* followed by 0, 6, 8, or 10 u16's of the MAC, then crypt */
+};
+
+#define	HIFN_MAC_RES_MISCOMPARE		0x0002	/* compare failed */
+#define	HIFN_MAC_RES_SRC_NOTZERO	0x0001	/* source expired */
+
+struct hifn_crypt_result 
+{
+	volatile u16 		flags;
+	volatile u16 		reserved;
+};
+
+#define	HIFN_CRYPT_RES_SRC_NOTZERO	0x0001	/* source expired */
+
+#ifndef HIFN_POLL_FREQUENCY
+#define	HIFN_POLL_FREQUENCY	0x1
+#endif
+
+#ifndef HIFN_POLL_SCALAR
+#define	HIFN_POLL_SCALAR	0x0
+#endif
+
+#define	HIFN_MAX_SEGLEN 	0xffff		/* maximum dma segment len */
+#define	HIFN_MAX_DMALEN		0x3ffff		/* maximum dma length */
+
+static inline u32 hifn_read_0(struct hifn_device *dev, u32 reg)
+{
+	u32 ret;
+
+	ret = readl((char *)(dev->bar[0]) + reg);
+
+	return ret;
+}
+
+static inline u32 hifn_read_1(struct hifn_device *dev, u32 reg)
+{
+	u32 ret;
+
+	ret = readl((char *)(dev->bar[1]) + reg);
+
+	return ret;
+}
+
+static inline void hifn_write_0(struct hifn_device *dev, u32 reg, u32 val)
+{
+	writel(val, (char *)(dev->bar[0]) + reg);
+}
+
+static inline void hifn_write_1(struct hifn_device *dev, u32 reg, u32 val)
+{
+	writel(val, (char *)(dev->bar[1]) + reg);
+}
+
+#if 0
+static void hifn_dump_ring(char *str, struct hifn_device *dev)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	dma_addr_t dptr = dev->desc_dma;
+
+	dprintk("%4d cmdr: %08x %d\n", 
+			dma->cmdi,
+			hifn_read_1(dev, HIFN_1_DMA_CRAR), 
+			(hifn_read_1(dev, HIFN_1_DMA_CRAR) - 
+			 	__cpu_to_le32(dptr + offsetof(struct hifn_dma, cmdr[0])))/sizeof(struct hifn_desc));
+	dprintk("%4d srcr: %08x %d\n", 
+			dma->srci,
+			hifn_read_1(dev, HIFN_1_DMA_SRAR), 
+			(hifn_read_1(dev, HIFN_1_DMA_SRAR) - 
+			 	__cpu_to_le32(dptr + offsetof(struct hifn_dma, srcr[0])))/sizeof(struct hifn_desc));
+	dprintk("%4d dstr: %08x %d\n", 
+			dma->dsti,
+			hifn_read_1(dev, HIFN_1_DMA_DRAR), 
+			(hifn_read_1(dev, HIFN_1_DMA_DRAR) - 
+			 	__cpu_to_le32(dptr + offsetof(struct hifn_dma, dstr[0])))/sizeof(struct hifn_desc));
+	dprintk("%4d resr: %08x %d\n", 
+			dma->resi,
+			hifn_read_1(dev, HIFN_1_DMA_RRAR), 
+			(hifn_read_1(dev, HIFN_1_DMA_RRAR) - 
+			 	__cpu_to_le32(dptr + offsetof(struct hifn_dma, resr[0])))/sizeof(struct hifn_desc));
+}
+#endif
+
+static void hifn_wait_puc(struct hifn_device *dev)
+{
+	int i;
+	u32 ret;
+
+	for (i=10000; i > 0; --i) {
+		ret = hifn_read_0(dev, HIFN_0_PUCTRL);
+		if (!(ret & HIFN_PUCTRL_RESET))
+			break;
+
+		udelay(1);
+	}
+
+	if (!i)
+		dprintk("%s: Failed to reset PUC unit.\n", dev->name);
+}
+
+static void hifn_reset_puc(struct hifn_device *dev)
+{
+	hifn_write_0(dev, HIFN_0_PUCTRL, HIFN_PUCTRL_DMAENA);
+	hifn_wait_puc(dev);
+}
+
+static void hifn_stop_device(struct hifn_device *dev)
+{
+	hifn_write_1(dev, HIFN_1_DMA_CSR,
+		HIFN_DMACSR_D_CTRL_DIS | HIFN_DMACSR_R_CTRL_DIS |
+		HIFN_DMACSR_S_CTRL_DIS | HIFN_DMACSR_C_CTRL_DIS);
+	hifn_write_0(dev, HIFN_0_PUIER, 0);
+	hifn_write_1(dev, HIFN_1_DMA_IER, 0);
+}
+
+static void hifn_reset_dma(struct hifn_device *dev, int full)
+{
+	hifn_stop_device(dev);
+	
+	/*
+	 * Setting poll frequency and others to 0.
+	 */
+	hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MSTRESET | HIFN_DMACNFG_DMARESET | HIFN_DMACNFG_MODE);
+	mdelay(1);
+
+	/*
+	 * Reset DMA.
+	 */
+	if (full) {
+		hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MODE);
+		mdelay(1);
+	} else {
+		hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MODE | HIFN_DMACNFG_MSTRESET);
+		hifn_reset_puc(dev);
+	}
+
+	hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MSTRESET | HIFN_DMACNFG_DMARESET | HIFN_DMACNFG_MODE);
+
+	hifn_reset_puc(dev);
+}
+
+static u32 hifn_next_signature(u_int32_t a, u_int cnt)
+{
+	int i;
+	u32 v;
+
+	for (i = 0; i < cnt; i++) {
+
+		/* get the parity */
+		v = a & 0x80080125;
+		v ^= v >> 16;
+		v ^= v >> 8;
+		v ^= v >> 4;
+		v ^= v >> 2;
+		v ^= v >> 1;
+
+		a = (v & 1) ^ (a << 1);
+	}
+
+	return a;
+}
+
+static struct pci2id {
+	u_short		pci_vendor;
+	u_short		pci_prod;
+	char		card_id[13];
+} pci2id[] = {
+	{
+		PCI_VENDOR_ID_HIFN,
+		PCI_DEVICE_ID_HIFN_7955,
+		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		  0x00, 0x00, 0x00, 0x00, 0x00 }
+	}, 
+	{
+		PCI_VENDOR_ID_HIFN,
+		PCI_DEVICE_ID_HIFN_7956,
+		{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		  0x00, 0x00, 0x00, 0x00, 0x00 }
+	}
+};
+
+static int hifn_init_pubrng(struct hifn_device *dev)
+{
+	int i;
+	
+	hifn_write_1(dev, HIFN_1_PUB_RESET, hifn_read_1(dev, HIFN_1_PUB_RESET) | HIFN_PUBRST_RESET);
+
+	for (i=100; i > 0; --i) {
+		mdelay(1);
+
+		if ((hifn_read_1(dev, HIFN_1_PUB_RESET) & HIFN_PUBRST_RESET) == 0)
+			break;
+	}
+
+	if (!i)
+		dprintk("Chip %s: Failed to initialise public key engine.\n", dev->name);
+	else {
+		hifn_write_1(dev, HIFN_1_PUB_IEN, HIFN_PUBIEN_DONE);
+		dev->dmareg |= HIFN_DMAIER_PUBDONE;
+		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
+
+		dprintk("Chip %s: Public key engine has been sucessfully initialised.\n", dev->name);
+	}
+
+	/*
+	 * Enable RNG engine.
+	 */
+
+	hifn_write_1(dev, HIFN_1_RNG_CONFIG, hifn_read_1(dev, HIFN_1_RNG_CONFIG) | HIFN_RNGCFG_ENA);
+	dprintk("Chip %s: RNG engine has been successfully initialised.\n", dev->name);
+
+	return 0;
+}
+
+static int hifn_enable_crypto(struct hifn_device *dev)
+{
+	u32 dmacfg, addr;
+	char *offtbl = NULL;
+	int i;
+	
+	for (i = 0; i < sizeof(pci2id)/sizeof(pci2id[0]); i++) {
+		if (pci2id[i].pci_vendor == dev->pdev->vendor && 
+				pci2id[i].pci_prod == dev->pdev->device) {
+			offtbl = pci2id[i].card_id;
+			break;
+		}
+	}
+
+	if (offtbl == NULL) {
+		dprintk("Chip %s: Unknown card!\n", dev->name);
+		return -ENODEV;
+	}
+
+	dmacfg = hifn_read_1(dev, HIFN_1_DMA_CNFG);
+
+	hifn_write_1(dev, HIFN_1_DMA_CNFG, 
+			HIFN_DMACNFG_UNLOCK | HIFN_DMACNFG_MSTRESET | 
+			HIFN_DMACNFG_DMARESET | HIFN_DMACNFG_MODE);
+	mdelay(1);
+	addr = hifn_read_1(dev, HIFN_1_UNLOCK_SECRET1);
+	mdelay(1);
+	hifn_write_1(dev, HIFN_1_UNLOCK_SECRET2, 0);
+	mdelay(1);
+
+	for (i=0; i<12; ++i) {
+		addr = hifn_next_signature(addr, offtbl[i] + 0x101);
+		hifn_write_1(dev, HIFN_1_UNLOCK_SECRET2, addr);
+
+		mdelay(1);
+	}
+	hifn_write_1(dev, HIFN_1_DMA_CNFG, dmacfg);
+	
+	dprintk("Chip %s: %s.\n", dev->name, pci_name(dev->pdev));
+
+	return 0;
+}
+
+static void hifn_init_dma(struct hifn_device *dev)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	u32 dptr = dev->desc_dma;
+	int i;
+
+	for (i=0; i<HIFN_D_CMD_RSIZE; ++i)
+		dma->cmdr[i].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, command_bufs[i][0]));
+	for (i=0; i<HIFN_D_RES_RSIZE; ++i)
+		dma->resr[i].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, result_bufs[i][0]));
+
+	/*
+	 * Setup LAST descriptors.
+	 */
+	dma->cmdr[HIFN_D_CMD_RSIZE].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, cmdr[0]));
+	dma->srcr[HIFN_D_SRC_RSIZE].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, srcr[0]));
+	dma->dstr[HIFN_D_DST_RSIZE].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, dstr[0]));
+	dma->resr[HIFN_D_RES_RSIZE].p = __cpu_to_le32(dptr + offsetof(struct hifn_dma, resr[0]));
+	
+	dma->cmdu = dma->srcu = dma->dstu = dma->resu = 0;
+	dma->cmdi = dma->srci = dma->dsti = dma->resi = 0;
+	dma->cmdk = dma->srck = dma->dstk = dma->resk = 0;
+}
+
+static void hifn_init_registers(struct hifn_device *dev)
+{
+	u32 dptr = dev->desc_dma;
+	
+	/* Initialization magic... */
+	hifn_write_0(dev, HIFN_0_PUCTRL, HIFN_PUCTRL_DMAENA);
+	hifn_write_0(dev, HIFN_0_FIFOCNFG, HIFN_FIFOCNFG_THRESHOLD);
+	hifn_write_0(dev, HIFN_0_PUIER, HIFN_PUIER_DSTOVER);
+
+	/* write all 4 ring address registers */
+	hifn_write_1(dev, HIFN_1_DMA_CRAR, __cpu_to_le32(dptr + offsetof(struct hifn_dma, cmdr[0])));
+	hifn_write_1(dev, HIFN_1_DMA_SRAR, __cpu_to_le32(dptr + offsetof(struct hifn_dma, srcr[0])));
+	hifn_write_1(dev, HIFN_1_DMA_DRAR, __cpu_to_le32(dptr + offsetof(struct hifn_dma, dstr[0])));
+	hifn_write_1(dev, HIFN_1_DMA_RRAR, __cpu_to_le32(dptr + offsetof(struct hifn_dma, resr[0])));
+
+	mdelay(2);
+#if 0	
+	hifn_write_1(dev, HIFN_1_DMA_CSR,
+	    HIFN_DMACSR_D_CTRL_DIS | HIFN_DMACSR_R_CTRL_DIS |
+	    HIFN_DMACSR_S_CTRL_DIS | HIFN_DMACSR_C_CTRL_DIS |
+	    HIFN_DMACSR_D_ABORT | HIFN_DMACSR_D_DONE | HIFN_DMACSR_D_LAST |
+	    HIFN_DMACSR_D_WAIT | HIFN_DMACSR_D_OVER |
+	    HIFN_DMACSR_R_ABORT | HIFN_DMACSR_R_DONE | HIFN_DMACSR_R_LAST |
+	    HIFN_DMACSR_R_WAIT | HIFN_DMACSR_R_OVER |
+	    HIFN_DMACSR_S_ABORT | HIFN_DMACSR_S_DONE | HIFN_DMACSR_S_LAST |
+	    HIFN_DMACSR_S_WAIT |
+	    HIFN_DMACSR_C_ABORT | HIFN_DMACSR_C_DONE | HIFN_DMACSR_C_LAST |
+	    HIFN_DMACSR_C_WAIT |
+	    HIFN_DMACSR_ENGINE | 
+	    HIFN_DMACSR_PUBDONE);
+#else
+	hifn_write_1(dev, HIFN_1_DMA_CSR,
+	    HIFN_DMACSR_C_CTRL_ENA | HIFN_DMACSR_S_CTRL_ENA |
+	    HIFN_DMACSR_D_CTRL_ENA | HIFN_DMACSR_R_CTRL_ENA |
+	    HIFN_DMACSR_D_ABORT | HIFN_DMACSR_D_DONE | HIFN_DMACSR_D_LAST |
+	    HIFN_DMACSR_D_WAIT | HIFN_DMACSR_D_OVER |
+	    HIFN_DMACSR_R_ABORT | HIFN_DMACSR_R_DONE | HIFN_DMACSR_R_LAST |
+	    HIFN_DMACSR_R_WAIT | HIFN_DMACSR_R_OVER |
+	    HIFN_DMACSR_S_ABORT | HIFN_DMACSR_S_DONE | HIFN_DMACSR_S_LAST |
+	    HIFN_DMACSR_S_WAIT |
+	    HIFN_DMACSR_C_ABORT | HIFN_DMACSR_C_DONE | HIFN_DMACSR_C_LAST |
+	    HIFN_DMACSR_C_WAIT |
+	    HIFN_DMACSR_ENGINE | 
+	    HIFN_DMACSR_PUBDONE);
+#endif
+	hifn_read_1(dev, HIFN_1_DMA_CSR);
+
+	dev->dmareg |= HIFN_DMAIER_R_DONE | HIFN_DMAIER_C_ABORT |
+	    HIFN_DMAIER_D_OVER | HIFN_DMAIER_R_OVER |
+	    HIFN_DMAIER_S_ABORT | HIFN_DMAIER_D_ABORT | HIFN_DMAIER_R_ABORT |
+	    HIFN_DMAIER_ENGINE;
+	dev->dmareg &= ~HIFN_DMAIER_C_WAIT;
+
+	hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
+	hifn_read_1(dev, HIFN_1_DMA_IER);
+#if 0	
+	hifn_write_0(dev, HIFN_0_PUCNFG, HIFN_PUCNFG_ENCCNFG |
+		    HIFN_PUCNFG_DRFR_128 | HIFN_PUCNFG_TCALLPHASES |
+		    HIFN_PUCNFG_TCDRVTOTEM | HIFN_PUCNFG_BUS32 |
+		    HIFN_PUCNFG_DRAM);
+#else
+	hifn_write_0(dev, HIFN_0_PUCNFG, 0x10342);
+#endif
+	hifn_write_1(dev, HIFN_1_PLL, HIFN_PLL_7956);
+	
+	hifn_write_0(dev, HIFN_0_PUISR, HIFN_PUISR_DSTOVER);
+	hifn_write_1(dev, HIFN_1_DMA_CNFG, HIFN_DMACNFG_MSTRESET |
+	    HIFN_DMACNFG_DMARESET | HIFN_DMACNFG_MODE | HIFN_DMACNFG_LAST |
+	    ((HIFN_POLL_FREQUENCY << 16 ) & HIFN_DMACNFG_POLLFREQ) |
+	    ((HIFN_POLL_SCALAR << 8) & HIFN_DMACNFG_POLLINVAL));
+}
+
+static void hifn_init_sessions(struct hifn_device *dev)
+{
+	u32 pucnfg;
+	u32 ctxsize = 1;
+
+	pucnfg = hifn_read_0(dev, HIFN_0_PUCNFG);
+	
+	if (pucnfg & HIFN_PUCNFG_COMPSING) {
+		if (pucnfg & HIFN_PUCNFG_ENCCNFG)
+			ctxsize = 128;
+		else
+			ctxsize = 512;
+		
+		dev->max_sessions = dev->ram_size / ctxsize;
+	} else
+		dev->max_sessions = dev->ram_size / 16384;
+	
+	dprintk("Chip %s: ram size=%uK, max_sessions=%u.\n", 
+			dev->name, dev->ram_size / 1024,
+			dev->max_sessions);
+}
+
+static int hifn_setup_base_command(struct hifn_device *dev, u8 *buf, u16 dlen, u16 slen, u16 mask, u8 snum)
+{
+	struct hifn_base_command *base_cmd;
+	u8 *buf_pos = buf;
+	
+	base_cmd = (struct hifn_base_command *)buf_pos;
+	base_cmd->masks = __cpu_to_le16(mask);
+	base_cmd->total_source_count = __cpu_to_le16(slen & HIFN_BASE_CMD_LENMASK_LO);
+	base_cmd->total_dest_count = __cpu_to_le16(dlen & HIFN_BASE_CMD_LENMASK_LO);
+
+	dlen >>= 16;
+	slen >>= 16;
+	base_cmd->session_num = __cpu_to_le16(snum | 
+	    ((slen << HIFN_BASE_CMD_SRCLEN_S) & HIFN_BASE_CMD_SRCLEN_M) |
+	    ((dlen << HIFN_BASE_CMD_DSTLEN_S) & HIFN_BASE_CMD_DSTLEN_M));
+
+	return sizeof(struct hifn_base_command);
+}
+
+static int hifn_setup_crypto_command(struct hifn_device *dev, 
+		u8 *buf, u16 dlen, u16 slen, 
+		u8 *key, int keylen, u8 *iv, int ivlen, u16 mode)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	struct hifn_crypt_command *cry_cmd;
+	u8 *buf_pos = buf;
+	u16 cmd_len;
+
+	cry_cmd = (struct hifn_crypt_command *)buf_pos;
+
+	cry_cmd->source_count = __cpu_to_le16(dlen & 0xffff);
+	dlen >>= 16;
+	cry_cmd->masks = __cpu_to_le16(mode | ((dlen << HIFN_CRYPT_CMD_SRCLEN_S) & HIFN_CRYPT_CMD_SRCLEN_M));
+	cry_cmd->header_skip = 0;
+	cry_cmd->reserved = 0;
+
+	buf_pos += sizeof(struct hifn_crypt_command);
+
+	dma->cmdu++;
+	if (dma->cmdu > 1) {
+		dev->dmareg |= HIFN_DMAIER_C_WAIT;
+		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
+	}
+
+	if (keylen) {
+		memcpy(buf_pos, key, keylen);
+		buf_pos += keylen;
+	}
+	if (ivlen) {
+		memcpy(buf_pos, iv, ivlen);
+		buf_pos += ivlen;
+	}
+
+	cmd_len = buf_pos - buf;
+
+	return cmd_len;
+}
+
+static int hifn_setup_src_desc(struct hifn_device *dev, struct scatterlist *sg, int nents)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int i, mapped_nsg, idx, nbytes;
+	u32 last = 0;
+	
+	mapped_nsg = pci_map_sg(dev->pdev, sg, nents, PCI_DMA_TODEVICE);
+	
+	idx = dma->srci;
+
+	nbytes = 0;
+	for (i=0; i<mapped_nsg; ++i) {
+		if (i == mapped_nsg - 1)
+			last = HIFN_D_LAST;
+		
+		dma->srcr[idx].p = __cpu_to_le32(sg_dma_address(&sg[i]));
+		dma->srcr[idx].l = __cpu_to_le32(sg_dma_len(&sg[i]) | HIFN_D_VALID | 
+				HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | last);
+		
+		if (++idx == HIFN_D_SRC_RSIZE) {
+			dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID | HIFN_D_JUMP | HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+			idx = 0;
+		}
+
+		nbytes += sg_dma_len(&sg[i]);
+	}
+		
+	dma->srci = idx;
+	dma->srcu += mapped_nsg;
+
+	if (!(dev->flags & HIFN_FLAG_SRC_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_S_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_SRC_BUSY;
+	}
+	
+	return nbytes;
+}
+
+static void hifn_setup_res_desc(struct hifn_device *dev)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	
+	dma->resr[dma->resi].l = __cpu_to_le32(12 | HIFN_D_VALID | HIFN_D_LAST);
+	//dma->resr[dma->resi].l = __cpu_to_le32(HIFN_MAX_RESULT | HIFN_D_VALID | HIFN_D_LAST | HIFN_D_NOINVALID);
+	
+	if (++dma->resi == HIFN_D_RES_RSIZE) {
+		dma->resr[HIFN_D_RES_RSIZE].l = __cpu_to_le32(HIFN_D_VALID | HIFN_D_JUMP | HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+		dma->resi = 0;
+	}
+	
+	dma->resu++;
+
+	if (!(dev->flags & HIFN_FLAG_RES_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_R_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_RES_BUSY;
+	}
+}
+
+static void hifn_setup_dst_desc(struct hifn_device *dev, struct scatterlist *sg, int mapped_nsg)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int idx, i;
+	u32 last = 0;
+	
+	mapped_nsg = pci_map_sg(dev->pdev, sg, mapped_nsg, PCI_DMA_FROMDEVICE);
+
+	idx = dma->dsti;
+
+	for (i=0; i<mapped_nsg; ++i) {
+		if (i == mapped_nsg - 1)
+			last = HIFN_D_LAST;
+		
+		dma->dstr[idx].p = __cpu_to_le32(sg_dma_address(&sg[i]));
+		dma->dstr[idx].l = __cpu_to_le32(sg_dma_len(&sg[i]) | HIFN_D_VALID | 
+				HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | last);
+		
+		if (++idx == HIFN_D_DST_RSIZE) {
+			dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID | HIFN_D_JUMP | 
+					HIFN_D_MASKDONEIRQ | HIFN_D_LAST | HIFN_D_NOINVALID);
+			idx = 0;
+		}
+	}
+	dma->dsti = idx;
+	dma->dstu += mapped_nsg;
+
+	if (!(dev->flags & HIFN_FLAG_DST_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_D_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_DST_BUSY;
+	}
+	
+}
+
+int hifn_setup_session(struct hifn_device *dev, 
+		struct scatterlist *src, int src_num,
+		struct scatterlist *dst, int dst_num, 
+		u8 *key, int keysize, u8 *iv, int ivsize,
+		u16 op, u16 type, u16 mode, u8 snum,
+		void *priv)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int nbytes, cmd_len, sa_idx, err = -EINVAL;
+	u8 *buf, *buf_pos;
+	u16 mask;
+	u16 dlen, slen;
+
+	dlen = sg_dma_len(dst);
+	slen = sg_dma_len(src);
+	sa_idx = dma->resi;
+
+	key = iv = NULL;
+	keysize = ivsize = 0;
+
+	nbytes = hifn_setup_src_desc(dev, src, src_num);
+
+	buf = dma->command_bufs[dma->cmdi];
+
+	buf_pos = buf;
+
+	mask = 0;
+	switch (op) {
+		case ACRYPTO_OP_DECRYPT:
+			mask = HIFN_BASE_CMD_CRYPT | HIFN_BASE_CMD_DECODE;
+			break;
+		case ACRYPTO_OP_ENCRYPT:
+			mask = HIFN_BASE_CMD_CRYPT;
+			break;
+		case ACRYPTO_OP_HMAC:
+			mask = HIFN_BASE_CMD_MAC;
+			break;
+		default:
+			goto err_out;
+	}
+	
+	buf_pos += hifn_setup_base_command(dev, buf_pos, dlen, slen, mask, snum);
+	
+	if (op == ACRYPTO_OP_ENCRYPT || op == ACRYPTO_OP_DECRYPT) {
+		u16 md;
+		md = 0;
+		
+		if (key)
+			md |= HIFN_CRYPT_CMD_NEW_KEY;
+		if (iv && mode != ACRYPTO_MODE_ECB)
+			md |= HIFN_CRYPT_CMD_NEW_IV;
+
+		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, type: %u.\n",
+			dev->name, iv, ivsize, key, keysize,
+			mode, op, type);
+
+		switch (mode) {
+			case ACRYPTO_MODE_ECB:
+				md |= HIFN_CRYPT_CMD_MODE_ECB;
+				break;
+			case ACRYPTO_MODE_CBC:
+				md |= HIFN_CRYPT_CMD_MODE_CBC;
+				break;
+			case ACRYPTO_MODE_CFB:
+				md |= HIFN_CRYPT_CMD_MODE_CFB;
+				break;
+			case ACRYPTO_MODE_OFB:
+				md |= HIFN_CRYPT_CMD_MODE_OFB;
+				break;
+			default:
+				goto err_out;
+		}
+
+		switch (type) {
+			case ACRYPTO_TYPE_AES_128:
+				if (keysize != 16)
+					goto err_out;
+				md |= HIFN_CRYPT_CMD_KSZ_128 | HIFN_CRYPT_CMD_ALG_AES;
+				break;
+			case ACRYPTO_TYPE_AES_192:
+				if (keysize != 24)
+					goto err_out;
+				md |= HIFN_CRYPT_CMD_KSZ_192 | HIFN_CRYPT_CMD_ALG_AES;
+				break;
+			case ACRYPTO_TYPE_AES_256:
+				if (keysize != 32)
+					goto err_out;
+				md |= HIFN_CRYPT_CMD_KSZ_256 | HIFN_CRYPT_CMD_ALG_AES;
+				break;
+			case ACRYPTO_TYPE_3DES:
+				if (keysize != 24)
+					goto err_out;
+				md |= HIFN_CRYPT_CMD_ALG_3DES;
+				break;
+			case ACRYPTO_TYPE_DES:
+				if (keysize != 8)
+					goto err_out;
+				md |= HIFN_CRYPT_CMD_ALG_DES;
+				break;
+			default:
+				goto err_out;
+		}
+
+		buf_pos += hifn_setup_crypto_command(dev, buf_pos, dlen, slen, key, keysize, iv, ivsize, md);
+	}
+
+	dev->sa[sa_idx] = priv;
+	
+	cmd_len = buf_pos - buf;
+	dma->cmdr[dma->cmdi].l = __cpu_to_le32(cmd_len | HIFN_D_VALID | HIFN_D_LAST | HIFN_D_MASKDONEIRQ);
+
+	if (++dma->cmdi == HIFN_D_CMD_RSIZE) {
+		dma->cmdr[dma->cmdi].l = __cpu_to_le32(HIFN_MAX_COMMAND | HIFN_D_VALID | 
+				HIFN_D_LAST | HIFN_D_MASKDONEIRQ | HIFN_D_JUMP);
+		dma->cmdi = 0;
+	} else
+		dma->cmdr[dma->cmdi-1].l |= __cpu_to_le32(HIFN_D_VALID);
+	
+	if (!(dev->flags & HIFN_FLAG_CMD_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_C_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_CMD_BUSY;
+	}
+	
+	hifn_setup_res_desc(dev);
+	hifn_setup_dst_desc(dev, dst, dst_num);
+
+	mb();
+
+	dev->active = 5;
+	err = 0;
+
+err_out:
+
+	if (err && printk_ratelimit())
+		printk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, type: %u.\n",
+			dev->name, iv, ivsize, key, keysize,
+			mode, op, type);
+
+	return err;
+}
+
+static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
+{
+	int n, err;
+	u8 key[16], *p;
+	u8 src[16];
+	struct scatterlist s;
+	u8 fips_aes_ecb_from_zero[16] = {
+		0x66, 0xE9, 0x4B, 0xD4, 
+		0xEF, 0x8A, 0x2C, 0x3B, 
+		0x88, 0x4C, 0xFA, 0x59, 
+		0xCA, 0x34, 0x2B, 0x2E};
+	
+	n = 0;
+	
+	dprintk("%s: session number=%02x:\n", (encdec)?"Encoding":"Decoding", snum);
+	
+	memset(src, 0, sizeof(src));
+	memset(key, 0, sizeof(key));
+
+	s.page 		= virt_to_page(src);
+	s.offset	= offset_in_page(src);
+	s.length	= sizeof(src);
+
+	err = hifn_setup_session(dev, 
+			&s, 1, 
+			&s, 1, 
+			key, sizeof(key), NULL, 0,
+			(encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT, 
+			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_ECB,
+			snum, NULL);
+	if (err)
+		goto err_out;
+
+	msleep(200);
+
+#ifdef HIFN_DEBUG
+	{
+		struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+		
+		dprintk("cmd: i=%d, u=%d, k=%d\n", dma->cmdi, dma->cmdu, dma->cmdk);
+		dprintk("src: i=%d, u=%d, k=%d\n", dma->srci, dma->srcu, dma->srck);
+		dprintk("dst: i=%d, u=%d, k=%d\n", dma->dsti, dma->dstu, dma->dstk);
+		dprintk("res: i=%d, u=%d, k=%d\n", dma->resi, dma->resu, dma->resk);
+	}
+#endif
+
+	dprintk("%s: decoded: ", dev->name);
+	for (n=0; n<sizeof(src); ++n)
+		dprintk("%02x ", src[n]);
+	dprintk("\n");
+	dprintk("%s: FIPS   : ", dev->name);
+	for (n=0; n<sizeof(fips_aes_ecb_from_zero); ++n)
+		dprintk("%02x ", fips_aes_ecb_from_zero[n]);
+	dprintk("\n");
+
+	p = page_address(s.page) + s.offset;
+	if (!memcmp(p, fips_aes_ecb_from_zero, sizeof(fips_aes_ecb_from_zero))) {
+		printk(KERN_INFO "%s: AES 128 ECB test has been successfully passed.\n", dev->name);
+		return 0;
+	}
+	
+err_out:
+	printk(KERN_INFO "%s: AES 128 ECB test has been failed.\n", dev->name);
+	return -1;
+}
+
+static void hifn_work(struct work_struct *);
+
+static int hifn_start_device(struct hifn_device *dev)
+{
+	int err;
+
+	dev->ram_size = 32768;
+	
+	hifn_reset_dma(dev, 1);
+	
+	err = hifn_enable_crypto(dev);
+	if (err)
+		return err;
+
+	hifn_reset_puc(dev);
+
+	hifn_init_dma(dev);
+
+	hifn_init_registers(dev);
+
+	hifn_init_sessions(dev);
+	
+	hifn_init_pubrng(dev);
+
+	INIT_DELAYED_WORK(&dev->work, hifn_work);
+	schedule_delayed_work(&dev->work, HZ);
+	
+	return 0;
+}
+
+static void hifn_process_ready(struct ablkcipher_request *req, int error)
+{
+	req->base.complete(req->base.data, error);
+}
+
+static void hifn_check_for_completion(struct hifn_device *dev, int error)
+{
+	int i;
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+
+	for (i=0; i<HIFN_D_RES_RSIZE; ++i) {
+		struct hifn_desc *d = &dma->resr[i];
+
+		if (!(d->l & __cpu_to_le32(HIFN_D_VALID)) && dev->sa[i]) {
+			dev->success++;
+			dev->reset = 0;
+			hifn_process_ready(dev->sa[i], error);
+			
+			dev->started--;
+			BUG_ON(dev->started < 0);
+			
+			dev->sa[i] = NULL;
+		}
+
+		if (d->l & __cpu_to_le32(HIFN_D_DESTOVER | HIFN_D_OVER)) {
+			int j;
+
+			if (printk_ratelimit())
+				printk("%s: overflow detected [d: %u, o: %u] in %d resr: l: %08x, p: %08x.\n",
+					dev->name, !!(d->l & __cpu_to_le32(HIFN_D_DESTOVER)),
+					!!(d->l & __cpu_to_le32(HIFN_D_OVER)),
+					i, d->l, d->p);
+
+			for (j=0; j<HIFN_D_RES_RSIZE; ++j) {
+				struct hifn_desc *dst = &dma->resr[j];
+
+				if (printk_ratelimit())
+					printk("%s: over: i: %d, j: %d, d: %u, o: %u, l: %u, dlen: %u, l: %08x, p: %08x.\n",
+						dev->name, i, j,
+						!!(dst->l & __cpu_to_le32(HIFN_D_DESTOVER)), 
+						!!(dst->l & __cpu_to_le32(HIFN_D_OVER)), 
+						!!(dst->l & __cpu_to_le32(HIFN_D_LAST)),
+						dst->l & __cpu_to_le32(HIFN_D_LENGTH),
+						dst->l, dst->p);
+			}
+		}
+	}
+}
+
+static void hifn_clear_rings(struct hifn_device *dev)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int i, u;
+	
+	dprintk("%s: ring cleanup 1: i: %d.%d.%d.%d, u: %d.%d.%d.%d, k: %d.%d.%d.%d.\n", 
+			dev->name,
+			dma->cmdi, dma->srci, dma->dsti, dma->resi,
+			dma->cmdu, dma->srcu, dma->dstu, dma->resu, 
+			dma->cmdk, dma->srck, dma->dstk, dma->resk); 
+	
+	i = dma->resk; u = dma->resu;
+	while (u != 0) {
+		if (dma->resr[i].l & __cpu_to_le32(HIFN_D_VALID))
+			break;
+
+		if (i != HIFN_D_RES_RSIZE)
+			u--;
+
+		if (++i == (HIFN_D_RES_RSIZE + 1))
+			i = 0;
+	}
+	dma->resk = i; dma->resu = u;
+
+	i = dma->srck; u = dma->srcu;
+	while (u != 0) {
+		if (i == HIFN_D_SRC_RSIZE)
+			i = 0;
+		if (dma->srcr[i].l & __cpu_to_le32(HIFN_D_VALID))
+			break;
+		i++, u--;
+	}
+	dma->srck = i; dma->srcu = u;
+
+	i = dma->cmdk; u = dma->cmdu;
+	while (u != 0) {
+		if (dma->cmdr[i].l & __cpu_to_le32(HIFN_D_VALID))
+			break;
+		if (i != HIFN_D_CMD_RSIZE)
+			u--;
+		if (++i == (HIFN_D_CMD_RSIZE + 1))
+			i = 0;
+	}
+	dma->cmdk = i; dma->cmdu = u;
+
+	i = dma->dstk; u = dma->dstu;
+	while (u != 0) {
+		if (i == HIFN_D_DST_RSIZE)
+			i = 0;
+		if (dma->dstr[i].l & __cpu_to_le32(HIFN_D_VALID))
+			break;
+		i++, u--;
+	}
+	dma->dstk = i; dma->dstu = u;
+
+	dprintk("%s: ring cleanup 2: i: %d.%d.%d.%d, u: %d.%d.%d.%d, k: %d.%d.%d.%d.\n", 
+			dev->name,
+			dma->cmdi, dma->srci, dma->dsti, dma->resi,
+			dma->cmdu, dma->srcu, dma->dstu, dma->resu, 
+			dma->cmdk, dma->srck, dma->dstk, dma->resk); 
+}
+
+static void hifn_work(struct work_struct *work)
+{
+	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct hifn_device *dev = container_of(dw, struct hifn_device, work);
+	unsigned long flags;
+	int reset = 0;
+	u32 r = 0;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (dev->active == 0) {
+		struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+
+		if (dma->cmdu == 0 && (dev->flags & HIFN_FLAG_CMD_BUSY)) {
+			dev->flags &= ~HIFN_FLAG_CMD_BUSY;
+			r |= HIFN_DMACSR_C_CTRL_DIS;
+		}
+		if (dma->srcu == 0 && (dev->flags & HIFN_FLAG_SRC_BUSY)) {
+			dev->flags &= ~HIFN_FLAG_SRC_BUSY;
+			r |= HIFN_DMACSR_S_CTRL_DIS;
+		}
+		if (dma->dstu == 0 && (dev->flags & HIFN_FLAG_DST_BUSY)) {
+			dev->flags &= ~HIFN_FLAG_DST_BUSY;
+			r |= HIFN_DMACSR_D_CTRL_DIS;
+		}
+		if (dma->resu == 0 && (dev->flags & HIFN_FLAG_RES_BUSY)) {
+			dev->flags &= ~HIFN_FLAG_RES_BUSY;
+			r |= HIFN_DMACSR_R_CTRL_DIS;
+		}
+		if (r)
+			hifn_write_1(dev, HIFN_1_DMA_CSR, r);
+	} else
+		dev->active--;
+
+	if (dev->prev_success == dev->success && dev->started)
+		reset = 1;
+	dev->prev_success = dev->success;
+
+	dprintk("%s: r: %08x, active: %d, started: %d, wait: %lu, break: %lu, intr: %lu, success: %lu: dfailed: %lu.\n", 
+			dev->name, r, dev->active, dev->started,
+			dev->waiting, dev->break_session, dev->intr, dev->success, dev->dequeue_failed);
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	if (reset) {
+		if (++dev->reset >= 5) {
+			dprintk("%s: reset.\n", dev->name);
+			hifn_reset_dma(dev, 1);
+			hifn_stop_device(dev);
+			hifn_start_device(dev);
+		}
+		
+		spin_lock_irqsave(&dev->lock, flags);
+		hifn_check_for_completion(dev, -EBUSY);
+		hifn_clear_rings(dev);
+		dev->reset = 0;
+		spin_unlock_irqrestore(&dev->lock, flags);
+	}
+
+	schedule_delayed_work(&dev->work, HZ);
+}
+
+static irqreturn_t hifn_interrupt(int irq, void *data)
+{
+	struct hifn_device *dev = (struct hifn_device *)data;
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	u32 dmacsr, restart;
+	
+	dmacsr = hifn_read_1(dev, HIFN_1_DMA_CSR);
+	
+	{
+		dmacsr = hifn_read_1(dev, HIFN_1_DMA_CSR);
+		/*
+		dprintk("%s: 1 dmacsr: %08x, dmareg: %08x, res: %08x [%d.%d], i: %d.%d.%d.%d, u: %d.%d.%d.%d.\n", 
+			dev->name, dmacsr, dev->dmareg, dmacsr & dev->dmareg, dma->cmdi, cmdi_calc,
+			dma->cmdu, dma->srcu, dma->dstu, dma->resu, 
+			dma->cmdi, dma->srci, dma->dsti, dma->resi);
+		*/
+
+		dprintk("%s: 1 dmacsr: %08x, dmareg: %08x, res: %08x [%d], i: %d.%d.%d.%d, u: %d.%d.%d.%d.\n", 
+			dev->name, dmacsr, dev->dmareg, dmacsr & dev->dmareg, dma->cmdi,
+			dma->cmdu, dma->srcu, dma->dstu, dma->resu, 
+			dma->cmdi, dma->srci, dma->dsti, dma->resi);
+	}
+	
+	if ((dmacsr & dev->dmareg) == 0)
+		goto out;
+
+	dev->intr++;
+
+	hifn_write_1(dev, HIFN_1_DMA_CSR, dmacsr & dev->dmareg);
+	
+	if (dmacsr & HIFN_DMACSR_ENGINE)
+		hifn_write_0(dev, HIFN_0_PUISR, hifn_read_0(dev, HIFN_0_PUISR));
+	if (dmacsr & HIFN_DMACSR_PUBDONE)
+		hifn_write_1(dev, HIFN_1_PUB_STATUS, hifn_read_1(dev, HIFN_1_PUB_STATUS) | HIFN_PUBSTS_DONE);
+	
+	restart = dmacsr & (HIFN_DMACSR_R_OVER | HIFN_DMACSR_D_OVER);
+	if (restart) {
+		u32 puisr = hifn_read_0(dev, HIFN_0_PUISR);
+		
+		if (printk_ratelimit())
+			printk("%s: overflow: r: %d, d: %d, puisr: %08x, d: %u.\n", 
+				dev->name, !!(dmacsr & HIFN_DMACSR_R_OVER), 
+				!!(dmacsr & HIFN_DMACSR_D_OVER),
+				puisr, !!(puisr & HIFN_PUISR_DSTOVER));
+		if (!!(puisr & HIFN_PUISR_DSTOVER))
+			hifn_write_0(dev, HIFN_0_PUISR, HIFN_PUISR_DSTOVER);
+		hifn_write_1(dev, HIFN_1_DMA_CSR, dmacsr & (HIFN_DMACSR_R_OVER | HIFN_DMACSR_D_OVER));
+	}
+	
+	restart = dmacsr & (HIFN_DMACSR_C_ABORT | HIFN_DMACSR_S_ABORT | HIFN_DMACSR_D_ABORT | HIFN_DMACSR_R_ABORT);
+	if (restart) {
+		if (printk_ratelimit())
+			printk("%s: abort: c: %d, s: %d, d: %d, r: %d.\n", 
+				dev->name, !!(dmacsr & HIFN_DMACSR_C_ABORT), !!(dmacsr & HIFN_DMACSR_S_ABORT), 
+				!!(dmacsr & HIFN_DMACSR_D_ABORT), !!(dmacsr & HIFN_DMACSR_R_ABORT));
+		hifn_reset_dma(dev, 1);
+		hifn_init_dma(dev);
+		hifn_init_registers(dev);
+	}
+	
+	if ((dmacsr & HIFN_DMACSR_C_WAIT) && (dma->cmdu == 0)) {
+		dev->waiting++;
+		dprintk("%s: wait on command.\n", dev->name);
+		dev->dmareg &= ~(HIFN_DMAIER_C_WAIT);
+		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);
+	}
+
+	hifn_check_for_completion(dev, 0);
+	hifn_clear_rings(dev);
+
+out:
+	return IRQ_HANDLED;
+}
+
+static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct hifn_device *dev = crypto_tfm_ctx(tfm);
+
+	if (len > HIFN_MAX_CRYPT_KEY_LENGTH)
+		return -1;
+
+	if (!memcmp(dev->current_key, key, len)) {
+		dev->flags |= HIFN_FLAG_OLD_KEY;
+		return 0;
+	}
+
+	dev->flags &= ~HIFN_FLAG_OLD_KEY;
+
+	memcpy(dev->current_key, key, len);
+	dev->current_key_len = len;
+
+	return 0;
+}
+
+static int hifn_setup_crypto(struct ablkcipher_request *req, u8 op, u8 type, u8 mode)
+{
+	struct hifn_device *dev = ablkcipher_request_ctx(req);
+	int err = -EBUSY;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (dev->started < HIFN_QUEUE_LENGTH) {
+		err = hifn_setup_session(dev, req->src, 1, req->dst, 1, 
+				(dev->flags & HIFN_FLAG_OLD_KEY)?NULL:dev->current_key, dev->current_key_len,
+				NULL, 0, 
+				op, type, mode, dev->snum, req);
+		dev->snum++;
+		dev->started++;
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	/*
+	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
+	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
+	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
+	 *
+	 * Actually I need to think about how to handle the case, when queue is full.
+	 * So far error (-EINVAL) is returned.
+	 */
+
+	return err;
+}
+
+static inline int hifn_encrypt_aes_ecb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_encrypt_aes_cbc_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_encrypt_aes_cfb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_encrypt_aes_ofb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_encrypt_aes_ecb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_encrypt_aes_cbc_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_encrypt_aes_cfb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_encrypt_aes_ofb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_encrypt_aes_ecb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_encrypt_aes_cbc_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_encrypt_aes_cfb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_encrypt_aes_ofb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_decrypt_aes_ecb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_decrypt_aes_cbc_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_decrypt_aes_cfb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_decrypt_aes_ofb_16(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_decrypt_aes_ecb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_decrypt_aes_cbc_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_decrypt_aes_cfb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_decrypt_aes_ofb_24(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_192, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_decrypt_aes_ecb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_decrypt_aes_cbc_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_decrypt_aes_cfb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_decrypt_aes_ofb_32(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_AES_256, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_encrypt_des_ecb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_encrypt_des_cbc(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_encrypt_des_cfb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_encrypt_des_ofb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_decrypt_des_ecb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_decrypt_des_cbc(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_decrypt_des_cfb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_decrypt_des_ofb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_DES, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_encrypt_3des_ecb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_encrypt_3des_cbc(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_encrypt_3des_cfb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_encrypt_3des_ofb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
+}
+
+static inline int hifn_decrypt_3des_ecb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_ECB);
+}
+static inline int hifn_decrypt_3des_cbc(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CBC);
+}
+static inline int hifn_decrypt_3des_cfb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CFB);
+}
+static inline int hifn_decrypt_3des_ofb(struct ablkcipher_request *req)
+{
+	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT, ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
+}
+
+
+struct hifn_alg_template
+{
+	char name[CRYPTO_MAX_ALG_NAME];
+	char drv_name[CRYPTO_MAX_ALG_NAME];
+	unsigned int bsize;
+	struct ablkcipher_alg ablkcipher;
+};
+
+static struct hifn_alg_template hifn_alg_templates[] = {
+	{
+		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 16, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ecb_16,
+			.decrypt	=	hifn_decrypt_aes_ecb_16,
+		},
+	},
+	{
+		.name = "cbc(aes)", .drv_name = "hifn-aes", .bsize = 16, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cbc_16,
+			.decrypt	=	hifn_decrypt_aes_cbc_16,
+		},
+	},
+	{
+		.name = "cfb(aes)", .drv_name = "hifn-aes", .bsize = 16, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cfb_16,
+			.decrypt	=	hifn_decrypt_aes_cfb_16,
+		},
+	},
+	{
+		.name = "ofb(aes)", .drv_name = "hifn-aes", .bsize = 16, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ofb_16,
+			.decrypt	=	hifn_decrypt_aes_ofb_16,
+		},
+	},
+	{
+		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ecb_24,
+			.decrypt	=	hifn_decrypt_aes_ecb_24,
+		},
+	},
+	{
+		.name = "cbc(aes)", .drv_name = "hifn-aes", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cbc_24,
+			.decrypt	=	hifn_decrypt_aes_cbc_24,
+		},
+	},
+	{
+		.name = "cfb(aes)", .drv_name = "hifn-aes", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cfb_24,
+			.decrypt	=	hifn_decrypt_aes_cfb_24,
+		},
+	},
+	{
+		.name = "ofb(aes)", .drv_name = "hifn-aes", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ofb_24,
+			.decrypt	=	hifn_decrypt_aes_ofb_24,
+		},
+	},
+	{
+		.name = "ecb(aes)", .drv_name = "hifn-aes", .bsize = 32, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ecb_32,
+			.decrypt	=	hifn_decrypt_aes_ecb_32,
+		},
+	},
+	{
+		.name = "cbc(aes)", .drv_name = "hifn-aes", .bsize = 32, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cbc_32,
+			.decrypt	=	hifn_decrypt_aes_cbc_32,
+		},
+	},
+	{
+		.name = "cfb(aes)", .drv_name = "hifn-aes", .bsize = 32, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_cfb_32,
+			.decrypt	=	hifn_decrypt_aes_cfb_32,
+		},
+	},
+	{
+		.name = "ofb(aes)", .drv_name = "hifn-aes", .bsize = 32, 
+		.ablkcipher = {
+			.min_keysize	=	AES_MIN_KEY_SIZE,
+			.max_keysize	=	AES_MAX_KEY_SIZE,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_aes_ofb_32,
+			.decrypt	=	hifn_decrypt_aes_ofb_32,
+		},
+	},
+	{
+		.name = "ecb(des)", .drv_name = "hifn-des", .bsize = 8, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_des_ecb,
+			.decrypt	=	hifn_decrypt_des_ecb,
+		},
+	},
+	{
+		.name = "cbc(des)", .drv_name = "hifn-des", .bsize = 8, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_des_cbc,
+			.decrypt	=	hifn_decrypt_des_cbc,
+		},
+	},
+	{
+		.name = "cfb(des)", .drv_name = "hifn-des", .bsize = 8, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_des_cfb,
+			.decrypt	=	hifn_decrypt_des_cfb,
+		},
+	},
+	{
+		.name = "ofb(des)", .drv_name = "hifn-des", .bsize = 8, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_des_ofb,
+			.decrypt	=	hifn_decrypt_des_ofb,
+		},
+	},
+	{
+		.name = "ecb(3des)", .drv_name = "hifn-3des", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_3des_ecb,
+			.decrypt	=	hifn_decrypt_3des_ecb,
+		},
+	},
+	{
+		.name = "cbc(3des)", .drv_name = "hifn-3des", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_3des_cbc,
+			.decrypt	=	hifn_decrypt_3des_cbc,
+		},
+	},
+	{
+		.name = "cfb(3des)", .drv_name = "hifn-3des", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_3des_cfb,
+			.decrypt	=	hifn_decrypt_3des_cfb,
+		},
+	},
+	{
+		.name = "ofb(3des)", .drv_name = "hifn-3des", .bsize = 24, 
+		.ablkcipher = {
+			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
+			.setkey		=	hifn_setkey,
+			.encrypt	=	hifn_encrypt_3des_ofb,
+			.decrypt	=	hifn_decrypt_3des_ofb,
+		},
+	},
+};
+
+struct hifn_crypto_alg
+{
+	struct list_head		entry;
+	struct crypto_alg		alg;
+};
+
+static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
+{
+	struct hifn_crypto_alg *alg;
+	int err;
+
+	alg = kzalloc(sizeof(struct hifn_crypto_alg), GFP_KERNEL);
+	if (!alg)
+		return -ENOMEM;
+
+	snprintf(alg->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s", t->name);
+	snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s", t->drv_name);
+
+	alg->alg.cra_priority = 300;
+	alg->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->alg.cra_blocksize = t->bsize;
+	alg->alg.cra_ctxsize = sizeof(struct hifn_device);
+	alg->alg.cra_alignmask = 15; /* Should be 3 for des, but 15 is ok */
+	alg->alg.cra_type = &crypto_ablkcipher_type;
+	alg->alg.cra_module = THIS_MODULE;
+	alg->alg.cra_u.ablkcipher = t->ablkcipher;
+
+	list_add_tail(&alg->entry, &dev->alg_list);
+
+	err = crypto_register_alg(&alg->alg);
+	if (err) {
+		list_del(&alg->entry);
+		kfree(alg);
+	}
+
+	return err;
+}
+
+static void hifn_unregister_alg(struct hifn_device *dev)
+{
+	struct hifn_crypto_alg *a, *n;
+
+	list_for_each_entry_safe(a, n, &dev->alg_list, entry) {
+		list_del(&a->entry);
+		kfree(a);
+	}
+}
+
+static int hifn_register_alg(struct hifn_device *dev)
+{
+	int i, err;
+
+	for (i=0; i<ARRAY_SIZE(hifn_alg_templates); ++i) {
+		err = hifn_alg_alloc(dev, &hifn_alg_templates[i]);
+		if (err)
+			goto err_out_exit;
+	}
+
+	return 0;
+
+err_out_exit:
+	hifn_unregister_alg(dev);
+	return err;
+}
+
+static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int err, i;
+	struct hifn_device *dev;
+	
+	err = pci_enable_device(pdev);
+	if (err) {
+		dprintk("%s: Failed to enable device.\n", pci_name(pdev));
+		return err;
+	}
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err) {
+		dprintk("%s: Failed to setup DMA.\n", pci_name(pdev));
+		goto err_out_disable_pci_device;
+	}
+
+	err = pci_request_regions(pdev, "hifn59x");
+	if (err) {
+		dprintk("%s: Failed to request I/O regions.\n", pci_name(pdev));
+		goto err_out_disable_pci_device;
+	}
+	
+	if (pci_resource_len(pdev, 0) < HIFN_BAR0_SIZE ||
+	    pci_resource_len(pdev, 1) < HIFN_BAR1_SIZE ||
+	    pci_resource_len(pdev, 2) < HIFN_BAR2_SIZE) {
+		dprintk("%s: Broken hardware - I/O regions are too small.\n", pci_name(pdev));
+		err = -ENODEV;
+		goto err_out_free_regions;
+	}
+
+	dev = (struct hifn_device *)kzalloc(sizeof(struct hifn_device) + sizeof(struct crypto_alg), 
+			GFP_KERNEL);
+	if (!dev) {
+		dprintk("Failed to allocate hifn_device structure.\n");
+		err = -ENOMEM;
+		goto err_out_free_regions;
+	}
+	
+	INIT_LIST_HEAD(&dev->alg_list);
+
+	snprintf(dev->name, sizeof(dev->name), "hifn%d", atomic_inc_return(&hifn_dev_number)-1);
+	spin_lock_init(&dev->lock);
+
+	for (i=0; i<3; ++i) {
+		unsigned long addr, size;
+
+		addr = pci_resource_start(pdev, i);
+		size = pci_resource_len(pdev, i);
+
+		dev->bar[i] = ioremap_nocache(addr, size);
+		if (!dev->bar[i]) {
+			dprintk("Failed to remap %d PCI bar: addr=0x%lx, size=0x%lx.\n", 
+					i, addr, size);
+			goto err_out_unmap_bars;
+		}
+	}
+
+	dev->result_mem = __get_free_pages(GFP_KERNEL, HIFN_MAX_RESULT_ORDER);
+	if (!dev->result_mem) {
+		dprintk("Failed to allocate %d pages for result_mem.\n", HIFN_MAX_RESULT_ORDER);
+		goto err_out_unmap_bars;
+	}
+	memset((void *)dev->result_mem, 0, PAGE_SIZE*(1<<HIFN_MAX_RESULT_ORDER));
+
+	dev->dst = pci_map_single(pdev, (void *)dev->result_mem, PAGE_SIZE << HIFN_MAX_RESULT_ORDER, PCI_DMA_FROMDEVICE);
+
+	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma), &dev->desc_dma);
+	if (!dev->desc_virt) {
+		dprintk("Failed to allocate descriptor rings.\n");
+		goto err_out_free_result_pages;
+	}
+	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
+
+	dev->pdev = pdev;
+	dev->irq = pdev->irq;
+
+	for (i=0; i<HIFN_D_RES_RSIZE; ++i)
+		dev->sa[i] = NULL;
+
+	pci_set_drvdata(pdev, dev);
+	
+	err = request_irq(dev->irq, hifn_interrupt, SA_SHIRQ, dev->name, dev);
+	if (err) {
+		dprintk("Failed to request IRQ%d: err=%d.\n", dev->irq, err);
+		dev->irq = 0;
+		goto err_out_free_desc;
+	}
+
+	err = hifn_start_device(dev);
+	if (err)
+		goto err_out_free_irq;
+
+	err = hifn_test(dev, 1, 0);
+	if (err)
+		goto err_out_stop_device;
+
+	err = hifn_register_alg(dev);
+	if (err)
+		goto err_out_stop_device;
+
+	dprintk("HIFN crypto accelerator card at %s has been successfully registered as %s: id=%08x.\n",
+			pci_name(pdev), dev->name, hifn_read_1(dev, HIFN_CHIP_ID));
+
+	return 0;
+
+err_out_stop_device:
+	hifn_reset_dma(dev, 1);
+	hifn_stop_device(dev);
+err_out_free_irq:
+	free_irq(dev->irq, dev->name);
+err_out_free_desc:
+	pci_free_consistent(pdev, sizeof(struct hifn_dma), dev->desc_virt, dev->desc_dma);
+
+err_out_free_result_pages:
+	pci_unmap_single(pdev, dev->dst, PAGE_SIZE << HIFN_MAX_RESULT_ORDER, PCI_DMA_FROMDEVICE);
+	free_pages(dev->result_mem, HIFN_MAX_RESULT_ORDER);
+
+err_out_unmap_bars:
+	for (i=0; i<3; ++i)
+		if (dev->bar[i])
+			iounmap(dev->bar[i]);
+	
+err_out_free_regions:
+	pci_release_regions(pdev);
+	
+err_out_disable_pci_device:
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static void hifn_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct hifn_device *dev;
+	
+	dev = pci_get_drvdata(pdev);
+
+	if (dev) {
+		cancel_rearming_delayed_work(&dev->work);
+		flush_scheduled_work();
+
+		hifn_unregister_alg(dev);
+		hifn_reset_dma(dev, 1);
+		hifn_stop_device(dev);
+
+		free_irq(dev->irq, dev->name);
+		pci_free_consistent(pdev, sizeof(struct hifn_dma), dev->desc_virt, dev->desc_dma);
+		pci_unmap_single(pdev, dev->dst, PAGE_SIZE << HIFN_MAX_RESULT_ORDER, PCI_DMA_FROMDEVICE);
+		free_pages(dev->result_mem, HIFN_MAX_RESULT_ORDER);
+		for (i=0; i<3; ++i)
+			if (dev->bar[i])
+				iounmap(dev->bar[i]);
+
+		kfree(dev);
+	}
+	
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id hifn_pci_tbl[] = {
+	{ PCI_VENDOR_ID_HIFN, PCI_DEVICE_ID_HIFN_7955, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_HIFN, PCI_DEVICE_ID_HIFN_7956, PCI_ANY_ID, PCI_ANY_ID },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, hifn_pci_tbl);
+
+static struct pci_driver hifn_pci_driver = {
+	.name     = "hifn795x",
+	.id_table = hifn_pci_tbl,
+	.probe    = hifn_probe,
+	.remove   = __devexit_p(hifn_remove),
+};
+
+static int __devinit hifn_init(void)
+{
+	int err;
+	
+	err = pci_register_driver(&hifn_pci_driver);
+	if (err < 0) {
+		dprintk("Failed to register PCI driver for %s device.\n", hifn_pci_driver.name);
+		return -ENODEV;
+	}
+
+	printk(KERN_INFO "Driver for HIFN 795x crypto accelerator chip has been successfully registered.\n");
+	
+	return 0;
+}
+
+static void __devexit hifn_fini(void)
+{
+	pci_unregister_driver(&hifn_pci_driver);
+	
+	printk(KERN_INFO "Driver for HIFN 795x crypto accelerator chip has been successfully deregistered.\n");
+}
+
+module_init(hifn_init);
+module_exit(hifn_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
+MODULE_DESCRIPTION("Driver for HIFN 795x crypto accelerator chip.");


-- 
	Evgeniy Polyakov
