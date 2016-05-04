From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 5/7] crypto: caam - handle core endianness != caam endianness
Date: Wed, 4 May 2016 20:16:53 +0300
Message-ID: <1462382213-12171-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	"Alexandru Porosanu" <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	"Fabio Estevam" <fabio.estevam@nxp.com>,
	Steve Cornelius <steve.cornelius@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:1104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754668AbcEDRRE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 13:17:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are SoCs like LS1043A where CAAM endianness (BE) does not match
the default endianness of the core (LE).
Moreover, there are requirements for the driver to handle cases like
CPU_BIG_ENDIAN=3Dy on ARM-based SoCs.
This requires for a complete rewrite of the I/O accessors.

PPC-specific accessors - {in,out}_{le,be}XX - are replaced with
generic ones - io{read,write}[be]XX.

Endianness is detected dynamically (at runtime) to allow for
multiplatform kernels, for e.g. running the same kernel image
on LS1043A (BE CAAM) and LS2080A (LE CAAM) armv8-based SoCs.

While here: debugfs entries need to take into consideration the
endianness of the core when displaying data. Add the necessary
glue code so the entries remain the same, but they are properly
read, regardless of the core and/or SEC endianness.

Note: pdb.h fixes only what is currently being used (IPsec).

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>
---
 drivers/crypto/caam/Kconfig       |   4 -
 drivers/crypto/caam/caamhash.c    |   5 +-
 drivers/crypto/caam/ctrl.c        | 125 +++++++++++++++++++-----------=
-
 drivers/crypto/caam/desc.h        |   7 +-
 drivers/crypto/caam/desc_constr.h |  44 +++++++----
 drivers/crypto/caam/jr.c          |  22 +++---
 drivers/crypto/caam/pdb.h         | 137 ++++++++++++++++++++++++++----=
----
 drivers/crypto/caam/regs.h        | 151 +++++++++++++++++++++++++-----=
--------
 drivers/crypto/caam/sg_sw_sec4.h  |  11 +--
 9 files changed, 340 insertions(+), 166 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 5652a53415dc..d2c2909a4020 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -116,10 +116,6 @@ config CRYPTO_DEV_FSL_CAAM_IMX
 	def_bool SOC_IMX6 || SOC_IMX7D
 	depends on CRYPTO_DEV_FSL_CAAM
=20
-config CRYPTO_DEV_FSL_CAAM_LE
-	def_bool CRYPTO_DEV_FSL_CAAM_IMX || SOC_LS1021A
-	depends on CRYPTO_DEV_FSL_CAAM
-
 config CRYPTO_DEV_FSL_CAAM_DEBUG
 	bool "Enable debug output in CAAM driver"
 	depends on CRYPTO_DEV_FSL_CAAM
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamh=
ash.c
index 5845d4a08797..f1ecc8df8d41 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -847,7 +847,7 @@ static int ahash_update_ctx(struct ahash_request *r=
eq)
 							 *next_buflen, 0);
 		} else {
 			(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=3D
-							SEC4_SG_LEN_FIN;
+				cpu_to_caam32(SEC4_SG_LEN_FIN);
 		}
=20
 		state->current_buf =3D !state->current_buf;
@@ -949,7 +949,8 @@ static int ahash_final_ctx(struct ahash_request *re=
q)
 	state->buf_dma =3D try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
 						last_buflen);
-	(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=3D SEC4_SG_LEN_FIN;
+	(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=3D
+		cpu_to_caam32(SEC4_SG_LEN_FIN);
=20
 	edesc->sec4_sg_dma =3D dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 44d30b45f3cc..1c8e764872ae 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -15,6 +15,9 @@
 #include "desc_constr.h"
 #include "error.h"
=20
+bool caam_little_end;
+EXPORT_SYMBOL(caam_little_end);
+
 /*
  * i.MX targets tend to have clock control subsystems that can
  * enable/disable clocking to our device.
@@ -106,7 +109,7 @@ static inline int run_descriptor_deco0(struct devic=
e *ctrldev, u32 *desc,
=20
=20
 	if (ctrlpriv->virt_en =3D=3D 1) {
-		setbits32(&ctrl->deco_rsr, DECORSR_JR0);
+		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);
=20
 		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
 		       --timeout)
@@ -115,7 +118,7 @@ static inline int run_descriptor_deco0(struct devic=
e *ctrldev, u32 *desc,
 		timeout =3D 100000;
 	}
=20
-	setbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
+	clrsetbits_32(&ctrl->deco_rq, 0, DECORR_RQD0ENABLE);
=20
 	while (!(rd_reg32(&ctrl->deco_rq) & DECORR_DEN0) &&
 								 --timeout)
@@ -123,12 +126,12 @@ static inline int run_descriptor_deco0(struct dev=
ice *ctrldev, u32 *desc,
=20
 	if (!timeout) {
 		dev_err(ctrldev, "failed to acquire DECO 0\n");
-		clrbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
+		clrsetbits_32(&ctrl->deco_rq, DECORR_RQD0ENABLE, 0);
 		return -ENODEV;
 	}
=20
 	for (i =3D 0; i < desc_len(desc); i++)
-		wr_reg32(&deco->descbuf[i], *(desc + i));
+		wr_reg32(&deco->descbuf[i], caam32_to_cpu(*(desc + i)));
=20
 	flags =3D DECO_JQCR_WHL;
 	/*
@@ -139,7 +142,7 @@ static inline int run_descriptor_deco0(struct devic=
e *ctrldev, u32 *desc,
 		flags |=3D DECO_JQCR_FOUR;
=20
 	/* Instruct the DECO to execute it */
-	setbits32(&deco->jr_ctl_hi, flags);
+	clrsetbits_32(&deco->jr_ctl_hi, 0, flags);
=20
 	timeout =3D 10000000;
 	do {
@@ -158,10 +161,10 @@ static inline int run_descriptor_deco0(struct dev=
ice *ctrldev, u32 *desc,
 		  DECO_OP_STATUS_HI_ERR_MASK;
=20
 	if (ctrlpriv->virt_en =3D=3D 1)
-		clrbits32(&ctrl->deco_rsr, DECORSR_JR0);
+		clrsetbits_32(&ctrl->deco_rsr, DECORSR_JR0, 0);
=20
 	/* Mark the DECO as free */
-	clrbits32(&ctrl->deco_rq, DECORR_RQD0ENABLE);
+	clrsetbits_32(&ctrl->deco_rq, DECORR_RQD0ENABLE, 0);
=20
 	if (!timeout)
 		return -EAGAIN;
@@ -349,7 +352,7 @@ static void kick_trng(struct platform_device *pdev,=
 int ent_delay)
 	r4tst =3D &ctrl->r4tst[0];
=20
 	/* put RNG4 into program mode */
-	setbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM);
=20
 	/*
 	 * Performance-wise, it does not make sense to
@@ -363,7 +366,7 @@ static void kick_trng(struct platform_device *pdev,=
 int ent_delay)
 	      >> RTSDCTL_ENT_DLY_SHIFT;
 	if (ent_delay <=3D val) {
 		/* put RNG4 into run mode */
-		clrbits32(&r4tst->rtmctl, RTMCTL_PRGM);
+		clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM, 0);
 		return;
 	}
=20
@@ -381,9 +384,9 @@ static void kick_trng(struct platform_device *pdev,=
 int ent_delay)
 	 * select raw sampling in both entropy shifter
 	 * and statistical checker
 	 */
-	setbits32(&val, RTMCTL_SAMP_MODE_RAW_ES_SC);
+	clrsetbits_32(&val, 0, RTMCTL_SAMP_MODE_RAW_ES_SC);
 	/* put RNG4 into run mode */
-	clrbits32(&val, RTMCTL_PRGM);
+	clrsetbits_32(&val, RTMCTL_PRGM, 0);
 	/* write back the control register */
 	wr_reg32(&r4tst->rtmctl, val);
 }
@@ -406,6 +409,23 @@ int caam_get_era(void)
 }
 EXPORT_SYMBOL(caam_get_era);
=20
+#ifdef CONFIG_DEBUG_FS
+static int caam_debugfs_u64_get(void *data, u64 *val)
+{
+	*val =3D caam64_to_cpu(*(u64 *)data);
+	return 0;
+}
+
+static int caam_debugfs_u32_get(void *data, u64 *val)
+{
+	*val =3D caam32_to_cpu(*(u32 *)data);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, =
"%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, =
"%llu\n");
+#endif
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -504,6 +524,10 @@ static int caam_probe(struct platform_device *pdev=
)
 		ret =3D -ENOMEM;
 		goto disable_caam_emi_slow;
 	}
+
+	caam_little_end =3D !(bool)(rd_reg32(&ctrl->perfmon.status) &
+				  (CSTA_PLEND | CSTA_ALT_PLEND));
+
 	/* Finding the page size for using the CTPR_MS register */
 	comp_params =3D rd_reg32(&ctrl->perfmon.comp_parms_ms);
 	pg_size =3D (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT=
;
@@ -559,9 +583,9 @@ static int caam_probe(struct platform_device *pdev)
 	}
=20
 	if (ctrlpriv->virt_en =3D=3D 1)
-		setbits32(&ctrl->jrstart, JRSTART_JR0_START |
-			  JRSTART_JR1_START | JRSTART_JR2_START |
-			  JRSTART_JR3_START);
+		clrsetbits_32(&ctrl->jrstart, 0, JRSTART_JR0_START |
+			      JRSTART_JR1_START | JRSTART_JR2_START |
+			      JRSTART_JR3_START);
=20
 	if (sizeof(dma_addr_t) =3D=3D sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
@@ -693,7 +717,7 @@ static int caam_probe(struct platform_device *pdev)
 		ctrlpriv->rng4_sh_init =3D ~ctrlpriv->rng4_sh_init & RDSTA_IFMASK;
=20
 		/* Enable RDB bit so that RNG works faster */
-		setbits32(&ctrl->scfgr, SCFGR_RDBENABLE);
+		clrsetbits_32(&ctrl->scfgr, 0, SCFGR_RDBENABLE);
 	}
=20
 	/* NOTE: RTIC detection ought to go here, around Si time */
@@ -719,48 +743,59 @@ static int caam_probe(struct platform_device *pde=
v)
 	ctrlpriv->ctl =3D debugfs_create_dir("ctl", ctrlpriv->dfs_root);
=20
 	/* Controller-level - performance monitor counters */
+
 	ctrlpriv->ctl_rq_dequeued =3D
-		debugfs_create_u64("rq_dequeued",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->req_dequeued);
+		debugfs_create_file("rq_dequeued",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->req_dequeued,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ob_enc_req =3D
-		debugfs_create_u64("ob_rq_encrypted",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ob_enc_req);
+		debugfs_create_file("ob_rq_encrypted",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ob_enc_req,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ib_dec_req =3D
-		debugfs_create_u64("ib_rq_decrypted",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ib_dec_req);
+		debugfs_create_file("ib_rq_decrypted",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ib_dec_req,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ob_enc_bytes =3D
-		debugfs_create_u64("ob_bytes_encrypted",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ob_enc_bytes);
+		debugfs_create_file("ob_bytes_encrypted",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ob_enc_bytes,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ob_prot_bytes =3D
-		debugfs_create_u64("ob_bytes_protected",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ob_prot_bytes);
+		debugfs_create_file("ob_bytes_protected",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ob_prot_bytes,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ib_dec_bytes =3D
-		debugfs_create_u64("ib_bytes_decrypted",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ib_dec_bytes);
+		debugfs_create_file("ib_bytes_decrypted",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ib_dec_bytes,
+				    &caam_fops_u64_ro);
 	ctrlpriv->ctl_ib_valid_bytes =3D
-		debugfs_create_u64("ib_bytes_validated",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->ib_valid_bytes);
+		debugfs_create_file("ib_bytes_validated",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->ib_valid_bytes,
+				    &caam_fops_u64_ro);
=20
 	/* Controller level - global status values */
 	ctrlpriv->ctl_faultaddr =3D
-		debugfs_create_u64("fault_addr",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->faultaddr);
+		debugfs_create_file("fault_addr",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->faultaddr,
+				    &caam_fops_u32_ro);
 	ctrlpriv->ctl_faultdetail =3D
-		debugfs_create_u32("fault_detail",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->faultdetail);
+		debugfs_create_file("fault_detail",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->faultdetail,
+				    &caam_fops_u32_ro);
 	ctrlpriv->ctl_faultstatus =3D
-		debugfs_create_u32("fault_status",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   ctrlpriv->ctl, &perfmon->status);
+		debugfs_create_file("fault_status",
+				    S_IRUSR | S_IRGRP | S_IROTH,
+				    ctrlpriv->ctl, &perfmon->status,
+				    &caam_fops_u32_ro);
=20
 	/* Internal covering keys (useful in non-secure mode only) */
 	ctrlpriv->ctl_kek_wrap.data =3D &ctrlpriv->ctrl->kek[0];
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index fe30ff69088c..d8d5584b600b 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -23,16 +23,15 @@
 #define SEC4_SG_OFFSET_MASK	0x00001fff
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
-	u8 rsvd2;
-	u8 buf_pool_id;
-	u16 offset;
+	u32 bpid_offset;
 };
=20
 /* Max size of any CAAM descriptor in 32-bit words, inclusive of heade=
r */
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/de=
sc_constr.h
index 98d07de24fc4..ae3aef6e9fee 100644
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
@@ -30,9 +31,11 @@
 			       LDST_SRCDST_WORD_DECOCTRL | \
 			       (LDOFF_ENABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
=20
+extern bool caam_little_end;
+
 static inline int desc_len(u32 *desc)
 {
-	return *desc & HDR_DESCLEN_MASK;
+	return caam32_to_cpu(*desc) & HDR_DESCLEN_MASK;
 }
=20
 static inline int desc_bytes(void *desc)
@@ -52,7 +55,7 @@ static inline void *sh_desc_pdb(u32 *desc)
=20
 static inline void init_desc(u32 *desc, u32 options)
 {
-	*desc =3D (options | HDR_ONE) + 1;
+	*desc =3D cpu_to_caam32((options | HDR_ONE) + 1);
 }
=20
 static inline void init_sh_desc(u32 *desc, u32 options)
@@ -78,9 +81,10 @@ static inline void append_ptr(u32 *desc, dma_addr_t =
ptr)
 {
 	dma_addr_t *offset =3D (dma_addr_t *)desc_end(desc);
=20
-	*offset =3D ptr;
+	*offset =3D cpu_to_caam_dma(ptr);
=20
-	(*desc) +=3D CAAM_PTR_SZ / CAAM_CMD_SZ;
+	(*desc) =3D cpu_to_caam32(caam32_to_cpu(*desc) +
+				CAAM_PTR_SZ / CAAM_CMD_SZ);
 }
=20
 static inline void init_job_desc_shared(u32 *desc, dma_addr_t ptr, int=
 len,
@@ -99,16 +103,17 @@ static inline void append_data(u32 *desc, void *da=
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
@@ -117,16 +122,22 @@ static inline void append_u64(u32 *desc, u64 data=
)
 {
 	u32 *offset =3D desc_end(desc);
=20
-	*offset =3D upper_32_bits(data);
-	*(++offset) =3D lower_32_bits(data);
+	/* Only 32-bit alignment is guaranteed in descriptor buffer */
+	if (caam_little_end) {
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
@@ -168,14 +179,17 @@ APPEND_CMD_RET(move, MOVE)
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
index 6fd63a600614..90aaa72ce0d0 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -31,7 +31,7 @@ static int caam_reset_hw_jr(struct device *dev)
 	 * mask interrupts since we are going to poll
 	 * for reset completion status
 	 */
-	setbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JRCFG_IMSK);
=20
 	/* initiate flush (required prior to reset) */
 	wr_reg32(&jrp->rregs->jrcommand, JRCR_RESET);
@@ -57,7 +57,7 @@ static int caam_reset_hw_jr(struct device *dev)
 	}
=20
 	/* unmask interrupts */
-	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+	clrsetbits_32(&jrp->rregs->rconfig_lo, JRCFG_IMSK, 0);
=20
 	return 0;
 }
@@ -147,7 +147,7 @@ static irqreturn_t caam_jr_interrupt(int irq, void =
*st_dev)
 	}
=20
 	/* mask valid interrupts */
-	setbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JRCFG_IMSK);
=20
 	/* Have valid interrupt at this point, just ACK and trigger */
 	wr_reg32(&jrp->rregs->jrintstatus, irqstate);
@@ -182,7 +182,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 			sw_idx =3D (tail + i) & (JOBR_DEPTH - 1);
=20
 			if (jrp->outring[hw_idx].desc =3D=3D
-			    jrp->entinfo[sw_idx].desc_addr_dma)
+			    caam_dma_to_cpu(jrp->entinfo[sw_idx].desc_addr_dma))
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
@@ -236,7 +236,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 	}
=20
 	/* reenable / unmask IRQs */
-	clrbits32(&jrp->rregs->rconfig_lo, JRCFG_IMSK);
+	clrsetbits_32(&jrp->rregs->rconfig_lo, JRCFG_IMSK, 0);
 }
=20
 /**
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
+	jrp->inpring[jrp->inp_ring_write_index] =3D cpu_to_caam_dma(desc_dma)=
;
=20
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
@@ -444,9 +444,9 @@ static int caam_jr_init(struct device *dev)
 	spin_lock_init(&jrp->outlock);
=20
 	/* Select interrupt coalescing parameters */
-	setbits32(&jrp->rregs->rconfig_lo, JOBR_INTC |
-		  (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
-		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
+	clrsetbits_32(&jrp->rregs->rconfig_lo, 0, JOBR_INTC |
+		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
+		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
=20
 	return 0;
=20
diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 3a87c0cf879a..fa60c4573131 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -11,8 +11,8 @@
 /*
  * PDB- IPSec ESP Header Modification Options
  */
-#define PDBHMO_ESP_DECAP_SHIFT	12
-#define PDBHMO_ESP_ENCAP_SHIFT	4
+#define PDBHMO_ESP_DECAP_SHIFT	28
+#define PDBHMO_ESP_ENCAP_SHIFT	28
 /*
  * Encap and Decap - Decrement TTL (Hop Limit) - Based on the value of=
 the
  * Options Byte IP version (IPvsn) field:
@@ -32,12 +32,23 @@
  */
 #define PDBHMO_ESP_DFBIT		(0x04 << PDBHMO_ESP_ENCAP_SHIFT)
=20
+#define PDBNH_ESP_ENCAP_SHIFT		16
+#define PDBNH_ESP_ENCAP_MASK		(0xff << PDBNH_ESP_ENCAP_SHIFT)
+
+#define PDBHDRLEN_ESP_DECAP_SHIFT	16
+#define PDBHDRLEN_MASK			(0x0fff << PDBHDRLEN_ESP_DECAP_SHIFT)
+
+#define PDB_NH_OFFSET_SHIFT		8
+#define PDB_NH_OFFSET_MASK		(0xff << PDB_NH_OFFSET_SHIFT)
+
 /*
  * PDB - IPSec ESP Encap/Decap Options
  */
 #define PDBOPTS_ESP_ARSNONE	0x00 /* no antireplay window */
 #define PDBOPTS_ESP_ARS32	0x40 /* 32-entry antireplay window */
+#define PDBOPTS_ESP_ARS128	0x80 /* 128-entry antireplay window */
 #define PDBOPTS_ESP_ARS64	0xc0 /* 64-entry antireplay window */
+#define PDBOPTS_ESP_ARS_MASK	0xc0 /* antireplay window mask */
 #define PDBOPTS_ESP_IVSRC	0x20 /* IV comes from internal random gen */
 #define PDBOPTS_ESP_ESN		0x10 /* extended sequence included */
 #define PDBOPTS_ESP_OUTFMT	0x08 /* output only decapsulation (decap) *=
/
@@ -54,35 +65,73 @@
 /*
  * General IPSec encap/decap PDB definitions
  */
+
+/**
+ * ipsec_encap_cbc - PDB part for IPsec CBC encapsulation
+ * @iv: 16-byte array initialization vector
+ */
 struct ipsec_encap_cbc {
-	u32 iv[4];
+	u8 iv[16];
 };
=20
+/**
+ * ipsec_encap_ctr - PDB part for IPsec CTR encapsulation
+ * @ctr_nonce: 4-byte array nonce
+ * @ctr_initial: initial count constant
+ * @iv: initialization vector
+ */
 struct ipsec_encap_ctr {
-	u32 ctr_nonce;
+	u8 ctr_nonce[4];
 	u32 ctr_initial;
-	u32 iv[2];
+	u64 iv;
 };
=20
+/**
+ * ipsec_encap_ccm - PDB part for IPsec CCM encapsulation
+ * @salt: 3-byte array salt (lower 24 bits)
+ * @ccm_opt: CCM algorithm options - MSB-LSB description:
+ *  b0_flags (8b) - CCM B0; use 0x5B for 8-byte ICV, 0x6B for 12-byte =
ICV,
+ *    0x7B for 16-byte ICV (cf. RFC4309, RFC3610)
+ *  ctr_flags (8b) - counter flags; constant equal to 0x3
+ *  ctr_initial (16b) - initial count constant
+ * @iv: initialization vector
+ */
 struct ipsec_encap_ccm {
-	u32 salt; /* lower 24 bits */
-	u8 b0_flags;
-	u8 ctr_flags;
-	u16 ctr_initial;
-	u32 iv[2];
+	u8 salt[4];
+	u32 ccm_opt;
+	u64 iv;
 };
=20
+/**
+ * ipsec_encap_gcm - PDB part for IPsec GCM encapsulation
+ * @salt: 3-byte array salt (lower 24 bits)
+ * @rsvd: reserved, do not use
+ * @iv: initialization vector
+ */
 struct ipsec_encap_gcm {
-	u32 salt; /* lower 24 bits */
+	u8 salt[4];
 	u32 rsvd1;
-	u32 iv[2];
+	u64 iv;
 };
=20
+/**
+ * ipsec_encap_pdb - PDB for IPsec encapsulation
+ * @options: MSB-LSB description
+ *  hmo (header manipulation options) - 4b
+ *  reserved - 4b
+ *  next header - 8b
+ *  next header offset - 8b
+ *  option flags (depend on selected algorithm) - 8b
+ * @seq_num_ext_hi: (optional) IPsec Extended Sequence Number (ESN)
+ * @seq_num: IPsec sequence number
+ * @spi: IPsec SPI (Security Parameters Index)
+ * @ip_hdr_len: optional IP Header length (in bytes)
+ *  reserved - 16b
+ *  Opt. IP Hdr Len - 16b
+ * @ip_hdr: optional IP Header content
+ */
 struct ipsec_encap_pdb {
-	u8 hmo_rsvd;
-	u8 ip_nh;
-	u8 ip_nh_offset;
-	u8 options;
+	u32 options;
 	u32 seq_num_ext_hi;
 	u32 seq_num;
 	union {
@@ -92,36 +141,65 @@ struct ipsec_encap_pdb {
 		struct ipsec_encap_gcm gcm;
 	};
 	u32 spi;
-	u16 rsvd1;
-	u16 ip_hdr_len;
-	u32 ip_hdr[0]; /* optional IP Header content */
+	u32 ip_hdr_len;
+	u32 ip_hdr[0];
 };
=20
+/**
+ * ipsec_decap_cbc - PDB part for IPsec CBC decapsulation
+ * @rsvd: reserved, do not use
+ */
 struct ipsec_decap_cbc {
 	u32 rsvd[2];
 };
=20
+/**
+ * ipsec_decap_ctr - PDB part for IPsec CTR decapsulation
+ * @ctr_nonce: 4-byte array nonce
+ * @ctr_initial: initial count constant
+ */
 struct ipsec_decap_ctr {
-	u32 salt;
+	u8 ctr_nonce[4];
 	u32 ctr_initial;
 };
=20
+/**
+ * ipsec_decap_ccm - PDB part for IPsec CCM decapsulation
+ * @salt: 3-byte salt (lower 24 bits)
+ * @ccm_opt: CCM algorithm options - MSB-LSB description:
+ *  b0_flags (8b) - CCM B0; use 0x5B for 8-byte ICV, 0x6B for 12-byte =
ICV,
+ *    0x7B for 16-byte ICV (cf. RFC4309, RFC3610)
+ *  ctr_flags (8b) - counter flags; constant equal to 0x3
+ *  ctr_initial (16b) - initial count constant
+ */
 struct ipsec_decap_ccm {
-	u32 salt;
-	u8 iv_flags;
-	u8 ctr_flags;
-	u16 ctr_initial;
+	u8 salt[4];
+	u32 ccm_opt;
 };
=20
+/**
+ * ipsec_decap_gcm - PDB part for IPsec GCN decapsulation
+ * @salt: 4-byte salt
+ * @rsvd: reserved, do not use
+ */
 struct ipsec_decap_gcm {
-	u32 salt;
+	u8 salt[4];
 	u32 resvd;
 };
=20
+/**
+ * ipsec_decap_pdb - PDB for IPsec decapsulation
+ * @options: MSB-LSB description
+ *  hmo (header manipulation options) - 4b
+ *  IP header length - 12b
+ *  next header offset - 8b
+ *  option flags (depend on selected algorithm) - 8b
+ * @seq_num_ext_hi: (optional) IPsec Extended Sequence Number (ESN)
+ * @seq_num: IPsec sequence number
+ * @anti_replay: Anti-replay window; size depends on ARS (option flags=
)
+ */
 struct ipsec_decap_pdb {
-	u16 hmo_ip_hdr_len;
-	u8 ip_nh_offset;
-	u8 options;
+	u32 options;
 	union {
 		struct ipsec_decap_cbc cbc;
 		struct ipsec_decap_ctr ctr;
@@ -130,8 +208,7 @@ struct ipsec_decap_pdb {
 	};
 	u32 seq_num_ext_hi;
 	u32 seq_num;
-	u32 anti_replay[2];
-	u32 end_index[0];
+	be32 anti_replay[4];
 };
=20
 /*
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 0ba9c40597dc..8c766cf9202c 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -8,6 +8,7 @@
 #define REGS_H
=20
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include <linux/io.h>
=20
 /*
@@ -65,46 +66,56 @@
  *
  */
=20
-#ifdef CONFIG_ARM
-/* These are common macros for Power, put here for ARM */
-#define setbits32(_addr, _v) writel((readl(_addr) | (_v)), (_addr))
-#define clrbits32(_addr, _v) writel((readl(_addr) & ~(_v)), (_addr))
+extern bool caam_little_end;
=20
-#define out_arch(type, endian, a, v)	__raw_write##type(cpu_to_##endian=
(v), a)
-#define in_arch(type, endian, a)	endian##_to_cpu(__raw_read##type(a))
+#define caam_to_cpu(len)				\
+static inline u##len caam##len ## _to_cpu(u##len val)	\
+{							\
+	if (caam_little_end)				\
+		return le##len ## _to_cpu(val);		\
+	else						\
+		return be##len ## _to_cpu(val);		\
+}
=20
-#define out_le32(a, v)	out_arch(l, le32, a, v)
-#define in_le32(a)	in_arch(l, le32, a)
+#define cpu_to_caam(len)				\
+static inline u##len cpu_to_caam##len(u##len val)	\
+{							\
+	if (caam_little_end)				\
+		return cpu_to_le##len(val);		\
+	else						\
+		return cpu_to_be##len(val);		\
+}
=20
-#define out_be32(a, v)	out_arch(l, be32, a, v)
-#define in_be32(a)	in_arch(l, be32, a)
+caam_to_cpu(16)
+caam_to_cpu(32)
+caam_to_cpu(64)
+cpu_to_caam(16)
+cpu_to_caam(32)
+cpu_to_caam(64)
=20
-#define clrsetbits(type, addr, clear, set) \
-	out_##type((addr), (in_##type(addr) & ~(clear)) | (set))
+static inline void wr_reg32(void __iomem *reg, u32 data)
+{
+	if (caam_little_end)
+		iowrite32(data, reg);
+	else
+		iowrite32be(data, reg);
+}
=20
-#define clrsetbits_be32(addr, clear, set) clrsetbits(be32, addr, clear=
, set)
-#define clrsetbits_le32(addr, clear, set) clrsetbits(le32, addr, clear=
, set)
-#endif
+static inline u32 rd_reg32(void __iomem *reg)
+{
+	if (caam_little_end)
+		return ioread32(reg);
=20
-#ifdef __BIG_ENDIAN
-#define wr_reg32(reg, data) out_be32(reg, data)
-#define rd_reg32(reg) in_be32(reg)
-#define clrsetbits_32(addr, clear, set) clrsetbits_be32(addr, clear, s=
et)
-#ifdef CONFIG_64BIT
-#define wr_reg64(reg, data) out_be64(reg, data)
-#define rd_reg64(reg) in_be64(reg)
-#endif
-#else
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
-#endif
+	return ioread32be(reg);
+}
+
+static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set=
)
+{
+	if (caam_little_end)
+		iowrite32((ioread32(reg) & ~clear) | set, reg);
+	else
+		iowrite32be((ioread32be(reg) & ~clear) | set, reg);
+}
=20
 /*
  * The only users of these wr/rd_reg64 functions is the Job Ring (JR).
@@ -123,29 +134,67 @@
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
+#ifdef CONFIG_64BIT
+static inline void wr_reg64(void __iomem *reg, u64 data)
+{
+	if (caam_little_end)
+		iowrite64(data, reg);
+	else
+		iowrite64be(data, reg);
+}
=20
-#ifndef CONFIG_64BIT
-#if !defined(CONFIG_CRYPTO_DEV_FSL_CAAM_LE) || \
-	defined(CONFIG_CRYPTO_DEV_FSL_CAAM_IMX)
-#define REG64_MS32(reg) ((u32 __iomem *)(reg))
-#define REG64_LS32(reg) ((u32 __iomem *)(reg) + 1)
-#else
-#define REG64_MS32(reg) ((u32 __iomem *)(reg) + 1)
-#define REG64_LS32(reg) ((u32 __iomem *)(reg))
-#endif
-
-static inline void wr_reg64(u64 __iomem *reg, u64 data)
+static inline u64 rd_reg64(void __iomem *reg)
 {
-	wr_reg32(REG64_MS32(reg), data >> 32);
-	wr_reg32(REG64_LS32(reg), data);
+	if (caam_little_end)
+		return ioread64(reg);
+	else
+		return ioread64be(reg);
 }
=20
-static inline u64 rd_reg64(u64 __iomem *reg)
+#else /* CONFIG_64BIT */
+static inline void wr_reg64(void __iomem *reg, u64 data)
 {
-	return ((u64)rd_reg32(REG64_MS32(reg)) << 32 |
-		(u64)rd_reg32(REG64_LS32(reg)));
+#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
+	if (caam_little_end) {
+		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
+		wr_reg32((u32 __iomem *)(reg), data);
+	} else
+#endif
+	{
+		wr_reg32((u32 __iomem *)(reg), data >> 32);
+		wr_reg32((u32 __iomem *)(reg) + 1, data);
+	}
 }
+
+static inline u64 rd_reg64(void __iomem *reg)
+{
+#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
+	if (caam_little_end)
+		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
+			(u64)rd_reg32((u32 __iomem *)(reg)));
+	else
 #endif
+		return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
+			(u64)rd_reg32((u32 __iomem *)(reg) + 1));
+}
+#endif /* CONFIG_64BIT  */
+
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+#ifdef CONFIG_SOC_IMX7D
+#define cpu_to_caam_dma(value) \
+		(((u64)cpu_to_caam32(lower_32_bits(value)) << 32) | \
+		 (u64)cpu_to_caam32(higher_32_bits(value)))
+#define caam_dma_to_cpu(value) \
+		(((u64)caam32_to_cpu(lower_32_bits(value)) << 32) | \
+		 (u64)caam32_to_cpu(higher_32_bits(value)))
+#else
+#define cpu_to_caam_dma(value) cpu_to_caam64(value)
+#define caam_dma_to_cpu(value) caam64_to_cpu(value)
+#endif /* CONFIG_SOC_IMX7D */
+#else
+#define cpu_to_caam_dma(value) cpu_to_caam32(value)
+#define caam_dma_to_cpu(value) caam32_to_cpu(value)
+#endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT  */
=20
 /*
  * jr_outentry
@@ -249,6 +298,8 @@ struct caam_perfmon {
 	u32 faultliodn;	/* FALR - Fault Address LIODN	*/
 	u32 faultdetail;	/* FADR - Fault Addr Detail	*/
 	u32 rsvd2;
+#define CSTA_PLEND		BIT(10)
+#define CSTA_ALT_PLEND		BIT(18)
 	u32 status;		/* CSTA - CAAM Status */
 	u64 rsvd3;
=20
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_=
sw_sec4.h
index 2311341b7356..19dc64fede0d 100644
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
@@ -13,10 +15,9 @@ struct sec4_sg_entry;
 static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_pt=
r,
 				      dma_addr_t dma, u32 len, u16 offset)
 {
-	sec4_sg_ptr->ptr =3D dma;
-	sec4_sg_ptr->len =3D len;
-	sec4_sg_ptr->buf_pool_id =3D 0;
-	sec4_sg_ptr->offset =3D offset & SEC4_SG_OFFSET_MASK;
+	sec4_sg_ptr->ptr =3D cpu_to_caam_dma(dma);
+	sec4_sg_ptr->len =3D cpu_to_caam32(len);
+	sec4_sg_ptr->bpid_offset =3D cpu_to_caam32(offset & SEC4_SG_OFFSET_MA=
SK);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "sec4_sg_ptr@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sec4_sg_ptr,
@@ -51,7 +52,7 @@ static inline void sg_to_sec4_sg_last(struct scatterl=
ist *sg, int sg_count,
 				      u16 offset)
 {
 	sec4_sg_ptr =3D sg_to_sec4_sg(sg, sg_count, sec4_sg_ptr, offset);
-	sec4_sg_ptr->len |=3D SEC4_SG_LEN_FIN;
+	sec4_sg_ptr->len |=3D cpu_to_caam32(SEC4_SG_LEN_FIN);
 }
=20
 static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
--=20
2.4.4
