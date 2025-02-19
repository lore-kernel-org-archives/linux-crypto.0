Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152D2185B8;
	Wed, 19 Feb 2025 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989471; cv=none; b=IvzL+n8VvJEAb+eqEJSEXTM4QE+yz1VisaLSR8AXVeORqy9JnxYpLhyqq32tJTQ7xRAFmTZhIqcsHUyOOLSeBCA+bAke7HoqSRnMcAW1dT7GUFDO+zcGRNdPGPXkQnm060L4z9ISAfhT/PZBJojCzecVtYF9/5pD9dcJOaXsfV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989471; c=relaxed/simple;
	bh=4rt8U10q2E5aveL8U8OSMVVCSPSkb8/hTdHib2bvw+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTPDNMplKpOd3PSu16tPOcwkVhQ4yghlVdwzrOFn9OoF5Zjxo5pdUAAvzNky8ZJc713lft6xsA+osVe6RI4F1gIU2vMakxskNAtZzFfnTxZ12RTAO37RdHKxIlZBmqCxBSOYMivKdql+sPzSLMLIvkV3gv3Crx0h3+zPsMzs5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4YclHx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4YclHx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C90C4CEEB;
	Wed, 19 Feb 2025 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989470;
	bh=4rt8U10q2E5aveL8U8OSMVVCSPSkb8/hTdHib2bvw+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4YclHx8RkftLzOpCdZakGuM2bVU88+tmdWM9jn+VZz9odi7oJTrY0SRF6P9JA9u1
	 M/wpSSuB89ToRT4yiITDcg9RqbHoH77qST94FabHswTnJ2T/+LCwXulgoyouQShSBx
	 I0+ex+IcD3tcU4QbL/VI3coGMNLrYL4S9IIsFWh7DvioZpfSRONFT6vdCS467ivZAc
	 oaxh2u+3t2LG+PQOn/x40VHrEriiZ0Fd9GjCD1K6RjVKCjO7ARGqp01IxmR466fQGE
	 QUYmCdFaziA+v7+yVh1kLrYrTWfJefRwxyrgt6SEncLZTuwUQ8rAXpPxa/hiw2CzMt
	 sYv7a3NHnUf7w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v3 13/19] crypto: stm32 - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:35 -0800
Message-ID: <20250219182341.43961-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Replace calls to the deprecated function scatterwalk_copychunks() with
memcpy_from_scatterwalk(), memcpy_to_scatterwalk(), scatterwalk_skip(),
or scatterwalk_start_at_pos() as appropriate.

Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Maxime Méré <maxime.mere@foss.st.com>
Cc: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 34 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 14c6339c2e43c..5ce88e7a8f657 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -664,11 +664,11 @@ static void stm32_cryp_write_ccm_first_header(struct stm32_cryp *cryp)
 		len = 6;
 	}
 
 	written = min_t(size_t, AES_BLOCK_SIZE - len, alen);
 
-	scatterwalk_copychunks((char *)block + len, &cryp->in_walk, written, 0);
+	memcpy_from_scatterwalk((char *)block + len, &cryp->in_walk, written);
 
 	writesl(cryp->regs + cryp->caps->din, block, AES_BLOCK_32);
 
 	cryp->header_in -= written;
 
@@ -991,11 +991,11 @@ static int stm32_cryp_header_dma_start(struct stm32_cryp *cryp)
 	tx_in->callback_param = cryp;
 	tx_in->callback = stm32_cryp_header_dma_callback;
 
 	/* Advance scatterwalk to not DMA'ed data */
 	align_size = ALIGN_DOWN(cryp->header_in, cryp->hw_blocksize);
-	scatterwalk_copychunks(NULL, &cryp->in_walk, align_size, 2);
+	scatterwalk_skip(&cryp->in_walk, align_size);
 	cryp->header_in -= align_size;
 
 	ret = dma_submit_error(dmaengine_submit(tx_in));
 	if (ret < 0) {
 		dev_err(cryp->dev, "DMA in submit failed\n");
@@ -1054,22 +1054,22 @@ static int stm32_cryp_dma_start(struct stm32_cryp *cryp)
 	tx_out->callback = stm32_cryp_dma_callback;
 	tx_out->callback_param = cryp;
 
 	/* Advance scatterwalk to not DMA'ed data */
 	align_size = ALIGN_DOWN(cryp->payload_in, cryp->hw_blocksize);
-	scatterwalk_copychunks(NULL, &cryp->in_walk, align_size, 2);
+	scatterwalk_skip(&cryp->in_walk, align_size);
 	cryp->payload_in -= align_size;
 
 	ret = dma_submit_error(dmaengine_submit(tx_in));
 	if (ret < 0) {
 		dev_err(cryp->dev, "DMA in submit failed\n");
 		return ret;
 	}
 	dma_async_issue_pending(cryp->dma_lch_in);
 
 	/* Advance scatterwalk to not DMA'ed data */
-	scatterwalk_copychunks(NULL, &cryp->out_walk, align_size, 2);
+	scatterwalk_skip(&cryp->out_walk, align_size);
 	cryp->payload_out -= align_size;
 	ret = dma_submit_error(dmaengine_submit(tx_out));
 	if (ret < 0) {
 		dev_err(cryp->dev, "DMA out submit failed\n");
 		return ret;
@@ -1735,13 +1735,13 @@ static int stm32_cryp_prepare_req(struct skcipher_request *req,
 
 		in_sg = areq->src;
 		out_sg = areq->dst;
 
 		scatterwalk_start(&cryp->in_walk, in_sg);
-		scatterwalk_start(&cryp->out_walk, out_sg);
 		/* In output, jump after assoc data */
-		scatterwalk_copychunks(NULL, &cryp->out_walk, cryp->areq->assoclen, 2);
+		scatterwalk_start_at_pos(&cryp->out_walk, out_sg,
+					 areq->assoclen);
 
 		ret = stm32_cryp_hw_init(cryp);
 		if (ret)
 			return ret;
 
@@ -1871,16 +1871,16 @@ static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
 	if (is_encrypt(cryp)) {
 		u32 out_tag[AES_BLOCK_32];
 
 		/* Get and write tag */
 		readsl(cryp->regs + cryp->caps->dout, out_tag, AES_BLOCK_32);
-		scatterwalk_copychunks(out_tag, &cryp->out_walk, cryp->authsize, 1);
+		memcpy_to_scatterwalk(&cryp->out_walk, out_tag, cryp->authsize);
 	} else {
 		/* Get and check tag */
 		u32 in_tag[AES_BLOCK_32], out_tag[AES_BLOCK_32];
 
-		scatterwalk_copychunks(in_tag, &cryp->in_walk, cryp->authsize, 0);
+		memcpy_from_scatterwalk(in_tag, &cryp->in_walk, cryp->authsize);
 		readsl(cryp->regs + cryp->caps->dout, out_tag, AES_BLOCK_32);
 
 		if (crypto_memneq(in_tag, out_tag, cryp->authsize))
 			ret = -EBADMSG;
 	}
@@ -1921,22 +1921,22 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 static void stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 {
 	u32 block[AES_BLOCK_32];
 
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
-	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
-							     cryp->payload_out), 1);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
+							    cryp->payload_out));
 	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize,
 				   cryp->payload_out);
 }
 
 static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
 {
 	u32 block[AES_BLOCK_32] = {0};
 
-	scatterwalk_copychunks(block, &cryp->in_walk, min_t(size_t, cryp->hw_blocksize,
-							    cryp->payload_in), 0);
+	memcpy_from_scatterwalk(block, &cryp->in_walk, min_t(size_t, cryp->hw_blocksize,
+							     cryp->payload_in));
 	writesl(cryp->regs + cryp->caps->din, block, cryp->hw_blocksize / sizeof(u32));
 	cryp->payload_in -= min_t(size_t, cryp->hw_blocksize, cryp->payload_in);
 }
 
 static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
@@ -1979,12 +1979,12 @@ static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
 	 * Same code as stm32_cryp_irq_read_data(), but we want to store
 	 * block value
 	 */
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
-	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
-							     cryp->payload_out), 1);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
+							    cryp->payload_out));
 	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize,
 				   cryp->payload_out);
 
 	/* d) change mode back to AES GCM */
 	cfg &= ~CR_ALGO_MASK;
@@ -2077,12 +2077,12 @@ static void stm32_cryp_irq_write_ccm_padded_data(struct stm32_cryp *cryp)
 	 * Same code as stm32_cryp_irq_read_data(), but we want to store
 	 * block value
 	 */
 	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
-	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
-							     cryp->payload_out), 1);
+	memcpy_to_scatterwalk(&cryp->out_walk, block, min_t(size_t, cryp->hw_blocksize,
+							    cryp->payload_out));
 	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize, cryp->payload_out);
 
 	/* d) Load again CRYP_CSGCMCCMxR */
 	for (i = 0; i < ARRAY_SIZE(cstmp2); i++)
 		cstmp2[i] = stm32_cryp_read(cryp, CRYP_CSGCMCCM0R + i * 4);
@@ -2159,11 +2159,11 @@ static void stm32_cryp_irq_write_gcmccm_header(struct stm32_cryp *cryp)
 	u32 block[AES_BLOCK_32] = {0};
 	size_t written;
 
 	written = min_t(size_t, AES_BLOCK_SIZE, cryp->header_in);
 
-	scatterwalk_copychunks(block, &cryp->in_walk, written, 0);
+	memcpy_from_scatterwalk(block, &cryp->in_walk, written);
 
 	writesl(cryp->regs + cryp->caps->din, block, AES_BLOCK_32);
 
 	cryp->header_in -= written;
 
-- 
2.48.1

