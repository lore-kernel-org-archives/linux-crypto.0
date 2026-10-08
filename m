Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100113DDB0D;
	Thu,  8 Oct 2026 20:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490811; cv=none; b=mn8pi78tq1w8H/UX1Ocw74pI3lb35y/xqp5vkWpTM5xQoxt0dqC2TZ6wF8ARkhfufVSdEBi8b/wT8od3/P65JVLrieUIE62kpFGBwhmPPM337l516H22tLEoVf/7LZYxmHU84rta9YF33IdOOvVbgoVsdysicbKhy4Guz5FC/ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490811; c=relaxed/simple;
	bh=T96s/fnsrHONgXeIXpGKt3YQJDuWHY9BMRyIWUEgkFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2HQPyjeQsn0DUTGt15UvTWFzqmHqy9FQZkTSdyMz4Ia7hzax3F0zX0l1MtWGlyrpoevHZahOnoJx0h7xevOg1vU3bmHWi45jYrKKr2mLvRhUZJ6hNd/8t1Jn9A8rtVAhFH1SaTSWAbq8r/so5GyjEJfk/tWvDStTY2bXsnHP5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=PL1MCQ6d; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="PL1MCQ6d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=btQhSQmBe7ws4MECTxH8P0ozyn0FAhTOQxzSzXwLJdk=; b=PL1MCQ6doOKYlzalYCR4eDHw/f
	karfXpp4uonEqvOYPFUF/lYsTunsJwwADcAsrfPMr+XIZbSUVvbtMHq/HgR0gIPXOA9V8z6QZoLWw
	opLn1TbXU9GjzPIHbTp/xUgnw0WxF1hw0fXOERIdDEbbc4NCCV4b4O0rVmLzIWSNs/IO3n+vohwV8
	z1dDyNYBGElvpT0x3bMgoefrfdKHmVjgWn4X8wjBrtCMIx5/TsIU0rfpi3FSyB02XW+KuQLSZm7LT
	xVL06dEsuY+XK+YRxvwxZatM0MujdE/98/FK2JwGRuTZpzt9cwXGARfPRgDjPA+QchhJTSXfT2o3m
	I4TUQf1g==;
Received: from [151.115.150.205] (port=38102 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xEub1-00000002wY0-1516;
	Thu, 08 Oct 2026 22:20:07 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Thu,  8 Oct 2026 20:19:50 +0000
Message-ID: <20261008201949.561207-4-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

When poly1305_blocks_neon() resumes from a lazily reduced NEON
accumulator and the next update contains an odd number of full
16-byte blocks, it processes one leading block through
poly1305_mult() so that the remaining NEON work has an even block
count. That requires converting the accumulator into the base 2^64
form used by poly1305_mult(). The final ADC stores the carry into d2,
but the following accumulation and poly1305_mult() use h2. If the
conversion overflows across bit 128, the carry is dropped and the
emitted tag is wrong.

This was introduced by Cryptogams 03dc4adf91c8
("arm/poly1305-armv*.pl: optimize branches."), which removed the
reduction that consumed d2 shortly before Linux imported the code.
OpenSSL's copy did not take that change.

That carry is possible because the NEON loop stores a lazily reduced,
redundant base 2^26 representation. Consider the reachable state
  [4,   2^26,   2^26 - 1,   2^26 - 1,   2^24 - 1].
These limbs in base 2^26 represent the value
      4 
    + (2^26    ) * 2^26
    + (2^26 - 1) * 2^52
    + (2^26 - 1) * 2^78
    + (2^24 - 1) * 2^104
  = 2^128 + 4,
so converting back to base 2^64 must produce
  h0 = 4, h1 = 0, h2 = 1,
so that h0 + h1 * 2^64 + h2 * 2^128 = 2^128 + 4.

The third limb starts at bit 52, so its low 12 bits belong in h0 and
its upper 14 bits belong in h1. The low-word ADDS starts from
  4 + 2^26 * 2^26 = 2^52 + 4
and adds the low 64 bits of
  (2^26 - 1) << 52 = 2^78 - 2^52,
namely 2^64 - 2^52. The sum is 2^64 + 4, so it leaves h0 = 4 and
carry = 1.

The middle word contains the upper 14 bits of the third limb, all of
the fourth limb, and the low 24 bits of the fifth limb. The next ADC
adds the carry from h0 to
  ((2^26 - 1) >> 12) + ((2^26 - 1) << 14),
giving
  (2^14 - 1) + (2^40 - 2^14) + 1 = 2^40.
The following ADDS adds the low 64 bits of
  (2^24 - 1) << 40 = 2^64 - 2^40,
so the sum is 2^64, h1 wraps to 0, and carry = 1.

The top word starts from the remaining bits of the fifth limb,
  (2^24 - 1) >> 24 = 0.
The final ADC must add the carry from h1 and set h2 = 1. Writing the
carry into d2 instead leaves h2 = 0, so the reconstructed value is 4
instead of 2^128 + 4.

More generally, for [a0, a1, a2, a3, a4], this carry exists only when 
  a1 >= 2^26,
  a2 = a3 = 2^26 - 1,
  a4 mod 2^24 = 2^24 - 1.
This is about 2^36 tuples out of about 2^130, or about one in 2^94 for
uniformly random tuples.

Store the carry back into h2. This matches the other conversion paths
and preserves the represented accumulator. Under regular use,
triggering this bug by chance is highly improbable; this fix addresses
arithmetic correctness only.

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---

Changes in v2:
 - Add an example of computations demonstrating the error.
 - Provide an estimate of the low probability it gets triggered.
 - Add a paragraph mentionning the introducing commit in Cryptogams
   repo, and non-impact on OpenSSL.

v1: https://lore.kernel.org/all/20261007220235.200818-2-Jeremy.Jean@oss.cyber.gouv.fr/

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
2.47.3
