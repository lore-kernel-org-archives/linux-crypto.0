Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29F9C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B63FC216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+9Zn4c3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfHLUIt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34624 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfHLUIU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so48331668plt.1;
        Mon, 12 Aug 2019 13:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hkp3G+DyaHhtptU5+NqkGexINUv2DZxaXcPwVtwRiGs=;
        b=J+9Zn4c3CfEaGKcds2ANE2b1ES79dPCHFJCneGUZsFY/c8gtALj0PIa7O4PM8GaUC/
         oozu4QFjqodhiCkn4L8IP/3T/gCIJq2G7Y9JDHY1ityh9MhGUVQF3K/uiKpMjFZMvFHK
         jbHiFxsvMrFsoIdjg4VqkJaOvSzYgtSlE1OpA6qmRGFi4yvFJIxbmMjXnv6AXR89ymCO
         0wkxcKHUrRHMRxFo3IiZAe92e5nOACcosXPy1i1rWU4egPxdIzQrrWalsnHvhoYGn5/W
         2VzFUOuDsDfJhelfKxXtM2WFP5a2kLKLrKPAmTUX53ZCadw4PzxufdXTkZ8lW5EUkzlk
         RcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hkp3G+DyaHhtptU5+NqkGexINUv2DZxaXcPwVtwRiGs=;
        b=VfEidY+X9eR0UYcyuE+aeTKhjIiMhW/5agdb+mm85JZTAZd0Ei3vr1fyE8homNBy3h
         KeNBi247I7sp7iW+Q1WP3oakogxh8lawvtpWgQy1sWtme4WvDfllR1iBGOD6SJfW6jl6
         WTfKtqXMhkjlJIkameIU5Vcbyom9N1kpHPoWA2fMGbg4OqWx2Sx4FAIgTkjkYSWtA/Jl
         Gs8+qmeT3ZNv2+cEE5xp6vwB4u05g+DpZItFXN10Aa63DYCu8kfG6s0FNj/UE1+rTJLT
         v3X39sn2dtz55XNAqzSCTsoVcq2j2VF4TKhey0+zjkYsA/AUYF7wNSvmHPJBbwQ88eJF
         MWqw==
X-Gm-Message-State: APjAAAVY0blwznIRMzaibTKsFgTYZjOkpZG0hZ0mKqfxcXQicJRHlpdd
        hPr11hcoBtRcuf05VWOFMK8vr+/N
X-Google-Smtp-Source: APXvYqyysdWZVFPT5oPESIryY9EJjhxOItucmIpi3OoXVoJE6d9BCNSH7R7knDYWaVp1UGp+wIQLEQ==
X-Received: by 2002:a17:902:bc41:: with SMTP id t1mr3786571plz.171.1565640499405;
        Mon, 12 Aug 2019 13:08:19 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:18 -0700 (PDT)
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
Subject: [PATCH v7 14/15] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Mon, 12 Aug 2019 13:07:38 -0700
Message-Id: <20190812200739.30389-15-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
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
case when SCFGR[VIRT_EN]=0 should be handled the same as the case when
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
index 7f6022a73865..d3bdc56b9256 100644
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

