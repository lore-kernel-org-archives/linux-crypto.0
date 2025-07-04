Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73411E47CC;
	Fri,  4 Jul 2025 02:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751596927; cv=none; b=Fg7IhPal6/mLkzbjLf9DtAtRDq8k5ecJTj7KGfpzXXhCpytrj/xCvIZyTlRYqN3AkcjWMiJBIYRxkCq9Pn2M93EueE69BYH008ndxLUpSgGCeX01DYwx6q4Sj+qnoWLdt4qcVGg9sbdFYrILCJRcejzfj8b9WEIj4pUAhiQumc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751596927; c=relaxed/simple;
	bh=cJEKeMrrEFzU02uZcEkZZnobeGg0XAEqgJDDvcatu80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSENTGrq/brw5PXO0HFXnYgS4z2JMwHLR6HH2ooFlg8kePk+P4mRl+gyUagSkC2akE/MCoPbFYOqPT+yN8zbEcKtYK8KTUV5qOTH1yyyQguCGMdUVm0Ny3QOeYFsrqUog5W8SIL0QHFQe7grN0bJpBEJYaz0MNCH937AhQ878lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgYL/dPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgYL/dPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C81C4CEEE;
	Fri,  4 Jul 2025 02:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751596927;
	bh=cJEKeMrrEFzU02uZcEkZZnobeGg0XAEqgJDDvcatu80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgYL/dPxx3tVST0ATkylNrYDgusq5kAsc1dJaMR/SHzed1jkA5IbKkjm2442fzjHu
	 ZfwubcuqqRl7I+toiC4LYuPm3sceLMWz73Hh8C/+xkMssRfS9mrC7HGD2XQNJcZaHW
	 hcA0ifxSALVhYQbh470HfuVklE5bUMK2/eojNh7a1gxA4ziuXnLkXE91Z9xosIQ+ce
	 dj5ct2NqPspv7wICaktv9t4rsvQqSRPWNzepTe7ZMjjd5QF0DKawyCkuuBCWFJOxF8
	 Jl69RLJ8n8ApU9YBM3G6mfm9NTIbmH6qqgMqsUj4VKJp8bpqsdEda4U6HYBAbATECO
	 K4jrPqYAstABA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] lib/crypto: x86/sha256: Move static_call above kernel-mode FPU section
Date: Thu,  3 Jul 2025 19:39:57 -0700
Message-ID: <20250704023958.73274-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250704023958.73274-1-ebiggers@kernel.org>
References: <20250704023958.73274-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As I did for sha512_blocks(), reorganize x86's sha256_blocks() to be
just a static_call.  To achieve that, for each assembly function add a C
function that handles the kernel-mode FPU section and fallback.  While
this increases total code size slightly, the amount of code actually
executed on a given system does not increase, and it is slightly more
efficient since it eliminates the extra static_key.  It also makes the
assembly functions be called with standard direct calls instead of
static calls, eliminating the need for ANNOTATE_NOENDBR.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sha256-avx-asm.S   |  3 --
 lib/crypto/x86/sha256-avx2-asm.S  |  3 --
 lib/crypto/x86/sha256-ni-asm.S    |  2 --
 lib/crypto/x86/sha256-ssse3-asm.S |  2 --
 lib/crypto/x86/sha256.h           | 48 ++++++++++++++++---------------
 5 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/lib/crypto/x86/sha256-avx-asm.S b/lib/crypto/x86/sha256-avx-asm.S
index 73bcff2b548f4..798a7f07fa013 100644
--- a/lib/crypto/x86/sha256-avx-asm.S
+++ b/lib/crypto/x86/sha256-avx-asm.S
@@ -46,11 +46,10 @@
 ########################################################################
 # This code schedules 1 block at a time, with 4 lanes per block
 ########################################################################
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 ## assume buffers not aligned
 #define    VMOVDQ vmovdqu
 
 ################################ Define Macros
@@ -344,12 +343,10 @@ a = TMP_
 ## void sha256_transform_avx(struct sha256_block_state *state,
 ##			     const u8 *data, size_t nblocks);
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_avx)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
-
 	pushq   %rbx
 	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
diff --git a/lib/crypto/x86/sha256-avx2-asm.S b/lib/crypto/x86/sha256-avx2-asm.S
index 45787570387f2..62a46993359e6 100644
--- a/lib/crypto/x86/sha256-avx2-asm.S
+++ b/lib/crypto/x86/sha256-avx2-asm.S
@@ -47,11 +47,10 @@
 ########################################################################
 # This code schedules 2 blocks at a time, with 4 lanes per block
 ########################################################################
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 ## assume buffers not aligned
 #define	VMOVDQ vmovdqu
 
 ################################ Define Macros
@@ -521,12 +520,10 @@ STACK_SIZE	= _CTX      + _CTX_SIZE
 ## void sha256_transform_rorx(struct sha256_block_state *state,
 ##			      const u8 *data, size_t nblocks);
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_rorx)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
-
 	pushq	%rbx
 	pushq	%r12
 	pushq	%r13
 	pushq	%r14
 	pushq	%r15
diff --git a/lib/crypto/x86/sha256-ni-asm.S b/lib/crypto/x86/sha256-ni-asm.S
index 4af7d22e29e47..9ebbacbb9c13b 100644
--- a/lib/crypto/x86/sha256-ni-asm.S
+++ b/lib/crypto/x86/sha256-ni-asm.S
@@ -52,11 +52,10 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 #define STATE_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
 #define NUM_BLKS	%rdx	/* 3rd arg */
 
@@ -109,11 +108,10 @@
  * void sha256_ni_transform(struct sha256_block_state *state,
  *			    const u8 *data, size_t nblocks);
  */
 .text
 SYM_FUNC_START(sha256_ni_transform)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
 
 	shl		$6, NUM_BLKS		/*  convert to bytes */
 	jz		.Ldone_hash
 	add		DATA_PTR, NUM_BLKS	/* pointer to end of data */
 
diff --git a/lib/crypto/x86/sha256-ssse3-asm.S b/lib/crypto/x86/sha256-ssse3-asm.S
index 407b30adcd37f..3b602b7d43fad 100644
--- a/lib/crypto/x86/sha256-ssse3-asm.S
+++ b/lib/crypto/x86/sha256-ssse3-asm.S
@@ -351,12 +351,10 @@ a = TMP_
 ## void sha256_transform_ssse3(struct sha256_block_state *state,
 ##			       const u8 *data, size_t nblocks);
 ########################################################################
 .text
 SYM_FUNC_START(sha256_transform_ssse3)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
-
 	pushq   %rbx
 	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 3b5456c222ba6..669bc06538b67 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -6,50 +6,52 @@
  */
 #include <asm/fpu/api.h>
 #include <crypto/internal/simd.h>
 #include <linux/static_call.h>
 
-asmlinkage void sha256_transform_ssse3(struct sha256_block_state *state,
-				       const u8 *data, size_t nblocks);
-asmlinkage void sha256_transform_avx(struct sha256_block_state *state,
-				     const u8 *data, size_t nblocks);
-asmlinkage void sha256_transform_rorx(struct sha256_block_state *state,
-				      const u8 *data, size_t nblocks);
-asmlinkage void sha256_ni_transform(struct sha256_block_state *state,
-				    const u8 *data, size_t nblocks);
+DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_blocks_generic);
 
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha256_x86);
+#define DEFINE_X86_SHA256_FN(c_fn, asm_fn)                                 \
+	asmlinkage void asm_fn(struct sha256_block_state *state,           \
+			       const u8 *data, size_t nblocks);            \
+	static void c_fn(struct sha256_block_state *state, const u8 *data, \
+			 size_t nblocks)                                   \
+	{                                                                  \
+		if (likely(crypto_simd_usable())) {                        \
+			kernel_fpu_begin();                                \
+			asm_fn(state, data, nblocks);                      \
+			kernel_fpu_end();                                  \
+		} else {                                                   \
+			sha256_blocks_generic(state, data, nblocks);       \
+		}                                                          \
+	}
 
-DEFINE_STATIC_CALL(sha256_blocks_x86, sha256_transform_ssse3);
+DEFINE_X86_SHA256_FN(sha256_blocks_ssse3, sha256_transform_ssse3);
+DEFINE_X86_SHA256_FN(sha256_blocks_avx, sha256_transform_avx);
+DEFINE_X86_SHA256_FN(sha256_blocks_avx2, sha256_transform_rorx);
+DEFINE_X86_SHA256_FN(sha256_blocks_ni, sha256_ni_transform);
 
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
-	if (static_branch_likely(&have_sha256_x86) && crypto_simd_usable()) {
-		kernel_fpu_begin();
-		static_call(sha256_blocks_x86)(state, data, nblocks);
-		kernel_fpu_end();
-	} else {
-		sha256_blocks_generic(state, data, nblocks);
-	}
+	static_call(sha256_blocks_x86)(state, data, nblocks);
 }
 
 #define sha256_mod_init_arch sha256_mod_init_arch
 static inline void sha256_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
-		static_call_update(sha256_blocks_x86, sha256_ni_transform);
+		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
 		   boot_cpu_has(X86_FEATURE_AVX)) {
 		if (boot_cpu_has(X86_FEATURE_AVX2) &&
 		    boot_cpu_has(X86_FEATURE_BMI2))
 			static_call_update(sha256_blocks_x86,
-					   sha256_transform_rorx);
+					   sha256_blocks_avx2);
 		else
 			static_call_update(sha256_blocks_x86,
-					   sha256_transform_avx);
-	} else if (!boot_cpu_has(X86_FEATURE_SSSE3)) {
-		return;
+					   sha256_blocks_avx);
+	} else if (boot_cpu_has(X86_FEATURE_SSSE3)) {
+		static_call_update(sha256_blocks_x86, sha256_blocks_ssse3);
 	}
-	static_branch_enable(&have_sha256_x86);
 }
-- 
2.50.0

