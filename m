Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACB8C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 18:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24E164DE9
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 18:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBTSaW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 13:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhBTSaT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 13:30:19 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629E6C06178B;
        Sat, 20 Feb 2021 10:29:39 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id a132so9905482wmc.0;
        Sat, 20 Feb 2021 10:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6hWDTEdBAXwx+lO4Qg45K9E7WWGnRAxPBEtbtmemIXY=;
        b=GG9eJKfYJsmV/mlV/H+/A8relxB+8IhsUxXDHYFDWub62SPeIwOJrz2FWJUsB53XIU
         DXv1bmRKJQidzIxsrXic1x4VFiOZ4st5ZaoHzo9ZCoMvgaLRpFwlL9WhhmceqDVG2UcK
         OyooWMrTPLpHuqRNy4YWHm17iGp4siBhe6rxPhSKkXIrQGIQS1UnNsTr1Mdougbxq9BX
         RI08Z6Lpr98Lc15i/KfZ7RTuA7GKRYitaFjnHkBiL+v6NMdOSDWTg04FDjr8M9NzOp+t
         sRqE8TZzjSplj3TXXpQ6nsaeEKueaOu3ZfPMwlzHuUnn3cD1MOKwfudFtr3oegKWmSKv
         G1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6hWDTEdBAXwx+lO4Qg45K9E7WWGnRAxPBEtbtmemIXY=;
        b=aw7ado+YUrRlcmDlJszKClGLH2ArwlBpv5xY7sKNsSi9ngpcIGO8h3GK8Nw7RKH4bH
         anDwExiuM1eCVenc2DoscNsrPF4xziey1x26mAMefmK/8SX2T/Rmj/+wSZEbk0Z9Q5u0
         oWiNd6A0wwR4mu9Kj/kGvy20iWCkZS0i+osfp3XSPQ+03w5x++I9wh8rjPeSf4HJ8mfJ
         ZMw9R/gUo5QQEf4uxqmwqIYSI2l/Se/tzQMX8e89pbGWWJTf8J6IHfPIOlfGMhP6DD4Z
         9sDj5ia4JqxICeUperxfS/YoLhrZzFDramohKEL9cGIHfOlKIwUILROtqA019FIjfWBf
         zObA==
X-Gm-Message-State: AOAM530b8jsZG+zNnvgzrcFwaYiZecC0iSG62E7q3A3cxShtjhGrEkZa
        f13XWectwdGOlmipxKbwCVQ=
X-Google-Smtp-Source: ABdhPJwOD0GvdhATabqqxveaXLZg4sDfX87LYDDwtZqkQNmfiy8UKmnnWeOXSalXHUQDxLvZWWEv8Q==
X-Received: by 2002:a1c:9d51:: with SMTP id g78mr13750396wme.5.1613845778047;
        Sat, 20 Feb 2021 10:29:38 -0800 (PST)
Received: from skynet.lan (23.red-2-137-25.dynamicip.rima-tde.net. [2.137.25.23])
        by smtp.gmail.com with ESMTPSA id w81sm18038448wmb.3.2021.02.20.10.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:29:37 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        Julia.Lawall@inria.fr, noltari@gmail.com, f.fainelli@gmail.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: iproc: set quality to 1000
Date:   Sat, 20 Feb 2021 19:29:35 +0100
Message-Id: <20210220182935.11247-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows khwrngd to make use of iproc-rng200.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/char/hw_random/iproc-rng200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 01583faf9893..e49868dd9b96 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	priv->rng.read = iproc_rng200_read;
 	priv->rng.init = iproc_rng200_init;
 	priv->rng.cleanup = iproc_rng200_cleanup;
+	priv->rng.quality = 1000;
 
 	/* Register driver */
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.20.1

