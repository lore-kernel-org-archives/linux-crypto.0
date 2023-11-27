Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="e+8bCO8j"
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEBF10E2
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:38 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cfc9c4acb6so4186755ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068857; x=1701673657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7M9E14E6fLJh7AJb55zP++mgBfFiPcFBw2pNzr7Sm0I=;
        b=e+8bCO8jEFA6gYSaBocJdXaAeQD99UnoxHcv8K1CJJzl4l8KES2IllcSMwwIOO1umW
         EiymFzKvalJGKiyzR9H2BK9/QQ/x7lsmhS9HxwucnActR3WNil1tLWJXiDMSMeVOE/ri
         imcJuKWd87odmk5VR3EaPcRwEaYRlOhPuY7dlOgdf4nPz4VtrexEVg0dIyQxPDepdOHR
         P3t/wIqWCIySUrMnK+cxuUY6nLmO1zlnf7YVAHONSb49hiGdniJdCyA1z9yP3KEPlhOc
         PRqVnUdfqirluL2z7EWP/PNCfH30driZ1cNuUIGG+75Mo7df65ma1dvlrpqiBQP142ZP
         yaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068857; x=1701673657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7M9E14E6fLJh7AJb55zP++mgBfFiPcFBw2pNzr7Sm0I=;
        b=IJMPrGIqAONTBmLb4kqtWPyLuxxwxwSlB85JFRSYiYXvwDY/rPdVYs2PNrLUp2HUKk
         ThZYyTf9TMUdKLlvOX4ZYyak6JoxkgqlmWw83StZDp543BmLrohwDPZawLbi66SN3xjx
         pdTCbbMD9caaEe2uVc3rxxFbLn6ZFiWZSs7n3rInDAC9bk9etHi4RLqt2HIysKaE46fe
         BRgPdRpP53NNgsIJl23QKb7sC+KUe3ye/S5EZFhRttupWvJv4dpmTUCpBCJvZt0cGbap
         EhVnU6NqnauI7grk0cWJO4qv14d1m84Ee9KQI38uo4x/JnlGonzs79BJJmVSqBpZlYBy
         Tu7g==
X-Gm-Message-State: AOJu0YzPr0z2Mqx0woyZ5C6TTJjSgpb0lerLuoduKi9Jih+qBse3mdzP
	Mnuihfyse0ln8wloGHbHbcrqog==
X-Google-Smtp-Source: AGHT+IHVda7BxvkREXau4SuF+gpfjUKcDNap6z/qKUI6eGy91unUWy63cKgknIxJ/anhs1Q3NGprvg==
X-Received: by 2002:a17:902:b488:b0:1cc:5aef:f2c1 with SMTP id y8-20020a170902b48800b001cc5aeff2c1mr9325175plr.33.1701068857649;
        Sun, 26 Nov 2023 23:07:37 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:37 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 08/13] RISC-V: crypto: add Zvkg accelerated GCM GHASH implementation
Date: Mon, 27 Nov 2023 15:06:58 +0800
Message-Id: <20231127070703.1697-9-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231127070703.1697-1-jerry.shih@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a gcm hash implementation using the Zvkg extension from OpenSSL
(openssl/openssl#21923).

The perlasm here is different from the original implementation in OpenSSL.
The OpenSSL assumes that the H is stored in little-endian. Thus, it needs
to convert the H to big-endian for Zvkg instructions. In kernel, we have
the big-endian H directly. There is no need for endian conversion.

Co-developed-by: Christoph Müllner <christoph.muellner@vrull.eu>
Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Co-developed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
Changelog v2:
 - Do not turn on kconfig `GHASH_RISCV64` option by default.
 - Add `asmlinkage` qualifier for crypto asm function.
 - Update the ghash fallback path in ghash_blocks().
 - Rename structure riscv64_ghash_context to riscv64_ghash_tfm_ctx.
 - Fold ghash_update_zvkg() and ghash_final_zvkg().
 - Reorder structure riscv64_ghash_alg_zvkg members initialization in the
   order declared.
---
 arch/riscv/crypto/Kconfig               |  10 ++
 arch/riscv/crypto/Makefile              |   7 +
 arch/riscv/crypto/ghash-riscv64-glue.c  | 175 ++++++++++++++++++++++++
 arch/riscv/crypto/ghash-riscv64-zvkg.pl | 100 ++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/ghash-riscv64-zvkg.pl

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 9d991ddda289..6863f01a2ab0 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -34,4 +34,14 @@ config CRYPTO_AES_BLOCK_RISCV64
 	  - Zvkb vector crypto extension (CTR/XTS)
 	  - Zvkg vector crypto extension (XTS)
 
+config CRYPTO_GHASH_RISCV64
+	tristate "Hash functions: GHASH"
+	depends on 64BIT && RISCV_ISA_V
+	select CRYPTO_GCM
+	help
+	  GCM GHASH function (NIST SP 800-38D)
+
+	  Architecture: riscv64 using:
+	  - Zvkg vector crypto extension
+
 endmenu
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 9574b009762f..94a7f8eaa8a7 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -9,6 +9,9 @@ aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o
 obj-$(CONFIG_CRYPTO_AES_BLOCK_RISCV64) += aes-block-riscv64.o
 aes-block-riscv64-y := aes-riscv64-block-mode-glue.o aes-riscv64-zvkned-zvbb-zvkg.o aes-riscv64-zvkned-zvkb.o
 
+obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
+ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
+
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) void $(@)
 
@@ -21,6 +24,10 @@ $(obj)/aes-riscv64-zvkned-zvbb-zvkg.S: $(src)/aes-riscv64-zvkned-zvbb-zvkg.pl
 $(obj)/aes-riscv64-zvkned-zvkb.S: $(src)/aes-riscv64-zvkned-zvkb.pl
 	$(call cmd,perlasm)
 
+$(obj)/ghash-riscv64-zvkg.S: $(src)/ghash-riscv64-zvkg.pl
+	$(call cmd,perlasm)
+
 clean-files += aes-riscv64-zvkned.S
 clean-files += aes-riscv64-zvkned-zvbb-zvkg.S
 clean-files += aes-riscv64-zvkned-zvkb.S
+clean-files += ghash-riscv64-zvkg.S
diff --git a/arch/riscv/crypto/ghash-riscv64-glue.c b/arch/riscv/crypto/ghash-riscv64-glue.c
new file mode 100644
index 000000000000..b01ab5714677
--- /dev/null
+++ b/arch/riscv/crypto/ghash-riscv64-glue.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * RISC-V optimized GHASH routines
+ *
+ * Copyright (C) 2023 VRULL GmbH
+ * Author: Heiko Stuebner <heiko.stuebner@vrull.eu>
+ *
+ * Copyright (C) 2023 SiFive, Inc.
+ * Author: Jerry Shih <jerry.shih@sifive.com>
+ */
+
+#include <asm/simd.h>
+#include <asm/vector.h>
+#include <crypto/ghash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
+#include <linux/crypto.h>
+#include <linux/linkage.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+/* ghash using zvkg vector crypto extension */
+asmlinkage void gcm_ghash_rv64i_zvkg(be128 *Xi, const be128 *H, const u8 *inp,
+				     size_t len);
+
+struct riscv64_ghash_tfm_ctx {
+	be128 key;
+};
+
+struct riscv64_ghash_desc_ctx {
+	be128 shash;
+	u8 buffer[GHASH_BLOCK_SIZE];
+	u32 bytes;
+};
+
+static inline void ghash_blocks(const struct riscv64_ghash_tfm_ctx *tctx,
+				struct riscv64_ghash_desc_ctx *dctx,
+				const u8 *src, size_t srclen)
+{
+	/* The srclen is nonzero and a multiple of 16. */
+	if (crypto_simd_usable()) {
+		kernel_vector_begin();
+		gcm_ghash_rv64i_zvkg(&dctx->shash, &tctx->key, src, srclen);
+		kernel_vector_end();
+	} else {
+		do {
+			crypto_xor((u8 *)&dctx->shash, src, GHASH_BLOCK_SIZE);
+			gf128mul_lle(&dctx->shash, &tctx->key);
+			srclen -= GHASH_BLOCK_SIZE;
+			src += GHASH_BLOCK_SIZE;
+		} while (srclen);
+	}
+}
+
+static int ghash_init(struct shash_desc *desc)
+{
+	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	*dctx = (struct riscv64_ghash_desc_ctx){};
+
+	return 0;
+}
+
+static int ghash_update_zvkg(struct shash_desc *desc, const u8 *src,
+			     unsigned int srclen)
+{
+	size_t len;
+	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	if (dctx->bytes) {
+		if (dctx->bytes + srclen < GHASH_BLOCK_SIZE) {
+			memcpy(dctx->buffer + dctx->bytes, src, srclen);
+			dctx->bytes += srclen;
+			return 0;
+		}
+		memcpy(dctx->buffer + dctx->bytes, src,
+		       GHASH_BLOCK_SIZE - dctx->bytes);
+
+		ghash_blocks(tctx, dctx, dctx->buffer, GHASH_BLOCK_SIZE);
+
+		src += GHASH_BLOCK_SIZE - dctx->bytes;
+		srclen -= GHASH_BLOCK_SIZE - dctx->bytes;
+		dctx->bytes = 0;
+	}
+	len = srclen & ~(GHASH_BLOCK_SIZE - 1);
+
+	if (len) {
+		ghash_blocks(tctx, dctx, src, len);
+		src += len;
+		srclen -= len;
+	}
+
+	if (srclen) {
+		memcpy(dctx->buffer, src, srclen);
+		dctx->bytes = srclen;
+	}
+
+	return 0;
+}
+
+static int ghash_final_zvkg(struct shash_desc *desc, u8 *out)
+{
+	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	int i;
+
+	if (dctx->bytes) {
+		for (i = dctx->bytes; i < GHASH_BLOCK_SIZE; i++)
+			dctx->buffer[i] = 0;
+
+		ghash_blocks(tctx, dctx, dctx->buffer, GHASH_BLOCK_SIZE);
+	}
+
+	memcpy(out, &dctx->shash, GHASH_DIGEST_SIZE);
+
+	return 0;
+}
+
+static int ghash_setkey(struct crypto_shash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen != GHASH_BLOCK_SIZE)
+		return -EINVAL;
+
+	memcpy(&tctx->key, key, GHASH_BLOCK_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg riscv64_ghash_alg_zvkg = {
+	.init = ghash_init,
+	.update = ghash_update_zvkg,
+	.final = ghash_final_zvkg,
+	.setkey = ghash_setkey,
+	.descsize = sizeof(struct riscv64_ghash_desc_ctx),
+	.digestsize = GHASH_DIGEST_SIZE,
+	.base = {
+		.cra_blocksize = GHASH_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct riscv64_ghash_tfm_ctx),
+		.cra_priority = 303,
+		.cra_name = "ghash",
+		.cra_driver_name = "ghash-riscv64-zvkg",
+		.cra_module = THIS_MODULE,
+	},
+};
+
+static inline bool check_ghash_ext(void)
+{
+	return riscv_isa_extension_available(NULL, ZVKG) &&
+	       riscv_vector_vlen() >= 128;
+}
+
+static int __init riscv64_ghash_mod_init(void)
+{
+	if (check_ghash_ext())
+		return crypto_register_shash(&riscv64_ghash_alg_zvkg);
+
+	return -ENODEV;
+}
+
+static void __exit riscv64_ghash_mod_fini(void)
+{
+	crypto_unregister_shash(&riscv64_ghash_alg_zvkg);
+}
+
+module_init(riscv64_ghash_mod_init);
+module_exit(riscv64_ghash_mod_fini);
+
+MODULE_DESCRIPTION("GCM GHASH (RISC-V accelerated)");
+MODULE_AUTHOR("Heiko Stuebner <heiko.stuebner@vrull.eu>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("ghash");
diff --git a/arch/riscv/crypto/ghash-riscv64-zvkg.pl b/arch/riscv/crypto/ghash-riscv64-zvkg.pl
new file mode 100644
index 000000000000..4beea4ac9cbe
--- /dev/null
+++ b/arch/riscv/crypto/ghash-riscv64-zvkg.pl
@@ -0,0 +1,100 @@
+#! /usr/bin/env perl
+# SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause
+#
+# This file is dual-licensed, meaning that you can use it under your
+# choice of either of the following two licenses:
+#
+# Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
+#
+# Licensed under the Apache License 2.0 (the "License"). You can obtain
+# a copy in the file LICENSE in the source distribution or at
+# https://www.openssl.org/source/license.html
+#
+# or
+#
+# Copyright (c) 2023, Christoph Müllner <christoph.muellner@vrull.eu>
+# Copyright (c) 2023, Jerry Shih <jerry.shih@sifive.com>
+# All rights reserved.
+#
+# Redistribution and use in source and binary forms, with or without
+# modification, are permitted provided that the following conditions
+# are met:
+# 1. Redistributions of source code must retain the above copyright
+#    notice, this list of conditions and the following disclaimer.
+# 2. Redistributions in binary form must reproduce the above copyright
+#    notice, this list of conditions and the following disclaimer in the
+#    documentation and/or other materials provided with the distribution.
+#
+# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+
+# - RV64I
+# - RISC-V Vector ('V') with VLEN >= 128
+# - RISC-V Vector GCM/GMAC extension ('Zvkg')
+
+use strict;
+use warnings;
+
+use FindBin qw($Bin);
+use lib "$Bin";
+use lib "$Bin/../../perlasm";
+use riscv;
+
+# $output is the last argument if it looks like a file (it has an extension)
+# $flavour is the first argument if it doesn't look like a file
+my $output = $#ARGV >= 0 && $ARGV[$#ARGV] =~ m|\.\w+$| ? pop : undef;
+my $flavour = $#ARGV >= 0 && $ARGV[0] !~ m|\.| ? shift : undef;
+
+$output and open STDOUT,">$output";
+
+my $code=<<___;
+.text
+___
+
+###############################################################################
+# void gcm_ghash_rv64i_zvkg(be128 *Xi, const be128 *H, const u8 *inp, size_t len)
+#
+# input: Xi: current hash value
+#        H: hash key
+#        inp: pointer to input data
+#        len: length of input data in bytes (multiple of block size)
+# output: Xi: Xi+1 (next hash value Xi)
+{
+my ($Xi,$H,$inp,$len) = ("a0","a1","a2","a3");
+my ($vXi,$vH,$vinp,$Vzero) = ("v1","v2","v3","v4");
+
+$code .= <<___;
+.p2align 3
+.globl gcm_ghash_rv64i_zvkg
+.type gcm_ghash_rv64i_zvkg,\@function
+gcm_ghash_rv64i_zvkg:
+    @{[vsetivli "zero", 4, "e32", "m1", "ta", "ma"]}
+    @{[vle32_v $vH, $H]}
+    @{[vle32_v $vXi, $Xi]}
+
+Lstep:
+    @{[vle32_v $vinp, $inp]}
+    add $inp, $inp, 16
+    add $len, $len, -16
+    @{[vghsh_vv $vXi, $vH, $vinp]}
+    bnez $len, Lstep
+
+    @{[vse32_v $vXi, $Xi]}
+    ret
+
+.size gcm_ghash_rv64i_zvkg,.-gcm_ghash_rv64i_zvkg
+___
+}
+
+print $code;
+
+close STDOUT or die "error closing STDOUT: $!";
-- 
2.28.0

