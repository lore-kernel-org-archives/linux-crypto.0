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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F8CC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2F1A208E4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTVTWk8W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFQQEQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:04:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39096 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfFQQEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 12:04:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so6074291pgc.6;
        Mon, 17 Jun 2019 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oScAg815dpC9PbTBv93gNwvPVQ64shuleqb2f2OZnrA=;
        b=XTVTWk8WXNY8pPbge6G7nLODt/8u6oQt4aSgbpKV342ePgrapp90hreARn0T1BIt4+
         ATrC5Kowys4Zdn8OJM2TBxl7w2u9Llb8aCD9UmwIhgL9iA487zLZ0LpZquB24YEYjQs+
         JTOwFP+RcO4x/sctubZSR08s1F2sOvmfrUzHNyu5lJdzDongqMLr1h+JQRn58sO+yyNY
         o41ERPzMDLOHHFMXQF6jJSzhdtDcCfOkGuMNcGaSw+kYm64IHs4B5hggpHm+hkem13ar
         CyVF4n70sPpIZQikBje73n1S4vgEqEmKdcwe0FrCc+fq8g2JTxMexTiTXaJxH1dD//1B
         Yx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oScAg815dpC9PbTBv93gNwvPVQ64shuleqb2f2OZnrA=;
        b=j8TVqzIAyaKIM/jMdNQkviH5L+1hWQysz5XQAprY6oFPS2EJe4WQ3neenhjgzbsNa/
         DOyNxgXx/gTF9wX9VoBV3V5OF0SKUEF7ZbcI8Zr51x6Gf/A29WYA6t25gOkD/kGPPu2Z
         fx9qr/GvFFTbai3g2MdPPzrYe9+AC+E4aVej7ZII0oeLVNQ5bxnv4ZsdatyWR7L+DCdz
         txwC1ECpeNfIx4OuJ/U//WMlzitukTc4bQPgsp3EhrO/ivw+ROjcXkD2ENXMIWpbkjkN
         aLISM6RCkn6JhJXRsul5f9HCCw7V44ET5sPfbHCXIsCXlysSoxuB4YE4n8ZGQcTTcYxS
         Uuow==
X-Gm-Message-State: APjAAAXvybZw21sxrvkhUV6J7s80yAPffB1GXQEmY3uuIauZSk24yPfz
        UHlvNJsDxuDWqJa+ZIxqyTcYnesS4qs=
X-Google-Smtp-Source: APXvYqwvMTwCuiva/0ovNeyEtQGktnr9d19qG0OGj8M3dcSsOwzcGLGR77hmH15gdmTUVJLA7JSZng==
X-Received: by 2002:a62:f20b:: with SMTP id m11mr62297938pfh.125.1560787440440;
        Mon, 17 Jun 2019 09:04:00 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id d187sm12834073pfa.38.2019.06.17.09.03.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:03:59 -0700 (PDT)
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
Subject: [PATCH v3 3/5] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Mon, 17 Jun 2019 09:03:37 -0700
Message-Id: <20190617160339.29179-4-andrew.smirnov@gmail.com>
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

Per feedback from NXP tech support the way to use register based
service interface on i.MX8MQ is to follow the same set of steps
outlined for the case when virtualization is enabled, regardless if it
is. Current version of SRM for i.MX8MQ speaks of DECO DID_MS and DECO
DID_LS registers, but apparently those are not implemented, so the
case when SCFGR[VIRT_EN]=0 should be handles the same as the case when
SCFGR[VIRT_EN]=1

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
 drivers/crypto/caam/ctrl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e674d8770cdb..e6e2457a573e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -107,7 +107,12 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	int i;
 
 
-	if (ctrlpriv->virt_en == 1) {
+	if (ctrlpriv->virt_en == 1 ||
+	    /*
+	     * Apparently on i.MX8MQ it doesn't matter if virt_en == 1
+	     * and the following steps should be performed regardless
+	     */
+	    of_machine_is_compatible("fsl,imx8mq")) {
 		clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);
 
 		while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
-- 
2.21.0

