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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA33C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7895218AD
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjGvB2vd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfGCIOU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34620 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfGCIOU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so825100pgn.1;
        Wed, 03 Jul 2019 01:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3NE6eF8wtZSbcEMraRfzpbuJsj8vIEFXgZ9uVdKcjs=;
        b=MjGvB2vdicUC+rpaKAkXobo4d4VHJRRoHXJfCbyAa/hzEWdvz8mdYPZiIwCB46+imG
         DDNtYWfLtizE6NhwQmkrSzcMBVXU4z3kRgDuOgPYJ48fVdoo+5smd8lySjs4Rwo+qWf+
         27L0n6Br7f3GCdtpc1BQTIB0OSQ1odY/rxsJxJSqFkpG3v/RPqn/LrYulYJvC5hA08Y5
         syancLCDgupxxzz8dlWLIa37qsiuP/0IRh0B1hGGFAnNzt9XGd3JWARku2O0V8VF7PQ5
         UA4UOCjeclOtCo3XgjuxtatOiJL/NWkqmvGTjMDhbFtXMexUNMOqgMioriSqoD0Q6Pqa
         JaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3NE6eF8wtZSbcEMraRfzpbuJsj8vIEFXgZ9uVdKcjs=;
        b=Li/KLlhSy2QYL6rkOncx2AM2x4wOr8pRw1pr5rBmosjCIIf59Vx6wt4jqm7RKm6QFb
         iUHsYiLsOd61JHbrVqtzE74iOUfBVzlPdosR9G5UXOjPgADm4hNrTNZ3yAGd+PYk2/6n
         NFrG67mCW9PPja/05hajf4CRAq33W3z4kpzO15KrRUhvR2qZV11A/x+O0h9n9zCVZNeP
         fiJxX/qDzbPOKMIovkj0tpWNA4ngs/6MgR6PjICwY8hXOczxadfgE+gmkVSnwQm8PvDF
         r6HbZ4xoHEYU/TlQ/wsQ2VJ9+I4QqHaZIw5ucESvxg7YDy6eXuXK7Iu0fduRyXknXzyt
         GPtg==
X-Gm-Message-State: APjAAAUtSl3w9PDRSlIpkDKCN9jhLKC1wUgb9YaSn+vMa75sdmyXmyQ5
        sItP429o61afEN+2fYboVxdi9FFucFM=
X-Google-Smtp-Source: APXvYqxD0vSuPSwOFaa0ONFk6vM54vgp5nr7d54JfN1Tutz7WSjZUlZ3J8J0UV1Jul9hXde0zjsmFQ==
X-Received: by 2002:a63:545c:: with SMTP id e28mr36881906pgm.374.1562141659184;
        Wed, 03 Jul 2019 01:14:19 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:18 -0700 (PDT)
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
Subject: [PATCH v4 16/16] crypto: caam - add clock entry for i.MX8MQ
Date:   Wed,  3 Jul 2019 01:13:27 -0700
Message-Id: <20190703081327.17505-17-andrew.smirnov@gmail.com>
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
index a354c64ca39d..916b63f4f93b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -527,6 +527,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
+	{ .soc_id = "i.MX8MQ", .data = &caam_imx7_data },
 	{ .family = "Freescale i.MX" },
 };
 
-- 
2.21.0

