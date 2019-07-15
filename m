Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7DCC76195
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94BFC20665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="har4LFRV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbfGOUUJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36884 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbfGOUUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:20:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id g15so8255775pgi.4;
        Mon, 15 Jul 2019 13:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i32RPM0bqtXuQZnoA3be1ZYAE0+DgtYdltQtvEXELbg=;
        b=har4LFRVJ8GX5FbuWFhXEuks2GUZr6zXzrhpJxl2uEZNjNKk0DdEjawm+olHdSnTJE
         g0lalDdP2GzCGU5cbljfzjNb5RnnyWTH7Jf97os36umxefFn+fSuLcEMUnnaVL+c2azF
         43GVucgrzoaVGbiEEpl+Hu72NeSpAVISUw/wniJcCF85QB8ma5PPR6QrZLlGq3zPRYgm
         8qGsJneRVoEAwyNyK5JhYJ/ucY1mIuePkLJG2AWr84O9TNh5WM+hs9Crq9iplnVW5o2O
         Se01kCozJS0FXe1oQa+dAitzji6xHwtJKjfEQobCtTpt9DsFiqRia550w/BVF1hlhJNo
         xT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i32RPM0bqtXuQZnoA3be1ZYAE0+DgtYdltQtvEXELbg=;
        b=dzKiga1yLx8u6xaW3Y4t2DGQvlkggerfIHFJ92w7VU4d3kp/ZnWLDRvRcjkufAEUi2
         eXQnQlsi4BBPDf6+Z59iEDdMd2bmH1eeejQT6Kgq+Mvm9rYOWCJdKu6Sfozwj+gAewy9
         r6P+JkQBmsdDcda/bQIEBdLLi3acOg/+bsXG0jSmR3KipfAbWzpYTYqU22dcQa44r5TR
         SF3GF+HdJ2Dq/x/k0sdYMhLCPCWudnfFDOWlpNqgRlfFB+4wmOmzf/PY9koRgV1lj1mi
         1yZEPpzKjryPGL/ZOtvvx5knnYOGMXev9k45DRLngZBOT1BzpOYkIdg/JiS2ajoYwjDu
         toXA==
X-Gm-Message-State: APjAAAVfXrORwIFX3nq0CI1M/RpMyVadBAYoDW5yMykhKVBHgVBnKZhw
        DuEHCB1eqQlwRKdmx1d7DaF0E9YH
X-Google-Smtp-Source: APXvYqyephSEwUmgBiyZI5vIP2pdW/c9cPGMm5cnxKZH9/oiyPvRHu0rMHyLsPpi8gZVBs8bSyngMQ==
X-Received: by 2002:a17:90a:d791:: with SMTP id z17mr29773686pju.40.1563222007026;
        Mon, 15 Jul 2019 13:20:07 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.20.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:20:06 -0700 (PDT)
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
Subject: [PATCH v5 13/14] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Mon, 15 Jul 2019 13:19:41 -0700
Message-Id: <20190715201942.17309-14-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190715201942.17309-1-andrew.smirnov@gmail.com>
References: <20190715201942.17309-1-andrew.smirnov@gmail.com>
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
index b309535f3157..ad6ff4040bab 100644
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

