Return-Path: <SRS0=RoO8=UG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEECC2BCA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3564E208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgNRd8LS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbfFGUDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jun 2019 16:03:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38840 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731356AbfFGUDO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jun 2019 16:03:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so1778906pfa.5;
        Fri, 07 Jun 2019 13:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4w4qky68sS5jtzYYwPL+DoWN4LFY4kdxoZDOz0CE2m0=;
        b=LgNRd8LSitogz+gT+KWPVWiaFBHa94azY6rqI620v4uzWLQwBq513CRAZa26EkJx0e
         LSB43j3SVg8h9DLdZUWir8zkzvulNvjhFijFCy7xTwEa42IHqxvrLboEQS+vFT9qXNQu
         /fmxYdpsuSL0bqWPQar9sU3n9ZuVizlfiO/wvEedrM6442TB/NZ8K0jORP2TT2JTlO2/
         tdoJ1g45kLfgSMHak/i8YfAEqbTphyyvhNgeGs9hlcINg+caVr4P0FsN7jQDIO8FEeYu
         qbMUqbFdVJEV/YXTgHkoCLGb/dQvSquaA8c8vC2p0fwGNwflkXhaVRTEeHpQcSXDlIul
         4CsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4w4qky68sS5jtzYYwPL+DoWN4LFY4kdxoZDOz0CE2m0=;
        b=lponJH9H3OUnwjTJWNjQFRBdGiUfNnvqG37O4mZce43SlyZxygRCpTZ2C+HFnXJUEI
         Eq8XJL+FXT/lqkDHVM50zI53fEcqWxdwSjGhIY3H8jFR2QfitA74mRqylWusZziXT+ii
         0eARCLPQg8XegosqWS1AjvMbiWe38tYeaUGHEDVMxEUBpWX+DANOlnF9vCXEX3xoeBHc
         X95tTcEzrKdRBA2qircHL8RHIhiWIMeIMrQEqfFHANPfKTE6wpbG2NA/DVJJC8Ml5AaP
         CXH/80sb0gcJ5kfPh23wIP20B0oxHFdh0+IupnBVTKUkXCj1QfCHuJJ3h2sq1Qc6yQT3
         eXCQ==
X-Gm-Message-State: APjAAAWF2kZlzmp44t2X/Lk9XSKSzBAgcM0w1PJzYjwKjM1SVAO3zrVY
        yNsUq6aug6UtoR2AKWzm/BBGOwcMntA=
X-Google-Smtp-Source: APXvYqwEKcpXbXXB0prW1dxsN3n80G75LdHkFxnoPW39VjKDXQ8wYzh5UzsyaJuilZbaOSVtjpbPOg==
X-Received: by 2002:a63:c744:: with SMTP id v4mr4617896pgg.370.1559937792698;
        Fri, 07 Jun 2019 13:03:12 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id s5sm3289405pgj.60.2019.06.07.13.03.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:03:12 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Fri,  7 Jun 2019 13:02:25 -0700
Message-Id: <20190607200225.21419-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607200225.21419-1-andrew.smirnov@gmail.com>
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
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
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9750fcfd37fc..c50fc059a441 100644
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

