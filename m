Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6D3C433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024A723715
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhAUEux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732513AbhAUEpc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:45:32 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD13C061575;
        Wed, 20 Jan 2021 20:44:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id q4so584259plr.7;
        Wed, 20 Jan 2021 20:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=eS/1ggdFWLmfnsVYZXAbwW1SmBRdM7h+i8u7eMxYshtdJMIwvsuLM6yn9GZBZ9S/K8
         KPB7IXVkvHseo+uWh3JXdsekkzlPnpD1fO5nonseXf9GOWYDGdR+HhSALKkTBW2yHqxA
         vhNiTnb6elTC+ROHAMTVxAmqh54NOFG8AXMg5XK2ZaPgk0Zkawh6ZbuAdmEfdFkEhZm2
         1UIpxFwDL7fAY+OlhacieGmRlqtZX1Sk/wWXzHNgZL3wH6FTjfH0lEmZHOzXOWK4oZol
         FrhZLsRXZ91FD1PC349AL88h5bApuFeMzE3PJ1YZJKXFQ8yXe/V3L7GGuSfN9S3XXoFM
         SpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=cqRFmP4HCr6x+0vWBHmYc/FCT8RzKVW7gSjVc41N132gmYrqJJAZGYpVjEK7/hn5sA
         b33dUNiZpvpS2ckgshygcjIrQ1Y/soWDOuJJ2z/ev+U9yf12YE61tBd8TOuZU/FEECnP
         y9RJBNvDD07GDon1FkYel7rg5KAliqdbWfYGVSIHAJrPf26YlLtT4ANT7UF99v8HDgCW
         OIl0FJigRiKVzKV9M0eyIunN6fO2q9OqiavGqp2JAVBLnYwimoQnTOKqtYzVfGND/gDU
         4tTapBj8Qq+/JCXz1Vv6W0EOCvv3QD0Bbx5uhj5zWrL5KfYQerMcPNBPr5oe1+ma3LBY
         ROMQ==
X-Gm-Message-State: AOAM531Y9x1F3fwANvASbT4JMnl4HnGiOHsGPcJOyAGyuZG068+NBmZU
        uDsJXrJsGV3v5k2qkwAcg+g=
X-Google-Smtp-Source: ABdhPJwK12yN+Nm/X1Li1WBmyUtsyI++TR5W0kfCfg/xipnswNtdqtNaye9X6xF+P0AT5ihT3NrvwA==
X-Received: by 2002:a17:902:8549:b029:de:8aaa:b012 with SMTP id d9-20020a1709028549b02900de8aaab012mr13199334plo.34.1611204292055;
        Wed, 20 Jan 2021 20:44:52 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:44:51 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH v4 19/19] crypto: octeontx: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:26 +0530
Message-Id: <20210121044126.152274-20-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121044126.152274-1-allen.lkml@gmail.com>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index c076d0b3ad5f..831550123719 100644
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

