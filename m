Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624B62FBDF0
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938426; cv=none; b=jl6hkNL8NxwVoDTYl2lpwPjQ/ZtXvhWtjRN+XboBoskBDqD1vU0o5iHhu8bh+BmmSxsH/u1/OC7yHaf+3Dh5T+wQWN4tcwXUH5iTfs8bn+gxXGv6xCAkuUR4IpchkfQU9YMulPoBn5T2+jRFT18cdClFxQCReXTCBDDICGleZMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938426; c=relaxed/simple;
	bh=FQD/z+6lXiIcL/7kTxCFE2DLvjr2aRXNJXgQtJfNEVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gyyywU5FxaXAEF5RKyn1DCVieTpvaZ8K+5QHE2LBQYEYZm2aRAXgbtvU6zAl2pPVXACn9a+sIh4CZxZ4xp5gIGp8LC6nGRnNl2BpE5AQt+trOqYF6NOhTCwlq9OI85KXU6QGSphsNRJksOaXr4n5lRswtG8QulMhMdxIMFcfhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUv55FJ4; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUv55FJ4"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso66718f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938422; x=1760543222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9LVoYmYTtGptKcGaIqz4TtHmJpnpszkhgfxtgMZN1E=;
        b=QUv55FJ41cyPQSy1Go9/Fx3VS66mEDNWnKAcDNwDq2WMUilUm+w2uRu5CzwU7NWdYM
         4X4ClEq1r7Xg1EJxQnMpPNElfXYTp3Kq8pkbC6N1jrW9xdfu/MqLsruvxONNz0MBucgM
         9cGSlHfARvzdkAp2LIYvuD0cqEBn8p61Gp0YASB54kmvDY4ZVyr8jrgWrV3wx8RfU0l8
         SV+VMFR49gnXviJxyHPzfT+bM2ZgNppSc5S0hMiusfIr9v9Cij/qkq7VesmQZ93HfCzL
         10AMs86L3i0b/DIQolYfyCS9gxxK+SverYdiACrwHW0aHIKmrpxiK18kKygh6TsAtI7L
         W6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938422; x=1760543222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9LVoYmYTtGptKcGaIqz4TtHmJpnpszkhgfxtgMZN1E=;
        b=LSP6y0vzpN42VLMMBX/KRAQBuKa7fjtbeXKCQX00ExTvmnhN+6xjiFCvth154VEM6H
         uf3pLXCJqj3QRh4i8eQY97/HLuRu3ok1zRoEMYWvHspd5ByCSxhL6IIrtoqv6BVZ3hz9
         mBek+aGjLl9gPHb4rLitLQNVjRw5HTbJol2QmuNhz0acgFXhXPt4U27OGadiN0i/FXRA
         m8rCcylZeu74yLXy99zsX2SQ+RgxatiYVgRW5wTh6ZO7yUm6RygFWTJeH6KnrcomN7Cv
         D+4xpYNtqqdsgYf358L+DTgVG9SRFPw+xJMGTZrsc22f8VUESb1kPZ+Ab4v5KgV70fQE
         v0LA==
X-Forwarded-Encrypted: i=1; AJvYcCWO85VRdPlNEBY/EKNpO1+t5Wm5IypdUirUAlo3zgIMp+GFuehpoCn+s7Y3MCWT2Ok2mcBc0/QzRh/7rlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY102eODLeDtNUbtvApFaJf5EmMQjqF865ofMjpT5QIY9WBskN
	UFju6FuVci5OlOpUmMBn9/rp2BmbZIqBodxcEujIT8lHSRYRH9Euz1y+tCSzcKz6GrHJVF13ew=
	=
X-Google-Smtp-Source: AGHT+IHpvSRci2gpv7ZU1IAhZM+xVMFiXHJZypmfvURMXvnTa0pwgCk5eYUgWECkxlzPguEf0Tz1w3HD
X-Received: from wmbd24.prod.google.com ([2002:a05:600c:58d8:b0:46e:4943:289b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d03:0:b0:3ec:e0d0:60e5
 with SMTP id ffacd0b85a97d-42667177bd4mr2760140f8f.15.1759938421849; Wed, 08
 Oct 2025 08:47:01 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:49 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1531; i=ardb@kernel.org;
 h=from:subject; bh=KbLRn3K+fhgTbW1ynT/DmRKNIqX5FUyDJ4LA4JLPqDs=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGjmh0mgHwxNRpFR0uLeyEM/7Ru0XZRuTjmbCFMD+pwVKCMPv
 Ih1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmjmh0kACgkQMG4JVi59LVyXkwD9GvEh
 GB4myAwRpn32iKqBOQuzHl9IIEadlLMcTujoQkgA/ie4fhaKFva43l0IM40cGryU1yaSMyBQQI8 ARZPeCzsG
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-38-ardb+git@google.com>
Subject: [PATCH v3 15/21] crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
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
 arch/arm64/crypto/sha3-ce-glue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index b4f1001046c9..22732760edd3 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -46,9 +46,8 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 	do {
 		int rem;
 
-		kernel_neon_begin();
-		rem = sha3_ce_transform(sctx->st, data, blocks, ds);
-		kernel_neon_end();
+		scoped_ksimd()
+			rem = sha3_ce_transform(sctx->st, data, blocks, ds);
 		data += (blocks - rem) * bs;
 		blocks = rem;
 	} while (blocks);
@@ -73,9 +72,8 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 	memset(block + len, 0, bs - len);
 	block[bs - 1] |= 0x80;
 
-	kernel_neon_begin();
-	sha3_ce_transform(sctx->st, block, 1, ds);
-	kernel_neon_end();
+	scoped_ksimd()
+		sha3_ce_transform(sctx->st, block, 1, ds);
 	memzero_explicit(block , sizeof(block));
 
 	for (i = 0; i < ds / 8; i++)
-- 
2.51.0.710.ga91ca5db03-goog

