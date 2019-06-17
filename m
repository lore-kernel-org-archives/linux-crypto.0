Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B825BC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C17208E4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R3cBNid6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfFQQEE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:04:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34303 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727996AbfFQQEE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 12:04:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so5944036pfc.1;
        Mon, 17 Jun 2019 09:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NffYjCT+19kqu15C0XR6euahrUMgoS4xoGIubo2p80U=;
        b=R3cBNid62KF9am1jU12o6Vn2rYWB32GFZt9Ocsfq6Zl0q4mIRtbdYY/CYx2PtfBQwU
         Is+SPejpfpMVzkxVeMAwPldav5ZOicXXWNriEAaKO/GBIIiJvdmTMKWwWOuk8IYTfmCy
         kk2j6S2hbeU8o4Pm6d+iORUrkJsKnsLo70IjKCKcyZbppSQabbXYrXVCme+7XIElmOo3
         gYQ0O2PmLVy93JdBTDRMrtDp6ETe0QcF9YYl7TV9LeYc+f812hUJGkQYX//zFKUliOQc
         YdFzZiKCGD+Pui/oFiCaIz61EGepuhmKXDJuzThekR+krWtKOAw8BVPHsoPrG381WNW7
         YR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NffYjCT+19kqu15C0XR6euahrUMgoS4xoGIubo2p80U=;
        b=EO1hSGv3RJtnvJvl1Q+8Osq2HXdlAtNxpw8YP37qaP0z/p1HyphhZJBclSzRomdl9P
         8g1dTlm9kpp7u/3pAzRMLoFdSEEY4duuDIjUGTM1JoVGK8zgCsbCN4JLLU0eXyly/fMw
         F2qhwFh3Zf7dmyE1/iqRgBBMzWMESe3VJyc0rbSkWRIPFc4VZfdznPHTvF0/KuvgG2hq
         DHqCJ4SioCNjH2hNiiSlTvOniS8cSo2V7TkdPNGcSTphZehuxANcXHwGn/hIsQJ9QdXC
         Ur1TzZ0Be+epbr/0yb4kLp0ErnCCgKDE638UazPt6MWmEPtLl1702g0+XwndUv9wBtth
         VRmQ==
X-Gm-Message-State: APjAAAVtZ9/VeaERkEkaSxaDzM7YtA4n3AH9yAFtlj+SiiWdwHqoCRtU
        HKExV7vvlxeycGEW/J/jjbj2dOpBD3k=
X-Google-Smtp-Source: APXvYqwGL2+Nxya4XyPZRBn7XDI9RyxIsPE29y5kHHokxNLIRcofTWz35lXpf0khrx3oEdO4HI6kcQ==
X-Received: by 2002:aa7:8394:: with SMTP id u20mr102119781pfm.252.1560787442976;
        Mon, 17 Jun 2019 09:04:02 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id d187sm12834073pfa.38.2019.06.17.09.04.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:04:02 -0700 (PDT)
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
Subject: [PATCH v3 5/5] crypto: caam - add clock entry for i.MX8MQ
Date:   Mon, 17 Jun 2019 09:03:39 -0700
Message-Id: <20190617160339.29179-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617160339.29179-1-andrew.smirnov@gmail.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
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
index b9655957d369..888eacc7c17d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -528,6 +528,7 @@ static const struct soc_device_attribute imx_soc[] = {
 	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_clk_data },
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_clk_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_clk_data },
+	{ .soc_id = "i.MX8MQ", .data = &caam_imx7_clk_data },
 	{ .family = "Freescale i.MX" },
 };
 
-- 
2.21.0

