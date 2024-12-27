Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78581F8671;
	Fri, 27 Dec 2024 22:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735337391; cv=none; b=bpZDOD2fXHgPC8+UdWoXBUf+VbP+TMBw7UrccjSJoMlMMjWTmC0BC5byzxhHgLn4nr58qqLY7p7qaci+V5cKouTRtb8uhTbLs6xxk3dIHKQAW6joaBsW1auP3aSDXxJd82rfAvUSltGrxjFFQiigN6IChX9Wt3rgY5m1EZmentM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735337391; c=relaxed/simple;
	bh=ACug/Gk+Imv5MuEhZDq3pEqbFjIIbrOUN5ITKtW/mRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1w0qebFiXx3SKnT+k63APCYja9uRB7NG0rmeKK0zwuqehn7gxtN6C6i/pakfSO0vQYv1l1u2pS9b4P1WGCQrAFzIGHBSbBY3cgaM8hhY0l6HpMIuuR/5qlCfAMuL23BqTqhHyjDteIWAww66vH47B7K/X45pAhq6zKqf2zplLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRi/bqdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRi/bqdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32408C4CED4;
	Fri, 27 Dec 2024 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735337391;
	bh=ACug/Gk+Imv5MuEhZDq3pEqbFjIIbrOUN5ITKtW/mRg=;
	h=From:To:Cc:Subject:Date:From;
	b=RRi/bqdk+/BBIJkezORiy/ULMVyPM7Hg/DLxuSSMs8AYr91aQ7IZKj2bNoU7mGIqN
	 n0hCfqM6W1mJI3t8eeZsnPrpj19YLK2hGTqN3jhbxibvEe0+ogx2ekta9szU2I0DnJ
	 t/YEDbnQEagGwpQ56A7hol6jN/dcK3xyA3wAOy53D0P8R1hFXdtZ55jEp8CgspfP1i
	 +K8qWIv+K2/FqnxNg8ff32PBatdsgxN6Qr+CKb4kMnqoLwQO8XJA1bg9xq6yZVlTbs
	 u0+cUhiKnjLzt8NO2PYp+U0xAF5i5EEs89B5JLCMAvZfHWa8pd3qwgmIp92qpNkkB2
	 qMscNhSyVbEKg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: keywrap - remove unused keywrap algorithm
Date: Fri, 27 Dec 2024 14:08:02 -0800
Message-ID: <20241227220802.92550-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The keywrap (kw) algorithm has no in-tree user.  It has never had an
in-tree user, and the patch that added it provided no justification for
its inclusion.  Even use of it via AF_ALG is impossible, as it uses a
weird calling convention where part of the ciphertext is returned via
the IV buffer, which is not returned to userspace in AF_ALG.

It's also unclear whether any new code in the kernel that does key
wrapping would actually use this algorithm.  It is controversial in the
cryptographic community due to having no clearly stated security goal,
no security proof, poor performance, and only a 64-bit auth tag.  Later
work (https://eprint.iacr.org/2006/221) suggested that the goal is
deterministic authenticated encryption.  But there are now more modern
algorithms for this, and this is not the same as key wrapping, for which
a regular AEAD such as AES-GCM usually can be (and is) used instead.

Therefore, remove this unused code.

There were several special cases for this algorithm in the self-tests,
due to its weird calling convention.  Remove those too.

Cc: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/m68k/configs/amiga_defconfig          |   1 -
 arch/m68k/configs/apollo_defconfig         |   1 -
 arch/m68k/configs/atari_defconfig          |   1 -
 arch/m68k/configs/bvme6000_defconfig       |   1 -
 arch/m68k/configs/hp300_defconfig          |   1 -
 arch/m68k/configs/mac_defconfig            |   1 -
 arch/m68k/configs/multi_defconfig          |   1 -
 arch/m68k/configs/mvme147_defconfig        |   1 -
 arch/m68k/configs/mvme16x_defconfig        |   1 -
 arch/m68k/configs/q40_defconfig            |   1 -
 arch/m68k/configs/sun3_defconfig           |   1 -
 arch/m68k/configs/sun3x_defconfig          |   1 -
 arch/mips/configs/decstation_64_defconfig  |   1 -
 arch/mips/configs/decstation_defconfig     |   1 -
 arch/mips/configs/decstation_r4k_defconfig |   1 -
 arch/s390/configs/debug_defconfig          |   1 -
 arch/s390/configs/defconfig                |   1 -
 crypto/Kconfig                             |   8 -
 crypto/Makefile                            |   1 -
 crypto/keywrap.c                           | 319 ---------------------
 crypto/testmgr.c                           |  20 +-
 crypto/testmgr.h                           |  39 ---
 22 files changed, 1 insertion(+), 403 deletions(-)
 delete mode 100644 crypto/keywrap.c

diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index c705247e7b5b..d74581facb49 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -577,11 +577,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 6d62b9187a58..e3442fd188b6 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -534,11 +534,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index c3c644df852d..a9c41344a33b 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -554,11 +554,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 20261f819691..9b299152958c 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -526,11 +526,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index ce4fe93a0f70..851a564fcd7c 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -536,11 +536,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 040ae75f47c3..7773ce50673e 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -553,11 +553,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 20d877cb4e30..16039dcb0fca 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -640,11 +640,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 5e1c8d0d3da5..396e261719ff 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -526,11 +526,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 5d1409e6a137..30c189ccd89c 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -527,11 +527,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index e4c30e2b9bbb..09d6bc21edfb 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -543,11 +543,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 980843a9ea1e..641bae8492e7 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -524,11 +524,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 38681cc6b598..5b9ac77c0df1 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -524,11 +524,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 92a1d0aea38c..5d1e0f36c7cd 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -175,11 +175,10 @@ CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index db214fcebcbe..53699c0e3883 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -170,11 +170,10 @@ CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index 15b769e96d5b..ce8d9545659c 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -170,11 +170,10 @@ CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d8d227ab82de..174a31962d4f 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -768,11 +768,10 @@ CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_GCM=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 6c2f2bb4fbf8..d304d3b723b0 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -754,11 +754,10 @@ CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
-CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_GCM=y
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6b0bfbccac08..b686f0fe4078 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -682,18 +682,10 @@ config CRYPTO_HCTR2
 	  x86 processors with AES-NI and CLMUL, and ARM processors with the
 	  ARMv8 crypto extensions.
 
 	  See https://eprint.iacr.org/2021/1441
 
-config CRYPTO_KEYWRAP
-	tristate "KW (AES Key Wrap)"
-	select CRYPTO_SKCIPHER
-	select CRYPTO_MANAGER
-	help
-	  KW (AES Key Wrap) authenticated encryption mode (NIST SP800-38F
-	  and RFC3394) without padding.
-
 config CRYPTO_LRW
 	tristate "LRW (Liskov Rivest Wagner)"
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
diff --git a/crypto/Makefile b/crypto/Makefile
index 77abca715445..e1a27358265c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -93,11 +93,10 @@ obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
 obj-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
-obj-$(CONFIG_CRYPTO_KEYWRAP) += keywrap.o
 obj-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305) += nhpoly1305.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
deleted file mode 100644
index 5ec4f94d46bd..000000000000
--- a/crypto/keywrap.c
+++ /dev/null
@@ -1,319 +0,0 @@
-/*
- * Key Wrapping: RFC3394 / NIST SP800-38F
- *
- * Copyright (C) 2015, Stephan Mueller <smueller@chronox.de>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, and the entire permission notice in its entirety,
- *    including the disclaimer of warranties.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote
- *    products derived from this software without specific prior
- *    written permission.
- *
- * ALTERNATIVELY, this product may be distributed under the terms of
- * the GNU General Public License, in which case the provisions of the GPL2
- * are required INSTEAD OF the above restrictions.  (This clause is
- * necessary due to a potential bad interaction between the GPL and
- * the restrictions contained in a BSD-style copyright.)
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
- * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
- * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
- * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
- * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- */
-
-/*
- * Note for using key wrapping:
- *
- *	* The result of the encryption operation is the ciphertext starting
- *	  with the 2nd semiblock. The first semiblock is provided as the IV.
- *	  The IV used to start the encryption operation is the default IV.
- *
- *	* The input for the decryption is the first semiblock handed in as an
- *	  IV. The ciphertext is the data starting with the 2nd semiblock. The
- *	  return code of the decryption operation will be EBADMSG in case an
- *	  integrity error occurs.
- *
- * To obtain the full result of an encryption as expected by SP800-38F, the
- * caller must allocate a buffer of plaintext + 8 bytes:
- *
- *	unsigned int datalen = ptlen + crypto_skcipher_ivsize(tfm);
- *	u8 data[datalen];
- *	u8 *iv = data;
- *	u8 *pt = data + crypto_skcipher_ivsize(tfm);
- *		<ensure that pt contains the plaintext of size ptlen>
- *	sg_init_one(&sg, pt, ptlen);
- *	skcipher_request_set_crypt(req, &sg, &sg, ptlen, iv);
- *
- *	==> After encryption, data now contains full KW result as per SP800-38F.
- *
- * In case of decryption, ciphertext now already has the expected length
- * and must be segmented appropriately:
- *
- *	unsigned int datalen = CTLEN;
- *	u8 data[datalen];
- *		<ensure that data contains full ciphertext>
- *	u8 *iv = data;
- *	u8 *ct = data + crypto_skcipher_ivsize(tfm);
- *	unsigned int ctlen = datalen - crypto_skcipher_ivsize(tfm);
- *	sg_init_one(&sg, ct, ctlen);
- *	skcipher_request_set_crypt(req, &sg, &sg, ctlen, iv);
- *
- *	==> After decryption (which hopefully does not return EBADMSG), the ct
- *	pointer now points to the plaintext of size ctlen.
- *
- * Note 2: KWP is not implemented as this would defy in-place operation.
- *	   If somebody wants to wrap non-aligned data, he should simply pad
- *	   the input with zeros to fill it up to the 8 byte boundary.
- */
-
-#include <linux/module.h>
-#include <linux/crypto.h>
-#include <linux/scatterlist.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/cipher.h>
-#include <crypto/internal/skcipher.h>
-
-struct crypto_kw_block {
-#define SEMIBSIZE 8
-	__be64 A;
-	__be64 R;
-};
-
-/*
- * Fast forward the SGL to the "end" length minus SEMIBSIZE.
- * The start in the SGL defined by the fast-forward is returned with
- * the walk variable
- */
-static void crypto_kw_scatterlist_ff(struct scatter_walk *walk,
-				     struct scatterlist *sg,
-				     unsigned int end)
-{
-	unsigned int skip = 0;
-
-	/* The caller should only operate on full SEMIBLOCKs. */
-	BUG_ON(end < SEMIBSIZE);
-
-	skip = end - SEMIBSIZE;
-	while (sg) {
-		if (sg->length > skip) {
-			scatterwalk_start(walk, sg);
-			scatterwalk_advance(walk, skip);
-			break;
-		}
-
-		skip -= sg->length;
-		sg = sg_next(sg);
-	}
-}
-
-static int crypto_kw_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	struct crypto_kw_block block;
-	struct scatterlist *src, *dst;
-	u64 t = 6 * ((req->cryptlen) >> 3);
-	unsigned int i;
-	int ret = 0;
-
-	/*
-	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
-	 * required by SP800-38F is the IV.
-	 */
-	if (req->cryptlen < (2 * SEMIBSIZE) || req->cryptlen % SEMIBSIZE)
-		return -EINVAL;
-
-	/* Place the IV into block A */
-	memcpy(&block.A, req->iv, SEMIBSIZE);
-
-	/*
-	 * src scatterlist is read-only. dst scatterlist is r/w. During the
-	 * first loop, src points to req->src and dst to req->dst. For any
-	 * subsequent round, the code operates on req->dst only.
-	 */
-	src = req->src;
-	dst = req->dst;
-
-	for (i = 0; i < 6; i++) {
-		struct scatter_walk src_walk, dst_walk;
-		unsigned int nbytes = req->cryptlen;
-
-		while (nbytes) {
-			/* move pointer by nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&src_walk, src, nbytes);
-			/* get the source block */
-			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
-					       false);
-
-			/* perform KW operation: modify IV with counter */
-			block.A ^= cpu_to_be64(t);
-			t--;
-			/* perform KW operation: decrypt block */
-			crypto_cipher_decrypt_one(cipher, (u8 *)&block,
-						  (u8 *)&block);
-
-			/* move pointer by nbytes in the SGL */
-			crypto_kw_scatterlist_ff(&dst_walk, dst, nbytes);
-			/* Copy block->R into place */
-			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
-					       true);
-
-			nbytes -= SEMIBSIZE;
-		}
-
-		/* we now start to operate on the dst SGL only */
-		src = req->dst;
-		dst = req->dst;
-	}
-
-	/* Perform authentication check */
-	if (block.A != cpu_to_be64(0xa6a6a6a6a6a6a6a6ULL))
-		ret = -EBADMSG;
-
-	memzero_explicit(&block, sizeof(struct crypto_kw_block));
-
-	return ret;
-}
-
-static int crypto_kw_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	struct crypto_kw_block block;
-	struct scatterlist *src, *dst;
-	u64 t = 1;
-	unsigned int i;
-
-	/*
-	 * Require at least 2 semiblocks (note, the 3rd semiblock that is
-	 * required by SP800-38F is the IV that occupies the first semiblock.
-	 * This means that the dst memory must be one semiblock larger than src.
-	 * Also ensure that the given data is aligned to semiblock.
-	 */
-	if (req->cryptlen < (2 * SEMIBSIZE) || req->cryptlen % SEMIBSIZE)
-		return -EINVAL;
-
-	/*
-	 * Place the predefined IV into block A -- for encrypt, the caller
-	 * does not need to provide an IV, but he needs to fetch the final IV.
-	 */
-	block.A = cpu_to_be64(0xa6a6a6a6a6a6a6a6ULL);
-
-	/*
-	 * src scatterlist is read-only. dst scatterlist is r/w. During the
-	 * first loop, src points to req->src and dst to req->dst. For any
-	 * subsequent round, the code operates on req->dst only.
-	 */
-	src = req->src;
-	dst = req->dst;
-
-	for (i = 0; i < 6; i++) {
-		struct scatter_walk src_walk, dst_walk;
-		unsigned int nbytes = req->cryptlen;
-
-		scatterwalk_start(&src_walk, src);
-		scatterwalk_start(&dst_walk, dst);
-
-		while (nbytes) {
-			/* get the source block */
-			scatterwalk_copychunks(&block.R, &src_walk, SEMIBSIZE,
-					       false);
-
-			/* perform KW operation: encrypt block */
-			crypto_cipher_encrypt_one(cipher, (u8 *)&block,
-						  (u8 *)&block);
-			/* perform KW operation: modify IV with counter */
-			block.A ^= cpu_to_be64(t);
-			t++;
-
-			/* Copy block->R into place */
-			scatterwalk_copychunks(&block.R, &dst_walk, SEMIBSIZE,
-					       true);
-
-			nbytes -= SEMIBSIZE;
-		}
-
-		/* we now start to operate on the dst SGL only */
-		src = req->dst;
-		dst = req->dst;
-	}
-
-	/* establish the IV for the caller to pick up */
-	memcpy(req->iv, &block.A, SEMIBSIZE);
-
-	memzero_explicit(&block, sizeof(struct crypto_kw_block));
-
-	return 0;
-}
-
-static int crypto_kw_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct skcipher_instance *inst;
-	struct crypto_alg *alg;
-	int err;
-
-	inst = skcipher_alloc_instance_simple(tmpl, tb);
-	if (IS_ERR(inst))
-		return PTR_ERR(inst);
-
-	alg = skcipher_ialg_simple(inst);
-
-	err = -EINVAL;
-	/* Section 5.1 requirement for KW */
-	if (alg->cra_blocksize != sizeof(struct crypto_kw_block))
-		goto out_free_inst;
-
-	inst->alg.base.cra_blocksize = SEMIBSIZE;
-	inst->alg.ivsize = SEMIBSIZE;
-
-	inst->alg.encrypt = crypto_kw_encrypt;
-	inst->alg.decrypt = crypto_kw_decrypt;
-
-	err = skcipher_register_instance(tmpl, inst);
-	if (err) {
-out_free_inst:
-		inst->free(inst);
-	}
-
-	return err;
-}
-
-static struct crypto_template crypto_kw_tmpl = {
-	.name = "kw",
-	.create = crypto_kw_create,
-	.module = THIS_MODULE,
-};
-
-static int __init crypto_kw_init(void)
-{
-	return crypto_register_template(&crypto_kw_tmpl);
-}
-
-static void __exit crypto_kw_exit(void)
-{
-	crypto_unregister_template(&crypto_kw_tmpl);
-}
-
-subsys_initcall(crypto_kw_init);
-module_exit(crypto_kw_exit);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("Key Wrapping (RFC3394 / NIST SP800-38F)");
-MODULE_ALIAS_CRYPTO("kw");
-MODULE_IMPORT_NS("CRYPTO_INTERNAL");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f5f48ab18c7..02088fbeb526 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2883,22 +2883,15 @@ static int test_skcipher_vec_cfg(int enc, const struct cipher_testvec *vec,
 
 	/* The IV must be copied to a buffer, as the algorithm may modify it */
 	if (ivsize) {
 		if (WARN_ON(ivsize > MAX_IVLEN))
 			return -EINVAL;
-		if (vec->generates_iv && !enc)
-			memcpy(iv, vec->iv_out, ivsize);
-		else if (vec->iv)
+		if (vec->iv)
 			memcpy(iv, vec->iv, ivsize);
 		else
 			memset(iv, 0, ivsize);
 	} else {
-		if (vec->generates_iv) {
-			pr_err("alg: skcipher: %s has ivsize=0 but test vector %s generates IV!\n",
-			       driver, vec_name);
-			return -EINVAL;
-		}
 		iv = NULL;
 	}
 
 	/* Build the src/dst scatterlists */
 	input.iov_base = enc ? (void *)vec->ptext : (void *)vec->ctext;
@@ -3131,14 +3124,10 @@ static int test_skcipher_vs_generic_impl(const char *generic_driver,
 	int err;
 
 	if (noextratests)
 		return 0;
 
-	/* Keywrap isn't supported here yet as it handles its IV differently. */
-	if (strncmp(algname, "kw(", 3) == 0)
-		return 0;
-
 	init_rnd_state(&rng);
 
 	if (!generic_driver) { /* Use default naming convention? */
 		err = build_generic_driver_name(algname, _generic_driver);
 		if (err)
@@ -5406,17 +5395,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "jitterentropy_rng",
 		.fips_allowed = 1,
 		.test = alg_test_null,
-	}, {
-		.alg = "kw(aes)",
-		.test = alg_test_skcipher,
-		.fips_allowed = 1,
-		.suite = {
-			.cipher = __VECS(aes_kw_tv_template)
-		}
 	}, {
 		.alg = "lrw(aes)",
 		.generic_driver = "lrw(ecb(aes-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 430d33d9ac13..4e279597033e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -57,12 +57,10 @@ struct hash_testvec {
  * @ctext:	Pointer to ciphertext
  * @len:	Length of @ptext and @ctext in bytes
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  * 		( e.g. test needs to fail due to a weak key )
  * @fips_skip:	Skip the test vector in FIPS mode
- * @generates_iv: Encryption should ignore the given IV, and output @iv_out.
- *		  Decryption takes @iv_out.  Needed for AES Keywrap ("kw(aes)").
  * @setkey_error: Expected error from setkey()
  * @crypt_error: Expected error from encrypt() and decrypt()
  */
 struct cipher_testvec {
 	const char *key;
@@ -72,11 +70,10 @@ struct cipher_testvec {
 	const char *ctext;
 	unsigned char wk; /* weak key flag */
 	unsigned short klen;
 	unsigned int len;
 	bool fips_skip;
-	bool generates_iv;
 	int setkey_error;
 	int crypt_error;
 };
 
 /*
@@ -24346,46 +24343,10 @@ static const struct aead_testvec aegis128_tv_template[] = {
 			  "\x78\x93\xec\xfc\xf4\xff\xe1\x2d",
 		.clen	= 24,
 	},
 };
 
-/*
- * All key wrapping test vectors taken from
- * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
- *
- * Note: as documented in keywrap.c, the ivout for encryption is the first
- * semiblock of the ciphertext from the test vector. For decryption, iv is
- * the first semiblock of the ciphertext.
- */
-static const struct cipher_testvec aes_kw_tv_template[] = {
-	{
-		.key	= "\x75\x75\xda\x3a\x93\x60\x7c\xc2"
-			  "\xbf\xd8\xce\xc7\xaa\xdf\xd9\xa6",
-		.klen	= 16,
-		.ptext	= "\x42\x13\x6d\x3c\x38\x4a\x3e\xea"
-			  "\xc9\x5a\x06\x6f\xd2\x8f\xed\x3f",
-		.ctext	= "\xf6\x85\x94\x81\x6f\x64\xca\xa3"
-			  "\xf5\x6f\xab\xea\x25\x48\xf5\xfb",
-		.len	= 16,
-		.iv_out	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
-		.generates_iv = true,
-	}, {
-		.key	= "\x80\xaa\x99\x73\x27\xa4\x80\x6b"
-			  "\x6a\x7a\x41\xa5\x2b\x86\xc3\x71"
-			  "\x03\x86\xf9\x32\x78\x6e\xf7\x96"
-			  "\x76\xfa\xfb\x90\xb8\x26\x3c\x5f",
-		.klen	= 32,
-		.ptext	= "\x0a\x25\x6b\xa7\x5c\xfa\x03\xaa"
-			  "\xa0\x2b\xa9\x42\x03\xf1\x5b\xaa",
-		.ctext	= "\xd3\x3d\x3d\x97\x7b\xf0\xa9\x15"
-			  "\x59\xf9\x9c\x8a\xcd\x29\x3d\x43",
-		.len	= 16,
-		.iv_out	= "\x42\x3c\x96\x0d\x8a\x2a\xc4\xc1",
-		.generates_iv = true,
-	},
-};
-
 /*
  * ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode)
  * test vectors, taken from Appendix B.2.9 and B.2.10:
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
  * Only AES-128 is supported at this time.

base-commit: 7b6092ee7a4ce2d03dc65b87537889e8e1e0ab95
-- 
2.47.1

