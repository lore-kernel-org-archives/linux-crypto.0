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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EB0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E2064E9E
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhBHJuN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhBHJrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D68BC06178C;
        Mon,  8 Feb 2021 01:45:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 189so339793pfy.6;
        Mon, 08 Feb 2021 01:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=ApWKweDrKDpU0fMRsdEf4+d0CAZUN1Q9h5p/1AUF6cRmIcqnX/F5krvog7HtwIPzwi
         NwvS5QfVzkFbS+VWJ3/2gt3mb5+6U1ug8Np95HumVaXEKyXVwyrJsA0ZKmwv38ldzhKB
         kiHCliyObcPQY70peNC+v4hmFuc9nx+2ajKZAL8JMm5iqOvLr+rErtpqubV41Ft7DW3m
         OHOvcOXx0xHDKR0w5N7ack48m7+blXzymg4mV63CUx0oVuNKWroUkk/Rb6HVMScdC9mK
         Qa4PEY6i8RA7f9sCPdpI6OKoJy78KK3Z2hthvyU5bCrxyBi3UpcGOi/igw+wAGg/dUdN
         Xb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=W+SaWpFVTI7usHuo5pvrKKQbWc6xWndqFk7PG12jvr+Z/J8sO/SToGOTeGaQCNecKq
         nKtgBEeuI90/CZpAeyOT6PbFmUofX8PJXzIyQSkvo9QGsHMbiWBvlWzP2CTk2OSAYKHM
         uNDXAmqxKDjX07zFlUntpCTDU8C9bY8ITjLuZTK2sAOqz6kD4t5M5MANXbmWl6Oc1+P5
         7x/z6bjJq3GvzXfd6/Dtwpf8XlDKRFqbvHD2iZBFS5KvlxRMsp1DnEDuBlO9x1z6V7oO
         bxZ3h+mjPCzV/RYECRyvJ7Q4KBZy+7lpK7Js50oXX0yz0ngPqXIhedCRlmPZSf2dvz9P
         tslQ==
X-Gm-Message-State: AOAM533mr5pg52dtpwRQuaiFQVZkdjT9BfmCuBvxQHhuaB/4kGWzx1bT
        WXpaHHfMeoneeTwUlXul/+w=
X-Google-Smtp-Source: ABdhPJyZCCeRkcGMY1ZBPc5avbbzvh2aZ0DbxTjeVcri3Zq/yzhqHPofVINcOAchEvAi1Y3gv9u3Tw==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr15713787pgc.359.1612777504785;
        Mon, 08 Feb 2021 01:45:04 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:45:04 -0800 (PST)
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
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v5 13/19] crypto: picoxcell: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:32 +0530
Message-Id: <20210208094238.571015-14-allen.lkml@gmail.com>
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

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/picoxcell_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 84f9c16d984c..e64fa3e22521 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1137,9 +1137,9 @@ static int spacc_req_submit(struct spacc_req *req)
 		return spacc_ablk_submit(req);
 }
 
-static void spacc_spacc_complete(unsigned long data)
+static void spacc_spacc_complete(struct tasklet_struct *t)
 {
-	struct spacc_engine *engine = (struct spacc_engine *)data;
+	struct spacc_engine *engine = from_tasklet(engine, t, complete);
 	struct spacc_req *req, *tmp;
 	unsigned long flags;
 	LIST_HEAD(completed);
@@ -1649,8 +1649,7 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
+	tasklet_setup(&engine->complete, spacc_spacc_complete);
 
 	ret = devm_add_action(&pdev->dev, spacc_tasklet_kill,
 			      &engine->complete);
-- 
2.25.1

