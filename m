Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4A7C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406CF20770
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 11:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="TTqzDXsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIDLKT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbgIDLKO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 07:10:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E08C061247
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 04:10:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l9so5699661wme.3
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 04:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=TTqzDXsBn6FWdO9r4eSR8vJwNAZQ1jLPWhP4CDs7SPszYe+vgueNYk3186j7aAfStB
         fEVb5pkxBi+J03G0DjdIvB2wqir7U8XLMavC3EKaiA8bh02JUfn4gVfoTQVtiyZimRt+
         Mo5VpxyAMLQ5Cx9I1IDcz8R7zrJjFo7fWre8HO+Tm6bw4ZycW796xHsQLfsoQ8FimuPR
         xUydGzzvltVlBgfb5x/Ia+UVlzq/1VBbj4XWUopG6LmJyEOMGG/+kltd9bHRqpVR97Q/
         tTG+X2F/ZdvMyzn9yomxqAKMXa5aNLx1XLSFvp10O8zPzdB49riLiGR9/ZbGxLuudZLO
         da8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=VqgwTTpY8hzfxmNphY1UAABMfwZ0T9HbQuY/JjnPA/uO+h74gFt5nNTd4xJJj17n8n
         IOHzsbaoHhFdDABd5JH3dTul18Wisk/S02xuZy73lD7Gg1R9j+uqKoXa0/VZb/LMENym
         mfvBkSjBLKGOY9E3D3VrAwghokW4JPxtig81Soo3Rk7L6mNal/3IXmUkPQ+aVpt5uKgn
         AgYtKajS8ztBUSEmxZAULGJledS2jsvnduF13qO0BJIG8llbEDmTOofMMVvKNOhPFkuu
         KLU48aFXQV9cESTMr39ymylRMj01+mMU1SeactuJ5MK/ckCsSJqh47bZcRu2UdYCQhoE
         wu2w==
X-Gm-Message-State: AOAM530hiYFT0bYSFMs1JfQ98B+Mo809Dfn0qqcCbVpduQ3QtXr431qV
        kQEmD3m5qEuueRYgu0zOchDHUQ==
X-Google-Smtp-Source: ABdhPJxaY1zql8unea6EJwBEcZXDu+yIaHKhrg1JeNCHEb7xvUJLvcQenAeszW9EoGMzCSrAGh3QIg==
X-Received: by 2002:a1c:c913:: with SMTP id f19mr6904224wmb.173.1599217811746;
        Fri, 04 Sep 2020 04:10:11 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id m3sm10622743wmb.26.2020.09.04.04.10.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2020 04:10:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 01/18] crypto: sun8i-ss: Add SS_START define
Date:   Fri,  4 Sep 2020 11:09:46 +0000
Message-Id: <1599217803-29755-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an hardcoded value, let's use a defined value for
SS_START.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 9a23515783a6..97012128385f 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -61,7 +61,7 @@ int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx
 		      const char *name)
 {
 	int flow = rctx->flow;
-	u32 v = 1;
+	u32 v = SS_START;
 	int i;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 0405767f1f7e..f3ffaea3a59f 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -13,6 +13,8 @@
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
 
+#define SS_START	1
+
 #define SS_ENCRYPTION		0
 #define SS_DECRYPTION		BIT(6)
 
-- 
2.26.2

