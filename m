Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE56EC43461
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF3C61401
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhEEU10 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbhEEU1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:25 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81FC06174A
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n84so2181015wma.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=geSaV6u3XqnSyXvPUEqcEIkcIHLSdxJiGRaPxg2uuDM=;
        b=2CYr0rnZRPnS5emc9+jzaU3nBdpUQiMsCZINuwplZ1aNmCXhl7qL1YezNJyUFcfOoQ
         fiAbbwHdjI8w18qPAH3Q1Idw5bcXAw+2enxtWgB4Fet3v6yVCrggBFvyv/sEkeCixBmj
         bjE6BFRRSo6msfmEnzCmeD2qkaV+MLrYU+MZnQ963AKCRgPP6x/BgPk17tYWePzaQeuy
         ldfvs/Nkw5Xbr/VC9SyfJlrKgcGNE1RI3dFFbV9wvQvN0D9yKp6g38dnFENlcAfBr0Xp
         Legpoxrvo7tw1viDkUR1N9tJS+Xw2vq+2cfj8inow2ffYj9Z7dtpZd8IiKh+/NxUfmOQ
         8eDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=geSaV6u3XqnSyXvPUEqcEIkcIHLSdxJiGRaPxg2uuDM=;
        b=S/Z5n39mjHWdIpXcsejcRDF3x2vq6RcU/PD/+K8qjW0GW+XFinQR/rzgiH8aAYzAwd
         RocXp56MLEOYWhxAKPc6bc0WGCUY26ybsh/dcnlJV0jGJuFcXQyS0hYwFz5tcRAUF/GX
         dk+th3cJpehYVeWLsruM2tnhm0ZGfY+x2raXcxDa3rjWzqpydRTdz4ASp7S7IXg0l2LN
         q8wSNSobV7Jpl8GtKAm9oROPnw2cH2nkEYYFh+e/17tuRv5Ko9atETzI3MXwj8Zuq8Su
         /kxZcQ61EB1JU8u168T/VpiVWAoF4Sd/vfje5W74MS6KMKcZ8pJiL/VbMPZA1jbwuFcB
         TYWw==
X-Gm-Message-State: AOAM530+sXlYDpCHLpeHSAq9PtJj8qahimMU/WEYabTeIPsabYu9DCF7
        4nrEbuCECFVY11i7zNPzfwsLGA==
X-Google-Smtp-Source: ABdhPJz4jwSCHfYQdFcvocO9Uyyjdfg6thYq+WyJkC1A6vR1jLLoHo3E3+t+8qjoQLRGH/E0pY1pfQ==
X-Received: by 2002:a1c:7209:: with SMTP id n9mr553944wmc.60.1620246386839;
        Wed, 05 May 2021 13:26:26 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:26 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 02/11] crypto: ixp4xx: update IV after requests
Date:   Wed,  5 May 2021 20:26:09 +0000
Message-Id: <20210505202618.2663889-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto selftests fail on ixp4xx since it do not update IV after skcipher
requests.

Fixes: 81bef0150074 ("crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index ed3deaa5ed2b..f577ee4afd06 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -149,6 +149,8 @@ struct crypt_ctl {
 struct ablk_ctx {
 	struct buffer_desc *src;
 	struct buffer_desc *dst;
+	u8 iv[MAX_IVLEN];
+	bool encrypt;
 };
 
 struct aead_ctx {
@@ -381,6 +383,20 @@ static void one_packet(dma_addr_t phys)
 	case CTL_FLAG_PERFORM_ABLK: {
 		struct skcipher_request *req = crypt->data.ablk_req;
 		struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
+		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+		unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+		unsigned int offset;
+
+		if (ivsize > 0) {
+			offset = req->cryptlen - ivsize;
+			if (req_ctx->encrypt) {
+				scatterwalk_map_and_copy(req->iv, req->dst,
+							 offset, ivsize, 0);
+			} else {
+				memcpy(req->iv, req_ctx->iv, ivsize);
+				memzero_explicit(req_ctx->iv, ivsize);
+			}
+		}
 
 		if (req_ctx->dst) {
 			free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
@@ -876,6 +892,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
 	struct buffer_desc src_hook;
 	struct device *dev = &pdev->dev;
+	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 				GFP_KERNEL : GFP_ATOMIC;
 
@@ -885,6 +902,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		return -EAGAIN;
 
 	dir = encrypt ? &ctx->encrypt : &ctx->decrypt;
+	req_ctx->encrypt = encrypt;
 
 	crypt = get_crypt_desc();
 	if (!crypt)
@@ -900,6 +918,10 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
+	if (ivsize > 0 && !encrypt) {
+		offset = req->cryptlen - ivsize;
+		scatterwalk_map_and_copy(req_ctx->iv, req->src, offset, ivsize, 0);
+	}
 	if (req->src != req->dst) {
 		struct buffer_desc dst_hook;
 		crypt->mode |= NPE_OP_NOT_IN_PLACE;
-- 
2.26.3

