Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF900C33CB1
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5438214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/0JK8rL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgA0Q5I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:08 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35700 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0Q5H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so5180010pfo.2;
        Mon, 27 Jan 2020 08:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PRvyPinTl56WwRZm2jsRHtlpDEBNkMeEQKYla1GuCIw=;
        b=b/0JK8rLW0meh5MIeuVFHvWBBpCn1O29dxZ03qSEmxyll1+Gc6RA5Me90MYDUBFVsc
         VbETHo0zOMkTQzUUI22zwbKXZiXcAcZ0vsao/8V98Ykai6kvARj/JsS3DXgIKRXQH9ic
         YjHPPkk1Ga6FKSq0bJI2jIqQkXifeoG32YQjLrRmEzmy3XCElhKbTk3monR/QRQr+KdY
         IB9dqWNadIYPxFQ3KCmPEIGs+W+NQJezHgDeUeyOLcOsIh/oDDNJJLdYKbmY6dF8lkQs
         /6obPj6nAREV1wkRCf0mRQble+phLko1xBy5t2O4qzPwHxImIuEKUjxCRPgpXkVdiv0N
         dVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PRvyPinTl56WwRZm2jsRHtlpDEBNkMeEQKYla1GuCIw=;
        b=AbjqNJrzx+iKkIH90TM1Y/Al5DVyLhqkx8kkp29+WoWomDEaQTJ5/8CHE5ZPUw2NDj
         CDo+MyXouX5mdJscz0UhMfk/oO7mv0UcWuqzKpN/OKIjv7pKrB0RyLMSgJkTvQxHicE8
         otExeLie9IeAsKKF5EL+sr9iYK/iBPCDPZJqlb4kGV5slre41340G2Zsvs1RWHCrr3Aa
         ApdJ8luUxmxyuRL7NWQygfHI43XxSCDLIlsgLLicFHsAA4QhdY+mJgQwCTKaD4unQYpP
         1ashDhAX25MtQFqTV76M8qxPFcpEtt1fCp2jfFmIi3qM3cMnkNye/ORLX4OV9OBw6keg
         wP/w==
X-Gm-Message-State: APjAAAVwV5aiIYDTPOn7ybZrw6XVzpR8y3r8+FwrPy+5tkDoRkWbTYKq
        Hl7dLV5IQY7OjZipHyIleoXc3rPm
X-Google-Smtp-Source: APXvYqyXsf4V2K/sgqhMu7zKf/lgK1gLTBOUt2bvgQzvui+PFHJq4tiRWQR+BilWnYd0eETdexVbew==
X-Received: by 2002:a63:3487:: with SMTP id b129mr20431160pga.320.1580144226195;
        Mon, 27 Jan 2020 08:57:06 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:05 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/9] crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
Date:   Mon, 27 Jan 2020 08:56:38 -0800
Message-Id: <20200127165646.19806-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Be consistent with the rest of the codebase and use GFP_DMA when
allocating memory for a CAAM JR descriptor.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 6659c8d9672e..a11c13a89ef8 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -194,7 +194,7 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 	u32 *desc, status;
 	int sh_idx, ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL | GFP_DMA);
 	if (!desc)
 		return -ENOMEM;
 
@@ -271,7 +271,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	int ret = 0, sh_idx;
 
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
+	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.21.0

