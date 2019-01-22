Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D26C282C4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA30D21019
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfAVP1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:27:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38639 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbfAVP1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:27:10 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <rhi@pengutronix.de>)
        id 1glxxC-0003nt-R7; Tue, 22 Jan 2019 16:27:06 +0100
Received: from rhi by dude.hi.pengutronix.de with local (Exim 4.92-RC4)
        (envelope-from <rhi@pengutronix.de>)
        id 1glxxC-0000Kl-Gj; Tue, 22 Jan 2019 16:27:06 +0100
From:   Roland Hieber <rhi@pengutronix.de>
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
Cc:     Roland Hieber <r.hieber@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Date:   Tue, 22 Jan 2019 16:26:51 +0100
Message-Id: <20190122152651.1150-1-rhi@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: rhi@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On a v4.19 i.MX6 system with IMA and CONFIG_DMA_API_DEBUG enabled, a
warning is generated when accessing files on a filesystem for which IMA
measurement is enabled:

    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:1181 check_for_stack.part.9+0xd0/0x120
    caam_jr 2101000.jr0: DMA-API: device driver maps memory from stack [addr=b668049e]
    Modules linked in:
    CPU: 0 PID: 1 Comm: switch_root Not tainted 4.19.0-20181214-1 #2
    Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
    Backtrace:
    [<c010efb8>] (dump_backtrace) from [<c010f2d0>] (show_stack+0x20/0x24)
    [<c010f2b0>] (show_stack) from [<c08b04f4>] (dump_stack+0xa0/0xcc)
    [<c08b0454>] (dump_stack) from [<c012b610>] (__warn+0xf0/0x108)
    [<c012b520>] (__warn) from [<c012b680>] (warn_slowpath_fmt+0x58/0x74)
    [<c012b62c>] (warn_slowpath_fmt) from [<c0199acc>] (check_for_stack.part.9+0xd0/0x120)
    [<c01999fc>] (check_for_stack.part.9) from [<c019a040>] (debug_dma_map_page+0x144/0x174)
    [<c0199efc>] (debug_dma_map_page) from [<c065f7f4>] (ahash_final_ctx+0x5b4/0xcf0)
    [<c065f240>] (ahash_final_ctx) from [<c065b3c4>] (ahash_final+0x1c/0x20)
    [<c065b3a8>] (ahash_final) from [<c03fe278>] (crypto_ahash_op+0x38/0x80)
    [<c03fe240>] (crypto_ahash_op) from [<c03fe2e0>] (crypto_ahash_final+0x20/0x24)
    [<c03fe2c0>] (crypto_ahash_final) from [<c03f19a8>] (ima_calc_file_hash+0x29c/0xa40)
    [<c03f170c>] (ima_calc_file_hash) from [<c03f2b24>] (ima_collect_measurement+0x1dc/0x240)
    [<c03f2948>] (ima_collect_measurement) from [<c03f0a60>] (process_measurement+0x4c4/0x6b8)
    [<c03f059c>] (process_measurement) from [<c03f0cdc>] (ima_file_check+0x88/0xa4)
    [<c03f0c54>] (ima_file_check) from [<c02d8adc>] (path_openat+0x5d8/0x1364)
    [<c02d8504>] (path_openat) from [<c02dad24>] (do_filp_open+0x84/0xf0)
    [<c02daca0>] (do_filp_open) from [<c02cf50c>] (do_open_execat+0x84/0x1b0)
    [<c02cf488>] (do_open_execat) from [<c02d1058>] (__do_execve_file+0x43c/0x890)
    [<c02d0c1c>] (__do_execve_file) from [<c02d1770>] (sys_execve+0x44/0x4c)
    [<c02d172c>] (sys_execve) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
    ---[ end trace 3455789a10e3aefd ]---

The cause is that the struct ahash_request *req is created as a
stack-local variable up in the stack (presumably somewhere in the IMA
implementation), then passed down into the CAAM driver, which tries to
dma_single_map the req->result (indirectly via map_seq_out_ptr_result)
in order to make that buffer available for the CAAM to store the result
of the following hash operation.

The calling code doesn't know how req will be used by the CAAM driver,
and there could be other such occurrences where stack memory is passed
down to the CAAM driver. Therefore we should rather fix this issue in
the CAAM driver where the requirements are known.

The problem is solved by introducing a temporary buffer in the auxiliary
struct ahash_edesc, which is kmalloc'ed and can be DMA-mapped safely to
receive the result from hardware. Then the result is copied back into
req->result in the respective done callbacks that are called when the
CAAM has finished the request.

Other hardware crypto drivers which use DMA also solve it this way, see
for example atmel_sha_copy_ready_hash() in drivers/crypto/atmel-sha.c.

Supplementary for the above stack trace, fix the issue also in other
code paths which show the same usage pattern of req->request.

Cc: stable@vger.kernel.org
Signed-off-by: Roland Hieber <rhi@pengutronix.de>
---
 drivers/crypto/caam/caamhash.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b65e2e54c5625..3f425d3bf6972 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -426,7 +426,8 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 
 /*
  * ahash_edesc - s/w-extended ahash descriptor
- * @dst_dma: physical mapped address of req->result
+ * @result: temporary heap buffer to hold req->result
+ * @dst_dma: physical mapped address of result
  * @sec4_sg_dma: physical mapped address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
@@ -434,6 +435,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
  * @sec4_sg: h/w link table
  */
 struct ahash_edesc {
+	u8 result[CAAM_MAX_HASH_KEY_SIZE];
 	dma_addr_t dst_dma;
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
@@ -498,6 +500,7 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap(jrdev, edesc, req, digestsize);
+	memcpy(req->result, edesc->result, digestsize);
 	kfree(edesc);
 
 #ifdef DEBUG
@@ -567,6 +570,7 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 		caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_TO_DEVICE);
+	memcpy(req->result, edesc->result, digestsize);
 	kfree(edesc);
 
 #ifdef DEBUG
@@ -858,7 +862,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len + buflen,
 			  LDST_SGF);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, edesc->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
@@ -945,7 +949,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	if (ret)
 		goto unmap_ctx;
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, edesc->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
@@ -1023,7 +1027,7 @@ static int ahash_digest(struct ahash_request *req)
 
 	desc = edesc->hw_desc;
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, edesc->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
@@ -1083,7 +1087,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		append_seq_in_ptr(desc, state->buf_dma, buflen, 0);
 	}
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, edesc->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
@@ -1298,7 +1302,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		goto unmap;
 	}
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, edesc->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
-- 
2.20.1

