Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794428130;
	b=XSLaFLhIXD6lgb9iBkmbdI96D9LXq+zzlpcym7Mo/gpUeNP8lHIo9MZmO2aDXffziUiK
	 u6hqJKDh5gR6J23OwMkcyzb2+sGhBgXK3wtSvAClV5M1BA/MleK1F5LsrrrwiDaSk5HvZ
	 4tkY/fm5GPxxoIM1e20N13hdtacrBfBI4NZXwZ1MnGadGtpC5HDjps7ysq4o4i0hFyMG+
	 rrjH5/w52sws8ZFz3jyla3EITYnRbrMdsx+TM8cMey4SuAbVA5WI6KaDoSvN683/PY++W
	 hL7Zt617QQS4emHyqf2JsH8KUtkK5U6KmvBUdhjBJL7z4+eN2yLFGu+gm3t/0JTfUjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794428130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6SZ5Morm1pTObyS9kphBk2li/F2B7RmkHpLEFosG0as=;
	b=QBOFsCtS4UdWwl5NVB7up88xbAMAvLBJiDCIAjcZ1tYB1z3NB1qG3o4S0xgOIjStvaeX
	 V1T4/xAA5w7ztfPWSzYJwwMWp+3qUKMqgYzLdPFno/6/keTqNKF5I0pYnW3aYHbEYdl7L
	 1cSFR67GPJ7DpULxZ1qirAZoKSKyN57rHSZj7xIl2aosccjYlFg0FQaPU8M+hhB3gqgTC
	 qDrvnb1PBUVWVVs1tmQujwQ/msOpZBInEwtJI0J7kNxDweAYX3Rtuyu6ZzRC0Sg0vqkik
	 TR7oj8W7CC4QOoDhPsui6ZUUr2cwWruuci5MiDGC7Yc09Ot5s6sYz/NNhlyiXgmKMdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="G/5IRctE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37E606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 20:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G/5IRctE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5798F1F00A05;
	Wed, 11 Nov 2026 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794428130;
	bh=6SZ5Morm1pTObyS9kphBk2li/F2B7RmkHpLEFosG0as=;
	h=From:To:Cc:Subject:Date;
	b=G/5IRctEp4uRoNVkakvHlmbHIvCofXGypdV1uk1xweEyP9geV3nnGNNBV/iWlpQd3
	 mBvygckFASs9vVOGVdo7tJNu7eBNgChtmczlRfcP/gN4H+4Kj4BS5xnCUXzxPPHds5
	 Yott0xbjd9885Vbf1Lc6YjoBBxRHn8H58PukbjgKMtC3n7eHwi46SEj/ybP9BY66ll
	 +S6ztO38eueavUS/jgdppIqKLDhiWpp2mRrQqR69LCPgr126jgSBqHB6IYpKeQNXW3
	 mEACLrl5kUPtq4ZKVT/x32ZlEQor8uwxGWBa+ULva6OjEWOpeFOBxiLjuprJgPWAGf
	 kEfRASZQNbvBw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/poly1305: Drop redundant checks for AVX and AVX2
Date: Wed, 11 Nov 2026 12:15:25 -0800
Message-ID: <20261111201525.40031-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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

Reorganize the code in poly1305_mod_init_arch() to use nesting.  This
eliminates redundant boot_cpu_has() calls.  It also makes the code
structure more closely match poly1305_blocks(), which has an early
return if poly1305_use_avx isn't set.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/poly1305.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
index 3b92e20f4f9b3..89d3b6add442a 100644
--- a/lib/crypto/x86/poly1305.h
+++ b/lib/crypto/x86/poly1305.h
@@ -143,13 +143,17 @@ static void poly1305_emit(const struct poly1305_state *ctx,
 #define poly1305_mod_init_arch poly1305_mod_init_arch
 static void poly1305_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AVX))
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		static_branch_enable(&poly1305_use_avx);
-	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2))
-		static_branch_enable(&poly1305_use_avx2);
-	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
-	    boot_cpu_has(X86_FEATURE_AVX512F) &&
-	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
-	    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
-		static_branch_enable(&poly1305_use_avx512);
+		if (boot_cpu_has(X86_FEATURE_AVX2)) {
+			static_branch_enable(&poly1305_use_avx2);
+			/*
+			 * Skylake downclocks unacceptably much when using zmm,
+			 * but later generations are fast.
+			 */
+			if (boot_cpu_has(X86_FEATURE_AVX512F) &&
+			    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
+				static_branch_enable(&poly1305_use_avx512);
+		}
+	}
 }

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

