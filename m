Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23498C4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDEF620663
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrcNObS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgCSQNM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:13:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34394 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgCSQNL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:13:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so1531488pgn.1;
        Thu, 19 Mar 2020 09:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rqGhDfe/l3VrM3s9b0bpdG7gXHo9u6mXfCQLIUi04fc=;
        b=DrcNObS3h0a19UBO/Bk1ikFhx7Dv3h9vWztSpmnOZN/O3xQWtIJoFwvZ4WbxzZ+pFx
         8sODoDvo1dIvuS0Rqqe0ca3BBLXbdrw5ZBX8XQofn/BGHIDBrITtsNSJ/N2Wp430FdYw
         HQ5j2ShSiRNswdlouMwx9Op1wj0RgUT9Mq+3gKOh3RL1Lz5YuV/epWbWFuY8qUdSRQVP
         3c/VOJxeEgVNM64gLlSiE3GQ0eO6V7d6oeRikoUYAL6TfkAr25bSjp+sIO6rIn8Zj9b4
         IrNt/ucSV0f9BgVF1R3fgQ5vQxR2B9v3hIi1UxXnZZ8wt7yUtGMgruEvzDGbYhiUIbMK
         PKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqGhDfe/l3VrM3s9b0bpdG7gXHo9u6mXfCQLIUi04fc=;
        b=XWT5nWVyK90xhOw7RiXyFjCKfTOX5p91CrYeQFdi8YI4BfLg+sPZ1eHsXF7d+9tM7n
         T2MUoPvpyBrROXYwdg9XHpLrzk3gWHEBrBReLpqdbl4GNo3Whd8hjSpEZg/2UZhfSqVX
         yqZHRI6dS3scNsqQP5/hwwPJ3BqZVFu111MKLuDLznOA55jtNHx2f2F6nobPOsBTkLvx
         yBpysV4yQDNoL9hWT2UFui8Rvc8YP0hFleZCXo3fXM9tROsgqWd5SPPjuzWDLE3Oym3v
         SvZPL2jYQEVwVIlE1cQpFKX2EEj413H6vfig8YtqZNXAj9zzS1Cm52T40whs/J7u1Hix
         AF2A==
X-Gm-Message-State: ANhLgQ1QXYBKnDg0RcfnpSrRiLHcqU2jue5hEvhFC++fnfJSBrqgPeHo
        w17AJTujLu1ht97JpibRNbKZKTtd
X-Google-Smtp-Source: ADFU+vs9RaTqIxpnTGtHvbkTOm5DPCfnXe1NVnZlOwDsjQFhfpB1jVnTisyuxGjygQettlYTFkd40w==
X-Received: by 2002:a65:53c5:: with SMTP id z5mr4339151pgr.0.1584634389164;
        Thu, 19 Mar 2020 09:13:09 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:13:08 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 7/9] bus: fsl-mc: add api to retrieve mc version
Date:   Thu, 19 Mar 2020 09:12:31 -0700
Message-Id: <20200319161233.8134-8-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andrei Botila <andrei.botila@nxp.com>

Add a new api that returns Management Complex firmware version
and make the required structure public. The api's first user will be
the caam driver for setting prediction resistance bits.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
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
 drivers/bus/fsl-mc/fsl-mc-bus.c | 33 +++++++++++++++++----------------
 include/linux/fsl/mc.h          | 16 ++++++++++++++++
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index c78d10ea641f..40526da5c6a6 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -26,6 +26,8 @@
  */
 #define FSL_MC_DEFAULT_DMA_MASK	(~0ULL)

+static struct fsl_mc_version mc_version;
+
 /**
  * struct fsl_mc - Private data of a "fsl,qoriq-mc" platform device
  * @root_mc_bus_dev: fsl-mc device representing the root DPRC
@@ -54,20 +56,6 @@ struct fsl_mc_addr_translation_range {
 	phys_addr_t start_phys_addr;
 };

-/**
- * struct mc_version
- * @major: Major version number: incremented on API compatibility changes
- * @minor: Minor version number: incremented on API additions (that are
- *		backward compatible); reset when major version is incremented
- * @revision: Internal revision number: incremented on implementation changes
- *		and/or bug fixes that have no impact on API
- */
-struct mc_version {
-	u32 major;
-	u32 minor;
-	u32 revision;
-};
-
 /**
  * fsl_mc_bus_match - device to driver matching callback
  * @dev: the fsl-mc device to match against
@@ -338,7 +326,7 @@ EXPORT_SYMBOL_GPL(fsl_mc_driver_unregister);
  */
 static int mc_get_version(struct fsl_mc_io *mc_io,
 			  u32 cmd_flags,
-			  struct mc_version *mc_ver_info)
+			  struct fsl_mc_version *mc_ver_info)
 {
 	struct fsl_mc_command cmd = { 0 };
 	struct dpmng_rsp_get_version *rsp_params;
@@ -363,6 +351,20 @@ static int mc_get_version(struct fsl_mc_io *mc_io,
 	return 0;
 }

+/**
+ * fsl_mc_get_version - function to retrieve the MC f/w version information
+ *
+ * Return:	mc version when called after fsl-mc-bus probe; NULL otherwise.
+ */
+struct fsl_mc_version *fsl_mc_get_version(void)
+{
+	if (mc_version.major)
+		return &mc_version;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_get_version);
+
 /**
  * fsl_mc_get_root_dprc - function to traverse to the root dprc
  */
@@ -862,7 +864,6 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	int container_id;
 	phys_addr_t mc_portal_phys_addr;
 	u32 mc_portal_size;
-	struct mc_version mc_version;
 	struct resource res;

 	mc = devm_kzalloc(&pdev->dev, sizeof(*mc), GFP_KERNEL);
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 54d9436600c7..2b5f8366dbe1 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -381,6 +381,22 @@ int __must_check __fsl_mc_driver_register(struct fsl_mc_driver *fsl_mc_driver,

 void fsl_mc_driver_unregister(struct fsl_mc_driver *driver);

+/**
+ * struct fsl_mc_version
+ * @major: Major version number: incremented on API compatibility changes
+ * @minor: Minor version number: incremented on API additions (that are
+ *		backward compatible); reset when major version is incremented
+ * @revision: Internal revision number: incremented on implementation changes
+ *		and/or bug fixes that have no impact on API
+ */
+struct fsl_mc_version {
+	u32 major;
+	u32 minor;
+	u32 revision;
+};
+
+struct fsl_mc_version *fsl_mc_get_version(void);
+
 int __must_check fsl_mc_portal_allocate(struct fsl_mc_device *mc_dev,
 					u16 mc_io_flags,
 					struct fsl_mc_io **new_mc_io);
--
2.21.0
