Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E0EC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 549A422DA9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xfs0I+aO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfHTUZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:25:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38490 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbfHTUYk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so40238plt.5;
        Tue, 20 Aug 2019 13:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=87Y8dKGWT+qLvvhP2nElArRl78yoCj1VnXaMqe4fD/A=;
        b=Xfs0I+aOXcmM+v86A9IOjZ/GDETVRcOYBCd8dWYCZjE/7wN1jZOTvwXIo7MvQoL6CV
         xKvNydkDVPtAWCzPxHUOTQkrcswvj0TVO6jCr+7zn9fDUQpHyo1cYVX92Pe+Y8jmnT0C
         r8Akwdc0c97jk128iBc4YTb7OHUp54u1gVk/X9B/q717gy0QF91NvUNLN1D4VM9GsTAW
         VUz5dZML4CDyIvx3Lamf6q3gTsH4oUzrVI/OVHV43eO/KUsQk6l6Z2DE5ENfEilwD1tE
         JkJzwv3WT1t4JREmctY0Kw8Qq7gfuG/62ZSLqQECGBnnKT1wifyYeE/hXjJaLipdA64G
         8+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=87Y8dKGWT+qLvvhP2nElArRl78yoCj1VnXaMqe4fD/A=;
        b=HoaM0NFJsca6g7l7NBhY0yArkHkKAe6C/rotIZjKAch+oVAzkUtRf/KCI4lgGk00Qw
         Bh1jDKPqhE9eMUZE4Deomn5LfrGV1M5SX4nGamGhdRMV84MlWDzS0b41ScF7dBOu3b0q
         vC9y2+73KGXBQ173PfXVgkq8e6DerDXQGgj1irHf6o9jgiZNOz09AfAwbvycMq/5tNWL
         +lX6Qsas+c1nimTNddPSrtsjmXLQyGiED789rpefptkmOxvs01lUyceod0evHSWfLllk
         abY78LXLUA5Ni86lwO3SeWOXrwr1XRWFiNnFTIrj2AN2+CI0He1wn6fPd7WyAZp8lgFj
         ARLA==
X-Gm-Message-State: APjAAAXv/OxUwwyuHne5oRXINjgYZtOcHtHLm2RrIlBjRRvP+SchV9rc
        ewg14t640GnI78tlI945CGm9OUKkroE=
X-Google-Smtp-Source: APXvYqxEtlFOP8i+NVNFMe2uzC28axp2CO+ZxDPWbV5CG5lQupbjkf5sWK1TezZYEti4B68D1XnqNw==
X-Received: by 2002:a17:902:566:: with SMTP id 93mr30471780plf.172.1566332679402;
        Tue, 20 Aug 2019 13:24:39 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:38 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 15/16] crypto: caam - add clock entry for i.MX8MQ
Date:   Tue, 20 Aug 2019 13:24:01 -0700
Message-Id: <20190820202402.24951-16-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add clock entry needed to support i.MX8MQ.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 3b18e7e8da1f..3c059d0e4207 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -527,6 +527,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
+	{ .soc_id = "i.MX8MQ", .data = &caam_imx7_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
 };
-- 
2.21.0

