Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3CDC433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9A9C64E4E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhBDVpa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBDVpX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:23 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F0EC06178C
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:03 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id n15so4918416qkh.8
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=LnP8z+oMAn848LJIEfdOqDBRJds5HSWKBf6vcIKvI4CiADXTlE+/N/zNNkHCrIhLAY
         VTnY0I4xXiXCCK5k2VfTkPZn2rie5BlnPXqovi1k1P1LnF23GdUuBQfgx8oYknHJSjYQ
         wGR3Bt/8er4TGA3nLtM0hHK3K4Z3Pl95Nlhwz6yzWtVgoVIkzAA+lx44rV/cZkM6PWG5
         aSGnvDIUsEt16bCvEo6zj/EdwYg+QNp2B7C1vnR5BgxazIQzWS9pp5oTRDdKGpGuxTmj
         NDdBY0bPPi3X/3nVVvjSzb86atdmKAsX7D+MQIEYE+FPn5rhSny22sSuEeL+KfMo7YMh
         499Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=fC8kHmiMvVv9AOHS22tkodMFu7dGjhD+ZddJwaJYK7GPM7JFVfwe4OQw5eXooHDmgb
         3bBFVNywbz59n0GLO3uM1xmRqzKEdEBcXSTNUlmxjIlg8XPMFHW8RKpAVyshz8enebMD
         ycYH4RBaJOaQj+oeavsx4fm2uq2qdLTvFYrBKj3L1kn5wKlwcj5wKkxXz7R1PPFMDhvR
         ljAiKd+lY07hqEfqtqGAP80CE9ytcXfR2kGqDJGmN/XTMyfHvUa3Q7EoPELD5a70pkRV
         q4dX7q/bHWUCvh8XsD1q9MmNn26I/TlRrS7S/lDV4ywrR6bdFo6+XuGPi+n8UDabT7Up
         FlDQ==
X-Gm-Message-State: AOAM530lrgdRpTwZh8myASMUPDDd7oPHL9cMqFW2ceoptrLz4/u6Ds/O
        lORGxDyI057qL1vBuDNyyeuiCw==
X-Google-Smtp-Source: ABdhPJypVtm7Ihf8UyWm4gadnLJUCzEwK7haktRwJbjOn3uSzjpJCP7SOwfdF6gRig6XXJRkEsJsTw==
X-Received: by 2002:a37:a753:: with SMTP id q80mr1285453qke.29.1612475042611;
        Thu, 04 Feb 2021 13:44:02 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:02 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/11] crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Thu,  4 Feb 2021 16:43:50 -0500
Message-Id: <20210204214359.1993065-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

