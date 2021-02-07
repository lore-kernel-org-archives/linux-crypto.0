Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A29EC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6DF64E4E
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhBGOlO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGOlL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:11 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB933C06178B
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:50 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id u20so11932932qku.7
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=eJtteYalWZ91+K2C6akaMpspY+GsXxbUfl6WHlqZ1i3V1Pptqdt0DQ3P/XOsoEZcBD
         DnqgzYnJa+D3tgBbR83rlgpoExPLwI3dzeDncD1789fOnUEvG3/WGybKDpwRoKmcwGdJ
         tgUa7PHaTa1Cutu9CFLSXuflvBMSCWFBkEkjFT3FX9Ma+zolZ34AadTJldj3XT5kiYlr
         wsS8ojdQTmZKVB2hsxgQbYC44dYLCiu4iqIRHAWfoBF/4qbZVhGJ7bUzE7apkTQcckp7
         PuG+9+mUIcJKvOK5n7zSww0kRNNrRabR2DLdY/GrxBhYceJdGwrT55rSBZ+l+5eAS+PX
         ug9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QL7UCH32HRfcwYFo/OihKYejmQ9XVroK1tPKK/3bNQ0=;
        b=GntTc+wCgwLvakpiPrgm/sZj2nICWos+0PPfH1GiNQk9UdQDcN3lQD8zfEJx3yDs27
         cM9G8NbV/Aal0JugPSFL9uyNsMyJ8f/i8DxtbacMxYAwEiYmzpuEgq95iPPMCaGdRMG4
         /UBXcnix/swzif9Sh/1Y6yPKhaPy3+BH7oSYtAqv3luKqKKBJGVnnvLEMxX7KvAeCOC5
         ToyeZuzzD3Dt8h3swBK40iME+CtdEJEEjqrf7/tHbNJKRSr/bT+GikIzfpgBj6ojl/9I
         OSKEgtt9k82JJ/u+3lHoVnziuB236jkaa9HTeuOIQDaUY+lB3I8rjvXP0fsQwc2yTt4n
         JPrg==
X-Gm-Message-State: AOAM533IaG0BJ+2WQeWJJo+awl5EvtlJTWshtLf5OManiC5o2+1EAmvV
        MhJMqPkVlAgqrkJ2KoCW5JRwJA==
X-Google-Smtp-Source: ABdhPJycEQpBZdJ7QqY5T6XdK9Tn2L2HcgBmgBwSXnZOZO67leTCW/QkTuIgzZCEqbBcBU4uWRYK9Q==
X-Received: by 2002:a37:b56:: with SMTP id 83mr12927210qkl.355.1612708789990;
        Sun, 07 Feb 2021 06:39:49 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:49 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/11] crypto: qce: sha: Hold back a block of data to be transferred as part of final
Date:   Sun,  7 Feb 2021 09:39:37 -0500
Message-Id: <20210207143946.2099859-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
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

