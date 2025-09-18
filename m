Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0801E51E0
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 06:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177371; cv=none; b=NxxAGf+HuZyhhPHipekyYZ7l2K5g8uD0hH4+hHws89v12ZQlAW9a11VLF4ARfzE9nAcYxDF52Xhf/j5BWOvsbV9owEgI09JPfKJG3NAANrbO+KW7XTsY3bzHjbzb4UbFdtV57nuODK8dcA2QGIURkKshUO9aNvk9P61ABM/Dml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177371; c=relaxed/simple;
	bh=6V9uNq83XXSYotxaF5gDZpQuTwairQF/oZADfO3/sw4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sCmaLS9IJBbY9r5C8ZMUSE/BKLDROk1ri2gk/4/pZAxGYTrb0jWqTgbSeoKffSukPpySUx8AuvHpmEcDlgyIwl9UY6LPBjR5k27Fei8tBaYH/E0N0BjMoCcgKIMeg5Fia3kS6Y2bF42BQk2HJa9FajvzFejqXnGidwZWyK97sWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dWPm2voH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dWPm2voH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b467f5173so4692625e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 23:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177367; x=1758782167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VFjH+4iKezMx9taew/P2Pp2wCahAKn7daFaD40BNcwI=;
        b=dWPm2voH0f603vPYQX77aQqLkQwj1gccurUP3xm1C/utJaqfk50DrRytdrmmiyQJfg
         Ycv4tPwrswZeOpCt4GBicXAxbm62qcDyG0SIvYXMBlZAPcn7/yv0kg7d561BhHzlUocL
         vXuHJevK3ZD6fDDJM2ygdtHImzccAXDBSCj/P/1DTfPXDuCvmnZZ+AHtWzy21aq+MpNW
         As7FIotfnDc8YfSYp8eCugw0KlJrZIcTzlwCpyvbmZ8Vuuro5MEUH7cayCez0pX2JdKD
         Zvt1xxtMkc/p+RRUyyX5EdoPZROIlDNWvVk7e3pMead98VErbqqpr0B4KEYaeJL9p0K4
         2YhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177367; x=1758782167;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VFjH+4iKezMx9taew/P2Pp2wCahAKn7daFaD40BNcwI=;
        b=cdb2P4Blz2ZAt1m5pIpug333SYyhQJ3Nm5JeDurWc2XNk4+Qc1tVvMIITrAxuMmP0i
         F47Pfy2UCFBNw2Q3CqnohYNUtKCr349UfwdTGTzpdwcDPKdAJwztGwpyD5AHJyNaRm0a
         JZ3qrsEYaovmwrxOB4vZskZkctyaIsVOYiymliODEU1hEorckv4mqkRHO8qHgFpaVZKw
         wmxpz7yD19DA0lsve1dfVK+Uk1XzJewMTXMBAM8jYbZAQxwaoptH95N6Adn2z79Eelb3
         DgMOMSN73NuqBsrktVfoF/86phIOFGgSdaDvTW2ENhjXGmYBUmm7FEd/HxRLjXhIo5rX
         62tA==
X-Gm-Message-State: AOJu0YzDKkFRL23AsE86w9BZSpLEQk8DtZFk0tUNScDf3vIGi9ZgScgs
	SsYcTYymdyLHicKXJhFhJzrH8GFEyE9eELJnaln+vGTnMg5AJDBa5LRuifz40BwrE2r4GWN8+Q=
	=
X-Google-Smtp-Source: AGHT+IH2UgG37umNMoeACtGTZ7/9BuSZf5nN5MC+UZpNd1hrMGzyvC/NPJGsd1QclVocKHX2GkTc/eq3
X-Received: from wmbjg18.prod.google.com ([2002:a05:600c:a012:b0:45f:28d1:7681])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19d4:b0:45b:8f5e:529a
 with SMTP id 5b1f17b1804b1-462031b1dfdmr44345345e9.14.1758177367559; Wed, 17
 Sep 2025 23:36:07 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:35:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1640; i=ardb@kernel.org;
 h=from:subject; bh=rNO7lD/OuznN/elc7/2TihvZkB/fdGPOYNhJzbseLp0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeP0CpsE7vV2ez+u1zTqWvlm66PI7v2vzq858OP34VDlH
 RdSd7CEdJSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJXNZgZJi8acHsj1ffLuVk
 fL/bXFd9jZnTm39O0idV/Nf9jMhU6bJm+Ge14c5izX+7hNeL3t5mGNO5U2iZoqlY/rFJqrp8UkJ t+dwA
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918063539.2640512-7-ardb+git@google.com>
Subject: [PATCH 0/5] arm64: Move kernel mode FPSIMD buffer to the stack
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
context switch out of struct thread_struct, and onto the stack, so that
the memory cost is not imposed needlessly on all tasks in the system.

Patches #1 - #3 contains some prepwork so that patch #4 can tighten the
rules around permitted usage patterns of kernel_neon_begin() and
kernel_neon_end(). This permits #5 to provide a stack buffer to
kernel_neon_begin() transparently, in a manner that ensures that it will
remain available until after the associated call to kernel_neon_end()
returns.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>

Ard Biesheuvel (5):
  crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
  crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
  arm64/fpsimd: Require kernel NEON begin/end calls from the same scope
  arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack

 arch/arm64/crypto/aes-ce-ccm-glue.c |  5 +--
 arch/arm64/crypto/sm4-ce-ccm-glue.c | 10 ++----
 arch/arm64/crypto/sm4-ce-gcm-glue.c | 10 ++----
 arch/arm64/include/asm/neon.h       |  7 ++--
 arch/arm64/include/asm/processor.h  |  2 +-
 arch/arm64/kernel/fpsimd.c          | 34 +++++++++++++-------
 6 files changed, 34 insertions(+), 34 deletions(-)


base-commit: f83ec76bf285bea5727f478a68b894f5543ca76e
-- 
2.51.0.384.g4c02a37b29-goog

