Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F411C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1186823341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgLGJC3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgLGJC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:02:27 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAACAC0613D4
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:50 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t8so9170615pfg.8
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGKoDGcGM+RwGvXEqZt36aMwO9Zs+cXK/6ewtYJSP6U=;
        b=YMUffoAifTEFNCq6VyY6CW1Da5PBrBEZ29j1IR3CaLHYd/0SAFTxhxLQdD1w6PNc7I
         SBR5rUDQ65ciNi5Jpb2WLnZAwYyAou3QBLb82w/nysjGY9YDXzY6lLXsrTBLAewUhwDh
         4TOK+La1vC1Nm98s0VtRBIupGnumoFNzWlB37Xqq2fmKy2pTVsszYuG3XACQewAUPHxw
         X76Z/OskZ2w29dnN2YPg5c0xQwdzgY3481dRCnWyKmX8RN5fLrq5VsVd26c9bnOjODQE
         E21+kXhJWZ8hNl3IEr4CtOgDSgeHlBLhCejS7ecqM1YztybdPqWgciXhuUM9zwLg3M1k
         IMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGKoDGcGM+RwGvXEqZt36aMwO9Zs+cXK/6ewtYJSP6U=;
        b=fQu0/CXlzkc+e1af89YxYCMtlG3NTUAhOKtg2R3cemRipNMVGjC7nHtM2BmeO4xcF2
         aaa9dtqWhooGbxG4GOq9U3CI+dFmonvYsQqMfWoWhettukO/pJJSELW7EjhgN+23EooR
         s5molfRndzYxeKSKkOdKCUnuMfunOsTWR8davzuyBel2dgkq+EsFg8bTtnGvkUTPc4Wm
         4s8XfC5bJ8enoDO9puFJwTr3KMB7szwtwpNX6E45TSYbM+W7C1dm1plxraFHS/9JPD7J
         KgW0oG+yTh3r4CyxIA/oePFhmMJGzFllWTYYncbAQ6G22wVNYKF/dokP8WbOr/V0Kn2l
         aU3Q==
X-Gm-Message-State: AOAM532au+gj4y2KXKjlPimoIH/Xc4UMNlx4pPX77ST6quEcLxl4mY1k
        llb/q8l1MOBL8G5h+uxC6hQ=
X-Google-Smtp-Source: ABdhPJxJVDi4Hy+Rvcp4uYFGbGyHLH/F7FQG2fQRuWpUSqHaMLgyJsMiDOzF7bKmW0fb9H9jxPDkYQ==
X-Received: by 2002:aa7:9635:0:b029:197:f590:8563 with SMTP id r21-20020aa796350000b0290197f5908563mr14937145pfg.58.1607331710384;
        Mon, 07 Dec 2020 01:01:50 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:49 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>
Subject: [RESEND 19/19] crypto: octeontx: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:31 +0530
Message-Id: <20201207085931.661267-20-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 228fe8e47e0e..515049cca9e3 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -17,11 +17,12 @@
 #define DRV_NAME	"octeontx-cptvf"
 #define DRV_VERSION	"1.0"
 
-static void vq_work_handler(unsigned long data)
+static void vq_work_handler(struct tasklet_struct *t)
 {
-	struct otx_cptvf_wqe_info *cwqe_info =
-					(struct otx_cptvf_wqe_info *) data;
-
+	struct otx_cptvf_wqe *cwqe = from_tasklet(cwqe, t, twork);
+	struct otx_cptvf_wqe_info *cwqe_info = container_of(cwqe,
+							typeof(*cwqe_info),
+							vq_wqe[0]);
 	otx_cpt_post_process(&cwqe_info->vq_wqe[0]);
 }
 
@@ -41,8 +42,7 @@ static int init_worker_threads(struct otx_cptvf *cptvf)
 	}
 
 	for (i = 0; i < cptvf->num_queues; i++) {
-		tasklet_init(&cwqe_info->vq_wqe[i].twork, vq_work_handler,
-			     (u64)cwqe_info);
+		tasklet_setup(&cwqe_info->vq_wqe[i].twork, vq_work_handler);
 		cwqe_info->vq_wqe[i].cptvf = cptvf;
 	}
 	cptvf->wqe_info = cwqe_info;
-- 
2.25.1

