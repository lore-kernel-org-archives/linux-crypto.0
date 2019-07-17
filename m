Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13622C7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05CC21850
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiQnQw7P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfGQPZl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33663 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbfGQPZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so12124033plo.0;
        Wed, 17 Jul 2019 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i32RPM0bqtXuQZnoA3be1ZYAE0+DgtYdltQtvEXELbg=;
        b=ZiQnQw7PuBpAvdsanIE4Xt4xDe75Mpx0jzF1MdYN6/vpSzRhBGOvOCrccTz6tvdWRF
         tPtRJK0KijECjiu5SRu5graygZdwrg9NAi0sfbwZ+CB54GhKLGTd0NJjabGy+q6VbZ9V
         8hPo26U4vaAIMGM3CwX0pqg14RgTSm9kp6sUN9JdeFyavX1HZdw549MRV4d/9Orh4ne5
         aSquGzNAzvzS7feOHJ7uuN6Lt7EJpYqvJrykTGzt3Z5h2F9fi0zLTF3zvifNT66FqfRr
         WkSVZ2yZj0YaXC5iAew5L3kuVMI7FW9avREk6D+cj/nPqGeF6bJx1gLak7g0q6mQiqbD
         4S9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i32RPM0bqtXuQZnoA3be1ZYAE0+DgtYdltQtvEXELbg=;
        b=erPUrkdyvS6XC8qhAWOGkkaEL00h/A0h4tGhiNaoUS8+UgQXMUxWcz9Wqb/6rzwh6b
         cqf9RCrhYU3N3OLTGV5U403QQw3vSLqmSNtnVh37XTs6yXL7wv82tTc6iPajJs3AhU4G
         WfacZnd0injVR7EIuwKvLamewGVbmSlLgSNt4FZARAGQUjfE0+IIWAPUzvalR7/nrLgV
         FHUKZpm+f1ETyYUlhFHHNiI5iRul5l41I0aHYMME9sNf4WIQ/SOFvKAT/lFg/LDq2i60
         6u3X1kf98H/BnZGB/lxwWt1YVR8qDpuJeQku48C66OpQVMmQy2vijJBCBV6oCQHcNjnY
         GxYw==
X-Gm-Message-State: APjAAAWGkLi3dArlreA7YOEX+qwjKYOLzdPeBRzDvCKILqv4tRPtlSSP
        +P0EPQI3w9DDHHyfiZydHWQ7mgCV
X-Google-Smtp-Source: APXvYqza/ID1R1MJcutdu/GUV2N4f3pkgvfuedAHugANw6+Uq+I3SMOl4Qiq0UGCWmbHI9u41PqCKQ==
X-Received: by 2002:a17:902:82c4:: with SMTP id u4mr43775277plz.196.1563377131097;
        Wed, 17 Jul 2019 08:25:31 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:29 -0700 (PDT)
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
Subject: [PATCH v6 13/14] crypto: caam - always select job ring via RSR on i.MX8MQ
Date:   Wed, 17 Jul 2019 08:24:57 -0700
Message-Id: <20190717152458.22337-14-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
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

