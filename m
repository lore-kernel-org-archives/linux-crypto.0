Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119D1C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD584206B8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVdfGLV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725209AbfGaQbs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:31:48 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38532 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfGaQbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:31:48 -0400
Received: by mail-ed1-f66.google.com with SMTP id r12so31460306edo.5
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tNOuvm1U7rjJYTQqqmSPb+y7j9vdX9oul5uO5z40swI=;
        b=KVdfGLV4Vq8n7VoZ4nbr1Qdo2T7BdmzaJ302gla7ROyq9PZEvmUqJDvJnBzUt0k1Dv
         0s7WPJRhGeVfFv2CB6FnRY8FtLWrMGDwlBIR/I3R6gc3e4coEv92WxjdVt++A6S/K/Qh
         SRaWpBm+mnuJ6tc77rUTFhy0TVBs/P60nirzioWr04olp+xOg8uEqUSyiC1PmS0FbE8s
         w+skU8fxTh0qbAKoKWUYUHPuPREB+wGHA24bo26jiUZb1LO111/A7PLQAmh/bDraMNzJ
         UUo6ajBsTl/tVYNNMHZnzEYu5nwcIJagFLwuUMgudpxZ2yYTKEQu8MNXWZRJd0mfywfd
         IC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tNOuvm1U7rjJYTQqqmSPb+y7j9vdX9oul5uO5z40swI=;
        b=lcJZFN2qwuBBIAJma2d6toeIMULvSf9TkGbxUE7Mkf4shv7v75rxSKtCVZvbGswoJz
         KR+8RNKguJwHtDzGh1jspoM1i0zIOiBhSBcRsLen0GbjF6XUhYRQlYR/ZcQ4Uien5SoA
         l7TnB6mW3nW8kGAXEpo5Mg/13K5APRUY7YNRnIjd+eS0IMoVmK6teJmMEwigRCxFuu9c
         3NsBogSGDihvBLUDLKka1L1jvPwEzzefTigi9SR2ibGqBPy7/8P0VnDXrM2arDhPExL9
         wYJu9w0Xqx5XuTdjDPebRXxF3XYLxzuPTvrqoknjO49mZHyfh7/pU8KG8ZVPjDACIQcI
         wdkA==
X-Gm-Message-State: APjAAAViYNJ8VwxAmaoPuSHi1rqB5LUVuSO9tH2NkApefLRU3vFMzlAp
        kaU+0CkCG0PcjnnFcFSpsTEsAZ7Y
X-Google-Smtp-Source: APXvYqy8NIuo09vnvrmIxCUmKRP/L1t3Dvzb7OtUF0n2hRf4gic/TkU0KPQeTfF4zt0GXNzgQsV0+Q==
X-Received: by 2002:a17:906:3419:: with SMTP id c25mr93546024ejb.305.1564590706007;
        Wed, 31 Jul 2019 09:31:46 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id u6sm6116892ejb.58.2019.07.31.09.31.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:31:45 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3 1/4] crypto: inside-secure - make driver selectable for non-Marvell hardware
Date:   Wed, 31 Jul 2019 17:29:16 +0200
Message-Id: <1564586959-9963-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
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
