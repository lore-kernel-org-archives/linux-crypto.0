Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A90C43140
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEE620838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hj8TVwX/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404318AbfIFPem (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:42 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40269 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392617AbfIFPem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:42 -0400
Received: by mail-ed1-f66.google.com with SMTP id v38so6675452edm.7
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BgOB06D1dj70xp8eWK+DKGL4PolIIHBFUxUYdIq7L9g=;
        b=hj8TVwX/LR6tbtdcW9chdJIkwaxJPoKP5NfjJaS8vwkz76ieefGAgCIgEMtm4xM4Po
         PYnArFUZmxABom7AEfeiwr0BQxGPRAcAU/vtpYjLaxDrk4xan3Uae2gvWsqaxQvJLWZD
         oTjIdOnU6ey+rTEy2fqHQLyBWxR/3zgIsyX9j/+VTN/MeZJrVH2tb4lU8Nf4QcG4O5oA
         Z6N1zBtVWz9ZlkNujHBgpng3dLYJUgBuY46BWC0sk/VxCvkVX4nHW+0QR4LIzQDKSBk9
         br8h0oUemq8gvTbQYRFPPwKm0qe/BgPBtZnEM+w4h2klaRJwZYreHHfGi4XVJf2Qaoav
         fOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BgOB06D1dj70xp8eWK+DKGL4PolIIHBFUxUYdIq7L9g=;
        b=dMsesWZESCx9EeYP3nsRd8i6QgRbqvvZjujdyBj0clXkJovS+doriQYvmOCobFxPMZ
         9AWoUFv7SzPqoXud4nY9O6YA6rmUEGgqTOhZDK6gHsDeAiCkOJsrocGMG+z7iP1UydW0
         ghqNn7y7lDoFbYHuvCiTjAO/AckSr5vTnFp21b6QB/LmFlQX/apdCZZpOR7Wc3I9wq5n
         0tb/F+FmcrcjvD+VSbNc/REeqC5pysOGlLvdCEB3+te9fev+XAMlAZ+0cFH5YGy7mIuQ
         i+9TJhah31ZJxFExlnHKByWgYRgL1M8CCGpBmnFb1LwIS17n5L92lgOBCCjRpCej3vWL
         GLfw==
X-Gm-Message-State: APjAAAV0KI2VW/LXencsoQdBVi/Ni5hr8wQmBlXwL0NPY0aC3ahy0NVr
        ZlMB4cDeI186H4GI7okTaq5sjPhM
X-Google-Smtp-Source: APXvYqym9I9mnEvQM/9UfyAT/InRl95B+tztZatEI0JOO3OOQY/ajUwlPzDcknxzi9RDsOrACnQeCA==
X-Received: by 2002:a05:6402:a50:: with SMTP id bt16mr10493857edb.287.1567784080709;
        Fri, 06 Sep 2019 08:34:40 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/6] crypto: inside-secure: Corrected configuration of EIP96_TOKEN_CTRL
Date:   Fri,  6 Sep 2019 16:31:49 +0200
Message-Id: <1567780313-1579-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch corrects the configuration of the EIP197_PE_EIP96_TOKEN_CTRL
register. Previous value was wrong and potentially dangerous.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 drivers/crypto/inside-secure/safexcel.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 7a37c40..d699827 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -498,8 +498,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 
 		/* Token & context configuration */
 		val = EIP197_PE_EIP96_TOKEN_CTRL_CTX_UPDATES |
-		      EIP197_PE_EIP96_TOKEN_CTRL_REUSE_CTX |
-		      EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX;
+		      EIP197_PE_EIP96_TOKEN_CTRL_NO_TOKEN_WAIT |
+		      EIP197_PE_EIP96_TOKEN_CTRL_ENABLE_TIMEOUT;
 		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_TOKEN_CTRL(pe));
 
 		/* H/W capabilities selection: just enable everything */
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e4da706..10a96dc 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -296,8 +296,8 @@
 
 /* EIP197_PE_EIP96_TOKEN_CTRL */
 #define EIP197_PE_EIP96_TOKEN_CTRL_CTX_UPDATES		BIT(16)
-#define EIP197_PE_EIP96_TOKEN_CTRL_REUSE_CTX		BIT(19)
-#define EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX	BIT(20)
+#define EIP197_PE_EIP96_TOKEN_CTRL_NO_TOKEN_WAIT	BIT(17)
+#define EIP197_PE_EIP96_TOKEN_CTRL_ENABLE_TIMEOUT	BIT(22)
 
 /* EIP197_PE_EIP96_FUNCTION_EN */
 #define EIP197_FUNCTION_ALL			0xffffffff
-- 
1.8.3.1

