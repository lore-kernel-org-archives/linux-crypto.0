Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38466287513;
	Thu,  2 Oct 2025 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372446; cv=none; b=Re73l57mADkxIXH5pHFSSgcFory5gcwIMHOfZevjR+8W3vTRTiJaSYWzQB98cDQVzsJtkgK+Laouxkezi43T76tzsTOy3MQWLaYGBRru2ZULhrwdw0qJ2au4GwjC/B7vhgt57qzHPu7DSOCu4E6TYWH0PpiFd2RF/xvp7j/ceRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372446; c=relaxed/simple;
	bh=gq4Cg4fbYXoIbz0yeNF+R6aP+cZlFHUjA+ld03dCxOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/37GvnBfLLIBNiz7deMqDPeCN7LVN7nLLBAXF7wqls+Jic2yz5QHCtoAdrqZMVokHNFNnFExsDpFnOq3GUWPFmKnhFcRDzqKsCVgoC0ka7rgc5L4kNUI6lbWNyvjmiecUeKidjoYAdRLwcxDJafy67aswc1BBbPRDngrVBl1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5zTcJs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5zTcJs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DEEC4CEFD;
	Thu,  2 Oct 2025 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372445;
	bh=gq4Cg4fbYXoIbz0yeNF+R6aP+cZlFHUjA+ld03dCxOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5zTcJs1RNh3iveGkVaTnQPp+OdiP70FAHKfB4VNI8f0zPkkuby4haDXz1tCd7K1x
	 6s2+CDnSNtcslr341q01PWKX4ERnifq4tSV8KttLyxe1t3bxA6M3pxVz+52Pnlm/6b
	 iipOB/PxwS/tSkV6bQxzFGXHGz/q8MbNzduR6QKtMbNurStWaO6+4Z6GWnntRydZvb
	 yOGG3nKoVgWu1buEGg8PyV9y6mnGh3IdAObPxQQoGfHknTiRkjRCxkS7F8rWnV/bsV
	 kwT8m3GM2oeCx2aWaSifcX1gqJB92cq80gPA8aOUljZvzKL3QOVFZchiCjfYMSpxVq
	 6Q1ZfgVnNpwMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/8] crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
Date: Wed,  1 Oct 2025 19:31:11 -0700
Message-ID: <20251002023117.37504-3-ebiggers@kernel.org>
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

Remove the VAES+AVX10/256 optimized implementation of AES-GCM.

It's no longer expected to be useful for future CPUs, since Intel
changed the AVX10 specification to require 512-bit vectors.

In addition, it's no longer very useful to serve as the 256-bit fallback
for older Intel CPUs (Ice Lake and Tiger Lake) that downclock too
eagerly when 512-bit vectors are used.  This is because I ended up
writing another 256-bit implementation anyway, using VAES+AVX2.  The
VAES+AVX2 implementation is almost as fast as the VAES+AVX10/256 one, as
shown by the following tables.  So, let's just use it instead.

Table 1: AES-256-GCM encryption throughput change,
         CPU vs. message length in bytes:

                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
----------------------+-------+-------+-------+-------+-------+-------+
Intel Ice Lake Server |   -2% |   -1% |    0% |   -2% |   -2% |    3% |

                      |   300 |   200 |    64 |    63 |    16 |
----------------------+-------+-------+-------+-------+-------+
Intel Ice Lake Server |    1% |    0% |    4% |    2% |   -6% |

Table 2: AES-256-GCM decryption throughput change,
         CPU vs. message length in bytes:

                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
----------------------+-------+-------+-------+-------+-------+-------+
Intel Ice Lake Server |   -1% |   -1% |    1% |   -2% |    0% |    2% |

                      |   300 |   200 |    64 |    63 |    16 |
----------------------+-------+-------+-------+-------+-------+
Intel Ice Lake Server |   -1% |    4% |    1% |    0% |   -5% |

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aes-gcm-avx10-x86_64.S | 11 ------
 arch/x86/crypto/aesni-intel_glue.c     | 54 +++-----------------------
 2 files changed, 6 insertions(+), 59 deletions(-)

diff --git a/arch/x86/crypto/aes-gcm-avx10-x86_64.S b/arch/x86/crypto/aes-gcm-avx10-x86_64.S
index 02ee11083d4f8..4fb04506d7932 100644
--- a/arch/x86/crypto/aes-gcm-avx10-x86_64.S
+++ b/arch/x86/crypto/aes-gcm-avx10-x86_64.S
@@ -1079,21 +1079,10 @@
 .endif
 	// No need for vzeroupper here, since only used xmm registers were used.
 	RET
 .endm
 
-_set_veclen 32
-SYM_FUNC_START(aes_gcm_precompute_vaes_avx10_256)
-	_aes_gcm_precompute
-SYM_FUNC_END(aes_gcm_precompute_vaes_avx10_256)
-SYM_FUNC_START(aes_gcm_enc_update_vaes_avx10_256)
-	_aes_gcm_update	1
-SYM_FUNC_END(aes_gcm_enc_update_vaes_avx10_256)
-SYM_FUNC_START(aes_gcm_dec_update_vaes_avx10_256)
-	_aes_gcm_update	0
-SYM_FUNC_END(aes_gcm_dec_update_vaes_avx10_256)
-
 _set_veclen 64
 SYM_FUNC_START(aes_gcm_precompute_vaes_avx10_512)
 	_aes_gcm_precompute
 SYM_FUNC_END(aes_gcm_precompute_vaes_avx10_512)
 SYM_FUNC_START(aes_gcm_enc_update_vaes_avx10_512)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e2847d67430fd..1ed8513208d36 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -939,17 +939,16 @@ struct aes_gcm_key_avx10 {
  */
 #define FLAG_RFC4106	BIT(0)
 #define FLAG_ENC	BIT(1)
 #define FLAG_AVX	BIT(2)
 #define FLAG_VAES_AVX2	BIT(3)
-#define FLAG_AVX10_256	BIT(4)
-#define FLAG_AVX10_512	BIT(5)
+#define FLAG_AVX10_512	BIT(4)
 
 static inline struct aes_gcm_key *
 aes_gcm_key_get(struct crypto_aead *tfm, int flags)
 {
-	if (flags & (FLAG_AVX10_256 | FLAG_AVX10_512))
+	if (flags & FLAG_AVX10_512)
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 64);
 	else if (flags & FLAG_VAES_AVX2)
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 32);
 	else
 		return PTR_ALIGN(crypto_aead_ctx(tfm), 16);
@@ -960,30 +959,16 @@ aes_gcm_precompute_aesni(struct aes_gcm_key_aesni *key);
 asmlinkage void
 aes_gcm_precompute_aesni_avx(struct aes_gcm_key_aesni *key);
 asmlinkage void
 aes_gcm_precompute_vaes_avx2(struct aes_gcm_key_vaes_avx2 *key);
 asmlinkage void
-aes_gcm_precompute_vaes_avx10_256(struct aes_gcm_key_avx10 *key);
-asmlinkage void
 aes_gcm_precompute_vaes_avx10_512(struct aes_gcm_key_avx10 *key);
 
 static void aes_gcm_precompute(struct aes_gcm_key *key, int flags)
 {
-	/*
-	 * To make things a bit easier on the assembly side, the AVX10
-	 * implementations use the same key format.  Therefore, a single
-	 * function using 256-bit vectors would suffice here.  However, it's
-	 * straightforward to provide a 512-bit one because of how the assembly
-	 * code is structured, and it works nicely because the total size of the
-	 * key powers is a multiple of 512 bits.  So we take advantage of that.
-	 *
-	 * A similar situation applies to the AES-NI implementations.
-	 */
 	if (flags & FLAG_AVX10_512)
 		aes_gcm_precompute_vaes_avx10_512(AES_GCM_KEY_AVX10(key));
-	else if (flags & FLAG_AVX10_256)
-		aes_gcm_precompute_vaes_avx10_256(AES_GCM_KEY_AVX10(key));
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_precompute_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key));
 	else if (flags & FLAG_AVX)
 		aes_gcm_precompute_aesni_avx(AES_GCM_KEY_AESNI(key));
 	else
@@ -1004,11 +989,11 @@ aes_gcm_aad_update_vaes_avx10(const struct aes_gcm_key_avx10 *key,
 			      u8 ghash_acc[16], const u8 *aad, int aadlen);
 
 static void aes_gcm_aad_update(const struct aes_gcm_key *key, u8 ghash_acc[16],
 			       const u8 *aad, int aadlen, int flags)
 {
-	if (flags & (FLAG_AVX10_256 | FLAG_AVX10_512))
+	if (flags & FLAG_AVX10_512)
 		aes_gcm_aad_update_vaes_avx10(AES_GCM_KEY_AVX10(key), ghash_acc,
 					      aad, aadlen);
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_aad_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 					     ghash_acc, aad, aadlen);
@@ -1031,14 +1016,10 @@ aes_gcm_enc_update_aesni_avx(const struct aes_gcm_key_aesni *key,
 asmlinkage void
 aes_gcm_enc_update_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			     const u32 le_ctr[4], u8 ghash_acc[16],
 			     const u8 *src, u8 *dst, int datalen);
 asmlinkage void
-aes_gcm_enc_update_vaes_avx10_256(const struct aes_gcm_key_avx10 *key,
-				  const u32 le_ctr[4], u8 ghash_acc[16],
-				  const u8 *src, u8 *dst, int datalen);
-asmlinkage void
 aes_gcm_enc_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
 				  const u32 le_ctr[4], u8 ghash_acc[16],
 				  const u8 *src, u8 *dst, int datalen);
 
 asmlinkage void
@@ -1052,14 +1033,10 @@ aes_gcm_dec_update_aesni_avx(const struct aes_gcm_key_aesni *key,
 asmlinkage void
 aes_gcm_dec_update_vaes_avx2(const struct aes_gcm_key_vaes_avx2 *key,
 			     const u32 le_ctr[4], u8 ghash_acc[16],
 			     const u8 *src, u8 *dst, int datalen);
 asmlinkage void
-aes_gcm_dec_update_vaes_avx10_256(const struct aes_gcm_key_avx10 *key,
-				  const u32 le_ctr[4], u8 ghash_acc[16],
-				  const u8 *src, u8 *dst, int datalen);
-asmlinkage void
 aes_gcm_dec_update_vaes_avx10_512(const struct aes_gcm_key_avx10 *key,
 				  const u32 le_ctr[4], u8 ghash_acc[16],
 				  const u8 *src, u8 *dst, int datalen);
 
 /* __always_inline to optimize out the branches based on @flags */
@@ -1071,14 +1048,10 @@ aes_gcm_update(const struct aes_gcm_key *key,
 	if (flags & FLAG_ENC) {
 		if (flags & FLAG_AVX10_512)
 			aes_gcm_enc_update_vaes_avx10_512(AES_GCM_KEY_AVX10(key),
 							  le_ctr, ghash_acc,
 							  src, dst, datalen);
-		else if (flags & FLAG_AVX10_256)
-			aes_gcm_enc_update_vaes_avx10_256(AES_GCM_KEY_AVX10(key),
-							  le_ctr, ghash_acc,
-							  src, dst, datalen);
 		else if (flags & FLAG_VAES_AVX2)
 			aes_gcm_enc_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 						     le_ctr, ghash_acc,
 						     src, dst, datalen);
 		else if (flags & FLAG_AVX)
@@ -1091,14 +1064,10 @@ aes_gcm_update(const struct aes_gcm_key *key,
 	} else {
 		if (flags & FLAG_AVX10_512)
 			aes_gcm_dec_update_vaes_avx10_512(AES_GCM_KEY_AVX10(key),
 							  le_ctr, ghash_acc,
 							  src, dst, datalen);
-		else if (flags & FLAG_AVX10_256)
-			aes_gcm_dec_update_vaes_avx10_256(AES_GCM_KEY_AVX10(key),
-							  le_ctr, ghash_acc,
-							  src, dst, datalen);
 		else if (flags & FLAG_VAES_AVX2)
 			aes_gcm_dec_update_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
 						     le_ctr, ghash_acc,
 						     src, dst, datalen);
 		else if (flags & FLAG_AVX)
@@ -1133,11 +1102,11 @@ aes_gcm_enc_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
 static __always_inline void
 aes_gcm_enc_final(const struct aes_gcm_key *key,
 		  const u32 le_ctr[4], u8 ghash_acc[16],
 		  u64 total_aadlen, u64 total_datalen, int flags)
 {
-	if (flags & (FLAG_AVX10_256 | FLAG_AVX10_512))
+	if (flags & FLAG_AVX10_512)
 		aes_gcm_enc_final_vaes_avx10(AES_GCM_KEY_AVX10(key),
 					     le_ctr, ghash_acc,
 					     total_aadlen, total_datalen);
 	else if (flags & FLAG_VAES_AVX2)
 		aes_gcm_enc_final_vaes_avx2(AES_GCM_KEY_VAES_AVX2(key),
@@ -1178,11 +1147,11 @@ aes_gcm_dec_final_vaes_avx10(const struct aes_gcm_key_avx10 *key,
 static __always_inline bool __must_check
 aes_gcm_dec_final(const struct aes_gcm_key *key, const u32 le_ctr[4],
 		  u8 ghash_acc[16], u64 total_aadlen, u64 total_datalen,
 		  u8 tag[16], int taglen, int flags)
 {
-	if (flags & (FLAG_AVX10_256 | FLAG_AVX10_512))
+	if (flags & FLAG_AVX10_512)
 		return aes_gcm_dec_final_vaes_avx10(AES_GCM_KEY_AVX10(key),
 						    le_ctr, ghash_acc,
 						    total_aadlen, total_datalen,
 						    tag, taglen);
 	else if (flags & FLAG_VAES_AVX2)
@@ -1310,11 +1279,11 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *raw_key,
 		/* Compute H^1 * x^-1 */
 		h = h1;
 		gf128mul_lle(&h, (const be128 *)x_to_the_minus1);
 
 		/* Compute the needed key powers */
-		if (flags & (FLAG_AVX10_256 | FLAG_AVX10_512)) {
+		if (flags & FLAG_AVX10_512) {
 			struct aes_gcm_key_avx10 *k = AES_GCM_KEY_AVX10(key);
 
 			for (i = ARRAY_SIZE(k->h_powers) - 1; i >= 0; i--) {
 				k->h_powers[i][0] = be64_to_cpu(h.b);
 				k->h_powers[i][1] = be64_to_cpu(h.a);
@@ -1608,15 +1577,10 @@ DEFINE_GCM_ALGS(aesni_avx, FLAG_AVX,
 /* aes_gcm_algs_vaes_avx2 */
 DEFINE_GCM_ALGS(vaes_avx2, FLAG_VAES_AVX2,
 		"generic-gcm-vaes-avx2", "rfc4106-gcm-vaes-avx2",
 		AES_GCM_KEY_VAES_AVX2_SIZE, 600);
 
-/* aes_gcm_algs_vaes_avx10_256 */
-DEFINE_GCM_ALGS(vaes_avx10_256, FLAG_AVX10_256,
-		"generic-gcm-vaes-avx10_256", "rfc4106-gcm-vaes-avx10_256",
-		AES_GCM_KEY_AVX10_SIZE, 700);
-
 /* aes_gcm_algs_vaes_avx10_512 */
 DEFINE_GCM_ALGS(vaes_avx10_512, FLAG_AVX10_512,
 		"generic-gcm-vaes-avx10_512", "rfc4106-gcm-vaes-avx10_512",
 		AES_GCM_KEY_AVX10_SIZE, 800);
 
@@ -1660,15 +1624,10 @@ static int __init register_avx_algs(void)
 	    !boot_cpu_has(X86_FEATURE_BMI2) ||
 	    !cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
 			       XFEATURE_MASK_AVX512, NULL))
 		return 0;
 
-	err = crypto_register_aeads(aes_gcm_algs_vaes_avx10_256,
-				    ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256));
-	if (err)
-		return err;
-
 	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
 		int i;
 
 		for (i = 0; i < ARRAY_SIZE(skcipher_algs_vaes_avx512); i++)
 			skcipher_algs_vaes_avx512[i].base.cra_priority = 1;
@@ -1700,11 +1659,10 @@ static void unregister_avx_algs(void)
 	unregister_skciphers(skcipher_algs_aesni_avx);
 	unregister_aeads(aes_gcm_algs_aesni_avx);
 	unregister_skciphers(skcipher_algs_vaes_avx2);
 	unregister_skciphers(skcipher_algs_vaes_avx512);
 	unregister_aeads(aes_gcm_algs_vaes_avx2);
-	unregister_aeads(aes_gcm_algs_vaes_avx10_256);
 	unregister_aeads(aes_gcm_algs_vaes_avx10_512);
 }
 #else /* CONFIG_X86_64 */
 static struct aead_alg aes_gcm_algs_aesni[0];
 
-- 
2.51.0

