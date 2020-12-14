Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44985C2BBD5
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B099207A0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgLNUIc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502978AbgLNUEU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:04:20 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544BC061257
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:17 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id l23so7345210pjg.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K1Ybs+hT1nPIORP2XwYBCL9D0EZYSmN/d5S7S6dnsio=;
        b=g+LNnNxBUNpU7QpFrxNKjl6txTsOOQHzwo1n74/ZGkW1xYEo3ghMx8d8gv17is0vfB
         /IiG6hqy3cl9DDBeK3tJoosmjJiEUDmGeI9BfcZbvS9vg8ZrqrSvMuA9bIc7L2mQY/o6
         CdXgXVvBNUVQu/zEl9PQ+rLiGCdTsRfSZR52IaaLGfGTOISRWVt1+jkbs+JNOZBX23tA
         5Sto69xFCyXCsr4u6S399effMuJiVAZjrI/5TnEaIiwyNXQ8RqImDBA2lMySSN9cfYRX
         AnHuYTIZDQmEFTkoaVN51W2xitoRo9Fbag24kZ/eNeQ0BX70JVm31nDLPaOJZqPhPdZj
         iGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K1Ybs+hT1nPIORP2XwYBCL9D0EZYSmN/d5S7S6dnsio=;
        b=ToDQalodZ880xQxnoCwVGeRzyJNnZZ6SBKOJ7i9xCGnD1GQqoTP82fEpzNdsGJnzsl
         vQuw+PbHiZuWzErOwJG3b1yQqaR038Y4y/XS3yySATzhcrPz3fePx9M3CPJSr1lw/EO3
         qaLeU/fMw20TSN8qPHl24bEew/NKvKSwW1AaVqwoM2ohXOrS5Ym5YIbrWPiAbUlq8dJW
         cG+f2ZQV8VHpOO5GWFRQlG+fvczV3/sxFvspX6cQ3TsBg6sVIME1LlhwRJSxEMZsbIai
         Q3z8/jD57bSb17++C3qoGo5MTUD8yiwKjb/DHpglbBkinV086XVoOhMAIH1sB93dRJHf
         bGEg==
X-Gm-Message-State: AOAM531vZKAIifCdZElInI3bp+fimFN3YjXkY4TTdcDSdScS1iej2XYx
        Buu+hHQQyHqqCm9snlrBdtATnA==
X-Google-Smtp-Source: ABdhPJxadrTTvMZ1XJcLsGOHcN+QNjm9wpcmYYgls91MdCy9Qa3wTYd/uomMSGJUuJXoDU5RmvPlOA==
X-Received: by 2002:a17:90a:a58f:: with SMTP id b15mr19829282pjq.17.1607976196699;
        Mon, 14 Dec 2020 12:03:16 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:16 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 4/8] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Mon, 14 Dec 2020 20:02:28 +0000
Message-Id: <20201214200232.17357-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
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
index c7bf731dad7b..e097f4c3e68f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -223,13 +223,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
-- 
2.26.2

