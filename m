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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738ACC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377D564E27
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhBHJrF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhBHJou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:44:50 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761F5C0617AB;
        Mon,  8 Feb 2021 01:43:11 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9so8460838pjl.5;
        Mon, 08 Feb 2021 01:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1ChG13UjjztSNVmWKm8LG/tQ4bXSFaATn/TncVbdO0=;
        b=T5syCcXJp9ECpk82vm2+7hmGJKlYvipt8MdeOw+1/OIDLPUbkXXgxcUrrvsAicXl3P
         NOAU/R88AzwgDeJJFH+QneZY9b3yysAkcQDNGtZcVN48FmGDhrAjmwLex8KfdfPtJcRb
         rit9eexydLejDaVGwC67hL0KBUWKQyF5xmgVp8K1GdHMAHiEJBSkNugAl2KkbNV+sYag
         GiRy9tU0ec1Vkw4WJ5bivAe6cfenmvq0gtLil0aOyRh45bDTFPYtYpl2wO2nEXsAV25+
         hONX2zevYi4gULbYBV49qLviLnzGJ4ySTAzVUHaNs8jDGD4gDoPF2tKEv2ZunH7NoYjF
         AjLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1ChG13UjjztSNVmWKm8LG/tQ4bXSFaATn/TncVbdO0=;
        b=M0PHr8uzCI8+elXVXcroUfehFPgBBV3X9+C/HvSNr53INeYdiT+TDccHqHeZknGSOO
         ymi1d0/teiL9w0TR0NLn+CGyQqcpq8WSMngvElG/5nM+Qbyr2IpSC8N/ViqPoDXrL//f
         oIt2Wzwgx+1UGlnT6knykDkjBP6rYXNGN/C4Ue+/B+/swILsC+YE6pbCcxLzxXZH43in
         zjuangxotDsX1WgU7djFKdpuCzLNStCcBDSoSCOpMRzu+MFzf2H4BHMkR9cWKrCbhuhS
         kfYcdjfpb2v1Lv5RzRhOCbTu9PgIYVoQ1kxnGxvdx3kxfoGr7j5eD4rk8Jo3uO3q/Gpv
         kfAw==
X-Gm-Message-State: AOAM531AKLUa9CjMHObu0nWFSy9DxOPPHp+jDtfs8PbVXyaX5kNLws80
        SGPE49MxW7lYJU+Wpqo4N/s=
X-Google-Smtp-Source: ABdhPJyywK9e9JjwWEAMufqCNgRCmU+pUvue7JS13f8T1Q7Y0jGVZuJNjqTfq/4k+vGVYxmKblWfzA==
X-Received: by 2002:a17:902:26a:b029:da:af47:77c7 with SMTP id 97-20020a170902026ab02900daaf4777c7mr15598456plc.10.1612777391098;
        Mon, 08 Feb 2021 01:43:11 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:43:10 -0800 (PST)
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
Subject: [PATCH v5 01/19] crypto: amcc: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:20 +0530
Message-Id: <20210208094238.571015-2-allen.lkml@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8d1b918a0533..721ccf850f0b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1072,10 +1072,11 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	}
 }
 
-static void crypto4xx_bh_tasklet_cb(unsigned long data)
+static void crypto4xx_bh_tasklet_cb(struct tasklet_struct *t)
 {
-	struct device *dev = (struct device *)data;
-	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
+	struct crypto4xx_core_device *core_dev = from_tasklet(core_dev, t,
+							      tasklet);
+	struct device *dev = core_dev->device;
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
 	u32 tail = core_dev->dev->pdr_tail;
@@ -1452,8 +1453,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_build_sdr;
 
 	/* Init tasklet for bottom half processing */
-	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
-		     (unsigned long) dev);
+	tasklet_setup(&core_dev->tasklet, crypto4xx_bh_tasklet_cb);
 
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
-- 
2.25.1

