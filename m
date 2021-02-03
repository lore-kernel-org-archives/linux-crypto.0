Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8483C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705AB64F6C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhBCOef (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhBCOeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:34:31 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4615EC06178A
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:12 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id r20so14075691qtm.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uksNnzHRuWvpXMI4aSId1xngqmQe06fCD5OoPJgAWng=;
        b=G3cYYZHApyAjGvQh6/bf039aehtbg3lTurFDKjeWPGZHGI9NzSnQI1iVe4t+2grxWo
         mRU7l01aWIdhQS3gANSX8rvbA8aXnZihjklSln+08vFmdpxYriUdjglEDevluwZBpq6p
         ul8AB+EA0vUa2f5zIvaGGlPwtTO7sgBxv8iK7lnRJRzLE4nWTp5yAew7QT72DE2j66WN
         XRyvBu6ivXgM7Ij50VhEzPpQwXRiWQXGjjzS2VsM+j1TmC8+p1oK+Y9R6kMURoayNpZa
         Ppm/B4yEiYqVb0PJ6tmdR7p8YbcqHQqMjDuJs6F+EkXbjOMZN2HJdS5B4ktrIOQF2ksn
         aioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uksNnzHRuWvpXMI4aSId1xngqmQe06fCD5OoPJgAWng=;
        b=T7LTwSo2akW1yGZIAln9sQUmEg1Y9oBhcotZZUJAx/Q/onLtAe0t30zA0MmlG/dpRd
         qwadztg9QBe8Eqcvh7uKWudRQ/xLeN7Vnlo21NLQ+dWfvKbdYOGJnR2zqnbLFgow2JJr
         6kLDcghmk2TArbG3cNDkiaSQcwFWS7/6gT+Jkjx304d6b/UG+9IKhqk7MCVH99B0vaJz
         6+00wBzNhbihOpb0zndCCoTFG/ain1Wl3SIivBEWaTSIGE124I7LllKQpn/frVhA99Mv
         Nzi9LeCA/KDZOdfW3sZLy/xW+5FJHT1PPbvo37dBiy5grFbA6ObkNoWU7MeQYSlQZ3yU
         UcoQ==
X-Gm-Message-State: AOAM532nUPqqS8K94N/YokuNsWT3p5yUKhmvhFqogcLhGl/nnZeMFCMB
        rRyfJnngszNLm09g6lqh5cOtbQ==
X-Google-Smtp-Source: ABdhPJyH0Dx2ea3Jfu5psK2mjoMxMDz6Nr0N2oiiesilOtqFfjNWg8gAB6bJURQsdu2Mj/LUZbBaDA==
X-Received: by 2002:ac8:59cd:: with SMTP id f13mr2754307qtf.258.1612362791507;
        Wed, 03 Feb 2021 06:33:11 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:10 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/11] crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Wed,  3 Feb 2021 09:32:58 -0500
Message-Id: <20210203143307.1351563-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
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
index 500290b40916..c8bfa9db07b8 100644
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

