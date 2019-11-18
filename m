Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51F8C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC3F421A44
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dAU5c9Yv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKRPjP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:39:15 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39390 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfKRPjN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:39:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so9995640plk.6;
        Mon, 18 Nov 2019 07:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=dAU5c9YvrvAc5FwNHT1gO7uVf5sn76QBMhamX3mNn89SPn4RdD1CsA1iWljKHhIPxr
         4Py+yW74C74stwVu+8ZeWVGV2EatiP83gmZFXeUJP1OHcp5og5ZosH+QHArynj75CRGl
         MqT/S8DGhyQq8qtetRmdOKCJhcx9TAJ7Q8iqRqwFi3U/RX8jejXyhBbOJeT3M643GVGZ
         tI47Ec83XSBGvUh/C5pb9FyPWA0AwraU3hqFbNu9W9VwCMyfivDZSi1hCCWaeOOk1Lz1
         LkKD6nZGdyAT6RbYPdoDLRTROTUF6l/4gc0mZZAE9895EPNiuryNOLislreWrlb4CkFi
         7meA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=tPXyaG9GUu8VbCBbY1MaSFVZswPai9iKSc1z6zvap6tYG+3Vwf9L3h2woqNUM6eALJ
         p9luHBKbiynd3RF8QtFc5zFidzdlHaTZfSQrMYRAkneg3byOplkF94QN7euhUFqkESew
         8wgXm4ie/P0xUkoRVMRBZxx3wPOlYpMP+uLZKhfmHgbckVcpA2i+Cy/nwGQGHY013P/V
         ym7wRO7c7uc6zssqr3NzBzx61JYP5nuquvGOWe/mAvVDq/+39ZuVJry2c0k47tuo4iPI
         mR9uvrc17wj6+PTVR9i/Ek/QzfJinWBLSI3WUc1zlV2KLUlxdcbAqnMO3TUDPIreG3/c
         d4cQ==
X-Gm-Message-State: APjAAAW6n+0I0ciddkFenTbMoc14GWMibXQVckJcLzlgZgOW00Q+3d0n
        1yPvR5d4JXaL20og5lvGlVc6xqU4
X-Google-Smtp-Source: APXvYqx/mcdg6RhldBSfa/qG2V1ZbdvXkp4Y2z6VJpMtTjT36r207423+O74pXkVyaUWGRWe8epSkg==
X-Received: by 2002:a17:902:b482:: with SMTP id y2mr30780936plr.128.1574091550693;
        Mon, 18 Nov 2019 07:39:10 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id z7sm23573732pfr.165.2019.11.18.07.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 07:39:09 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
Date:   Mon, 18 Nov 2019 07:38:40 -0800
Message-Id: <20191118153843.28136-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118153843.28136-1-andrew.smirnov@gmail.com>
References: <20191118153843.28136-1-andrew.smirnov@gmail.com>
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

