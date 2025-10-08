Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D37C2F9C2D
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938416; cv=none; b=dPElzgrkmpSrZtaarD1vcKdBCo4/A9w9ejEXVyhJ5ed9PrRwLz4vdEWN40+NDV7YK+PuGAJVCRAKXWCLdfEACwStCuVde2cUjWV0AyiSQPwf6ZRQQ0dhOae+H8V0CgJh3zfx9kReaM02yyL0wlJEHpacRYty0PlOACFscD52Yoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938416; c=relaxed/simple;
	bh=OKa7e4VZ6Av+L894vcBvYIq2RBNlaMFytXrCMa0czDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OACP7vtbUZQiPgPNaFECsvFJrfzdIkLKkby4IEOieC79+D1PgR72OEG+7lnRn5BYQoLZNc8DdrHyaSaI8JgUU0NkQcE4IzfiNV5usqQ2rDtH+r47WOOLQHxdVfI6qWc1kO+HayiRL7QvTsZX2IQQyvuTBLIPL34D5Asi5VUmSfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BPqc/rWW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BPqc/rWW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso11175e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938413; x=1760543213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgOp7iaV/RaDAR+GphQp+dqI9mVhhh2Ps95uPVoCH/4=;
        b=BPqc/rWWeJBHtdbUue2iTisg3OlFcQRhWVjic2ZeyYukW/SlbTt8UtcnJfHQTpSF3W
         q+VNTCCcWepW6PxcK5LIE3xDsnSK36haqSzBwVOW8pUFOxvetRC3UP1qLpCxpGs2lOCy
         MQY/ZTTqiVmwrvgXhE1s08CRs76bqMDMfSgodoc+n+Fdd5dxBbJsieeOto/MmIB+/eIs
         lYV7AF8xaiHEqWHSZoSO+HEhL30kxwXx0eQXUFkY4VlOiXiiQFihWgqTPYJ2P8FPHuoM
         FsAW0jcO1Ee9DlzQ3B64aHQVmDs+j4vSCydDyOU9dvuM2ZymrccyBS2x2DquM8xnN9Bm
         Khug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938413; x=1760543213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgOp7iaV/RaDAR+GphQp+dqI9mVhhh2Ps95uPVoCH/4=;
        b=OfVyNREJ6MNJWiuCDCVLKUxas88GEM3JFfc3PYniGMOQ86lNoziYhn2mYwxLhl5l65
         WeJpJvDBSppjL5ZO5MI9VNnIE//TbjHM43/GpEGoh5cnGlu5XbSmcOkNPf+YRP8zH3tD
         EkQmEHKCNUJaGpfAjE0PU4ySUsAfVcZh4KxhutoO8a71GKtRvg25fVc3nv+kP7A9pc1M
         uFFzu7c6Fh5JYrj984WXnGRR6VFBIGoKHPmEo0lwWVi+g9GH8/K5pUsw20NOMyOc4gaN
         mow+9F0C+niW/RsWJHZ2A6nv3os4VgdBcfkAx3p42KtQdJd5UHzvS6jx1FVUfnl5Awbw
         A1pw==
X-Forwarded-Encrypted: i=1; AJvYcCVzUX2OulkrvU/6EzcB5oUT27+4/hcrpAnECtROSLJpexq2DNITvupAT4A1j3LkGCb3wO79mFyY6SyByKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YybP7DvnDEMUO3/xlVZmpgTMQpICfIh/De6Z/eF7FTPs3bIWX+X
	DIFkMdSFfiiQqn8vHnZ9GIqqJzotxAwKT32znhItyX+kaaE/Z2NTYIIp5Je0fSknUikh4w3EAA=
	=
X-Google-Smtp-Source: AGHT+IHnmMnb0RKyaZwccpLn7QM/pWxbFeikk4zy0bIG8pjPiMhw8Qcfv9JNIYTDNAkRKG1Td/av8bhJ
X-Received: from wmbji6.prod.google.com ([2002:a05:600c:a346:b0:46e:1b05:b386])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4753:b0:46e:1d8d:cfb6
 with SMTP id 5b1f17b1804b1-46fa9af0621mr24939175e9.19.1759938412947; Wed, 08
 Oct 2025 08:46:52 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:41 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3233; i=ardb@kernel.org;
 h=from:subject; bh=S7UkFILzssk2NqWBV2TXMFPj5Ekrt9RH75yk9Qm+UwE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu1F00hLnn+/fFUZJ/WdX51zowZrIPy+rUaZ34U/hZ
 wYnLvzpKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABM5upSRYfEi+fKcM1LLv9Rb
 ZLq4XVr5tUNinm6e3b6kR9wpF7cdN2FkeC7925hr96WfEn2XFhRqveJla9PxyjRiXDKv52Pr498 HuAE=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-30-ardb+git@google.com>
Subject: [PATCH v3 07/21] raid6: Move to more abstract 'ksimd' guard API
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
2.51.0.710.ga91ca5db03-goog

