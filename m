Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A90C65C05
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5172246C0
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpwWQTBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfLMPjW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:39:22 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36378 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfLMPjV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 10:39:21 -0500
Received: by mail-yw1-f68.google.com with SMTP id n184so6054ywc.3;
        Fri, 13 Dec 2019 07:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66dDxa4JQshR1dxJN1HCdA7FRTIVML1Rl2L0x4gBwBs=;
        b=IpwWQTBzg9+efmz6zpdHlpW7WO6Qb2rzpNyjAvojL6elJWNgpVqmZyQ+VOA2jRdCEh
         jGyplAdiIPO/JftjYxUO7sovgTvepNOw0lWV1MT9dznUOuusPMO+j+Z13oroUaaD5bil
         1piYhqNdzEdfXdqhnE+7U5kCEFqfJ8zhu7wceeOYtYpgS0QKCQ+RML/u0oe6npp2nIWC
         Cc9nOT5KsyorY2X5unKnHKTIQ8r9XxZZz4ec1HolS6nH5SjuT5MeeuFP3YXKRzxK52KC
         2LdZ8O6EEN/aQaZn8ExiHvWWt6aJrAMgVOeJJTI1AxGZbbtQSCpn6u9Ib/Kn3pQul97X
         ebAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66dDxa4JQshR1dxJN1HCdA7FRTIVML1Rl2L0x4gBwBs=;
        b=paGbHfPminizg1T70Pj3QKYWFmDEp+RQKlsesNVFmI0ad/wLdWJoqyw3ePIWcG8mq+
         T8vwmv2qTpe57wTHAJ0Sgtlb6+kuNP/7MvthGaWk5HuQwAaJ+kbNTW/J+7DBh5LDn/w4
         RweWhsi1/HhI7pZFiM+m+7rErHnr9UO7q5wSO8GGRQZy9G5my9yx0H4epRqvrw0/OxJz
         E4h3lkCHlAMgLgmBwCrHSO+ax2GGU8RDfqwIof7KS+XUcOcV48txEUieTlayZbIWih4K
         IzZNeLmcHqea3wZVEwN5ELIGdSxgQDrmOK2hWWpAiMmTv5eDnCcPrNM+EJIDp9kvF0aZ
         Xd+Q==
X-Gm-Message-State: APjAAAXc0cPpi8bqXwwoMbGK57GYdN/EQWAC0gejCnbz4v1W0LvvpW9F
        SkzM6ng/EkhNeSZxT7om7A8=
X-Google-Smtp-Source: APXvYqzO7cb72G93h6pc42x43nIgubOr0x06bTe3Kej8fCH2doIKLJGdJ8weE8MbHkaf+/uMF//KeA==
X-Received: by 2002:a25:b007:: with SMTP id q7mr7626962ybf.193.1576251560130;
        Fri, 13 Dec 2019 07:39:20 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id i17sm4300474ywg.66.2019.12.13.07.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:39:19 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     horia.geanta@nxp.com, Adam Ford <aford173@gmail.com>,
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
Subject: [PATCH V2 1/3] crypto: caam: Add support for i.MX8M Mini
Date:   Fri, 13 Dec 2019 09:39:08 -0600
Message-Id: <20191213153910.11235-1-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The i.MX8M Mini uses the same crypto engine as the i.MX8MQ, but
the driver is restricting the check to just the i.MX8MQ.

This patch expands the check for either i.MX8MQ or i.MX8MM.

Signed-off-by: Adam Ford <aford173@gmail.com>

---
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

