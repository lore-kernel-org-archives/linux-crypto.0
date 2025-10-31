Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E13431FF
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907196; cv=none; b=pNRxyZuhG4gy6jU31L7ohYDlT8jXh2eJ0YMOxW0SwO/P3VaJDMs/ivNS4o9Unsc4lzBqdPmVM/YDeR/NMwyyWXNVN0QDwrCk/WVDMwfEAZ4UDzJ+1tH9elE4oXY55M83+ykb9cg6iTTsQJ64UipIKjEgjEOOQHgt1wsA+iyHm60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907196; c=relaxed/simple;
	bh=WgYwOMvlr+zTqk1uI7p2SkyIbQb6yGgF7pl0TkawgU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BA+lP2fdf8b39Zq6REt3o5tk4mMppugrIMLzg7NmRoLSkfetzK7YvRUgQTE6FHEYtoS98tTec2lgnBy10K2/NcERVXPI9XpY2kWyPAiiiKS4gAOJTJQU+/Jh955ILCy+nYIlSATkRQ3KljW+DbCYXa66hSp0lAxcdDMwKYo4XBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxorp0jE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxorp0jE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so23151825e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907193; x=1762511993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4RjkuRbzhzq+DbHCUcTmZHT9d6t7fanSTph/M7FrwM=;
        b=bxorp0jEoyaSuqrX2Wt2htp89/+f/W5w5ZngpeHeTsh01pTANNzTMDogcf7B3yK00W
         JnvE94VuqTDnkWbSJeopKcKqISYlRhIBBBnwC3bmPHjeFn3ijc9/6vosWEMhE7ftllx1
         DoJaK7cpTSedS+e2J6M7WZo82mKHGZMQSF8W5boONC2FTyELoWylX3DgKCvbv5S31nUg
         YPxfvusQmS0O8F1d/3i6I1TMeDTT3zVQhEGzE5zifySO4tVYR415R/SR0D81kZi/l4/j
         hrCpi5Cjzr7hQx4c0jdt8iKze/SrQFEQCT0MavMWwRolBSvGNi4wv6p4Nz6LeYLS7c5s
         c6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907193; x=1762511993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4RjkuRbzhzq+DbHCUcTmZHT9d6t7fanSTph/M7FrwM=;
        b=YfSdzjWwUs3fWCYXIZDCoZwIj3IgEeH29cegQqOE3JnCjLuYux768v0ttmC55kp5tF
         hMCli6hJ/9eCfCqvKj6tdAHWbsQAXwDVr2Ndha26JMsQeWRoqITYQe86F8X97uwp/6+m
         k+t9S6o3E9RHF38amjBAizLXjihfjc3CbUm0inAJ+DxTTymmhn+4CrOj08PqaWn/gQ2t
         UlV+8/qzfvtBKuA9Gq+4ExKZXgGgx+efmNaAjB6tnEMNGdlXJXLUp4oj82IRcmVPaGCI
         kcyg0yMzD4wtPqTCDC5Tl2U4WT94bQe+/fHjJ/4lM0BJXgDfKA7dCtcMw2Dssqik0286
         KPVg==
X-Forwarded-Encrypted: i=1; AJvYcCUu38KPBq+9t/UHQDnXQVyq+N0FQGksNeZ9K0/BbDga77/d3KbBbAOUYnG68L4eTQsNXr9QDhUbDGL49aM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNheyebOUvjWsnnzPwoZXYSgDHgoC1Mj4+mNfx5+H+guGvWWiS
	NDhUmQ4j8f1NNBNtDyZc+Z/azFtcA9HYp8aUGXrWvpy2z4EkulalDHwKOR62qaIIhekz14GBhw=
	=
X-Google-Smtp-Source: AGHT+IHVOvUG0Xu/U72ITBOpdefU2DBxMkwXD2QsdxXRJMDjdqSoWxzPqoXGu/4sUXEGYRcoh2Hw1odT
X-Received: from wrbdz17.prod.google.com ([2002:a05:6000:e91:b0:429:8bd5:a979])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4813:b0:429:89c2:d933
 with SMTP id ffacd0b85a97d-429bd6a661bmr2703069f8f.36.1761907192812; Fri, 31
 Oct 2025 03:39:52 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:06 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3233; i=ardb@kernel.org;
 h=from:subject; bh=iSbN4ekVGltGzQmP5pLZ+bG2pN1WnvqNrOwI0kB4C8o=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGkEkc3IqxaPccg6BBv5hnkGx/1bCaULY/XwigMLrW1nDGA+l
 Yh1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmkEkc0ACgkQMG4JVi59LVzG4QEAoaIi
 zu37MoBFQRoBZZ+yZD5/L9uJT55ZFas0kEqcoTgBANiP73S3Ww/wj+Epar2f+78g93ZAI/f4ta1 oEhX9xoUH
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-30-ardb+git@google.com>
Subject: [PATCH v4 07/21] raid6: Move to more abstract 'ksimd' guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move away from calling kernel_neon_begin() and kernel_neon_end()
directly, and instead, use the newly introduced scoped_ksimd() API. This
permits arm64 to modify the kernel mode NEON API without affecting code
that is shared between ARM and arm64.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
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
2.51.1.930.gacf6e81ea2-goog

