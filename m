Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADF7C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F28322E03
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbhALBus (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbhALBus (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:50:48 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B4C0617A2;
        Mon, 11 Jan 2021 17:50:07 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 4so525584plk.5;
        Mon, 11 Jan 2021 17:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=PIC7XupoDMn9piWQ69Bl0kSfEVHNzrMRig+EIc5OLLCmFuFRswvromgbiophGM4QYT
         ZD80Bj/rA5IwXoG1Cl7PFkQrgG8ZvvcmRUFgRGaEAdl1BXrb2dqQgY0ctp70w1+jPmRW
         T3saZ3Dv0NpvtYnvNIiL1rBjBb5Hsf9Ql6XGjKUxArWP/Jfx/JeApHqYds2TBZ1yA9Y/
         rgZLAHIxgZDLeBV4ciOlD54q8dsDHuwxMT3U13i8N1WMOsTxZhI8Vjg4RzlUtZDe/tHp
         gb17/KPo4c3WJgDloV+1R6wCybnuniZnBEL8Usvu6/JR0PphWZ4dsgLcv7Gw7YJrLo4w
         0CqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=r/Fs2lkA8A2iltRfTpKC6vvCn1mGXHtRtIeZGtppqeJ4kDDl81ZYVRP/nEsuzgv52b
         vOJvhe8rszCSlFJxrALaBiYVN4HmOEuuEDVLhpfIwL16DfOIKPMHB39SCOrBrOgc+7Uq
         tVU/elassNN5vtWeLbgBARA5C7wO5UVXnX2AV1PNjx1tDpDfm5rm4qC/VrBGA0pNmQd9
         aDDwbikQaXeSHHRPpzXhb6K3Ko9/WEAkfGsVUl32AWX5b2f+/rWgAnnZMikXzewfxMB3
         Zvz/8tYJghXFqSnCBRqM7SJwd8VaaspG1XO0XFthwDFtWFTIemyi7BRxvBWOxIY2YAfE
         dyDg==
X-Gm-Message-State: AOAM533jTSdonmE7rh6f/qz+LsJoFzt9I3RvQfnD5Gi28Bg1V1Fp0Vo4
        ufI7oGYSGpdoCCnfCmD/EWU=
X-Google-Smtp-Source: ABdhPJykt4ezhXe8itNyfcI61xbwIwZ6yNHylHi48PECxS7E18PCI0lpNxhryVnVn/naJ48zL6j5xg==
X-Received: by 2002:a17:90a:49c5:: with SMTP id l5mr1833591pjm.116.1610416207445;
        Mon, 11 Jan 2021 17:50:07 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:50:06 -0800 (PST)
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
Subject: [PATCH v3 19/19] crypto: octeontx: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:50 +0530
Message-Id: <20210112014650.10887-20-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112014650.10887-1-allen.lkml@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
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

