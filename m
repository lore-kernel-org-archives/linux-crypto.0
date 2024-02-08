Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2B19470
	for <linux-crypto@vger.kernel.org>; Thu,  8 Feb 2024 06:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707372655; cv=none; b=iuuQEe/EkJYM39fzwsBj1IHXJWCyphxkpBPybMjjS4488bTnS7E8EXucMOisFXWAxNu3zSEo3DhIxb/AEDzIq1h7MLLzTg3DQoPkJAPjIk6z2HoBulbPjWjOxyZGN6goIVslfQXSSTiNLHTV6Dll/vdMrH+ihGav7SfneGnKwRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707372655; c=relaxed/simple;
	bh=q5NnvPNENXx6lXEqe6lzo8azetgd5THlB6UTUGS4XJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S7ioVK8urhNqJsLTanHLXGRliR+yVDBer2QtiDlSZWoMsRJxjZyqnG779ItrE8r9DbDHdCtwQT9GRlo0P1XhxcTcHnJPyClmvib7xc2ltX1LulvXAYy7VE3ClK0d1dxu3cecJXsYNBblLk/LCjhIVmLUikuVZ1UjcHEzvYNFS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQd6SPFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQd6SPFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA37C433F1;
	Thu,  8 Feb 2024 06:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707372654;
	bh=q5NnvPNENXx6lXEqe6lzo8azetgd5THlB6UTUGS4XJc=;
	h=From:To:Cc:Subject:Date:From;
	b=OQd6SPFXMRyWPgDAZQwxJQOpwAdnF/pAk6Gr7yfLUfqr8HLHNHIAgzh5uK1MFfWar
	 KDd7yQoMso59HaRBAzMBWhxFfEum4Tuqrlt9y/sAGjrWeltwoRpH9Cb9AQZq63z/tF
	 zErIg8rBEDWXnJQNWjt7pIxJSTwCs0n6Wd4jSgmRdgf5JtqfbkwgVIEM3R2I/D6C4k
	 KQYh62E2IC39TzPWROTarfg2PzbVguafe1QNXbQGldWsbwyxFIQj1KK33lILRStR2d
	 enzgVDBCs5LOlRtkrRWdiI0k7YOtHeE05zPNKO1Wi6IZX7N9dlnMzoT1Mvj+GnPh1m
	 pSFv+HuMccxqg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>
Cc: linux-crypto@vger.kernel.org,
	Jerry Shih <jerry.shih@sifive.com>,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko@sntech.de>,
	Phoebe Chen <phoebe.chen@sifive.com>,
	Andy Chiu <andy.chiu@sifive.com>
Subject: [PATCH riscv/for-next] crypto: riscv - parallelize AES-CBC decryption
Date: Wed,  7 Feb 2024 22:08:51 -0800
Message-ID: <20240208060851.154129-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since CBC decryption is parallelizable, make the RISC-V implementation
of AES-CBC decryption process multiple blocks at a time, instead of
processing the blocks one by one.  This should improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/crypto/aes-riscv64-zvkned.S | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S b/arch/riscv/crypto/aes-riscv64-zvkned.S
index 78d4e1186c074..43541aad6386c 100644
--- a/arch/riscv/crypto/aes-riscv64-zvkned.S
+++ b/arch/riscv/crypto/aes-riscv64-zvkned.S
@@ -132,33 +132,39 @@ SYM_FUNC_END(aes_ecb_decrypt_zvkned)
 	addi		INP, INP, 16
 	addi		OUTP, OUTP, 16
 	addi		LEN, LEN, -16
 	bnez		LEN, 1b
 
 	vse32.v		v16, (IVP)	// Store next IV
 	ret
 .endm
 
 .macro	aes_cbc_decrypt	keylen
+	srli		LEN, LEN, 2	// Convert LEN from bytes to words
 	vle32.v		v16, (IVP)	// Load IV
 1:
-	vle32.v		v17, (INP)	// Load ciphertext block
-	vmv.v.v		v18, v17	// Save ciphertext block
-	aes_decrypt	v17, \keylen	// Decrypt
-	vxor.vv		v17, v17, v16	// XOR with IV or prev ciphertext block
-	vse32.v		v17, (OUTP)	// Store plaintext block
-	vmv.v.v		v16, v18	// Next "IV" is prev ciphertext block
-	addi		INP, INP, 16
-	addi		OUTP, OUTP, 16
-	addi		LEN, LEN, -16
+	vsetvli		t0, LEN, e32, m4, ta, ma
+	vle32.v		v20, (INP)	// Load ciphertext blocks
+	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
+	addi		t1, t0, -4
+	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
+	aes_decrypt	v20, \keylen	// Decrypt the blocks
+	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
+	vse32.v		v20, (OUTP)	// Store plaintext blocks
+	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
+	slli		t1, t0, 2	// Words to bytes
+	add		INP, INP, t1
+	add		OUTP, OUTP, t1
+	sub		LEN, LEN, t0
 	bnez		LEN, 1b
 
+	vsetivli	zero, 4, e32, m1, ta, ma
 	vse32.v		v16, (IVP)	// Store next IV
 	ret
 .endm
 
 // void aes_cbc_encrypt_zvkned(const struct crypto_aes_ctx *key,
 //			       const u8 *in, u8 *out, size_t len, u8 iv[16]);
 //
 // |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
 SYM_FUNC_START(aes_cbc_encrypt_zvkned)
 	aes_begin	KEYP, 128f, 192f

base-commit: cb4ede926134a65bc3bf90ed58dace8451d7e759
-- 
2.43.0

