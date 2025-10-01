Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A04311C20
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352650; cv=none; b=PNMH2iqSKMc6QgFk5yElwroxLaG1rTpmI6lheg56WQoWAb2UHLPMqEqRqbhASuckjsy4fOSvuXM+3ScvGsrTkGDamOMGJmYIXAsUaXmE7sSp5xdHAe5pN5GqTEQB/fllzTQXf9MoHY0oPPwZYf5ZEapFGe4+MS/y+2t5wt3xFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352650; c=relaxed/simple;
	bh=/ZA4JA9wV0R82IktuAfOLSwLAhmDtcCLaF/KC91msqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vFDMeaD1W6glrd6CX4WzFEkjghbY22E3SmvxNuYTRXsLkqwyqmqvGil6TgMpTKK4H1fBRxRHfJwqivRyM7VY5YQJZCD77az5PgrTMSyBvppj+fMAqupOdrVwuCr3o2JPhfPfbA4B9H666iMyWG25L3XHFDccMSOQp5vsqJCxrK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B1wQqj5/; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B1wQqj5/"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so111296f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352646; x=1759957446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CeDKPAQMPbh0EqMW8jQOA9NzBOuPEFyE2AHCW54BErk=;
        b=B1wQqj5/UTdR+oD0PLp67YlrZ5w8PQQuxF1S4WzGFQxzQ+WEmJlteFaJFOV/Dyy+k6
         fkOCNcFEKxhf3nH1Im7WdWgtj7pFtrtaRGxAQSdgV+g8Sj26V1eyUDRpRzoIqt3HmbkB
         IaWpK+TxNTDCaSSv6Lxr6w5Tk320dcxHCX7SGmBc96gYljKg5admD/LUvOMG98qF3efW
         JK4qIMWP8Rb251oFKR5fHSewbsKn0KCpOSEaOt8IUdfbIFibkigbKC0HhpkdGJMHxxeT
         FVm1Jc/OO5vdfbsaSuEb8GqZcahuKC8LxqKN2i5VEfoYbq5JWPVXIa8xxHborHw/9nzw
         Ny1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352646; x=1759957446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CeDKPAQMPbh0EqMW8jQOA9NzBOuPEFyE2AHCW54BErk=;
        b=nOxb0SU5UsecwrFPsxu+HXntHVe39y2Zb51ScU6amjoMlsR9TuN38B7Lf2WT16X3tA
         +8jIIiC4FdhU9BvUeh9BaYqCub6KQwTufaCGkPFYT8cyn5nJ8yK9Mzu5VYuHlB7v8iLQ
         ZHTOHKg+x+sGa4R/DDaaKeKtRmt3vAcis1U3mLdHiaLCWIj/MuYHMCdnxzZBGJRlMdID
         27t8I9iO2kPz3Dlj3T0pdvsOlWKpKyZ1L04YGazIcHAVG77Ddb7TG7XI8VBCS23aFx43
         tBfnTGfiedCNocNvGiVjEmaFkZ7uSjq9gLBb2mKlX5z0gBQiS4p3Ip9d1/zphCzlnN59
         QADA==
X-Gm-Message-State: AOJu0Yx2Ev1mAdUlTI7YI+7nyTzWjLhyYmYU5i2ChJeILnQc6oDIkubN
	erZIIHqe9bP60HJa2S/Q+BPh4EKseENV2R3I2JxxaGwe80wgIfRD20fc1Og6BKTxrPUb5cxLMg=
	=
X-Google-Smtp-Source: AGHT+IFzputzbAebEFyEfc/jsFLhZ5Ij21AZlBRWh2WXnyRCr1Ir7HRHLQr/BaUei+1rcPYe79TOPRsG
X-Received: from wmbh26.prod.google.com ([2002:a05:600c:a11a:b0:45d:cfa4:ce0d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2408:b0:3f0:2ab8:710f
 with SMTP id ffacd0b85a97d-425577ed732mr2808941f8f.8.1759352646016; Wed, 01
 Oct 2025 14:04:06 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:15 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2238; i=ardb@kernel.org;
 h=from:subject; bh=6vnaDpO87kSFyERwmfNjHVSsNUwe+WjtwCLCIOuhD2k=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePudMabfzoiq30TZq93WPL622O99VO1Yg0XZ+6/KH3hp
 c5lmzjbjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARP1+G/wWmxxe9Ef5yUDnC
 4UG55DG/L0npufYTWHPy3JZ7+Hvvf8TwT62otuLghCfsBRG+pqa91dvetu9/w7vik47Kx3/8xvz pjAA=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-35-ardb+git@google.com>
Subject: [PATCH v2 13/20] crypto/arm64: aes-gcm - Switch to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 27 ++++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 4995b6e22335..7951557a285a 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/neon.h>
 #include <crypto/aes.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
@@ -22,6 +21,8 @@
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
+#include <asm/simd.h>
+
 MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -74,9 +75,8 @@ void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
 					      u64 const h[][2],
 					      const char *head))
 {
-	kernel_neon_begin();
-	simd_update(blocks, dg, src, key->h, head);
-	kernel_neon_end();
+	scoped_ksimd()
+		simd_update(blocks, dg, src, key->h, head);
 }
 
 /* avoid hogging the CPU for too long */
@@ -329,11 +329,10 @@ static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 			tag = NULL;
 		}
 
-		kernel_neon_begin();
-		pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
-				  dg, iv, ctx->aes_key.key_enc, nrounds,
-				  tag);
-		kernel_neon_end();
+		scoped_ksimd()
+			pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
+					  dg, iv, ctx->aes_key.key_enc, nrounds,
+					  tag);
 
 		if (unlikely(!nbytes))
 			break;
@@ -399,11 +398,11 @@ static int gcm_decrypt(struct aead_request *req, char *iv, int assoclen)
 			tag = NULL;
 		}
 
-		kernel_neon_begin();
-		ret = pmull_gcm_decrypt(nbytes, dst, src, ctx->ghash_key.h,
-					dg, iv, ctx->aes_key.key_enc,
-					nrounds, tag, otag, authsize);
-		kernel_neon_end();
+		scoped_ksimd()
+			ret = pmull_gcm_decrypt(nbytes, dst, src,
+						ctx->ghash_key.h,
+						dg, iv, ctx->aes_key.key_enc,
+						nrounds, tag, otag, authsize);
 
 		if (unlikely(!nbytes))
 			break;
-- 
2.51.0.618.g983fd99d29-goog

