Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B52AC31E5E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747EA20673
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 06:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MU8UR8hf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFRG65 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 02:58:57 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35905 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfFRG65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 02:58:57 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so20050314edq.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 23:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x33f+0NIrmIewXwhkH22a/5YnyzCPmNiHgFDHQGNfMw=;
        b=MU8UR8hfQMRY5DR+ktKI+wekwVUUepLsmN1Qa0HiSfZLCpcxoHVERkgFwo4ZxAKI1y
         dB58pBqT2JvCxYloddoS6/rSaRd1a61QIc4M3PN/PpFQUWEOcTbbuCGH/WAZoLKuTVM5
         lWaZaHmcccQ4mGZnHpVYt1STGttQa2JUaSnifmghRDBPpEl/fbTGJlRQPu13vDudLIYx
         WIPfCMP535eMfL2q9PHS4ySZnE/E5Xnpepq2c3g9FgL6sPTVXyNzm4wpw7Gs9MKEzkWa
         QYLXT30GY6oWj+Zp0PpSA/aP8BVNSLXKuRpoaG2eV6IazHbAYF4jx92Kc/C9zc9carDe
         xkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x33f+0NIrmIewXwhkH22a/5YnyzCPmNiHgFDHQGNfMw=;
        b=OalsJMHkBw5qK22wnOmAmAV4wXIOaQBh3tAlXEEpduLzeQbD9n7CzR7FyN/PpxlNwR
         NFHZoYX19/CeKJI1sI49HWm+C6w+AKQV/tFY9MQSp6CuJInuvv3uEIyCM8552syDFhwx
         zlo2XV6GGHDti3kaZbxzMNqv+5eJwdddcC4xpTiDdts9CFr+7mP8JSByujZ924djo1Nq
         4MUHJQfSjn0w98aHMTnwpHgTwEyJK6Y7CdMmwfKGjtzGmjKQ/m4Ryem4L8EXllXDzvsv
         77KFuLry7jmO6LrLvaFKsZ++81IQ53FGcwMM0YSZOJUwiytC8pPGqPOJH3H8OQvQERre
         Ws1g==
X-Gm-Message-State: APjAAAUs4W4QZcpeHTlcP523hobJkAEsp5UAo+G/Xoxo3yqY2w7yMpi9
        AFkNTIOnNkg8A/EagbX5CFr4ghFJ
X-Google-Smtp-Source: APXvYqx+fvoGV5hn2QuDLorzXAUPG2fUHlhq/uq+M1Fx8xkfz8eTpaVMyrKbNY1JkPsw9rtsy8JvPg==
X-Received: by 2002:a17:906:2347:: with SMTP id m7mr39663872eja.275.1560841136102;
        Mon, 17 Jun 2019 23:58:56 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id q2sm2602291ejk.46.2019.06.17.23.58.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 23:58:55 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: [PATCH 1/3] crypto: inside-secure - make driver selectable for non-Marvell hardware
Date:   Tue, 18 Jun 2019 07:56:22 +0200
Message-Id: <1560837384-29814-2-git-send-email-pvanleeuwen@insidesecure.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
References: <1560837384-29814-1-git-send-email-pvanleeuwen@insidesecure.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While being a generic EIP97/EIP197 driver, the driver was only selectable
for Marvell Armada hardware. This fix makes the driver selectable for any
Device Tree supporting kernel configuration, allowing it to be used for
other compatible hardware by just adding the correct device tree entry.

It also allows the driver to be selected for PCI(E) supporting kernel con-
figurations, to be able to use it with PCIE based FPGA development boards
for pre-silicon driver development by both Inside Secure and its IP custo-
mers.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
---
 drivers/crypto/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 67af688..0d9f67d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -716,8 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF
-	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
+	depends on OF || PCI || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
@@ -729,10 +728,11 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	help
-	  This driver interfaces with the SafeXcel EIP-197 cryptographic engine
-	  designed by Inside Secure. Select this if you want to use CBC/ECB
-	  chain mode, AES cipher mode and SHA1/SHA224/SHA256/SHA512 hash
-	  algorithms.
+	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
+	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
+	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
+	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
+	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.
 
 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
-- 
1.8.3.1

