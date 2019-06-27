Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55979C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F66020828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rt2zKLIe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfF0K2F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53447 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfF0K2F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so5188438wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=rt2zKLIeJAWLh19X7pdXenP7Gy8ReHps31E4Hs4n1DWNIWrdM6ikJIrIhpu1fnqtST
         WIRomgcPzc8oMvVNT8QlR8oFTABtuwK07c2ccUgdb7CRV2hwdu7mvbKaiZwkDZO4oMyC
         Kti+5s1ewVvu9Hd1ACstAa5XllS7M3nI+ACteInFugod+Fzh7ffdUuFVMIZC4C/lcOe6
         MKGW/+sFGzzoKq3CSCnzfxQ/xDRsb8MwcevXYMiaYSNKqrHALo8AxzxsSsRBxnpZSIjS
         QiyWogHs8xCFLAddJnXjFlUxx6/Ht2wy0L8ZGDKBQUl9BScVG7Smp8kblsPZfxlQg7iy
         le8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=tzipoxJrrDrjWitgup/F1+udenxb8Yd1iNQ2PuOl9fpvpuBsLqiFKgjqHuBZ1jISch
         t8hojygHcPudPHM/Y6UOTbsEfAulVkgdjz8M19vwPdgUmxaPVC8S0kiQpt3TLYG6YMM6
         0gXypECLzxyM7lj+hKtP0khd91EpO+UpNoqJDy8dRqzDkwXQhxcKZebO+SYyDIVaqEiA
         vG3E0r5wacMOiEkL3ajb51I0IfqBPITS0jg8LX3FSPHI7xlGcKLKoLnDx6daf6Yug2LJ
         FV32v/ciTJitEjZ5wPamuZa15Q8ZUSd11e80uyNlh2q9m0w08mXXo/CcYiEmEaZZWSr8
         Cocw==
X-Gm-Message-State: APjAAAU4wzMyoanPyz2D2az9F1yugK2oKWhhO1Wyn2S3W6T1nbXxpUnu
        X5bVJ0BwPrU7vdh+pZKcfSAXDOPF9Cc=
X-Google-Smtp-Source: APXvYqwMiI96wzMB2HquB54+ukZlNtDSRXDaZU1aA1I1+eZ0l7nIishbxsrsGGGxXOx+cvZfG45wFg==
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr2783801wmm.96.1561631282832;
        Thu, 27 Jun 2019 03:28:02 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 11/32] crypto: arm/aes-neonbs - switch to library version of key expansion routine
Date:   Thu, 27 Jun 2019 12:26:26 +0200
Message-Id: <20190627102647.2992-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig           | 2 +-
 arch/arm/crypto/aes-neonbs-glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index a95322b59799..b24df84a1d7a 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -82,8 +82,8 @@ config CRYPTO_AES_ARM_BS
 	tristate "Bit sliced AES using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
-	select CRYPTO_AES
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 617c2c99ebfb..f43c9365b6a9 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -64,7 +64,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -123,7 +123,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
-- 
2.20.1

