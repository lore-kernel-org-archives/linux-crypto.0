Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A17C43465
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65752158C
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="cxfwt+vj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgITShs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgITShc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:32 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6FC0613D7
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l15so10178051wmh.1
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gd2hvr/SAKzjKtmSl3X2mEioPmDAlGeI7zVBmc2l4K8=;
        b=cxfwt+vj0IMFYW+JQ/I7RatzPtFw1+jGLORAJybIyLwiBbd8P6wU5H00s9S1g4XMCY
         UtVX46Nx5geEh0rX6GT/R1NqCO0wAXNvq3PTMp5xIYww5KxBWgMxCm08fYTjWz8EDRly
         ORI6B+JW2+/ifJ9LxD6u6F21uUfuTr3CMQTPHbky+JTF7baBn+u9aYHI31U0DUYBtoPK
         Gku7/dytrVz3juRK5t7OQNxRwpCr840JqSDM2TwYFdt0VxmmGUHG41RSjfnRWNaCOPDB
         T0dou1BYOe5x7NuYgGSLZ8uaOHyw0lvLaQmG7zhUGOm7By0kKCa6jx/62Q5Gu59Csz3q
         Mhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gd2hvr/SAKzjKtmSl3X2mEioPmDAlGeI7zVBmc2l4K8=;
        b=V2nlRA7TFhKSzjwuXpM4EPnHmD6VDesqO8FpFdMt6xoUq1pAbq/x3eS1Ezdnm2TWz6
         XEJDzLbaPvPeDOS/2vNiLdGHj2EUWjXo7AFEyFKiZ19OxJnu2kesnmO37u5BcRhruDG3
         KpgnLOXKC13luuOLc2kELa9Tg6D7nF49JfV8ZCcErL+1B8z1Lssgc/cFO3fGAMYDohR4
         Dp6SB05bXX+vx+nkg+0NJ1Qth+kvGwImUfnniS1atNz5Ba9qOyqFFnURXTClaDIQ3jg0
         m2ubOinkoTgTv2DidJACo3qVe+2xiFyUYuQmE9dNK/4osXPpGkt5LjWTAiNSNsA4vH8v
         bdhg==
X-Gm-Message-State: AOAM533tqNPwwBxY+k8F1cX1Je8sESgJOjJnjMGxhqXSlODuCpkq1+n8
        ynYVCsoPM5obOVpfzdahVDvtHg==
X-Google-Smtp-Source: ABdhPJxFgf7fh7vgfuCj7uPWgYnoR/9rCAgoeOSkNbbVfdIgvzC4Qjnot2R01IIEr2PfqXC84D6//w==
X-Received: by 2002:a1c:f208:: with SMTP id s8mr27172664wmc.85.1600627048332;
        Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:27 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Sun, 20 Sep 2020 18:37:15 +0000
Message-Id: <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index c6c25204780d..a05889745097 100644
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
@@ -225,13 +225,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
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

