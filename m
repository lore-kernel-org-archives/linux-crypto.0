Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C47C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A1920775
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgFZGGK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 02:06:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51896 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgFZGGK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 02:06:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1johV0-0004U3-5a; Fri, 26 Jun 2020 16:06:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jun 2020 16:06:06 +1000
Date:   Fri, 26 Jun 2020 16:06:06 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        George Cherian <gcherian@marvell.com>
Subject: [PATCH] crypto: cpt - Fix sparse warnings
Message-ID: <20200626060606.GA20741@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes all the sparse warnings in the octeontx driver.
Some of these are just trivial type changes.

However, some of the changes are non-trivial on little-endian hosts.
Obviously the driver appears to be broken on either LE or BE as it
was doing different things.  I've taken the BE behaviour as the
correct one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 2e4bf90c5798..0f0991f9f294 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -99,10 +99,10 @@ static inline u32 create_ctx_hdr(struct skcipher_request *req, u32 enc,
 	struct cvm_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
 	struct fc_context *fctx = &rctx->fctx;
-	u64 *offset_control = &rctx->control_word;
 	u32 enc_iv_len = crypto_skcipher_ivsize(tfm);
 	struct cpt_request_info *req_info = &rctx->cpt_req;
-	u64 *ctrl_flags = NULL;
+	__be64 *ctrl_flags = NULL;
+	__be64 *offset_control;
 
 	req_info->ctrl.s.grp = 0;
 	req_info->ctrl.s.dma_mode = DMA_GATHER_SCATTER;
@@ -126,9 +126,10 @@ static inline u32 create_ctx_hdr(struct skcipher_request *req, u32 enc,
 		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len * 2);
 	else
 		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
-	ctrl_flags = (u64 *)&fctx->enc.enc_ctrl.flags;
-	*ctrl_flags = cpu_to_be64(*ctrl_flags);
+	ctrl_flags = (__be64 *)&fctx->enc.enc_ctrl.flags;
+	*ctrl_flags = cpu_to_be64(fctx->enc.enc_ctrl.flags);
 
+	offset_control = (__be64 *)&rctx->control_word;
 	*offset_control = cpu_to_be64(((u64)(enc_iv_len) << 16));
 	/* Storing  Packet Data Information in offset
 	 * Control Word First 8 bytes
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index e343249c8d05..3878b01e19e1 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -4,6 +4,7 @@
  */
 
 #include "cptvf.h"
+#include "cptvf_algs.h"
 #include "request_manager.h"
 
 /**
@@ -173,11 +174,10 @@ static inline int setup_sgio_list(struct cpt_vf *cptvf,
 		goto  scatter_gather_clean;
 	}
 
-	((u16 *)info->in_buffer)[0] = req->outcnt;
-	((u16 *)info->in_buffer)[1] = req->incnt;
-	((u16 *)info->in_buffer)[2] = 0;
-	((u16 *)info->in_buffer)[3] = 0;
-	*(u64 *)info->in_buffer = cpu_to_be64p((u64 *)info->in_buffer);
+	((__be16 *)info->in_buffer)[0] = cpu_to_be16(req->outcnt);
+	((__be16 *)info->in_buffer)[1] = cpu_to_be16(req->incnt);
+	((__be16 *)info->in_buffer)[2] = 0;
+	((__be16 *)info->in_buffer)[3] = 0;
 
 	memcpy(&info->in_buffer[8], info->gather_components,
 	       g_sz_bytes);
@@ -470,8 +470,6 @@ int process_request(struct cpt_vf *cptvf, struct cpt_request_info *req)
 	vq_cmd.cmd.s.param2 = cpu_to_be16(cpt_req->param2);
 	vq_cmd.cmd.s.dlen   = cpu_to_be16(cpt_req->dlen);
 
-	/* 64-bit swap for microcode data reads, not needed for addresses*/
-	vq_cmd.cmd.u64 = cpu_to_be64(vq_cmd.cmd.u64);
 	vq_cmd.dptr = info->dptr_baddr;
 	vq_cmd.rptr = info->rptr_baddr;
 	vq_cmd.cptr.u64 = 0;
diff --git a/drivers/crypto/cavium/cpt/request_manager.h b/drivers/crypto/cavium/cpt/request_manager.h
index 1e8dd9ebcc17..8d40e4ba3af1 100644
--- a/drivers/crypto/cavium/cpt/request_manager.h
+++ b/drivers/crypto/cavium/cpt/request_manager.h
@@ -75,16 +75,16 @@ struct sglist_component {
 	union {
 		u64 len;
 		struct {
-			u16 len0;
-			u16 len1;
-			u16 len2;
-			u16 len3;
+			__be16 len0;
+			__be16 len1;
+			__be16 len2;
+			__be16 len3;
 		} s;
 	} u;
-	u64 ptr0;
-	u64 ptr1;
-	u64 ptr2;
-	u64 ptr3;
+	__be64 ptr0;
+	__be64 ptr1;
+	__be64 ptr2;
+	__be64 ptr3;
 };
 
 struct cpt_info_buffer {
@@ -114,10 +114,10 @@ struct cpt_info_buffer {
 union vq_cmd_word0 {
 	u64 u64;
 	struct {
-		u16 opcode;
-		u16 param1;
-		u16 param2;
-		u16 dlen;
+		__be16 opcode;
+		__be16 param1;
+		__be16 param2;
+		__be16 dlen;
 	} s;
 };
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
