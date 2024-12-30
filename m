Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845791A2567;
	Mon, 30 Dec 2024 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517767; cv=none; b=g3aNWccQxwg3H6UdnWMaZucq3oe3JAndBqErRAPaGly6CWE2+5458oL8gHhmcSbyil9oYehgf2l2hOPJEoPkUl7hsLOCBrmu459xzFxwyx8Wvb31IgAyGKyXS8PieIlkMjD2ooKKBhx2kqG+9q/v+3OZoOQ4kd72vjEIuFTUDVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517767; c=relaxed/simple;
	bh=Zhg/KDiZCPgy+MF6pUjpqhVE/E/er2PToHEWYDXwwVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POXL8y2A72f6fafolC0tDW9XI7wrcJMGgJcNNomqtZwT0inu6lOFkuLSToEamn2Vr0bdCvXTGRXMs2NyBABeI1M/X0ZKQda/d6pSg5naXT2+2M09ehKOqd73l8VkPzR11YJ7echmfPKb00XKdEfu4zGbAstrLtwVZm8xYOEA6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQeQWSWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQeQWSWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F18C4CEDC;
	Mon, 30 Dec 2024 00:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517767;
	bh=Zhg/KDiZCPgy+MF6pUjpqhVE/E/er2PToHEWYDXwwVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQeQWSWGrhHBPwio5Jg0oNJ3NF0/xyx1ANYtKFo++QjWgDy9z/zithnQznylaiBPP
	 2oQGvntdxCqhBUGU2Y/pZQTFpcHDvY8e8qYJEKuOgpKN7KyMNTmPg+ZQeVDQ3zpWvo
	 AZvhLxC2+/m28vE+PWJhDrES5EKpMCwYrzAiFI/bEoz/qIvKAbl5KlQJHZthdTvFjV
	 /3pIYi5hn3cUFwx7IrfTU8myRkoCRJAo1KH6MkpD2Jaxrd0gtPiQYoSHwXukFAVpr0
	 42LRTkDtK5SWA/S7odPwpeumj0a4zPYFIIxJ3qKZeMuNT7K+Wsb7znPzRmRJGSbLWE
	 3ZiK9qncSkiKw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH v2 23/29] crypto: stm32 - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:12 -0800
Message-ID: <20241230001418.74739-24-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
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

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 drivers/crypto/stm32/stm32-cryp.c | 34 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 14c6339c2e43..5ce88e7a8f65 100644
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
2.47.1

