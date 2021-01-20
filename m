Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FD4C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2B423403
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392187AbhATTSp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392093AbhATSuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 13:50:50 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B196C061786
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:48 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id z9so7088357qtv.6
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzoTTNnCPyrLt8K8sPUqSR8uOcEXNVFa8VbUu/a/sAw=;
        b=W91aASl733ZLAOz8W+VMfENwcB2YPmp1GP6Wgb63CXAmhQmR6LaS/yhs84yWRvx4Bu
         tEdoA7BJSo9Nwrrs2m6QS31O5EjD9GmwUXaBTCrERFRKu1r5nI38LH0fVaB5qanAQuDV
         UIAhK4d6cgWnm1ymFmaBl39JuRbGYpA9zkryhYv87Q+0uWrVVoefmulSoXPIp+8pm/AC
         KQMr9nja785KJWnwJzrIRP3FyEg9k+KQWgdSRzwUs48cKKrFmgPNmj+f+2kgP1AVnlRS
         fX3nSufc/rPl7aK0NFNjsbxGZ31QZdzr3GKRZNS9hNde/lttH0oLCjxZKiQ6T7pvtTu/
         wVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzoTTNnCPyrLt8K8sPUqSR8uOcEXNVFa8VbUu/a/sAw=;
        b=lEzaWEFwQIoH0AF5TCSXNAr/4iOSKFDqs4KAitojWJHF/VS1A9Gr3dvA2TdcOEC8lS
         Vo+17pfqDVVvI0sfHoBlFx8HYHtfTrQs0UsWcw0wKwPHUorQDjKuUUIMBiRg+QlJGCsr
         sBqKzbueZvopNNL53tqB9JKQyWtDFAl/DT+e9GST43GzspuarVpO/TGG7aVdhd5niOj9
         82C/pKcmeqWCF5YHIjYCXcJ3NXi6YO0ogVeEkUh7Q6vUU8Z4d1uiA3ZwTg/SG6Fx4drJ
         F6/Whl9YC5Q8DulHMklvuVwBUr4SFkjYOH4AmDHv5prY507MxL2LPvtXR1/XFfp/j350
         39/g==
X-Gm-Message-State: AOAM532M5ulrfTcTzeeH7e3gSQcSx2ZyaFE1Oq80WXbghilYl7sOPd8j
        rAdEK89UULYN6twJH8RxZs0RQA==
X-Google-Smtp-Source: ABdhPJy5rOmfCLRTDFH2MY83BTNTodYg5uXwoV/VoN2KvO056MM5tgt/3PHObHhoV/E4xd14tpP3cA==
X-Received: by 2002:aed:3629:: with SMTP id e38mr10150279qtb.354.1611168527314;
        Wed, 20 Jan 2021 10:48:47 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id w8sm1769903qts.50.2021.01.20.10.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:48:46 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] drivers: crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Wed, 20 Jan 2021 13:48:39 -0500
Message-Id: <20210120184843.3217775-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120184843.3217775-1-thara.gopinath@linaro.org>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
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

