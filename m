Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD532C10F00
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA0F2086C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b81K54da"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfBVKH1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:07:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36956 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVKH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 05:07:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id c8so1712779wrs.4
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 02:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E2eoUdoc/Uk7/EOw+fP2az0brkJJ0yuusqa//jvSVRg=;
        b=b81K54da+ctMR8i2vGg6GBCdcKR3bWxSVFApw5nCgBgKTDdrcwW/g0cFRB4juwSnqp
         mIjDUc9F3V+f05W7ZEIQL7FfQ6fHlzVnLP40ii/BiO3JLZjbkTqWbYU0sADAy+Z2POVW
         ZeQArJ7wOTfROdAxi9MKrX9t8SKE7p9W/ezPWHQVi2MclXDYV2CdNWNnRFC4kJdXFAMV
         8Sr4/0SUvafV5Q63bZYcjzBDSBtngGlT+YUe7lfAsLSP929jwfK0uPf7u8t/aFKgs1et
         Gkbwa1krjmARPk/bXtvNb5/gvqi9sac0EdKmIKoQDFG7lN5W5DaRe4paYoCT2jo3Sp4k
         z34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E2eoUdoc/Uk7/EOw+fP2az0brkJJ0yuusqa//jvSVRg=;
        b=iV1m/3/aND4G6zc0czPEI+jwN8Qz5MN/p9eRGdw8jECWLUAXdUiqpZGWLwN71aZiiU
         zRHiG2GoyrOFi3Y80FFz6TwE5/Rs2Ckwa1GiOuQHCElixjov8r3yE2hWGEeBD9BX3unr
         yrx6aKcTHzfaxKmdSLUdphmm7M/+F+BBNHwavIGwQxJSG6r5DTp0kFi8Wcqa3LTYSNaf
         1PjcMtHtwWIgxCH1zHo0RyLUk76uD7CQNIk7zSyEjSYVvfwPR12j82nDgvRNB+O6HSKN
         Qm1H23DkIuD4rlvfxhwypF2/Uj2SF2A0GY4LWPH7euJrMGQ1P5P1LhbYvgJRCP30wd0w
         Xg5Q==
X-Gm-Message-State: AHQUAubt4x/uV5IkEhWidb6Tu6vsbuIOYDKZumUxPKuAZ5U9j1g4h/+V
        3C5ZFZWjNhGQAplruCFouC8=
X-Google-Smtp-Source: AHgI3IaFFrdFOgoFCqFShNgfLWTomjyveHn0qvfcqc+plfeuZ8MvUttuzAOWqPUaWBf6pT7xSM1ZlA==
X-Received: by 2002:adf:ffcf:: with SMTP id x15mr2266066wrs.277.1550830045288;
        Fri, 22 Feb 2019 02:07:25 -0800 (PST)
Received: from roadflow-linux-dev.dtes.tfl.gov.uk (host81-149-116-186.in-addr.btopenworld.com. [81.149.116.186])
        by smtp.gmail.com with ESMTPSA id j41sm2094240wre.9.2019.02.22.02.07.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:07:24 -0800 (PST)
From:   spencercw@gmail.com
X-Google-Original-From: christopher.spencer@sea.co.uk
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Subject: [RFC 1/4] crypto: caam - fix detection of i.MX8 SoC
Date:   Fri, 22 Feb 2019 10:06:10 +0000
Message-Id: <20190222100613.2290-2-christopher.spencer@sea.co.uk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

The i.MX8 does not currently have an SoC driver so soc_device_match does
not recognise it. Check the machine compatible instead.

Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
---
 drivers/crypto/caam/ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 16bbc72f041a..22cb7106133a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -513,7 +513,8 @@ static int caam_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ctrlpriv);
 	nprop = pdev->dev.of_node;
 
-	caam_imx = (bool)soc_device_match(imx_soc);
+	caam_imx = soc_device_match(imx_soc) ||
+		of_machine_is_compatible("fsl,imx8mq");
 
 	/* Enable clocking */
 	clk = caam_drv_identify_clk(&pdev->dev, "ipg");
-- 
2.17.1

