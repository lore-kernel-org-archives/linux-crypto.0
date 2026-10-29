Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305309;
	b=qvo+q+FPFbgHsZCmtCYyelpukjmcqR2Hmxk4Tiav6sGJ91ysELsA+4LLblI7pgoA0v6B
	 cxYy3pvtQSXg+IfdpOl6YJ8ZdzIPxCmrWiyGaT2aS3i23L3tS7vWEnhpVRzCtSz+6apPN
	 ilL7wp1rk/zTvGWDkuGI295AoZt4dqZ3rLPE8/oWIaTpdu1MP/VHF5H6EszxxFG/F9AE1
	 otAUOlU0b+SRX156hRhxu2hAGx3GYmyamXUmSOjdkBDqqjt8MIXlUqykk2JfQDYTK9v9+
	 Tl4oe+tq26XwLEKnfnt6E7jwqGD5r8EVcHnJpc/eADU8/L/dVsdJ0gHGWRNZYfrsSTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NG0rcom/ENkoFyoDk/mPLZtYS0KiuQXHp5StsiKbwa0=;
	b=OYB6sVr7wD4k163w2DFCBSszgAoSpVGIhdi+NMyZqu2goVtD2mRGQOcX1fF5s99v502d
	 qbmRl1xwWiHQOpBpcvWjMkiBv/0P9rO8K/UqHLeLNBmjLNzFXLc8P9LOzP95S4qQwNxNN
	 BH7mr2fQ/kOrTrRs4Eu2Qj8V5x4gDiFwuSMUH8NTw19qmJxXbdACEE143ZcicrZ+9U8Dl
	 wPPPimJHh0F5vrXI+7F66pnkqQBAAEmSTn9qNxasXnzwotjoNN96tPK3IPYESA2TvYrC3
	 ZomGJ9ssd3h2eQDMIaAv5hjwM4wKB4V0ylNGR9buBEj3u3HNjXRHoj5ydYTCeg8AI6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMAEgbat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B891606A31A;
	Thu, 29 Oct 2026 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMAEgbat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A651F01824;
	Thu, 29 Oct 2026 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793305308;
	bh=NG0rcom/ENkoFyoDk/mPLZtYS0KiuQXHp5StsiKbwa0=;
	h=From:To:Cc:Subject:Date;
	b=aMAEgbatqidp4Sh9pQm3Be0xzXLa4NYSh5zhsmHTEj9++DmK19Zy8f+y0832Dga/9
	 3+pwUw2wCOa8N1e5akRA74BEpKuztAXuQ5dRWuhm3A5YdqH2UGQclLe1hKR78Oexld
	 HfpfQ/VNX+Tkmk1tucZWf90ZF+rTpPPfNILM3Dtr4fGKp8sP1zizaIsO0z51XmuSex
	 xKcBgka54K10/GK6kOMzWWs9UD7rj867JSG84V0x99lSSY+4p06gT2JyToX7tDtWF4
	 pylNw2x8mbQwcJaED82syZ9wqZgqZYCEeTd3hxHv0BoK+eGkou/VHLiewS19azN+51
	 J0B2nhA/WLG4g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12,6.6,6.1,5.15,5.10] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Thu, 29 Oct 2026 13:20:14 -0700
Message-ID: <20261029202014.51014-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 24f07e8c07a0c0dd275331cbb41c79a78741eef9 upstream.

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

represents 4 + 2^26*2^26 + (2^26-1)*2^52 + (2^26-1)*2^78 +
(2^24-1)*2^104 = 2^128 + 4, despite the bit representing the 2^128 term
(bit 24 of h4) not being set; the extra comes from the h1 limb being
above the normal base 2^26 range.  When this value is converted into the
non-redundant base 2^64 form, a carry into the new 2^128 bit (in bit 0
of h2) is necessary to preserve the value.

Given the above bounds, a carry into bit 128 happens exactly when
h1 >= 2^26, h2 = h3 = 2^26 - 1, and h4 mod 2^24 = 2^24 - 1.

Store the carry into h2, matching the other base 2^26 to base 2^64
conversions in poly1305_blocks() and poly1305_emit().

This bug causes an incorrect tag to be emitted.  However, this is
unlikely to happen in practice where Poly1305 is used with a random key,
since the random key tends to distribute the accumulator values
throughout their valid range.  There isn't an obvious way for an
attacker without knowledge of the r_key to cause [h0, h1, h2, h3, h4] to
land on the precise values where this bug occurs.

[EB: Rewrote the commit message to more clearly describe the bug and
 its impact, and simplified explanation about why there's a carry bit.]

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20261009125354.315476-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/poly1305-armv8.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly1305-armv8.pl
index 22c9069c06505..e69419b0ca01e 100644
--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -372,7 +372,7 @@ poly1305_blocks_neon:
 	adc	$h1,$h1,xzr
 	lsr	$h2,x14,#24
 	adds	$h1,$h1,x14,lsl#40
-	adc	$d2,$h2,xzr		// can be partially reduced...
+	adc	$h2,$h2,xzr		// preserve carry into top limb
 
 	ldp	$d0,$d1,[$inp],#16	// load input
 	sub	$len,$len,#16

base-commit: 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
-- 
2.56.0

