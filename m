Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36427C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CCEC218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UByox/6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGCIOC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46251 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfGCIOC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so785184pls.13;
        Wed, 03 Jul 2019 01:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmCsYbm1OChUS/6iyzuZc8+iRZsteMJe/aD4EAVxC/s=;
        b=UByox/6ooMiUeUN9pNJYDu5l/7oPAkbrqiAGR6ZlR/yGvFd0NRmZtOy8mgQFOl9Xx9
         P+RKZo5hMxaIa/X1bDjJ+L2JRQZzKiTGgm83+W16ScQKadvAn7mw2EagotmP0zEx3tPU
         bDKkMfb/slpwP27vSkSn7gL/T7abisnqf2tBOpH/09W3cSP+5em66Fsj30cXq15fbj1E
         rrTA1Eb3Sn2RdWuHj081Kh8Ko+H8N87p+AuP5Dl32aelgOpB0z2ZZvABLPMRNoOL2D7h
         roMDXQfCoJDbAGAHYJRfSdaWvpiQzYT6iNKR18YqyJaKO87Wgny2tZvCjlNOYLjVVjQ6
         8SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmCsYbm1OChUS/6iyzuZc8+iRZsteMJe/aD4EAVxC/s=;
        b=YXV9coBG60Xaj7zedKqR2UyhY0xaqNK9KvCMxvDcDvBC2Gzq0N2dDjJpWG66aB4NRt
         keXCfv5x9MZr0Gl7hwtvnhOde/NH3DjiWsuG+AkRTdQ7jgl/9C6HvPNthWAMSeMa+5fc
         Bvpz/UhRIf5h/ZPat066aAE02Fk7QzA4XJqPYrz1qN7N+Owxw8MRoGdfRrmQ6LrPSTCi
         Ebrg6qli1dbsGeTZwWCAWzcHsTZD/iSNNSXJjdk54nGUncAHIuS1fpD364fKiEXwTEib
         yc0rrfiZv7Xqezec+iQ3LmwyRJC0pbZ0Y48Zf5ztkvPZuWcyeDm3RwrtYlmIWWrl63V8
         t10A==
X-Gm-Message-State: APjAAAWjLv0mFiaGGn/U1EE5gmNSsW+VoIyCowXGyDm19nCHEmlOT0v/
        atnhfmKnaThSlxcIVBIstZHOvz05//0=
X-Google-Smtp-Source: APXvYqxPwQGd/DQpl5Vf317Gi61kfH7TZG6TGsyBMCktingto6JDt3KHixMP9vvfKMcenuLf4NVcyw==
X-Received: by 2002:a17:902:106:: with SMTP id 6mr41661031plb.64.1562141641353;
        Wed, 03 Jul 2019 01:14:01 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.13.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:00 -0700 (PDT)
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
Subject: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Date:   Wed,  3 Jul 2019 01:13:14 -0700
Message-Id: <20190703081327.17505-4-andrew.smirnov@gmail.com>
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

Move tasklet_init() call further down in order to simplify error path
cleanup. No functional change intended.

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
 drivers/crypto/caam/jr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 4b25b2fa3d02..a7ca2bbe243f 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -441,15 +441,13 @@ static int caam_jr_init(struct device *dev)
 
 	jrp = dev_get_drvdata(dev);
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
-
 	/* Connect job ring interrupt handler. */
 	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
 			    dev_name(dev), dev);
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
-		goto out_kill_deq;
+		return error;
 	}
 
 	error = caam_reset_hw_jr(dev);
@@ -471,6 +469,8 @@ static int caam_jr_init(struct device *dev)
 	if (!jrp->entinfo)
 		goto out_free_outring;
 
+	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+
 	for (i = 0; i < JOBR_DEPTH; i++)
 		jrp->entinfo[i].desc_addr_dma = !0;
 
@@ -504,8 +504,6 @@ static int caam_jr_init(struct device *dev)
 	dev_err(dev, "can't allocate job rings for %d\n", jrp->ridx);
 out_free_irq:
 	free_irq(jrp->irq, dev);
-out_kill_deq:
-	tasklet_kill(&jrp->irqtask);
 	return error;
 }
 
-- 
2.21.0

