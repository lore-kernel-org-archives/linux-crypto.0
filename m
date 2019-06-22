Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A4AC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6C620657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="se4WvrAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFVTey (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34664 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFVTex (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so11348958wmd.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=se4WvrAkQddJuEKOWJWEobWEFH4GFHDCCINWdq/2PGUoMXh7mI+J7ZhN6Z1xR/MSC6
         lIzGId01l5ijUmJkVoaymPFWv/NkcA2M8GuDraBWeZP3Laz0m9VHtrhLSwklTQ9whIve
         71KGUDOgD41lfRpd/0LrfPgZgvBSrr3TLJmdg3NpJs6vKdhjBU/6JVSvId7ofZnIzzOQ
         he7Jas4GTIrKORP5DBcfd4oW2LO788MKI2UkHkavRJMiFCsuSFLlXSqnAiICfkKweOci
         LrVeefvVndHELfMu4XnzPfcMPp135V20aTAWwjjGm5crcl4MVme6kH6eR2OzLytGD+w7
         STSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXrlKaueW49CmOlW9q/RYTZvkffZ+6o0SuGgZq9akzA=;
        b=mXwkWJ3hXQ5GbsXjHL9JdJ0K0LIK4XvjZYxVTk5DpjiFbT3sHpwshfIqk/3+UGYShg
         zdxbpfNFT25a1wsYC8AN8tNRjz0STSf89lYBLi6tiPChIOw1wXjvtGAYaufXDxIZW4hE
         zxHmnig8msmbFfvT2jKKKxBlxQVY3zapiFaAYKYpW0Me24SEZlK64u2+oUJ3qi3mPJff
         BxZB6qfrGq489UlteyvZx6SLa5KgVub0f+6nrKLsTbyU8xA3flvUHWBp8THwbK+ys09+
         V1BaEbyXC07QX4NpGl83bxQpNCSg8am200VZ487R48m3Zk45as+n7G/PmwHy44nJ/PL6
         YrcA==
X-Gm-Message-State: APjAAAUzxCTHIC39W/npTfZeWblUzfklPhs9Kjx3dlpjKJAbOVrR1FTu
        6bCj8w92mfCtvNFrfJxfi3UOkwfm/xfJU/oL
X-Google-Smtp-Source: APXvYqzL4W5EyXnfv7ukYX0pZjoNnuyRpMV9+Os7hoquP1twzLf5j9TysZUntT2R1qh4c1fFqFC7Dw==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr9077532wmk.40.1561232091975;
        Sat, 22 Jun 2019 12:34:51 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 11/26] crypto: arm/aes-neonbs - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:12 +0200
Message-Id: <20190622193427.20336-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

