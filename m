Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E86340A51
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907207; cv=none; b=K+wOYB1rsGZrrSGfkCGbvGSv1x8aghtst7i9AflMr2Nz/3uj2DOW+CgkmoKj+YJuwfIq7M8y4zkX2PzTQHIdlAkDdbTweomE1xxWlDfN5yiMoI0UT3ptXch3tL4EdsfKpqUMnzoArQFP3ujri9cpjyT8QothTeLir3Am8tUQIkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907207; c=relaxed/simple;
	bh=72D7ld0QaLVbpLWswxFeBab7Xjr8fyBYpl2QMGIhIQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sl+MmKF4g/j/7XFTUMfl7gnZtvfPRwD4DH2XA+wHxf3TwMvhyQC91bMqjZu0hZ2bBWQ/xcBJ/GmTXKicQ1krHcTT8UyhhKaClsh6Iqs5GHbzh/3RIDuAr9aruf6XySB9gZexVuR4CahrD059rHXw6BhsWn+tkN2Hq2zt8o0Dq+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ffrGY6hU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ffrGY6hU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-476b8c02445so18517055e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907203; x=1762512003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EBCI2bCGa2uMBxuOl4BNLMr0TWQdRgwa7kpYQ+xRQo=;
        b=ffrGY6hUW6tdCwPBzv1UKROgJEdUkFtTfJTlX8YqDqyye8MuuiE9OKjy4IDKTMnQH+
         8d9nrZVm1bkdcZ+a5JgHxnFeS7QJb2D6MH8duEZ8UXM9AXzpt/x/QsKHwpnqf+AAajeY
         6BmKp0wPPN/4gg0/+cubkFXFksIuPV0uI7NkAHi0rrtppjFZwr+3jghXiPbydH+Ch/FC
         dm2gC+4u35T7I3UxNiny9iDEXXi6cqxeVE0Gz/ofRz++/PJWeJDnCaLnksVjw34jD7dr
         Na3074kgQyYSAVGiCGyPFbrim7ylc6QnrQu7CMbRQ7KZJgA+Kqz5H5kSYKq2OiRyPnK+
         pw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907203; x=1762512003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EBCI2bCGa2uMBxuOl4BNLMr0TWQdRgwa7kpYQ+xRQo=;
        b=WxkdfXu76IVGkHP5aWD4vcgTPOJJPSitZcrgdOjdr+Ltd3/cd8l0QtzEui5ff9rD0Y
         LmA4mbeUozloyL4NPXjv20fvy7lTFpVSB2TptMW2QWN+qNoh9QyuHA1wcgYsFy5OGqX1
         Bm7pc06jVpUqlCFkkJZ+PWvHfGgPHU3EZokc5CgwtdOOck/CWrzvj/3bEFi2bdl6m5mA
         UmOjUWXDL9K6OnKf/jaFbd/IXc+YymVZuqj6gyxT9t5gxpceUK+79jmV214Bjrl4sv9M
         y5h4aUecpI3KuY8d3POl7ynRWzGSvzmmwEWj/rrmaElGHsrss8hcu0XlZdy101v137zf
         4ZMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmCuxUPodlPct7ze+papImj+kWlCSBmaPgURutIHBivFHhb1d9ayTheWxpR/cNGYkU0UXpbTFAUlZpOlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzEX/uGB4xB/uttbiy8cOtlVliey/u3bkf2/ixmTRgC2zvobOf
	21Dx39ZyxgXLFbZzgE1twzKBsU6eH5CYi19xfCDwMojAF8LTVE+EmaNuSwxuGbnrmNBfKBytKQ=
	=
X-Google-Smtp-Source: AGHT+IEsXL7pay8yayVs9zynCOgQoK1Z8jXHUNfyuqH/t2/LwKAhQiBuGbloXMNB6A2V6Qfym6M16bpZ
X-Received: from wmcq10.prod.google.com ([2002:a05:600c:c10a:b0:475:de83:8f42])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190e:b0:46e:2562:e7b8
 with SMTP id 5b1f17b1804b1-4773086e447mr24492465e9.21.1761907203196; Fri, 31
 Oct 2025 03:40:03 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:17 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2401; i=ardb@kernel.org;
 h=from:subject; bh=+pRFDT2DZ8ceDoxhoXJcyM9jtfEdqdQN8vIsBlZZ/gU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4t1Dt15MeJZtLZJ3Lzvy9fFThtcuKypWxDt61IdM+
 cdQEmrYUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZy8iYjw6+vB+x4V7qGiTeI
 G9gKXzI9xNa6iaNu36esCEmj/TPP6TMyHGXxmszGJcf3Y+WEDUrhOzWLv/x3+6d9ImZ/w8awfis bfgA=
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-41-ardb+git@google.com>
Subject: [PATCH v4 18/21] arm64/xorblocks:  Switch to 'ksimd' scoped guard API
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
 arch/arm64/include/asm/xor.h | 22 ++++++++------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/xor.h b/arch/arm64/include/asm/xor.h
index befcd8a7abc9..c38e3d017a79 100644
--- a/arch/arm64/include/asm/xor.h
+++ b/arch/arm64/include/asm/xor.h
@@ -9,7 +9,7 @@
 #include <linux/hardirq.h>
 #include <asm-generic/xor.h>
 #include <asm/hwcap.h>
-#include <asm/neon.h>
+#include <asm/simd.h>
 
 #ifdef CONFIG_KERNEL_MODE_NEON
 
@@ -19,9 +19,8 @@ static void
 xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p2)
 {
-	kernel_neon_begin();
-	xor_block_inner_neon.do_2(bytes, p1, p2);
-	kernel_neon_end();
+	scoped_ksimd()
+		xor_block_inner_neon.do_2(bytes, p1, p2);
 }
 
 static void
@@ -29,9 +28,8 @@ xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p2,
 	   const unsigned long * __restrict p3)
 {
-	kernel_neon_begin();
-	xor_block_inner_neon.do_3(bytes, p1, p2, p3);
-	kernel_neon_end();
+	scoped_ksimd()
+		xor_block_inner_neon.do_3(bytes, p1, p2, p3);
 }
 
 static void
@@ -40,9 +38,8 @@ xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p3,
 	   const unsigned long * __restrict p4)
 {
-	kernel_neon_begin();
-	xor_block_inner_neon.do_4(bytes, p1, p2, p3, p4);
-	kernel_neon_end();
+	scoped_ksimd()
+		xor_block_inner_neon.do_4(bytes, p1, p2, p3, p4);
 }
 
 static void
@@ -52,9 +49,8 @@ xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 	   const unsigned long * __restrict p4,
 	   const unsigned long * __restrict p5)
 {
-	kernel_neon_begin();
-	xor_block_inner_neon.do_5(bytes, p1, p2, p3, p4, p5);
-	kernel_neon_end();
+	scoped_ksimd()
+		xor_block_inner_neon.do_5(bytes, p1, p2, p3, p4, p5);
 }
 
 static struct xor_block_template xor_block_arm64 = {
-- 
2.51.1.930.gacf6e81ea2-goog

