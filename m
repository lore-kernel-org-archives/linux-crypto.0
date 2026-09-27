Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F244839D;
	Sun, 27 Sep 2026 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549087; cv=none; b=BBfVEs02ecv50GUpVyvz9/SmT+wTuT6SvVycLqTPDRn7kxZkiE011XqnwicolsK0zQQYdVQfIRzx5XZ5HbHla7IurGNow8FjWYGJiogbAj/qfDnpNOcfNvPf6KaPHgHwe9dqZ3NbP50RxebSMJWa2AbWfDZwe7+ivUjfGF3BMRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549087; c=relaxed/simple;
	bh=7ZVt9UN6weTFHmWJYN29bL2yE7dPhCIz318ynng7jOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSucSH9PB7CUsIKkWma7c4y1y/CjvfX65gTyN7j8UaACLOgK7C+wWiZ5/zfjDqzcPad9IqmcqBmzj0yOESSEaPc1oFt8PcilnABAb5RINhw3PsWzFdKEUGg5PjOrVlNuZbTXBh0cSU5ioL45djgr4I+xZ5iAm/UmcLttzswWvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWZQHiiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWZQHiiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F9B1F00898;
	Sun, 27 Sep 2026 22:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549084;
	bh=4OcM0b8lBQ/4SN1CE0jP1i18febJdAbQx78bAYR1X2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWZQHiiMaceUXjKmD9D+AZyzzQtixJysPz+3qPy6m0j4i8Pu2v8y5W3vgN9FkdNKq
	 UKd2cTI+aKgrKnwcFXWiB1d8zXDi9Xb7mx0uVXZrYWWNf6pBtVxXvFIcsTsC+gyxNT
	 A3O07/9/0EzRySZLP1z5EUO4glRsEFdAyUC11lgnShqWo5cP0E3kXKe9RxLKVC1TCK
	 Ei00fVG1mI2zQoES8RQWjtC+O5B93j/+9sShI2Q2Oe6YJJcbW9Ucm0QEIaUJvBR+7c
	 w+GSr28H59LmKxnBMMtmeWKZ5ZahPqXw9GlgLsa/vTbbBdiFoS0FdxJN88Y56Da+Nf
	 KCOCHNDzSA78g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 16/20] lib/crypto: riscv/aes: Pass key struct to assembly code
Date: Sun, 27 Sep 2026 15:43:07 -0700
Message-ID: <20260927224418.109759-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
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
 lib/crypto/riscv/aes-riscv64-zvkned.S | 17 ++++++++---------
 lib/crypto/riscv/aes.h                | 18 ++++++++++++------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/lib/crypto/riscv/aes-macros.S b/lib/crypto/riscv/aes-macros.S
index 1384164621a5..1ab18e358474 100644
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
+// Also sets vl=4 and vtype=e32,m1,ta,ma.  Clobbers \keyp, t0, and t1.
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
index 7a52ea6c669d..fb35f694b5ac 100644
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
@@ -71,14 +70,14 @@
 	__aes_crypt_zvkned	\enc, 192
 .endm
 
-// void aes_encrypt_zvkned(const u32 rndkeys[], int key_len,
-//			   u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+// void aes_encrypt_zvkned(const struct aes_enckey *key, u8 out[AES_BLOCK_SIZE],
+//			   const u8 in[AES_BLOCK_SIZE]);
 SYM_FUNC_START(aes_encrypt_zvkned)
 	aes_crypt_zvkned	1
 SYM_FUNC_END(aes_encrypt_zvkned)
 
-// void aes_decrypt_zvkned(const u32 rndkeys[], int key_len,
-//			   u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+// void aes_decrypt_zvkned(const struct aes_key *key, u8 out[AES_BLOCK_SIZE],
+//			   const u8 in[AES_BLOCK_SIZE]);
 SYM_FUNC_START(aes_decrypt_zvkned)
 	aes_crypt_zvkned	0
 SYM_FUNC_END(aes_decrypt_zvkned)
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index 0b26f58faf2b..9de9dbd1e887 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -10,10 +10,16 @@
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned);
 
-void aes_encrypt_zvkned(const u32 rndkeys[], int key_len,
-			u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
-void aes_decrypt_zvkned(const u32 rndkeys[], int key_len,
-			u8 out[AES_BLOCK_SIZE], const u8 in[AES_BLOCK_SIZE]);
+/* The assembly code assumes the following offsets. */
+static_assert(offsetof(struct aes_enckey, len) == 0);
+static_assert(offsetof(struct aes_enckey, k.rndkeys) == 16);
+static_assert(offsetof(struct aes_key, len) == 0);
+static_assert(offsetof(struct aes_key, k.rndkeys) == 16);
+
+void aes_encrypt_zvkned(const struct aes_enckey *key, u8 out[AES_BLOCK_SIZE],
+			const u8 in[AES_BLOCK_SIZE]);
+void aes_decrypt_zvkned(const struct aes_key *key, u8 out[AES_BLOCK_SIZE],
+			const u8 in[AES_BLOCK_SIZE]);
 
 static void aes_preparekey_arch(union aes_enckey_arch *k,
 				union aes_invkey_arch *inv_k,
@@ -29,7 +35,7 @@ static void aes_encrypt_arch(const struct aes_enckey *key,
 {
 	if (static_branch_likely(&have_zvkned) && likely(may_use_simd())) {
 		kernel_vector_begin();
-		aes_encrypt_zvkned(key->k.rndkeys, key->len, out, in);
+		aes_encrypt_zvkned(key, out, in);
 		kernel_vector_end();
 	} else {
 		aes_encrypt_generic(key->k.rndkeys, key->nrounds, out, in);
@@ -46,7 +52,7 @@ static void aes_decrypt_arch(const struct aes_key *key,
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

