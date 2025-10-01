Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA07C30FF25
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352640; cv=none; b=FGTvQ19TK3+pX+sw0gW/xi+6d8kfg5QvZtenQXlr0QnS5F2v6+OY8oU7djOL81BUs0lRSZ+icMRzrE/v2Z+vB264O/ROQS196QT0n8jBbRWg1zWKo0ugZF84pFxo0KmlH4Vk44cIrOCCUs6n03+wTDu7J4QgqOOIN7eVj4FykqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352640; c=relaxed/simple;
	bh=nadp2g4HyADqc9HwrCLpsPTlFfrdWtCsrrf5SqzqoPY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ivZOqwOb4Sk4NhoW37lUO0wipGpjWFucTSMJRm5trDVsKyYhYtMQgk+EnWo44DZmnstLhLzqjPtMlT/DPIjlxyIooENfQ7AtCYmMqsB0CTsstGfiW3FmJdJWcZe88pbHFwqk6iuCuXLjTxUrZTs7cr1W3podG+HJho8EbS7/QdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jVV2aSE7; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jVV2aSE7"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aff0df4c4abso45839466b.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352637; x=1759957437; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nLN5jr5EZSwszf+F9TmirI7MwTEPAK5WzBEEPFGFb+c=;
        b=jVV2aSE7+z4M1GA169jDvqZznvrLuakEEvE8JVEaB6RCO3PdIH7227PyVGfWkLduwi
         mplg5J3t9n/s2OWHnCHjARQPfkM3iZEcjbOUWIcOWGgRhjiaKUxHf0MtUuf0I0L0WcxZ
         2l5Ybx1H14BNAR70nfGjxDnhUuI6hKtN/ppOpyfZz8/f/Qitp2VVIg8mgWYapEplfCsQ
         JdP0jaK3q+tbxS3yeqbgowHqqtbDWeqDj/NEp7uGQ+Jr7N+lnMYvtWCBqJbjw1jC7NGd
         4BMXjaHRnNVN/0y0D+lIDtPhPl1jm4KIhz/nCBEB/CtFgXl1T90k0TIKEs9PhxdtBQHN
         4ABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352637; x=1759957437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLN5jr5EZSwszf+F9TmirI7MwTEPAK5WzBEEPFGFb+c=;
        b=NQamaZxFj9OCp0YAUqr3rJd1riMxnFqzYGWJ74lZYDCsY+t3UJq/PdDpFr3aPj7/AV
         +RVMBYFjEpkTK/NGifM1cOn3tP30qDycVE8DRBQKz8YnRU2Vr2sGIXt2pDp9ADRj5fMf
         s2iFvnVglwHq4UkcaZUEwYsUWRucbfCHjuKfD7gHsxPcIJniOLkUmkcj8rEqzPUyfzNz
         ULlKnZS8cRO7A2WkjrHKPa0JPufVJ6pK/bMIjvNaCSgPI0rO5gcjDe46Q0jfVddnwrs7
         +mDcCyOmUYfVKgEoW3tqTmVeeBlWpI/VwVX0yPSgZfdxrZnAX+Z5hPLpGop/0bIBm86i
         JrUA==
X-Gm-Message-State: AOJu0YyUVEnTdzc/S0sytq8uvLlrb8TJxuRic0oIRM99uGeTyh3KbY+O
	L+I4+TOR1Up0eD5wQ/VXb3743lxJI4siWJS7NnEnDee4UwfuW/OhbDs1XJAAH9lV89mk3iIsyg=
	=
X-Google-Smtp-Source: AGHT+IE/5dzsYm+uKsCA7BqxixvVFjLG0cblUGfuQzl+SHoar/yQvT4DNAxneFAQwNCEwxJSwxiGrNJ9
X-Received: from ejbgx6.prod.google.com ([2002:a17:906:f1c6:b0:b3d:b7b8:e443])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:724a:b0:b41:abc9:613c
 with SMTP id a640c23a62f3a-b46e97621d3mr576098566b.51.1759352637265; Wed, 01
 Oct 2025 14:03:57 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:07 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3184; i=ardb@kernel.org;
 h=from:subject; bh=gbq7vX1V656Kd5zOXbjYzxNSx5HVr+W5CHBw6KSs3yM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutAd/TfvXOrnNLdzMmuP5wDbmqvKCn8Y7b23smLTMO
 eYwY+nPjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjCRK48Y/ldUdS5R2rJRRfXS
 RDOpUsODP9J6kjct2vbf13Ji73OtackM/0vYOs/H38s/k8jeMbdyy6Hvl1ee9mG9fkrdSVhmk13 dZVYA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-27-ardb+git@google.com>
Subject: [PATCH v2 05/20] raid6: Move to more abstract 'ksimd' guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move away from calling kernel_neon_begin() and kernel_neon_end()
directly, and instead, use the newly introduced scoped_ksimd() API. This
permits arm64 to modify the kernel mode NEON API without affecting code
that is shared between ARM and arm64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/raid6/neon.c       | 17 +++++++----------
 lib/raid6/recov_neon.c | 15 ++++++---------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
index 0a2e76035ea9..6d9474ce6da9 100644
--- a/lib/raid6/neon.c
+++ b/lib/raid6/neon.c
@@ -8,10 +8,9 @@
 #include <linux/raid/pq.h>
 
 #ifdef __KERNEL__
-#include <asm/neon.h>
+#include <asm/simd.h>
 #else
-#define kernel_neon_begin()
-#define kernel_neon_end()
+#define scoped_ksimd()
 #define cpu_has_neon()		(1)
 #endif
 
@@ -32,10 +31,9 @@
 	{								\
 		void raid6_neon ## _n  ## _gen_syndrome_real(int,	\
 						unsigned long, void**);	\
-		kernel_neon_begin();					\
-		raid6_neon ## _n ## _gen_syndrome_real(disks,		\
+		scoped_ksimd()						\
+			raid6_neon ## _n ## _gen_syndrome_real(disks,	\
 					(unsigned long)bytes, ptrs);	\
-		kernel_neon_end();					\
 	}								\
 	static void raid6_neon ## _n ## _xor_syndrome(int disks,	\
 					int start, int stop, 		\
@@ -43,10 +41,9 @@
 	{								\
 		void raid6_neon ## _n  ## _xor_syndrome_real(int,	\
 				int, int, unsigned long, void**);	\
-		kernel_neon_begin();					\
-		raid6_neon ## _n ## _xor_syndrome_real(disks,		\
-			start, stop, (unsigned long)bytes, ptrs);	\
-		kernel_neon_end();					\
+		scoped_ksimd()						\
+			raid6_neon ## _n ## _xor_syndrome_real(disks,	\
+				start, stop, (unsigned long)bytes, ptrs);\
 	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
 		raid6_neon ## _n ## _gen_syndrome,			\
diff --git a/lib/raid6/recov_neon.c b/lib/raid6/recov_neon.c
index 70e1404c1512..9d99aeabd31a 100644
--- a/lib/raid6/recov_neon.c
+++ b/lib/raid6/recov_neon.c
@@ -7,11 +7,10 @@
 #include <linux/raid/pq.h>
 
 #ifdef __KERNEL__
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include "neon.h"
 #else
-#define kernel_neon_begin()
-#define kernel_neon_end()
+#define scoped_ksimd()
 #define cpu_has_neon()		(1)
 #endif
 
@@ -55,9 +54,8 @@ static void raid6_2data_recov_neon(int disks, size_t bytes, int faila,
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 					 raid6_gfexp[failb]]];
 
-	kernel_neon_begin();
-	__raid6_2data_recov_neon(bytes, p, q, dp, dq, pbmul, qmul);
-	kernel_neon_end();
+	scoped_ksimd()
+		__raid6_2data_recov_neon(bytes, p, q, dp, dq, pbmul, qmul);
 }
 
 static void raid6_datap_recov_neon(int disks, size_t bytes, int faila,
@@ -86,9 +84,8 @@ static void raid6_datap_recov_neon(int disks, size_t bytes, int faila,
 	/* Now, pick the proper data tables */
 	qmul = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_neon_begin();
-	__raid6_datap_recov_neon(bytes, p, q, dq, qmul);
-	kernel_neon_end();
+	scoped_ksimd()
+		__raid6_datap_recov_neon(bytes, p, q, dq, qmul);
 }
 
 const struct raid6_recov_calls raid6_recov_neon = {
-- 
2.51.0.618.g983fd99d29-goog

