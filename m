Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794430589;
	b=t+SfYV3Z8oosqDYVmbBlX61PNDcA5VVE1Wkj5agm4Gqvesays+lsqD9ytHjElcTa8Y26
	 OkfvpGCIPTa01LC4xopkyizU7QNrohJEGERrAc7asESePycLIQSutq4uOyyTsn4zTAY68
	 AAoLgHjlRycV3hPY1F1BIIWFbQkMFvPQSOUw3Y2Xxf2hIFjyFcBb1iIhy9U2heFlhgdp8
	 r/yg5pjj2R0qbIYqHADuCu5m8h9Fz9Uz8duGXuTjZSoMT4cI8VE8UUSXJMrCy4UvJOSuW
	 Lj7Ab8DDGUv8TS/fYogKmSUbrbaUujS8ZDTJx54q3C9YecxKNwjUCv8sxTjzgD5BPXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794430589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GJo3G9Hrid/iZJu/8QeZ7pTIVh8uBNsrKZv7yWK21wk=;
	b=xaaRnyJwNY8Oy4KV7smlAIhx5HWyuzOBfgfR2eAESAvs3j1l1fXPMZYwTxalZIPt/iOG
	 VII3K4KPp4phb2QFdDS6gA8jLCcHYXy+DcTl9QBxF5XeDaPUxw37mtyXQMlKvOuSE/QYo
	 DTgcxbU/OyOKMNhPfRxe1ngqSNAaXQKt1qK6qI/HeUIimVE9zwbbpJkAgbh5j+LC8g4xw
	 QN0kLctQuFfcjnB5pfi2BmWNSy1xuryxI85ngRoYeQmmJrMS2jZf+hUf3/Ya8MZPQzpvx
	 sVyO+o7L/XwiR/gVZbY5/FuAFv7VwuLHAy/20W6ELuEzaYUk1hEzJgnis0u8rNlMBXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUMTlEqg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB0606A33D;
	Wed, 11 Nov 2026 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EUMTlEqg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A301F00A06;
	Wed, 11 Nov 2026 20:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794430589;
	bh=GJo3G9Hrid/iZJu/8QeZ7pTIVh8uBNsrKZv7yWK21wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUMTlEqg1iegHSHv7n2YL1f1YkRq5WHpkpNRyyiMw9RCBxHh8k+ap5+rgNP8ATSV6
	 Q3I11YEUMtoBaCKR4EXhbbFMqwcNJ4nZ+GpJQcT7rVR5DWlgPKGh9rs7jBCmfPo1fY
	 IhZdg0GtLMwcocaSNki3RGpNtLSISpJ5jmmfQHlViFu6+IzIwkxNWoTKefMP75MBQa
	 D8E18J6ZKDAlgIbjUOksmE9uxdZQRGz/2Gpv5nNMlxrEfiWPBgVmIf2NAA7xT/qyCS
	 1V+H2GSlvJ+H7NPoXCmfPtQUhYDR7alVdRguJ0766p7P/5WGpyODb43N3VlV0fDXk2
	 K7VW3m5HpvXBg==
From: Eric Biggers <ebiggers@kernel.org>
To: akpm@linux-foundation.org,
	linux-raid@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] xor: opt out of initializing MXCSR and 387 state
Date: Wed, 11 Nov 2026 12:56:03 -0800
Message-ID: <20261111205604.47547-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111205604.47547-1-ebiggers@kernel.org>
References: <20261111205604.47547-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XOR code using "kernel-mode FPU" is integer code that does not use
any MMX or x87 instructions.  (MMX optimized code previously existed but
was recently removed.)  To the extent that float-domain instructions are
used at all, they are only moves, shuffles, and XORs, none of which
raises SIMD floating-point exceptions or depends on MXCSR.

Therefore, there's no need to initialize MXCSR or the 387 FPU state.

Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
every kernel-mode FPU section, reducing overhead, which matters most for
short input lengths.  On 32-bit kernels it also eliminates 'fninit'.

This will make the RAID code consistent with the crypto and CRC code,
which are also switching to kernel_fpu_begin_mask(0)
(https://lore.kernel.org/linux-crypto/20261105005523.84925-1-ebiggers@kernel.org/).
Another precedent for this optimization can be found in
commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
don't need a valid MXCSR state").

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor-avx.c    | 2 +-
 lib/raid/xor/x86/xor-avx512.c | 2 +-
 lib/raid/xor/x86/xor-sse.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
index 95b21e7225e8d..d4154a761b408 100644
--- a/lib/raid/xor/x86/xor-avx.c
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -145,7 +145,7 @@ DO_XOR_BLOCKS(avx_inner, xor_avx_2, xor_avx_3, xor_avx_4, xor_avx_5);
 static void xor_gen_avx(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
index c11d83441875c..1c7ce519660e4 100644
--- a/lib/raid/xor/x86/xor-avx512.c
+++ b/lib/raid/xor/x86/xor-avx512.c
@@ -110,7 +110,7 @@ DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
 static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
 			   unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
diff --git a/lib/raid/xor/x86/xor-sse.c b/lib/raid/xor/x86/xor-sse.c
index c6626ecae6ba5..725686c0c942f 100644
--- a/lib/raid/xor/x86/xor-sse.c
+++ b/lib/raid/xor/x86/xor-sse.c
@@ -432,7 +432,7 @@ DO_XOR_BLOCKS(sse_inner, xor_sse_2, xor_sse_3, xor_sse_4, xor_sse_5);
 static void xor_gen_sse(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_sse_inner(dest, srcs, src_cnt, bytes);
 	kernel_fpu_end();
 }
@@ -448,7 +448,7 @@ DO_XOR_BLOCKS(sse_pf64_inner, xor_sse_2_pf64, xor_sse_3_pf64, xor_sse_4_pf64,
 static void xor_gen_sse_pf64(void *dest, void **srcs, unsigned int src_cnt,
 			unsigned int bytes)
 {
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 	xor_gen_sse_pf64_inner(dest, srcs, src_cnt, bytes);
 	kernel_fpu_end();
 }
-- 
2.56.1

