Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D1436195C;
	Mon, 21 Sep 2026 05:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967772; cv=none; b=TFdl7fv+iWyeE1fTKlgVLdJ+1+VsWhF5VYJwjyeDu/WSb1ubVPA9dslJ9vERu5d5cboGQ5X5Bj1Wp7dfa8ANwpdVgHJ7Mn4jACd87Tk/bQwBydCHu7vooGFLz7ZNoPO8/gUKZXzNAhbOH2o6I2SXi4JlXAtMBYRISFkNJaW9Jtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967772; c=relaxed/simple;
	bh=L9TXqDmje3l7vbXeBbsMs2/svsGmBQAvC/uNFmhLLmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVGxefTCZ1V5p/Fqv2Lbb1la38caHTddOJc9oiBB7uLwNNEnRlQl9twSmwLjHe9ljZ3yDNGOOauEeUTQhaSxEW14OPmOrrbpem1q1AH22FV2pfSyWgkyr625xWykwzzK3x4mKY9bY2dr0+hjtvHB36PbH7IaLCfIhFhfIzRuHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rw2a6kH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rw2a6kH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE431F0089B;
	Mon, 21 Sep 2026 05:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967769;
	bh=JtXdB4tOMY8yQZAnGFn5daFwsAwdwklSo1JeZmkW/k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rw2a6kH4ITMGqzwwlWBH9DjIOk8Nemf8R0QqFZUafMVf/lrVBFiIiSUCeU5njYOeE
	 FhZPgIlXE2uAUSXDx4RK7H4143qgM0dwasVO6sStF3azimpR9Xbc/FB3wQsvVzTeA1
	 lG+Z3zG/EKGvqfI9KoFy4zoBFwXTTM0FNW4ykSLwr8Jo+4U1LSiNI41f5PXWJJXDrp
	 5M5UmqdGYCKjw0EK0CM7/Zz45UL7YY4R9WFMs9TWiKmr4uScADPUpLlMJ945bIbmZy
	 eWcr1v1iEJWVmwUvrnnRz+8/X6chmPSWBLjrcac85zVOKGmdHZvFqqgbnkb4vhpjjo
	 Gef2XAlWBgKGg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 15/20] lib/crypto: riscv/aes: Copy aes-macros.S to library
Date: Sun, 20 Sep 2026 22:09:01 -0700
Message-ID: <20260921050910.296144-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Copy arch/riscv/crypto/aes-macros.S to lib/crypto/riscv/aes-macros.S and
make lib/crypto/riscv/aes-riscv64-zvkned.S include the latter copy.

This makes it possible to change these macros without interfering with
the remaining code in arch/riscv/crypto/.

Of course, the copy in arch/riscv/crypto/ will be removed once the rest
of the AES code there is migrated to the library.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/riscv/aes-macros.S         | 166 ++++++++++++++++++++++++++
 lib/crypto/riscv/aes-riscv64-zvkned.S |   2 +-
 2 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 lib/crypto/riscv/aes-macros.S

diff --git a/lib/crypto/riscv/aes-macros.S b/lib/crypto/riscv/aes-macros.S
new file mode 100644
index 000000000000..1384164621a5
--- /dev/null
+++ b/lib/crypto/riscv/aes-macros.S
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause */
+//
+// This file is dual-licensed, meaning that you can use it under your
+// choice of either of the following two licenses:
+//
+// Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
+//
+// Licensed under the Apache License 2.0 (the "License"). You can obtain
+// a copy in the file LICENSE in the source distribution or at
+// https://www.openssl.org/source/license.html
+//
+// or
+//
+// Copyright (c) 2023, Christoph Müllner <christoph.muellner@vrull.eu>
+// Copyright (c) 2023, Phoebe Chen <phoebe.chen@sifive.com>
+// Copyright (c) 2023, Jerry Shih <jerry.shih@sifive.com>
+// Copyright 2024 Google LLC
+// All rights reserved.
+//
+// Redistribution and use in source and binary forms, with or without
+// modification, are permitted provided that the following conditions
+// are met:
+// 1. Redistributions of source code must retain the above copyright
+//    notice, this list of conditions and the following disclaimer.
+// 2. Redistributions in binary form must reproduce the above copyright
+//    notice, this list of conditions and the following disclaimer in the
+//    documentation and/or other materials provided with the distribution.
+//
+// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+// This file contains macros that are shared by the other aes-*.S files.  The
+// generated code of these macros depends on the following RISC-V extensions:
+// - RV64I
+// - RISC-V Vector ('V') with VLEN >= 128
+// - RISC-V Vector AES block cipher extension ('Zvkned')
+
+// Loads the AES round keys from \keyp into vector registers and jumps to code
+// specific to the length of the key.  Specifically:
+//   - If AES-128, loads round keys into v1-v11 and jumps to \label128.
+//   - If AES-192, loads round keys into v1-v13 and jumps to \label192.
+//   - If AES-256, loads round keys into v1-v15 and continues onwards.
+//
+// Also sets vl=4 and vtype=e32,m1,ta,ma.  Clobbers t0 and t1.
+.macro	aes_begin	keyp, label128, label192, key_len
+.ifb \key_len
+	lwu		t0, 480(\keyp)	// t0 = key length in bytes
+.endif
+	li		t1, 24		// t1 = key length for AES-192
+	vsetivli	zero, 4, e32, m1, ta, ma
+	vle32.v		v1, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v2, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v3, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v4, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v5, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v6, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v7, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v8, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v9, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v10, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v11, (\keyp)
+.ifb \key_len
+	blt		t0, t1, \label128	// If AES-128, goto label128.
+.else
+	blt		\key_len, t1, \label128	// If AES-128, goto label128.
+.endif
+	addi		\keyp, \keyp, 16
+	vle32.v		v12, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v13, (\keyp)
+.ifb \key_len
+	beq		t0, t1, \label192	// If AES-192, goto label192.
+.else
+	beq		\key_len, t1, \label192	// If AES-192, goto label192.
+.endif
+	// Else, it's AES-256.
+	addi		\keyp, \keyp, 16
+	vle32.v		v14, (\keyp)
+	addi		\keyp, \keyp, 16
+	vle32.v		v15, (\keyp)
+.endm
+
+// Encrypts \data using zvkned instructions, using the round keys loaded into
+// v1-v11 (for AES-128), v1-v13 (for AES-192), or v1-v15 (for AES-256).  \keylen
+// is the AES key length in bits.  vl and vtype must already be set
+// appropriately.  Note that if vl > 4, multiple blocks are encrypted.
+.macro	aes_encrypt	data, keylen
+	vaesz.vs	\data, v1
+	vaesem.vs	\data, v2
+	vaesem.vs	\data, v3
+	vaesem.vs	\data, v4
+	vaesem.vs	\data, v5
+	vaesem.vs	\data, v6
+	vaesem.vs	\data, v7
+	vaesem.vs	\data, v8
+	vaesem.vs	\data, v9
+	vaesem.vs	\data, v10
+.if \keylen == 128
+	vaesef.vs	\data, v11
+.elseif \keylen == 192
+	vaesem.vs	\data, v11
+	vaesem.vs	\data, v12
+	vaesef.vs	\data, v13
+.else
+	vaesem.vs	\data, v11
+	vaesem.vs	\data, v12
+	vaesem.vs	\data, v13
+	vaesem.vs	\data, v14
+	vaesef.vs	\data, v15
+.endif
+.endm
+
+// Same as aes_encrypt, but decrypts instead of encrypts.
+.macro	aes_decrypt	data, keylen
+.if \keylen == 128
+	vaesz.vs	\data, v11
+.elseif \keylen == 192
+	vaesz.vs	\data, v13
+	vaesdm.vs	\data, v12
+	vaesdm.vs	\data, v11
+.else
+	vaesz.vs	\data, v15
+	vaesdm.vs	\data, v14
+	vaesdm.vs	\data, v13
+	vaesdm.vs	\data, v12
+	vaesdm.vs	\data, v11
+.endif
+	vaesdm.vs	\data, v10
+	vaesdm.vs	\data, v9
+	vaesdm.vs	\data, v8
+	vaesdm.vs	\data, v7
+	vaesdm.vs	\data, v6
+	vaesdm.vs	\data, v5
+	vaesdm.vs	\data, v4
+	vaesdm.vs	\data, v3
+	vaesdm.vs	\data, v2
+	vaesdf.vs	\data, v1
+.endm
+
+// Expands to aes_encrypt or aes_decrypt according to \enc, which is 1 or 0.
+.macro	aes_crypt	data, enc, keylen
+.if \enc
+	aes_encrypt	\data, \keylen
+.else
+	aes_decrypt	\data, \keylen
+.endif
+.endm
diff --git a/lib/crypto/riscv/aes-riscv64-zvkned.S b/lib/crypto/riscv/aes-riscv64-zvkned.S
index 0d988bc3d37b..7a52ea6c669d 100644
--- a/lib/crypto/riscv/aes-riscv64-zvkned.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned.S
@@ -48,7 +48,7 @@
 .text
 .option arch, +zvkned
 
-#include "../../arch/riscv/crypto/aes-macros.S"
+#include "aes-macros.S"
 
 #define RNDKEYS		a0
 #define KEY_LEN		a1
-- 
2.55.0

