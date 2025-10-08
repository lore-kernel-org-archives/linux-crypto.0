Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDC42FBE16
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938426; cv=none; b=TdffhSlzfH9awCM7JYnqStFUquNOT484GYkVlrcxNMd5kPDalZkmqMmqqhxq15dKgphIcHo41RAUm3nmgOUBdHNhlCBDxWW1CLgzGUP2Thdw406CwkFKXNsWMNxL6sxa14Gz7DPGkC790FyT2xrwQM9F2NkQUqofS+kuw/1teS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938426; c=relaxed/simple;
	bh=2Y4ovck1VNEDJT/eJTVGRHTacMKXujIutu/8KsCMop0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UosO5XJ3tDBdXwNKDFEY2zSj3Exdh5aNEOJCvKlWrUKZcWjprgAofVsR6pVVzN1aIrtfBaF+jYHXre4HdiR+4KaWoNUmsj9xv2+csVrTN60mt2/k8HgiHALnEWHw/3MpuCXfazNT9kIsPMA1/dtiYriCQKDZmQs/O40IsD/vofY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxg5SCVK; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxg5SCVK"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e3d9bf9e1so34615925e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938423; x=1760543223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rx/I2mYB3NrCk/vXv2cfgvi3kC2D2Tey/+p9VMElDFg=;
        b=pxg5SCVKNNqh8TDdVWkQPvvXN7OooA1Js2WevrLevaGOPsFFxAPViEhZXfzNiP7CKp
         fK1MNg5VRRQWQ1fvsr8rP/rWPPq3M1tiBCnDVhOXScIgJm+mjPV8ZbhKwVGGUIsSHp/q
         L8hEzUVODdv4b+r0DLhpI6EKiuCD4tEGSW44De/bOo5/i9eOBGUOXEi37sKng8WnkIDN
         jwwwkqPsRt6Mv/JS4sOLvk18bxdAdpjebwLk9P7iRgw0/OZpUtQ0zcdrefLjT0t91SZV
         eFr0QcS+PuEmyP5xcIKbSQD5wKb57yiZ8wsLWEvFaFy8BsmIZPfI1B4c9gxfz98ejxV+
         +L/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938423; x=1760543223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx/I2mYB3NrCk/vXv2cfgvi3kC2D2Tey/+p9VMElDFg=;
        b=H/TUc2VN7uYEbtG7hd7XndSt3d+Z6VfhjV8PKl/QQGvYWGVsWIlvawMNSayDxfoFKD
         AVo3JGHQ5HA91hbgBlSyhqRY4HTn8n2GFHd435/1lwZ7vRJE2aaKjnsGPT76P8d8b4T/
         LMrdbCR5jxqLELThizdRcoUa0H70GZ4lIS+rON21Yr0UuMgLmBxjIVqgm3qkkT0ZlPuH
         Wlf1102hB8EDSXRhpIl8f7lndmzUv1btkKjQZNNlzirLSzmFxCL3vOgNfs7ezPzMwosZ
         9oe4cLl/T6Guz0iZ5jtK+AY35Vy0nsjCwtLidBM1wnyfBBRTM4648l+qRb1/FA9VTXPi
         ojEA==
X-Forwarded-Encrypted: i=1; AJvYcCVe1efusZzeZiS7AnS+zZWwfAmyf4lHyWPyMkw6UzIkV+G52c0l6LQylfgVHiFFStgUbnTiohlwdluyzls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3XLCA0w+AG0evvtYNDFJZiFyY47FLyzv8GtdLHkhsKv3Jq9kt
	zFn0CqnytaZ13OCorW1rA4TJKBDdzwPG4bN/KN9d4E+Gqa0z0hmAPpSlmE7pGGqLqdgVGXnu3w=
	=
X-Google-Smtp-Source: AGHT+IGgGXd0YwsnNbBmOjS8U85+nouh42Fv0MQo/IxganC0g4CIjlugauCG5GDY/nU4c6gjRWBTho+b
X-Received: from wmvy7.prod.google.com ([2002:a05:600d:4307:b0:46f:aa50:d706])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5028:b0:46e:428a:b4c7
 with SMTP id 5b1f17b1804b1-46fa9af2ff1mr27394355e9.23.1759938422874; Wed, 08
 Oct 2025 08:47:02 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:50 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3235; i=ardb@kernel.org;
 h=from:subject; bh=jIptOtZmKOCZwDiEu+JvA9/u7XRZR8J3wVrBatzcfYQ=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGjmh0uhjRILxkNErSHRqZl7bCOk8F2GbmbuEihaJS52zdYRB
 4h1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmjmh0sACgkQMG4JVi59LVwfRQD9FKpH
 Q9qKX3oWwmzrLHOlLSPFAhIUtqFZBlk/vuE50v4BAPJ2xQQvHPUUD1P6GRLlf3WTDIgb0IKpfQw jPHxyFbcH
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-39-ardb+git@google.com>
Subject: [PATCH v3 16/21] crypto/arm64: sm3 - Switch to 'ksimd' scoped guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Switch to the more abstract 'scoped_ksimd()' API, which will be modified
in a future patch to transparently allocate a kernel mode FP/SIMD state
buffer on the stack, so that kernel mode FP/SIMD code remains
preemptible in principe, but without the memory overhead that adds 528
bytes to the size of struct task_struct.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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
2.51.0.710.ga91ca5db03-goog

