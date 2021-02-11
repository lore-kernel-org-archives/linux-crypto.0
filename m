Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351C5C433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0779264E15
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhBKUC5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhBKUCR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:02:17 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C8BC06178A
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:32 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id n28so5071922qtv.12
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=Cr/0Xzp4NcBg9CJMoY2MZGRGaHzQArd287KXJSudEfKvWZfiGlX51La0k+4m7JIovS
         DbFOazCu9vjUxkquGis4YogcImJTtrjo/xM7FZCgHJMXSaWeGA4yThC4Iw43xGNKhoqL
         vmia+BJnRQvca9G+L1XgPqY96T5C2E6JsgY0odnnXXelNMiOShhBFIV613zxnlAae6bX
         B9ZfVZUI+r1nuhDyBmNUgaEHfFF6tRmia+yOSFUye69dFUUBiQJH7/DGJRQwLT+GnOxI
         P6m7LbkzFolWYhOgCq0sFfVyHPTaUehVTpsmYfD3yyUW2eDB1Oa2NNFHUhE3A6F6ZACC
         6vTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=IX7Chf+rifckjJxlMAIRG3Nt+11VmRz6KSQEFlk5YIX8NIMFIlzgyi8Twz1wCCMy7F
         MLHM8HlVKXZM55g7hNSqCb8QVaJpzs7kxFk6BznnXW5VtVWCepQfZ/kmYz49ry5gDcKH
         jWfzvv3SEyuCRAcZhutmFo3I4MuKZQJlidiAYkYXsL+3D75Mk8USTWu3e26y0F2LM+lY
         l6Og11YEoSSs7l8vgf8Fh8JWvKbdkZ4oetp0LUPN/iMbXKVTasIND5mjWOBzXe+DoeWT
         Q2eo3CHGpiZhj1uNOTbhD6SzLY7v8HZdoB5NoGg8CdT6VIrs/s93Pg3bna3SgANsLVKm
         daLQ==
X-Gm-Message-State: AOAM5306EMLeXt7Ef9qNNAOJTWb7rksEMld6GRjWHobpUkTNt+c9cfKH
        SMo0v/H9gXdMhjAnTuHJPE/8Aw==
X-Google-Smtp-Source: ABdhPJx6dFZ90mo7ytP+LkmwQGzYuwXtjNGYF+tpUSPYSykM/RLD/GOi+HH6nnN+M9Y4MIf/MIkPBw==
X-Received: by 2002:ac8:5a0d:: with SMTP id n13mr8795872qta.172.1613073691589;
        Thu, 11 Feb 2021 12:01:31 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:30 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 02/11] crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Thu, 11 Feb 2021 15:01:19 -0500
Message-Id: <20210211200128.2886388-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the available data to transfer is exactly a multiple of block size, save
the last block to be transferred in qce_ahash_final (with the last block
bit set) if this is indeed the end of data stream. If not this saved block
will be transferred as part of next update. If this block is not held back
and if this is indeed the end of data stream, the digest obtained will be
wrong since qce_ahash_final will see that rctx->buflen is 0 and return
doing nothing which in turn means that a digest will not be copied to the
destination result buffer.  qce_ahash_final cannot be made to alter this
behavior and allowed to proceed if rctx->buflen is 0 because the crypto
engine BAM does not allow for zero length transfers.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/sha.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 7da562dca740..2813c9a27a6e 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -216,6 +216,25 @@ static int qce_ahash_update(struct ahash_request *req)
 
 	/* calculate how many bytes will be hashed later */
 	hash_later = total % blocksize;
+
+	/*
+	 * At this point, there is more than one block size of data.  If
+	 * the available data to transfer is exactly a multiple of block
+	 * size, save the last block to be transferred in qce_ahash_final
+	 * (with the last block bit set) if this is indeed the end of data
+	 * stream. If not this saved block will be transferred as part of
+	 * next update. If this block is not held back and if this is
+	 * indeed the end of data stream, the digest obtained will be wrong
+	 * since qce_ahash_final will see that rctx->buflen is 0 and return
+	 * doing nothing which in turn means that a digest will not be
+	 * copied to the destination result buffer.  qce_ahash_final cannot
+	 * be made to alter this behavior and allowed to proceed if
+	 * rctx->buflen is 0 because the crypto engine BAM does not allow
+	 * for zero length transfers.
+	 */
+	if (!hash_later)
+		hash_later = blocksize;
+
 	if (hash_later) {
 		unsigned int src_offset = req->nbytes - hash_later;
 		scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
-- 
2.25.1

