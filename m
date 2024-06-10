Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515613DB9B
	for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2024 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718033211; cv=none; b=AANL+YhO+SDovqQN9k/AHMchOR2jjWo1wVB7E2q3eT2wBDizbM+OGlLSqh/pVb2irnWwowQWSbJjbGI3DGA3xmODkwrbsloR/yT7AWoTfQHnbKz+InWcEPQsQ3yZxEN5M9w54qZDFcww7IhYdNtUCWIsbdCcVIvmOOVfXTf2VFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718033211; c=relaxed/simple;
	bh=djm11PbPLUTyQQJ9l3sDzgoLBWIugExYLbEBTnWiegA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SKFkBefeDy8c5uk956ceniWe/v+poFJaVEs9wRab4jtdXylc99mnpBnZkcAts4ix06qoffrjO7lmmOVzZhn2HJXebS4rioq4RBf+Od8Y+JkVsRUGiXKZ0IgAAiFZYNO55VMALeY4HJj0RaeWoZL1tzDDH9rB/MwYlTbG6hPgDQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjJNzUou; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjJNzUou"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-421eed70e30so7195515e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2024 08:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718033209; x=1718638009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DMRJJSTKqYUGD8dus+yMRcwA/79j6mVNZpg6fqpBuM4=;
        b=BjJNzUoudrPRDwJ8vhBC0bJ3GZCfl5qF2FNbd1VfERaHj+4B/WmwHdeOFQyQKspulS
         mF7+wgKFjHC+rE2rBKShSz9L490mbPSck+3xbeGQEchgSPndpe9EFptOmDa/LBOwk7w9
         cfpUSgGByYAQlWpMj6RFJURMwhC9/k7cgvhNL6NwxLnMCZz2gNdzppHgaI0gw5NOOBPJ
         ZwhDH3zs7DS8uxs7SILKeVcjstwwaGF+hocnk+5dUuoxSDLUTa4jV051ITMmDHl5SQwE
         eI1MBCieWARIV1P9t720tyCWzSqVDOJbBGT6cF7A96AuEjAJTIe+2O3F1zJGuuyEXWso
         kMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718033209; x=1718638009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMRJJSTKqYUGD8dus+yMRcwA/79j6mVNZpg6fqpBuM4=;
        b=BqMMygt3TKN8tugCh0hsCLgq4qaFfidwPLVUCfIp9OSOIeL8Ie3HIqqOok+DkdWBxN
         CYkgIwTbo2RN6oWIbJHzsBNiRcZAWISY/ahMjeXfpeJWR5R1LlqT7o1UadAOWGZ1Ejyu
         umuBZ+9PTc8Y7h8EML45yr0oQp2GF1cR0PJe0vUZYRS64Emzx38RBR/ErQfYJnJE+8d1
         c4l5c77m10dAUrSoQFSHwO5GaIamvrsv+6/QZExiVYIbXAr+ErfiuKCx2N7Wjo5eoxTa
         /CXQaUautUFq0EpX9jnNVsYYC9dm/rFEE+BH5F5d+w5DB0dFrjjyU+IXlbjdNGzRxtzL
         uUzA==
X-Gm-Message-State: AOJu0YyOqRxt6jlCQ4/W8Ml4KA2RZCM/oNSErSFKeK//Nwu7lhWhd5Kx
	UDE2MgvdyT+4WEQFmq95Vzsq7KDuP064A03nVzwi//R/AsKah9HurEvs/jzvvXHeoOmv3i85D8M
	qx/nfVfXCCT6IM2peacJ8S9LWV3/YJEWzovs+uEWc4JcVj+LwYwrUflQ7Y9Ebi6p8BYdQhNKCJ5
	udb+Wfyu/DbQpBHp3YWS8DCpYnb4GDBQ==
X-Google-Smtp-Source: AGHT+IEgVKYDJAU1PB7jiqGHNCiuMfVzxelJUEkF9CTltoEJ0PqEdL6NNITTyaGvrim+bR2T+XtvJETE
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:5487:b0:41f:e5af:181e with SMTP id
 5b1f17b1804b1-42164a4e229mr408355e9.7.1718033208283; Mon, 10 Jun 2024
 08:26:48 -0700 (PDT)
Date: Mon, 10 Jun 2024 17:26:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1742; i=ardb@kernel.org;
 h=from:subject; bh=eJNPUyXrEg+4UdWAVwkHUS/E+tlxeHkytZaImtWFzIg=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIS1dWn/dQ06xa7aMn3l3LbaR6hWs1Np5teBSz7+sug23P
 oflSz3uKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPJnc7wT69IwtFPpvN/y/+7
 Wxg77slM8LghKBZ9uEr/3+zyi9InlBj+Sk+1KnEoyzgmLs4Xu2au+k6pq8ECnGs2vXyuJTLnwF1 NXgA=
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610152638.2755370-2-ardb+git@google.com>
Subject: [PATCH] crypto: arm/crc32 - add kCFI annotations to asm routines
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-hardening@vger.kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The crc32/crc32c implementations using the scalar CRC32 instructions are
accessed via indirect calls, and so they must be annotated with type ids
in order to execute correctly when kCFI is enabled.

Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/crc32-ce-core.S | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
index 3f13a76b9066..88f9edf94e95 100644
--- a/arch/arm/crypto/crc32-ce-core.S
+++ b/arch/arm/crypto/crc32-ce-core.S
@@ -48,6 +48,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 	.text
@@ -123,11 +124,12 @@
 	 * uint crc32_pmull_le(unsigned char const *buffer,
 	 *                     size_t len, uint crc32)
 	 */
-ENTRY(crc32_pmull_le)
+SYM_FUNC_START(crc32_pmull_le)
 	adr		r3, .Lcrc32_constants
 	b		0f
+SYM_FUNC_END(crc32_pmull_le)
 
-ENTRY(crc32c_pmull_le)
+SYM_FUNC_START(crc32c_pmull_le)
 	adr		r3, .Lcrc32c_constants
 
 0:	bic		LEN, LEN, #15
@@ -236,8 +238,7 @@ fold_64:
 	vmov		r0, s5
 
 	bx		lr
-ENDPROC(crc32_pmull_le)
-ENDPROC(crc32c_pmull_le)
+SYM_FUNC_END(crc32c_pmull_le)
 
 	.macro		__crc32, c
 	subs		ip, r2, #8
@@ -296,11 +297,11 @@ ARM_BE8(rev16		r3, r3		)
 	.endm
 
 	.align		5
-ENTRY(crc32_armv8_le)
+SYM_TYPED_FUNC_START(crc32_armv8_le)
 	__crc32
-ENDPROC(crc32_armv8_le)
+SYM_FUNC_END(crc32_armv8_le)
 
 	.align		5
-ENTRY(crc32c_armv8_le)
+SYM_TYPED_FUNC_START(crc32c_armv8_le)
 	__crc32		c
-ENDPROC(crc32c_armv8_le)
+SYM_FUNC_END(crc32c_armv8_le)
-- 
2.45.2.505.gda0bf45e8d-goog

