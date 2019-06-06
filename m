Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577E4C04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF4520872
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uv+fwX8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfFFRVU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:21:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42391 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfFFRVU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 13:21:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so3553167qtk.9
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jun 2019 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SPyiw97pWei/KHbnhDdWTM690wY/Ap74V9d6g8sFxqA=;
        b=Uv+fwX8yhulNH07QRWC9hu6BYogyWC1uPxV0ecV3G6h4bZi2YUpmXUDfE9w0lSyUrL
         EXXZgThJWuo8CDM6pUVWcKmIWGzqIbL7sGz2bW9KzY6HywPPgFnPaE/oJpMauyLmafko
         viXAojBUENyCugxc+T94GatLP3Vow8Bm48fuex0ayrtlJ+6s9jfBv2JsREFzMitBEIof
         ylZ9lwt3s/kCHNTL2C3AXQZXPnPBCZlZaPkfLEE7TfNzg4/0nM8WQTah1LFgomDH2lnl
         3ytZcO9/M81LATmE8RFU07X1Xxuv60IiOJIb8XOxsxkI4v7V09Ll43pf2eQIZMp4+Jz9
         KZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SPyiw97pWei/KHbnhDdWTM690wY/Ap74V9d6g8sFxqA=;
        b=o4w8ZNNYZwLF9VtYf12JhWJl1GeOLpfJjLweQuvIPS9goLPwWnTnc0fnhnME/MhmTS
         /0Hu4g+3B7wJAcFPSExTbnD9DpAa0QY26nWqxhFLmYna7fpLoE/GpXDCZICZka5u9QuW
         Rl3wH1d0RpplDrxX2ZA4HaAARhYM6+1vHC5AOMAUAOf6pHl5BlKFNKAEEkcvCHvn1Zzy
         xmB7woJ3E0zKFzg9HySsW9fMZH8ONsVO7PRyeFgo1oAp93ra2dEBa0lLeGMv1bNj+Dl9
         fFGBbnvOTFJFn2SZj4X4vRWbXR3bIB8H/HiLGsXAZU6lUc9NG6u4iJwm6eDl7DaFKhEK
         vNzw==
X-Gm-Message-State: APjAAAWfi5GPwj3EJmV9zzb8FeC7PtdgIubaGpRj1yQFJLIZvNTEOgFa
        D4608TtsyhXRrm6OExafuII=
X-Google-Smtp-Source: APXvYqyPaHkjuN5jWZ9BI1UWrj4Lab1307UNsWN1uirOByKQF3dJ0pJ3/nW9VQMcPrvrmpoA30rs3w==
X-Received: by 2002:ac8:282b:: with SMTP id 40mr9966301qtq.49.1559841679542;
        Thu, 06 Jun 2019 10:21:19 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id u125sm1204304qkd.5.2019.06.06.10.21.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:21:18 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     christophe.leroy@c-s.fr, linux-crypto@vger.kernel.org,
        horia.geanta@nxp.com, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: talitos - Use devm_platform_ioremap_resource()
Date:   Thu,  6 Jun 2019 14:21:12 -0300
Message-Id: <20190606172112.15701-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/talitos.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 32a7e747dc5f..f2269a2f8ce6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3336,7 +3336,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct talitos_private *priv;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
 	if (!priv)
@@ -3350,10 +3349,7 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-	priv->reg = devm_ioremap(dev, res->start, resource_size(res));
+	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
 		err = -ENOMEM;
-- 
2.17.1

