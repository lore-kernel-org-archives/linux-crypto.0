Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF0313276
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352655; cv=none; b=pldFKCS+dBV7uyh+IN3zqfRA3UOCJduFB/9K4Ig6IB0DX2JcjJiMH4sok0fvJgtUbHXQ0/8cc3FesurVhbeDbfHxTdSotvYUQ35tfq+kHQMmmWW16WlCc14iyg8lV2kPBLb+ponfIVEMSyp8+1nsOdsHnjY51fftfRXw1HDI8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352655; c=relaxed/simple;
	bh=jNAe/V4zNi6LpOPWatt40NoZhMnHLRvmHGAaaO4Ly1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ioOEKeFWUX+vSeuCiMj0LMdqWHl6mmGU0AsKMUHLMv5BhqCQMSf8tTxbhqr18cuMxIUUeu9Z9QPjaFeyDJ4TQ9Lqk0loFiC1qGSmq1ixAEkUbVSKo7PpU4VIpk1uEynsMz1rcg5RA/j8t2T5LLBaDwRRF8WDEYomPzUavdvoI8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KP/r1dsr; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KP/r1dsr"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so1295745e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352651; x=1759957451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NhER74UBpIhoIb7wn4zkF28t+zv1ftYCaNbghO5GaF0=;
        b=KP/r1dsryPzrDFOHsD3a8VegYS59PvdVwxOHHDFaHBi+Xe5isVSAHmWemHxR5ph1db
         F3dBd6fiNpqOL42WlD7XUqT0iUe6jnE2MHoZaILPK921Ql1nH20yhnJEXQ83MSVpy0tS
         pqIk9MrlnPswG/mgETtk1ke+j716WHlRh5ybBW1MIMuvAIsCcVczLTKZtDPlY8OcEKuk
         aeHSGbENAZCWz33JFlSI5eC+JSrk0Ippp4ryh1h4RRoM8ZPXeKol76ZArw6M5zjC2NCn
         AsJUxs0SYXgWmZWuAkOHiE9uSDaOPNLf32tkgYgTHW9aIobxuR7q3+ma5Np5yeR7XlU4
         q8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352651; x=1759957451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NhER74UBpIhoIb7wn4zkF28t+zv1ftYCaNbghO5GaF0=;
        b=qiuosXj2Jht2EKLz6nqwmyrAN5GNeXO3YnU/ubZueeMsxw1dR0ZVQfBFrbfNJN56Bt
         oWv5kvm+7+2XsmYl1fhUfpAYuzEf4QYj7EV9iAj4PASPQTWdH3GJBwLe5se3OqrHVoF2
         r7uFCM9G7zHIV/Bwd5G7mX0C6cPKpzRWlg+qrG3YLDN0d+dlI0XW6Bkcp8MSBijBE4WC
         NhkJPisGp+EDE9dJZcXKVGYrWbgFw4Y6qQnpcxRfk6daedSCp8ujOZPaY37jnNcLNlYO
         ceeY1huu5YbQPqxaBSBLYzAohOZQeYrmSZRirPE0kfcvrhggwbQFNiW7RLZMgg2l8KgN
         xiEA==
X-Gm-Message-State: AOJu0YxT5et6/Ssk5Ts5snnx6PJRqdj2Ulzp1rxQ6lmImaKIbj0m/O2g
	BiJ2aGidNXBzCyjUkjspgpxmieoo6xRhfJ9cmjo7jIawZ3kiXPScVg8l8maE7KEmly5LyB3XIQ=
	=
X-Google-Smtp-Source: AGHT+IHOlHJXU9hXA0ZmAXl6mlRNCJKkb1Gcp+5ssLGIRuoPhjvb1Emmd8X4cPDWubbLQ9YjO7PB9gsQ
X-Received: from wmcq27.prod.google.com ([2002:a05:600c:c11b:b0:46e:1f26:9212])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6692:b0:46e:502c:8d6a
 with SMTP id 5b1f17b1804b1-46e64641e65mr29454385e9.25.1759352651235; Wed, 01
 Oct 2025 14:04:11 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:19 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2860; i=ardb@kernel.org;
 h=from:subject; bh=nxbcY1qMUcCM5Jp3a99oXHHwAeI3LF7dd8KEKxZdHZ4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePudKH2XdeuGB133c2V2KjV5uU9u09ni9zLgvJw7qCF0
 9Z8LXjSUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACaS0M7I8OxoakasXPVCVm6x
 mvWzfBYxuO7SO7rQoEMsbF7GoxkqCxj+cNsr7Pt+bLaWpqps/7OPbIU9G7oT7rhfTTy33L9yhcN 5XgA=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-39-ardb+git@google.com>
Subject: [PATCH v2 17/20] crypto/arm64: sm3 - Switch to 'ksimd' scoped guard API
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
 arch/arm64/crypto/sm3-ce-glue.c   | 15 ++++++++-------
 arch/arm64/crypto/sm3-neon-glue.c | 16 ++++++----------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
index eac6f5fa0abe..24c1fcfae072 100644
--- a/arch/arm64/crypto/sm3-ce-glue.c
+++ b/arch/arm64/crypto/sm3-ce-glue.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/neon.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
@@ -13,6 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include <asm/simd.h>
+
 MODULE_DESCRIPTION("SM3 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -25,18 +26,18 @@ static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
 {
 	int remain;
 
-	kernel_neon_begin();
-	remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
-	kernel_neon_end();
+	scoped_ksimd() {
+		remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
+	}
 	return remain;
 }
 
 static int sm3_ce_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	kernel_neon_begin();
-	sm3_base_do_finup(desc, data, len, sm3_ce_transform);
-	kernel_neon_end();
+	scoped_ksimd() {
+		sm3_base_do_finup(desc, data, len, sm3_ce_transform);
+	}
 	return sm3_base_finish(desc, out);
 }
 
diff --git a/arch/arm64/crypto/sm3-neon-glue.c b/arch/arm64/crypto/sm3-neon-glue.c
index 6c4611a503a3..15f30cc24f32 100644
--- a/arch/arm64/crypto/sm3-neon-glue.c
+++ b/arch/arm64/crypto/sm3-neon-glue.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2022 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
@@ -20,20 +20,16 @@ asmlinkage void sm3_neon_transform(struct sm3_state *sst, u8 const *src,
 static int sm3_neon_update(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
-	int remain;
-
-	kernel_neon_begin();
-	remain = sm3_base_do_update_blocks(desc, data, len, sm3_neon_transform);
-	kernel_neon_end();
-	return remain;
+	scoped_ksimd()
+		return sm3_base_do_update_blocks(desc, data, len,
+						 sm3_neon_transform);
 }
 
 static int sm3_neon_finup(struct shash_desc *desc, const u8 *data,
 			  unsigned int len, u8 *out)
 {
-	kernel_neon_begin();
-	sm3_base_do_finup(desc, data, len, sm3_neon_transform);
-	kernel_neon_end();
+	scoped_ksimd()
+		sm3_base_do_finup(desc, data, len, sm3_neon_transform);
 	return sm3_base_finish(desc, out);
 }
 
-- 
2.51.0.618.g983fd99d29-goog

