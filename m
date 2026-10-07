Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76108392C46;
	Wed,  7 Oct 2026 22:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791410871; cv=none; b=rMhyn1LJW2BLp4e2QMBwa4n8yXQxHHNzJeG/oAbqbip35KBXQpeJ9rjnrFGlLL7Dxx+kABsfAgyB7ZZs3FAhqhEZG/dtiWiEX8uuedC5jWpgqpHhEC0NiL3nDNQPkfUve2bM2iAXfZ3bipKND1t12Z+BmjT3kfbUpr60ovp+uv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791410871; c=relaxed/simple;
	bh=Yz91O8hGC8SKXGWCJAsfrEdUHmyCU3N27q11SmIGAgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Su2oBBMY51CoOKBEfr1eTjUOHGKaKSmRrj1NGVsHxUK5YwTMWKGYDNmUXLmRjDDYSp3t0LHV2Gjc02uv9ZfN8wRHd1eOy9wZ3Z0o3iDDr3d+QY5CeoSslIQiL6d/O+mgF7hyb6/MzSXm5RwJah/b2P7OOYbk4TxUF1QrbzpNANk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=UrxfGzJx; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="UrxfGzJx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=k1FsZeqVOwtqbCaRxGcfIEnljfC6GJbQZ2/ERsudhWY=; b=UrxfGzJxFKNQEdeX4vRD5Dv4WR
	+hjXDX6TWc9UZOl/0SlTSsPibXE/9qL2Tk6HStqk5MuGeBlJX0c5K4Er/Joggqn95p2DoVBtyIkgJ
	REoJ7yHP/oXWVOUOtJgAXZ9S/S0qHjc7NRJRQSg3hAydxPdSmUtTx12gaGVnsVJtuWWmVtktUtLlN
	wbxyBoKF+pqho6eSplfgZ6EBoSIW7bD1bp0KbSLSJcLJCjFt1IQ4dhJ4XuRXfM4ItQPjLLn8th6P1
	hv1AyffMFCzBcPGC+gCmKMDCI88LAFPuYscNBCM4Z8w31IE8PiFlDvBbRlnnk9RS7O960TJJ42ghd
	fdGPLQPA==;
Received: from [151.115.150.205] (port=58268 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xEZnh-00000002ncT-1pnJ;
	Thu, 08 Oct 2026 00:07:47 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
Date: Wed,  7 Oct 2026 22:02:36 +0000
Message-ID: <20261007220235.200818-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
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

When poly1305_blocks_neon() resumes from a radix-2^26 state with an odd
number of input blocks, it converts the accumulator back to radix-2^64
before consuming the first block. The final ADC stores the carry into d2,
but the following accumulation and poly1305_mult() use h2.  If the
conversion overflows across bit 128, the carry is dropped and the emitted
tag is wrong.

Store the carry back into h2. This matches the other conversion paths and
preserves the represented accumulator.

Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 lib/crypto/arm64/poly1305-armv8.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/arm64/poly1305-armv8.pl b/lib/crypto/arm64/poly1305-armv8.pl
index f1930c6..234398f 100644
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

