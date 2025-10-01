Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDCA30FC0E
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352639; cv=none; b=DI2Aaa1cvuOEswQRdPeK80fpUgL+S7Rk61gITYSVDE8BGx/sJ3IUT+FSuCL2DJQobh3SZxbIBFoRXBfeFmmU5RuI3Ad6GInZuHpjHK7HHb2W8TqZJW1JwCCgXXA1ar76xyLnwRevWAnGZj7r/Xr+7tt/O3fMVQF82Bi86NUwouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352639; c=relaxed/simple;
	bh=y61+7VCzNMGSMbWtXfByDo69lK0ON+BCKh3sIOEFzkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tTRkcjxWJtpYwY97RVLV9v2K7yV8jwQHwB5bFc/P5hARkKd318dMNc7RrMA4EzCpgIwYK2QWwLczQXohoLWN3FwPU+t15joW2Nriyg1s+luFstdCn9Uf90FHLwvve0fuFXs1GsOBXzwyUbom3TrjGtO2DT4LgJBRugh7mz8sdrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=joWHD8d2; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="joWHD8d2"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63214bea14cso200438a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352636; x=1759957436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=acDSbPr0ckzlJYMJhQI+twxWM3EGvwpk6VEzCJHCwrY=;
        b=joWHD8d2x1bi8PXS+1tN+EACbQ+ehuWEkUIm2UjhZdyvaSfWJyM9aHbWWZLpPmzKOI
         crWV5ykV6rIDb+TuxPIySwlUyO9ERZwuhuFhisrd3Y0rj87eW+LMs4roJks0qBTFWAnr
         2nzrdjh8Oyg4eRHBPRTLmjiPfd99jO0B+GpBhQ7TcLNOivVxwnOYEihjteRYNDWtlwKY
         RuGb5GNjVNf8qECH6+QLpXzSNTrrr971qAmq/seTTOiY/Z+r76enGEr5xayrFKk+zkzj
         ys2BmS7b47dCx9bKIT9WMOPTlLa7KE0AB41BZM9Aum3sSBtUokAD4kAMNXzaeGhewLT4
         rB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352636; x=1759957436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acDSbPr0ckzlJYMJhQI+twxWM3EGvwpk6VEzCJHCwrY=;
        b=upRvlEMTyuwiH0J6C/afzWjTpEZxWKE/QgTwJWKtopn4DZEj8rZkiwr+NNe1i4X5Pq
         S566r+eoJyQNbkHfdq9d8tmZuTLi7uCKtIXIgG3AnWSyqP6G0Bz+D2zHwKWFk9w719Nt
         bNsacZcOvTGcNDSNyQ+5UgCwxhEXmW7+I5dfNUxNoi7vdb6v5ooppx0Vny7+M6mLjRqd
         xIk8hNsFM4eqGqvNjEZ/pvI1nH/QTa5243emsksetJPwfGaAi/N4qeFJx6TmiJxWkCg7
         uezovMp0JFBnJxw7FykpxIvA/B/zSkyF94AuM/Okij9L3QYybwK4p0IuD0r7PK7MxkeW
         9COg==
X-Gm-Message-State: AOJu0YypeAF0vp5uYUt+a2V2wmmTsQSFXWhNcTWGmQUiVFF5tmmXABm0
	6crkfzWcWVUwOs6PLuccAEoXncVjozWNwcr4cDFLGDYIZRDfYp+nuVzS7C6zJ1dece4zJuRDlg=
	=
X-Google-Smtp-Source: AGHT+IEnx5RXeiL9kmHFg/RRSgpRtVYIAVUq2zDXnriSjY4GRqOqm0pZKleynTYr8BnmTOEPCHcJAcWB
X-Received: from edwn19.prod.google.com ([2002:a05:6402:4d3:b0:636:7d5e:f1f0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:42c2:b0:634:b4cb:c892
 with SMTP id 4fb4d7f45d1cf-63678c998cdmr5701808a12.32.1759352635997; Wed, 01
 Oct 2025 14:03:55 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:06 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2459; i=ardb@kernel.org;
 h=from:subject; bh=cjwJWt4i7jKdiITTdNRuozrMElZ3Ow1rsFcjCp41v6I=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutDtRV62tdzTOWvv8H6N85apP8zU+pHE0XX+8dkfc+
 XknPnrM6ShlYRDjYpAVU2QRmP333c7TE6VqnWfJwsxhZQIZwsDFKQATMdZk+F87y/Ne5BfOHc8/
 3mZY2B+3Pdrzc9G9588Cp8dLvpx1WsObkWHnjJRdwZa9pbmFmr8/W8ztFJOJlbz35bApq+W96/U ajMwA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-26-ardb+git@google.com>
Subject: [PATCH v2 04/20] crypto: aegis128-neon - Move to more abstract
 'ksimd' guard API
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
 crypto/aegis128-neon.c | 33 +++++++-------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index 9ee50549e823..b41807e63bd3 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -4,7 +4,7 @@
  */
 
 #include <asm/cpufeature.h>
-#include <asm/neon.h>
+#include <asm/simd.h>
 
 #include "aegis.h"
 #include "aegis-neon.h"
@@ -24,32 +24,28 @@ void crypto_aegis128_init_simd(struct aegis_state *state,
 			       const union aegis_block *key,
 			       const u8 *iv)
 {
-	kernel_neon_begin();
-	crypto_aegis128_init_neon(state, key, iv);
-	kernel_neon_end();
+	scoped_ksimd()
+		crypto_aegis128_init_neon(state, key, iv);
 }
 
 void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg)
 {
-	kernel_neon_begin();
-	crypto_aegis128_update_neon(state, msg);
-	kernel_neon_end();
+	scoped_ksimd()
+		crypto_aegis128_update_neon(state, msg);
 }
 
 void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
-	kernel_neon_begin();
-	crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
-	kernel_neon_end();
+	scoped_ksimd()
+		crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
 }
 
 void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
-	kernel_neon_begin();
-	crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
-	kernel_neon_end();
+	scoped_ksimd()
+		crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
 }
 
 int crypto_aegis128_final_simd(struct aegis_state *state,
@@ -58,12 +54,7 @@ int crypto_aegis128_final_simd(struct aegis_state *state,
 			       unsigned int cryptlen,
 			       unsigned int authsize)
 {
-	int ret;
-
-	kernel_neon_begin();
-	ret = crypto_aegis128_final_neon(state, tag_xor, assoclen, cryptlen,
-					 authsize);
-	kernel_neon_end();
-
-	return ret;
+	scoped_ksimd()
+		return crypto_aegis128_final_neon(state, tag_xor, assoclen,
+						  cryptlen, authsize);
 }
-- 
2.51.0.618.g983fd99d29-goog

