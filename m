Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C6EC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86AA32088F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbRvP+JM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732950AbfKTQzC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:55:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39632 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732934AbfKTQzB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:55:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so13590pfo.6;
        Wed, 20 Nov 2019 08:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=fbRvP+JM2Y9NJsh1l25Fwsbig1fuTNtWcFYEyXHjcxQkwNwyBC92m3NiGEbTH4o5vw
         6Kp8ohEoezigJfbAUCcds//6jXfjIOEXIBCrUhmFTZOm33azOYnR9cfus0dGUWCGzgoP
         o6i9gu2s2Z9nLHPeJWLqpCymYuNYoHY0UP/MOpRN64L1I0ZKZdWlpKs9SXWxW91R9Gw3
         1P0i1YSN8ayNLbIMBK9Sr5ee7Vt16ahflX5jknJDY5VbWd9dz5q7SG9tF47hBpaa7vMa
         MBAn2H58vm5pVyuj7fh4F0ovFTF8fuSU4TDMeaz8YQ5+veFVszg/rq/zAXU2X57ggn3F
         V6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZVobmFgrwdoULTp3hehMSizYkD3NBn4CVCiP3rG4R64=;
        b=BzLsaURGfNM+Tu4Eg2gL1fZPvQbzrftmj+mMkhMjKXBMdG5XLm0L+aW229Kf8tH/HQ
         op1zn8fQw6pcwTlGXB6WEVkpXfUMJHr4ELB9iBWfB/AphB7PZq3DAxhRAlJPc9LEGF1Z
         CnXngKTUTcSDFuAT0I1QFHYCgMvsnVwX1v+L+iPgH5Y729zcB+bcaYjhEdDaIfj3+Ua4
         F2EbvbaYrCJoslEPDciaqStICuyPg1kZtWtMX4/XSDGAhmp93cY8VlQ3drLBtecSAOV/
         H39D3Ou41qZ5Q/EMV2nyMMBMG187S/+ivdUYZx/96oGtU5gyO+Z/I27y49/iKcmwC1rJ
         St2g==
X-Gm-Message-State: APjAAAW7Nv9SuJGiq+DffB0tEj6HkHEQVzElgze+mlqlGp9uNAGk52L1
        bFhSJtd0ReGum/xf+zwS7ddbUkvb
X-Google-Smtp-Source: APXvYqxXSfMhEPdVflj9vKj9n8He8r2/ccaYceladWM75mlN7oKQ9ej2u/FFdBHeRkXe2qm/qwWSCw==
X-Received: by 2002:a65:4381:: with SMTP id m1mr4380746pgp.43.1574268899812;
        Wed, 20 Nov 2019 08:54:59 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e11sm29841483pff.104.2019.11.20.08.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 08:54:57 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
Date:   Wed, 20 Nov 2019 08:53:38 -0800
Message-Id: <20191120165341.32669-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191120165341.32669-1-andrew.smirnov@gmail.com>
References: <20191120165341.32669-1-andrew.smirnov@gmail.com>
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

