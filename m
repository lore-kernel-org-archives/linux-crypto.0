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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A001C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D004F2335A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbhAGMcD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbhAGMcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:32:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BE8C0612F9;
        Thu,  7 Jan 2021 04:31:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j13so3595458pjz.3;
        Thu, 07 Jan 2021 04:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=V1vfZ4x5Wfxkd5zVPqFj8CmcX2UJQPnL4eVh0PHLtBP/O+bnLI8npKqfe0WWNSSjtp
         jVxjrpT9ITx0wMYv5LWSNWZS3ShZSAfyxkkqN24COtQArayItJ6AlxcqJCy+ovUEPBUm
         UuCmlzpkQ9XvyBl5Xmaf5dx1rxyduiiXh76svNgHpxKfPWF2l+KPWbirwAsIO6vB+NC9
         K7mzRzbHYU4rIdO8dK7KhWZE5raGjBY0ImjknQ0UlJsw1JelcWm+BkAaVDsd9YEK7A/d
         R9xWE7pg8dyRY6eSOAX9g3uHebqMlbowmSLLwePMyuXP/C8SOj69hIypk8SXS7IW/M1k
         g/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=YRdDd1g7YCMRosnWL7+nUOODwrnY9ol55K/vtVGTevA8oMZqCANWIfP4XuNYhIre63
         C7Vkq1ArlGI/1qexXNZAi8VkjhLwtO2Ohxo6aW+jJmX9scHQmyBmx+Xrk6jlIT/Kz9lZ
         LLSAkuaA8DsI5AP22ULJ117wVmRfLhHntQek1Dr+62bRvj3iOcePfsW8QqqGcOIEOAXp
         LR0EkzfawcjWfK3zBNiyC10qdNIsunOayKVX7i3Ha+d+8MRj8RvnbDEWp/vDLbCEzwDP
         0JTBqs/zkIcTlVXHNlzuzqBzW++XHbKzLTOTiDm3ytBdB9nyQzHBlJPTvVNTBEqHaat7
         Nrpg==
X-Gm-Message-State: AOAM533PLFlo1oW0QT8bBlx8B/mSqXlY19IAMY2DAYB/d8M8nzSxISbt
        MZAfkZNALW0KX73Fx6aqG/0=
X-Google-Smtp-Source: ABdhPJxoWvVixLhb4AqWe/Ovm28z3v0vAZuqSGnKpO54YLN6o9l6jNS4i24bVdxlg+M1aNnBhG8Cfg==
X-Received: by 2002:a17:90a:aa85:: with SMTP id l5mr8154475pjq.230.1610022682199;
        Thu, 07 Jan 2021 04:31:22 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:31:21 -0800 (PST)
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
Subject: [PATCH v2 13/19] crypto: picoxcell: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:38 +0530
Message-Id: <20210107122944.16363-10-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
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

