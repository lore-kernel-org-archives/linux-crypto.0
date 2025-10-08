Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6F2FB618
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938422; cv=none; b=I9rS8AxSZALAq3Gbg7c+HH8U+pCJJKubZwumKckTjZbd/akm9fiYPxN1lsisYiWz7yuaz/8BXVcnErk05QH6vqPflH/CQFpzx1hYLe5+iTGYV5pFZnu16VoWz3+/MrJgNBfP1PgQcBQBijighNNqNoQMo1xo8FbW3Vmy3bB7xTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938422; c=relaxed/simple;
	bh=qCZByrWzrmyH3UqPPmysPCtXP60NqDPuaPfmddQNwAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uqy6L3EfZMNFzqjtbmCk7OM39tS+AU17PYNDFLkbVTP/qeeA7yd6H7Fb/ai62o6FIbr5e6fXlseo6BMsXCHCELrD/vKlQuZzcLE/37suPELLZlJppkjyId6LYrIxe3s3/8ymirfGQ6l3ZQ5tWvEDQCvgFG3A+zhz1FLjWSmoFFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsL5e5A6; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsL5e5A6"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6394afe514eso6335186a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938419; x=1760543219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0Zu7n3LaOo+I8CYEuQkDSSyekyMvHu55FmTnZPR1Fs=;
        b=jsL5e5A625yqUhXudNynVVwIpRANnyLusCkB+HGpAEYqnxOAQncddEDMQ5yUSJNcjW
         AnjgzN8d/m5nneQLiZdjPMnKJuQtdQW4v6FfDjtODvhBXylBuNWcoJc+GZhwH/QnS2j3
         W7r8g44MiUu0gT0SbOxPbjUJivjJ9m6JF6CfXgVwZ5apl+lwBonrCGkkH9r17l38OKeR
         H28RoqDNqv+ILtNo5l/ixHmVdccNUnY4sUbfleUyHJJkYXaHJrwxfOFhyM5NwJrDmsJz
         OnSzB9WNax9MHtjb8Z3CXzIa/t8Dj5VfA5cd6ojDkXoqbII6woVnXYWvIFZXb5Huv12j
         6Www==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938419; x=1760543219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0Zu7n3LaOo+I8CYEuQkDSSyekyMvHu55FmTnZPR1Fs=;
        b=pvkQS9KRPiBLnSPZeAzC1NFl2UJQQXMeMBA92vrE4Ik1JEg9xw7jFKGQivh3dkZ+uT
         UydL9KVBTQR4MuafUSANloA45RhwO/d4X+r+8LPYS7qs0WxnWs4XKhflmHUxWL8zxrKu
         WfGWI4g4uLQsiDEdFV4IAdhE8XuinTzVXnxL05wwwGH7Y1fLxq4OPYYtVLQV/po1SuUJ
         eMu7xCTYs9Fs89brKg+XEsNf53ZLCPD0ZGJVgGDNeyzkzIcnHc6X8cY9O+M4Fz3waHjc
         tYZtofOiTVymjS7GokjgjMPCV4homWT5gEwPzFYvJb3KYRYz7Z++v/y/9x3ksAJ/FzK9
         hZNA==
X-Forwarded-Encrypted: i=1; AJvYcCVsGnOnH56pGoY0BJBhmKkKckba3bvNndHa+ZubCmkh6RMiOvdGUQzqAR76YbHBMxSLw6tQ9/FsCSEXrYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNjev8AcoMu0dfLeqTeNCfMBaoklr0+GN8whhcOLXaOs0ux+eM
	XTVQ7y6MudSKIndyXVd6+UzLR6lmurdHuEQHho2Q00PrbEqlt8o5F3QpQpDoLmyrSVneMXszGA=
	=
X-Google-Smtp-Source: AGHT+IGav2hs8j+BD8Ez6wtFb9ryWmg+5Cqi/FdQRo4iR29OSB6a6/a1XkaaR/BdhniWetTsV5AzKnAF
X-Received: from edg11.prod.google.com ([2002:a05:6402:23cb:b0:633:88ce:6ba1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1ed0:b0:639:e469:8ad1
 with SMTP id 4fb4d7f45d1cf-639e469a2e6mr1875949a12.20.1759938418627; Wed, 08
 Oct 2025 08:46:58 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:46 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2613; i=ardb@kernel.org;
 h=from:subject; bh=5MqfiBK+zzoh8ZIeemHCwImcnXO2p3OW2OkltAZA92c=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu6PQv0s/3R6FHTWrvdppvE8hc+vPH+tbHDdp7mpvM
 V4evbWxo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkezEjw0qBPKbzws7Ls/O1
 ouV3v2yt4VpzsfVj3Rr2CQcy7kcG6DD8s28KWpu+NjTuYv5NwwkVnJz71GZnX1lqLbpLJixgrcQ EFgA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-35-ardb+git@google.com>
Subject: [PATCH v3 12/21] crypto/arm64: aes-gcm - Switch to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Switch to the more abstract 'scoped_ksimd()' API, which will be modified
in a future patch to transparently allocate a kernel mode FP/SIMD state
buffer on the stack, so that kernel mode FP/SIMD code remains
preemptible in principe, but without the memory overhead that adds 528
bytes to the size of struct task_struct.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 27 ++++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 4995b6e22335..7951557a285a 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/neon.h>
 #include <crypto/aes.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
@@ -22,6 +21,8 @@
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
+#include <asm/simd.h>
+
 MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -74,9 +75,8 @@ void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
 					      u64 const h[][2],
 					      const char *head))
 {
-	kernel_neon_begin();
-	simd_update(blocks, dg, src, key->h, head);
-	kernel_neon_end();
+	scoped_ksimd()
+		simd_update(blocks, dg, src, key->h, head);
 }
 
 /* avoid hogging the CPU for too long */
@@ -329,11 +329,10 @@ static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 			tag = NULL;
 		}
 
-		kernel_neon_begin();
-		pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
-				  dg, iv, ctx->aes_key.key_enc, nrounds,
-				  tag);
-		kernel_neon_end();
+		scoped_ksimd()
+			pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
+					  dg, iv, ctx->aes_key.key_enc, nrounds,
+					  tag);
 
 		if (unlikely(!nbytes))
 			break;
@@ -399,11 +398,11 @@ static int gcm_decrypt(struct aead_request *req, char *iv, int assoclen)
 			tag = NULL;
 		}
 
-		kernel_neon_begin();
-		ret = pmull_gcm_decrypt(nbytes, dst, src, ctx->ghash_key.h,
-					dg, iv, ctx->aes_key.key_enc,
-					nrounds, tag, otag, authsize);
-		kernel_neon_end();
+		scoped_ksimd()
+			ret = pmull_gcm_decrypt(nbytes, dst, src,
+						ctx->ghash_key.h,
+						dg, iv, ctx->aes_key.key_enc,
+						nrounds, tag, otag, authsize);
 
 		if (unlikely(!nbytes))
 			break;
-- 
2.51.0.710.ga91ca5db03-goog

