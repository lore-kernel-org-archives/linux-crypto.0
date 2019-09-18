Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4850AC4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F52720640
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 07:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2lsnTae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfIRHpd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 03:45:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42324 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfIRHpd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 03:45:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id y91so5694835ede.9
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 00:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qsB5A5xVonZFJdPXFRsgXmkeGHfghb52saFIawfLe+Q=;
        b=d2lsnTaeFRieis98Adjtnt2kCZ5f8iTFK0bheiYviBflzUM1mHqWAok8duPOJ1n8Rk
         /rGq4Dwg2EoV70ZrH/4D4ph0hijrJGHqLVgdAxFCqjb3lBulrl/MRWnnzqitoF67tvZy
         00l0G6MWZz6Pxvu5vliFOJ6y7CTbbBPJLeokWSK0XmoXsiW73xTL2LLBlXuiCB0H5ZXY
         218j8xjvRlBCsO5XD/kCo0KP433LgOlx9Fv1X3KPLcI3l9+I4lq2OpQ3HfV+NspyN7Pc
         JyTdCGQ93GSy1V6D0A7bTFMQeOMIMKtmN6t9Z2FZQjVPchkrk1uU8AKU50u269/4fKsC
         MfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qsB5A5xVonZFJdPXFRsgXmkeGHfghb52saFIawfLe+Q=;
        b=TG4DjB4jipV2gGbUK13LEEs2/ImHQl2hBbRbzwfo0pefmg9REbrEBYQjEgmF8jPahF
         frWxjXdQFv6NV4wmXnHJEnMp5uOymtJQlkU1YFU3rB7BOcFwRM3IfTWM/RG2NNo1QeMc
         C0ObdhQK7u7vqW3rmXIyLgPstnU1aTX5Tfu6dH7b/puc1mKntHOVyTyCs2yQHWMi2YuJ
         u7d7V3NfrK3kieU/n111314jBqsoNpviylgvBpXSoNdJqnk32wnqxOTl6XNIQm/2wj40
         GgQPtvVfxwUjnJOeMWmkgXKuUdVd3M3jDY6VNCR6mQwOESJ/8MUlKxlIT+mle4xwizuh
         S8FQ==
X-Gm-Message-State: APjAAAU7kFVpK/0DqOW3QPhesAScU/voEcrNUJtkE1OewSoEU81iauTc
        0BPN1CLmgBOLRPReRBDB6BGQMJIt
X-Google-Smtp-Source: APXvYqx93Gje/MOd0UJGmVSR+D0GEfXNOldUwWsufqm1ackeu3xGYQJ0fVsF5+Lj0VykLF70H2qpwQ==
X-Received: by 2002:a50:e614:: with SMTP id y20mr8757721edm.276.1568792731094;
        Wed, 18 Sep 2019 00:45:31 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id hh11sm18332ejb.33.2019.09.18.00.45.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 00:45:30 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/2] crypto: inside-secure - Add support for HW with less ring AIC's than rings
Date:   Wed, 18 Sep 2019 08:42:40 +0200
Message-Id: <1568788960-7829-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568788960-7829-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568788960-7829-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current driver assumes one dedicated ring interrupt controller per
ring. However, some existing EIP(1)97 HW has less ring AIC's than rings.
This patch allows the driver to work with such HW by detecting how many
ring AIC's are present and restricting the number of rings it *uses* by
the number of ring AIC's present. This allows it to at least function.
(optimization for the future: add ring dispatch functionality in the
interrupt service routine such that multiple rings can be supported from
one ring AIC, allowing all rings to be used)

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 20 ++++++++++++++++----
 drivers/crypto/inside-secure/safexcel.h |  4 ++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 0bcf36c..c40eb1b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1308,6 +1308,9 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)
 
 	priv->config.pes = priv->hwconfig.hwnumpes;
 	priv->config.rings = min_t(u32, priv->hwconfig.hwnumrings, max_rings);
+	/* Cannot currently support more rings than we have ring AICs! */
+	priv->config.rings = min_t(u32, priv->config.rings,
+					priv->hwconfig.hwnumraic);
 
 	priv->config.cd_size = EIP197_CD64_FETCH_SIZE;
 	priv->config.cd_offset = (priv->config.cd_size + mask) & ~mask;
@@ -1481,6 +1484,15 @@ static int safexcel_probe_generic(void *pdev,
 					    EIP197_N_RINGS_MASK;
 	}
 
+	/* Scan for ring AIC's */
+	for (i = 0; i < EIP197_MAX_RING_AIC; i++) {
+		version = readl(EIP197_HIA_AIC_R(priv) +
+				EIP197_HIA_AIC_R_VERSION(i));
+		if (EIP197_REG_LO16(version) != EIP201_VERSION_LE)
+			break;
+	}
+	priv->hwconfig.hwnumraic = i;
+
 	/* Get supported algorithms from EIP96 transform engine */
 	priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
 				    EIP197_PE_EIP96_OPTIONS(0));
@@ -1488,10 +1500,10 @@ static int safexcel_probe_generic(void *pdev,
 	/* Print single info line describing what we just detected */
 	dev_info(priv->dev, "EIP%d:%x(%d,%d,%d,%d)-HIA:%x(%d,%d,%d),PE:%x,alg:%08x\n",
 		 peid, priv->hwconfig.hwver, hwctg, priv->hwconfig.hwnumpes,
-		 priv->hwconfig.hwnumrings, priv->hwconfig.hiaver,
-		 priv->hwconfig.hwdataw, priv->hwconfig.hwcfsize,
-		 priv->hwconfig.hwrfsize, priv->hwconfig.pever,
-		 priv->hwconfig.algo_flags);
+		 priv->hwconfig.hwnumrings, priv->hwconfig.hwnumraic,
+		 priv->hwconfig.hiaver, priv->hwconfig.hwdataw,
+		 priv->hwconfig.hwcfsize, priv->hwconfig.hwrfsize,
+		 priv->hwconfig.pever, priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 73d790a..25dfd8a 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -19,6 +19,7 @@
 #define EIP97_VERSION_LE			0x9e61
 #define EIP197_VERSION_LE			0x3ac5
 #define EIP96_VERSION_LE			0x9f60
+#define EIP201_VERSION_LE			0x36c9
 #define EIP197_REG_LO16(reg)			(reg & 0xffff)
 #define EIP197_REG_HI16(reg)			((reg >> 16) & 0xffff)
 #define EIP197_VERSION_MASK(reg)		((reg >> 16) & 0xfff)
@@ -32,6 +33,7 @@
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_DEPTH			2
 #define EIP197_MAX_BATCH_SZ			64
+#define EIP197_MAX_RING_AIC			14
 
 #define EIP197_GFP_FLAGS(base)	((base).flags & CRYPTO_TFM_REQ_MAY_SLEEP ? \
 				 GFP_KERNEL : GFP_ATOMIC)
@@ -138,6 +140,7 @@
 #define EIP197_HIA_AIC_R_ENABLED_STAT(r)	(0xe010 - EIP197_HIA_AIC_R_OFF(r))
 #define EIP197_HIA_AIC_R_ACK(r)			(0xe010 - EIP197_HIA_AIC_R_OFF(r))
 #define EIP197_HIA_AIC_R_ENABLE_CLR(r)		(0xe014 - EIP197_HIA_AIC_R_OFF(r))
+#define EIP197_HIA_AIC_R_VERSION(r)		(0xe01c - EIP197_HIA_AIC_R_OFF(r))
 #define EIP197_HIA_AIC_G_ENABLE_CTRL		0xf808
 #define EIP197_HIA_AIC_G_ENABLED_STAT		0xf810
 #define EIP197_HIA_AIC_G_ACK			0xf810
@@ -740,6 +743,7 @@ struct safexcel_hwconfig {
 	int hwrfsize;
 	int hwnumpes;
 	int hwnumrings;
+	int hwnumraic;
 };
 
 struct safexcel_crypto_priv {
-- 
1.8.3.1

