Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A3347FFC
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907208; cv=none; b=qw6ci3hvhBX2e9jSRMmvfxqKhxg8qlQIyJGOyYXeVwAXuqcp8lNPce2j10AZDbN2yduPgPw5F5bLEbmFu+XCvdWJB7qUa+88wAHMMQYdmlJqK9qWHbJbwd8vBImRnVsJp2bXPCkSBMAOEVzWO4LVEFHQ9pxhvPNZRuq8xEvCdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907208; c=relaxed/simple;
	bh=FR+N77IdiGrlCFWn63AwwcQrA42LGDK7Cq6yK+Fgkuo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TdTRlA+Mlxynsbe4zfQP/Tz8vLW5GRXpqcaBSPNQX+DXHAWZqExnuLQ+U0LvTI78A4iykBSxVlOnDPA9dy0yJbKgmYDjzs4enoXn+8Xi4Fkr951GK6GcTPYS4MmhERV5hQ0La5s6BFw7MYNQMhnr9g/OFejBlHr2PMtHjHG8pDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LStgMf4V; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LStgMf4V"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477212937eeso14256085e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907205; x=1762512005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SF8ncrqKGZBPqJiWodPZcZtzsyty0i7Yz17S72ramgE=;
        b=LStgMf4VHRGYxkZK8MLrbZkS9aaUCTEYp1rEk2RHYoQvz8mKp87ZQnNMsHxFqVqs+a
         Xd05Yv9CwLCvGtHmm/5dZpOC5cLycuuXR2+ttFHV7P5ZDQNcNF3q9Xh2r4zmUFdjmCAh
         8/AYj3SyLRrgMWOR1qBUYfTcp7x2TmwPnlxHsa4mWEObrfPRsKtzSjgVZq7o2XnvSQZJ
         sPiaQfcchd8bKEUL7oWDWIIayp5sA/ouxRICSaTDdclluYC67fJqZlmzpM+zAR0XQLFT
         3VWUUbU29cLb+e6/J4qKp1sWhFjbdWFULPLxqjEx4IpQuP5xLG9RIwRIE531VUTok4XR
         MbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907205; x=1762512005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SF8ncrqKGZBPqJiWodPZcZtzsyty0i7Yz17S72ramgE=;
        b=hTNxW3VCF7g4PTSu9PyS1Jmgrdg/GKE9YCpBmDLK0KP60eKMsVAzMAMkzDQ/uoe6EA
         3E2XVvR4TzfiIoOg62u8/4WaoAZ1LjbUfTnY60sbJ7ual1prfOtfC5OKFE5k90mbfWfg
         xFDKjOAwz2WZHv2qsy0sC40B4rc7z2xDMxz8iWJ5iAyZ08UF7xbFVeBJcbGzXFUUi4km
         hgBlMpkih1lkWMKnSxzD/qztU+yBEMAw1zUX2WYNzosWFQgTXQLax8dP8VkeHlrJ/yM/
         F+TCiKzjonwOzOCmsjXzluaOLe6MTq0tHqCajyoBSZrA8Dpl/1c92oXyNZN6SMqhnrpp
         rEDw==
X-Forwarded-Encrypted: i=1; AJvYcCVIGP/QaKXSKw0Ll9MuqM37SU81k15GTzanHjRhGMNN9uX0BRop0sO5Cb6E0weMAjCY0kCQUBW4Hi7Tz7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzcm94UE3BA4Mw8+KHyP+px1PpbKgQ6kh3ZdfKjbq/0Uc3LnPr
	YArtGoai1WaMd5oRDgXpJRcn8lwXNUJFq5vbZs0b1uXfKoQMfyoPpKJTxb/dKhNCrhixS2tLlw=
	=
X-Google-Smtp-Source: AGHT+IEcqBxbY2AIAxAcJMsPotcWd8+1QqYVT1aVGm+VjwDxESgE8ZawF9/oIrAUJEx68xLqm7/XWK7L
X-Received: from wma7.prod.google.com ([2002:a05:600c:8907:b0:477:14b8:19f6])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f0e:b0:46e:4704:b01e
 with SMTP id 5b1f17b1804b1-477305a24bcmr31060015e9.8.1761907204696; Fri, 31
 Oct 2025 03:40:04 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:19 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1630; i=ardb@kernel.org;
 h=from:subject; bh=QCkmJ7w8pvMSbfD6OyFFYQvX8b+Mf1wyse4VMzYa6NQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4gP+H0eZF9crby3kuR/0NfFDu3admAK3vWychkKUR
 phch0lHKQuDGBeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmEhBC8P/nEtnfS3ZXiR9vDY9
 pu4ZV2LeS23Rv09n3jGVaZy24fmjswz/Yy7EKLWZ/1XO9HrZ7r+lRMb6Z+SrY24TdVlFxV8Y6Kv xAgA=
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-43-ardb+git@google.com>
Subject: [PATCH v4 20/21] arm64/fpu: Enforce task-context only for generic
 kernel mode FPU
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The generic kernel mode FPU API, which is used by the AMDGPU driver to
perform floating point calculations, is modeled after the most
restrictive architecture that supports it. This means it doesn't support
preemption, and can only be used from task context.

The arm64 implementation is a bit more flexible, but supporting that in
the generic API complicates matters slightly, and for no good reason,
given that the only user does not need it.

So enforce that kernel_fpu_begin() can only be called from task context,
and [redundantly] disable preemption. This removes the need for users of
this API to provide a kernel mode FP/SIMD state after a future patch
that makes that compulsory for preemptible task context.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/fpu.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/fpu.h b/arch/arm64/include/asm/fpu.h
index 2ae50bdce59b..bdc4c6304c6a 100644
--- a/arch/arm64/include/asm/fpu.h
+++ b/arch/arm64/include/asm/fpu.h
@@ -6,10 +6,22 @@
 #ifndef __ASM_FPU_H
 #define __ASM_FPU_H
 
+#include <linux/preempt.h>
 #include <asm/neon.h>
 
 #define kernel_fpu_available()	cpu_has_neon()
-#define kernel_fpu_begin()	kernel_neon_begin()
-#define kernel_fpu_end()	kernel_neon_end()
+
+static inline void kernel_fpu_begin(void)
+{
+	BUG_ON(!in_task());
+	preempt_disable();
+	kernel_neon_begin();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	kernel_neon_end();
+	preempt_enable();
+}
 
 #endif /* ! __ASM_FPU_H */
-- 
2.51.1.930.gacf6e81ea2-goog

