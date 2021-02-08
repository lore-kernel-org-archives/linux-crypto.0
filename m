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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AD3C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5183B64E9D
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhBHJu1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhBHJsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:48:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E330C0611BC;
        Mon,  8 Feb 2021 01:46:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d2so8465656pjs.4;
        Mon, 08 Feb 2021 01:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=uCYoZg2R8/14y0vFMLpPaQrQnJMbTKrlnsoIPOS5QGxuth7pVrBwrA6j9gye/csbVB
         j+5RtB1vgQ/mWJWxDFGUR3KtlxSichulOWha+IW3/EorGaqTwmHXEicitQnSp8F7qo2T
         H4eCH5JgjaxXZAVWGSmV3s1TNTnZX0F6jCFyziRIAFb4TX8fKB5rld8F/WFR79ktoXDA
         tOxJTl4TOaA1rZRtpJV2v8r/6EHbrW7ivVSuAOmysEsiDzLM22xgt3fiIobRfWrcjANg
         apZiOo9RQ4NrxVP6+BYZYoL1Y4yC5j1VVpEPnVW0V3PZhttbddwkfshnBuy8i6z3muY5
         dHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmGD8HgPe/79+tkqFpZtuKTtNUxMt+0Wii+rdB2TPJ0=;
        b=qEl1/eFhqcmjRxpzT6h87+Wg+lqF5ZtoOv93Eqh1bij0+YOyEMndKi0lUWuKCAG8Rs
         iW39jLM/KHh225I6udcudXdJcaYlHsKknjMGENPLa+zhKgUtZfOCYv4VsVPdPySfoCPy
         HHy5vLD7A7RwTGtRg164oV0H5T4KzBc8xTg3CrHdTCm/dea3z/h2f7F/NRPoiDWWdSZX
         7YBrcNkDo09AYLOc+nunRJbgpLrzFgP4menpREcOaEcpi44FpVQplrv/Q2yhWWL1QyOF
         iYnIQuwR767awTalzRyb5m2L89P4XK0VbCEga73Mpjk6glU2s6OpGiJTzA+VjoYpzFRN
         sVcg==
X-Gm-Message-State: AOAM533AD5fLHY8bkeDTSoFbEbkIMpDZ5avhsGt/PE/tKE2g0+p9XHtZ
        V5PVkzb1JqAv4/MXCt0+edw=
X-Google-Smtp-Source: ABdhPJxFAfA3xnZa/SdlnyWSMLtUZfzO6fW1PsgSY+mW3dZpcPzfVsYschVtjHAKOzf8A52dbNSn0A==
X-Received: by 2002:a17:902:c242:b029:e1:8332:f14e with SMTP id 2-20020a170902c242b02900e18332f14emr15645661plg.41.1612777561736;
        Mon, 08 Feb 2021 01:46:01 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:46:01 -0800 (PST)
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
Subject: [PATCH v5 19/19] crypto: octeontx: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:38 +0530
Message-Id: <20210208094238.571015-20-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
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

