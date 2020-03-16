Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631E6C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383402071C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjPfR7YF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgCPPBD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36290 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbgCPPBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id i13so10096904pfe.3;
        Mon, 16 Mar 2020 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0Kh2+LS4t0Gn18HgPrQ7Dx9B87FOQXhtsCkrbuPHSE=;
        b=hjPfR7YFCSspiBssrhLO0118tojUGw3XN/gHbYr6h68xMxP1AIK3OzsjEW+WldfUmX
         23ozeQ3xUQ12mypSaeK/7tATUdxjberBMjqtjiSEoDjTnvDzS9XOGlQpyrsuTEogEJlU
         GzcW9h/CQiK+ryvFs7org0XtQO+tDklbU8HC8N7BskP2fNP9kSftiw4D+RtITDho0CYw
         yvaxxXbqhDiUD2PBBOdlU3n/iqqiumNGmAgg2BaGFj0mHUxnAr/KpI00n9FhlI5P+a4i
         HEArAtJqvx3t+8bRz9uj0tfYWPqi+VfYpx0TnkWbbVKISfa6KC9ywwGWlHWxuD4eHBub
         dimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0Kh2+LS4t0Gn18HgPrQ7Dx9B87FOQXhtsCkrbuPHSE=;
        b=OaVh8hUmM5tPZXxB44RllmLGNA79cyNcVt1iBAz/pqXGkDkbVAor4yOhmkjhD7cv0f
         6rlXHXwRYGchEbnUW5NvD6dZ7XwUub97cFeZeThiH2eh3CF4cf1G/UeYdV9apSjVOTNC
         Dhg+2qXoH2XuMyU1cu7YSImWPrLVj8iGCflF+rrjIP+b1prUEoljj9CWqBfQ6MyQe5kl
         5LCZjNbzmZCDDhCOITGtMWBD4+1Xc+sauEPhU3rswUe7lKoWH7UXd/XFOj8hbzWUhObN
         mBZ2+UYt2xVM6j+zc994yVFnYwzHYO4ZzsYwRnB7iPiURzlH055m9HTEh1Y16mW9LBVX
         OUXg==
X-Gm-Message-State: ANhLgQ2jt2ROtkV3YjiEaboK6vBBPO1sI7+EbE0f1aNcdlA7bK9w+67k
        v2Bg1zKCVKVuXmg+VUF5FSYJ8nDl
X-Google-Smtp-Source: ADFU+vsTTtN/HPWOdFHcvalqUd9XsRBQ4rGiHfxHr+Mlsa53oZIthzk7icK6ml93nCkxEhv4+XNkYg==
X-Received: by 2002:a62:5c07:: with SMTP id q7mr67445pfb.200.1584370861806;
        Mon, 16 Mar 2020 08:01:01 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:01:00 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/8] crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
Date:   Mon, 16 Mar 2020 08:00:40 -0700
Message-Id: <20200316150047.30828-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200316150047.30828-1-andrew.smirnov@gmail.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
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
index 7139366da016..7f7f2960b0cc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -196,7 +196,7 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 	u32 *desc, status;
 	int sh_idx, ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL | GFP_DMA);
 	if (!desc)
 		return -ENOMEM;
 
@@ -273,7 +273,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	int ret = 0, sh_idx;
 
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
+	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.21.0

