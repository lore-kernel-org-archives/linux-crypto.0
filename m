Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7075EC2BB1D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48BC920767
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwyF7Kt0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgCPPBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:16 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51033 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgCPPBN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:13 -0400
Received: by mail-pj1-f67.google.com with SMTP id o23so2735880pjp.0;
        Mon, 16 Mar 2020 08:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kfpZWrpoE5n8JP08S8IQsd4cy/AH7i9JnMmCEqutX0=;
        b=fwyF7Kt0CowLhs2uqr/b27uoCrPuAngqF/uAW33LyjPc/Q5+aULI3590R0C0nVELyP
         SPTrd+k06bxbFdqRGsJHxpsAAyBvuTtE4l4oER7AZpOletFvxjTzJmo9O509kNIm8+NS
         mIDpV1Jv/sircGlRxDZyajm9t2vMGy1YuM4oYUrsM85tGYkv/ZsZUgGrCX6mCynJXX52
         2j9pFaHzrBNb1LFbSkJVLc+YpjR+eHQrjZyo8jOt4P7bakKp2dQNinGxczkxAqwvISGZ
         pCsDlivKltZlNseeIvcYdtTJn4YIkJl1p5UljW+R1OajNIgD1jT3sgEhXqP8/jvsP0hH
         gipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kfpZWrpoE5n8JP08S8IQsd4cy/AH7i9JnMmCEqutX0=;
        b=W6ALCEEiTJfqkQVY/gOj6fHrVo85+D8LvoKI2QZUo7H4yQgrGVQ6o6IDdVU6tM84wS
         z3BlcbRYj7Isyvr9BZiRMfGeaMlUFlDdyDOmyo0GHCDVpWqqEy9QBud6V3F6KB63CSfi
         jFf92f8dUwZKhGrCAk2N3uN7f6IuwVifyk9TSxjqrQyIiXC/S+XqDbzusEGw/Rq2Cyw7
         9wmS8q2qLPiypHVXa4nemw+FWQMpU+9Z2IKQfixhxjLEQNjjIUXnrHKK60iwfCA5K88X
         ZZKcFSqMyA7MJ5LV8djQyqmyygUQ9UUd6TWL6c+UvAy7aNDnctPmbhbk6yvAIOCZu7FI
         U9DQ==
X-Gm-Message-State: ANhLgQ0Vxt9qRgrLS2gyOchl+P2FZrY7YhVys9PH4Q5tXIXuu94804yf
        Qs4WnMVIESY+uNcvWrhC+ALoxEfH
X-Google-Smtp-Source: ADFU+vv7Mb877pIIE5+vpncehbvrRG2ZZBqSVEaFXJ4pMft6McCiOQ0GYzIuVb6YYP3Ipsj0kYa8RA==
X-Received: by 2002:a17:902:c1cb:: with SMTP id c11mr27658473plc.80.1584370872214;
        Mon, 16 Mar 2020 08:01:12 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:01:11 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v8 6/8] crypto: caam - invalidate entropy register during RNG initialization
Date:   Mon, 16 Mar 2020 08:00:45 -0700
Message-Id: <20200316150047.30828-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200316150047.30828-1-andrew.smirnov@gmail.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to make sure that we always use non-stale entropy data, change
the code to invalidate entropy register during RNG initialization.

Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
[andrew.smirnov@gmail.com ported to upstream kernel, rewrote commit msg]
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/ctrl.c | 11 ++++++++---
 drivers/crypto/caam/regs.h |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7f7f2960b0cc..b278471f4013 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -341,8 +341,12 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 	r4tst = &ctrl->r4tst[0];
 
-	/* put RNG4 into program mode */
-	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM);
+	/*
+	 * Setting both RTMCTL:PRGM and RTMCTL:TRNG_ACC causes TRNG to
+	 * properly invalidate the entropy in the entropy register and
+	 * force re-generation.
+	 */
+	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM | RTMCTL_ACC);
 
 	/*
 	 * Performance-wise, it does not make sense to
@@ -372,7 +376,8 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 	 * select raw sampling in both entropy shifter
 	 * and statistical checker; ; put RNG4 into run mode
 	 */
-	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM, RTMCTL_SAMP_MODE_RAW_ES_SC);
+	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM | RTMCTL_ACC,
+		      RTMCTL_SAMP_MODE_RAW_ES_SC);
 }
 
 static int caam_get_era_from_hw(struct caam_ctrl __iomem *ctrl)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 05127b70527d..c191e8fd0fa7 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -487,7 +487,8 @@ struct rngtst {
 
 /* RNG4 TRNG test registers */
 struct rng4tst {
-#define RTMCTL_PRGM	0x00010000	/* 1 -> program mode, 0 -> run mode */
+#define RTMCTL_ACC  BIT(5)  /* TRNG access mode */
+#define RTMCTL_PRGM BIT(16) /* 1 -> program mode, 0 -> run mode */
 #define RTMCTL_SAMP_MODE_VON_NEUMANN_ES_SC	0 /* use von Neumann data in
 						     both entropy shifter and
 						     statistical checker */
-- 
2.21.0

