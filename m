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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45948C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE2323341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgLGJBz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgLGJBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:55 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C8C061A4F
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:12 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id d2so5286592pfq.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SBLd7A+SLeCAxqu7t9KC/1LuDodNLH34yTZT195Qbig=;
        b=V/nvvdpbAm2HTIv7NRkBMdqo6AWPo2v3kMFA0+isJmP6m8q16UtsirsXkXpu2CCbWI
         dcDbRNHfM7x9E74oDWkhjO1Ui7aG+G8216kgC2RuG11MT8Q8HqMDkmvnbuYkLgoPQV5l
         FVRjFY7v6RDNE255LVx/zEMygZptqVPiDece4p52Imqwkz+5D3bMTUfNt60BJYSG1ErW
         DZqUaf+sDLMzdfmPFQTjMZZs+4i8DWDPITE0Y7dCwFPxCWvuUP1ZydlnV55Km8af7yeK
         eeaeeBIwqzmRBU7yNwKu0A2VBOfuwXZ1izmbTXoCvQLKzZEbGy0/+Sy7ORzjXGxH9U//
         Z+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SBLd7A+SLeCAxqu7t9KC/1LuDodNLH34yTZT195Qbig=;
        b=FrnHKmaJFq8Lck74cLPFZV4dNjivhYTsLDwgIjeYrO0Zxdx3AMf7Z7/nF2dBH0aAON
         1dtx2/jHK9I8N0JBTEekGjs4Vh8XDctmGWMZpQXizugWJYPfvclU7skzO1H2MeFIwT3P
         yIUMpKWgYoBRsB8cRJhKyrNfAjF75uioGX4RI1pKi2HGnNI6hrHhl0azUP9ZGJXrHocG
         qcpJ/IVipJk25XEXT23EnUmxQy1qpCWqVl5uAiLZMcc+YT3qGLx+KCRIIdMZN9m74KX2
         phDG66hcQsmVUvwHRBaHpGvGaT+uj7Kxktlg+SxozjXGs3N9xcoDpuZYbc6R6OH7NKXB
         CtTg==
X-Gm-Message-State: AOAM533ByT/5xhsui44HsuKearkEnd1GVyp5SLd01Us4G8L1h/T909fO
        m4XW6FKA86whKeicaTspnh0=
X-Google-Smtp-Source: ABdhPJz0E7uE2AhnfZ77YUzT9U7VF0+/WSHGyOrxo4AkCbvkEb75vLZCRMN/90HUJILoMW9OIvSx6g==
X-Received: by 2002:a63:eb10:: with SMTP id t16mr12759586pgh.210.1607331671885;
        Mon, 07 Dec 2020 01:01:11 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:11 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 13/19] crypto: picoxcell: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:25 +0530
Message-Id: <20201207085931.661267-14-allen.lkml@gmail.com>
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

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/picoxcell_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index fb34bf92861d..e96fd1caba14 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1136,9 +1136,9 @@ static int spacc_req_submit(struct spacc_req *req)
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
@@ -1648,8 +1648,7 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
+	tasklet_setup(&engine->complete, spacc_spacc_complete);
 
 	ret = devm_add_action(&pdev->dev, spacc_tasklet_kill,
 			      &engine->complete);
-- 
2.25.1

