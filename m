Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4059C3526E
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 905F523BB5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgLSDbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgLSDbM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 22:31:12 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F29C061248
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:31 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id f26so2508959qka.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G+dMsLBrY99BUWGLKr1cRQ/g1Fbgha5c1iEnYj8qjJo=;
        b=vT8jy5MptC7VW2zdcTnk29uYgSz67EeJOfAP4ek4gPwzqbeurSmmjfcUW9xpmBn2zf
         hTEOcc7PR7X0O2TeTsexiKHG9k7tD3TG4JxiBSlLhgOIITNcdWgbN1zcYBWPsIrA1vU4
         iA47XFB35EOXuYsPkWL2ovbUfR9QYXKe9n+jgBrlCHKyFkNs3GAodS1ifcuFiasH47GU
         FPvErgetFEvolLBB6MDR2N58MQRkRrWbZyHi1hFj2cV5u/bO0RajCqxCYNeUMD14jty7
         qYM26i6S9bL9TuKw5tLRlM6MN+Mhf5boMygkj9QzbexJ6JwbaKicCUkbYMCt3BUCzwyJ
         B5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+dMsLBrY99BUWGLKr1cRQ/g1Fbgha5c1iEnYj8qjJo=;
        b=f1tkX8eVa1WX6jE0gEj5nGs5rzPsBJ9T0QtlAHOpSKH6VzzzCHwc75hvsU4F2tq3PB
         vpejdphIH4xW4gPMSyuQqN49+a4YLK7kIHh6oZQlYz3vnoLpEhJCPCsu3xAvcXQrhq1Q
         AGlELkHPn76gBTv0S++ib2zdXxb2xlBGhr9PO5GLk0DfGW5VlwGnR/MGEQ2N2NM0gxrp
         uaCvUFg/FL6GcSvlUO4gYmciyD00dy0cgDuBO1op2i8y9+moMG3D3n0YDRJedPfYJKOI
         qgLUsWDOwh1NIoz7mafmgHTZrwhRiNjgQbX2SRs8fXOBQ+3hMuZzU52+/AKuVEuPQcFd
         sN1Q==
X-Gm-Message-State: AOAM5306rjbnJIXaG0fjykUKWu2lX0BYLy2fca/Kzgr/2XE6fO8PjGpH
        cVXnoEg/FEtbFYoyJ6pqHHKr1g==
X-Google-Smtp-Source: ABdhPJzU/qyYPNNeD+vd+TgYuRGoGACzorAX5fTuj3JMZ6nkU8rS4gcMERgW0MZ2QuWyM3gSvViknw==
X-Received: by 2002:a05:620a:10b7:: with SMTP id h23mr8222309qkk.249.1608348631006;
        Fri, 18 Dec 2020 19:30:31 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id y16sm4376045qki.132.2020.12.18.19.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 19:30:30 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] drivers: crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Fri, 18 Dec 2020 22:30:23 -0500
Message-Id: <20201219033027.3066042-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201219033027.3066042-1-thara.gopinath@linaro.org>
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
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
index b8428da6716d..02d89267a806 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -193,6 +193,25 @@ static int qce_ahash_update(struct ahash_request *req)
 
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

