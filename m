From: tmarri@apm.com
Subject: [PATCH 2/2] PPC4xx: Merge xor.h and dma.h into onefile ppc440spe-dma.h
Date: Fri, 17 Sep 2010 18:42:42 -0700
Message-ID: <1284774162-14652-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, neilb@suse.de, yur@emcraft.com, tmarri@apm.com,
	linux-crypto@vger.kernel.org, dan.j.williams@intel.com,
	linuxppc-dev@lists.ozlabs.org
To: linux-raid@vger.kernel.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

From: Tirumala Marri <tmarri@apm.com>

This patch combines drivers/dma/ppc4xx/xor.h and driver/dma/dma/ppc4xx/dma.h
into drivers/dma/ppc4xx/ppx440spe-dma.h .

Signed-off-by: Tirumala R Marri <tmarri@apm.com>
---
 drivers/dma/ppc4xx/dma.h           |  223 -------------------------
 drivers/dma/ppc4xx/ppc440spe-dma.h |  318 ++++++++++++++++++++++++++++++++++++
 drivers/dma/ppc4xx/xor.h           |  110 -------------
 3 files changed, 318 insertions(+), 333 deletions(-)
 delete mode 100644 drivers/dma/ppc4xx/dma.h
 create mode 100644 drivers/dma/ppc4xx/ppc440spe-dma.h
 delete mode 100644 drivers/dma/ppc4xx/xor.h

diff --git a/drivers/dma/ppc4xx/dma.h b/drivers/dma/ppc4xx/dma.h
deleted file mode 100644
index bcde2df..0000000
--- a/drivers/dma/ppc4xx/dma.h
+++ /dev/null
@@ -1,223 +0,0 @@
-/*
- * 440SPe's DMA engines support header file
- *
- * 2006-2009 (C) DENX Software Engineering.
- *
- * Author: Yuri Tikhonov <yur@emcraft.com>
- *
- * This file is licensed under the term of  the GNU General Public License
- * version 2. The program licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-
-#ifndef	_PPC440SPE_DMA_H
-#define _PPC440SPE_DMA_H
-
-#include <linux/types.h>
-
-/* Number of elements in the array with statical CDBs */
-#define	MAX_STAT_DMA_CDBS	16
-/* Number of DMA engines available on the contoller */
-#define DMA_ENGINES_NUM		2
-
-/* Maximum h/w supported number of destinations */
-#define DMA_DEST_MAX_NUM	2
-
-/* FIFO's params */
-#define DMA0_FIFO_SIZE		0x1000
-#define DMA1_FIFO_SIZE		0x1000
-#define DMA_FIFO_ENABLE		(1<<12)
-
-/* DMA Configuration Register. Data Transfer Engine PLB Priority: */
-#define DMA_CFG_DXEPR_LP	(0<<26)
-#define DMA_CFG_DXEPR_HP	(3<<26)
-#define DMA_CFG_DXEPR_HHP	(2<<26)
-#define DMA_CFG_DXEPR_HHHP	(1<<26)
-
-/* DMA Configuration Register. DMA FIFO Manager PLB Priority: */
-#define DMA_CFG_DFMPP_LP	(0<<23)
-#define DMA_CFG_DFMPP_HP	(3<<23)
-#define DMA_CFG_DFMPP_HHP	(2<<23)
-#define DMA_CFG_DFMPP_HHHP	(1<<23)
-
-/* DMA Configuration Register. Force 64-byte Alignment */
-#define DMA_CFG_FALGN		(1 << 19)
-
-/*UIC0:*/
-#define D0CPF_INT		(1<<12)
-#define D0CSF_INT		(1<<11)
-#define D1CPF_INT		(1<<10)
-#define D1CSF_INT		(1<<9)
-/*UIC1:*/
-#define DMAE_INT		(1<<9)
-
-/* I2O IOP Interrupt Mask Register */
-#define I2O_IOPIM_P0SNE		(1<<3)
-#define I2O_IOPIM_P0EM		(1<<5)
-#define I2O_IOPIM_P1SNE		(1<<6)
-#define I2O_IOPIM_P1EM		(1<<8)
-
-/* DMA CDB fields */
-#define DMA_CDB_MSK		(0xF)
-#define DMA_CDB_64B_ADDR	(1<<2)
-#define DMA_CDB_NO_INT		(1<<3)
-#define DMA_CDB_STATUS_MSK	(0x3)
-#define DMA_CDB_ADDR_MSK	(0xFFFFFFF0)
-
-/* DMA CDB OpCodes */
-#define DMA_CDB_OPC_NO_OP	(0x00)
-#define DMA_CDB_OPC_MV_SG1_SG2	(0x01)
-#define DMA_CDB_OPC_MULTICAST	(0x05)
-#define DMA_CDB_OPC_DFILL128	(0x24)
-#define DMA_CDB_OPC_DCHECK128	(0x23)
-
-#define DMA_CUED_XOR_BASE	(0x10000000)
-#define DMA_CUED_XOR_HB		(0x00000008)
-
-#ifdef CONFIG_440SP
-#define DMA_CUED_MULT1_OFF	0
-#define DMA_CUED_MULT2_OFF	8
-#define DMA_CUED_MULT3_OFF	16
-#define DMA_CUED_REGION_OFF	24
-#define DMA_CUED_XOR_WIN_MSK	(0xFC000000)
-#else
-#define DMA_CUED_MULT1_OFF	2
-#define DMA_CUED_MULT2_OFF	10
-#define DMA_CUED_MULT3_OFF	18
-#define DMA_CUED_REGION_OFF	26
-#define DMA_CUED_XOR_WIN_MSK	(0xF0000000)
-#endif
-
-#define DMA_CUED_REGION_MSK	0x3
-#define DMA_RXOR123		0x0
-#define DMA_RXOR124		0x1
-#define DMA_RXOR125		0x2
-#define DMA_RXOR12		0x3
-
-/* S/G addresses */
-#define DMA_CDB_SG_SRC		1
-#define DMA_CDB_SG_DST1		2
-#define DMA_CDB_SG_DST2		3
-
-/*
- * DMAx engines Command Descriptor Block Type
- */
-struct dma_cdb {
-	/*
-	 * Basic CDB structure (Table 20-17, p.499, 440spe_um_1_22.pdf)
-	 */
-	u8	pad0[2];        /* reserved */
-	u8	attr;		/* attributes */
-	u8	opc;		/* opcode */
-	u32	sg1u;		/* upper SG1 address */
-	u32	sg1l;		/* lower SG1 address */
-	u32	cnt;		/* SG count, 3B used */
-	u32	sg2u;		/* upper SG2 address */
-	u32	sg2l;		/* lower SG2 address */
-	u32	sg3u;		/* upper SG3 address */
-	u32	sg3l;		/* lower SG3 address */
-};
-
-/*
- * DMAx hardware registers (p.515 in 440SPe UM 1.22)
- */
-struct dma_regs {
-	u32	cpfpl;
-	u32	cpfph;
-	u32	csfpl;
-	u32	csfph;
-	u32	dsts;
-	u32	cfg;
-	u8	pad0[0x8];
-	u16	cpfhp;
-	u16	cpftp;
-	u16	csfhp;
-	u16	csftp;
-	u8	pad1[0x8];
-	u32	acpl;
-	u32	acph;
-	u32	s1bpl;
-	u32	s1bph;
-	u32	s2bpl;
-	u32	s2bph;
-	u32	s3bpl;
-	u32	s3bph;
-	u8	pad2[0x10];
-	u32	earl;
-	u32	earh;
-	u8	pad3[0x8];
-	u32	seat;
-	u32	sead;
-	u32	op;
-	u32	fsiz;
-};
-
-/*
- * I2O hardware registers (p.528 in 440SPe UM 1.22)
- */
-struct i2o_regs {
-	u32	ists;
-	u32	iseat;
-	u32	isead;
-	u8	pad0[0x14];
-	u32	idbel;
-	u8	pad1[0xc];
-	u32	ihis;
-	u32	ihim;
-	u8	pad2[0x8];
-	u32	ihiq;
-	u32	ihoq;
-	u8	pad3[0x8];
-	u32	iopis;
-	u32	iopim;
-	u32	iopiq;
-	u8	iopoq;
-	u8	pad4[3];
-	u16	iiflh;
-	u16	iiflt;
-	u16	iiplh;
-	u16	iiplt;
-	u16	ioflh;
-	u16	ioflt;
-	u16	ioplh;
-	u16	ioplt;
-	u32	iidc;
-	u32	ictl;
-	u32	ifcpp;
-	u8	pad5[0x4];
-	u16	mfac0;
-	u16	mfac1;
-	u16	mfac2;
-	u16	mfac3;
-	u16	mfac4;
-	u16	mfac5;
-	u16	mfac6;
-	u16	mfac7;
-	u16	ifcfh;
-	u16	ifcht;
-	u8	pad6[0x4];
-	u32	iifmc;
-	u32	iodb;
-	u32	iodbc;
-	u32	ifbal;
-	u32	ifbah;
-	u32	ifsiz;
-	u32	ispd0;
-	u32	ispd1;
-	u32	ispd2;
-	u32	ispd3;
-	u32	ihipl;
-	u32	ihiph;
-	u32	ihopl;
-	u32	ihoph;
-	u32	iiipl;
-	u32	iiiph;
-	u32	iiopl;
-	u32	iioph;
-	u32	ifcpl;
-	u32	ifcph;
-	u8	pad7[0x8];
-	u32	iopt;
-};
-
-#endif /* _PPC440SPE_DMA_H */
diff --git a/drivers/dma/ppc4xx/ppc440spe-dma.h b/drivers/dma/ppc4xx/ppc440spe-dma.h
new file mode 100644
index 0000000..c52945e
--- /dev/null
+++ b/drivers/dma/ppc4xx/ppc440spe-dma.h
@@ -0,0 +1,318 @@
+/*
+ * 440SPe's DMA engines support header file
+ *
+ * 2006-2009 (C) DENX Software Engineering.
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * This file is licensed under the term of  the GNU General Public License
+ * version 2. The program licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef	_PPC440SPE_DMA_H
+#define _PPC440SPE_DMA_H
+
+#include <linux/types.h>
+
+/* Number of elements in the array with statical CDBs */
+#define	MAX_STAT_DMA_CDBS	16
+/* Number of DMA engines available on the contoller */
+#define DMA_ENGINES_NUM		2
+
+/* Maximum h/w supported number of destinations */
+#define DMA_DEST_MAX_NUM	2
+
+/* FIFO's params */
+#define DMA0_FIFO_SIZE		0x1000
+#define DMA1_FIFO_SIZE		0x1000
+#define DMA_FIFO_ENABLE		(1<<12)
+
+/* DMA Configuration Register. Data Transfer Engine PLB Priority: */
+#define DMA_CFG_DXEPR_LP	(0<<26)
+#define DMA_CFG_DXEPR_HP	(3<<26)
+#define DMA_CFG_DXEPR_HHP	(2<<26)
+#define DMA_CFG_DXEPR_HHHP	(1<<26)
+
+/* DMA Configuration Register. DMA FIFO Manager PLB Priority: */
+#define DMA_CFG_DFMPP_LP	(0<<23)
+#define DMA_CFG_DFMPP_HP	(3<<23)
+#define DMA_CFG_DFMPP_HHP	(2<<23)
+#define DMA_CFG_DFMPP_HHHP	(1<<23)
+
+/* DMA Configuration Register. Force 64-byte Alignment */
+#define DMA_CFG_FALGN		(1 << 19)
+
+/*UIC0:*/
+#define D0CPF_INT		(1<<12)
+#define D0CSF_INT		(1<<11)
+#define D1CPF_INT		(1<<10)
+#define D1CSF_INT		(1<<9)
+/*UIC1:*/
+#define DMAE_INT		(1<<9)
+
+/* I2O IOP Interrupt Mask Register */
+#define I2O_IOPIM_P0SNE		(1<<3)
+#define I2O_IOPIM_P0EM		(1<<5)
+#define I2O_IOPIM_P1SNE		(1<<6)
+#define I2O_IOPIM_P1EM		(1<<8)
+
+/* DMA CDB fields */
+#define DMA_CDB_MSK		(0xF)
+#define DMA_CDB_64B_ADDR	(1<<2)
+#define DMA_CDB_NO_INT		(1<<3)
+#define DMA_CDB_STATUS_MSK	(0x3)
+#define DMA_CDB_ADDR_MSK	(0xFFFFFFF0)
+
+/* DMA CDB OpCodes */
+#define DMA_CDB_OPC_NO_OP	(0x00)
+#define DMA_CDB_OPC_MV_SG1_SG2	(0x01)
+#define DMA_CDB_OPC_MULTICAST	(0x05)
+#define DMA_CDB_OPC_DFILL128	(0x24)
+#define DMA_CDB_OPC_DCHECK128	(0x23)
+
+#define DMA_CUED_XOR_BASE	(0x10000000)
+#define DMA_CUED_XOR_HB		(0x00000008)
+
+#ifdef CONFIG_440SP
+#define DMA_CUED_MULT1_OFF	0
+#define DMA_CUED_MULT2_OFF	8
+#define DMA_CUED_MULT3_OFF	16
+#define DMA_CUED_REGION_OFF	24
+#define DMA_CUED_XOR_WIN_MSK	(0xFC000000)
+#else
+#define DMA_CUED_MULT1_OFF	2
+#define DMA_CUED_MULT2_OFF	10
+#define DMA_CUED_MULT3_OFF	18
+#define DMA_CUED_REGION_OFF	26
+#define DMA_CUED_XOR_WIN_MSK	(0xF0000000)
+#endif
+
+#define DMA_CUED_REGION_MSK	0x3
+#define DMA_RXOR123		0x0
+#define DMA_RXOR124		0x1
+#define DMA_RXOR125		0x2
+#define DMA_RXOR12		0x3
+
+/* S/G addresses */
+#define DMA_CDB_SG_SRC		1
+#define DMA_CDB_SG_DST1		2
+#define DMA_CDB_SG_DST2		3
+
+/*
+ * XOR Endgine definies
+ */
+
+/* Number of XOR engines available on the contoller */
+#define XOR_ENGINES_NUM		1
+
+/* Number of operands supported in the h/w */
+#define XOR_MAX_OPS		16
+
+/*
+ * XOR Command Block Control Register bits
+ */
+#define XOR_CBCR_LNK_BIT        (1<<31) /* link present */
+#define XOR_CBCR_TGT_BIT        (1<<30) /* target present */
+#define XOR_CBCR_CBCE_BIT       (1<<29) /* command block compete enable */
+#define XOR_CBCR_RNZE_BIT       (1<<28) /* result not zero enable */
+#define XOR_CBCR_XNOR_BIT       (1<<15) /* XOR/XNOR */
+#define XOR_CDCR_OAC_MSK        (0x7F)  /* operand address count */
+
+/*
+ * XORCore Status Register bits
+ */
+#define XOR_SR_XCP_BIT		(1<<31)	/* core processing */
+#define XOR_SR_ICB_BIT		(1<<17)	/* invalid CB */
+#define XOR_SR_IC_BIT		(1<<16)	/* invalid command */
+#define XOR_SR_IPE_BIT		(1<<15)	/* internal parity error */
+#define XOR_SR_RNZ_BIT		(1<<2)	/* result not Zero */
+#define XOR_SR_CBC_BIT		(1<<1)	/* CB complete */
+#define XOR_SR_CBLC_BIT		(1<<0)	/* CB list complete */
+
+/*
+ * XORCore Control Set and Reset Register bits
+ */
+#define XOR_CRSR_XASR_BIT	(1<<31)	/* soft reset */
+#define XOR_CRSR_XAE_BIT	(1<<30)	/* enable */
+#define XOR_CRSR_RCBE_BIT	(1<<29)	/* refetch CB enable */
+#define XOR_CRSR_PAUS_BIT	(1<<28)	/* pause */
+#define XOR_CRSR_64BA_BIT	(1<<27) /* 64/32 CB format */
+#define XOR_CRSR_CLP_BIT	(1<<25)	/* continue list processing */
+
+/*
+ * XORCore Interrupt Enable Register
+ */
+#define XOR_IE_ICBIE_BIT	(1<<17)	/* Invalid Command Block IRQ Enable */
+#define XOR_IE_ICIE_BIT		(1<<16)	/* Invalid Command IRQ Enable */
+#define XOR_IE_RPTIE_BIT	(1<<14)	/* Read PLB Timeout Error IRQ Enable */
+#define XOR_IE_CBCIE_BIT	(1<<1)	/* CB complete interrupt enable */
+#define XOR_IE_CBLCI_BIT	(1<<0)	/* CB list complete interrupt enable */
+/*
+ * DMAx engines Command Descriptor Block Type
+ */
+struct dma_cdb {
+	/*
+	 * Basic CDB structure (Table 20-17, p.499, 440spe_um_1_22.pdf)
+	 */
+	u8	pad0[2];        /* reserved */
+	u8	attr;		/* attributes */
+	u8	opc;		/* opcode */
+	u32	sg1u;		/* upper SG1 address */
+	u32	sg1l;		/* lower SG1 address */
+	u32	cnt;		/* SG count, 3B used */
+	u32	sg2u;		/* upper SG2 address */
+	u32	sg2l;		/* lower SG2 address */
+	u32	sg3u;		/* upper SG3 address */
+	u32	sg3l;		/* lower SG3 address */
+};
+
+/*
+ * DMAx hardware registers (p.515 in 440SPe UM 1.22)
+ */
+struct dma_regs {
+	u32	cpfpl;
+	u32	cpfph;
+	u32	csfpl;
+	u32	csfph;
+	u32	dsts;
+	u32	cfg;
+	u8	pad0[0x8];
+	u16	cpfhp;
+	u16	cpftp;
+	u16	csfhp;
+	u16	csftp;
+	u8	pad1[0x8];
+	u32	acpl;
+	u32	acph;
+	u32	s1bpl;
+	u32	s1bph;
+	u32	s2bpl;
+	u32	s2bph;
+	u32	s3bpl;
+	u32	s3bph;
+	u8	pad2[0x10];
+	u32	earl;
+	u32	earh;
+	u8	pad3[0x8];
+	u32	seat;
+	u32	sead;
+	u32	op;
+	u32	fsiz;
+};
+
+/*
+ * I2O hardware registers (p.528 in 440SPe UM 1.22)
+ */
+struct i2o_regs {
+	u32	ists;
+	u32	iseat;
+	u32	isead;
+	u8	pad0[0x14];
+	u32	idbel;
+	u8	pad1[0xc];
+	u32	ihis;
+	u32	ihim;
+	u8	pad2[0x8];
+	u32	ihiq;
+	u32	ihoq;
+	u8	pad3[0x8];
+	u32	iopis;
+	u32	iopim;
+	u32	iopiq;
+	u8	iopoq;
+	u8	pad4[3];
+	u16	iiflh;
+	u16	iiflt;
+	u16	iiplh;
+	u16	iiplt;
+	u16	ioflh;
+	u16	ioflt;
+	u16	ioplh;
+	u16	ioplt;
+	u32	iidc;
+	u32	ictl;
+	u32	ifcpp;
+	u8	pad5[0x4];
+	u16	mfac0;
+	u16	mfac1;
+	u16	mfac2;
+	u16	mfac3;
+	u16	mfac4;
+	u16	mfac5;
+	u16	mfac6;
+	u16	mfac7;
+	u16	ifcfh;
+	u16	ifcht;
+	u8	pad6[0x4];
+	u32	iifmc;
+	u32	iodb;
+	u32	iodbc;
+	u32	ifbal;
+	u32	ifbah;
+	u32	ifsiz;
+	u32	ispd0;
+	u32	ispd1;
+	u32	ispd2;
+	u32	ispd3;
+	u32	ihipl;
+	u32	ihiph;
+	u32	ihopl;
+	u32	ihoph;
+	u32	iiipl;
+	u32	iiiph;
+	u32	iiopl;
+	u32	iioph;
+	u32	ifcpl;
+	u32	ifcph;
+	u8	pad7[0x8];
+	u32	iopt;
+};
+
+/*
+ * XOR Accelerator engine Command Block Type
+ */
+struct xor_cb {
+	/*
+	 * Basic 64-bit format XOR CB (Table 19-1, p.463, 440spe_um_1_22.pdf)
+	 */
+	u32	cbc;		/* control */
+	u32	cbbc;		/* byte count */
+	u32	cbs;		/* status */
+	u8	pad0[4];	/* reserved */
+	u32	cbtah;		/* target address high */
+	u32	cbtal;		/* target address low */
+	u32	cblah;		/* link address high */
+	u32	cblal;		/* link address low */
+	struct {
+		u32 h;
+		u32 l;
+	} __attribute__ ((packed)) ops[16];
+} __attribute__ ((packed));
+
+/*
+ * XOR hardware registers Table 19-3, UM 1.22
+ */
+struct xor_regs {
+	u32	op_ar[16][2];	/* operand address[0]-high,[1]-low registers */
+	u8	pad0[352];	/* reserved */
+	u32	cbcr;		/* CB control register */
+	u32	cbbcr;		/* CB byte count register */
+	u32	cbsr;		/* CB status register */
+	u8	pad1[4];	/* reserved */
+	u32	cbtahr;		/* operand target address high register */
+	u32	cbtalr;		/* operand target address low register */
+	u32	cblahr;		/* CB link address high register */
+	u32	cblalr;		/* CB link address low register */
+	u32	crsr;		/* control set register */
+	u32	crrr;		/* control reset register */
+	u32	ccbahr;		/* current CB address high register */
+	u32	ccbalr;		/* current CB address low register */
+	u32	plbr;		/* PLB configuration register */
+	u32	ier;		/* interrupt enable register */
+	u32	pecr;		/* parity error count register */
+	u32	sr;		/* status register */
+	u32	revidr;		/* revision ID register */
+};
+
+#endif /* _PPC440SPE_XOR_H */
diff --git a/drivers/dma/ppc4xx/xor.h b/drivers/dma/ppc4xx/xor.h
deleted file mode 100644
index daed738..0000000
--- a/drivers/dma/ppc4xx/xor.h
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * 440SPe's XOR engines support header file
- *
- * 2006-2009 (C) DENX Software Engineering.
- *
- * Author: Yuri Tikhonov <yur@emcraft.com>
- *
- * This file is licensed under the term of  the GNU General Public License
- * version 2. The program licensed "as is" without any warranty of any
- * kind, whether express or implied.
- */
-
-#ifndef _PPC440SPE_XOR_H
-#define _PPC440SPE_XOR_H
-
-#include <linux/types.h>
-
-/* Number of XOR engines available on the contoller */
-#define XOR_ENGINES_NUM		1
-
-/* Number of operands supported in the h/w */
-#define XOR_MAX_OPS		16
-
-/*
- * XOR Command Block Control Register bits
- */
-#define XOR_CBCR_LNK_BIT        (1<<31) /* link present */
-#define XOR_CBCR_TGT_BIT        (1<<30) /* target present */
-#define XOR_CBCR_CBCE_BIT       (1<<29) /* command block compete enable */
-#define XOR_CBCR_RNZE_BIT       (1<<28) /* result not zero enable */
-#define XOR_CBCR_XNOR_BIT       (1<<15) /* XOR/XNOR */
-#define XOR_CDCR_OAC_MSK        (0x7F)  /* operand address count */
-
-/*
- * XORCore Status Register bits
- */
-#define XOR_SR_XCP_BIT		(1<<31)	/* core processing */
-#define XOR_SR_ICB_BIT		(1<<17)	/* invalid CB */
-#define XOR_SR_IC_BIT		(1<<16)	/* invalid command */
-#define XOR_SR_IPE_BIT		(1<<15)	/* internal parity error */
-#define XOR_SR_RNZ_BIT		(1<<2)	/* result not Zero */
-#define XOR_SR_CBC_BIT		(1<<1)	/* CB complete */
-#define XOR_SR_CBLC_BIT		(1<<0)	/* CB list complete */
-
-/*
- * XORCore Control Set and Reset Register bits
- */
-#define XOR_CRSR_XASR_BIT	(1<<31)	/* soft reset */
-#define XOR_CRSR_XAE_BIT	(1<<30)	/* enable */
-#define XOR_CRSR_RCBE_BIT	(1<<29)	/* refetch CB enable */
-#define XOR_CRSR_PAUS_BIT	(1<<28)	/* pause */
-#define XOR_CRSR_64BA_BIT	(1<<27) /* 64/32 CB format */
-#define XOR_CRSR_CLP_BIT	(1<<25)	/* continue list processing */
-
-/*
- * XORCore Interrupt Enable Register
- */
-#define XOR_IE_ICBIE_BIT	(1<<17)	/* Invalid Command Block IRQ Enable */
-#define XOR_IE_ICIE_BIT		(1<<16)	/* Invalid Command IRQ Enable */
-#define XOR_IE_RPTIE_BIT	(1<<14)	/* Read PLB Timeout Error IRQ Enable */
-#define XOR_IE_CBCIE_BIT	(1<<1)	/* CB complete interrupt enable */
-#define XOR_IE_CBLCI_BIT	(1<<0)	/* CB list complete interrupt enable */
-
-/*
- * XOR Accelerator engine Command Block Type
- */
-struct xor_cb {
-	/*
-	 * Basic 64-bit format XOR CB (Table 19-1, p.463, 440spe_um_1_22.pdf)
-	 */
-	u32	cbc;		/* control */
-	u32	cbbc;		/* byte count */
-	u32	cbs;		/* status */
-	u8	pad0[4];	/* reserved */
-	u32	cbtah;		/* target address high */
-	u32	cbtal;		/* target address low */
-	u32	cblah;		/* link address high */
-	u32	cblal;		/* link address low */
-	struct {
-		u32 h;
-		u32 l;
-	} __attribute__ ((packed)) ops[16];
-} __attribute__ ((packed));
-
-/*
- * XOR hardware registers Table 19-3, UM 1.22
- */
-struct xor_regs {
-	u32	op_ar[16][2];	/* operand address[0]-high,[1]-low registers */
-	u8	pad0[352];	/* reserved */
-	u32	cbcr;		/* CB control register */
-	u32	cbbcr;		/* CB byte count register */
-	u32	cbsr;		/* CB status register */
-	u8	pad1[4];	/* reserved */
-	u32	cbtahr;		/* operand target address high register */
-	u32	cbtalr;		/* operand target address low register */
-	u32	cblahr;		/* CB link address high register */
-	u32	cblalr;		/* CB link address low register */
-	u32	crsr;		/* control set register */
-	u32	crrr;		/* control reset register */
-	u32	ccbahr;		/* current CB address high register */
-	u32	ccbalr;		/* current CB address low register */
-	u32	plbr;		/* PLB configuration register */
-	u32	ier;		/* interrupt enable register */
-	u32	pecr;		/* parity error count register */
-	u32	sr;		/* status register */
-	u32	revidr;		/* revision ID register */
-};
-
-#endif /* _PPC440SPE_XOR_H */
-- 
1.6.1.rc3
