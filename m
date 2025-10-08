Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9782FD7A8
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938431; cv=none; b=IXjJ1bcZuGim86GnlBUOYMPKNM+GIzo4qkTubGmXS6a6O9BjDqDPDrg4c3Io1X2NVB80ts+ij+OfQBoqBzPwpihcGHUW6xVGEeKW4Qf8sKfMgabgCGIkDXp164L+HSoZlh/1maqlVfZX8prwo4wTrJT1iFaWSNT5yagODmCKtrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938431; c=relaxed/simple;
	bh=5G4nFD2pp89m/e0LNcJVsGUkoysspkzidmC0Tj5QN0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j6X84I1nsl6T697ANWiKZ095YdMKO84v37f3zXMTTAq1sOdk+2l6uZaRV48DQ5z8BKkBjopguKHeDct8QsaT61iHfjG1iwgNZqLbKgxf22vcssTlKxUJ+ZB3bWyEZ4yuSu+sC5Av3SItqpbh/K9tvG/tYl3pZmnkYfcjbdQby14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aEWOMFG6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aEWOMFG6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so29677f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938428; x=1760543228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4d430to7F+bJwYs62ijVveUJQwYq/Bl3TbNr2srG04A=;
        b=aEWOMFG6R9p/ynfLbkMBJn96ejp7MPOkQWaetVSliuln2Jhgi9SRP9MbIagqrBYdlh
         oSzESMOYfsbRkIoNvsrAkD0hgTdyRoLYDtF5pK22ew7yIHIs3za3pEFwGM8CjF8Wjyd1
         3hvBvLN86g0OvHGFYRHaOnPl2WuXSExEwdVKdJftToYSNcKqc7fH5SiiW6SVF64KginQ
         u6J5xnEZpG/sB9B5iZvXBjh+mRpG7CvA7X01ppZqcawDox0px6CvJpRZi6j6GnCmP6nx
         QHwFD7D/5mmzc2+emUcYEsAAJyaJr4i+j4ujXxT2leoJdH/V8hRPAVycaNEm4IZSC69Y
         ObXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938428; x=1760543228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4d430to7F+bJwYs62ijVveUJQwYq/Bl3TbNr2srG04A=;
        b=ZlVCxFZ/RlJxQWUwsnhxf7YDVmT49v9rrCz5F9c5FHw76kKKm7497QG8veGIPFfhdn
         7DnZGc+yPTzTrp34FiIlveiKdMvvVxYts/YsWRQiWCL09glocJxfVz2fnHi3WQdkFLOh
         3RyN7YjeppRXCQOpNOo2RD3hkVskb1rC2ytFFqLvt2rhHoL6ctQlwVMu0s+J2m7owLZ2
         wNHkRb1CSFT4hBDgxyRpL06dcDhIvaRj2JTkToKkEmt672nLlj4wS3sQmFu4XT7YadNv
         9tXze/GZ4pso4ywp/Eqvl4kqB0ANWJpOwVCnmIYSOKpflQ/olyrZkPDl9q3fHntrt3WJ
         QYlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXheP+lHa/ZqVSEtKTlhor4ke5WIoTUYJFzc40tr0649UtXwFdLXpMoYsFTUk4QOWGsCiHwCOU8opvjcz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTlxxBQdDm6LH4RXrjtBQQ2PLEUXjpUFmVKrNeLCwpXQKfX8uN
	7WUCEnNTpaZZUZ3x/sVSAoTmnOl3OVeg6U6MQGczsoHe4mySmGmy+2whtJ1R/lvK5x/GUqdMAA=
	=
X-Google-Smtp-Source: AGHT+IFxuPNcvfnI61ScnGz/kEaKdHt8OBEaJHISLPH795AUUxCAL4+HW8dxd6WipTwVX9VIvhQ1077r
X-Received: from wmlm12.prod.google.com ([2002:a7b:ca4c:0:b0:45f:29fc:83d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2389:b0:3fd:eb15:77a
 with SMTP id ffacd0b85a97d-42666ac2da4mr2403184f8f.6.1759938427683; Wed, 08
 Oct 2025 08:47:07 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:54 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; i=ardb@kernel.org;
 h=from:subject; bh=jCkHQXSdf8VNipopESRILGcuCgPWNMlfZdyre0v/uHk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZe1iU7eedkh0ZXVG1KaJNn85s2LNxVn6X6HFXzp2nI
 6vrlfg6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwERm7mVkWPDjweI7tbdrJQPY
 eIJjdzxemCDdfydySVTtoncHsld9F2JkOOuxUuhE0XeuS1f/dqy3qu09MXn3XCM9na+rHyR9evz pOzcA
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-43-ardb+git@google.com>
Subject: [PATCH v3 20/21] arm64/fpu: Enforce task-context only for generic
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
index 2ae50bdce59b..52a1c513bdf3 100644
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
+	preempt_disable();
+}
 
 #endif /* ! __ASM_FPU_H */
-- 
2.51.0.710.ga91ca5db03-goog

