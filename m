Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F5D23ABBF;
	Sat, 24 Jan 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769276661; cv=none; b=C6835H23Y88DUBB+NQFmUJnoOQSgBdjvAgolukHEu2rILS8w/c632nMRll4qNti7zoc80i4MGOYsOwBL3Z31bGOVx82MqHpTaDxBhZeIgTS+9LTKD8rD6WiqB4CHeJ3tJXqqbp81Js2FjymI8D5pM+rxq/d2NCAanHLNvm7PNuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769276661; c=relaxed/simple;
	bh=P9IUCTKEE+qNa5rg7jIPSA2K1Rc09vA1I4C1mVK4XKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETYgVUnCj07SucQwQGaAI0qPmOXa00PbovktQIZHGNLt/6fc7tQhrTolpoN2fJ7RlCG+u+n7XDXMJ1knWgcOZcbK0Y5S5Lkokgt3Cv9Y/IegRkyWr4XMwqJnbX9N0QSCJTc/4LPXHRFzBvUtDq6qHubV8AAOi11IRxXTkC+HNUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=DlSKyPuX; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=o7uZmJlF; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="DlSKyPuX";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="o7uZmJlF"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1769276631; bh=HiUwtWr/NEua2FMfQ76RjXF
	bXYGP1MZ5nYen0JOWZfg=; b=DlSKyPuXrJPVB96tJF7hX4BLbDAUalfHR94Gsfmg3diWoRzK75
	JhOpU+ux/tkPHPeTgZDGIRU9sY2AqwyeYTYId76oKKpWlNmZtWczy//l/bX5GiH+AseAh6g/0kD
	95JGu8QSwOfnDz1yusswhhtJykAGXet7UxMX3kg3X9YnhLCz/PR1FwGOZILXW76tQrvoT5imFdg
	osK0hiwd7S3kPdr4KZwdrHqOaikkxhcAcvmjczIeCTMpc9043+e45FiRG10sCKoz0Gl6Vsqlz0q
	V2y1PdlsdtvoS0In4E1bNPlAqgej2W4IA2mPAvMFbkPt4Wq2kv9bKSca79n2aNt8+Bw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1769276631; bh=HiUwtWr/NEua2FMfQ76RjXF
	bXYGP1MZ5nYen0JOWZfg=; b=o7uZmJlFz14CQbY8CVfVfCSIHBP2DGvXvFXkyt0GcuEp28GOWo
	QucIponqYhvVCpi6RJn+2JWl3t8UHb1+hhCw==;
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
Subject: [PATCH bpf-next v6 2/4] selftests/bpf: Add tests for bpf_crypto_hash kfunc
Date: Sat, 24 Jan 2026 12:43:47 -0500
Message-ID: <20260124174349.16861-3-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260124174349.16861-1-git@danielhodges.dev>
References: <20260124174349.16861-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add selftests to validate the bpf_crypto_hash works properly. The tests
verify both correct functionality and proper error handling.

Test Data:
All tests use the well-known NIST test vector input "abc" and validate
against the standardized expected outputs for each algorithm. This ensures
the BPF kfunc wrappers correctly delegate to the kernel crypto library.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/crypto_hash.c    | 210 ++++++++++++++++
 .../selftests/bpf/progs/crypto_common.h       |   2 +
 .../testing/selftests/bpf/progs/crypto_hash.c | 231 ++++++++++++++++++
 5 files changed, 447 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/crypto_hash.c
 create mode 100644 tools/testing/selftests/bpf/progs/crypto_hash.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e9b369acd1c..9602b6216ab9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4717,6 +4717,8 @@ F:	crypto/bpf_crypto_shash.c
 F:	crypto/bpf_crypto_skcipher.c
 F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
+F:	tools/testing/selftests/bpf/prog_tests/crypto_hash.c
+F:	tools/testing/selftests/bpf/progs/crypto_hash.c
 
 BPF [DOCUMENTATION] (Related to Standardization)
 R:	David Vernet <void@manifault.com>
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 558839e3c185..814804f71780 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -13,6 +13,8 @@ CONFIG_BPF_SYSCALL=y
 CONFIG_CGROUP_BPF=y
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA256=y
+CONFIG_CRYPTO_SHA512=y
+CONFIG_CRYPTO_HASH2=y
 CONFIG_CRYPTO_USER_API=y
 CONFIG_CRYPTO_USER_API_HASH=y
 CONFIG_CRYPTO_USER_API_SKCIPHER=y
diff --git a/tools/testing/selftests/bpf/prog_tests/crypto_hash.c b/tools/testing/selftests/bpf/prog_tests/crypto_hash.c
new file mode 100644
index 000000000000..0c78b5f46c9c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/crypto_hash.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include <errno.h>
+#include "crypto_hash.skel.h"
+
+/* NIST test vectors for SHA-256("abc") */
+static const unsigned char expected_sha256[32] = {
+	0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea,
+	0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
+	0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c,
+	0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad
+};
+
+/* NIST test vectors for SHA-384("abc") */
+static const unsigned char expected_sha384[48] = {
+	0xcb, 0x00, 0x75, 0x3f, 0x45, 0xa3, 0x5e, 0x8b,
+	0xb5, 0xa0, 0x3d, 0x69, 0x9a, 0xc6, 0x50, 0x07,
+	0x27, 0x2c, 0x32, 0xab, 0x0e, 0xde, 0xd1, 0x63,
+	0x1a, 0x8b, 0x60, 0x5a, 0x43, 0xff, 0x5b, 0xed,
+	0x80, 0x86, 0x07, 0x2b, 0xa1, 0xe7, 0xcc, 0x23,
+	0x58, 0xba, 0xec, 0xa1, 0x34, 0xc8, 0x25, 0xa7
+};
+
+/* NIST test vectors for SHA-512("abc") */
+static const unsigned char expected_sha512[64] = {
+	0xdd, 0xaf, 0x35, 0xa1, 0x93, 0x61, 0x7a, 0xba,
+	0xcc, 0x41, 0x73, 0x49, 0xae, 0x20, 0x41, 0x31,
+	0x12, 0xe6, 0xfa, 0x4e, 0x89, 0xa9, 0x7e, 0xa2,
+	0x0a, 0x9e, 0xee, 0xe6, 0x4b, 0x55, 0xd3, 0x9a,
+	0x21, 0x92, 0x99, 0x2a, 0x27, 0x4f, 0xc1, 0xa8,
+	0x36, 0xba, 0x3c, 0x23, 0xa3, 0xfe, 0xeb, 0xbd,
+	0x45, 0x4d, 0x44, 0x23, 0x64, 0x3c, 0xe8, 0x0e,
+	0x2a, 0x9a, 0xc9, 0x4f, 0xa5, 0x4c, 0xa4, 0x9f
+};
+
+static struct crypto_hash *setup_skel(void)
+{
+	struct crypto_hash *skel;
+
+	skel = crypto_hash__open_and_load();
+	if (!skel) {
+		/* Skip if kfuncs not available (CONFIG_CRYPTO_HASH2 not set) */
+		if (errno == ENOENT || errno == EINVAL) {
+			test__skip();
+			return NULL;
+		}
+		ASSERT_OK_PTR(skel, "crypto_hash__open_and_load");
+		return NULL;
+	}
+
+	return skel;
+}
+
+static void test_sha256_basic(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_sha256);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_sha256");
+	ASSERT_EQ(skel->data->sha256_status, 0, "sha256_status");
+	ASSERT_EQ(memcmp(skel->bss->sha256_output, expected_sha256, 32), 0,
+		  "sha256_output_match");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_sha384_basic(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+	prog_fd = bpf_program__fd(skel->progs.test_sha384);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_sha384");
+	ASSERT_EQ(skel->data->sha384_status, 0, "sha384_status");
+	ASSERT_EQ(memcmp(skel->bss->sha384_output, expected_sha384, 48), 0,
+		  "sha384_output_match");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_sha512_basic(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_sha512);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_sha512");
+	ASSERT_EQ(skel->data->sha512_status, 0, "sha512_status");
+	ASSERT_EQ(memcmp(skel->bss->sha512_output, expected_sha512, 64), 0,
+		  "sha512_output_match");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_sha256_invalid_params(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_sha256_zero_len);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_zero_len");
+	ASSERT_EQ(skel->data->sha256_status, 0, "zero_len_rejected");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_hash_with_key_rejected(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_hash_with_key_rejected);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_hash_with_key_rejected");
+	ASSERT_EQ(skel->data->hash_with_key_status, 0, "hash_with_key_rejected");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_hash_output_too_small(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_hash_output_too_small);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_hash_output_too_small");
+	ASSERT_EQ(skel->data->hash_output_too_small_status, 0, "hash_output_too_small");
+
+	crypto_hash__destroy(skel);
+}
+
+static void test_hash_on_skcipher_ctx(void)
+{
+	struct crypto_hash *skel;
+	int err, prog_fd;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	skel = setup_skel();
+	if (!skel)
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.test_hash_on_skcipher_ctx);
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(err, "test_hash_on_skcipher_ctx");
+	ASSERT_EQ(skel->data->hash_on_skcipher_status, 0, "hash_on_skcipher_rejected");
+
+	crypto_hash__destroy(skel);
+}
+
+void test_crypto_hash(void)
+{
+	if (test__start_subtest("sha256_basic"))
+		test_sha256_basic();
+	if (test__start_subtest("sha384_basic"))
+		test_sha384_basic();
+	if (test__start_subtest("sha512_basic"))
+		test_sha512_basic();
+	if (test__start_subtest("sha256_invalid_params"))
+		test_sha256_invalid_params();
+	if (test__start_subtest("hash_with_key_rejected"))
+		test_hash_with_key_rejected();
+	if (test__start_subtest("hash_output_too_small"))
+		test_hash_output_too_small();
+	if (test__start_subtest("hash_on_skcipher_ctx"))
+		test_hash_on_skcipher_ctx();
+}
diff --git a/tools/testing/selftests/bpf/progs/crypto_common.h b/tools/testing/selftests/bpf/progs/crypto_common.h
index 57dd7a68a8c3..2f04f08f890b 100644
--- a/tools/testing/selftests/bpf/progs/crypto_common.h
+++ b/tools/testing/selftests/bpf/progs/crypto_common.h
@@ -15,6 +15,8 @@ int bpf_crypto_encrypt(struct bpf_crypto_ctx *ctx, const struct bpf_dynptr *src,
 		       const struct bpf_dynptr *dst, const struct bpf_dynptr *iv) __ksym;
 int bpf_crypto_decrypt(struct bpf_crypto_ctx *ctx, const struct bpf_dynptr *src,
 		       const struct bpf_dynptr *dst, const struct bpf_dynptr *iv) __ksym;
+int bpf_crypto_hash(struct bpf_crypto_ctx *ctx, const struct bpf_dynptr *data,
+		    const struct bpf_dynptr *out) __ksym;
 
 struct __crypto_ctx_value {
 	struct bpf_crypto_ctx __kptr * ctx;
diff --git a/tools/testing/selftests/bpf/progs/crypto_hash.c b/tools/testing/selftests/bpf/progs/crypto_hash.c
new file mode 100644
index 000000000000..0258fdbe3e71
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/crypto_hash.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+#include "bpf_kfuncs.h"
+#include "crypto_common.h"
+
+unsigned char test_input[3] = "abc";
+
+/* Expected SHA-256 hash of "abc" */
+/* ba7816bf 8f01cfea 414140de 5dae2223 b00361a3 96177a9c b410ff61 f20015ad */
+unsigned char expected_sha256[32] = {
+	0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea,
+	0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
+	0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c,
+	0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad
+};
+
+/* Output buffers for test results */
+unsigned char sha256_output[32] = {};
+unsigned char sha384_output[48] = {};
+unsigned char sha512_output[64] = {};
+unsigned char small_output[16] = {}; /* Intentionally small for output_too_small test */
+
+int sha256_status = -1;
+int sha384_status = -1;
+int sha512_status = -1;
+int hash_with_key_status = -1;
+int hash_output_too_small_status = -1;
+int hash_on_skcipher_status = -1;
+
+SEC("syscall")
+int test_sha256(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha256",
+		.key_len = 0,
+	};
+	int err = 0;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		sha256_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, sizeof(test_input), 0, &input_ptr);
+	bpf_dynptr_from_mem(sha256_output, sizeof(sha256_output), 0, &output_ptr);
+
+	sha256_status = bpf_crypto_hash(hash_ctx, &input_ptr, &output_ptr);
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_sha384(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha384",
+		.key_len = 0,
+	};
+	int err = 0;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		sha384_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, sizeof(test_input), 0, &input_ptr);
+	bpf_dynptr_from_mem(sha384_output, sizeof(sha384_output), 0, &output_ptr);
+
+	sha384_status = bpf_crypto_hash(hash_ctx, &input_ptr, &output_ptr);
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_sha512(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha512",
+		.key_len = 0,
+	};
+	int err = 0;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		sha512_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, sizeof(test_input), 0, &input_ptr);
+	bpf_dynptr_from_mem(sha512_output, sizeof(sha512_output), 0, &output_ptr);
+
+	sha512_status = bpf_crypto_hash(hash_ctx, &input_ptr, &output_ptr);
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_sha256_zero_len(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
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
+		sha256_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, 0, 0, &input_ptr);
+	bpf_dynptr_from_mem(sha256_output, sizeof(sha256_output), 0, &output_ptr);
+
+	ret = bpf_crypto_hash(hash_ctx, &input_ptr, &output_ptr);
+	sha256_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_hash_with_key_rejected(void *ctx)
+{
+	struct bpf_crypto_ctx *hash_ctx;
+	struct bpf_crypto_params params = {
+		.type = "hash",
+		.algo = "sha256",
+		.key_len = 16, /* Hash algorithms don't support keys */
+	};
+	int err = 0;
+
+	/* Set some dummy key data */
+	params.key[0] = 0x01;
+	params.key[1] = 0x02;
+
+	hash_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!hash_ctx) {
+		/* Expected: should fail with -EINVAL (-22) */
+		hash_with_key_status = (err == -22) ? 0 : err;
+		return 0;
+	}
+
+	/* Should not reach here - context creation should have failed */
+	hash_with_key_status = -1;
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_hash_output_too_small(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
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
+		hash_output_too_small_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, sizeof(test_input), 0, &input_ptr);
+	bpf_dynptr_from_mem(small_output, sizeof(small_output), 0, &output_ptr);
+
+	ret = bpf_crypto_hash(hash_ctx, &input_ptr, &output_ptr);
+	/* Expected: should fail with -EINVAL (-22) */
+	hash_output_too_small_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(hash_ctx);
+	return 0;
+}
+
+SEC("syscall")
+int test_hash_on_skcipher_ctx(void *ctx)
+{
+	struct bpf_dynptr input_ptr, output_ptr;
+	struct bpf_crypto_ctx *cipher_ctx;
+	struct bpf_crypto_params params = {
+		.type = "skcipher",
+		.algo = "ecb(aes)",
+		.key_len = 16,
+	};
+	int err = 0;
+	int ret;
+
+	params.key[0] = 0x00; params.key[1] = 0x01; params.key[2] = 0x02; params.key[3] = 0x03;
+	params.key[4] = 0x04; params.key[5] = 0x05; params.key[6] = 0x06; params.key[7] = 0x07;
+	params.key[8] = 0x08; params.key[9] = 0x09; params.key[10] = 0x0a; params.key[11] = 0x0b;
+	params.key[12] = 0x0c; params.key[13] = 0x0d; params.key[14] = 0x0e; params.key[15] = 0x0f;
+
+	cipher_ctx = bpf_crypto_ctx_create(&params, sizeof(params), &err);
+	if (!cipher_ctx) {
+		hash_on_skcipher_status = err;
+		return 0;
+	}
+
+	bpf_dynptr_from_mem(test_input, sizeof(test_input), 0, &input_ptr);
+	bpf_dynptr_from_mem(sha256_output, sizeof(sha256_output), 0, &output_ptr);
+
+	ret = bpf_crypto_hash(cipher_ctx, &input_ptr, &output_ptr);
+	/* Expected: should fail with -EINVAL (-22) due to type_id mismatch */
+	hash_on_skcipher_status = (ret == -22) ? 0 : ret;
+	bpf_crypto_ctx_release(cipher_ctx);
+	return 0;
+}
+
+char __license[] SEC("license") = "GPL";
-- 
2.52.0

