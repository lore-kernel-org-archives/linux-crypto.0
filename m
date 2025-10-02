Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC229A31C;
	Thu,  2 Oct 2025 02:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372447; cv=none; b=Ofs5JMQCulSokN7zwp4LzdeCwgsY6kmyNmU/IXNavIYBRMukDsSiS4jdiovqXt85XNU1wq4S2WKBpj8gjWJdnTsA5wqkWGnU22uVO1cgY1PfI0+uM5F2e4c/KwGV2xSrCrG1YuyEk+BqRdX7wm12YB4gzwdf9pLpLcklKb7bTyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372447; c=relaxed/simple;
	bh=+d3VJKli1Zg9RVaDLx6/DDOQvw9ia2VIYtFw3Nj/zNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNWidJVp943NptjatFrISGTccO+yJMLauMNlpe8W3J8koEeHWjfxV0G8ehj0S5hpO/3LNaKXlgexEYPslN9UtYcmpQINVFmkvTmo1CnniQQ0XPGigDtiaY0Qeoq/le7Kkva2TWfLLBuObWrF82ioIJPNVorwjAtq/cSxE4oMI28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GADYoweq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GADYoweq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BD7C4CEFC;
	Thu,  2 Oct 2025 02:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372447;
	bh=+d3VJKli1Zg9RVaDLx6/DDOQvw9ia2VIYtFw3Nj/zNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GADYoweqWSzjYmKNowR+k+OF3wHRV2jvKCzw9YIOUNUeGFKBaUPpXdRrgrkcSUYO7
	 ku89I+IyY91QcvUJrybLbHbESCUvtIi7x6C8N+7umP8N38v0Uy1nUV7hirLKmE85rq
	 z1XokO5y9jhce9PXpJdGXdwRSQ84OatU8UgaE8tkO2/Ch2QZOPI5cSU4QLut39U8uo
	 PQ0uzsIm1LR9yCZhniFWDTNxaJMfhlUphN4xuHmMWe4zXVhVyuCnecB+8FwrBn6mmJ
	 nLE6zcnL524oCpnmwFwSl1q6HfKJXXx0SsUI2Ox8S/Wa60sKDoG0jRI4P4iXkDTJx/
	 am6ywL7K9AAeA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/8] crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
Date: Wed,  1 Oct 2025 19:31:16 -0700
Message-ID: <20251002023117.37504-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002023117.37504-1-ebiggers@kernel.org>
References: <20251002023117.37504-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Squaring in GF(2^128) requires fewer instructions than a generic
multiplication in GF(2^128).  Take advantage of this when computing H^2
from H^1 in aes_gcm_precompute_vaes_avx512().

Note that aes_gcm_precompute_vaes_avx2() already uses this optimization.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-vaes-avx512.S | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx512.S b/arch/x86/crypto/aes-gcm-vaes-avx512.S
index 3cf0945a25170..5c8301d275c66 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx512.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx512.S
@@ -258,10 +258,23 @@
 	vpclmulqdq	$0x01, \mi, \gfpoly, \t0
 	vpshufd		$0x4e, \mi, \mi
 	vpternlogd	$0x96, \t0, \mi, \hi
 .endm
 
+// This is a specialized version of _ghash_mul that computes \a * \a, i.e. it
+// squares \a.  It skips computing MI = (a_L * a_H) + (a_H * a_L) = 0.
+.macro	_ghash_square	a, dst, gfpoly, t0, t1
+	vpclmulqdq	$0x00, \a, \a, \t0	  // LO = a_L * a_L
+	vpclmulqdq	$0x11, \a, \a, \dst	  // HI = a_H * a_H
+	vpclmulqdq	$0x01, \t0, \gfpoly, \t1  // LO_L*(x^63 + x^62 + x^57)
+	vpshufd		$0x4e, \t0, \t0		  // Swap halves of LO
+	vpxord		\t0, \t1, \t1		  // Fold LO into MI
+	vpclmulqdq	$0x01, \t1, \gfpoly, \t0  // MI_L*(x^63 + x^62 + x^57)
+	vpshufd		$0x4e, \t1, \t1		  // Swap halves of MI
+	vpternlogd	$0x96, \t0, \t1, \dst	  // Fold MI into HI
+.endm
+
 // void aes_gcm_precompute_vaes_avx512(struct aes_gcm_key_vaes_avx512 *key);
 //
 // Given the expanded AES key |key->base.aes_key|, derive the GHASH subkey and
 // initialize |key->h_powers| and |key->padding|.
 SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
@@ -335,12 +348,11 @@ SYM_FUNC_START(aes_gcm_precompute_vaes_avx512)
 	// Note that as with H^1, all higher key powers also need an extra
 	// factor of x^-1 (or x using the natural interpretation).  Nothing
 	// special needs to be done to make this happen, though: H^1 * H^1 would
 	// end up with two factors of x^-1, but the multiplication consumes one.
 	// So the product H^2 ends up with the desired one factor of x^-1.
-	_ghash_mul	H_CUR_XMM, H_CUR_XMM, H_INC_XMM, GFPOLY_XMM, \
-			%xmm0, %xmm1, %xmm2
+	_ghash_square	H_CUR_XMM, H_INC_XMM, GFPOLY_XMM, %xmm0, %xmm1
 
 	// Create H_CUR_YMM = [H^2, H^1] and H_INC_YMM = [H^2, H^2].
 	vinserti128	$1, H_CUR_XMM, H_INC_YMM, H_CUR_YMM
 	vinserti128	$1, H_INC_XMM, H_INC_YMM, H_INC_YMM
 
-- 
2.51.0

