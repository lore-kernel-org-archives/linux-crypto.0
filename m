Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253A91C986B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725365399; cv=none; b=mc9vHP9HCiSzsLKo4nimqi8yhcHhO5wy+HNGzOuzpMrf6nYF72JQlyVo3HZuksSAlEjRQd9rpR9S/SxVF2V4FMty19gY03RyP4T6FmUUg5kBgw3Bj9q+oIo6qXKoc3+MJTALx3RT5JOJEWG/Q3Df/aeL0ICy7YaSN1BN+JPnbs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725365399; c=relaxed/simple;
	bh=44yzxRSTqwlOROlkCwEXzmTbMUBKaeO1+N1E/oREDTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfYttEYZ+D4D/huNfTp4LYJwRzky4eywoQOiPcutCePioLRbBtr2SYdCu8TQpeE+BRKXIK82RnimcnT3QQAUrIezhPaVIzqQVVTdqDwgmCqcua7p2+0aFiQw5Vl101vp21rqOYwGbtvia2VZ/xcYXMVCkptajEzbKxSVpTwBHwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A6f+8c2B; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A6f+8c2B"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42c7a49152aso32654455e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 05:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725365396; x=1725970196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/DUDom//tRZnCzR0TPrW7dnmFkZZ6kQdXEFrODb12u4=;
        b=A6f+8c2BdG8o+Y7O5uRJFBHkFlH0wNBzQPPcmb2rLp1n6O2+pj2PIans7wSwV3ZtJz
         cF2m//6pNZJxbUx/iwdJetrS0IXrbo610bm8ip8ChOsoji50g6laURTZ5n3qutnn7KY4
         Bo8tFVLSIXVCGoFAPYbZieLD+iOW3LfI6U/73nNEGgBEp4p5l0z6eQ+m8XYvWfL0ve+L
         cvnoyAcuylsbtoERPhCH0VHyJ+h6TvrIZaw+zzFkES36/2LisAtEq8yXRqJ63be8Ci5l
         IUfQ8EX+YjpPoDvAAVJvi4fxMFGWtGT8qmvDgohmXuxBHwNM6QQZSj2QNtTuGr0zi1q4
         npsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725365396; x=1725970196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DUDom//tRZnCzR0TPrW7dnmFkZZ6kQdXEFrODb12u4=;
        b=LQjEKRHljRV20VtFaf/cpaRnnpB7AE8eilSwwn+qPUDpLDXuEK48otlRhu18RZ4t70
         R52s1SfWMAk0+MKphhoBP01Tgly5NvLq7p1UlwE3duO5NuPNvg2ADBILCUrE8CKTmOXC
         DjvqoqQJSvU16cTFA/xQkiaNDUkOA5aH/nFKQu9EjXET4+bRXGpWUN0NDTVH1fM70HAP
         s22hlx3u6Xdpa3Gr5jfXTm3EANfk5r7ypClWKFxsp8LIaBpD8M/GkICvKEm6DwGCvVhq
         47Cf7qtoGz/6sjG7rctLM8+usdaYi4Y9uaX4EXzhxYAhdCKVekNErqRaI3qTLioHF/QH
         NIgg==
X-Forwarded-Encrypted: i=1; AJvYcCVul41ie3YD4N36IHJju81iXCHgm4ZHviqTBXbC38wz4rJyyXHV963ONYmytgj8JvvhPAxPC0TcuBaxOec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8G68G7lfooDx0Luze+OhKt1eJCYtEuvIz7rTyT7hkAagZzQ7i
	bgwdfeHRvEJwm+uBBOhADVVT+BOfWbXH8sctvZLaO71pzJkgLwZeW32MyNSAv7Y=
X-Google-Smtp-Source: AGHT+IFcoK0ATItLWWMNoYyO3QSsujmu7MhadnpNmBdao6RwrBFoO5Fsa1nhUpv/GrvTkZFRm38cOA==
X-Received: by 2002:a05:600c:3c9f:b0:426:5b44:2be7 with SMTP id 5b1f17b1804b1-42bb01b5f50mr137762745e9.10.1725365396400;
        Tue, 03 Sep 2024 05:09:56 -0700 (PDT)
Received: from ubuntu-vm.. (51-148-40-55.dsl.zen.co.uk. [51.148.40.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4a55fsm14069238f8f.10.2024.09.03.05.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:09:55 -0700 (PDT)
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v5 1/2] arm64: alternative: make alternative_has_cap_likely() VDSO compatible
Date: Tue,  3 Sep 2024 12:09:16 +0000
Message-ID: <20240903120948.13743-2-adhemerval.zanella@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240903120948.13743-1-adhemerval.zanella@linaro.org>
References: <20240903120948.13743-1-adhemerval.zanella@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

Currently alternative_has_cap_unlikely() can be used in VDSO code, but
alternative_has_cap_likely() cannot as it references alt_cb_patch_nops,
which is not available when linking the VDSO. This is unfortunate as it
would be useful to have alternative_has_cap_likely() available in VDSO
code.

The use of alt_cb_patch_nops was added in commit:

  d926079f17bf8aa4 ("arm64: alternatives: add shared NOP callback")

... as removing duplicate NOPs within the kernel Image saved areasonable
amount of space.

Given the VDSO code will have nowhere near as many alternative branches
as the main kernel image, this isn't much of a concern, and a few extra
nops isn't a massive problem.

Change alternative_has_cap_likely() to only use alt_cb_patch_nops for
the main kernel image, and allow duplicate NOPs in VDSO code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Adhemerval Zanella <adhemerval.zanella@linaro.org>
---
 arch/arm64/include/asm/alternative-macros.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index d328f549b1a6..c8c77f9e36d6 100644
--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -230,7 +230,11 @@ alternative_has_cap_likely(const unsigned long cpucap)
 		return false;
 
 	asm goto(
+#ifdef BUILD_VDSO
+	ALTERNATIVE("b	%l[l_no]", "nop", %[cpucap])
+#else
 	ALTERNATIVE_CB("b	%l[l_no]", %[cpucap], alt_cb_patch_nops)
+#endif
 	:
 	: [cpucap] "i" (cpucap)
 	:
-- 
2.43.0

