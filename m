Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68232C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D5B218AD
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AczUvvKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfGCIOa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47075 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfGCIOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so796299pgm.13;
        Wed, 03 Jul 2019 01:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFdFgnbGfYNFGWijUj/XlW0cCu4McvzsQkcXKLZ/y8I=;
        b=AczUvvKP6F/HCai5Oa1GCtVY1AilofYFPC69OkqStFoCsrPmasZt2WLIFsv7rylS5V
         Pg+3Gh75cv6pqIcHduFuRyI7fj+lu0NKIckkEHHYmr4WNIPKacHqpRsBL7zLmiCCHY0r
         hbmkzC5Oa6ig9++PaYvyes6gLisM9baNhpFYMlhn+9F3HJwXnwBpTMbx4zKxdWGgSFWt
         93mPMbBRmJ3CDcgomnZsIvG42w7DiJZ+YBrqwcdgBX2R65owBrdNEutdzZcZM3CwHUFX
         FcZKtNsaXe+KRP6UHTx2l5KgoT+pzB1OYAZQUNnDGkQ+WrV7eDTNEA5Kgy3nlVwuxEP7
         n2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFdFgnbGfYNFGWijUj/XlW0cCu4McvzsQkcXKLZ/y8I=;
        b=PkIqzYUYjZX6MdrNHcHmu3N7cB9+hsVMptlVrE62JlwZTFgvZE+/g+cYYzM0XFVz0i
         XHKQhUbS/YRmZVqoGa0V6Nz8iNSUZfIK6adYi2t/q15mL7XLOuDmTZbZEWOKgIQzYFYo
         IiroWVQHANI2Fn5i8lrRSoI0ziU2uinRcawV80XzNgDeCp4pUPJRbAZqqgowY/RovWnP
         u5svLL5nXkznSzgIJmlqivfvL3rEeua5LPZSaIJi8HceizCWRQVy15VL71eCv9FZX6TW
         0f9X8hvyLcgqRfaAFy3cE6Ky2twZG/W4KaT2dACETUR2faiBEbN/a2k6cP7VUaOK46EQ
         vAlA==
X-Gm-Message-State: APjAAAU/DuzWfQx0qmcJz7nOzEsUFndmthUAUVwnfQSDT+pq15I1dz5W
        TeGkReEdTScMqlXJB/o5YYeWc2wtgkY=
X-Google-Smtp-Source: APXvYqwzaR4dkXTDNAVT6FQnOKxqCmAVx0fDduq+qzwa+fkB6r+tP4P4cjVwaIoF9IYm6+Gm/iDqpg==
X-Received: by 2002:a65:4cc4:: with SMTP id n4mr36959361pgt.307.1562141657808;
        Wed, 03 Jul 2019 01:14:17 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:17 -0700 (PDT)
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
Subject: [PATCH v4 15/16] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Wed,  3 Jul 2019 01:13:26 -0700
Message-Id: <20190703081327.17505-16-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703081327.17505-1-andrew.smirnov@gmail.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
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
index adb560950e59..a354c64ca39d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -97,7 +97,12 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
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

