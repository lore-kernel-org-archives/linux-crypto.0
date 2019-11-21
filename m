Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C908C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 15:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65420206D8
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 15:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foEjwT/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKUP4N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 10:56:13 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40865 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfKUP4M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 10:56:12 -0500
Received: by mail-pl1-f196.google.com with SMTP id f9so1746942plr.7;
        Thu, 21 Nov 2019 07:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=foEjwT/aA2EoZzdD5cak1S9ftyvsaHNnGNlQue5hvZlZTAutaB9+F9SwkisHlgfqR4
         O85Q4BI2+xNp6hklOb/avcInG7ccAEj5ODYmupNT4Z+DnM+35a/fQi1nNAQWNpbXCeOb
         Lghp/stQVRISpcSlAsFD2hi6fDVB6BcDkDUVijFtoIGNEnv9g17cm8O4vuTaF2XBzT3Y
         /5FWfVo5BtewtTuFwTLbpB1zvsAaK4LzpRUSqSwt1P5eVOGVEPHfhLMyG58wvfiYF39P
         1n64tcUY2Um5Fw0yOC1zFbXVs7/sMF4kyrA1gkQ/mIR7vrIr2qOY55fLXmeUTHq1n66S
         LDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=Qc/820BfaiG2ms7qRorIgoG6ouVS1B4oHM7hEdR2Z7cWyJqPQxhNrG3nirLk/dUGVg
         +I3J/RO+sAOXaJLIaC82benMafIMAXGId8kuZAxwQ8HhAG16pkhQ8NVhfRMwoy3PbSWV
         5/lrVH8prFMIdyEmHbh1YSqOW7I5JXeiUaFoFhg18x8B6JPatqoj6+dPrcAeZGUP8CHw
         1p71DuR70SGI5IBNzKD0DHip9DkZG1JDr1SkZ77h0zkr0GYnhFHMmXFRkp3zrC7OW1Le
         zFM016d84Xh9NaJN0BQknOQekWCQlMaLEKOQk2RdnHvDZHeb8UD/Hs8v2Si0RK/U830k
         910Q==
X-Gm-Message-State: APjAAAXcPdsMaAFdgiNq443UcLqejZTAxBdKlYlMs86foREryufDHOYX
        /CY4jQKklXpcdbaLF2pR3bPLbnRO
X-Google-Smtp-Source: APXvYqwhgvW5BhO+lDKdJHKNOD9Z/RkeIX5RjaO15+7nrmEHvto9a4PnCqo2AbTjjNKaTVTD2rs4mQ==
X-Received: by 2002:a17:90a:178e:: with SMTP id q14mr12566916pja.134.1574351771355;
        Thu, 21 Nov 2019 07:56:11 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e8sm3709212pga.17.2019.11.21.07.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 07:56:09 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/6] crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
Date:   Thu, 21 Nov 2019 07:55:51 -0800
Message-Id: <20191121155554.1227-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191121155554.1227-1-andrew.smirnov@gmail.com>
References: <20191121155554.1227-1-andrew.smirnov@gmail.com>
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
index a1c879820286..8054ec29d35a 100644
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

