Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9663AC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA67208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uesOFonJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409163AbfFLMs4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33312 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409157AbfFLMs4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so16819636wru.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=35aKMFTnfvApYT0bZnbnGPl1odG7lcC67cVgsN970Jc=;
        b=uesOFonJATVd0Dhi+ZGYHzoBuGkkmkYtb0S7HQv1Hz59/RBe4i5p43ZVuPUMbAGNHx
         9bpEHnn3XLn+RgRUFTon52E1BHildbm3m0MKNdS97AHqyTiqUkwWy1VHjpoZLou1P7AG
         r6I3q/xWtdUl+qLTdEO9jqMSgUoxL5QnSYzyV4l22NQ322Y1N09yiOP49WkSD8lVneJY
         0rvI97kyanKet4adT23Xdj9kb9nzLJnzZK2itXiUChvrbGQiNl/foh5tvhZ3f4RwPhug
         ADKDGvtOpFHPbKSrQCbUKE88bbtYeKZWOeLH/fN+NcVVMwnOC3lgFXo5Fq3XhuRYhMMG
         R8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=35aKMFTnfvApYT0bZnbnGPl1odG7lcC67cVgsN970Jc=;
        b=cDGHxiFEoxSvLyWHQUg/XPpm5gDSl3mtUzVmCPnnphlvWBcf+Mjh80DMUP/uBl9yVq
         8R8UFSruv4CoP6AYsg1eFAz+aS+2dogvfayTw7hiewXMnkPItqBKhLIqZu2jsSK1Z3P9
         sBHSA37k+vVCiUPZ3zIoUQ0c8+9Vi+mSQg1rDdMbYszYMRdQjWmTH0KCbqztq30E9RsH
         tVCTDOB6bbqtuj8TrH1GCu3X4en2MI7+sLwE2uqdOBVcM/0LSd4TA90cVvruXIkZRIl+
         cYfl8ymN3Ta/RxIMb7zPxtFctObDf4enHW2+iFOF2IflrDHrxkXRfMVABBPNLAYlZ1/L
         TcfQ==
X-Gm-Message-State: APjAAAUz0xJnydBh/kpIh/n5dPC71TUAzjLJ82UUwO5H1tq4+iGfj+3c
        vrhcT6jP/QVFg3epHLJ4jFMwSepBsPQxgQ==
X-Google-Smtp-Source: APXvYqz2LH34ke+zZvymZrS7jVoWGvw7k9Vc1McHT42Eze37IROOTN7xLWF6R7cSL45+2nzwGmuBkw==
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr7629850wrq.251.1560343734764;
        Wed, 12 Jun 2019 05:48:54 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 07/20] crypto: padlock/aes - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:25 +0200
Message-Id: <20190612124838.2492-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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
 drivers/crypto/Kconfig       | 2 +-
 drivers/crypto/padlock-aes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0af08081e305..b7557eb69409 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -27,7 +27,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	help
 	  Use VIA PadLock for AES algorithm.
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index ad020133da19..e73eab9bc22a 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -145,7 +145,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.encrypt.keygen = 1;
 	ctx->cword.decrypt.keygen = 1;
 
-	if (crypto_aes_expand_key(&gen_aes, in_key, key_len)) {
+	if (aes_expandkey(&gen_aes, in_key, key_len)) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
-- 
2.20.1

