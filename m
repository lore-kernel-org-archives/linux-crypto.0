Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4CB2D7DE9;
	Mon, 25 May 2026 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779734780; cv=none; b=CbiGNjnpOfAGf9hUXw4JXACMbpLU3VO2BmhtrQ2bAS/OljEMZ43rLfgOJKgEG9VrodMinnqVDRNUSw5x3kFoS+z1guFqrFhCmoJr1MEr+ds/JxhwLfLUgJCDSEsVi7q8byB1y37DkFvzoev2TMmvq++CQx2D59iYtvygC01tPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779734780; c=relaxed/simple;
	bh=2mmQHT116ViizH+iWfI/hWQTb00XosiwZl0mEAPk+zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc5/e7o5QUcVMAJCOCP4W9zOx3TywVByLCBD57G9PijPoDl8B8VQfwEpohhuoSG/JI6mbKsgyuZ+I3bdbj3g99K9lPDpkeGJKY31AE1nQNRw1ghe1bGHBOYM91M6ATx+6RmPNdG6+KHRO3Ot+rHrZdylP/FcTc79JMaEKNwvhNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAXgSVOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAXgSVOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701241F000E9;
	Mon, 25 May 2026 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779734774;
	bh=e/Igxs4pmyN2HsfgXMk12TzAgFEK58TuZSPR58CmFNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAXgSVOZinQ7nLnnPMg2wTS9nMdQskZzLP+pqfmhYCVoVy5n+h8pUhwFUsrQVJ7cd
	 qaCjLbtuYpwgziWHAqPLKndoHQIwnB9pDyWpl2aTrllLT83xHVA3JD3QCqVg+zfhe7
	 XoCNyZKk1LiBpjZk2ec2JJ+1o/1TNU9Tt8Ly3mOLg/NGXxVceP4/kKlO40Qdf5R5hF
	 hKj43EF2blysvkhbqzGaPvcV0VvZx8FI/LuAEQlECwGNS2Ih4XoXas/CuFkbRj9IUD
	 EfAlNt5/uoaXUgScB2rs2nB568s0fwWyzd5w3dlYjSodIUYxQzLJ3kb9xNq3zfjpaD
	 QUT3ydTTbsbAQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ryan Appel <ryan.appel.333@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/5] lib/crypto: xwing: Add support for X-Wing KEM
Date: Mon, 25 May 2026 13:44:02 -0500
Message-ID: <20260525184403.101818-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525184403.101818-1-ebiggers@kernel.org>
References: <20260525184403.101818-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for X-Wing, a general-purpose post-quantum/traditional
hybrid key encapsulation mechanism using X25519 and ML-KEM-768.  X-Wing
is the recommended KEM for new applications.  X-Wing is specified at
https://datatracker.ietf.org/doc/html/draft-connolly-cfrg-xwing-kem-10

This is a proof-of-concept that won't be merged until there's an
in-kernel user.  Potential users include in-kernel users of classical
key agreement schemes (Bluetooth, NVMe auth, WireGuard).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/libcrypto-asymmetric.rst |   7 +
 include/crypto/xwing.h                        |  84 +++++++
 lib/crypto/Kconfig                            |   9 +
 lib/crypto/Makefile                           |   5 +
 lib/crypto/xwing.c                            | 237 ++++++++++++++++++
 5 files changed, 342 insertions(+)
 create mode 100644 include/crypto/xwing.h
 create mode 100644 lib/crypto/xwing.c

diff --git a/Documentation/crypto/libcrypto-asymmetric.rst b/Documentation/crypto/libcrypto-asymmetric.rst
index 6e71c5ce823f..d44ee74f6a46 100644
--- a/Documentation/crypto/libcrypto-asymmetric.rst
+++ b/Documentation/crypto/libcrypto-asymmetric.rst
@@ -16,5 +16,12 @@ ML-KEM
 Support for the ML-KEM key encapsulation mechanism.
 
 This shall be used as part of a hybrid scheme such as X-Wing, not by itself.
 
 .. kernel-doc:: include/crypto/mlkem.h
+
+X-Wing
+------
+
+Support for the X-Wing key encapsulation mechanism.
+
+.. kernel-doc:: include/crypto/xwing.h
diff --git a/include/crypto/xwing.h b/include/crypto/xwing.h
new file mode 100644
index 000000000000..d1ad7b1e6596
--- /dev/null
+++ b/include/crypto/xwing.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2026 Google LLC
+ */
+
+/**
+ * DOC: X-Wing key encapsulation mechanism
+ *
+ * Implementation of X-Wing, a general-purpose post-quantum/traditional hybrid
+ * key encapsulation mechanism using X25519 and ML-KEM-768.  X-Wing is the
+ * recommended KEM for new applications.  X-Wing is specified at
+ * https://datatracker.ietf.org/doc/html/draft-connolly-cfrg-xwing-kem-10
+ */
+
+#ifndef _CRYPTO_XWING_H
+#define _CRYPTO_XWING_H
+
+#include <linux/types.h>
+
+#define XWING_SEED_BYTES 32 /* Length of seed for KeyGen */
+#define XWING_PUBLIC_KEY_BYTES 1216
+#define XWING_SECRET_KEY_BYTES 32
+#define XWING_ESEED_BYTES 64 /* Length of seed for Encaps */
+#define XWING_CIPHERTEXT_BYTES 1120
+#define XWING_SHARED_SECRET_BYTES 32
+
+/**
+ * xwing_keygen() - Generate an X-Wing key pair
+ * @pk: (output) The public key (encapsulation key)
+ * @sk: (output) The secret key (decapsulation key)
+ *
+ * Context: Might sleep
+ *
+ * Return: 0 on success, or -ENOMEM if out of memory.
+ */
+int xwing_keygen(u8 pk[XWING_PUBLIC_KEY_BYTES], u8 sk[XWING_SECRET_KEY_BYTES]);
+
+/**
+ * xwing_encaps() - Generate and encapsulate shared secret with X-Wing
+ * @ct: (output) The ciphertext
+ * @ss: (output) The generated shared secret
+ * @pk: The public key (encapsulation key)
+ *
+ * Context: Might sleep
+ *
+ * Return:
+ * * 0 on success
+ * * -EBADMSG if the public key is malformed
+ * * -ENOMEM if out of memory
+ */
+int xwing_encaps(u8 ct[XWING_CIPHERTEXT_BYTES],
+		 u8 ss[XWING_SHARED_SECRET_BYTES],
+		 const u8 pk[XWING_PUBLIC_KEY_BYTES]);
+
+/**
+ * xwing_decaps() - Decapsulate shared secret with X-Wing
+ * @ss: (output) The decapsulated shared secret
+ * @ct: The ciphertext
+ * @sk: The secret key (decapsulation key)
+ *
+ * Context: Might sleep
+ *
+ * Return:
+ * * 0 on success, including the implicit rejection cases where the ciphertext
+ *   is invalid and a randomized shared secret is returned
+ * * -EBADMSG if the secret key is malformed
+ * * -ENOMEM if out of memory
+ */
+int xwing_decaps(u8 ss[XWING_SHARED_SECRET_BYTES],
+		 const u8 ct[XWING_CIPHERTEXT_BYTES],
+		 const u8 sk[XWING_SECRET_KEY_BYTES]);
+
+#if IS_ENABLED(CONFIG_KUNIT)
+/* Functions taking explicit seeds, only for KUnit testing */
+int xwing_keygen_internal(u8 pk[XWING_PUBLIC_KEY_BYTES],
+			  u8 sk[XWING_SECRET_KEY_BYTES],
+			  const u8 seed[XWING_SEED_BYTES]);
+int xwing_encaps_internal(u8 ct[XWING_CIPHERTEXT_BYTES],
+			  u8 ss[XWING_SHARED_SECRET_BYTES],
+			  const u8 pk[XWING_PUBLIC_KEY_BYTES],
+			  const u8 eseed[XWING_ESEED_BYTES]);
+#endif /* CONFIG_KUNIT */
+
+#endif /* _CRYPTO_XWING_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index acaa64af4c6d..2ce1867eeb9e 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -285,5 +285,14 @@ config CRYPTO_LIB_SM3_ARCH
 	depends on CRYPTO_LIB_SM3 && !UML
 	default y if ARM64
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if X86_64
+
+config CRYPTO_LIB_XWING
+	tristate
+	select CRYPTO_LIB_CURVE25519
+	select CRYPTO_LIB_MLKEM
+	select CRYPTO_LIB_SHA3
+	help
+	  The X-Wing library functions.  Select this if your module uses any of
+	  the functions from <crypto/xwing.h>.
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 94cef4e574cd..a20ae074cbfa 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -384,10 +384,15 @@ libsm3-$(CONFIG_RISCV) += riscv/sm3-riscv64-zvksh-zvkb.o
 libsm3-$(CONFIG_X86) += x86/sm3-avx-asm_64.o
 endif # CONFIG_CRYPTO_LIB_SM3_ARCH
 
 ################################################################################
 
+obj-$(CONFIG_CRYPTO_LIB_XWING) += libxwing.o
+libxwing-y := xwing.o
+
+################################################################################
+
 obj-$(CONFIG_MPILIB) += mpi/
 
 obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
 
 # clean-files must be defined unconditionally
diff --git a/lib/crypto/xwing.c b/lib/crypto/xwing.c
new file mode 100644
index 000000000000..deffa46b900e
--- /dev/null
+++ b/lib/crypto/xwing.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * X-Wing key encapsulation mechanism
+ *
+ * See include/crypto/xwing.h for the documentation.
+ *
+ * Copyright 2026 Google LLC
+ */
+
+#include <crypto/curve25519.h>
+#include <crypto/mlkem.h>
+#include <crypto/sha3.h>
+#include <crypto/xwing.h>
+#include <kunit/visibility.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+/* pk = pk_mlkem || pk_x25519 */
+static_assert(XWING_PUBLIC_KEY_BYTES ==
+	      MLKEM768_PUBLIC_KEY_BYTES + CURVE25519_KEY_SIZE);
+
+/* sk = seed */
+static_assert(XWING_SECRET_KEY_BYTES == XWING_SEED_BYTES);
+
+/* ct = ct_mlkem || ct_x25519 */
+static_assert(XWING_CIPHERTEXT_BYTES ==
+	      MLKEM768_CIPHERTEXT_BYTES + CURVE25519_KEY_SIZE);
+
+/* expanded_sk = sk_mlkem || sk_x25519 || pk_mlkem || pk_x25519 */
+#define XWING_EXPANDED_SECRET_KEY_BYTES                    \
+	(MLKEM768_SECRET_KEY_BYTES + CURVE25519_KEY_SIZE + \
+	 MLKEM768_PUBLIC_KEY_BYTES + CURVE25519_KEY_SIZE)
+
+static int xwing_expand_sk(u8 expanded_sk[XWING_EXPANDED_SECRET_KEY_BYTES],
+			   const u8 sk[XWING_SECRET_KEY_BYTES])
+{
+	u8 *sk_mlkem = &expanded_sk[0];
+	u8 *sk_x25519 = &sk_mlkem[MLKEM768_SECRET_KEY_BYTES];
+	u8 *pk_mlkem = &sk_x25519[CURVE25519_KEY_SIZE];
+	u8 *pk_x25519 = &pk_mlkem[MLKEM768_PUBLIC_KEY_BYTES];
+	u8 seed_mlkem[MLKEM_SEED_BYTES];
+	struct shake_ctx shake;
+	int err;
+
+	shake256_init(&shake);
+	shake_update(&shake, sk, XWING_SECRET_KEY_BYTES);
+	shake_squeeze(&shake, seed_mlkem, sizeof(seed_mlkem));
+
+	err = mlkem768_keygen_internal(pk_mlkem, sk_mlkem, seed_mlkem);
+	if (err) /* can only be -ENOMEM */
+		goto out;
+	shake_squeeze(&shake, sk_x25519, CURVE25519_KEY_SIZE);
+	curve25519_clamp_secret(sk_x25519);
+	if (unlikely(!curve25519_generate_public(pk_x25519, sk_x25519)))
+		err = -EAGAIN;
+out:
+	shake_zeroize_ctx(&shake);
+	memzero_explicit(seed_mlkem, sizeof(seed_mlkem));
+	return err;
+}
+
+VISIBLE_IF_KUNIT int xwing_keygen_internal(u8 pk[XWING_PUBLIC_KEY_BYTES],
+					   u8 sk[XWING_SECRET_KEY_BYTES],
+					   const u8 seed[XWING_SEED_BYTES])
+{
+	u8 *expanded_sk __free(kfree_sensitive) =
+		kmalloc(XWING_EXPANDED_SECRET_KEY_BYTES, GFP_KERNEL);
+	int err;
+
+	if (!expanded_sk)
+		return -ENOMEM;
+
+	err = xwing_expand_sk(expanded_sk, seed);
+	if (err)
+		return err;
+	/* pk = pk_mlkem || pk_x25519 */
+	memcpy(pk,
+	       &expanded_sk[MLKEM768_SECRET_KEY_BYTES + CURVE25519_KEY_SIZE],
+	       XWING_PUBLIC_KEY_BYTES);
+	/* sk = seed */
+	memcpy(sk, seed, XWING_SECRET_KEY_BYTES);
+	return 0;
+}
+EXPORT_SYMBOL_IF_KUNIT(xwing_keygen_internal);
+
+int xwing_keygen(u8 pk[XWING_PUBLIC_KEY_BYTES], u8 sk[XWING_SECRET_KEY_BYTES])
+{
+	u8 seed[XWING_SEED_BYTES];
+	int err;
+
+	do {
+		get_random_bytes(seed, sizeof(seed));
+		err = xwing_keygen_internal(pk, sk, seed);
+	} while (err == -EAGAIN); /* curve25519_null_point case */
+	memzero_explicit(seed, sizeof(seed));
+	return err;
+}
+EXPORT_SYMBOL_GPL(xwing_keygen);
+
+static void xwing_combine(u8 ss[XWING_SHARED_SECRET_BYTES],
+			  const u8 ss_mlkem[MLKEM_SHARED_SECRET_BYTES],
+			  const u8 ss_x25519[CURVE25519_KEY_SIZE],
+			  const u8 ct_x25519[CURVE25519_KEY_SIZE],
+			  const u8 pk_x25519[CURVE25519_KEY_SIZE])
+{
+	static const u8 xwing_label[6] = { 0x5c, 0x2e, 0x2f, 0x2f, 0x5e, 0x5c };
+	struct sha3_ctx ctx;
+
+	sha3_256_init(&ctx);
+	sha3_update(&ctx, ss_mlkem, MLKEM_SHARED_SECRET_BYTES);
+	sha3_update(&ctx, ss_x25519, CURVE25519_KEY_SIZE);
+	sha3_update(&ctx, ct_x25519, CURVE25519_KEY_SIZE);
+	sha3_update(&ctx, pk_x25519, CURVE25519_KEY_SIZE);
+	sha3_update(&ctx, xwing_label, sizeof(xwing_label));
+	sha3_final(&ctx, ss);
+}
+
+VISIBLE_IF_KUNIT int xwing_encaps_internal(u8 ct[XWING_CIPHERTEXT_BYTES],
+					   u8 ss[XWING_SHARED_SECRET_BYTES],
+					   const u8 pk[XWING_PUBLIC_KEY_BYTES],
+					   const u8 eseed[XWING_ESEED_BYTES])
+{
+	const u8 *pk_mlkem = &pk[0];
+	const u8 *pk_x25519 = &pk[MLKEM768_PUBLIC_KEY_BYTES];
+	const u8 *eseed_mlkem = &eseed[0];
+	const u8 *eseed_x25519 = &eseed[MLKEM_ESEED_BYTES];
+	u8 eph_sk_x25519[CURVE25519_KEY_SIZE];
+	u8 *ct_mlkem = &ct[0];
+	u8 *ct_x25519 = &ct[MLKEM768_CIPHERTEXT_BYTES];
+	u8 ss_mlkem[MLKEM_SHARED_SECRET_BYTES];
+	u8 ss_x25519[CURVE25519_KEY_SIZE];
+	int err;
+
+	err = mlkem768_encaps_internal(ct_mlkem, ss_mlkem, pk_mlkem,
+				       eseed_mlkem);
+	if (err)
+		goto out;
+	memcpy(eph_sk_x25519, eseed_x25519, CURVE25519_KEY_SIZE);
+	curve25519_clamp_secret(eph_sk_x25519);
+	if (!curve25519_generate_public(ct_x25519, eph_sk_x25519)) {
+		err = -EAGAIN;
+		goto out;
+	}
+	if (!curve25519(ss_x25519, eph_sk_x25519, pk_x25519)) {
+		err = -EBADMSG;
+		goto out;
+	}
+	xwing_combine(ss, ss_mlkem, ss_x25519, ct_x25519, pk_x25519);
+	err = 0;
+out:
+	if (err) {
+		get_random_bytes(ct, XWING_CIPHERTEXT_BYTES);
+		get_random_bytes(ss, XWING_SHARED_SECRET_BYTES);
+	}
+	memzero_explicit(eph_sk_x25519, sizeof(eph_sk_x25519));
+	memzero_explicit(ss_mlkem, sizeof(ss_mlkem));
+	memzero_explicit(ss_x25519, sizeof(ss_x25519));
+	return err;
+}
+EXPORT_SYMBOL_IF_KUNIT(xwing_encaps_internal);
+
+int xwing_encaps(u8 ct[XWING_CIPHERTEXT_BYTES],
+		 u8 ss[XWING_SHARED_SECRET_BYTES],
+		 const u8 pk[XWING_PUBLIC_KEY_BYTES])
+{
+	u8 eseed[XWING_ESEED_BYTES];
+	int err;
+
+	do {
+		get_random_bytes(eseed, sizeof(eseed));
+		err = xwing_encaps_internal(ct, ss, pk, eseed);
+	} while (err == -EAGAIN); /* curve25519_null_point case */
+	memzero_explicit(eseed, sizeof(eseed));
+	return err;
+}
+EXPORT_SYMBOL_GPL(xwing_encaps);
+
+int xwing_decaps(u8 ss[XWING_SHARED_SECRET_BYTES],
+		 const u8 ct[XWING_CIPHERTEXT_BYTES],
+		 const u8 sk[XWING_SECRET_KEY_BYTES])
+{
+	u8 *expanded_sk __free(kfree_sensitive) =
+		kmalloc(XWING_EXPANDED_SECRET_KEY_BYTES, GFP_KERNEL);
+	u8 *sk_mlkem, *sk_x25519, *pk_mlkem, *pk_x25519;
+	const u8 *ct_mlkem = &ct[0];
+	const u8 *ct_x25519 = &ct[MLKEM768_CIPHERTEXT_BYTES];
+	u8 ss_mlkem[MLKEM_SHARED_SECRET_BYTES];
+	u8 ss_x25519[CURVE25519_KEY_SIZE];
+	int err;
+
+	if (!expanded_sk) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = xwing_expand_sk(expanded_sk, sk);
+	if (err) {
+		if (err == -EAGAIN) /* curve25519_null_point case */
+			err = -EBADMSG;
+		goto out;
+	}
+	sk_mlkem = &expanded_sk[0];
+	sk_x25519 = &sk_mlkem[MLKEM768_SECRET_KEY_BYTES];
+	pk_mlkem = &sk_x25519[CURVE25519_KEY_SIZE];
+	pk_x25519 = &pk_mlkem[MLKEM768_PUBLIC_KEY_BYTES];
+
+	err = mlkem768_decaps(ss_mlkem, ct_mlkem, sk_mlkem);
+	if (err) {
+		/*
+		 * This is either -ENOMEM, or -EBADMSG for a malformed secret
+		 * key.  This case is *not* reached if the ciphertext is
+		 * invalid, as implicit rejection is used.
+		 */
+		goto out;
+	}
+	if (!curve25519(ss_x25519, sk_x25519, ct_x25519)) {
+		/*
+		 * ss_x25519 is curve25519_null_point, which can happen if the
+		 * ciphertext is invalid.  In this case the correct behavior is
+		 * to continue anyway and implicitly reject.
+		 */
+	}
+
+	xwing_combine(ss, ss_mlkem, ss_x25519, ct_x25519, pk_x25519);
+	err = 0;
+out:
+	if (err)
+		get_random_bytes(ss, XWING_SHARED_SECRET_BYTES);
+	memzero_explicit(ss_mlkem, sizeof(ss_mlkem));
+	memzero_explicit(ss_x25519, sizeof(ss_x25519));
+	return err;
+}
+EXPORT_SYMBOL_GPL(xwing_decaps);
+
+MODULE_DESCRIPTION("X-Wing key encapsulation mechanism");
+MODULE_IMPORT_NS("CRYPTO_INTERNAL");
+MODULE_LICENSE("GPL");
-- 
2.54.0

