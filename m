Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2459C35264
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBDA21973
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="nXYqabRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIQSgm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgIQSgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:36:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B546C061352
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a17so3117978wrn.6
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9qViGrdUGpa0ThWB+YcFxDSbeYaJXJqK+FKlEA3vuxA=;
        b=nXYqabRMAd6ecAv6o7n+gbyP8lIEInIM1bduwtk6gkOAsnFCZFVNSEbxc4gjOhn2He
         ptpAwvp9f3TYVItGu0CWnX8YSH/bNnf0ThJJc04JiOHRtJMed/bQytK4fSDx4xLq5ZFy
         2m4lN2B4zic6x4Z0W5EltglSFnAcB7ulIL3JEUQJH5Hr2l/z6JlRsNalfq6BcCfjKvAj
         A/ePNKMUbjPbVkZSg+jaPLF0FQ+UpFYLQ/Rcio52l545Dp9pyaJkaLSFTbVsYy8PWjf/
         ffSH9+EovqeSe4kEUnRyjBJXUU1DtlGiKikA5V3fqYz9taWP5JG+htBaVRd3EDpVFT9l
         lffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9qViGrdUGpa0ThWB+YcFxDSbeYaJXJqK+FKlEA3vuxA=;
        b=EZpMTdFR1zGwhRw9+cYjjxS0Ok4d/gsBgIHf38VQVMiqZr/HgnDv0N+XRT3PEvK0kD
         bG9GkyuhYgoTmjURVbUbjt29g4ApQCK0UW8k7zIY47cytEwcYcieMoFAQinI0vgM910d
         x5TwYy0hCqBsfNey5mc+5I3x10FP3IcaF1ZVCh1AhoJM+7XB5k2r/0eHmIuaHIbvdclI
         S4uCfJZFfEXdPkV7r/LjKFcx86SbAHDnPZzAFWBQkD8/sSecQDHsXhNbzlYquRgJgVrS
         B78H2ritDQR2dh4bsjBY4IohSbvoea/Hw8UiZKLikDbyEvj0J0BzwJUzogpNv7lr0Nhg
         BPBg==
X-Gm-Message-State: AOAM533+IO2JrrROUK2jCU72VAtGsQz7YhiCcCrF/3iX1zzW0PwBLqp2
        m6JEPezz95theTLz+GtGWPUKlg==
X-Google-Smtp-Source: ABdhPJy7+7QERE4fHeCWidnhS46dr4Oq55POtQVLZeXG+8jIPa6GyhVDO/qNZvzRbwQjpN82CwAdSw==
X-Received: by 2002:adf:81e6:: with SMTP id 93mr33456129wra.412.1600367771799;
        Thu, 17 Sep 2020 11:36:11 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Thu, 17 Sep 2020 18:35:55 +0000
Message-Id: <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.
Furthermore, the non-optimized function is too complicated to convert,
let's simply fallback on BE for the moment.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c6c25204780d..d66bb9cf657c 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writel(cpu_to_le32(v), ss->base + SS_IV0 + i * 4);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -213,6 +213,11 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (no_chunk == 1 && !need_fallback)
 		return sun4i_ss_opti_poll(areq);
 
+/* The non aligned function does not work on BE. Probably due to buf/bufo handling.*/
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	need_fallback = true;
+#endif
+
 	if (need_fallback)
 		return sun4i_ss_cipher_poll_fallback(areq);
 
@@ -225,13 +230,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writel(cpu_to_le32(v), ss->base + SS_IV0 + i * 4);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
-- 
2.26.2

