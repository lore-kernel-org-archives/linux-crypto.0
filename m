Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11331065A
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352643; cv=none; b=LcXwcWvSBblO5X+KKuyF4o9pzGJ9VIGxkxF/bCuvb44D9a7bL6GHBoEl7VxHK3awRC3cfMce7JO3YCiNAQSdVgiyB/k8xcPzGeDfqbXTj/Tn/pH/PIVnHwwxJvPhlGfGT2S1Cc/pw8fM2kFmCEhpMquReJgU3rIHjE8Yhffqw1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352643; c=relaxed/simple;
	bh=+MReetO5lOEq+ENKq1vyXwob8BhS+VD/ZAqXqiNcwSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iVb8hZCKgWYJgLPI+O95vvJwVbPqAGNXrmq1YDCf34TXJoQNmRRedW7CKcYyycWYNFGlLUf8qiwWcQt2zp43QaQ+iMvKzcEkf+UAv5xTouCc823H+lWInMCj5h8r0bEhBzXgdZlcBYEAGccs2TA139qEzmwQKxIwVrgz7kQ07fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fm5dCh83; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fm5dCh83"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f42b54d159so125450f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352640; x=1759957440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKVgCyEYUlEYJnl7IzVVeeoQQVhKM/SWcfJ5A7yRcl4=;
        b=fm5dCh83lLBqxcTwL72MOpunDhd7CLCknZBefrVd0m5Lc0Xhj/0cWjeaV1LEnWqNh1
         wjlfObIHEPqW038ECtx3S3egOhQ/PsqI8Y+y/ybcQGCG/SZdM4Np7QuoTIcf0fcMWLKz
         C2QnzmF/oQ60hRjMbhqH4TOSlpIZmS8H5QCfGO7yoRqN34arxl9XTmysIcDSf5vR0jzX
         N2kAfwsj47aGSM0UrRRagYoONm2aZtPRi2Yw0Tvu1q56IiqQcAYwXQzIoaMoC69dgns1
         yOlKBltbXYSCZCKiQW/EyIJAeYYdGCktVNwX+R19dhh75uCPQzWIXt3TfyaoHzCjCsGa
         ibrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352640; x=1759957440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKVgCyEYUlEYJnl7IzVVeeoQQVhKM/SWcfJ5A7yRcl4=;
        b=UquqJKI/7q3/4jwMaqMpZmumIdj91myCzSjOLE1wnWlqt0yOEnRtd+gqWYaSb2Y39w
         2n9DZot+pzk/IrrlnFU43CzeXPsbTwhklPmx4s4eIBR8lwwB//LeeGgICzYpR3i1QzkE
         IDjqc/mKKqj2El9Kc29ePYpmIgLQZ4CBHlI84WnWwIHeOe/ulA4eR9R0jsQGMXDx11HP
         nM0OZf/OHgpHGmrFfYOLottzj8KifRmOEOggq93E34qGUapDwvwsd+9c5qtjKI3ZqtX6
         1o7UloidkIxn97Up+8DadwoQIMBOzudrNRedhG24IWq9eQHMKc1p1052XqxRy3JKocVW
         ZSUg==
X-Gm-Message-State: AOJu0Yz09gsEZ8adMfWjy0qN/VJvYN/1NjfKGZfn3GspUlWTC5OIDYKj
	ptVfaCjZy/e2i20pu3zbMc2x8fGI2LZhkhh5qseOkPpmlCeT9Ei1IL4Z1TmHH9d+QL7h2zhsBw=
	=
X-Google-Smtp-Source: AGHT+IHDmr/Nj33e2mS518oZ37yPaOtdq4b9XOTrdSeSEajRVgzVPmNn2xLCvIBcNV1g6wzgv51cRxYJ
X-Received: from wrge9.prod.google.com ([2002:a05:6000:1789:b0:421:8d6a:e0b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:18a6:b0:3eb:a237:a051
 with SMTP id ffacd0b85a97d-42557820770mr3555146f8f.58.1759352640509; Wed, 01
 Oct 2025 14:04:00 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:10 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542; i=ardb@kernel.org;
 h=from:subject; bh=ibLsffhkx3eQuDIH6wng+X3cde8PFK2qiv2gBQvEgB0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutDcHLTbs9tkZJfys9AfjVivVRQv3qXhZt9g/3VRX8
 NRJsOZvRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhImxDDf4esiwetRG6+KPnm
 dV3iVm7kOcUz9zdPjTqh5XVbccJP178M/0xnpNX4dnd6mPue5Dt550ecgevSD2vKLggFBe54s/6 hGDsA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-30-ardb+git@google.com>
Subject: [PATCH v2 08/20] crypto/arm64: sm4-ce-gcm - Avoid pointless yield of
 the NEON unit
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

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it when calling APIs that may sleep.

Also, move the calls to kernel_neon_end() to the same scope as
kernel_neon_begin(). This is needed for a subsequent change where a
stack buffer is allocated transparently and passed to
kernel_neon_begin().

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-gcm-glue.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index c2ea3d5f690b..170cd0151385 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -165,26 +165,22 @@ static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 					       ctx->ghash_table,
 					       (const u8 *)&lengths);
 
-			kernel_neon_end();
-
-			return skcipher_walk_done(walk, 0);
+			err = skcipher_walk_done(walk, 0);
+			goto out;
 		}
 
 		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
 				       walk->nbytes - tail, ghash,
 				       ctx->ghash_table, NULL);
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
 	}
 
 	sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
 			       walk->nbytes, ghash, ctx->ghash_table,
 			       (const u8 *)&lengths);
 
+out:
 	kernel_neon_end();
 
 	return err;
-- 
2.51.0.618.g983fd99d29-goog

