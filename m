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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2FDC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506F82083D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDpTTUSM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfFFR2v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:28:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35097 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfFFR2v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 13:28:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so3634651qto.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jun 2019 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Vp+M5brGDuC7e6hY9XVD72ejVZQVSg2/8aWViX7BaB0=;
        b=MDpTTUSMMjtu4CbkZAGgdURFobb9ocEUv+tD5QyIZ/UPICVsEV5CtD4TpN7ibBnGyG
         07vJgNL5rDZJSrFeU+7JsMKCM4NDRp1uL9pnK7TNB1pQauRUk899CzZjLMZt0q6hXDwe
         wV7+8imerfLngPXfZ1koxvEgAZVfAzBNwV18ORQ9Ah7SR+PY4lHE944487Uzz+ymAzzz
         dMiWa5tL8fubC4li7m4h633+7bPnjjwsjoJMktDuMLlJuxPZrYONGqwSZJqX3+wr2zCs
         bJPd6LUHtKJ2cG8Hizi+zUxfOSUmKzYvOtKBom9myQ3/Pj8yuJrNBwXVBulx3CmyPGCA
         L10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vp+M5brGDuC7e6hY9XVD72ejVZQVSg2/8aWViX7BaB0=;
        b=fZQLWOosLrbqoBlBGMRc3arDUOFkGTjp58J4dGxsf3RKPmBtebQvQgCSF8XgS4nZ5M
         hpzYoolGo9u7wc3UKXTLIj/xNb90/dLBsc4PpN8sNA/lgY3hHwBZyEHk07aYzi1RJOTz
         t60KLkBc/i2SnS1l+2/H2azjmU73LVb6HAytWhyqcNvdznX2o+zGSnxhcXWZvxYLHMAu
         UG6R7SSk47rkjZ3PcEuMMy+T15lcUMuaFcsgoYm6iW/Wc4/8U5mHGy2O6dO56o/cbcev
         4Q20zgS6azIpA8erl/ipsN+LscsPWK50fU3UIR4BP+aa8zcOUJAWjMPyH72cwDQpkU1Y
         xJGg==
X-Gm-Message-State: APjAAAVholeYrrze4RaD5s1OgntG5eyMaP+PyRK9k3p31jiVRG6P6WHG
        ZgqIKU35zT4hEh22boKI8kg=
X-Google-Smtp-Source: APXvYqxmg43GsmCva/IPqBSQSJUrfDwb0imG2VBmS82/5c8edl7zeziNUjfNsJnzTbm/Fcl1HD1Vzg==
X-Received: by 2002:a0c:8732:: with SMTP id 47mr19000934qvh.105.1559842130696;
        Thu, 06 Jun 2019 10:28:50 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id m5sm1476926qke.25.2019.06.06.10.28.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:28:50 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     christophe.leroy@c-s.fr, linux-crypto@vger.kernel.org,
        horia.geanta@nxp.com, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2] crypto: talitos - Use devm_platform_ioremap_resource()
Date:   Thu,  6 Jun 2019 14:28:45 -0300
Message-Id: <20190606172845.16864-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.

While at it, remove unneeded error message in case of
devm_platform_ioremap_resource() failure, as the core mm code
will take care of it.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Adjust the error check for devm_platform_ioremap_resource()
- Remove error message on devm_platform_ioremap_resource() failure

 drivers/crypto/talitos.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 32a7e747dc5f..688affec36c9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3336,7 +3336,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct talitos_private *priv;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
 	if (!priv)
@@ -3350,13 +3349,9 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-	priv->reg = devm_ioremap(dev, res->start, resource_size(res));
-	if (!priv->reg) {
-		dev_err(dev, "failed to of_iomap\n");
-		err = -ENOMEM;
+	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(priv->reg)) {
+		err = PTR_ERR(priv->reg);
 		goto err_out;
 	}
 
-- 
2.17.1

