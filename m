Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873EFC43332
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B3B22E03
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387577AbhALDHI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733151AbhALDHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 22:07:08 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DD2C0617A2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:49 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id e15so729072qte.9
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzoTTNnCPyrLt8K8sPUqSR8uOcEXNVFa8VbUu/a/sAw=;
        b=gOs/dNmKiiq2t7vlKbE823hViq8mqDd2xe0FlFuWDbHtxk/AxL1dlbLYpWEpp0IghA
         XrNfyCXUVO4coU0Q4AGBBQ8726X3da0O55GZD8mfh6rgie+JfTsEBk0SNAWPvsvyqNoW
         qaBZQnoQRoeg5YB1mUnlFX8+FS4COgYQRV3ADk8RUFSXamH9d25zkyXiKetFrgoN2Fv2
         ZWI3wbDSrk40uqz/NQdI3cNDOn09tpJK/lsJiCnhc6S3h04pWVzXkOIZrEU2tutGKSdW
         Eo9Fhx/ZBvo9eTYvB4mpQZioGxtM1cXoUWpjDUKTxSHlrYYAKDAi+I+x2Csw59+qGyyD
         pDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzoTTNnCPyrLt8K8sPUqSR8uOcEXNVFa8VbUu/a/sAw=;
        b=e9TtKjtZCUATYbzXbtKkQp8nnbRh3qlSXILkBHprmpBnQiYsOfmxAUJyZjQvMCp1Bs
         jKpeaRUW3xSFPqc79P9ZIb73QT5nC1bwBC4Zl/A0Mw/7AquzLG+6QQXbsEfAtkoeoRJU
         Xrl7GiO/YLKBRRnGeRznMwYjeiSt7BsZJgAW9s/C/NiaBGv/m1V0+J0gzfoK2+0jmOHO
         zntRvUZIA/MPXAyGacTe9SMrkHkh1vezil4KRl8zWitIHQbDtqrnKJMUspwCnk3HCeZ9
         oErJGEUScnfRc6+6Ac8VR5QNVFfjiXtSMyZ7tsxRdy8C+ZN6pswnYwZGSvDFdY/tCqfV
         dpMw==
X-Gm-Message-State: AOAM532tHcNrPTnbX/qlzsU21MggGbTonTecEhbvhpnhsm0b0UUGCpUz
        5pONC2Z9FDy0ysPW7p+NAMZCmA==
X-Google-Smtp-Source: ABdhPJwgAJDwOJMMVKgbaFcRTlNKxxD1HzB9CEtWQK0CsdIqVmYHMjHsoReAVp5etK3W89G16GObPQ==
X-Received: by 2002:ac8:5acb:: with SMTP id d11mr2696475qtd.269.1610420748810;
        Mon, 11 Jan 2021 19:05:48 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c7sm814235qkm.99.2021.01.11.19.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:05:48 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] drivers: crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Mon, 11 Jan 2021 22:05:41 -0500
Message-Id: <20210112030545.669480-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112030545.669480-1-thara.gopinath@linaro.org>
References: <20210112030545.669480-1-thara.gopinath@linaro.org>
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

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/sha.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 08aed03e2b59..dd263c5e4dd8 100644
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

