Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403626;
	b=qmeFDjJpWcOH6zSD7eiZW6iFH2EfvBmpPoD0U33a/Ua/eX4DNjVawEtqlOkA06MhZL7i
	 7BoriejOs+wwfBPotLioTOQPI83Tz0ALfbvguj5j8nOnBb98DAznGyebi00p63wpWfEpL
	 +26cNHOnUcLAI57DH6I9bacyieky0daj4mi2XbIlgFqZwhohfrqk8O7kyUOuYauKb27lP
	 azyIvHjOK4cbxiHOppgln9BMFPqiOZVlABu1CItWbPGOgkDcYuAsICgJ3s8nkNGll0oWC
	 +oCpeFIa/VtKP+GOhruBAxvRjlTke4AiNBF3wDVVnG6PeP0HYBI7Fhal6MFomgnMsWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OLNqAAbAA4xt48JFwCjDTzX0/tBK9Ub2YKjkac4b7YE=;
	b=KNnlORKxGO9HCd0JMZpvlIkjxIrERUy8/qgUG1WxAg6FgBT2fqjJFluWFsSfUTzcX+1G
	 +c+I5CYRAor9tEq41FK/wfsKRu5QNZ8xWWswMYE5lYxTDLrxISgdYEVYT9m+5u5huPPuj
	 x8oYhYJSjtj56/QywwsnCXID59H2C87D65XaRqI+ng225TqxV1CXXhW5dYII/bniJhrRz
	 9PcWnlBNhR6MBzqFIMSVl3nL9rgRNXR9Q/n2MYG03lhckPH/23D6D2iXPw0A7HJHAghga
	 uZ6bil4DzCIDMHu54KH57ttbtQaiwQCNsS0uG7nkSpw3VkGoN8R2vlX3iblY78/kxzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vc1A2XcA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF19606A31E
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 03:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vc1A2XcA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32FC1F000CA;
	Mon, 23 Nov 2026 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795403625;
	bh=OLNqAAbAA4xt48JFwCjDTzX0/tBK9Ub2YKjkac4b7YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc1A2XcAc/yn5b+DP1JF/kqitOXbE5BeDESRG75PUoXJ/mZHxAjlrD5jh+QNU+I4m
	 YdVf6o1diQTRLEp9ceL1KP29rNMUivsnfcv+TYJgT+8BrAq86Wn3c7/yyYJy6XLm3s
	 BRghRGeGR1Jaq8yXMTGzX9KdHVU4o++MQLR/6RgI9vnJM7DC0RUfQFND/kC6phRuHb
	 1FYfaFzFatKRtNUxl+BoC5E0g/y7w1PbXfgQvneYQiqApO9jffntZRmlRq/6dBsAow
	 PgNyle4ZaqPqkacZ8rrO4ddz4aSucQqOggJ7Y9bHMee+o4RV1FXaXeYXKOuIx5E+rD
	 v4nwFRzJ9DNfA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] lib/crypto: x86/sha512-avx2: Optimize SHA512_Round
Date: Sun, 22 Nov 2026 19:13:21 -0800
Message-ID: <20261123031321.403308-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261123031321.403308-1-ebiggers@kernel.org>
References: <20261123031321.403308-1-ebiggers@kernel.org>
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

Make two related optimizations to the SHA-512 round computation.

First, replace the Majority function computation:

    Maj(a, b, c) = ((a | c) & b) | (a & c)

... with the equivalent computation:

    Maj(a, b, c) = ((b | c) & a) | (b & c)

This is helpful because it uses 'a' later, matching its later
availability.  ('a' was just computed by the previous round, whereas 'b'
and 'c' were computed by the two rounds before that.)  This reduces the
latency of Maj(a, b, c) from 'a' from 3 cycles to 2 cycles.

Second, now that Maj() is less likely to be a bottleneck, reassociate
the additions.  Instead of:

    h += w + k
    d += h
    h += S0(a)
    t = S1(e) + Ch(e, f, g)
    d += t
    h += t
    h += Maj(a, b, c)

Do the following (which conveniently also more closely matches the way
the SHA-2 specification describes the algorithm):

    t1 = h + w + k + Ch(e, f, g) + S1(e)
    d += t1
    t2 = Maj(a, b, c) + S0(a)
    h = t1 + t2

The CPU can compute t2 in parallel with t1, shortening the critical path
for updating 'h' (the next round's 'a') from 6 cycles to 5 cycles from
'a' and 'e' -- assuming that 'xor', 'add', and 'rorx' have a latency of
1 cycle, as they do on current CPUs.  The critical path for updating 'd'
(the next round's 'e') remains at 5 cycles from 'e'.  The new code also
has one fewer instruction per round: one of the 'add' instructions is
gone.  Finally, the new code also uses one fewer scratch register: %rsi
(alias y3) is no longer used, so INP no longer needs to be spilled.

This commit makes SHA-512 about 5% faster on AMD Ryzen 9 9950X (Zen 5)
and about 6% faster on Intel Sapphire Rapids.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha512-avx2-asm.S | 44 ++++++++++++++------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index f64ef3adcd6c1..2b6151cebd852 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -86,7 +86,6 @@ NUM_BLKS    = %rdx
 c           = %rcx
 d           = %r8
 e           = %rdx
-y3          = %rsi
 
 TBL   = %rdi # clobbers CTX1
 
@@ -105,14 +104,12 @@ y2    = %r15
 # Local variables (stack frame)
 XFER_SIZE = 4*8
 SRND_SIZE = 1*8
-INP_SIZE = 1*8
 INPEND_SIZE = 1*8
 CTX_SIZE = 1*8
 
 frame_XFER = 0
 frame_SRND = frame_XFER + XFER_SIZE
-frame_INP = frame_SRND + SRND_SIZE
-frame_INPEND = frame_INP + INP_SIZE
+frame_INPEND = frame_SRND + SRND_SIZE
 frame_CTX = frame_INPEND + INPEND_SIZE
 frame_size = frame_CTX + CTX_SIZE
 
@@ -162,38 +159,38 @@ frame_size = frame_CTX + CTX_SIZE
 # Do one SHA-512 round using the state a-h and \wk = W[t] + K[t].  Updates a-h
 # and rotates their aliases to match what the next round expects.
 .macro SHA512_Round wk
+	add	\wk, h		# h = h + w + k
 	mov	f, y2		# y2 = f
 	rorx	$41, e, y0	# y0 = e ror 41
 	rorx	$18, e, y1	# y1 = e ror 18
 	xor	g, y2		# y2 = f ^ g
-	add	\wk, h		# h = h + w + k
 
 	xor	y1, y0		# y0 = (e ror 41) ^ (e ror 18)
 	rorx	$14, e, y1	# y1 = e ror 14
 	and	e, y2		# y2 = (f ^ g) & e
-	add	h, d		# d = d + h + w + k
 
 	xor	y1, y0		# y0 = S1(e)
 	xor	g, y2		# y2 = Ch(e, f, g) = ((f ^ g) & e) ^ g
-	rorx	$34, a, T1	# T1 = a ror 34
-	rorx	$39, a, y1	# y1 = a ror 39
-	mov	a, y3		# y3 = a
+	add	y2, h		# h = h + w + k + Ch(e, f, g)
 
-	xor	T1, y1		# y1 = (a ror 39) ^ (a ror 34)
-	rorx	$28, a, T1	# T1 = a ror 28
-	or	c, y3		# y3 = a | c
+	mov	b, y2		# y2 = b
+	mov	b, T1		# T1 = b
+	or	c, y2		# y2 = b | c
+	and	c, T1		# T1 = b & c
+	add	y0, h		# h = t1 = h + w + k + Ch(e, f, g) + S1(e)
 
-	xor	T1, y1		# y1 = S0(a)
-	mov	a, T1		# T1 = a
-	and	b, y3		# y3 = (a | c) & b
-	and	c, T1		# T1 = a & c
-	add	y0, y2		# y2 = S1(e) + Ch(e, f, g)
+	rorx	$39, a, y1	# y1 = a ror 39
+	and	a, y2		# y2 = (b | c) & a
+	rorx	$34, a, y0	# y0 = a ror 34
+	or	T1, y2		# y2 = Maj(a, b, c) = ((b | c) & a) | (b & c)
+
+	xor	y0, y1		# y1 = (a ror 39) ^ (a ror 34)
+	rorx	$28, a, y0	# y0 = a ror 28
+	add	h, d		# d = d + t1
+	xor	y0, y1		# y1 = S0(a)
 
-	or	T1, y3		# y3 = Maj(a, b, c) = ((a | c) & b) | (a & c)
-	add	y1, h		# h = h + w + k + S0(a)
-	add	y2, d		# d = d + t1
-	add	y2, h		# h = t1 + S0(a)
-	add	y3, h		# h = t1 + S0(a) + Maj(a, b, c)
+	add	y1, y2		# y2 = t2 = Maj(a, b, c) + S0(a)
+	add	y2, h		# h = t1 + t2
 
 	RotateState
 .endm
@@ -326,8 +323,6 @@ SYM_FUNC_START(sha512_transform_rorx)
 	vpshufb	YBSWAP, Y_\i, Y_\i
 .endr
 
-	mov	INP, frame_INP(%rsp)
-
 	# Do rounds 0..63 and compute W[16..79] (interleaved) in four loop
 	# iterations, each of which does four groups of four rounds.
 	movq	$4, frame_SRND(%rsp)
@@ -382,7 +377,6 @@ SYM_FUNC_START(sha512_transform_rorx)
 	addm	8*6(CTX2), g
 	addm	8*7(CTX2), h
 
-	mov	frame_INP(%rsp), INP
 	add	$128, INP
 	cmp	frame_INPEND(%rsp), INP
 	jne	.Lloop0
-- 
2.56.1

