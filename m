Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605A620B21E
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907193; cv=none; b=GfNhOfauJMUa6qwD/w0rBRh5plGamEUdMRH6IBAquoIGQYEKV8kfR+48GAHCf2kelDUf6FvoGUg+jKKMSQxKtULezOGJ6pk+atfQBz2rm5cn0vDV3CXy5n/ILdtyCh8iRNTLp+fWWypXtrcE09JEqF988qSZHWQVoWL1UNQmW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907193; c=relaxed/simple;
	bh=1sGjwL/f15WqDxjZ6B3QjAhT4bc84EG6TafOD55kaSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dwmg1asvAscJZnwhagKsX0Soe8LrG1P4mPKGYEk7OkwyX/iBaRX2hmcRIiavOOI16EBb7/UuXVm1Npp2H4nhjPa1sdoQVQKSP8FT9wBpYyFV92fkMaqszRoUWibUSVlIJm3M09aSY3m++Psn1WA/5MOobpPz3Xjhu5jZNQV6P78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtPJQ/nQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtPJQ/nQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-475de0566adso16709755e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907190; x=1762511990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFCvTIOsXSjYhMkRl4dIW/P5UlNb2kn2VBhE2xHZEzQ=;
        b=jtPJQ/nQJD9y0aHUBdFQAhDSCy+SNzqehIQsnTIETl/qJc8I02ZYNKIXJcDDY2PSN3
         v77OgSFb85mfDhFWeCh+/rsRy7RahXmQiPvgCvAfVqHF1DhB9ObFbO3mNq5Ng0JD2u6p
         wus7zDva2pjRUNWswp/KZCQ6jTSSSjJV3428YT+3sQf6cZm5ZOy4ghbQI1pGEhQGwGLH
         PJjr/yxg4f89KSO+mwowef94iPqUoDX8OGqgpAhlNxQTsiWmME4NCvHrsAglMJwq/f/b
         OPRSfVnemUaz3yqrCqZJN9oc/P1zSHvmgOLIMVQdbtSO91z1XtJOnWD1X5dE9lHJhLPn
         eSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907190; x=1762511990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFCvTIOsXSjYhMkRl4dIW/P5UlNb2kn2VBhE2xHZEzQ=;
        b=WfedCBzRwL8rJ1z0aCxUs6N2jYg7CYTdt+PVALs4pbiTseyHoo+05eYgAEMG6QYb8F
         e7dKEfuDlUzgQiF4jI3eN8uOxI8bQyWQrchCLD8L6QjArWJEXiquM6tXfc36F7/INqmy
         O1bIYJZIVq2L2Ne1x2GowdZexkiGun7hRD6x0RKddDN3tzZbev1VI1YzHx3HR35qlSaH
         KxsHZm1+k9nArXsEJVCJXfg5NEW7OcG2GxumiY5BvF17tCiT0b+PZ3VzSAwJgcdW0e7u
         sdMfb3sF0tyGwly8xf9zHSMda5dRsxJsUKgKooRUXMU0ytH5Kzw/pdmSWUR5nYZuxlVm
         58og==
X-Forwarded-Encrypted: i=1; AJvYcCVHyYwV/UUSW3MPM2KFud9jdPXH0WN7POl+1QTEL2oHHn7Pi2iHUclIN93CYl5msnUZBMDn8kIKUNDF0v4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys216IPAswgHP18mDkqNshKCRHlOwV7PId8WZJMoy7rJYgPJOO
	ZLAp5zDJCFXxE62nPqanzSmXcCBxCbDLF4a9ZgDDTdWz68Mc3xtqgiJH1t0N9OIYkX+9QTQn3A=
	=
X-Google-Smtp-Source: AGHT+IHWFYs4QMEYXdlkbsATPtP+/gZ1YWrkitgykutzLvMorl43xTdKzAxhRGPUNTRTOeWGSSSeXYsY
X-Received: from wmcn22.prod.google.com ([2002:a05:600c:c0d6:b0:46e:1f26:9212])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c16a:b0:46f:b42e:e39e
 with SMTP id 5b1f17b1804b1-477308c60aamr29196925e9.39.1761907189938; Fri, 31
 Oct 2025 03:39:49 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:03 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1521; i=ardb@kernel.org;
 h=from:subject; bh=94iSyJlcyEo5KVonam61v2/twjbge67xOTFdxdGB8QY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4kmfrSk5Qpcfzl42UcROjqnaPjK96+1NWR7t6X8Zu
 kS0Lh/qKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPpTGH4K3/s/uZKlaPzZ+Tu
 2nPn9NXVy6bU6yrM+VGz+seS3o+/WE0YGbYbSc2X5uHX85V6cL03YfU0mwtcZ7oWJ8kw/G1SCn6 6nRsA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-27-ardb+git@google.com>
Subject: [PATCH v4 04/21] arm64/simd: Add scoped guard API for kernel mode SIMD
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Encapsulate kernel_neon_begin() and kernel_neon_end() using a 'ksimd'
cleanup guard. This hides the prototype of those functions, allowing
them to be changed for arm64 but not ARM, without breaking code that is
shared between those architectures (RAID6, AEGIS-128)

It probably makes sense to expose this API more widely across
architectures, as it affords more flexibility to the arch code to
plumb it in, while imposing more rigid rules regarding the start/end
bookends appearing in matched pairs.

Reviewed-by: Kees Cook <kees@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/simd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
index 8e86c9e70e48..d9f83c478736 100644
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -6,12 +6,15 @@
 #ifndef __ASM_SIMD_H
 #define __ASM_SIMD_H
 
+#include <linux/cleanup.h>
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/types.h>
 
+#include <asm/neon.h>
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 /*
@@ -40,4 +43,8 @@ static __must_check inline bool may_use_simd(void) {
 
 #endif /* ! CONFIG_KERNEL_MODE_NEON */
 
+DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
+
+#define scoped_ksimd()	scoped_guard(ksimd)
+
 #endif
-- 
2.51.1.930.gacf6e81ea2-goog

