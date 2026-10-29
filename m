Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281839;
	b=RPdzL9h+PJesRawoYvi+Fnxi1VJkYgw9TXIGvDBIMUu+tSV1Z1QCvZcRg4fE3yYUvKnQ
	 08iYoLoyT4+xubSJdJnsRnSK/WUQOD7wz45wAiqZyevqU/Iv/tL6DI4Q2uF0oqgeyMjFQ
	 GV5CMW6RjoFhOnmsYW+4n+Q4L1x0y1gKWbjqaDGG//DrN0zCnSnCYUs4d+5SSnEiR5F8K
	 eiVQ24/CBNdOezrhRgrrlwaQ63qHqRKdanyb3fzEVyVwgrqqXr/8b/51dKj6My92sBdor
	 +16vrHjp8VIVuR1tVUdPFPct+RibXax7HwtKYXrXijjFxMkM9Jrn2b0VM2iA5xa69RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=X2dfVjLkrmuJSC4aZO/b8p2vQ9W6RQvFVrEQpEEdhzw=;
	b=oHncGti4oQv9AhmW7JaCqZIPLm0DXfDg5Zw4GM+OVscAbrv2hDqenaOPYKkj63lC2PRK
	 BFRpnE7scWDCxnJMZ6dxBRLPE2VIkFN+X8S7cN1d5pqZld7WPxXRuWQfPZn1EsJw5dgSB
	 MaByOwYpjuXbi68cqGsj/DNX4KAa5sc0XpH6QAf+R6hB+gJdgz9U5NlQlIW2dcSmDepYE
	 Muc75Xma16eTd1bW6GCfYDzvmLd/dC86bKIP5RAvrI0Ua093EwKmdUb1iM7n+EqQnqWIw
	 Pl0sQ6jYOxhMSssnAfgcgggz6v3EfPtjaEBx/Bc/JxcgCtOduEbjk2LA/jgoLMzNxNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MsRiGxaT;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F5606A338
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 13:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 333F5606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MsRiGxaT
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a70b42bab0so8294925e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281838; x=1793886638; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X2dfVjLkrmuJSC4aZO/b8p2vQ9W6RQvFVrEQpEEdhzw=;
        b=MsRiGxaTPquXF7q6+ewsjA/st3i+8tluFvx8BlHcX0yDVs1/6YfZqBgJ3BASv9xrju
         u0g9iQFTQ/z9zpwL1vfvsS28MZseNz20LQPMq2HYHFTDkYlX97cOybuSyyF58cQcnsjL
         OIoZKYS+uC9fy+m3EuE0j5edcPp/+QtoVxxnopE7TXQI7ibqIOnB48AgmDEx+9jQT1+k
         1SgtERSmYahnixQV1GErebQ21QyKm1o1o7+WZPhR2hoeWX8pUq+WJJ3Q5q2n86zPYJ0D
         W3KP5SLQUw/kjwJpdAIfJW0MXej/oTqLga/fMlcJq0eIV5jAyKIOMpFbwBr6Z4g5sSER
         7XyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281838; x=1793886638;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X2dfVjLkrmuJSC4aZO/b8p2vQ9W6RQvFVrEQpEEdhzw=;
        b=E7kFiAw7lgIxN1bL90RnWbO6B1CS/+C+k0lelMrBN4h8saL9dqqgfPs0toKzi/ihHY
         OUnwtSKYf6urCBsXb5n/DhKq8agrS1+P7KneXlBTyROyNb5HFX1kntKuuTrlRUmBLrd6
         IWyQON4mrHnNLuqDYJC4pj+H9Ym4c99VPWNh2t1EJ+ZeTi2prsYWJit+j296OC1z8765
         wBAdsfdd6BwMALBG+Nu5lpBr5RZweF7/8uvN4wpzD2RuA1UeBzq7tyMpDXhQ3TpvKR5o
         958buVbnNZwF8TSsv5Gahyp/834/d97aXrICKxuH4CGeA0OMtf8M6q+BXitGCmPN6sfo
         OWzQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGe6mjtn6eA2Li/YIr3AzGDhmJq4rsgjWUGILzRIxU2LptLtdUYLcP0b5zh4DMW3OHV0x6vXzcIC1UyXE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLNGE5zgufKiY9t+S0IJNZn4oLdh0TCoKiQuOKiVj+D5EhTkXz5
	1CYBnw0TIKMwm140qY2YSu0FjxD0wDDR0rpZ3Bm/qMBZXJ4pnaPDD/m1NLfpJLWgSMIwx3XYaw=
	=
X-Received: from wmby1.prod.google.com ([2002:a05:600c:c041:b0:4a5:a768:cd6c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f84:b0:4a7:72b1:c8bd
 with SMTP id 5b1f17b1804b1-4aa8823d762mr60543425e9.15.1793281835085; Thu, 29
 Oct 2026 06:50:35 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:50:22 +0100
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029135020.272082-8-ardb+git@google.com>
Subject: [PATCH 2/4] xor: arm/arm64: Move NEON xor_gen() dispatch into the
 glue code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The NEON intrinsics code in xor-neon.c and arm64/xor-eor3.c includes xor_impl.h
for the definition of __DO_XOR_BLOCKS(), which pulls in <linux/types.h> via
<linux/init.h> and <linux/minmax.h>. This only works because
asm/neon-intrinsics.h overrides the compiler's predefined macros that
<stdint.h> uses to define the C99 types, so that they match the kernel's
definitions in <linux/types.h>.

So instead, follow the approach taken by LoongArch, and instantiate the
dispatch routines using DO_XOR_BLOCKS() in the glue code, which already
includes the kernel headers, and does not use NEON intrinsics itself.  This
requires the NEON routines that handle a fixed number of sources to be exposed
to the glue code, which means that the arm64 glue code can use __xor_neon_2()
directly for the EOR3 flavor as well, and so the __xor_eor3_2() alias can be
dropped.

This makes the NEON intrinsics code independent of the kernel's own headers,
which will allow the macro overrides in asm/neon-intrinsics.h to be removed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/raid/xor/arm/xor-neon-glue.c   |  3 ++
 lib/raid/xor/arm/xor-neon.h        | 16 ++++++++--
 lib/raid/xor/arm64/xor-eor3.c      | 15 ++--------
 lib/raid/xor/arm64/xor-neon-glue.c |  5 ++++
 lib/raid/xor/arm64/xor-neon.h      | 31 +++++++++++++++++---
 lib/raid/xor/xor-neon.c            | 16 +++-------
 6 files changed, 56 insertions(+), 30 deletions(-)

diff --git a/lib/raid/xor/arm/xor-neon-glue.c b/lib/raid/xor/arm/xor-neon-glue.c
index cea39e019904..783474bfe81e 100644
--- a/lib/raid/xor/arm/xor-neon-glue.c
+++ b/lib/raid/xor/arm/xor-neon-glue.c
@@ -5,6 +5,9 @@
 #include "xor_impl.h"
 #include "xor_arch.h"
 
+DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
+		__xor_neon_5);
+
 static void xor_gen_neon(void *dest, void **srcs, unsigned int src_cnt,
 		unsigned int bytes)
 {
diff --git a/lib/raid/xor/arm/xor-neon.h b/lib/raid/xor/arm/xor-neon.h
index 406e0356f05b..5592dec4de50 100644
--- a/lib/raid/xor/arm/xor-neon.h
+++ b/lib/raid/xor/arm/xor-neon.h
@@ -3,5 +3,17 @@
 extern struct xor_block_template xor_block_arm4regs;
 extern struct xor_block_template xor_block_neon;
 
-void xor_gen_neon_inner(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes);
+void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2);
+void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3);
+void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4);
+void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5);
diff --git a/lib/raid/xor/arm64/xor-eor3.c b/lib/raid/xor/arm64/xor-eor3.c
index e44016c363f1..41bb577b63eb 100644
--- a/lib/raid/xor/arm64/xor-eor3.c
+++ b/lib/raid/xor/arm64/xor-eor3.c
@@ -1,14 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-#include <linux/cache.h>
 #include <asm/neon-intrinsics.h>
-#include "xor_impl.h"
-#include "xor_arch.h"
 #include "xor-neon.h"
 
-extern void __xor_eor3_2(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2);
-
 static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
 {
 	uint64x2_t res;
@@ -19,7 +13,7 @@ static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
 	return res;
 }
 
-static void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3)
 {
@@ -53,7 +47,7 @@ static void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-static void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3,
 		const unsigned long * __restrict p4)
@@ -96,7 +90,7 @@ static void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-static void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3,
 		const unsigned long * __restrict p4,
@@ -141,6 +135,3 @@ static void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
 		dp5 += 8;
 	} while (--lines > 0);
 }
-
-__DO_XOR_BLOCKS(eor3_inner, __xor_eor3_2, __xor_eor3_3, __xor_eor3_4,
-		__xor_eor3_5);
diff --git a/lib/raid/xor/arm64/xor-neon-glue.c b/lib/raid/xor/arm64/xor-neon-glue.c
index f0284f86feb4..ae133d699649 100644
--- a/lib/raid/xor/arm64/xor-neon-glue.c
+++ b/lib/raid/xor/arm64/xor-neon-glue.c
@@ -9,6 +9,11 @@
 #include "xor_arch.h"
 #include "xor-neon.h"
 
+DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
+		__xor_neon_5);
+DO_XOR_BLOCKS(eor3_inner, __xor_neon_2, __xor_eor3_3, __xor_eor3_4,
+		__xor_eor3_5);
+
 #define XOR_TEMPLATE(_name)						\
 static void xor_gen_##_name(void *dest, void **srcs, unsigned int src_cnt, \
 		unsigned int bytes)					\
diff --git a/lib/raid/xor/arm64/xor-neon.h b/lib/raid/xor/arm64/xor-neon.h
index 514699ba8f5f..7d7fb96343df 100644
--- a/lib/raid/xor/arm64/xor-neon.h
+++ b/lib/raid/xor/arm64/xor-neon.h
@@ -1,6 +1,29 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 
-void xor_gen_neon_inner(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes);
-void xor_gen_eor3_inner(void *dest, void **srcs, unsigned int src_cnt,
-		unsigned int bytes);
+void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2);
+void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3);
+void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4);
+void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5);
+
+void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3);
+void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4);
+void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5);
diff --git a/lib/raid/xor/xor-neon.c b/lib/raid/xor/xor-neon.c
index c7c3cf634e23..6b2fd14f5041 100644
--- a/lib/raid/xor/xor-neon.c
+++ b/lib/raid/xor/xor-neon.c
@@ -4,12 +4,11 @@
  * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
  */
 
-#include "xor_impl.h"
 #include "xor-neon.h"
 
 #include <asm/neon-intrinsics.h>
 
-static void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2)
 {
 	uint64_t *dp1 = (uint64_t *)p1;
@@ -36,7 +35,7 @@ static void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-static void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3)
 {
@@ -72,7 +71,7 @@ static void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-static void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3,
 		const unsigned long * __restrict p4)
@@ -117,7 +116,7 @@ static void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
 	} while (--lines > 0);
 }
 
-static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
+void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 		const unsigned long * __restrict p2,
 		const unsigned long * __restrict p3,
 		const unsigned long * __restrict p4,
@@ -170,10 +169,3 @@ static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 		dp5 += 8;
 	} while (--lines > 0);
 }
-
-__DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
-		__xor_neon_5);
-
-#ifdef CONFIG_ARM64
-extern typeof(__xor_neon_2) __xor_eor3_2 __alias(__xor_neon_2);
-#endif
-- 
2.56.0.313.g2479322e68-goog

