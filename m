Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083918A92D
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 11:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739704205; cv=none; b=KeyFVYPdEc9muRM2bfxX9Rj/iDwxaMniUxQbJM92S0YXd/3n25c3TLJc9yq1BVJg+67jwzRXYDdIgPw/R06+e3z6j0gg75UZS6BLYwQnfopgZXFaKmjSWThr7cVj1QGeGnqKo2jzRkNpE9swLkGq+UuO77BPkVm2dvJff8/Rs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739704205; c=relaxed/simple;
	bh=ac2vttwv4wKNLqh8ENu3PiVuPXuHpzytAONdLc9jb/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gre1DjlJeqc7u/TRin6Ni8TSCRQqhrVclZEXeOTVqK9gT+pNjFvo2FJrqZ3ArRnT4pXrHWGqoGdyrUDH0Ds4708eQ2EetPknnUBUz9TJWSx3b4XgvmiNCjkqXBXGvjiWIeskjbV7esxGITQLC0JjCaXWmo5DMzVhHOqCpspvXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=K2ydrI4V; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="K2ydrI4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PgHY92FFa5XemuL/iZYHuUvpaEpPahpUpiSRZqvHhGk=; b=K2ydrI4VN/17Fyagem8IwWht3E
	wZbR0qSuiLqATnvIOsipqxGBWHNNiUMaCw1kBy/4kb33qgCZQtnDsay1lQR7VBYgJcgHHVu4TpQZb
	MXslXfiBHU2mblj4JLt4H+hXTPoqkWswPG32XQlN+PKJsaVusrwYFztnc/iFSt0BmUW4gqToSUtER
	yTsp2wY8GEtp2Y62yPPOskN1Ziy3ruxub7soTkg9PualnvXtmVBSY5M0nACzjVEU0kNWpCBoiasNj
	7cUhHwQi2ZzvxWtc3Nb94SZxYhAQd77+pQreUUW1MyWQ9u8LLtKfDx2IBr7l/umxv3Iu0kbjtTayr
	fBizjk/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjcKC-000jbo-1J;
	Sun, 16 Feb 2025 19:09:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 19:09:57 +0800
Date: Sun, 16 Feb 2025 19:09:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <20250216033816.GB90952@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216033816.GB90952@quark.localdomain>

On Sat, Feb 15, 2025 at 07:38:16PM -0800, Eric Biggers wrote:
> 
> This new version hasn't fundamentally changed anything.  It's still a much
> worse, unnecessarily complex and still incomplete implementation compared to my
> patchset which has been ready to go for nearly a year already.  Please refer to
> all the previous feedback that I've given.

FWIW, my interface is a lot simpler than yours to implement, since
it doesn't deal with the partial buffer non-sense in assembly.  In
fact that was a big mistake with the original API, the partial data
handling should've been moved to the API layer a long time ago.

Here is the result for sha256-ni-mb with my code:

               testing speed of multibuffer sha256 (sha256-ni-mb)
[   73.212300] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 1 operation in 284 cycles (16 bytes)
[   73.212805] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 1 operation in 311 cycles (64 bytes)
[   73.213256] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 1 operation in 481 cycles (256 bytes)
[   73.213715] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates): 1 operation in 1209 cycles (1024 bytes)
[   73.214181] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates): 1 operation in 36107 cycles (2048 bytes)
[   73.214904] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 1 operation in 4097 cycles (4096 bytes)
[   73.215416] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 1 operation in 7991 cycles (8192 bytes)
[   86.522453] tcrypt: 
               testing speed of multibuffer sha256 (sha256-ni)
[   86.522737] tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 1 operation in 224 cycles (16 bytes)
[   86.523164] tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 1 operation in 296 cycles (64 bytes)
[   86.523586] tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 1 operation in 531 cycles (256 bytes)
[   86.524012] tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates): 1 operation in 1466 cycles (1024 bytes)
[   86.524602] tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates): 1 operation in 2911 cycles (2048 bytes)
[   86.525199] tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 1 operation in 5566 cycles (4096 bytes)
[   86.525806] tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 1 operation in 10901 cycles (8192 bytes)

So about a 36% jump in throughput at 4K on my aging Intel CPU.

Cheers,

diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index d515a55a3bc1..10771d957116 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -174,6 +174,216 @@ SYM_TYPED_FUNC_START(sha256_ni_transform)
 	RET
 SYM_FUNC_END(sha256_ni_transform)
 
+#undef DIGEST_PTR
+#undef DATA_PTR
+#undef NUM_BLKS
+#undef SHA256CONSTANTS
+#undef MSG
+#undef STATE0
+#undef STATE1
+#undef MSG0
+#undef MSG1
+#undef MSG2
+#undef MSG3
+#undef TMP
+#undef SHUF_MASK
+#undef ABEF_SAVE
+#undef CDGH_SAVE
+
+// parameters for sha256_ni_x2()
+#define MBCTX		%rdi
+#define BLOCKS		%rsi
+#define DATA1		%rdx
+#define DATA2		%rcx
+
+// other scalar variables
+#define SHA256CONSTANTS	%rax
+#define COUNT		%r10
+#define COUNT32		%r10d
+
+// rbx is used as a temporary.
+
+#define MSG		%xmm0	// sha256rnds2 implicit operand
+#define STATE0_A	%xmm1
+#define STATE1_A	%xmm2
+#define STATE0_B	%xmm3
+#define STATE1_B	%xmm4
+#define TMP_A		%xmm5
+#define TMP_B		%xmm6
+#define MSG0_A		%xmm7
+#define MSG1_A		%xmm8
+#define MSG2_A		%xmm9
+#define MSG3_A		%xmm10
+#define MSG0_B		%xmm11
+#define MSG1_B		%xmm12
+#define MSG2_B		%xmm13
+#define MSG3_B		%xmm14
+#define SHUF_MASK	%xmm15
+
+#define OFFSETOF_STATEA	0	// offsetof(struct sha256_x2_mbctx, state[0])
+#define OFFSETOF_STATEB	32	// offsetof(struct sha256_x2_mbctx, state[1])
+#define OFFSETOF_INPUT0	64	// offsetof(struct sha256_x2_mbctx, input[0])
+#define OFFSETOF_INPUT1	72	// offsetof(struct sha256_x2_mbctx, input[1])
+
+// Do 4 rounds of SHA-256 for each of two messages (interleaved).  m0_a and m0_b
+// contain the current 4 message schedule words for the first and second message
+// respectively.
+//
+// If not all the message schedule words have been computed yet, then this also
+// computes 4 more message schedule words for each message.  m1_a-m3_a contain
+// the next 3 groups of 4 message schedule words for the first message, and
+// likewise m1_b-m3_b for the second.  After consuming the current value of
+// m0_a, this macro computes the group after m3_a and writes it to m0_a, and
+// likewise for *_b.  This means that the next (m0_a, m1_a, m2_a, m3_a) is the
+// current (m1_a, m2_a, m3_a, m0_a), and likewise for *_b, so the caller must
+// cycle through the registers accordingly.
+.macro	do_4rounds_2x	i, m0_a, m1_a, m2_a, m3_a,  m0_b, m1_b, m2_b, m3_b
+	movdqa		(\i-32)*4(SHA256CONSTANTS), TMP_A
+	movdqa		TMP_A, TMP_B
+	paddd		\m0_a, TMP_A
+	paddd		\m0_b, TMP_B
+.if \i < 48
+	sha256msg1	\m1_a, \m0_a
+	sha256msg1	\m1_b, \m0_b
+.endif
+	movdqa		TMP_A, MSG
+	sha256rnds2	STATE0_A, STATE1_A
+	movdqa		TMP_B, MSG
+	sha256rnds2	STATE0_B, STATE1_B
+	pshufd 		$0x0E, TMP_A, MSG
+	sha256rnds2	STATE1_A, STATE0_A
+	pshufd 		$0x0E, TMP_B, MSG
+	sha256rnds2	STATE1_B, STATE0_B
+.if \i < 48
+	movdqa		\m3_a, TMP_A
+	movdqa		\m3_b, TMP_B
+	palignr		$4, \m2_a, TMP_A
+	palignr		$4, \m2_b, TMP_B
+	paddd		TMP_A, \m0_a
+	paddd		TMP_B, \m0_b
+	sha256msg2	\m3_a, \m0_a
+	sha256msg2	\m3_b, \m0_b
+.endif
+.endm
+
+//
+// void sha256_ni_x2(struct sha256_x2_mbctx *mbctx, int blocks)
+//
+// This function computes the SHA-256 digests of two messages that are
+// both |blocks| blocks long, starting from the individual initial states
+// in |mbctx|.
+//
+// The instructions for the two SHA-256 operations are interleaved.  On many
+// CPUs, this is almost twice as fast as hashing each message individually due
+// to taking better advantage of the CPU's SHA-256 and SIMD throughput.
+//
+SYM_FUNC_START(sha256_ni_x2)
+	// Allocate 64 bytes of stack space, 16-byte aligned.
+	push		%rbx
+	push		%rbp
+	mov		%rsp, %rbp
+	sub		$64, %rsp
+	and		$~15, %rsp
+
+	// Load the shuffle mask for swapping the endianness of 32-bit words.
+	movdqa		PSHUFFLE_BYTE_FLIP_MASK(%rip), SHUF_MASK
+
+	// Set up pointer to the round constants.
+	lea		K256+32*4(%rip), SHA256CONSTANTS
+
+	// Load the initial state from sctx->state.
+	movdqu		OFFSETOF_STATEA+0*16(MBCTX), STATE0_A	// DCBA
+	movdqu		OFFSETOF_STATEA+1*16(MBCTX), STATE1_A	// HGFE
+	movdqu		OFFSETOF_STATEB+0*16(MBCTX), STATE0_B	// DCBA
+	movdqu		OFFSETOF_STATEB+1*16(MBCTX), STATE1_B	// HGFE
+
+	movdqa		STATE0_A, TMP_A
+	movdqa		STATE0_B, TMP_B
+	punpcklqdq	STATE1_A, STATE0_A			// FEBA
+	punpcklqdq	STATE1_B, STATE0_B			// FEBA
+	punpckhqdq	TMP_A, STATE1_A				// DCHG
+	punpckhqdq	TMP_B, STATE1_B				// DCHG
+	pshufd		$0x1B, STATE0_A, STATE0_A		// ABEF
+	pshufd		$0x1B, STATE0_B, STATE0_B		// ABEF
+	pshufd		$0xB1, STATE1_A, STATE1_A		// CDGH
+	pshufd		$0xB1, STATE1_B, STATE1_B		// CDGH
+
+	mov		OFFSETOF_INPUT0+0(MBCTX),DATA1
+	mov		OFFSETOF_INPUT1+0(MBCTX),DATA2
+
+.Lfinup2x_loop:
+	// Load the next two data blocks.
+	movdqu		0*16(DATA1), MSG0_A
+	movdqu		0*16(DATA2), MSG0_B
+	movdqu		1*16(DATA1), MSG1_A
+	movdqu		1*16(DATA2), MSG1_B
+	movdqu		2*16(DATA1), MSG2_A
+	movdqu		2*16(DATA2), MSG2_B
+	movdqu		3*16(DATA1), MSG3_A
+	movdqu		3*16(DATA2), MSG3_B
+	add		$64, DATA1
+	add		$64, DATA2
+
+	// Convert the words of the data blocks from big endian.
+	pshufb		SHUF_MASK, MSG0_A
+	pshufb		SHUF_MASK, MSG0_B
+	pshufb		SHUF_MASK, MSG1_A
+	pshufb		SHUF_MASK, MSG1_B
+	pshufb		SHUF_MASK, MSG2_A
+	pshufb		SHUF_MASK, MSG2_B
+	pshufb		SHUF_MASK, MSG3_A
+	pshufb		SHUF_MASK, MSG3_B
+
+	// Save the original state for each block.
+	movdqa		STATE0_A, 0*16(%rsp)
+	movdqa		STATE0_B, 1*16(%rsp)
+	movdqa		STATE1_A, 2*16(%rsp)
+	movdqa		STATE1_B, 3*16(%rsp)
+
+	// Do the SHA-256 rounds on each block.
+.irp i, 0, 16, 32, 48
+	do_4rounds_2x	(\i + 0),  MSG0_A, MSG1_A, MSG2_A, MSG3_A, \
+				   MSG0_B, MSG1_B, MSG2_B, MSG3_B
+	do_4rounds_2x	(\i + 4),  MSG1_A, MSG2_A, MSG3_A, MSG0_A, \
+				   MSG1_B, MSG2_B, MSG3_B, MSG0_B
+	do_4rounds_2x	(\i + 8),  MSG2_A, MSG3_A, MSG0_A, MSG1_A, \
+				   MSG2_B, MSG3_B, MSG0_B, MSG1_B
+	do_4rounds_2x	(\i + 12), MSG3_A, MSG0_A, MSG1_A, MSG2_A, \
+				   MSG3_B, MSG0_B, MSG1_B, MSG2_B
+.endr
+
+	// Add the original state for each block.
+	paddd		0*16(%rsp), STATE0_A
+	paddd		1*16(%rsp), STATE0_B
+	paddd		2*16(%rsp), STATE1_A
+	paddd		3*16(%rsp), STATE1_B
+
+	// Update BLOCKS and loop back if more blocks remain.
+	sub		$1, BLOCKS
+	jne		.Lfinup2x_loop
+
+	// Write the two digests with all bytes in the correct order.
+	movdqa		STATE0_A, TMP_A
+	movdqa		STATE0_B, TMP_B
+	punpcklqdq	STATE1_A, STATE0_A		// GHEF
+	punpcklqdq	STATE1_B, STATE0_B
+	punpckhqdq	TMP_A, STATE1_A			// ABCD
+	punpckhqdq	TMP_B, STATE1_B
+	pshufd		$0xB1, STATE0_A, STATE0_A	// HGFE
+	pshufd		$0xB1, STATE0_B, STATE0_B
+	pshufd		$0x1B, STATE1_A, STATE1_A	// DCBA
+	pshufd		$0x1B, STATE1_B, STATE1_B
+	movdqu		STATE0_A, OFFSETOF_STATEA+1*16(MBCTX)
+	movdqu		STATE0_B, OFFSETOF_STATEB+1*16(MBCTX)
+	movdqu		STATE1_A, OFFSETOF_STATEA+0*16(MBCTX)
+	movdqu		STATE1_B, OFFSETOF_STATEB+0*16(MBCTX)
+
+	mov		%rbp, %rsp
+	pop		%rbp
+	pop		%rbx
+	RET
+SYM_FUNC_END(sha256_ni_x2)
+
 .section	.rodata.cst256.K256, "aM", @progbits, 256
 .align 64
 K256:
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index e634b89a5123..d578fd98a0d6 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -41,6 +41,11 @@
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
+struct sha256_x2_mbctx {
+	u32 state[2][8];
+	const u8 *input[2];
+};
+
 struct sha256_x8_mbctx {
 	u32 state[8][8];
 	const u8 *input[8];
@@ -558,7 +563,102 @@ static int sha256_mb_next(struct ahash_request *req, unsigned int len,
 	return sha256_mb_fill(req, final);
 }
 
-static struct ahash_request *sha256_update_x8x1(
+static struct ahash_request *sha256_update_x1_post(
+	struct list_head *list, struct ahash_request *r2,
+	struct ahash_request **reqs, int width,
+	unsigned int len, bool nodata, bool final)
+{
+	int i = 0;
+
+	do {
+		struct sha256_reqctx *rctx = ahash_request_ctx(reqs[i]);
+
+		rctx->next = sha256_mb_next(reqs[i], len, final);
+
+		if (rctx->next) {
+			if (++i >= width)
+				break;
+			continue;
+		}
+
+		if (i < width - 1 && reqs[i + 1]) {
+			memmove(reqs + i, reqs + i + 1,
+				sizeof(r2) * (width - i - 1));
+			reqs[width - 1] = NULL;
+			continue;
+		}
+
+		reqs[i] = NULL;
+
+		do {
+			while (!list_is_last(&r2->base.list, list)) {
+				r2 = list_next_entry(r2, base.list);
+				r2->base.err = 0;
+
+				rctx = ahash_request_ctx(r2);
+				rctx->next = sha256_mb_start(r2, nodata, final);
+				if (rctx->next) {
+					reqs[i] = r2;
+					break;
+				}
+			}
+		} while (reqs[i] && ++i < width);
+
+		break;
+	} while (reqs[i]);
+
+	return r2;
+}
+
+static int sha256_chain_pre(struct ahash_request **reqs, int width,
+			    struct ahash_request *req,
+			    bool nodata, bool final)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *r2;
+	int i;
+
+	req->base.err = 0;
+	reqs[0] = req;
+	rctx->next = sha256_mb_start(req, nodata, final);
+	i = !!rctx->next;
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
+
+		r2->base.err = 0;
+
+		r2ctx = ahash_request_ctx(r2);
+		r2ctx->next = sha256_mb_start(r2, nodata, final);
+		if (!r2ctx->next)
+			continue;
+
+		reqs[i++] = r2;
+		if (i >= width)
+			break;
+	}
+
+	return i;
+}
+
+static void sha256_chain_post(struct ahash_request *req, bool final)
+{
+	struct sha256_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	struct ahash_request *r2;
+
+	if (!final)
+		return;
+
+	lib_sha256_base_finish(&rctx->state, req->result, ds);
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
+
+		lib_sha256_base_finish(&r2ctx->state, r2->result, ds);
+	}
+}
+
+static struct ahash_request *sha256_avx2_update_x8x1(
 	struct list_head *list, struct ahash_request *r2,
 	struct ahash_request *reqs[8], bool nodata, bool final)
 {
@@ -613,97 +713,30 @@ static struct ahash_request *sha256_update_x8x1(
 	}
 
 done:
-	i = 0;
-	do {
-		struct sha256_reqctx *rctx = ahash_request_ctx(reqs[i]);
-
-		rctx->next = sha256_mb_next(reqs[i], len, final);
-
-		if (rctx->next) {
-			if (++i >= 8)
-				break;
-			continue;
-		}
-
-		if (i < 7 && reqs[i + 1]) {
-			memmove(reqs + i, reqs + i + 1, sizeof(r2) * (7 - i));
-			reqs[7] = NULL;
-			continue;
-		}
-
-		reqs[i] = NULL;
-
-		do {
-			while (!list_is_last(&r2->base.list, list)) {
-				r2 = list_next_entry(r2, base.list);
-				r2->base.err = 0;
-
-				rctx = ahash_request_ctx(r2);
-				rctx->next = sha256_mb_start(r2, nodata, final);
-				if (rctx->next) {
-					reqs[i] = r2;
-					break;
-				}
-			}
-		} while (reqs[i] && ++i < 8);
-
-		break;
-	} while (reqs[i]);
-
-	return r2;
+	return sha256_update_x1_post(list, r2, reqs, 8, len, nodata, final);
 }
 
-static void sha256_update_x8(struct list_head *list,
-			     struct ahash_request *reqs[8], int i,
-			     bool nodata, bool final)
+static void sha256_avx2_update_x8(struct list_head *list,
+				  struct ahash_request *reqs[8], int i,
+				  bool nodata, bool final)
 {
 	struct ahash_request *r2 = reqs[i - 1];
 
 	do {
-		r2 = sha256_update_x8x1(list, r2, reqs, nodata, final);
+		r2 = sha256_avx2_update_x8x1(list, r2, reqs, nodata, final);
 	} while (reqs[0]);
 }
 
-static void sha256_chain(struct ahash_request *req, bool nodata, bool final)
+static void sha256_avx2_chain(struct ahash_request *req, bool nodata, bool final)
 {
-	struct sha256_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	unsigned int ds = crypto_ahash_digestsize(tfm);
 	struct ahash_request *reqs[8] = {};
-	struct ahash_request *r2;
-	int i;
+	int blocks;
 
-	req->base.err = 0;
-	reqs[0] = req;
-	rctx->next = sha256_mb_start(req, nodata, final);
-	i = !!rctx->next;
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
+	blocks = sha256_chain_pre(reqs, 8, req, nodata, final);
+	if (blocks)
+		sha256_avx2_update_x8(&req->base.list, reqs, blocks, nodata, final);
 
-		r2->base.err = 0;
-
-		r2ctx = ahash_request_ctx(r2);
-		r2ctx->next = sha256_mb_start(r2, nodata, final);
-		if (!r2ctx->next)
-			continue;
-
-		reqs[i++] = r2;
-		if (i >= 8)
-			break;
-	}
-
-	if (i)
-		sha256_update_x8(&req->base.list, reqs, i, nodata, final);
-
-	if (!final)
-		return;
-
-	lib_sha256_base_finish(&rctx->state, req->result, ds);
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		struct sha256_reqctx *r2ctx = ahash_request_ctx(r2);
-
-		lib_sha256_base_finish(&r2ctx->state, r2->result, ds);
-	}
+	sha256_chain_post(req, final);
 }
 
 static int sha256_avx2_update_mb(struct ahash_request *req)
@@ -712,7 +745,7 @@ static int sha256_avx2_update_mb(struct ahash_request *req)
 	int err;
 
 	if (ahash_request_chained(req) && crypto_simd_usable()) {
-		sha256_chain(req, false, false);
+		sha256_avx2_chain(req, false, false);
 		return 0;
 	}
 
@@ -736,7 +769,7 @@ static int _sha256_avx2_finup(struct ahash_request *req, bool nodata)
 	int err;
 
 	if (ahash_request_chained(req) && crypto_simd_usable()) {
-		sha256_chain(req, nodata, true);
+		sha256_avx2_chain(req, nodata, true);
 		return 0;
 	}
 
@@ -860,6 +893,7 @@ static void unregister_sha256_avx2(void)
 #ifdef CONFIG_AS_SHA256_NI
 asmlinkage void sha256_ni_transform(struct sha256_state *digest,
 				    const u8 *data, int rounds);
+asmlinkage void sha256_ni_x2(struct sha256_x2_mbctx *mbctx, int blocks);
 
 static int sha256_ni_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
@@ -916,19 +950,207 @@ static struct shash_alg sha256_ni_algs[] = { {
 	}
 } };
 
+static struct ahash_request *sha256_ni_update_x2x1(
+	struct list_head *list, struct ahash_request *r2,
+	struct ahash_request *reqs[2], bool nodata, bool final)
+{
+	struct sha256_state *states[2];
+	struct sha256_x2_mbctx mbctx;
+	unsigned int len = 0;
+	int i = 0;
+
+	do {
+		struct sha256_reqctx *rctx = ahash_request_ctx(reqs[i]);
+		unsigned int nbytes;
+
+		nbytes = rctx->next;
+		if (!i || nbytes < len)
+			len = nbytes;
+
+		states[i] = &rctx->state;
+		memcpy(mbctx.state[i], states[i], 32);
+		mbctx.input[i] = rctx->input;
+	} while (++i < 2 && reqs[i]);
+
+	len &= ~(SHA256_BLOCK_SIZE - 1);
+
+	if (i < 2) {
+		sha256_ni_transform(states[0], mbctx.input[0],
+				    len / SHA256_BLOCK_SIZE);
+		goto done;
+	}
+
+	sha256_ni_x2(&mbctx, len / SHA256_BLOCK_SIZE);
+
+	for (i = 0; i < 2; i++)
+		memcpy(states[i], mbctx.state[i], 32);
+
+done:
+	return sha256_update_x1_post(list, r2, reqs, 2, len, nodata, final);
+}
+
+static void sha256_ni_update_x2(struct list_head *list,
+				  struct ahash_request *reqs[2], int i,
+				  bool nodata, bool final)
+{
+	struct ahash_request *r2 = reqs[i - 1];
+
+	do {
+		r2 = sha256_ni_update_x2x1(list, r2, reqs, nodata, final);
+	} while (reqs[0]);
+}
+
+static void sha256_ni_chain(struct ahash_request *req, bool nodata, bool final)
+{
+	struct ahash_request *reqs[2] = {};
+	int blocks;
+
+	blocks = sha256_chain_pre(reqs, 2, req, nodata, final);
+	if (blocks)
+		sha256_ni_update_x2(&req->base.list, reqs, blocks, nodata, final);
+
+	sha256_chain_post(req, final);
+}
+
+static int sha256_ni_update_mb(struct ahash_request *req)
+{
+	struct ahash_request *r2;
+	int err;
+
+	if (ahash_request_chained(req) && crypto_simd_usable()) {
+		sha256_ni_chain(req, false, false);
+		return 0;
+	}
+
+	err = sha256_ahash_update(req, sha256_ni_transform);
+	if (!ahash_request_chained(req))
+		return err;
+
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		err = sha256_ahash_update(r2, sha256_ni_transform);
+		r2->base.err = err;
+	}
+
+	return 0;
+}
+
+static int _sha256_ni_finup(struct ahash_request *req, bool nodata)
+{
+	struct ahash_request *r2;
+	int err;
+
+	if (ahash_request_chained(req) && crypto_simd_usable()) {
+		sha256_ni_chain(req, nodata, true);
+		return 0;
+	}
+
+	err = sha256_ahash_finup(req, nodata, sha256_ni_transform);
+	if (!ahash_request_chained(req))
+		return err;
+
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		err = sha256_ahash_finup(r2, nodata, sha256_ni_transform);
+		r2->base.err = err;
+	}
+
+	return 0;
+}
+
+static int sha256_ni_finup_mb(struct ahash_request *req)
+{
+	return _sha256_ni_finup(req, false);
+}
+
+static int sha256_ni_final_mb(struct ahash_request *req)
+{
+	return _sha256_ni_finup(req, true);
+}
+
+static int sha256_ni_digest_mb(struct ahash_request *req)
+{
+	return sha256_ahash_init(req) ?:
+	       sha256_ni_finup_mb(req);
+}
+
+static int sha224_ni_digest_mb(struct ahash_request *req)
+{
+	return sha224_ahash_init(req) ?:
+	       sha256_ni_finup_mb(req);
+}
+
+static struct ahash_alg sha256_ni_mb_algs[] = { {
+	.halg.digestsize =	SHA256_DIGEST_SIZE,
+	.halg.statesize	=	sizeof(struct sha256_state),
+	.reqsize	=	sizeof(struct sha256_reqctx),
+	.init		=	sha256_ahash_init,
+	.update		=	sha256_ni_update_mb,
+	.final		=	sha256_ni_final_mb,
+	.finup		=	sha256_ni_finup_mb,
+	.digest		=	sha256_ni_digest_mb,
+	.import		=	sha256_import,
+	.export		=	sha256_export,
+	.halg.base	=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name =	"sha256-ni-mb",
+		.cra_priority	=	260,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+		.cra_flags	=	CRYPTO_ALG_REQ_CHAIN,
+	}
+}, {
+	.halg.digestsize =	SHA224_DIGEST_SIZE,
+	.halg.statesize	=	sizeof(struct sha256_state),
+	.reqsize	=	sizeof(struct sha256_reqctx),
+	.init		=	sha224_ahash_init,
+	.update		=	sha256_ni_update_mb,
+	.final		=	sha256_ni_final_mb,
+	.finup		=	sha256_ni_finup_mb,
+	.digest		=	sha224_ni_digest_mb,
+	.import		=	sha256_import,
+	.export		=	sha256_export,
+	.halg.base	=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name =	"sha224-ni-mb",
+		.cra_priority	=	260,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+		.cra_flags	=	CRYPTO_ALG_REQ_CHAIN,
+	}
+} };
+
 static int register_sha256_ni(void)
 {
-	if (boot_cpu_has(X86_FEATURE_SHA_NI))
-		return crypto_register_shashes(sha256_ni_algs,
-				ARRAY_SIZE(sha256_ni_algs));
-	return 0;
+	int err;
+
+	if (!boot_cpu_has(X86_FEATURE_SHA_NI))
+		return 0;
+
+	err = crypto_register_shashes(sha256_ni_algs,
+				      ARRAY_SIZE(sha256_ni_algs));
+	if (err)
+		return err;
+
+	err = crypto_register_ahashes(sha256_ni_mb_algs,
+				      ARRAY_SIZE(sha256_ni_mb_algs));
+	if (err)
+		crypto_unregister_shashes(sha256_ni_algs,
+					  ARRAY_SIZE(sha256_ni_algs));
+
+	return err;
 }
 
 static void unregister_sha256_ni(void)
 {
-	if (boot_cpu_has(X86_FEATURE_SHA_NI))
-		crypto_unregister_shashes(sha256_ni_algs,
-				ARRAY_SIZE(sha256_ni_algs));
+	if (!boot_cpu_has(X86_FEATURE_SHA_NI))
+		return;
+
+	crypto_unregister_ahashes(sha256_ni_mb_algs,
+				  ARRAY_SIZE(sha256_ni_mb_algs));
+	crypto_unregister_shashes(sha256_ni_algs, ARRAY_SIZE(sha256_ni_algs));
 }
 
 #else
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
