Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFD7C54EBC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjAJTnV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjAJTnT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:43:19 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD0DDEB3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:43:18 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id b3so20134192lfv.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6WK2Snknx5q6DqgfLKm58fMpMD4ck4a9f8QIfce9Lrc=;
        b=p7oPlCmZedrWRoiSVeoy6bmdvaGMQJyEi9NfSM/+5ynkmqnG4jo0HqYIBPICn9DdzE
         r1FhhdCDPNqDDh6Ndj50QzykxA9fkch8rRH7BYMKpAa4EPUF0STAs+fB6zhU1HNiXTDG
         FZhbGNSylBoJX2GaRXl//tXsJKfFRwtjb2i76FLyyfXh70bhfL7sa7gKlbf5R3Mh/sk9
         vCn1sVrUNNUGZlvsqMKD+GfmQfrpg7dqVPxBsAIfaI+r0YC0KvY3zIiQ+cOaOKYdr8Aa
         pXgZmdaXChhGHvlG8lx3BSyqi+deyUVl8Zo5VNGZ+kQ9OCZeMa1wfj8Z/fxo5bUfhqzI
         nE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6WK2Snknx5q6DqgfLKm58fMpMD4ck4a9f8QIfce9Lrc=;
        b=vI3Usjc2aFTVz5lvfpu4Gs6LsdbWxVjJaRetsf1xDiAV4M1llYzSh0bTgGCo6R9I1t
         6bxQrMZttQGcIrzIxODANlMUYavQaGpRBkZyufKpsoC7tDeomfyfqS+IxulCebSJhPCE
         dpBCJrH2MeXG352zh6W1pMQle9qGSDT1lo+nhCoQlNGllXHO3cYPRMbG4J5sdf8uw7MC
         wpSC8WR8MBjlcexE2iEAHeFjEnKzK1pK+qxIFBqb2VU0gPpmAGtACIkYhyaxhKw2b6du
         aOrdxTeu+aOyUVO7d23Np3rYg9O+pyNt1gx55aed+iqcE5qICky4vQOLBL/98Yr1K6iK
         WpjA==
X-Gm-Message-State: AFqh2kqkMvcymFI4yllrPvLyhVJHm0x63NmuofrFjmD74SWB8BDp1GMY
        t+mEyEVkWCT7JCjW6N80uufxdNYsQp91BSQQ
X-Google-Smtp-Source: AMrXdXvd9JYUEH5gx5Y5sY2UqMyyKryZpntkHym2B+KeN015qRBQPFCKaGB21wOfuDUp4tBqP4MWJA==
X-Received: by 2002:ac2:5c4b:0:b0:4cc:7ff3:ab4d with SMTP id s11-20020ac25c4b000000b004cc7ff3ab4dmr2607900lfp.20.1673379796325;
        Tue, 10 Jan 2023 11:43:16 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id m10-20020a056512358a00b004cb0242704asm2307754lfr.255.2023.01.10.11.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:43:15 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] crypto: stm32/cryp: Use accelerated readsl/writesl
Date:   Tue, 10 Jan 2023 20:43:07 +0100
Message-Id: <20230110194307.657918-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When reading or writing crypto buffers the inner loops can
be replaced with readsl and writesl which will on ARM result
in a tight assembly loop, speeding up encryption/decryption
a little bit. This optimization was in the Ux500 driver so
let's carry it over to the STM32 driver.

Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 37 +++++++++----------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 4208338e72b6..6b8d731092a4 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -597,7 +597,6 @@ static void stm32_crypt_gcmccm_end_header(struct stm32_cryp *cryp)
 
 static void stm32_cryp_write_ccm_first_header(struct stm32_cryp *cryp)
 {
-	unsigned int i;
 	size_t written;
 	size_t len;
 	u32 alen = cryp->areq->assoclen;
@@ -623,8 +622,8 @@ static void stm32_cryp_write_ccm_first_header(struct stm32_cryp *cryp)
 	written = min_t(size_t, AES_BLOCK_SIZE - len, alen);
 
 	scatterwalk_copychunks((char *)block + len, &cryp->in_walk, written, 0);
-	for (i = 0; i < AES_BLOCK_32; i++)
-		stm32_cryp_write(cryp, cryp->caps->din, block[i]);
+
+	writesl(cryp->regs + cryp->caps->din, block, AES_BLOCK_32);
 
 	cryp->header_in -= written;
 
@@ -1363,18 +1362,14 @@ static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
 		u32 out_tag[AES_BLOCK_32];
 
 		/* Get and write tag */
-		for (i = 0; i < AES_BLOCK_32; i++)
-			out_tag[i] = stm32_cryp_read(cryp, cryp->caps->dout);
-
+		readsl(cryp->regs + cryp->caps->dout, out_tag, AES_BLOCK_32);
 		scatterwalk_copychunks(out_tag, &cryp->out_walk, cryp->authsize, 1);
 	} else {
 		/* Get and check tag */
 		u32 in_tag[AES_BLOCK_32], out_tag[AES_BLOCK_32];
 
 		scatterwalk_copychunks(in_tag, &cryp->in_walk, cryp->authsize, 0);
-
-		for (i = 0; i < AES_BLOCK_32; i++)
-			out_tag[i] = stm32_cryp_read(cryp, cryp->caps->dout);
+		readsl(cryp->regs + cryp->caps->dout, out_tag, AES_BLOCK_32);
 
 		if (crypto_memneq(in_tag, out_tag, cryp->authsize))
 			ret = -EBADMSG;
@@ -1415,12 +1410,9 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 
 static void stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 {
-	unsigned int i;
 	u32 block[AES_BLOCK_32];
 
-	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++)
-		block[i] = stm32_cryp_read(cryp, cryp->caps->dout);
-
+	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
 							     cryp->payload_out), 1);
 	cryp->payload_out -= min_t(size_t, cryp->hw_blocksize,
@@ -1429,14 +1421,11 @@ static void stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
 
 static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
 {
-	unsigned int i;
 	u32 block[AES_BLOCK_32] = {0};
 
 	scatterwalk_copychunks(block, &cryp->in_walk, min_t(size_t, cryp->hw_blocksize,
 							    cryp->payload_in), 0);
-	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++)
-		stm32_cryp_write(cryp, cryp->caps->din, block[i]);
-
+	writesl(cryp->regs + cryp->caps->din, block, cryp->hw_blocksize / sizeof(u32));
 	cryp->payload_in -= min_t(size_t, cryp->hw_blocksize, cryp->payload_in);
 }
 
@@ -1480,8 +1469,7 @@ static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
 	 * Same code as stm32_cryp_irq_read_data(), but we want to store
 	 * block value
 	 */
-	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++)
-		block[i] = stm32_cryp_read(cryp, cryp->caps->dout);
+	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
 	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
 							     cryp->payload_out), 1);
@@ -1499,8 +1487,7 @@ static void stm32_cryp_irq_write_gcm_padded_data(struct stm32_cryp *cryp)
 	stm32_cryp_write(cryp, cryp->caps->cr, cfg);
 
 	/* f) write padded data */
-	for (i = 0; i < AES_BLOCK_32; i++)
-		stm32_cryp_write(cryp, cryp->caps->din, block[i]);
+	writesl(cryp->regs + cryp->caps->din, block, AES_BLOCK_32);
 
 	/* g) Empty fifo out */
 	err = stm32_cryp_wait_output(cryp);
@@ -1580,8 +1567,7 @@ static void stm32_cryp_irq_write_ccm_padded_data(struct stm32_cryp *cryp)
 	 * Same code as stm32_cryp_irq_read_data(), but we want to store
 	 * block value
 	 */
-	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++)
-		block[i] = stm32_cryp_read(cryp, cryp->caps->dout);
+	readsl(cryp->regs + cryp->caps->dout, block, cryp->hw_blocksize / sizeof(u32));
 
 	scatterwalk_copychunks(block, &cryp->out_walk, min_t(size_t, cryp->hw_blocksize,
 							     cryp->payload_out), 1);
@@ -1660,15 +1646,14 @@ static void stm32_cryp_irq_write_data(struct stm32_cryp *cryp)
 
 static void stm32_cryp_irq_write_gcmccm_header(struct stm32_cryp *cryp)
 {
-	unsigned int i;
 	u32 block[AES_BLOCK_32] = {0};
 	size_t written;
 
 	written = min_t(size_t, AES_BLOCK_SIZE, cryp->header_in);
 
 	scatterwalk_copychunks(block, &cryp->in_walk, written, 0);
-	for (i = 0; i < AES_BLOCK_32; i++)
-		stm32_cryp_write(cryp, cryp->caps->din, block[i]);
+
+	writesl(cryp->regs + cryp->caps->din, block, AES_BLOCK_32);
 
 	cryp->header_in -= written;
 
-- 
2.39.0

