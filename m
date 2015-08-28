From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [RFC][PATCH 2/2] crypto: caam - handle core endianness != caam endianness
Date: Fri, 28 Aug 2015 14:50:08 +0300
Message-ID: <1440762608-7866-1-git-send-email-horia.geanta@freescale.com>
References: <1440762306-7764-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	"Scott Wood" <scottwood@freescale.com>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	Steve Cornelius <steve.cornelius@freescale.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440762306-7764-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There are SoCs like LS1043A where CAAM endianness (BE) does not match
the endianness of the core (LE).
Moreover, there are requirements for the driver to handle cases like
CPU_BIG_ENDIAN=3Dy on ARM-based SoCs.
This requires for a complete rewrite of the I/O accessors.

PPC-specific accessors - {in,out}_{le,be}XX - are replaced with
generic io{read,write}[be]XX where possible (no 64-bit generic I/O).

Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---

While patch takes into consideration the S/G format (struct sec4_sg_ent=
ry)
for i.MX7, I don't have a board so I haven't tested this platform.

 drivers/crypto/caam/caamhash.c    |  5 +--
 drivers/crypto/caam/ctrl.c        |  2 +-
 drivers/crypto/caam/desc.h        |  9 ++++-
 drivers/crypto/caam/desc_constr.h | 42 +++++++++++++++--------
 drivers/crypto/caam/jr.c          |  8 ++---
 drivers/crypto/caam/regs.h        | 72 ++++++++++++++++++++++++++++---=
--------
 drivers/crypto/caam/sg_sw_sec4.h  | 10 +++---
 7 files changed, 102 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamh=
ash.c
index 72acf8e5ac2f..c39332171fa3 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -841,7 +841,7 @@ static int ahash_update_ctx(struct ahash_request *r=
eq)
 							 *next_buflen, 0);
 		} else {
 			(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=3D
-							SEC4_SG_LEN_FIN;
+				cpu_to_caam32(SEC4_SG_LEN_FIN);
 		}
=20
 		state->current_buf =3D !state->current_buf;
@@ -942,7 +942,8 @@ static int ahash_final_ctx(struct ahash_request *re=
q)
 	state->buf_dma =3D try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
 						last_buflen);
-	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |=3D SEC4_SG_LEN_FIN;
+	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |=3D
+		cpu_to_caam32(SEC4_SG_LEN_FIN);
=20
 	edesc->sec4_sg_dma =3D dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8abb4bc548cc..e527d1e0b9ab 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -128,7 +128,7 @@ static inline int run_descriptor_deco0(struct devic=
e *ctrldev, u32 *desc,
 	}
=20
 	for (i =3D 0; i < desc_len(desc); i++)
-		wr_reg32(&deco->descbuf[i], *(desc + i));
+		wr_reg32(&deco->descbuf[i], caam32_to_cpu(*(desc + i)));
=20
 	flags =3D DECO_JQCR_WHL;
 	/*
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 983d663ef671..fc257b343d3b 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -23,16 +23,23 @@
 #define SEC4_SG_OFFS_MASK	0x00001fff
=20
 struct sec4_sg_entry {
-#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
+#if !defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) && \
+	defined(CONFIG_CRYPTO_DEV_FSL_CAAM_IMX)
 	u32 rsvd1;
 	dma_addr_t ptr;
 #else
 	u64 ptr;
 #endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_IMX */
 	u32 len;
+#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
 	u8 rsvd2;
 	u8 buf_pool_id;
 	u16 offset;
+#else
+	u16 offset;
+	u8 buf_pool_id;
+	u8 rsvd2;
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_LE */
 };
=20
 /* Max size of any CAAM descriptor in 32-bit words, inclusive of heade=
r */
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/de=
sc_constr.h
index 98d07de24fc4..40baf4752fbc 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -5,6 +5,7 @@
  */
=20
 #include "desc.h"
+#include "regs.h"
=20
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
@@ -32,7 +33,7 @@
=20
 static inline int desc_len(u32 *desc)
 {
-	return *desc & HDR_DESCLEN_MASK;
+	return caam32_to_cpu(*desc) & HDR_DESCLEN_MASK;
 }
=20
 static inline int desc_bytes(void *desc)
@@ -52,7 +53,7 @@ static inline void *sh_desc_pdb(u32 *desc)
=20
 static inline void init_desc(u32 *desc, u32 options)
 {
-	*desc =3D (options | HDR_ONE) + 1;
+	*desc =3D cpu_to_caam32((options | HDR_ONE) + 1);
 }
=20
 static inline void init_sh_desc(u32 *desc, u32 options)
@@ -78,9 +79,10 @@ static inline void append_ptr(u32 *desc, dma_addr_t =
ptr)
 {
 	dma_addr_t *offset =3D (dma_addr_t *)desc_end(desc);
=20
-	*offset =3D ptr;
+	*offset =3D wr_dma(ptr);
=20
-	(*desc) +=3D CAAM_PTR_SZ / CAAM_CMD_SZ;
+	(*desc) =3D cpu_to_caam32(caam32_to_cpu(*desc) +
+				CAAM_PTR_SZ / CAAM_CMD_SZ);
 }
=20
 static inline void init_job_desc_shared(u32 *desc, dma_addr_t ptr, int=
 len,
@@ -99,16 +101,17 @@ static inline void append_data(u32 *desc, void *da=
ta, int len)
 	if (len) /* avoid sparse warning: memcpy with byte count of 0 */
 		memcpy(offset, data, len);
=20
-	(*desc) +=3D (len + CAAM_CMD_SZ - 1) / CAAM_CMD_SZ;
+	(*desc) =3D cpu_to_caam32(caam32_to_cpu(*desc) +
+				(len + CAAM_CMD_SZ - 1) / CAAM_CMD_SZ);
 }
=20
 static inline void append_cmd(u32 *desc, u32 command)
 {
 	u32 *cmd =3D desc_end(desc);
=20
-	*cmd =3D command;
+	*cmd =3D cpu_to_caam32(command);
=20
-	(*desc)++;
+	(*desc) =3D cpu_to_caam32(caam32_to_cpu(*desc) + 1);
 }
=20
 #define append_u32 append_cmd
@@ -117,16 +120,22 @@ static inline void append_u64(u32 *desc, u64 data=
)
 {
 	u32 *offset =3D desc_end(desc);
=20
-	*offset =3D upper_32_bits(data);
-	*(++offset) =3D lower_32_bits(data);
+	/* Only 32-bit alignment is guaranteed in descriptor buffer */
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_LE)) {
+		*offset =3D cpu_to_caam32(lower_32_bits(data));
+		*(++offset) =3D cpu_to_caam32(upper_32_bits(data));
+	} else {
+		*offset =3D cpu_to_caam32(upper_32_bits(data));
+		*(++offset) =3D cpu_to_caam32(lower_32_bits(data));
+	}
=20
-	(*desc) +=3D 2;
+	(*desc) =3D cpu_to_caam32(caam32_to_cpu(*desc) + 2);
 }
=20
 /* Write command without affecting header, and return pointer to next =
word */
 static inline u32 *write_cmd(u32 *desc, u32 command)
 {
-	*desc =3D command;
+	*desc =3D cpu_to_caam32(command);
=20
 	return desc + 1;
 }
@@ -168,14 +177,17 @@ APPEND_CMD_RET(move, MOVE)
=20
 static inline void set_jump_tgt_here(u32 *desc, u32 *jump_cmd)
 {
-	*jump_cmd =3D *jump_cmd | (desc_len(desc) - (jump_cmd - desc));
+	*jump_cmd =3D cpu_to_caam32(caam32_to_cpu(*jump_cmd) |
+				  (desc_len(desc) - (jump_cmd - desc)));
 }
=20
 static inline void set_move_tgt_here(u32 *desc, u32 *move_cmd)
 {
-	*move_cmd &=3D ~MOVE_OFFSET_MASK;
-	*move_cmd =3D *move_cmd | ((desc_len(desc) << (MOVE_OFFSET_SHIFT + 2)=
) &
-				 MOVE_OFFSET_MASK);
+	u32 val =3D caam32_to_cpu(*move_cmd);
+
+	val &=3D ~MOVE_OFFSET_MASK;
+	val |=3D (desc_len(desc) << (MOVE_OFFSET_SHIFT + 2)) & MOVE_OFFSET_MA=
SK;
+	*move_cmd =3D cpu_to_caam32(val);
 }
=20
 #define APPEND_CMD(cmd, op) \
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index f7e0d8d4c3da..5add26b2a2ff 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -182,7 +182,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 			sw_idx =3D (tail + i) & (JOBR_DEPTH - 1);
=20
 			if (jrp->outring[hw_idx].desc =3D=3D
-			    jrp->entinfo[sw_idx].desc_addr_dma)
+			    rd_dma(jrp->entinfo[sw_idx].desc_addr_dma))
 				break; /* found */
 		}
 		/* we should never fail to find a matching descriptor */
@@ -200,7 +200,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 		usercall =3D jrp->entinfo[sw_idx].callbk;
 		userarg =3D jrp->entinfo[sw_idx].cbkarg;
 		userdesc =3D jrp->entinfo[sw_idx].desc_addr_virt;
-		userstatus =3D jrp->outring[hw_idx].jrstatus;
+		userstatus =3D caam32_to_cpu(jrp->outring[hw_idx].jrstatus);
=20
 		/*
 		 * Make sure all information from the job has been obtained
@@ -330,7 +330,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	int head, tail, desc_size;
 	dma_addr_t desc_dma;
=20
-	desc_size =3D (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
+	desc_size =3D (caam32_to_cpu(*desc) & HDR_JD_LENGTH_MASK) * sizeof(u3=
2);
 	desc_dma =3D dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, desc_dma)) {
 		dev_err(dev, "caam_jr_enqueue(): can't map jobdesc\n");
@@ -356,7 +356,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry->cbkarg =3D areq;
 	head_entry->desc_addr_dma =3D desc_dma;
=20
-	jrp->inpring[jrp->inp_ring_write_index] =3D desc_dma;
+	jrp->inpring[jrp->inp_ring_write_index] =3D wr_dma(desc_dma);
=20
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index a8a79975682f..d3e93e066cd8 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -65,7 +65,7 @@
  *
  */
=20
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 /* These are common macros for Power, put here for ARM */
 #define setbits32(_addr, _v) writel((readl(_addr) | (_v)), (_addr))
 #define clrbits32(_addr, _v) writel((readl(_addr) & ~(_v)), (_addr))
@@ -86,26 +86,62 @@
 #define clrsetbits_le32(addr, clear, set) clrsetbits(le32, addr, clear=
, set)
 #endif
=20
-#ifdef __BIG_ENDIAN
-#define wr_reg32(reg, data) out_be32(reg, data)
-#define rd_reg32(reg) in_be32(reg)
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
+#define caam16_to_cpu(value) le16_to_cpu(value)
+#define cpu_to_caam16(value) cpu_to_le16(value)
+#define caam32_to_cpu(value) le32_to_cpu(value)
+#define cpu_to_caam32(value) cpu_to_le32(value)
+#define caam64_to_cpu(value) le64_to_cpu(value)
+#define cpu_to_caam64(value) cpu_to_le64(value)
+#define wr_reg32(reg, data) iowrite32(data, reg)
+#define rd_reg32(reg) ioread32(reg)
+#define clrsetbits_32(addr, clear, set) clrsetbits_le32(addr, clear, s=
et)
+#else
+#define caam16_to_cpu(value) be16_to_cpu(value)
+#define cpu_to_caam16(value) cpu_to_be16(value)
+#define caam32_to_cpu(value) be32_to_cpu(value)
+#define cpu_to_caam32(value) cpu_to_be32(value)
+#define caam64_to_cpu(value) be64_to_cpu(value)
+#define cpu_to_caam64(value) cpu_to_be64(value)
+#define wr_reg32(reg, data) iowrite32be(data, reg)
+#define rd_reg32(reg) ioread32be(reg)
 #define clrsetbits_32(addr, clear, set) clrsetbits_be32(addr, clear, s=
et)
-#ifdef CONFIG_64BIT
-#define wr_reg64(reg, data) out_be64(reg, data)
-#define rd_reg64(reg) in_be64(reg)
 #endif
+
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#ifdef CONFIG_SOC_IMX7D
+#define wr_dma(value) (((u64)cpu_to_caam32(lower_32_bits(value)) << 32=
) | \
+			(u64)cpu_to_caam32(higher_32_bits(value)))
+#define rd_dma(value) (((u64)caam32_to_cpu(lower_32_bits(value)) << 32=
) | \
+			(u64)caam32_to_cpu(higher_32_bits(value)))
 #else
-#ifdef __LITTLE_ENDIAN
-#define wr_reg32(reg, data) __raw_writel(data, reg)
-#define rd_reg32(reg) __raw_readl(reg)
-#define clrsetbits_32(addr, clear, set) clrsetbits_le32(addr, clear, s=
et)
-#ifdef CONFIG_64BIT
-#define wr_reg64(reg, data) __raw_writeq(data, reg)
-#define rd_reg64(reg) __raw_readq(reg)
-#endif
-#endif
+#define wr_dma(value) cpu_to_caam64(value)
+#define rd_dma(value) caam64_to_cpu(value)
+#endif /* CONFIG_SOC_IMX7D */
+#else
+#define wr_dma(value) cpu_to_caam32(value)
+#define rd_dma(value) caam32_to_cpu(value)
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifdef CONFIG_PPC
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
+#define wr_reg64(reg, data) out_le64(reg, data)
+#define rd_reg64(reg) in_le64(reg)
+#else
+#define wr_reg64(reg, data) out_be64(reg, data)
+#define rd_reg64(reg) in_be64(reg)
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_LE */
+#else /* CONFIG_PPC */
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
+#define wr_reg64(reg, data) writeq(data, reg)
+#define rd_reg64(reg) readq(reg)
+#else
+#define wr_reg64(reg, data) iowrite64be(data, reg)
+#define rd_reg64(reg) ioread64be(reg)
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_LE */
+#endif /* CONFIG_PPC */
+#else /* CONFIG_64BIT */
 /*
  * The only users of these wr/rd_reg64 functions is the Job Ring (JR).
  * The DMA address registers in the JR are handled differently dependi=
ng on
@@ -123,8 +159,6 @@
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-
-#ifndef CONFIG_64BIT
 #if !defined(CONFIG_CRYPTO_DEV_FSL_CAAM_LE) || \
 	defined(CONFIG_CRYPTO_DEV_FSL_CAAM_IMX)
 #define REG64_MS32(reg) ((u32 __iomem *)(reg))
@@ -145,7 +179,7 @@ static inline u64 rd_reg64(u64 __iomem *reg)
 	return ((u64)rd_reg32(REG64_MS32(reg)) << 32 |
 		(u64)rd_reg32(REG64_LS32(reg)));
 }
-#endif
+#endif /* CONFIG_64BIT */
=20
 /*
  * jr_outentry
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_=
sw_sec4.h
index 18cd6d1f5870..fb8e0084e3e5 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -5,6 +5,8 @@
  *
  */
=20
+#include "regs.h"
+
 struct sec4_sg_entry;
=20
 /*
@@ -13,10 +15,10 @@ struct sec4_sg_entry;
 static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_pt=
r,
 				      dma_addr_t dma, u32 len, u32 offset)
 {
-	sec4_sg_ptr->ptr =3D dma;
-	sec4_sg_ptr->len =3D len;
+	sec4_sg_ptr->ptr =3D wr_dma(dma);
+	sec4_sg_ptr->len =3D cpu_to_caam32(len);
 	sec4_sg_ptr->buf_pool_id =3D 0;
-	sec4_sg_ptr->offset =3D offset;
+	sec4_sg_ptr->offset =3D cpu_to_caam16(offset & SEC4_SG_OFFS_MASK);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "sec4_sg_ptr@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sec4_sg_ptr,
@@ -51,7 +53,7 @@ static inline void sg_to_sec4_sg_last(struct scatterl=
ist *sg, int sg_count,
 				      u32 offset)
 {
 	sec4_sg_ptr =3D sg_to_sec4_sg(sg, sg_count, sec4_sg_ptr, offset);
-	sec4_sg_ptr->len |=3D SEC4_SG_LEN_FIN;
+	sec4_sg_ptr->len |=3D cpu_to_caam32(SEC4_SG_LEN_FIN);
 }
=20
 static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
--=20
2.4.4
