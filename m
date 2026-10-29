Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281841;
	b=tvMBKzBZ4fBxk629jG3v28SqyOms9h4W+mlKbBULwnEDYKBcwxqyksn0VR7WRXzeRdbf
	 P56Gc4T2KhWDs87zh0q99JrICWTXNmeySRtYRfBXLqFFwvFacnrAAWe4NVvY03WAilEXS
	 kn+QIcq/tIaG5twiil0DplmDIhUGm+ogd1nj/MEpnBxbu46eMVIW2qWjXbpuqiBG9GVWT
	 Dc5wCZUWHiq4Gs4Xg0Gpycyig4kQbeMAbCWf+WFmPmDqCRd5GNsZyArdo0Rs8YZLBv3O/
	 sPcFX4EYurKHhBhWabjOwcGzUwaWiDlOV7hRA/h9XXaKiPO0BdmygPGxogBm4uHTfmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=exWtIBRZ56EySSgogA875Ex4m63J1/CXAzQ1NHtAG7s=;
	b=oDaq271f93zkEc8Cfuh4oazIPnC4h82miSB8ycC35+e70qVGmGajMl/WAWv8bNs6442a
	 LhWi393axydgkCA3PvUeaXBHBl2LOZA6rPgVuHAMlebGIxrW8vBdQuJbar6NKYSVGZa7d
	 HRk9p/Ws0QmvX9hdY5Jl4oPZS9kmBYtRB8vTJIZ2v8XY8cqiUE0wITb7xq61wtgzjZTpc
	 53YBLRGbfSP0GkMnFvM+74cezC3ytTPBjce6bDABZTTpWAebshSxKrvNKDx1ktrZh3SV6
	 CosobJMhSPsq+2oj+PP0VGJssh20LrEpmxaVgdwog7l9a6EaCr4zXXDb412d9jCtmkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lu5TxXdQ;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819A60A2623
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 13:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7819A60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Lu5TxXdQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a17741243eso15682515e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281840; x=1793886640; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=exWtIBRZ56EySSgogA875Ex4m63J1/CXAzQ1NHtAG7s=;
        b=Lu5TxXdQ8bJxkxwIkFPt/7A7+cY1pSTP03qpBeulydbqj0z6Gh4/VvUzI5fGlMyZQS
         o160QygY/3dCMt9UTQOQxE2wxAxgjD1MSXP8D6d0QSvq9j5gH7MHR5hX8KSsf2B2Vx4w
         6RShPfRWF+rvbqjEm2ES6f6tqVa1QtcPpgcFwZGhb8Qrhrs8s7gfBQvELy7gX4fNDPfd
         1I/E4yyxscX27/IGzX4TUr0xCtr8oxX7qB1YbPuRUrIjYKnAKp0BcdBXkktQeDdhRKnA
         v+clKdtb5tddxzxR9mo0uXJU72U1pyh/Ve+tlhN0blh6VjktEWPnvzo/BcXjlZTPpA36
         HcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281840; x=1793886640;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=exWtIBRZ56EySSgogA875Ex4m63J1/CXAzQ1NHtAG7s=;
        b=qkl7Jnwdqrfick3qaXf9ayGSrTJJ8r/FoRob3eX3Gaxc6e+YcCEqbDYxr5pEv03gZo
         bN834GRIUSEamFwaeXFhr1Iv7eq54ogp6f8EYmE3774ibPIWFu1WtunHfiBSszAN2x09
         e1zZCMwb/I2Ok8Vn4qMfhUQqFMxK+Hp3vnn4El6ddcWdRVoH0YNhN5QWVTBQV4xI+h8B
         5FMOHiHmbNkFm4Xqk1FE8MUolT1bB9J7WiLIRU+kox8U8lOEMdXi3DPgDQ2Rq6qzqAm9
         AaxU6AyrwipWz38KGs6qFM0iIVePTknFXBW+YcrT2QVC1dDqES6abGHp0E88GKPPVD6q
         gPxA==
X-Forwarded-Encrypted: i=1; AKwUvBzTQkKv8Z1SAiKEfrFXX9To8XyqCaypYNDNvAjrNUlY2uM+x338cWxCXdVFPxBQHVW1bVpSXAvq8J4SCPg=@vger.kernel.org
X-Gm-Message-State: AFq9FYK6H8n79mBULbGnvbiGTj9ColK3568haqm5mFKiZmIUwxo70o0A
	g1FQ0qhPmrsJxn08c5KHj49SxJ8n7XGeNJp/cVENnAEQ+vmV5PeCW3UC/7tojyct9F9U5ITFzA=
	=
X-Received: from wman14.prod.google.com ([2002:a05:600c:6c4e:b0:4a1:bec2:1cfe])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4454:b0:4a3:2f35:38b6
 with SMTP id 5b1f17b1804b1-4a967017cf8mr130515735e9.24.1793281839636; Thu, 29
 Oct 2026 06:50:39 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:50:24 +0100
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
Message-ID: <20261029135020.272082-10-ardb+git@google.com>
Subject: [PATCH 4/4] ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

None of the users of NEON intrinsics include <linux/types.h> anymore,
and so there is no longer a need to override the compiler's predefined
macros that are used to define the C99 [u]int32_t and [u]intptr_t types
in order to make them compatible with the kernel's definitions. So drop
the overrides from asm/neon-intrinsics.h.

Update the documentation accordingly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/arch/arm/kernel_mode_neon.rst | 10 +++--
 arch/arm/include/asm/neon-intrinsics.h      | 43 +++-----------------
 2 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/Documentation/arch/arm/kernel_mode_neon.rst b/Documentation/arch/arm/kernel_mode_neon.rst
index 1efb6d35b7bd..73331f17b2c0 100644
--- a/Documentation/arch/arm/kernel_mode_neon.rst
+++ b/Documentation/arch/arm/kernel_mode_neon.rst
@@ -121,6 +121,10 @@ observe the following in addition to the rules above:
 * Compile the unit containing the NEON intrinsics with '-ffreestanding' so GCC
   uses its builtin version of <stdint.h> (this is a C99 header which the kernel
   does not supply);
-* Do not include <arm_neon.h> directly: instead, include <asm/neon-intrinsics.h>,
-  which tweaks some macro definitions so that system headers can be included
-  safely.
+* Do not include <arm_neon.h> directly: instead, include <asm/neon-intrinsics.h>;
+* Do not include <linux/types.h>, or any other kernel header that includes it,
+  into the same compilation unit: some of the C99 types it defines (e.g.,
+  intptr_t) are incompatible with the ones defined by <stdint.h>. The kernel's
+  own u8, u16, u32 and u64 types are provided by <asm/neon-intrinsics.h>, and
+  can be used safely in the prototypes of functions that are called from code
+  that does include <linux/types.h>.
diff --git a/arch/arm/include/asm/neon-intrinsics.h b/arch/arm/include/asm/neon-intrinsics.h
index 8b80c05ce1d7..449f6556ac67 100644
--- a/arch/arm/include/asm/neon-intrinsics.h
+++ b/arch/arm/include/asm/neon-intrinsics.h
@@ -7,46 +7,13 @@
 #error You should compile this file with '-march=armv7-a -mfloat-abi=softfp -mfpu=neon'
 #endif
 
-#include <asm-generic/int-ll64.h>
-
 /*
- * The C99 types uintXX_t that are usually defined in 'stdint.h' are not as
- * unambiguous on ARM as you would expect. For the types below, there is a
- * difference on ARM between GCC built for bare metal ARM, GCC built for glibc
- * and the kernel itself, which results in build errors if you try to build
- * with -ffreestanding and include 'stdint.h' (such as when you include
- * 'arm_neon.h' in order to use NEON intrinsics)
- *
- * As the typedefs for these types in 'stdint.h' are based on builtin defines
- * supplied by GCC, we can tweak these to align with the kernel's idea of those
- * types, so 'linux/types.h' and 'stdint.h' can be safely included from the
- * same source file (provided that -ffreestanding is used).
- *
- *                    int32_t     uint32_t          intptr_t     uintptr_t
- * bare metal GCC     long        unsigned long     int          unsigned int
- * glibc GCC          int         unsigned int      int          unsigned int
- * kernel             int         unsigned int      long         unsigned long
+ * <arm_neon.h> includes <stdint.h>, which defines some C99 types differently
+ * from <linux/types.h>, so the latter must not be included into code that uses
+ * NEON intrinsics. The kernel's u8/u16/u32/u64 types can be used alongside the
+ * C99 ones, so provide those instead.
  */
-
-#ifdef __INT32_TYPE__
-#undef __INT32_TYPE__
-#define __INT32_TYPE__		int
-#endif
-
-#ifdef __UINT32_TYPE__
-#undef __UINT32_TYPE__
-#define __UINT32_TYPE__		unsigned int
-#endif
-
-#ifdef __INTPTR_TYPE__
-#undef __INTPTR_TYPE__
-#define __INTPTR_TYPE__		long
-#endif
-
-#ifdef __UINTPTR_TYPE__
-#undef __UINTPTR_TYPE__
-#define __UINTPTR_TYPE__	unsigned long
-#endif
+#include <asm-generic/int-ll64.h>
 
 /*
  * genksyms chokes on the ARM NEON instrinsics system header, but we
-- 
2.56.0.313.g2479322e68-goog

