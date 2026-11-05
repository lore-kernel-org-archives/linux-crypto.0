Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793853447;
	b=g/3LOFM9b/QwkNj1lwA4Y0CkzZ2v7TyoFgXdLGaN0z7NFuHhwtCTOg6YPR+qSrGYoBi9
	 tuTX/rZb7BEY0TTvEEXGbU/FRgH+JHcxvV1SuIKi6Yni6EpiHnmxqd/xk9E9UK7rJkvba
	 c5fqjNggJRycvxdeRwWs6wXR+3zUY6+MIv6BTLb839DCtB+iB8LwJh0XyfvOl1/fIlkjS
	 e4CdERX02rvHIAe56FzBHWecisdjCxAVyWaWk/f4bp0VU2C+1B8bAj4fiBAuu8t6tTGy/
	 Cl99dELA0R7EFy18N7Yxfz/TcomMwza5eK6myRqt3a8PM8ZqpGfRzSuWGagJeLjZuLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793853447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=voN1v/XKJBSEYxqGn9xQaTiE1Ge2pSLvYPxBbE+5D5c=;
	b=lbDAcmWIqUOECkwVq+gev/4gpqBiRqW0KxaCoGtewJCwqo47eTorQtGt6B30ecYbh7sA
	 Mh4a0u/UFchmNomHqXV506OFHu0J4YvNlS4HviCeQapKlgFOxNXIKTrEsOcjqUbVHpfy/
	 IVp6rpeK2F26ZCbjZJN7DWA7UPkcg1YYO0XZaeRjYLdNEqLTEBn8UjDW8wot+gw9277UH
	 SYYeFXL/644T7FvJhG+XXtSTEpk71o5V7LuGG1FiYiKb5gX5TwstZj4vUS94xuikRtpl3
	 AVlv18JyKDrpUYuENUOtw7dWD/EVQjo0DAGDh13Gs2FDepH6jonjpXcLdH432Z93CIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCNYAvKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D974A606A31B
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 04:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCNYAvKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D79A1F000C1;
	Thu,  5 Nov 2026 04:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853446;
	bh=voN1v/XKJBSEYxqGn9xQaTiE1Ge2pSLvYPxBbE+5D5c=;
	h=From:To:Cc:Subject:Date;
	b=bCNYAvKxa6oo49Q7aO5hrRlkJIrw+FgngqscLiJhCjPAxLY1oLYO3hw1Ne8DVmlLB
	 7CkvUQWtpFfFz2pCpFUw/dWOKPCsualIyeR3zLpawdwBXHIxko6bBZwKP3cQmSzqHY
	 5T69lP8Py9z0tqdwXN7dBAKX2Shh9z+0g/13d9USEzHUauOPSYmXU4LAJI11HKO6ec
	 8no8fcMZ8kBAl5OQA5T2/TQjXWVSOnrO+4NeCBF18dvX2krdYy/Y0fIr4kCoRLkLLL
	 AfFzwFnrVm5bSg10kPnjjThUWz9ZUcyMLSM07+65KFYn33hGIzHBCTeZGtF/7GDOhQ
	 nYp9td7j6nU5A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/nh: Remove unnecessary check for SSE2 support on x86_64
Date: Wed,  4 Nov 2026 20:37:10 -0800
Message-ID: <20261105043710.310742-1-ebiggers@kernel.org>
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
Content-Transfer-Encoding: 8bit

Remove the unnecessary check for X86_FEATURE_XMM2 (and the have_sse2
static key it controls) from the x86_64 optimized NH code.

This code is 64-bit only, and x86_64 kernels require X86_FEATURE_XMM2.
(See X86_REQUIRED_FEATURE_XMM2.)

Also replace <linux/static_call.h> with <linux/jump_label.h>, since this
file uses static keys, not static calls.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/nh.h | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/crypto/x86/nh.h b/lib/crypto/x86/nh.h
index 342636dcb750..3972c7ae28fd 100644
--- a/lib/crypto/x86/nh.h
+++ b/lib/crypto/x86/nh.h
@@ -6,9 +6,8 @@
  */
 
 #include <asm/fpu/api.h>
-#include <linux/static_call.h>
+#include <linux/jump_label.h>
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sse2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_avx2);
 
 asmlinkage void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
@@ -19,8 +18,7 @@ asmlinkage void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
 static bool nh_arch(const u32 *key, const u8 *message, size_t message_len,
 		    __le64 hash[NH_NUM_PASSES])
 {
-	if (message_len >= 64 && static_branch_likely(&have_sse2) &&
-	    irq_fpu_usable()) {
+	if (message_len >= 64 && irq_fpu_usable()) {
 		kernel_fpu_begin();
 		if (static_branch_likely(&have_avx2))
 			nh_avx2(key, message, message_len, hash);
@@ -35,9 +33,6 @@ static bool nh_arch(const u32 *key, const u8 *message, size_t message_len,
 #define nh_mod_init_arch nh_mod_init_arch
 static void nh_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_XMM2)) {
-		static_branch_enable(&have_sse2);
-		if (boot_cpu_has(X86_FEATURE_AVX2))
-			static_branch_enable(&have_avx2);
-	}
+	if (boot_cpu_has(X86_FEATURE_AVX2))
+		static_branch_enable(&have_avx2);
 }

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

