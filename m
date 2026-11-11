Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794430590;
	b=vJU6ALvoBk+i3fsup1Cys7GvdX0Sk6ZzguS7UqpyH+zQlzIdps27z4AAB9ybPFprjyf5
	 lWZ2VG1NMZdr+6XAsaZxCrDI5BG4gaVnuwUN5WNLTZ0lVKtQf1na56fQzhuqjTXzI/DsS
	 ayQ/3FXS/TTxzTfObZ3WUkPN0CicOb2YfkKVihynGnQx4F+WyXuljgFmyfE7JUipugyoR
	 i6Jz05jQAyr/YXHLLffJOkEoQkciKZ1pbUeaZkKiiQyTF07plj5IF8McxFpdtLcRhQPMy
	 2uBDjppNds3BWZMJw+zoswIkCHRBoxrIEaPZsQ7MRBGxJL34CbbEGA4iA7AjahBLivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794430590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pStOyxBQoussPKbDWC0Y4yIvlj83S/Ec9vJBhAymBs8=;
	b=5F7W+QHwNrtdRGuDvBflM1mn+5rI6jkM6EQ7cs3ihHQXVupEWCbH164ZM1hoy4AmqBrD
	 bjUebpN4T4vjcdIfedpdA9vEL+UpFUgG+GFPR47hYbahiL5QpX5XT+AczWn8hAfXJ5bqO
	 1UD0Xt8usLs0RAOYYzm93QG/OnsVemahu+cShU/PrnfmxTgKlb31hJZe5agN5wxfVj8u/
	 ys/ky+vkm7D+MKMQgQKJYaVXkKXopj9BcmoPPrNrNvjqobPSWBsKgjtIQmpcSPMD0Xmri
	 6xCnm61xJxHmynxP2iIz3wcUYskFVsCq1Sxk3gRXU6kLw7vhCnGSemKgG2H78rZW26Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtJF5DBX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B67606A32A;
	Wed, 11 Nov 2026 20:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtJF5DBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397941F00A05;
	Wed, 11 Nov 2026 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794430589;
	bh=pStOyxBQoussPKbDWC0Y4yIvlj83S/Ec9vJBhAymBs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtJF5DBX6JRDTGvLXLB3A1NjGlxPcVZSqlxUGuZfjLGV/gkzTEcD7kRiOt5BmcHOk
	 UD6llHB7uXWkp/KD0rVUqS/sBTPceUz45ulDmOHjJtX7ccbD0eCZPZjtJMd3yTt+u3
	 SiRi22bj+WhJ/ZSyMRImmmWP4hD6RrpdnY442usSP4AsvAC9tltCDiGeQqL1CrxIny
	 U8ziSRc7T5sgIUTCbm+RdWeT7grjfwIDNKQdp6O/P50t9Y/zyATm6HUnh0UNKqbUPz
	 ZSGg6fT1Yp1vXyjn4koV/x4sVqmAyh6eY8oNX/Z3fg/bLSwsM/yztva9JRV2NLXRaZ
	 elPL/nB9tbcYA==
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
Subject: [PATCH 3/3] raid6: opt out of initializing MXCSR and 387 state
Date: Wed, 11 Nov 2026 12:56:04 -0800
Message-ID: <20261111205604.47547-4-ebiggers@kernel.org>
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

The RAID6 code using "kernel-mode FPU" is integer code that does not use
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
 lib/raid/raid6/x86/avx2.c         | 12 ++++++------
 lib/raid/raid6/x86/avx512.c       | 12 ++++++------
 lib/raid/raid6/x86/recov_avx2.c   |  4 ++--
 lib/raid/raid6/x86/recov_avx512.c |  4 ++--
 lib/raid/raid6/x86/recov_ssse3.c  |  4 ++--
 lib/raid/raid6/x86/sse2.c         | 12 ++++++------
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index 3cc2fe7ac42c5..e09d0bd418efc 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -32,7 +32,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm3,%ymm3,%ymm3");	/* Zero temp */
@@ -82,7 +82,7 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
@@ -139,7 +139,7 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm1,%ymm1,%ymm1"); /* Zero temp */
@@ -192,7 +192,7 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 
@@ -271,7 +271,7 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
 	asm volatile("vpxor %ymm1,%ymm1,%ymm1");	/* Zero temp */
@@ -353,7 +353,7 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa %0,%%ymm0" :: "m" (raid6_avx2_constants.x1d[0]));
 
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 772bfc4af6dfd..6ba5ca7df29d5 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -34,7 +34,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1" /* Zero temp */
@@ -93,7 +93,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
@@ -161,7 +161,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1" /* Zero temp */
@@ -225,7 +225,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     : : "m" (raid6_avx512_constants.x1d[0]));
@@ -320,7 +320,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];         /* XOR parity */
 	q = dptr[z0+2];         /* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0\n\t"
 		     "vpxorq %%zmm1,%%zmm1,%%zmm1\n\t"       /* Zero temp */
@@ -415,7 +415,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vmovdqa64 %0,%%zmm0"
 		     :: "m" (raid6_avx512_constants.x1d[0]));
diff --git a/lib/raid/raid6/x86/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
index 820871046e305..41c050746b3dd 100644
--- a/lib/raid/raid6/x86/recov_avx2.c
+++ b/lib/raid/raid6/x86/recov_avx2.c
@@ -43,7 +43,7 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	/* ymm0 = x0f[16] */
 	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
@@ -205,7 +205,7 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
 
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index 299a3f044d616..3b48822b61ac3 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -48,7 +48,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	/* zmm0 = x0f[16] */
 	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
@@ -243,7 +243,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("vpbroadcastb %0, %%zmm7" : : "m" (x0f));
 
diff --git a/lib/raid/raid6/x86/recov_ssse3.c b/lib/raid/raid6/x86/recov_ssse3.c
index 700bd2c865ece..5540944945d57 100644
--- a/lib/raid/raid6/x86/recov_ssse3.c
+++ b/lib/raid/raid6/x86/recov_ssse3.c
@@ -44,7 +44,7 @@ static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
 		raid6_gfexp[failb]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm7" : : "m" (x0f[0]));
 
@@ -210,7 +210,7 @@ static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
 	/* Now, pick the proper data tables */
 	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0, %%xmm7" : : "m" (x0f[0]));
 
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index 43b09ce58270a..2bbb288c244fc 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -28,7 +28,7 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5");	/* Zero temp */
@@ -80,7 +80,7 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
@@ -136,7 +136,7 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm5,%xmm5"); /* Zero temp */
@@ -189,7 +189,7 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
 
@@ -266,7 +266,7 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	p = dptr[z0+1];		/* XOR parity */
 	q = dptr[z0+2];		/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
 	asm volatile("pxor %xmm2,%xmm2");	/* P[0] */
@@ -353,7 +353,7 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 	p = dptr[disks-2];	/* XOR parity */
 	q = dptr[disks-1];	/* RS syndrome */
 
-	kernel_fpu_begin();
+	kernel_fpu_begin_mask(0);
 
 	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
 
-- 
2.56.1

