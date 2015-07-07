From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 09/10] crypto: poly1305 - Add a two block SSE2 variant for x86_64
Date: Tue,  7 Jul 2015 21:36:55 +0200
Message-ID: <1436297816-16414-10-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44647 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbbGGThU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:20 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends the x86_64 SSE2 Poly1305 authenticator by a function processing two
consecutive Poly1305 blocks in parallel using a derived key r^2. Loop
unrolling can be more effectively mapped to SSE instructions, further
increasing throughput.

For large messages, throughput increases by ~45-65% compared to single
block SSE2:

testing speed of poly1305 (poly1305-simd)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 3654724 opers/sec,  350853504 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 5939245 opers/sec,  570167520 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9480730 opers/sec,  910150080 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1387720 opers/sec,  399663360 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 2031633 opers/sec,  585110304 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3697643 opers/sec, 1064921184 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  570658 opers/sec,  602614848 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1129287 opers/sec, 1192527072 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  289452 opers/sec,  602060160 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates):  595957 opers/sec, 1239590560 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  303426 opers/sec, 1252542528 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  153136 opers/sec, 1259390464 bytes/sec

testing speed of poly1305 (poly1305-simd)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 3623907 opers/sec,  347895072 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 5915244 opers/sec,  567863424 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9489525 opers/sec,  910994400 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1369657 opers/sec,  394461216 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 2016000 opers/sec,  580608000 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3716146 opers/sec, 1070250048 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  561913 opers/sec,  593380128 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1635554 opers/sec, 1727145024 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  286540 opers/sec,  596003200 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates):  935339 opers/sec, 1945505120 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  491810 opers/sec, 2030191680 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  252857 opers/sec, 2079495968 bytes/sec

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/poly1305-sse2-x86_64.S | 306 +++++++++++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  54 +++++-
 2 files changed, 355 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
index a3d2b5e..338c748 100644
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -15,6 +15,7 @@
 .align 16
 
 ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
+ORMASK:	.octa 0x00000000010000000000000001000000
 
 .text
 
@@ -274,3 +275,308 @@ ENTRY(poly1305_block_sse2)
 	pop		%rbx
 	ret
 ENDPROC(poly1305_block_sse2)
+
+
+#define u0 0x00(%r8)
+#define u1 0x04(%r8)
+#define u2 0x08(%r8)
+#define u3 0x0c(%r8)
+#define u4 0x10(%r8)
+#define hc0 %xmm0
+#define hc1 %xmm1
+#define hc2 %xmm2
+#define hc3 %xmm5
+#define hc4 %xmm6
+#define ru0 %xmm7
+#define ru1 %xmm8
+#define ru2 %xmm9
+#define ru3 %xmm10
+#define ru4 %xmm11
+#define sv1 %xmm12
+#define sv2 %xmm13
+#define sv3 %xmm14
+#define sv4 %xmm15
+#undef d0
+#define d0 %r13
+
+ENTRY(poly1305_2block_sse2)
+	# %rdi: Accumulator h[5]
+	# %rsi: 16 byte input block m
+	# %rdx: Poly1305 key r[5]
+	# %rcx: Doubleblock count
+	# %r8:  Poly1305 derived key r^2 u[5]
+
+	# This two-block variant further improves performance by using loop
+	# unrolled block processing. This is more straight forward and does
+	# less byte shuffling, but requires a second Poly1305 key r^2:
+	# h = (h + m) * r    =>    h = (h + m1) * r^2 + m2 * r
+
+	push		%rbx
+	push		%r12
+	push		%r13
+
+	# combine r0,u0
+	movd		u0,ru0
+	movd		r0,t1
+	punpcklqdq	t1,ru0
+
+	# combine r1,u1 and s1=r1*5,v1=u1*5
+	movd		u1,ru1
+	movd		r1,t1
+	punpcklqdq	t1,ru1
+	movdqa		ru1,sv1
+	pslld		$2,sv1
+	paddd		ru1,sv1
+
+	# combine r2,u2 and s2=r2*5,v2=u2*5
+	movd		u2,ru2
+	movd		r2,t1
+	punpcklqdq	t1,ru2
+	movdqa		ru2,sv2
+	pslld		$2,sv2
+	paddd		ru2,sv2
+
+	# combine r3,u3 and s3=r3*5,v3=u3*5
+	movd		u3,ru3
+	movd		r3,t1
+	punpcklqdq	t1,ru3
+	movdqa		ru3,sv3
+	pslld		$2,sv3
+	paddd		ru3,sv3
+
+	# combine r4,u4 and s4=r4*5,v4=u4*5
+	movd		u4,ru4
+	movd		r4,t1
+	punpcklqdq	t1,ru4
+	movdqa		ru4,sv4
+	pslld		$2,sv4
+	paddd		ru4,sv4
+
+.Ldoblock2:
+	# hc0 = [ m[16-19] & 0x3ffffff, h0 + m[0-3] & 0x3ffffff ]
+	movd		0x00(m),hc0
+	movd		0x10(m),t1
+	punpcklqdq	t1,hc0
+	pand		ANMASK(%rip),hc0
+	movd		h0,t1
+	paddd		t1,hc0
+	# hc1 = [ (m[19-22] >> 2) & 0x3ffffff, h1 + (m[3-6] >> 2) & 0x3ffffff ]
+	movd		0x03(m),hc1
+	movd		0x13(m),t1
+	punpcklqdq	t1,hc1
+	psrld		$2,hc1
+	pand		ANMASK(%rip),hc1
+	movd		h1,t1
+	paddd		t1,hc1
+	# hc2 = [ (m[22-25] >> 4) & 0x3ffffff, h2 + (m[6-9] >> 4) & 0x3ffffff ]
+	movd		0x06(m),hc2
+	movd		0x16(m),t1
+	punpcklqdq	t1,hc2
+	psrld		$4,hc2
+	pand		ANMASK(%rip),hc2
+	movd		h2,t1
+	paddd		t1,hc2
+	# hc3 = [ (m[25-28] >> 6) & 0x3ffffff, h3 + (m[9-12] >> 6) & 0x3ffffff ]
+	movd		0x09(m),hc3
+	movd		0x19(m),t1
+	punpcklqdq	t1,hc3
+	psrld		$6,hc3
+	pand		ANMASK(%rip),hc3
+	movd		h3,t1
+	paddd		t1,hc3
+	# hc4 = [ (m[28-31] >> 8) | (1<<24), h4 + (m[12-15] >> 8) | (1<<24) ]
+	movd		0x0c(m),hc4
+	movd		0x1c(m),t1
+	punpcklqdq	t1,hc4
+	psrld		$8,hc4
+	por		ORMASK(%rip),hc4
+	movd		h4,t1
+	paddd		t1,hc4
+
+	# t1 = [ hc0[1] * r0, hc0[0] * u0 ]
+	movdqa		ru0,t1
+	pmuludq		hc0,t1
+	# t1 += [ hc1[1] * s4, hc1[0] * v4 ]
+	movdqa		sv4,t2
+	pmuludq		hc1,t2
+	paddq		t2,t1
+	# t1 += [ hc2[1] * s3, hc2[0] * v3 ]
+	movdqa		sv3,t2
+	pmuludq		hc2,t2
+	paddq		t2,t1
+	# t1 += [ hc3[1] * s2, hc3[0] * v2 ]
+	movdqa		sv2,t2
+	pmuludq		hc3,t2
+	paddq		t2,t1
+	# t1 += [ hc4[1] * s1, hc4[0] * v1 ]
+	movdqa		sv1,t2
+	pmuludq		hc4,t2
+	paddq		t2,t1
+	# d0 = t1[0] + t1[1]
+	movdqa		t1,t2
+	psrldq		$8,t2
+	paddq		t2,t1
+	movq		t1,d0
+
+	# t1 = [ hc0[1] * r1, hc0[0] * u1 ]
+	movdqa		ru1,t1
+	pmuludq		hc0,t1
+	# t1 += [ hc1[1] * r0, hc1[0] * u0 ]
+	movdqa		ru0,t2
+	pmuludq		hc1,t2
+	paddq		t2,t1
+	# t1 += [ hc2[1] * s4, hc2[0] * v4 ]
+	movdqa		sv4,t2
+	pmuludq		hc2,t2
+	paddq		t2,t1
+	# t1 += [ hc3[1] * s3, hc3[0] * v3 ]
+	movdqa		sv3,t2
+	pmuludq		hc3,t2
+	paddq		t2,t1
+	# t1 += [ hc4[1] * s2, hc4[0] * v2 ]
+	movdqa		sv2,t2
+	pmuludq		hc4,t2
+	paddq		t2,t1
+	# d1 = t1[0] + t1[1]
+	movdqa		t1,t2
+	psrldq		$8,t2
+	paddq		t2,t1
+	movq		t1,d1
+
+	# t1 = [ hc0[1] * r2, hc0[0] * u2 ]
+	movdqa		ru2,t1
+	pmuludq		hc0,t1
+	# t1 += [ hc1[1] * r1, hc1[0] * u1 ]
+	movdqa		ru1,t2
+	pmuludq		hc1,t2
+	paddq		t2,t1
+	# t1 += [ hc2[1] * r0, hc2[0] * u0 ]
+	movdqa		ru0,t2
+	pmuludq		hc2,t2
+	paddq		t2,t1
+	# t1 += [ hc3[1] * s4, hc3[0] * v4 ]
+	movdqa		sv4,t2
+	pmuludq		hc3,t2
+	paddq		t2,t1
+	# t1 += [ hc4[1] * s3, hc4[0] * v3 ]
+	movdqa		sv3,t2
+	pmuludq		hc4,t2
+	paddq		t2,t1
+	# d2 = t1[0] + t1[1]
+	movdqa		t1,t2
+	psrldq		$8,t2
+	paddq		t2,t1
+	movq		t1,d2
+
+	# t1 = [ hc0[1] * r3, hc0[0] * u3 ]
+	movdqa		ru3,t1
+	pmuludq		hc0,t1
+	# t1 += [ hc1[1] * r2, hc1[0] * u2 ]
+	movdqa		ru2,t2
+	pmuludq		hc1,t2
+	paddq		t2,t1
+	# t1 += [ hc2[1] * r1, hc2[0] * u1 ]
+	movdqa		ru1,t2
+	pmuludq		hc2,t2
+	paddq		t2,t1
+	# t1 += [ hc3[1] * r0, hc3[0] * u0 ]
+	movdqa		ru0,t2
+	pmuludq		hc3,t2
+	paddq		t2,t1
+	# t1 += [ hc4[1] * s4, hc4[0] * v4 ]
+	movdqa		sv4,t2
+	pmuludq		hc4,t2
+	paddq		t2,t1
+	# d3 = t1[0] + t1[1]
+	movdqa		t1,t2
+	psrldq		$8,t2
+	paddq		t2,t1
+	movq		t1,d3
+
+	# t1 = [ hc0[1] * r4, hc0[0] * u4 ]
+	movdqa		ru4,t1
+	pmuludq		hc0,t1
+	# t1 += [ hc1[1] * r3, hc1[0] * u3 ]
+	movdqa		ru3,t2
+	pmuludq		hc1,t2
+	paddq		t2,t1
+	# t1 += [ hc2[1] * r2, hc2[0] * u2 ]
+	movdqa		ru2,t2
+	pmuludq		hc2,t2
+	paddq		t2,t1
+	# t1 += [ hc3[1] * r1, hc3[0] * u1 ]
+	movdqa		ru1,t2
+	pmuludq		hc3,t2
+	paddq		t2,t1
+	# t1 += [ hc4[1] * r0, hc4[0] * u0 ]
+	movdqa		ru0,t2
+	pmuludq		hc4,t2
+	paddq		t2,t1
+	# d4 = t1[0] + t1[1]
+	movdqa		t1,t2
+	psrldq		$8,t2
+	paddq		t2,t1
+	movq		t1,d4
+
+	# d1 += d0 >> 26
+	mov		d0,%rax
+	shr		$26,%rax
+	add		%rax,d1
+	# h0 = d0 & 0x3ffffff
+	mov		d0,%rbx
+	and		$0x3ffffff,%ebx
+
+	# d2 += d1 >> 26
+	mov		d1,%rax
+	shr		$26,%rax
+	add		%rax,d2
+	# h1 = d1 & 0x3ffffff
+	mov		d1,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h1
+
+	# d3 += d2 >> 26
+	mov		d2,%rax
+	shr		$26,%rax
+	add		%rax,d3
+	# h2 = d2 & 0x3ffffff
+	mov		d2,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h2
+
+	# d4 += d3 >> 26
+	mov		d3,%rax
+	shr		$26,%rax
+	add		%rax,d4
+	# h3 = d3 & 0x3ffffff
+	mov		d3,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h3
+
+	# h0 += (d4 >> 26) * 5
+	mov		d4,%rax
+	shr		$26,%rax
+	lea		(%eax,%eax,4),%eax
+	add		%eax,%ebx
+	# h4 = d4 & 0x3ffffff
+	mov		d4,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h4
+
+	# h1 += h0 >> 26
+	mov		%ebx,%eax
+	shr		$26,%eax
+	add		%eax,h1
+	# h0 = h0 & 0x3ffffff
+	andl		$0x3ffffff,%ebx
+	mov		%ebx,h0
+
+	add		$0x20,m
+	dec		%rcx
+	jnz		.Ldoblock2
+
+	pop		%r13
+	pop		%r12
+	pop		%rbx
+	ret
+ENDPROC(poly1305_2block_sse2)
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 1e59274..b7c33d0 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -18,24 +18,68 @@
 #include <asm/fpu/api.h>
 #include <asm/simd.h>
 
+struct poly1305_simd_desc_ctx {
+	struct poly1305_desc_ctx base;
+	/* derived key u set? */
+	bool uset;
+	/* derived Poly1305 key r^2 */
+	u32 u[5];
+};
+
 asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
 				    const u32 *r, unsigned int blocks);
+asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
+				     unsigned int blocks, const u32 *u);
+
+static int poly1305_simd_init(struct shash_desc *desc)
+{
+	struct poly1305_simd_desc_ctx *sctx = shash_desc_ctx(desc);
+
+	sctx->uset = false;
+
+	return crypto_poly1305_init(desc);
+}
+
+static void poly1305_simd_mult(u32 *a, const u32 *b)
+{
+	u8 m[POLY1305_BLOCK_SIZE];
+
+	memset(m, 0, sizeof(m));
+	/* The poly1305 block function adds a hi-bit to the accumulator which
+	 * we don't need for key multiplication; compensate for it. */
+	a[4] -= 1 << 24;
+	poly1305_block_sse2(a, m, b, 1);
+}
 
 static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 					 const u8 *src, unsigned int srclen)
 {
+	struct poly1305_simd_desc_ctx *sctx;
 	unsigned int blocks, datalen;
 
+	BUILD_BUG_ON(offsetof(struct poly1305_simd_desc_ctx, base));
+	sctx = container_of(dctx, struct poly1305_simd_desc_ctx, base);
+
 	if (unlikely(!dctx->sset)) {
 		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
 		src += srclen - datalen;
 		srclen = datalen;
 	}
 
+	if (likely(srclen >= POLY1305_BLOCK_SIZE * 2)) {
+		if (unlikely(!sctx->uset)) {
+			memcpy(sctx->u, dctx->r, sizeof(sctx->u));
+			poly1305_simd_mult(sctx->u, dctx->r);
+			sctx->uset = true;
+		}
+		blocks = srclen / (POLY1305_BLOCK_SIZE * 2);
+		poly1305_2block_sse2(dctx->h, src, dctx->r, blocks, sctx->u);
+		src += POLY1305_BLOCK_SIZE * 2 * blocks;
+		srclen -= POLY1305_BLOCK_SIZE * 2 * blocks;
+	}
 	if (srclen >= POLY1305_BLOCK_SIZE) {
-		blocks = srclen / POLY1305_BLOCK_SIZE;
-		poly1305_block_sse2(dctx->h, src, dctx->r, blocks);
-		srclen -= POLY1305_BLOCK_SIZE * blocks;
+		poly1305_block_sse2(dctx->h, src, dctx->r, 1);
+		srclen -= POLY1305_BLOCK_SIZE;
 	}
 	return srclen;
 }
@@ -84,11 +128,11 @@ static int poly1305_simd_update(struct shash_desc *desc,
 
 static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
-	.init		= crypto_poly1305_init,
+	.init		= poly1305_simd_init,
 	.update		= poly1305_simd_update,
 	.final		= crypto_poly1305_final,
 	.setkey		= crypto_poly1305_setkey,
-	.descsize	= sizeof(struct poly1305_desc_ctx),
+	.descsize	= sizeof(struct poly1305_simd_desc_ctx),
 	.base		= {
 		.cra_name		= "poly1305",
 		.cra_driver_name	= "poly1305-simd",
-- 
1.9.1
