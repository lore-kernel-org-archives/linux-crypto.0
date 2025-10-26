Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E398B283FE5;
	Sun, 26 Oct 2025 05:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457988; cv=none; b=bTHJ4S08M4IrVrxBBPczKgZkodcdyeM5ElUHIBQP06xSe9pBLnpYG23fukIYMdflU7I1QoqH+7z46yKJ6M2ulah71rHN30Rufe+CLE+/sRei7TQ1q0du+rxs55pNy/5VYXBVxiqCZfEHXV7FEwy4swM2Kg7rPcvgPYS84a9TEUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457988; c=relaxed/simple;
	bh=UDeV+e2gTIJPhO0d+cQbe63gbfwYnFHdWs0Ho6ezHg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VW44EEFf9BJAZnu3amwKoe8EsyoT1qzqQxZ+Mi9MX0N+lPDLZvkc7tnRrOOBSn5zuc5PwmzS2St8vg2Z888Cx+FNyDn9HDyrkT7jKnWGKEqdHfpLmGeQ5ph3h0VOm5o5++9R44BEQn/0OKtVf4XOkNf81zi4s8nxLdxV3U3PFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUSepT19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUSepT19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A9C116C6;
	Sun, 26 Oct 2025 05:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457987;
	bh=UDeV+e2gTIJPhO0d+cQbe63gbfwYnFHdWs0Ho6ezHg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUSepT19WMWWLhm/3WnKdHgpZlIAoFal9CQHkqFa4qLw5yULTpRBxag4bbuH+qh0V
	 mu4/41ajLPPg4RQziYYXAU+j4GSdkfCo02xmTo9u5LSTsRDjou7i/QU1QXcGljVHrt
	 /35RPFqSU+1Fj37OIUV/UxrvGCrzxmwQfpDdo+xDYvuGyzVNGVqNBk7YI0DEAnFm53
	 DesU1dALhqTdyz8V6p7hYZUybZAHPYtajemxkf527gYM48pb/+FN67/7gW7pfQkErY
	 uQUWO5uq6eWnkPvraolNzYsPvyLquG22Kye3RWAJyvztSW5fJAzlIdYCPn/BcNtZDr
	 DjevePua//JHA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/15] lib/crypto: s390/sha3: Add optimized Keccak functions
Date: Sat, 25 Oct 2025 22:50:27 -0700
Message-ID: <20251026055032.1413733-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement sha3_absorb_blocks() and sha3_keccakf() using the hardware-
accelerated SHA-3 support in Message-Security-Assist Extension 6.

This accelerates the SHA3-224, SHA3-256, SHA3-384, SHA3-512, and
SHAKE256 library functions.

Note that arch/s390/crypto/ already has SHA-3 code that uses this
extension, but it is exposed only via crypto_shash.  This commit brings
the same acceleration to the SHA-3 library.  The arch/s390/crypto/
version will become redundant and be removed in later changes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig     |  1 +
 lib/crypto/s390/sha3.h | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 lib/crypto/s390/sha3.h

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 587490ca65654..7445054fc0ad4 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -204,10 +204,11 @@ config CRYPTO_LIB_SHA3
 
 config CRYPTO_LIB_SHA3_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA3 && !UML
 	default y if ARM64 && KERNEL_MODE_NEON
+	default y if S390
 
 config CRYPTO_LIB_SM3
 	tristate
 
 source "lib/crypto/tests/Kconfig"
diff --git a/lib/crypto/s390/sha3.h b/lib/crypto/s390/sha3.h
new file mode 100644
index 0000000000000..668e53da93d2c
--- /dev/null
+++ b/lib/crypto/s390/sha3.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SHA-3 optimized using the CP Assist for Cryptographic Functions (CPACF)
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <asm/cpacf.h>
+#include <linux/cpufeature.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha3);
+
+static void sha3_absorb_blocks(struct sha3_state *state, const u8 *data,
+			       size_t nblocks, size_t block_size)
+{
+	if (static_branch_likely(&have_sha3)) {
+		/*
+		 * Note that KIMD assumes little-endian order of the state
+		 * words.  sha3_state already uses that order, though, so
+		 * there's no need for a byteswap.
+		 */
+		switch (block_size) {
+		case SHA3_224_BLOCK_SIZE:
+			cpacf_kimd(CPACF_KIMD_SHA3_224, state,
+				   data, nblocks * block_size);
+			return;
+		case SHA3_256_BLOCK_SIZE:
+			/*
+			 * This case handles both SHA3-256 and SHAKE256, since
+			 * they have the same block size.
+			 */
+			cpacf_kimd(CPACF_KIMD_SHA3_256, state,
+				   data, nblocks * block_size);
+			return;
+		case SHA3_384_BLOCK_SIZE:
+			cpacf_kimd(CPACF_KIMD_SHA3_384, state,
+				   data, nblocks * block_size);
+			return;
+		case SHA3_512_BLOCK_SIZE:
+			cpacf_kimd(CPACF_KIMD_SHA3_512, state,
+				   data, nblocks * block_size);
+			return;
+		}
+	}
+	sha3_absorb_blocks_generic(state, data, nblocks, block_size);
+}
+
+static void sha3_keccakf(struct sha3_state *state)
+{
+	if (static_branch_likely(&have_sha3)) {
+		/*
+		 * Passing zeroes into any of CPACF_KIMD_SHA3_* gives the plain
+		 * Keccak-f permutation, which is what we want here.  Use
+		 * SHA3-512 since it has the smallest block size.
+		 */
+		static const u8 zeroes[SHA3_512_BLOCK_SIZE];
+
+		cpacf_kimd(CPACF_KIMD_SHA3_512, state, zeroes, sizeof(zeroes));
+	} else {
+		sha3_keccakf_generic(state);
+	}
+}
+
+#define sha3_mod_init_arch sha3_mod_init_arch
+static void sha3_mod_init_arch(void)
+{
+	int num_present = 0;
+	int num_possible = 0;
+
+	if (!cpu_have_feature(S390_CPU_FEATURE_MSA))
+		return;
+	/*
+	 * Since all the SHA-3 functions are in Message-Security-Assist
+	 * Extension 6, just treat them as all or nothing.  This way we need
+	 * only one static_key.
+	 */
+#define QUERY(opcode, func) \
+	({ num_present += !!cpacf_query_func(opcode, func); num_possible++; })
+	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_224);
+	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_256);
+	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_384);
+	QUERY(CPACF_KIMD, CPACF_KIMD_SHA3_512);
+#undef QUERY
+
+	if (num_present == num_possible)
+		static_branch_enable(&have_sha3);
+	else if (num_present != 0)
+		pr_warn("Unsupported combination of SHA-3 facilities\n");
+}
-- 
2.51.1.dirty

