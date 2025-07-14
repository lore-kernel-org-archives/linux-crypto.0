Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D025A331;
	Mon, 14 Jul 2025 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505166; cv=none; b=pIUxowGuhOtSvEwglFeWJtJUeeNQhF+Gt1YNss66V/qfGQmg4xagKzSnbufslFvxI0POSd67aU+i3prl9osECUSMmatBQxGWSPgyrkGwbXLlqd553zKsmpQgWJVvmwQtGkCs8WfSrdTCmfYa/QOj7MbBn+UTRcI5j07ZuyIgSCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505166; c=relaxed/simple;
	bh=HuKu0m6/V1cOYA4cnFU33tdkk8VYfQgcmZY5Xc9VMRM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DNq4oDxiBq10+4feS3Pm34GzSqA6wtSyuVx7MPr3jDRX71/qC4gv0vuMJvaScRZi+22s0fIdXpJbOXMuEnIXIsU3t6y+Pr6ZmVUZuP1MXpNVzMZprNCn5NwWk/UkjLc+ByhFoo3PEAPmXRYef03247DiST3P7ygTX4ApYoqLqWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6mOkQtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6mOkQtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18595C4CEED;
	Mon, 14 Jul 2025 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752505165;
	bh=HuKu0m6/V1cOYA4cnFU33tdkk8VYfQgcmZY5Xc9VMRM=;
	h=From:To:Cc:Subject:Date:From;
	b=c6mOkQtViH7KiI3sDUw3K+rtp20Qc23elxV0fLKyJtZGnxMxUiA2iMi90CyHa1Drb
	 Pxc8zc60FZeq1brJLXZp8+cqsOkx+iK7nvAA2so2//lWisDSb0At8eF9Xmo1klVFz+
	 EJ/OlYe1EEHXQgc0xbAWdoXTaCOprMKAQRxWgJmWpKzLU4HvHDSjTVE9ihqT3oRiXF
	 r+Scpmxg6J50XTAAvHosgPTtU032PS1MldhmNn5Xo2UjqeU7DoXVv5fuHvIh9G7Ir9
	 cgR7ECwO+b++bwW8pPtNuN8ArP7mfnPI/DD7sXG2VtDfY7DMPs3mpbxFjYHUgmpkfc
	 vx/sAKyyJCzLg==
From: Arnd Bergmann <arnd@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp: reduce stack usage in ccp_run_aes_gcm_cmd
Date: Mon, 14 Jul 2025 16:59:12 +0200
Message-Id: <20250714145921.699060-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

A number of functions in this file have large structures on the stack,
ccp_run_aes_gcm_cmd() being the worst, in particular when KASAN
is enabled on gcc:

drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_sha_cmd':
drivers/crypto/ccp/ccp-ops.c:1833:1: error: the frame size of 1136 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
drivers/crypto/ccp/ccp-ops.c:914:1: error: the frame size of 1632 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Avoid the issue by using dynamic memory allocation in the worst one
of these.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I'm not overly happy with this patch myself but couldn't come up
with anything better either.

One alternative would be to turn off sanitizers here, but even without
those, the stack usage is fairly high, so that still feels like
papering over the problem.
---
 drivers/crypto/ccp/ccp-ops.c | 163 ++++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 77 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 109b5aef4034..d78865d9d5f0 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -633,10 +633,16 @@ static noinline_for_stack int
 ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
-	struct ccp_dm_workarea key, ctx, final_wa, tag;
-	struct ccp_data src, dst;
-	struct ccp_data aad;
-	struct ccp_op op;
+	struct {
+		struct ccp_dm_workarea key;
+		struct ccp_dm_workarea ctx;
+		struct ccp_dm_workarea final;
+		struct ccp_dm_workarea tag;
+		struct ccp_data src;
+		struct ccp_data dst;
+		struct ccp_data aad;
+		struct ccp_op op;
+	} *wa __cleanup(kfree) = kzalloc(sizeof *wa, GFP_KERNEL);
 	unsigned int dm_offset;
 	unsigned int authsize;
 	unsigned int jobid;
@@ -650,6 +656,9 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	struct scatterlist *p_outp, sg_outp[2];
 	struct scatterlist *p_aad;
 
+	if (!wa)
+		return -ENOMEM;
+
 	if (!aes->iv)
 		return -EINVAL;
 
@@ -696,26 +705,26 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	jobid = CCP_NEW_JOBID(cmd_q->ccp);
 
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = jobid;
-	op.sb_key = cmd_q->sb_key; /* Pre-allocated */
-	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
-	op.init = 1;
-	op.u.aes.type = aes->type;
+	memset(&wa->op, 0, sizeof(wa->op));
+	wa->op.cmd_q = cmd_q;
+	wa->op.jobid = jobid;
+	wa->op.sb_key = cmd_q->sb_key; /* Pre-allocated */
+	wa->op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
+	wa->op.init = 1;
+	wa->op.u.aes.type = aes->type;
 
 	/* Copy the key to the LSB */
-	ret = ccp_init_dm_workarea(&key, cmd_q,
+	ret = ccp_init_dm_workarea(&wa->key, cmd_q,
 				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
 				   DMA_TO_DEVICE);
 	if (ret)
 		return ret;
 
 	dm_offset = CCP_SB_BYTES - aes->key_len;
-	ret = ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_set_dm_area(&wa->key, dm_offset, aes->key, 0, aes->key_len);
 	if (ret)
 		goto e_key;
-	ret = ccp_copy_to_sb(cmd_q, &key, op.jobid, op.sb_key,
+	ret = ccp_copy_to_sb(cmd_q, &wa->key, wa->op.jobid, wa->op.sb_key,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
@@ -726,58 +735,58 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	 * There is an assumption here that the IV is 96 bits in length, plus
 	 * a nonce of 32 bits. If no IV is present, use a zeroed buffer.
 	 */
-	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+	ret = ccp_init_dm_workarea(&wa->ctx, cmd_q,
 				   CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES,
 				   DMA_BIDIRECTIONAL);
 	if (ret)
 		goto e_key;
 
 	dm_offset = CCP_AES_CTX_SB_COUNT * CCP_SB_BYTES - aes->iv_len;
-	ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_set_dm_area(&wa->ctx, dm_offset, aes->iv, 0, aes->iv_len);
 	if (ret)
 		goto e_ctx;
 
-	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+	ret = ccp_copy_to_sb(cmd_q, &wa->ctx, wa->op.jobid, wa->op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_ctx;
 	}
 
-	op.init = 1;
+	wa->op.init = 1;
 	if (aes->aad_len > 0) {
 		/* Step 1: Run a GHASH over the Additional Authenticated Data */
-		ret = ccp_init_data(&aad, cmd_q, p_aad, aes->aad_len,
+		ret = ccp_init_data(&wa->aad, cmd_q, p_aad, aes->aad_len,
 				    AES_BLOCK_SIZE,
 				    DMA_TO_DEVICE);
 		if (ret)
 			goto e_ctx;
 
-		op.u.aes.mode = CCP_AES_MODE_GHASH;
-		op.u.aes.action = CCP_AES_GHASHAAD;
+		wa->op.u.aes.mode = CCP_AES_MODE_GHASH;
+		wa->op.u.aes.action = CCP_AES_GHASHAAD;
 
-		while (aad.sg_wa.bytes_left) {
-			ccp_prepare_data(&aad, NULL, &op, AES_BLOCK_SIZE, true);
+		while (wa->aad.sg_wa.bytes_left) {
+			ccp_prepare_data(&wa->aad, NULL, &wa->op, AES_BLOCK_SIZE, true);
 
-			ret = cmd_q->ccp->vdata->perform->aes(&op);
+			ret = cmd_q->ccp->vdata->perform->aes(&wa->op);
 			if (ret) {
 				cmd->engine_error = cmd_q->cmd_error;
 				goto e_aad;
 			}
 
-			ccp_process_data(&aad, NULL, &op);
-			op.init = 0;
+			ccp_process_data(&wa->aad, NULL, &wa->op);
+			wa->op.init = 0;
 		}
 	}
 
-	op.u.aes.mode = CCP_AES_MODE_GCTR;
-	op.u.aes.action = aes->action;
+	wa->op.u.aes.mode = CCP_AES_MODE_GCTR;
+	wa->op.u.aes.action = aes->action;
 
 	if (ilen > 0) {
 		/* Step 2: Run a GCTR over the plaintext */
 		in_place = (sg_virt(p_inp) == sg_virt(p_outp)) ? true : false;
 
-		ret = ccp_init_data(&src, cmd_q, p_inp, ilen,
+		ret = ccp_init_data(&wa->src, cmd_q, p_inp, ilen,
 				    AES_BLOCK_SIZE,
 				    in_place ? DMA_BIDIRECTIONAL
 					     : DMA_TO_DEVICE);
@@ -785,52 +794,52 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			goto e_aad;
 
 		if (in_place) {
-			dst = src;
+			wa->dst = wa->src;
 		} else {
-			ret = ccp_init_data(&dst, cmd_q, p_outp, ilen,
+			ret = ccp_init_data(&wa->dst, cmd_q, p_outp, ilen,
 					    AES_BLOCK_SIZE, DMA_FROM_DEVICE);
 			if (ret)
 				goto e_src;
 		}
 
-		op.soc = 0;
-		op.eom = 0;
-		op.init = 1;
-		while (src.sg_wa.bytes_left) {
-			ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
-			if (!src.sg_wa.bytes_left) {
+		wa->op.soc = 0;
+		wa->op.eom = 0;
+		wa->op.init = 1;
+		while (wa->src.sg_wa.bytes_left) {
+			ccp_prepare_data(&wa->src, &wa->dst, &wa->op, AES_BLOCK_SIZE, true);
+			if (!wa->src.sg_wa.bytes_left) {
 				unsigned int nbytes = ilen % AES_BLOCK_SIZE;
 
 				if (nbytes) {
-					op.eom = 1;
-					op.u.aes.size = (nbytes * 8) - 1;
+					wa->op.eom = 1;
+					wa->op.u.aes.size = (nbytes * 8) - 1;
 				}
 			}
 
-			ret = cmd_q->ccp->vdata->perform->aes(&op);
+			ret = cmd_q->ccp->vdata->perform->aes(&wa->op);
 			if (ret) {
 				cmd->engine_error = cmd_q->cmd_error;
 				goto e_dst;
 			}
 
-			ccp_process_data(&src, &dst, &op);
-			op.init = 0;
+			ccp_process_data(&wa->src, &wa->dst, &wa->op);
+			wa->op.init = 0;
 		}
 	}
 
 	/* Step 3: Update the IV portion of the context with the original IV */
-	ret = ccp_copy_from_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+	ret = ccp_copy_from_sb(cmd_q, &wa->ctx, wa->op.jobid, wa->op.sb_ctx,
 			       CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
 	}
 
-	ret = ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_set_dm_area(&wa->ctx, dm_offset, aes->iv, 0, aes->iv_len);
 	if (ret)
 		goto e_dst;
 
-	ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
+	ret = ccp_copy_to_sb(cmd_q, &wa->ctx, wa->op.jobid, wa->op.sb_ctx,
 			     CCP_PASSTHRU_BYTESWAP_256BIT);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
@@ -840,75 +849,75 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	/* Step 4: Concatenate the lengths of the AAD and source, and
 	 * hash that 16 byte buffer.
 	 */
-	ret = ccp_init_dm_workarea(&final_wa, cmd_q, AES_BLOCK_SIZE,
+	ret = ccp_init_dm_workarea(&wa->final, cmd_q, AES_BLOCK_SIZE,
 				   DMA_BIDIRECTIONAL);
 	if (ret)
 		goto e_dst;
-	final = (__be64 *)final_wa.address;
+	final = (__be64 *)wa->final.address;
 	final[0] = cpu_to_be64(aes->aad_len * 8);
 	final[1] = cpu_to_be64(ilen * 8);
 
-	memset(&op, 0, sizeof(op));
-	op.cmd_q = cmd_q;
-	op.jobid = jobid;
-	op.sb_key = cmd_q->sb_key; /* Pre-allocated */
-	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
-	op.init = 1;
-	op.u.aes.type = aes->type;
-	op.u.aes.mode = CCP_AES_MODE_GHASH;
-	op.u.aes.action = CCP_AES_GHASHFINAL;
-	op.src.type = CCP_MEMTYPE_SYSTEM;
-	op.src.u.dma.address = final_wa.dma.address;
-	op.src.u.dma.length = AES_BLOCK_SIZE;
-	op.dst.type = CCP_MEMTYPE_SYSTEM;
-	op.dst.u.dma.address = final_wa.dma.address;
-	op.dst.u.dma.length = AES_BLOCK_SIZE;
-	op.eom = 1;
-	op.u.aes.size = 0;
-	ret = cmd_q->ccp->vdata->perform->aes(&op);
+	memset(&wa->op, 0, sizeof(wa->op));
+	wa->op.cmd_q = cmd_q;
+	wa->op.jobid = jobid;
+	wa->op.sb_key = cmd_q->sb_key; /* Pre-allocated */
+	wa->op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
+	wa->op.init = 1;
+	wa->op.u.aes.type = aes->type;
+	wa->op.u.aes.mode = CCP_AES_MODE_GHASH;
+	wa->op.u.aes.action = CCP_AES_GHASHFINAL;
+	wa->op.src.type = CCP_MEMTYPE_SYSTEM;
+	wa->op.src.u.dma.address = wa->final.dma.address;
+	wa->op.src.u.dma.length = AES_BLOCK_SIZE;
+	wa->op.dst.type = CCP_MEMTYPE_SYSTEM;
+	wa->op.dst.u.dma.address = wa->final.dma.address;
+	wa->op.dst.u.dma.length = AES_BLOCK_SIZE;
+	wa->op.eom = 1;
+	wa->op.u.aes.size = 0;
+	ret = cmd_q->ccp->vdata->perform->aes(&wa->op);
 	if (ret)
 		goto e_final_wa;
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
-		ccp_get_dm_area(&final_wa, 0, p_tag, 0, authsize);
+		ccp_get_dm_area(&wa->final, 0, p_tag, 0, authsize);
 	} else {
 		/* Does this ciphered tag match the input? */
-		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
+		ret = ccp_init_dm_workarea(&wa->tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_final_wa;
-		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
+		ret = ccp_set_dm_area(&wa->tag, 0, p_tag, 0, authsize);
 		if (ret) {
-			ccp_dm_free(&tag);
+			ccp_dm_free(&wa->tag);
 			goto e_final_wa;
 		}
 
-		ret = crypto_memneq(tag.address, final_wa.address,
+		ret = crypto_memneq(wa->tag.address, wa->final.address,
 				    authsize) ? -EBADMSG : 0;
-		ccp_dm_free(&tag);
+		ccp_dm_free(&wa->tag);
 	}
 
 e_final_wa:
-	ccp_dm_free(&final_wa);
+	ccp_dm_free(&wa->final);
 
 e_dst:
 	if (ilen > 0 && !in_place)
-		ccp_free_data(&dst, cmd_q);
+		ccp_free_data(&wa->dst, cmd_q);
 
 e_src:
 	if (ilen > 0)
-		ccp_free_data(&src, cmd_q);
+		ccp_free_data(&wa->src, cmd_q);
 
 e_aad:
 	if (aes->aad_len)
-		ccp_free_data(&aad, cmd_q);
+		ccp_free_data(&wa->aad, cmd_q);
 
 e_ctx:
-	ccp_dm_free(&ctx);
+	ccp_dm_free(&wa->ctx);
 
 e_key:
-	ccp_dm_free(&key);
+	ccp_dm_free(&wa->key);
 
 	return ret;
 }
-- 
2.39.5

