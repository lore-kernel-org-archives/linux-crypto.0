Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB5BC4CECE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFEA21907
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nqs7lsVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfIRW2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:28:54 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:33996 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfIRW2x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 18:28:53 -0400
Received: by mail-ed1-f52.google.com with SMTP id p10so1411535edq.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 15:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IUgYmBm7QSLjZcp/ttH674yUIp9XjHTvaFW5hPaSq4w=;
        b=Nqs7lsVsCHAQuYC/ZleA6yDXwaMiIH/gTJaA1KS0OLilGBDUmvtG5GUmV0SCgD5ssX
         cQQVo615t7AFQpj/0PxHRvqDExzkVWVZfVeAzUkHlHyDKg3wymiTES1b0KXLp9qhqXtN
         7u/9zUDb/MjvReuEdXrG4Jpza6Ny4HzxOQmRFuDqYVsp+vR3fQCVuhZEihuW+pJnWH4/
         IOyOz1YR1DzKbYsRRSGi11Hkqp+vmzLYKXhuuRtc1K3WFonpwmUrtsKEX9v7b0wzwkfo
         47dn0Kkbsx8UL14rHgzIPYP5PQCjp9q6e2LAb4sqNbEphIFh7XYe27efL5b3yZNxZHSW
         StPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IUgYmBm7QSLjZcp/ttH674yUIp9XjHTvaFW5hPaSq4w=;
        b=tOTv+0UO6tCBM86/foUv/Bq890MUGRiamGgukJceeUk9HBEwc+/gqhwYlFDVevT8KD
         RVezhA+/S6J3LQEpopuzA4SKsool99v/NL1Wwew2WKLPcW6aoFDqxlOBuB2/o/HICT7K
         GlnnOJ+yJrH9NekUp5g4q6JKPk/FsGnFz1tb40JYT1Tx/RoktjHK4By5CC0fNYWk+w8u
         aNyDkFijr5zh9OujKt6jt4N3xeHqA2I1fpB7DasKtGlTU2Pbp61hAE4oU4i75RR7BgGp
         8/uXGzitV52QoDLRaDJohTEQzODbQ7qZ8dMiGsUjClSbuRULbIQjw12J5ZisBlYfWcR1
         4LSQ==
X-Gm-Message-State: APjAAAUSZvQXFzUaRMIkltSGx6rfSmgj9KPIfLm1ot1t5yu9LqBWR9Sb
        nLP0QgTJVvNan/Zuk/NvASR1IJ9y
X-Google-Smtp-Source: APXvYqzLUPFyjpdB8oJHeMq+t3YsvEnLpasinJCZusHEuc9Bdw/erRhhIp1w2y3eOnZJKQyL5aGsDg==
X-Received: by 2002:a50:a939:: with SMTP id l54mr12837904edc.214.1568845732037;
        Wed, 18 Sep 2019 15:28:52 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a3sm811951eje.90.2019.09.18.15.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 15:28:51 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 3/3] crypto: Kconfig - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL
Date:   Wed, 18 Sep 2019 23:25:58 +0200
Message-Id: <1568841958-14622-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Due to the addition of Chacha20-Poly1305 support to the inside-secure
driver, it now depends on CRYPTO_CHACHA20POLY1305. Added reference.

changes since v1:
- added missing dependency to crypto/Kconfig

changes since v2:
- nothing

changes since v3:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 83271d9..2ed1a2b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -19,7 +19,7 @@ config CRYPTO_DEV_PADLOCK
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
 	  that provides instructions for very fast cryptographic
 	  operations with supported algorithms.
-
+
 	  The instructions are used only when the CPU supports them.
 	  Otherwise software encryption is used.

@@ -728,6 +728,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_CHACHA20POLY1305
 	help
 	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
 	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
--
1.8.3.1
