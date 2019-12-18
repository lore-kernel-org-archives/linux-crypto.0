Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BECC2D0CD
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 13:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D2A024680
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 13:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7GOlgqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfLRNG3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 08:06:29 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34771 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRNG3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 08:06:29 -0500
Received: by mail-yw1-f67.google.com with SMTP id b186so733194ywc.1;
        Wed, 18 Dec 2019 05:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLIjdUM214rts+QdFmLT0qdowpwm43aLvVt9JtuWnSI=;
        b=k7GOlgqxBrb7DrpjWzIRp+jbycjd5MM/XzKtDlUMxHwrUIXuBXNcVEDICBqRGEJtPs
         lS0/nCcvc1fRc0JI+PfYd+v/L1SoiwfhttrM7O+4gXbSI55qZkJpOQZf+XhF0jes4YXk
         8Pq7nmCmI1wZgSbmlPdn+aLh3W8SqwV1MdiiNMN4ye6CwjFBu6cWQzT2D/+3nUeJg48O
         /G2xqSbfH0pczNadzW+gfMhW40fV/8Cz2PFtRoWPatMgYbnMWWlRthAv3ao1Ft1ytePU
         PTSeq/oFPE08p59UWxEsxEk0PkvWeTSOk2IsdBR+Mv5yyfviPNmC29W87cPPPdyvwAQp
         1WtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLIjdUM214rts+QdFmLT0qdowpwm43aLvVt9JtuWnSI=;
        b=hu8k7rwGiXic+dF0OiRF2EMTXuTaEpGR8Yz63r27j13fjI/WzxjicQA2RqcfIqg5vw
         NSM2wzQCSH0/ZC0RvuAyusYs8o5A5nMltA/4AWkIaWiHDUJOAqyaz3XtHVR5/rrc9kZv
         Ag1VP4B4WmfBrSy2xQovwrePRlbvEcrDfNFuIp4748TM0lEgLC26euBhGRFH1OeK7F2u
         p5KFb5i3paN3z7wyMkuHYcZDx0d8q9L13ooUdtDvkKSduJVZbdiC0px2ejESWhN/m/15
         eM84KW2sTELgvKIZMkc3gLWwV9Nv5UEBONoJ2rDP7MYMgeKxKTpGBFjuwmMjPqkqwzTY
         9lwQ==
X-Gm-Message-State: APjAAAWb34WkJ8CCVepVQtCf1wuhFftPpgvWZCtLzW2uhG8Dmm5SYfAp
        wdGHOatW1ineuVNPJgkHEEo=
X-Google-Smtp-Source: APXvYqzBCz5/Y3IeMZDESTHiuAl8EZLblP3IJZCPORJ/K5z1qkW5EVc4+ZaGd3Qy/EH9AeRJOGyGQw==
X-Received: by 2002:a81:b60d:: with SMTP id u13mr1834559ywh.382.1576674388055;
        Wed, 18 Dec 2019 05:06:28 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id r64sm909603ywg.84.2019.12.18.05.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 05:06:27 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Adam Ford <aford173@gmail.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH V3 1/3] crypto: caam: Add support for i.MX8M Mini
Date:   Wed, 18 Dec 2019 07:06:14 -0600
Message-Id: <20191218130616.13860-1-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The i.MX8M Mini uses the same crypto engine as the i.MX8MQ, but
the driver is restricting the check to just the i.MX8MQ.

This patch expands the check for either i.MX8MQ or i.MX8MM.

Signed-off-by: Adam Ford <aford173@gmail.com>
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
V3:  No Change
V2:  Expand the check that forces the setting on imx8mq to also be true for imx8mm
     Explictly state imx8mm compatiblity instead of making it generic to all imx8m*
      this is mostly due to lack of other hardware to test

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d7c3c3805693..c01dda692ecc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -102,7 +102,8 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	     * Apparently on i.MX8MQ it doesn't matter if virt_en == 1
 	     * and the following steps should be performed regardless
 	     */
-	    of_machine_is_compatible("fsl,imx8mq")) {
+	    of_machine_is_compatible("fsl,imx8mq") ||
+	    of_machine_is_compatible("fsl,imx8mm")) {
 		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);
 
 		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
@@ -509,6 +510,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8MQ", .data = &caam_imx7_data },
+	{ .soc_id = "i.MX8MM", .data = &caam_imx7_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
 };
-- 
2.20.1

