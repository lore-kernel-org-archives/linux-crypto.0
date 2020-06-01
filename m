Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318B8C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 23:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F00207BB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 23:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2Aj01OZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFAXHf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 19:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAXHf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 19:07:35 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B45C05BD43;
        Mon,  1 Jun 2020 16:07:35 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ga6so470553pjb.1;
        Mon, 01 Jun 2020 16:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5B/N62UW4CnjV5O8Ue8qK7N4+2Q5utDmBxZkXHNXp4=;
        b=a2Aj01OZdFEKOqsKY49mU7mRI0rR9SwcGyHa/6Ul05kxzIerb68AdgsG7lxOfvNgcL
         2p/asSf6QGr7Dxj848kppAcnnYwwKXTq388Rh7j/qpITAGzDfM9GjxlUFny/cLNRRFuE
         IYneoG+FU3ydz/OPbTl5bS8id6bEItgeeC/BurAw4Uj2t1SexE+UY9Br2MIG/lZdIFG/
         4uCfs8j/wyXTakrNIFqru3hk00IgGb3isW0TeEwojvDKCSZ+HqLmdSrOH4FVsZ12dcfU
         9qIxBy5KpBPdmeUEhT6dTriToo+nqmBS4hbyYV+12oWhJc6qM/r2/O7/vlrUrXXTYLII
         L87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5B/N62UW4CnjV5O8Ue8qK7N4+2Q5utDmBxZkXHNXp4=;
        b=Nc68xWE2DbovOcCuuLLyib1oA6N7K3SEfqiJt9RJxMSs8psbcv0TawZq1dtF1GhAGa
         fOzJInPHbiewR+m9KJY5+zf63kCXuTFwmF3Hb7cntL8292kguXSbwOmfnk3N5lPliVd2
         38Hqcc0rrffpbl23LBNQ1YJ7boiJpfb64UwGNFKp92eBm0Ih3tc9+Pz2wKT0tLFsdDM6
         ljelWjLq8mUlVrl2NGT54fKF1zx/Pjb3PVOx/UMUnQGOUUMbSQnJprOhYrMAKIwc7jep
         K7OfOrJrbIuI75bDbqsDgQKhNXp6he7TpunAOzb06myVIYCDwCONdk0WmM653nKfgPIL
         Neig==
X-Gm-Message-State: AOAM533HXIT6tBF++nJ5chI4q+TdEmFNOkK+7wQKHYduH6ajlHWqDGAw
        FG26DcGhjCuxyygfynq8rz9v5gzo
X-Google-Smtp-Source: ABdhPJzQ51L25DuLAHuY3mDoz8uwJm5H42VvZgDVt99gwGKSvZd2xUy6kmmPn/EUBLi0voFAByIOFQ==
X-Received: by 2002:a17:902:301:: with SMTP id 1mr19881615pld.65.1591052854146;
        Mon, 01 Jun 2020 16:07:34 -0700 (PDT)
Received: from squirtle.lan (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id w124sm376145pfc.213.2020.06.01.16.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 16:07:33 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: caam - add clock info for VFxxx SoCs
Date:   Mon,  1 Jun 2020 16:07:26 -0700
Message-Id: <20200601230726.32328-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a small bit of plumbing necessary to use CAAM on VFxxx SoCs.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4fcdd262e581..3d7e87856646 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -527,11 +527,21 @@ static const struct caam_imx_data caam_imx6ul_data = {
 	.num_clks = ARRAY_SIZE(caam_imx6ul_clks),
 };

+static const struct clk_bulk_data caam_vf610_clks[] = {
+	{ .id = "ipg" },
+};
+
+static const struct caam_imx_data caam_vf610_data = {
+	.clks = caam_vf610_clks,
+	.num_clks = ARRAY_SIZE(caam_vf610_clks),
+};
+
 static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8M*", .data = &caam_imx7_data },
+	{ .soc_id = "VF*",     .data = &caam_vf610_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
 };
--
2.21.3
