Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686A4CA292
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879720; cv=none; b=ljry9Erqst0c6OFfiV5vAqYbiNlU7ZLSVZct28Bb2+viZT8VQOFcZf65UZ/BFNQGduyjVQvFi5J8PGMPCoQrvNDHuI76emf//qwSBCxqAkFCmP1GBfuysbDei3x+Dpo/oifLDoxtMZe/LjTQWpEl8Dd4UfI9P6ISAR+aDIPhWek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879720; c=relaxed/simple;
	bh=Zcwz++VNrXh9y6soBYCC7hxdmV5RO3C0KhJ6H3w36Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwhSXwa6UekuEqDk09j9LL/7TnSH4IMedKgx2olbsQ6HNzhxRxGo9zkidAK9b/HgrPD4G0gb8v1S5wGKn548kM4UxJBvksJ2ZOaSnQFOF0Wi2jlZmFnvzC5cefK1Pt5UgB19C7rKpYLAZcm67ggIsZBf6AqKPklt4cxWlXFY6k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pS456OJH; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pS456OJH"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2f0d3e07e30so1352951eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879718; x=1779484518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8RkPwRSQGNgtwFGhMa45mhqNtBX9nLmlB3IzWi1i0E=;
        b=pS456OJH1AEeHSLqDqw4ui/jbQksci7GOMA5UlZbGUKa3b3cKwqxQ6MWm5xwlX57PI
         IZDJIMG8QqVi0ayPNo4/ypRXZdgRlhu+XjkAk73EqC7nB0IRpSRqGXxoy8vQd8Bgt0CQ
         WzXiDAw6KrRaOGBb/z0v7a61im0dlEScKq/wb4E9/cTIbcx67pmRYk290CD9S+K1KRL/
         l6Fry/b26nnViZfxl9z6fED8dgvP5m7O9o1LjTQeMg92Ky/sK7+4svsAdj3UWxQlrHwX
         SF0UYmimTDOTR1kBR9t4IKWksrJIgXR9XanS7ZoycxoKXpmFEuhgVKLoq5LCGKnBYZTA
         SWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879718; x=1779484518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h8RkPwRSQGNgtwFGhMa45mhqNtBX9nLmlB3IzWi1i0E=;
        b=TYHF2PoEhqLF69ipMpBI0Sy14PBx5cU8nw3Xzolec5ia0d2w0bsSkNQcCLGcSKwnYd
         teijS94DYiw56V5t11Wuq0KpB9tU6eJoLxUezx5rF0iAIK42HKFUzuXUjbBDfZH0ZgRM
         vjxEb0a7pqzyjzMvPDIa3RlVPR3r9BI1sJhxxJjwY1cPj0lMH+b+zrjJWgg1q8FflyCM
         bkHkTHj0qCfvYFqZ2hp9ZbaTOwS5O9yQCEa8ULSu/FYm7AArjn5ajCKKmRJay2Mo+lEn
         MPoLHof4z55gjvA1hNDZa0fO5zjp4nSQtuBZWdqqCKtFb+12El8ghLxmBaM2pqxLI6KY
         ZojQ==
X-Forwarded-Encrypted: i=1; AFNElJ/r1PAWY525SBUxG5eaPPhRqkPj1LA1De1igIkx804bkYrwQ25F9cH7OQE9N+wErXmEwMYsyUAo6GYHeaw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzilzVb/HvGKlPDLRWK1cRzrWIbrUHQ6Wu8ZOuTaZQgDq2OYO0c
	x/PmMg/L/YU7p7gMfKLTLxto+oFxbpxwnot4N9mGOHFDsVDF99QuzP+W
X-Gm-Gg: Acq92OFmIPPakK94ykf1usX+WxLfWngEMpk1w/fuevDWXATsXOJZLSxcG5iiLPOWanY
	NHEzOEDCHQYdBAD2eH7rKBfsIKVnTJET5YbrnQ2T2hkh63oUZnqsk8RjL9C0+FePgA6+Lg7UgGS
	jiJDqEXQf8H2esS1lAYrIfmkKLzh/2NPEE/bpYfOuaXcDRTRYNI9UV3BdxlNsdT+Uo5fYRbmbYR
	4aSvJSicL28hvczk8cmTTGQmQ3xfaOaU6QLDZJc27NXqgCwKdxXzOkIiR9GQUgETBHu5bjOpdiG
	pooIwCKMrkyDAMbfXGJxHsgz6CR5/UN8hczm8A7WseJaIzfmyIh0HyDWDY1kgVv52qUfh/gPnHi
	WWM7JZek+OjdgbD2sI0zMI7sfkB1R1GvhYFvy6hF9fsJGTgbPWfKtP/P8c1Vtp7z6zksTVIMSuy
	jKwinP3oIsP9Zp/Oe4vs5Gqx44kn/RrzY=
X-Received: by 2002:a05:7300:ad30:b0:2e7:5737:8364 with SMTP id 5a478bee46e88-303984e17ffmr3028118eec.15.1778879717789;
        Fri, 15 May 2026 14:15:17 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302947e917dsm8005268eec.12.2026.05.15.14.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:17 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 23/38] x86: Allow WARN_trap() macro to be included in pre-boot environments
Date: Fri, 15 May 2026 14:13:55 -0700
Message-ID: <20260515211410.31440-24-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For pre-boot environments, do not use the static call definition of the
WARN_trap() macro.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/include/asm/bug.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 80c1696d8d59..7899768ae644 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -138,8 +138,14 @@ do {									\
 #ifdef HAVE_ARCH_BUG_FORMAT_ARGS
 
 #ifndef __ASSEMBLER__
+
+#ifndef __DISABLE_EXPORTS
 #include <linux/static_call_types.h>
 DECLARE_STATIC_CALL(WARN_trap, __WARN_trap);
+#define WARN_trap(...)	static_call_mod(WARN_trap)(__VA_ARGS__)
+#else /* __DISABLE_EXPORTS */
+#define WARN_trap(...)	__WARN_trap(__VA_ARGS__)
+#endif /* __DISABLE_EXPORTS */
 
 struct pt_regs;
 struct sysv_va_list { /* from AMD64 System V ABI */
@@ -172,7 +178,7 @@ extern void *__warn_args(struct arch_va_list *args, struct pt_regs *regs);
 #define __WARN_print_arg(flags, format, arg...)				\
 do {									\
 	int __flags = (flags) | BUGFLAG_WARNING | BUGFLAG_ARGS ;	\
-	static_call_mod(WARN_trap)(__WARN_bug_entry(__flags, format), ## arg); \
+	WARN_trap(__WARN_bug_entry(__flags, format), ## arg);		\
 	asm (""); /* inhibit tail-call optimization */			\
 } while (0)
 
-- 
2.47.3

