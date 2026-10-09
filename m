Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254BA486E40;
	Fri,  9 Oct 2026 12:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550482; cv=none; b=tgYhflzIBfxVVhvbcbopL87gny0CnAK/Zq97QdfiL1Lhk2WrGDcBma+Quh5zOqPavrd8xUapvmVUeoR4BjBSdNhEr5NGLFtCwseBJBkq7MEsFVdHH4DpPVpiyjrP61C/K6ooURhzxanGTVuSyCwSBi705m6+ErSTZQ0Vbw+gsqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550482; c=relaxed/simple;
	bh=CAJpIALCNKBs7+IQqpobbfwiPFOMMgsIrlFEutuXWEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XtDuAuqKP+NcOfbZ//jKpp9CV9pKj1T7z5/3vcVo9ltWvxmGVBLW8J6aUMTcI7cmTJ1PisKmugI++9GeSXyqdpiakGeVtg/FFHdcNJEGYbA+jg+EXOOdULHkM8wwheI2RKJ/qXQNFyHX1ZBE7NMbmN8XBztzOOG8++TVDBDg51o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0TYGnHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0TYGnHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A811F00893;
	Fri,  9 Oct 2026 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550478;
	bh=wN9BHkt86Y/qHrXCRuKCB1Rre2zJtJsy9zYh9NyiYs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0TYGnHlpxTrTLdzCPG5DNTnffxT+6cnt/m7A0CJJ70Ad8A+Lt4gbwzsYt+YCY4Ej
	 qaXwzJdtT21dBAGvz2KiZ8iv5VcRzCa0QQRVIWhAeFqa/HdOBMUnyfJChqxea27Y6L
	 NudVqgsDKePcEPPKcWdG7pdC2YcLAmeLN+UuwhDCdEhdqCX6kCocJyRuNdHsOWi8TO
	 D+l9ikOCvt8+xWLOzl8GhzKbAzApxUZIjyLmcIl207FEJLBY0oXCA8ByvtM5SUCRyn
	 KjE2Js9OnMcMZYdk8SWVE8vEX2DFuQt4/lug70IpG3vaR4vNYxqRBn3uAoJIuvLOQo
	 yqA6PemeJuCkw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Fri,  9 Oct 2026 14:53:53 +0200
Message-ID: <20261009125354.315476-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009125354.315476-1-ebiggers@kernel.org>
References: <20261009125354.315476-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

When poly1305_blocks_neon() resumes from a base 2^26 accumulator and the
next update contains an odd number of full 16-byte blocks, it processes
one leading block through poly1305_mult() so that the remaining NEON
work has an even block count.  That requires converting the accumulator
to the base 2^64 form used by poly1305_mult().  The final ADC of that
conversion stores the carry into d2, but the following accumulation and
poly1305_mult() use h2.  If the conversion carries across bit 128, the
carry is dropped and the emitted tag is wrong.

This was introduced by Cryptogams commit 03dc4adf91c8
("arm/poly1305-armv*.pl: optimize branches."), which removed the
reduction that consumed d2 shortly before Linux imported the code.
OpenSSL's copy did not take that change.

The carry is possible because the NEON code stores the accumulator [h0,
h1, h2, h3, h4] in a lazily reduced, redundant base 2^26 form: its final
carry chain leaves h0, h2, h3 < 2^26, but h1 and h4 may slightly exceed
2^26 - 1.  For example, the reachable state

  h0 = 4
  h1 = 2^26
  h2 = 2^26 - 1
  h3 = 2^26 - 1
  h4 = 2^24 - 1

represents 2^128 + 4, so the conversion must produce the base 2^64 limbs
h0 = 4, h1 = 0, h2 = 1.  The low 64-bit word sums to 2^64 + 4 and the
middle 64-bit word (including the carry from the low word) sums to 2^64,
so both carry out.  However, the carry out of the middle word goes to
d2, leaving h2 = 0 and the value 4 instead of 2^128 + 4.

Given the above bounds, a carry across bit 128 happens exactly when
h1 >= 2^26, h2 = h3 = 2^26 - 1, and h4 mod 2^24 = 2^24 - 1.

Store the carry into h2, matching the other base 2^26 to base 2^64
conversions in poly1305_blocks() and poly1305_emit().

This bug causes an incorrect tag to be emitted.  However, this is
unlikely to happen in practice where Poly1305 is used with a random key,
since the random key tends to distribute the accumulator values
throughout their valid range.  There isn't an obvious way for an
attacker without knowledge of the r_key to cause [h0, h1, h2, h3, h4] to
land on the precise values where this bug occurs.

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
[EB: Rewrote the commit message to more clearly describe the bug and
 its impact, and removed a lot of pointless LLM-generated text.]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm64/poly1305-armv8.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/arm64/poly1305-armv8.pl b/lib/crypto/arm64/poly1305-armv8.pl
index f1930c6b55ce..234398ff6b60 100644
--- a/lib/crypto/arm64/poly1305-armv8.pl
+++ b/lib/crypto/arm64/poly1305-armv8.pl
@@ -375,7 +375,7 @@ poly1305_blocks_neon:
 	adc	$h1,$h1,xzr
 	lsr	$h2,x14,#24
 	adds	$h1,$h1,x14,lsl#40
-	adc	$d2,$h2,xzr		// can be partially reduced...
+	adc	$h2,$h2,xzr		// preserve carry into top limb
 
 	ldp	$d0,$d1,[$inp],#16	// load input
 	sub	$len,$len,#16
-- 
2.56.0

