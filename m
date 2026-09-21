Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A7F36308F;
	Mon, 21 Sep 2026 05:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967772; cv=none; b=MB9pytQYv07TTyDlOCkBaB2mWu5HN7pXRFAybDywux8/nyJzTIr2YFO8XzAzT+A9eypsAyHLE26tceTJGwG+E2XHKHsCTRn1rlMTO/EfAK/h2OQMD+0/3mYNBrLU+/asyz3J16eXZFEOlnT9De0HDTeoEOcFrdKafiWe4sENQA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967772; c=relaxed/simple;
	bh=bPmW6wqCL/cuG9YCAT2htcCSbOqD3uiz4WQ7EBZgVXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPolry2oynwlbWEPTeLvzdSG/19K1T8+seEuetUxOypaAHViRmxrHH9RyAfbF/4N3UwjRWivnjz9shlqSXQiJECXH7NsuFJPoKMorjdbLlJtxaylZZ8cgpCBsxOJ+x7kSVs/kxKzJdo/y77voVPGiZCuZcXCb07A657K0ou/9W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMNlvo4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMNlvo4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E141F008A0;
	Mon, 21 Sep 2026 05:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967769;
	bh=A0Q4ywSNwm+bmXk82fgsubJuFKPHWy+87PLk05b7EkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMNlvo4HsVDSxO6tsOLlvbCX8oCQA4G1VYajpXq6dhScvBcMOJRl/d6MD1GgBMYez
	 Id+wqhS0GV2CUCYazuUWGpf4fsMT692B2b1VWKXHplwMwg0Ok8RzzmkAh4BKxxUGDH
	 to3vdTBZxClo/BbIsP/ab/4ZMsdGYPI080kFmgqiK6Geb7NepVtbq1I40sHahLEdwd
	 8lrjHLLYitnCqXgOLJ1AcGN//Jx2sglV8ekGrERbTCoX8KEsE4UuNjg3dN7glIBNuN
	 lJkOVEaJwqjiPYD4/5QKN83dzEoEQkJNiflyfc4KZCVhDTCwzQOXMWQDteg6oq38JF
	 UsmaxlrWWJ9jA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/20] lib/crypto: riscv/aes: Pass key struct to assembly code
Date: Sun, 20 Sep 2026 22:09:02 -0700
Message-ID: <20260921050910.296144-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the assembly code take the AES key struct directly, rather than the
round keys pointer and key length separately.  Make the aes_begin macro
assume this convention, and remove support for the legacy
'struct crypto_aes_ctx' from it since that isn't used here.

This aligns with the convention that is being used (and will continue to
be used) for the AES modes, it makes the C glue code slightly simpler,
and it avoids the unnecessary shuffling around of arguments.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/riscv/aes-macros.S         | 25 ++++++++++---------------
 lib/crypto/riscv/aes-riscv64-zvkned.S | 13 ++++++-------
 lib/crypto/riscv/aes.h                | 12 ++++++++----
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/lib/crypto/riscv/aes-macros.S b/lib/crypto/riscv/aes-macros.S
index 1384164621a5..720ad69a41ac 100644
--- a/lib/crypto/riscv/aes-macros.S
+++ b/lib/crypto/riscv/aes-macros.S
@@ -44,17 +44,20 @@
 // - RISC-V Vector ('V') with VLEN >= 128
 // - RISC-V Vector AES block cipher extension ('Zvkned')
 
-// Loads the AES round keys from \keyp into vector registers and jumps to code
-// specific to the length of the key.  Specifically:
+// Offsets in struct aes_enckey
+#define OFFSETOF_KEYLEN		0
+#define OFFSETOF_RNDKEYS	16
+
+// Loads the AES round keys from the struct aes_enckey \keyp into vector
+// registers and jumps to code specific to the length of the key.  Specifically:
 //   - If AES-128, loads round keys into v1-v11 and jumps to \label128.
 //   - If AES-192, loads round keys into v1-v13 and jumps to \label192.
 //   - If AES-256, loads round keys into v1-v15 and continues onwards.
 //
-// Also sets vl=4 and vtype=e32,m1,ta,ma.  Clobbers t0 and t1.
-.macro	aes_begin	keyp, label128, label192, key_len
-.ifb \key_len
-	lwu		t0, 480(\keyp)	// t0 = key length in bytes
-.endif
+// Also sets vl=4 and vtype=e32,m1,ta,ma.  Clobbers keyp, t0, and t1.
+.macro	aes_begin	keyp, label128, label192
+	lwu		t0, OFFSETOF_KEYLEN(\keyp) // t0 = key length in bytes
+	addi		\keyp, \keyp, OFFSETOF_RNDKEYS
 	li		t1, 24		// t1 = key length for AES-192
 	vsetivli	zero, 4, e32, m1, ta, ma
 	vle32.v		v1, (\keyp)
@@ -78,20 +81,12 @@
 	vle32.v		v10, (\keyp)
 	addi		\keyp, \keyp, 16
 	vle32.v		v11, (\keyp)
-.ifb \key_len
 	blt		t0, t1, \label128	// If AES-128, goto label128.
-.else
-	blt		\key_len, t1, \label128	// If AES-128, goto label128.
-.endif
 	addi		\keyp, \keyp, 16
 	vle32.v		v12, (\keyp)
 	addi		\keyp, \keyp, 16
 	vle32.v		v13, (\keyp)
-.ifb \key_len
 	beq		t0, t1, \label192	// If AES-192, goto label192.
-.else
-	beq		\key_len, t1, \label192	// If AES-192, goto label192.
-.endif
 	// Else, it's AES-256.
 	addi		\keyp, \keyp, 16
 	vle32.v		v14, (\keyp)
diff --git a/lib/crypto/riscv/aes-riscv64-zvkned.S b/lib/crypto/riscv/aes-riscv64-zvkned.S
index 7a52ea6c669d..374fc4dba11b 100644
--- a/lib/crypto/riscv/aes-riscv64-zvkned.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned.S
@@ -50,10 +50,9 @@
 
 #include "aes-macros.S"
 
-#define RNDKEYS		a0
-#define KEY_LEN		a1
-#define OUTP		a2
-#define INP		a3
+#define KEYP		a0
+#define OUTP		a1
+#define INP		a2
 
 .macro	__aes_crypt_zvkned	enc, keybits
 	vle32.v		v16, (INP)
@@ -63,7 +62,7 @@
 .endm
 
 .macro	aes_crypt_zvkned	enc
-	aes_begin	RNDKEYS, 128f, 192f, KEY_LEN
+	aes_begin	KEYP, 128f, 192f
 	__aes_crypt_zvkned	\enc, 256
 128:
 	__aes_crypt_zvkned	\enc, 128
@@ -71,13 +70,13 @@
 	__aes_crypt_zvkned	\enc, 192
 .endm
 
-// void aes_encrypt_zvkned(const u32 rndkeys[], int key_len,
+// void aes_encrypt_zvkned(const struct aes_enckey *key,
 //			   u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
 SYM_FUNC_START(aes_encrypt_zvkned)
 	aes_crypt_zvkned	1
 SYM_FUNC_END(aes_encrypt_zvkned)
 
-// void aes_decrypt_zvkned(const u32 rndkeys[], int key_len,
+// void aes_decrypt_zvkned(const struct aes_key *key,
 //			   u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
 SYM_FUNC_START(aes_decrypt_zvkned)
 	aes_crypt_zvkned	0
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index 0b26f58faf2b..a288b4c5b493 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -10,9 +10,13 @@
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned);
 
-void aes_encrypt_zvkned(const u32 rndkeys[], int key_len,
+/* The assembly code assumes the following offsets. */
+static_assert(offsetof(struct aes_enckey, len) == 0);
+static_assert(offsetof(struct aes_enckey, k.rndkeys) == 16);
+
+void aes_encrypt_zvkned(const struct aes_enckey *key,
 			u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
-void aes_decrypt_zvkned(const u32 rndkeys[], int key_len,
+void aes_decrypt_zvkned(const struct aes_key *key,
 			u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
 
 static void aes_preparekey_arch(union aes_enckey_arch *k,
@@ -29,7 +33,7 @@ static void aes_encrypt_arch(const struct aes_enckey *key,
 {
 	if (static_branch_likely(&have_zvkned) && likely(may_use_simd())) {
 		kernel_vector_begin();
-		aes_encrypt_zvkned(key->k.rndkeys, key->len, out, in);
+		aes_encrypt_zvkned(key, out, in);
 		kernel_vector_end();
 	} else {
 		aes_encrypt_generic(key->k.rndkeys, key->nrounds, out, in);
@@ -46,7 +50,7 @@ static void aes_decrypt_arch(const struct aes_key *key,
 	 */
 	if (static_branch_likely(&have_zvkned) && likely(may_use_simd())) {
 		kernel_vector_begin();
-		aes_decrypt_zvkned(key->k.rndkeys, key->len, out, in);
+		aes_decrypt_zvkned(key, out, in);
 		kernel_vector_end();
 	} else {
 		aes_decrypt_generic(key->inv_k.inv_rndkeys, key->nrounds,
-- 
2.55.0

