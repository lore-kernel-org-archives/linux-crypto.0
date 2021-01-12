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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C15FC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A1422EBF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbhALBsR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbhALBsR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:48:17 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC612C061795;
        Mon, 11 Jan 2021 17:47:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id a188so398736pfa.11;
        Mon, 11 Jan 2021 17:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=dyLRtXDjB67vS15RLsmqGSUOvPPoOTHemszDDXF+TlQiAEsteD0YrxcYZwJDoUvbct
         uVNXnzERBcj0usi04XikK3DYBQ2KUn0Hm1BE9dC2/+cLnoSaPcw0nVTsEHjr0x0JNdW/
         zIEds6h0gVNU+76UE6+PGWSQXvNol7Gpue6C4enyaob+C3OhekAd3dIHXw0vGzclsXOi
         hUsxcAGxXZRjr/SKWpj6+GreRS3oI+OVtMpQF6aTu5ZFDHfjE5rG8//Rd+ejNrUN2FDB
         TpZG/to2TcodizTeA+CJTupytQCv1XwZIQuSjSUpkQZaZ++4KZgLAypg9ns8fciwU7CR
         H4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=iRBVl0h/OZfSqSkEWloCTp9pydFenVwmbm0Be7lepNGWVJUL+HgBu3gKEwj1RToM+P
         BUafuKpppktRG49ynLqxvTZ4m1cmIbaBaKhylgM2toU7eYlmAS6TFSXo1+UP9gC+WqmZ
         zH1yEUiF10zXrC/Widi7cSmVO/qH3NGaQ+t4Zm2+WrhfPDO2BllCa7ur3f11A2CdxswB
         R//zP3GXFPEZrBG5Lv+ZBTWGK89dN5AS14XQrhyfWGq+flXyUhJkrAY+6uoUkx0S7Zhu
         y73zry2ofNNBnG0sPjmEJcBDTxHWS/F95SOcLritzK4a21lGzBFgPlcPevISYnISKqyx
         0eYw==
X-Gm-Message-State: AOAM530X+kYHBF86/lAzWdazxieG37YcyfzlYfNS+JSvGapwrVYEIbxE
        PKdoGceTAYSVWCvXC/y5Mcc=
X-Google-Smtp-Source: ABdhPJwnfmBvyejGqi0Tb2J3Dw3X+mlfmegsFTEcZ+clarKrFxuo2IsTMEoXTWC+GHMQHQp1daHk1Q==
X-Received: by 2002:aa7:8506:0:b029:19e:95:f75f with SMTP id v6-20020aa785060000b029019e0095f75fmr2142115pfn.7.1610416056325;
        Mon, 11 Jan 2021 17:47:36 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:47:35 -0800 (PST)
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
Subject: [PATCH v3 03/19] crypto: axis: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:34 +0530
Message-Id: <20210112014650.10887-4-allen.lkml@gmail.com>
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

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 9ad188cffd0d..52e0c7fdbfa8 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2075,9 +2075,9 @@ static void artpec6_crypto_timeout(struct timer_list *t)
 	tasklet_schedule(&ac->task);
 }
 
-static void artpec6_crypto_task(unsigned long data)
+static void artpec6_crypto_task(struct tasklet_struct *t)
 {
-	struct artpec6_crypto *ac = (struct artpec6_crypto *)data;
+	struct artpec6_crypto *ac = from_tasklet(ac, t, task);
 	struct artpec6_crypto_req_common *req;
 	struct artpec6_crypto_req_common *n;
 	struct list_head complete_done;
@@ -2900,8 +2900,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	artpec6_crypto_init_debugfs();
 #endif
 
-	tasklet_init(&ac->task, artpec6_crypto_task,
-		     (unsigned long)ac);
+	tasklet_setup(&ac->task, artpec6_crypto_task);
 
 	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
-- 
2.25.1

