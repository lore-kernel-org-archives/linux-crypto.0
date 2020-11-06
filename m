Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB92C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 06:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07482208FE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 06:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgKFGx6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 01:53:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34976 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFGx6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 01:53:58 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavdA-0007v7-Az; Fri, 06 Nov 2020 17:53:53 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 17:53:52 +1100
Date:   Fri, 6 Nov 2020 17:53:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Phani Kiran Hemadri <phemadri@marvell.com>,
        Srikanth Jampala <jsrikanth@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Fix sparse warnings
Message-ID: <20201106065352.GA2731@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes all the sparse warnings in cavium/nitrox:

- Fix endianness warnings by adding the correct markers to unions.
- Add missing header inclusions for prototypes.
- Move nitrox_sriov_configure prototype into the isr header file.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
index 1be2571363fe..e5d8607ecb1d 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -45,9 +45,9 @@ static int nitrox_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 
 	/* fill crypto context */
 	fctx = nctx->u.fctx;
-	flags.f = be64_to_cpu(fctx->flags.f);
+	flags.fu = be64_to_cpu(fctx->flags.f);
 	flags.w0.aes_keylen = aes_keylen;
-	fctx->flags.f = cpu_to_be64(flags.f);
+	fctx->flags.f = cpu_to_be64(flags.fu);
 
 	/* copy enc key to context */
 	memset(&fctx->crypto, 0, sizeof(fctx->crypto));
@@ -63,9 +63,9 @@ static int nitrox_aead_setauthsize(struct crypto_aead *aead,
 	struct flexi_crypto_context *fctx = nctx->u.fctx;
 	union fc_ctx_flags flags;
 
-	flags.f = be64_to_cpu(fctx->flags.f);
+	flags.fu = be64_to_cpu(fctx->flags.f);
 	flags.w0.mac_len = authsize;
-	fctx->flags.f = cpu_to_be64(flags.f);
+	fctx->flags.f = cpu_to_be64(flags.fu);
 
 	aead->authsize = authsize;
 
@@ -319,7 +319,7 @@ static int nitrox_gcm_common_init(struct crypto_aead *aead)
 	flags->w0.iv_source = IV_FROM_DPTR;
 	/* ask microcode to calculate ipad/opad */
 	flags->w0.auth_input_type = 1;
-	flags->f = be64_to_cpu(flags->f);
+	flags->f = cpu_to_be64(flags->fu);
 
 	return 0;
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
index 16f7d0bd1303..741572a01995 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -3,6 +3,7 @@
 #include <linux/debugfs.h>
 
 #include "nitrox_csr.h"
+#include "nitrox_debugfs.h"
 #include "nitrox_dev.h"
 
 static int firmware_show(struct seq_file *s, void *v)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index 34a2f4f30a7e..13b137410b75 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -3,6 +3,7 @@
 
 #include "nitrox_dev.h"
 #include "nitrox_csr.h"
+#include "nitrox_hal.h"
 
 #define PLL_REF_CLK 50
 #define MAX_CSR_RETRIES 10
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 3dec570a190a..99b053094f5a 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -7,6 +7,7 @@
 #include "nitrox_csr.h"
 #include "nitrox_common.h"
 #include "nitrox_hal.h"
+#include "nitrox_isr.h"
 #include "nitrox_mbx.h"
 
 /**
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.h b/drivers/crypto/cavium/nitrox/nitrox_isr.h
index 1062c9336c1f..2bb123cd2f1c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.h
@@ -9,4 +9,13 @@ void nitrox_unregister_interrupts(struct nitrox_device *ndev);
 int nitrox_sriov_register_interupts(struct nitrox_device *ndev);
 void nitrox_sriov_unregister_interrupts(struct nitrox_device *ndev);
 
+#ifdef CONFIG_PCI_IOV
+int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs);
+#else
+static inline int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	return 0;
+}
+#endif
+
 #endif /* __NITROX_ISR_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 9d14be97e381..facc8e6bc580 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -49,15 +49,6 @@ static unsigned int qlen = DEFAULT_CMD_QLEN;
 module_param(qlen, uint, 0644);
 MODULE_PARM_DESC(qlen, "Command queue length - default 2048");
 
-#ifdef CONFIG_PCI_IOV
-int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs);
-#else
-int nitrox_sriov_configure(struct pci_dev *pdev, int num_vfs)
-{
-	return 0;
-}
-#endif
-
 /**
  * struct ucode - Firmware Header
  * @id: microcode ID
@@ -555,10 +546,8 @@ static void nitrox_remove(struct pci_dev *pdev)
 
 	nitrox_remove_from_devlist(ndev);
 
-#ifdef CONFIG_PCI_IOV
 	/* disable SR-IOV */
 	nitrox_sriov_configure(pdev, 0);
-#endif
 	nitrox_crypto_unregister();
 	nitrox_debugfs_exit(ndev);
 	nitrox_pf_sw_cleanup(ndev);
@@ -584,9 +573,7 @@ static struct pci_driver nitrox_driver = {
 	.probe = nitrox_probe,
 	.remove	= nitrox_remove,
 	.shutdown = nitrox_shutdown,
-#ifdef CONFIG_PCI_IOV
 	.sriov_configure = nitrox_sriov_configure,
-#endif
 };
 
 module_pci_driver(nitrox_driver);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index 73993f9e2311..c1af9d4fca6e 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -4,6 +4,7 @@
 #include "nitrox_csr.h"
 #include "nitrox_hal.h"
 #include "nitrox_dev.h"
+#include "nitrox_mbx.h"
 
 #define RING_TO_VFNO(_x, _y)	((_x) / (_y))
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cavium/nitrox/nitrox_req.h
index 12282c1b14f5..ed174883c8e3 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -149,6 +149,7 @@ struct auth_keys {
 
 union fc_ctx_flags {
 	__be64 f;
+	u64 fu;
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
 		u64 cipher_type	: 4;
@@ -280,6 +281,7 @@ struct nitrox_rfc4106_rctx {
  *   - packet payload bytes
  */
 union pkt_instr_hdr {
+	__be64 bev;
 	u64 value;
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
@@ -324,6 +326,7 @@ union pkt_instr_hdr {
  * @ctxp: Context pointer. CTXP<63,2:0> must be zero in all cases.
  */
 union pkt_hdr {
+	__be64 bev[2];
 	u64 value[2];
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
@@ -370,6 +373,7 @@ union pkt_hdr {
  *        sglist components at [RPTR] on the remote host.
  */
 union slc_store_info {
+	__be64 bev[2];
 	u64 value[2];
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 5826c2c98a50..53ef06792133 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -3,6 +3,7 @@
 #include <linux/workqueue.h>
 #include <crypto/internal/skcipher.h>
 
+#include "nitrox_common.h"
 #include "nitrox_dev.h"
 #include "nitrox_req.h"
 #include "nitrox_csr.h"
@@ -448,7 +449,7 @@ int nitrox_process_se_request(struct nitrox_device *ndev,
 	sr->instr.ih.s.ssz = sr->out.sgmap_cnt;
 	sr->instr.ih.s.fsz = FDATA_SIZE + sizeof(struct gphdr);
 	sr->instr.ih.s.tlen = sr->instr.ih.s.fsz + sr->in.total_bytes;
-	sr->instr.ih.value = cpu_to_be64(sr->instr.ih.value);
+	sr->instr.ih.bev = cpu_to_be64(sr->instr.ih.value);
 
 	/* word 2 */
 	sr->instr.irh.value[0] = 0;
@@ -460,7 +461,7 @@ int nitrox_process_se_request(struct nitrox_device *ndev,
 	sr->instr.irh.s.ctxc = req->ctrl.s.ctxc;
 	sr->instr.irh.s.arg = req->ctrl.s.arg;
 	sr->instr.irh.s.opcode = req->opcode;
-	sr->instr.irh.value[0] = cpu_to_be64(sr->instr.irh.value[0]);
+	sr->instr.irh.bev[0] = cpu_to_be64(sr->instr.irh.value[0]);
 
 	/* word 3 */
 	sr->instr.irh.s.ctxp = cpu_to_be64(ctx_handle);
@@ -468,7 +469,7 @@ int nitrox_process_se_request(struct nitrox_device *ndev,
 	/* word 4 */
 	sr->instr.slc.value[0] = 0;
 	sr->instr.slc.s.ssz = sr->out.sgmap_cnt;
-	sr->instr.slc.value[0] = cpu_to_be64(sr->instr.slc.value[0]);
+	sr->instr.slc.bev[0] = cpu_to_be64(sr->instr.slc.value[0]);
 
 	/* word 5 */
 	sr->instr.slc.s.rptr = cpu_to_be64(sr->out.sgcomp_dma);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
