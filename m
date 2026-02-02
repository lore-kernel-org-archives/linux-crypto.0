Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A722882A8;
	Mon,  2 Feb 2026 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043853; cv=none; b=cpxQyIm29vM1kv6sCfQbm9roiKmDjUbw8lUrsLH57nsuqP6wXamaYSlnMzKAuX6hMMGTZsdcOZGKoLNCv7cto+cYCunGVVACSBv+QwKrJ36Wf12qMq2xdIZzHZJ8q6aM2tSN3LrNLXOcaST4eixO3usTyxTfGFV058Zj7P2joo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043853; c=relaxed/simple;
	bh=hsg3J9WRKm4HHHkK8PrnwK6HM3+zV67+MOtj1aeGzp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkQCwL9JGI1dQrdt6yv6UU20yQ2TctAah067au8GKZUJHEA9AS0nAo7w1ASyJ/7VgjreoyZb4vXLOw6IFjiSJXw95cJt2VHfadcOWxxyceS/n7jZe9yseWR8XN15QphlkIdB+s3BCRAhZ2E8dRSdu+qUIHyXjX1ABimI5DF4W/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=JaBfGyzU; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=OnMX2lzL; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="JaBfGyzU";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="OnMX2lzL"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770043671; bh=hwbyeP4penQ0j6vlDk3zJuy
	+ksLS8NFxf0SWco3IBGs=; b=JaBfGyzUD49XhZFdC6neZaxXFZYcnP04lgzw9nKn97Cr8qzSeg
	sXO16qYsr6gJvbvL1NZ5bOO2iQkciuygxZNxjASQ69/Cery1ojOKb/O29By/+2iBsQAW17g/6f1
	9KBIUXXOvRfJBc2X5H8KW9kCT8926Bcrbcx/lfsNdxM5kVACmjp5ZuAeoqTuTr1RXc4KvG2rdUH
	xX31KLvFQHkqvEOaxw0WR7mKk4l2070Wi5e8WGR47ZT3rB1wO4tvAupenBrkjwfsSVUkzG4U/Zh
	fQv2VfZGV2BTT1USw6XRpVNNBQAdUs3NoqTcXKPBt7O4rF1Eeuu0BS3AAoNSJYvSJsQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770043671; bh=hwbyeP4penQ0j6vlDk3zJuy
	+ksLS8NFxf0SWco3IBGs=; b=OnMX2lzLI02D78D0F6LA6MS9tiEVE2O76PzxYnzMxZAuhY+/JA
	6XSkkzf8tX2LXmmDZDzaZChLzNdLRKo+51Bw==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org
Cc: ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	vadim.fedorenko@linux.dev,
	song@kernel.org,
	yatsenko@meta.com,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	haoluo@google.com,
	jolsa@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	yonghong.song@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v7 4/4] selftests/bpf: Add tests for signature verification kfuncs
Date: Mon,  2 Feb 2026 09:47:49 -0500
Message-ID: <20260202144749.22932-5-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202144749.22932-1-git@danielhodges.dev>
References: <20260202144749.22932-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tests for the signature verification kfuncs:

1. test_ecdsa_verify_valid_signature: Verifies that a valid ECDSA
   signature over a known message hash is correctly verified using
   the P-256 curve with a test vector.

2. test_ecdsa_verify_invalid_signature: Verifies that an invalid
   signature (with modified r component) is correctly rejected.

3. test_ecdsa_size_queries: Tests the bpf_sig_keysize(),
   bpf_sig_digestsize(), and bpf_sig_maxsize() kfuncs to ensure
   they return valid positive values for a P-256 ECDSA context.

4. test_ecdsa_on_hash_ctx: Tests that calling bpf_sig_verify on
   a hash context fails with -EINVAL due to type mismatch.

5. test_ecdsa_keysize_on_hash_ctx: Tests that calling bpf_sig_keysize
   on a hash context fails with -EINVAL due to type mismatch.

6. test_ecdsa_zero_len_msg: Tests that zero-length message is rejected.

7. test_ecdsa_zero_len_sig: Tests that zero-length signature is rejected.

The test uses the p1363(ecdsa-nist-p256) algorithm with a known
NIST P-256 test vector for reliable and reproducible testing.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   4 +
 .../selftests/bpf/prog_tests/sig_verify.c     | 163 ++++++++++
 .../selftests/bpf/progs/crypto_common.h       |   6 +
 .../testing/selftests/bpf/progs/sig_verify.c  | 286 ++++++++++++++++++
 5 files changed, 461 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sig_verify.c
 create mode 100644 tools/testing/selftests/bpf/progs/sig_verify.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d23ea38b606f..e297cc18c5f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4719,7 +4719,9 @@ F:	crypto/bpf_crypto_skcipher.c
 F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
 F:	tools/testing/selftests/bpf/prog_tests/crypto_hash.c
+F:	tools/testing/selftests/bpf/prog_tests/sig_verify.c
 F:	tools/testing/selftests/bpf/progs/crypto_hash.c
+F:	tools/testing/selftests/bpf/progs/sig_verify.c
 
 BPF [DOCUMENTATION] (Related to Standardization)
 R:	David Vernet <void@manifault.com>
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 814804f71780..6db8b648cdd8 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -21,6 +21,10 @@ CONFIG_CRYPTO_USER_API_SKCIPHER=y
 CONFIG_CRYPTO_SKCIPHER=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_AES=y
+CONFIG_CRYPTO_SIG=y
+CONFIG_CRYPTO_SIG2=y
+CONFIG_CRYPTO_ECDSA=y
+CONFIG_CRYPTO_ECRDSA=y
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_BTF=y
 CONFIG_DEBUG_INFO_DWARF4=y
diff --git a/tools/testing/selftests/bpf/prog_tests/sig_verify.c b/tools/testing/selftests/bpf/prog_tests/sig_verify.c
new file mode 100644
index 000000000000..f682fc3c8595
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sig_verify.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include "sig_verify.skel.h"
+
+static void test_ecdsa_verify_valid_signature(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_verify_valid);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_verify_valid");
+	ASSERT_EQ(skel->data->ctx_create_status, 0, "ctx_create_status");
+	ASSERT_EQ(skel->data->verify_result, 0, "verify_valid_signature");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_verify_invalid_signature(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_verify_invalid);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_verify_invalid");
+	ASSERT_NEQ(skel->data->verify_invalid_result, 0, "verify_invalid_signature_rejected");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_size_queries(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_size_queries);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_size_queries");
+	ASSERT_EQ(skel->data->ctx_create_status, 0, "ctx_create_status");
+	/* P-256 key size is 256 bits = 32 bytes */
+	ASSERT_GT(skel->data->keysize_result, 0, "keysize_positive");
+	/* P-256 digest size is 32 bytes (SHA-256) */
+	ASSERT_GT(skel->data->digestsize_result, 0, "digestsize_positive");
+	/* P-256 max signature size is 64 bytes (r||s format) */
+	ASSERT_GT(skel->data->maxsize_result, 0, "maxsize_positive");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_on_hash_ctx(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_on_hash_ctx);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_on_hash_ctx");
+	ASSERT_EQ(skel->data->ecdsa_on_hash_ctx_status, 0, "ecdsa_on_hash_ctx_rejected");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_keysize_on_hash_ctx(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_keysize_on_hash_ctx);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_keysize_on_hash_ctx");
+	ASSERT_EQ(skel->data->ecdsa_keysize_on_hash_status, 0, "ecdsa_keysize_on_hash_rejected");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_zero_len_msg(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_zero_len_msg);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_zero_len_msg");
+	ASSERT_EQ(skel->data->ecdsa_zero_msg_status, 0, "zero_len_msg_rejected");
+
+	sig_verify__destroy(skel);
+}
+
+static void test_ecdsa_zero_len_sig(void)
+{
+	struct sig_verify *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = sig_verify__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "sig_verify__open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_ecdsa_zero_len_sig);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_ecdsa_zero_len_sig");
+	ASSERT_EQ(skel->data->ecdsa_zero_sig_status, 0, "zero_len_sig_rejected");
+
+	sig_verify__destroy(skel);
+}
+
+void test_sig_verify(void)
+{
+	if (test__start_subtest("verify_valid_signature"))
+		test_ecdsa_verify_valid_signature();
+	if (test__start_subtest("verify_invalid_signature"))
+		test_ecdsa_verify_invalid_signature();
+	if (test__start_subtest("size_queries"))
+		test_ecdsa_size_queries();
+	if (test__start_subtest("ecdsa_on_hash_ctx"))
+		test_ecdsa_on_hash_ctx();
+	if (test__start_subtest("ecdsa_keysize_on_hash_ctx"))
+		test_ecdsa_keysize_on_hash_ctx();
+	if (test__start_subtest("zero_len_msg"))
+		test_ecdsa_zero_len_msg();
+	if (test__start_subtest("zero_len_sig"))
+		test_ecdsa_zero_len_sig();
+}
diff --git a/tools/testing/selftests/bpf/progs/crypto_common.h b/tools/testing/selftests/bpf/progs/crypto_common.h
index 2f04f08f890b..3849083f2d23 100644
--- a/tools/testing/selftests/bpf/progs/crypto_common.h
+++ b/tools/testing/selftests/bpf/progs/crypto_common.h
@@ -17,6 +17,12 @@ int bpf_crypto_decrypt(struct bpf_crypto_ctx *ctx, const struct bpf_dynptr *src,
 		       const struct bpf_dynptr *dst, const struct bpf_dynptr *iv) __ksym;
 int bpf_crypto_hash(struct bpf_crypto_ctx *ctx, const struct bpf_dynptr *data,
 		    const struct bpf_dynptr *out) __ksym;
+int bpf_sig_verify(struct bpf_crypto_ctx *ctx,
+		     const struct bpf_dynptr *message,
+		     const struct bpf_dynptr *signature) __ksym;
+int bpf_sig_keysize(struct bpf_crypto_ctx *ctx) __ksym;
+int bpf_sig_digestsize(struct bpf_crypto_ctx *ctx) __ksym;
+int bpf_sig_maxsize(struct bpf_crypto_ctx *ctx) __ksym;
 
 struct __crypto_ctx_value {
 	struct bpf_crypto_ctx __kptr * ctx;
diff --git a/tools/testing/selftests/bpf/progs/sig_verify.c b/tools/testing/selftests/bpf/progs/sig_verify.c
new file mode 100644
index 000000000000..27488404444d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/sig_verify.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+#include "crypto_common.h"
+
+/* NIST P-256 test vector
+ * This is a known valid ECDSA signature for testing purposes
+ */
+
+/* Public key in uncompressed format: 0x04 || x || y (65 bytes) */
+unsigned char pubkey_p256[65] = {
+	0x04, /* Uncompressed point indicator */
+	/* X coordinate (32 bytes) */
+	0x60, 0xfe, 0xd4, 0xba, 0x25, 0x5a, 0x9d, 0x31,
+	0xc9, 0x61, 0xeb, 0x74, 0xc6, 0x35, 0x6d, 0x68,
+	0xc0, 0x49, 0xb8, 0x92, 0x3b, 0x61, 0xfa, 0x6c,
+	0xe6, 0x69, 0x62, 0x2e, 0x60, 0xf2, 0x9f, 0xb6,
+	/* Y coordinate (32 bytes) */
+	0x79, 0x03, 0xfe, 0x10, 0x08, 0xb8, 0xbc, 0x99,
+	0xa4, 0x1a, 0xe9, 0xe9, 0x56, 0x28, 0xbc, 0x64,
+	0xf2, 0xf1, 0xb2, 0x0c, 0x2d, 0x7e, 0x9f, 0x51,
+	0x77, 0xa3, 0xc2, 0x94, 0xd4, 0x46, 0x22, 0x99
+};
+
+/* Message hash (32 bytes) - SHA-256 of "sample" */
+unsigned char message_hash[32] = {
+	0xaf, 0x2b, 0xdb, 0xe1, 0xaa, 0x9b, 0x6e, 0xc1,
+	0xe2, 0xad, 0xe1, 0xd6, 0x94, 0xf4, 0x1f, 0xc7,
+	0x1a, 0x83, 0x1d, 0x02, 0x68, 0xe9, 0x89, 0x15,
+	0x62, 0x11, 0x3d, 0x8a, 0x62, 0xad, 0xd1, 0xbf
+};
+
+/* Valid signature r || s (64 bytes) */
+unsigned char valid_signature[64] = {
+	/* r component (32 bytes) */
+	0xef, 0xd4, 0x8b, 0x2a, 0xac, 0xb6, 0xa8, 0xfd,
+	0x11, 0x40, 0xdd, 0x9c, 0xd4, 0x5e, 0x81, 0xd6,
+	0x9d, 0x2c, 0x87, 0x7b, 0x56, 0xaa, 0xf9, 0x91,
+	0xc3, 0x4d, 0x0e, 0xa8, 0x4e, 0xaf, 0x37, 0x16,
+	/* s component (32 bytes) */
+	0xf7, 0xcb, 0x1c, 0x94, 0x2d, 0x65, 0x7c, 0x41,
+	0xd4, 0x36, 0xc7, 0xa1, 0xb6, 0xe2, 0x9f, 0x65,
+	0xf3, 0xe9, 0x00, 0xdb, 0xb9, 0xaf, 0xf4, 0x06,
+	0x4d, 0xc4, 0xab, 0x2f, 0x84, 0x3a, 0xcd, 0xa8
+};
+
+/* Invalid signature (modified r component) for negative test */
+unsigned char invalid_signature[64] = {
+	/* r component (32 bytes) - first byte modified */
+	0xff, 0xd4, 0x8b, 0x2a, 0xac, 0xb6, 0xa8, 0xfd,
+	0x11, 0x40, 0xdd, 0x9c, 0xd4, 0x5e, 0x81, 0xd6,
+	0x9d, 0x2c, 0x87, 0x7b, 0x56, 0xaa, 0xf9, 0x91,
+	0xc3, 0x4d, 0x0e, 0xa8, 0x4e, 0xaf, 0x37, 0x16,
+	/* s component (32 bytes) */
+	0xf7, 0xcb, 0x1c, 0x94, 0x2d, 0x65, 0x7c, 0x41,
+	0xd4, 0x36, 0xc7, 0xa1, 0xb6, 0xe2, 0x9f, 0x65,
+	0xf3, 0xe9, 0x00, 0xdb, 0xb9, 0xaf, 0xf4, 0x06,
+	0x4d, 0xc4, 0xab, 0x2f, 0x84, 0x3a, 0xcd, 0xa8
+};
+
+/* Test results */
+int verify_result = -1;
+int verify_invalid_result = -1;
+int ctx_create_status = -1;
+int keysize_result = -1;
+int digestsize_result = -1;
+int maxsize_result = -1;
+int ecdsa_on_hash_ctx_status = -1;
+int ecdsa_keysize_on_hash_status = -1;
+int ecdsa_zero_msg_status = -1;
+int ecdsa_zero_sig_status = -1;
+
+SEC("syscall")
+int test_ecdsa_verify_valid(void *ctx)
+{
+	struct bpf_crypto_ctx *ecdsa_ctx;
+	struct bpf_crypto_params params = {
+		.type = "sig",
+		.algo = "p1363(ecdsa-nist-p256)",
+		.key_len = sizeof(pubkey_p256),
+	};
+	struct bpf_dynptr msg_ptr, sig_ptr;
+	int err = 0;
+
+	__builtin_memcpy(params.key, pubkey_p256, sizeof(pubkey_p256));
+
+	ecdsa_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!ecdsa_ctx) {
+		ctx_create_status = err;
+		return 0;
+	}
+	ctx_create_status = 0;
+
+	bpf_dynptr_from_mem(message_hash, sizeof(message_hash), 0, &msg_ptr);
+	bpf_dynptr_from_mem(valid_signature, sizeof(valid_signature), 0, &sig_ptr);
+
+	verify_result = bpf_sig_verify(ecdsa_ctx, &msg_ptr, &sig_ptr);
+
+	bpf_crypto_ctx_release(ecdsa_ctx);
+
+	return 0;
+}
+
+SEC("syscall")
+int test_ecdsa_verify_invalid(void *ctx)
+{
+	struct bpf_crypto_ctx *ecdsa_ctx;
+	struct bpf_crypto_params params = {
+		.type = "sig",
+		.algo = "p1363(ecdsa-nist-p256)",
+		.key_len = sizeof(pubkey_p256),
+	};
+	struct bpf_dynptr msg_ptr, sig_ptr;
+	int err = 0;
+
+	__builtin_memcpy(params.key, pubkey_p256, sizeof(pubkey_p256));
+
+	ecdsa_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!ecdsa_ctx)
+		return 0;
+
+	bpf_dynptr_from_mem(message_hash, sizeof(message_hash), 0, &msg_ptr);
+	bpf_dynptr_from_mem(invalid_signature, sizeof(invalid_signature), 0, &sig_ptr);
+
+	verify_invalid_result = bpf_sig_verify(ecdsa_ctx, &msg_ptr, &sig_ptr);
+
+	bpf_crypto_ctx_release(ecdsa_ctx);
+
+	return 0;
+}
+
+SEC("syscall")
+int test_ecdsa_size_queries(void *ctx)
+{
+	struct bpf_crypto_ctx *ecdsa_ctx;
+	struct bpf_crypto_params params = {
+		.type = "sig",
+		.algo = "p1363(ecdsa-nist-p256)",
+		.key_len = sizeof(pubkey_p256),
+	};
+	int err = 0;
+
+	__builtin_memcpy(params.key, pubkey_p256, sizeof(pubkey_p256));
+
+	ecdsa_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!ecdsa_ctx) {
+		ctx_create_status = err;
+		return 0;
+	}
+	ctx_create_status = 0;
+
+	keysize_result = bpf_sig_keysize(ecdsa_ctx);
+	digestsize_result = bpf_sig_digestsize(ecdsa_ctx);
+	maxsize_result = bpf_sig_maxsize(ecdsa_ctx);
+
+	bpf_crypto_ctx_release(ecdsa_ctx);
+
+	return 0;
+}
+
+/* Test that calling bpf_sig_verify on hash context fails with type mismatch */
+SEC("syscall")
+int test_ecdsa_on_hash_ctx(void *ctx)
+{
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha256",
+		.key_len = 0,
+	};
+	struct bpf_dynptr msg_ptr, sig_ptr;
+	int err = 0;
+	int ret;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		ecdsa_on_hash_ctx_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(message_hash, sizeof(message_hash), 0, &msg_ptr);
+	bpf_dynptr_from_mem(valid_signature, sizeof(valid_signature), 0, &sig_ptr);
+
+	ret = bpf_sig_verify(hash_ctx, &msg_ptr, &sig_ptr);
+	/* Expected: should fail with -EINVAL (-22) due to type_id mismatch */
+	ecdsa_on_hash_ctx_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+/* Test that calling bpf_sig_keysize on hash context fails with type mismatch */
+SEC("syscall")
+int test_ecdsa_keysize_on_hash_ctx(void *ctx)
+{
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha256",
+		.key_len = 0,
+	};
+	int err = 0;
+	int ret;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		ecdsa_keysize_on_hash_status = err;
+		return 0;
+	}
+
+	ret = bpf_sig_keysize(hash_ctx);
+	/* Expected: should fail with -EINVAL (-22) due to type_id mismatch */
+	ecdsa_keysize_on_hash_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+/* Test that bpf_sig_verify with zero-length message fails */
+SEC("syscall")
+int test_ecdsa_zero_len_msg(void *ctx)
+{
+	struct bpf_crypto_ctx *ecdsa_ctx;
+	struct bpf_crypto_params params = {
+		.type = "sig",
+		.algo = "p1363(ecdsa-nist-p256)",
+		.key_len = sizeof(pubkey_p256),
+	};
+	struct bpf_dynptr msg_ptr, sig_ptr;
+	int err = 0;
+	int ret;
+
+	__builtin_memcpy(params.key, pubkey_p256, sizeof(pubkey_p256));
+
+	ecdsa_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!ecdsa_ctx) {
+		ecdsa_zero_msg_status = err;
+		return 0;
+	}
+
+	/* Zero-length message */
+	bpf_dynptr_from_mem(message_hash, 0, 0, &msg_ptr);
+	bpf_dynptr_from_mem(valid_signature, sizeof(valid_signature), 0, &sig_ptr);
+
+	ret = bpf_sig_verify(ecdsa_ctx, &msg_ptr, &sig_ptr);
+	/* Expected: should fail with -EINVAL (-22) */
+	ecdsa_zero_msg_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(ecdsa_ctx);
+	return 0;
+}
+
+/* Test that bpf_sig_verify with zero-length signature fails */
+SEC("syscall")
+int test_ecdsa_zero_len_sig(void *ctx)
+{
+	struct bpf_crypto_ctx *ecdsa_ctx;
+	struct bpf_crypto_params params = {
+		.type = "sig",
+		.algo = "p1363(ecdsa-nist-p256)",
+		.key_len = sizeof(pubkey_p256),
+	};
+	struct bpf_dynptr msg_ptr, sig_ptr;
+	int err = 0;
+	int ret;
+
+	__builtin_memcpy(params.key, pubkey_p256, sizeof(pubkey_p256));
+
+	ecdsa_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!ecdsa_ctx) {
+		ecdsa_zero_sig_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(message_hash, sizeof(message_hash), 0, &msg_ptr);
+	/* Zero-length signature */
+	bpf_dynptr_from_mem(valid_signature, 0, 0, &sig_ptr);
+
+	ret = bpf_sig_verify(ecdsa_ctx, &msg_ptr, &sig_ptr);
+	/* Expected: should fail with -EINVAL (-22) */
+	ecdsa_zero_sig_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(ecdsa_ctx);
+	return 0;
+}
+
+char __license[] SEC("license") = "GPL";
-- 
2.52.0

