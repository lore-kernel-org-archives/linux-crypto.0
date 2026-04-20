Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6734382F30;
	Mon, 20 Apr 2026 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667020; cv=none; b=NqH3l3bUYgy2xy7A2uwQqs3uSVEfQonC01lkxgIroieWHzEUJMVsJFksWS77Y8hOo8j6Gk0xkcpMHBil4zlFhhk2+VFzs2u7ClfCUjsZW7wpBXbbhn+N5LVeem0CgB0DhRpkF8orDwS7B7aDULGjuSgEo4emcgjbUEotNJe6LLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667020; c=relaxed/simple;
	bh=E/caBFaT5oe5iu25OVDOFiTddXIWeBTyZnY1rZiZXwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UihbA5m7jH9BvZpg17TUlZxybQbQSlO/PIc7JTar610PlASyEx25yL/IN72NFTuZGGY0gYv+0uOu4VG1enCgaAZDw/yG6D7xg+8fvAuEVJ6xg1HU6OTSGs8wvCJssX8mOMjADTDIxU687I02AMkTKcPHIoJc7B6upaiI2wsOkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLjZBPx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLjZBPx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C379C2BCB3;
	Mon, 20 Apr 2026 06:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667020;
	bh=E/caBFaT5oe5iu25OVDOFiTddXIWeBTyZnY1rZiZXwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLjZBPx1SsrFsCND9zwOT0GbL8Z+Ft464paDL0WAqQbCS5LlrlkPHCOL4kVBgJcqR
	 yDVJ1u1maay5aJtArBKYvjAnxDzz9nj2JfK6CKRtSU6YiOmDQmIf7RMn/VwAOHUBkE
	 CnA5yOR+VnorBp2KbOTWHzZnmr0ueFBQ7ttjUM5crmqby9q2HJKSpbnChhYwdoAMIB
	 6hFaDZ1VgJ6xgwMoqpap3y36C5ECNCZQPA4d8nH4pyS53fxWKmqWiyzJulgbBlp5LF
	 UPjQOrVbpbKM1m98wxZEEKRZc229u7oQY5XK1LxBtquPjn+/WTzAU88V95xdd3bwYF
	 m+ym9jsLKZ9EQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 04/38] crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
Date: Sun, 19 Apr 2026 23:33:48 -0700
Message-ID: <20260420063422.324906-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 64-bit kernels, drbg_max_addtl() returns 2**35 bytes.  That's too
large, for two reasons:

1. SP800-90A says the maximum limit is 2**35 *bits*, not 2**35 bytes.
   So the implemented limit has confused bits and bytes.

2. When drbg_kcapi_hash() calls crypto_shash_update() on the additional
   information string, the length is implicitly cast to 'unsigned int'.
   That truncates the additional information string to U32_MAX bytes.

Fix the maximum additional information string length to always be
U32_MAX - 1, causing an error to be returned for any longer lengths.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/drbg.h | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 2d42518cbdce..c11eaf757ed0 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -146,23 +146,19 @@ static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
 {
 	/* SP800-90A requires the limit 2**19 bits, but we return bytes */
 	return (1 << 16);
 }
 
+/*
+ * SP800-90A allows implementations to support additional info / personalization
+ * strings of up to 2**35 bits.  Implementations can have a smaller maximum.  We
+ * use 2**35 - 16 bits == U32_MAX - 1 bytes so that the max + 1 always fits in a
+ * size_t, allowing drbg_healthcheck_sanity() to verify its enforcement.
+ */
 static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 {
-	/* SP800-90A requires 2**35 bytes additional info str / pers str */
-#if (__BITS_PER_LONG == 32)
-	/*
-	 * SP800-90A allows smaller maximum numbers to be returned -- we
-	 * return SIZE_MAX - 1 to allow the verification of the enforcement
-	 * of this value in drbg_healthcheck_sanity.
-	 */
-	return (SIZE_MAX - 1);
-#else
-	return (1UL<<35);
-#endif
+	return U32_MAX - 1;
 }
 
 static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
-- 
2.53.0

