Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5676234104D
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857590; cv=none; b=aYThJNL+qJnkmSy61w/i1T5EuwDz6vYmB7oGZimd9VU6WPmsPn/Atd9k0vEt6Fe1mRcwZ7h3uF9V5i8E/nnUI0hYL1iCwTP6vkZeCDiSCkUd7wBnOpQ0Q4lyrST1/Kd/zGv/B/JPcE6uZEqUE7IrcbjZZc39ka9HLhujdc35/ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857590; c=relaxed/simple;
	bh=ETSuX2q6aBqRJwufP4nFQ3iS4q0jKzkgSG63WlRXfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bD8xRTJ+1yF+iLr9k4yRvV5ZRjeHOxIL6YGV36AE3Ii2TM1TQ7orDVPrQtFqdqsxQ8e/fuvU4qaaPu+BftE6G0TZd7/5exj5Zpk7IxF1Vm2VGpLvUxaEh/jn7lSUsnS0N9BPwPIVXTXdeUVi050gAm58mn7XNUlXJkXUXxxlBao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUmLYfQ5; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUmLYfQ5"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e29739ff1so455070f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857585; x=1765462385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eB/egNHg9loIhoHi7MhcNEE3/MaK1lWrTWkAXOToMjQ=;
        b=RUmLYfQ5zklSV1+7aloU76Tb9iY6rNNe0uH96Gh78ehwrS5DftBnu2xPjLJ5gOtPno
         PZqXPVFlBjFXPGO/2KgX+1cYo3IN6scgtJCfpM4vfVarlVwCqgalQRew9swj3vBLmB3T
         7jKLG/hlksZZm3nhWo6LHrVt+LQhRI/I3GNYvREtzsdaqFQlF5ltKdWo87FMGnjFDRML
         xdY3o+j3YAaR7HsiWd2N3GOJLSD3iU1+Pt30Lxq9hbAE9sdyp1UR99mIVkrcDQimLWCi
         jBSltUs3+aH6K4JGIts8yLQwPYRZHUbjhBYjCqgzwimna1Q1adMFW1w6aKTQCN67eR7W
         CfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857585; x=1765462385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eB/egNHg9loIhoHi7MhcNEE3/MaK1lWrTWkAXOToMjQ=;
        b=pHXtfKcCcS03BsYc+OvUK1jLwVpPgw6LMOEh450EyC3cUWLdxNrZBBE3hn82DPajsZ
         3elgJms7yUHnOq0H6/u9zR66KmIW0ilOhzPPtOiADy6+QqV7mDj04Z8wsc4Mz/jdtMk/
         nvof2fBr9FMd6XTteEE11vlJWB32f8TMDib7lD1Mz+lUwbVbJL6g/IW7QZck28/Goscg
         ih5uE235dbAf/V7c3E/pnPWNWJvgkxjHcxb/Dx5f/+hd430UpeXEKJYkV1WLpeYW4enN
         zegOBfy4/Bh+18Xyf+4sLSCsTXzuwUHvju0EJH6FEuCbbJYJ6cUgPnY1TQ1NbKn2m9O0
         r+Kg==
X-Forwarded-Encrypted: i=1; AJvYcCUkeyCPZtdiqFd1DhQT6NYq/FRxM2SapbLkgdshyc621oFoVh0c2rJ3VaIJI9vGDtjP3WiacwFXGmH0qp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ztkFQpbLFpQpsZW5QigmTin5jS63lmBQXWFO1PTVUPyokqyb
	fiH060co7Yg1WRgj2YiWkVaL4P0fOAbignsorAikJMiU9OiSl9a8b9UL
X-Gm-Gg: ASbGncv92SEz82A+HgQXHwhnPtwH+aW+slyStwV55j3ZnQKgQhhG1lG3Ev0wfFGaRRj
	1rT6HEgFTZgYZHb5viF3j25Jy5UpDdOBPyEUPQNtSqhO/jYn+ST0oHJBygB+i/OkKHqS+aaqTBy
	NtCUOwbRQQiVKYehcRlhwnV1T2wV87un9yKoi/BS0gJK6sNjkHlaXHPWUmzNhuIvcE1/gSw6hxI
	ao/K/k7dUBbcA/M7YMsPLdveciK2r6zvo7bMi6Cw3nWAH5oC3gt90wcVxFaD5TP3Zus8dfh/ssG
	l7SHVkgxG3OjZ05UuhwUA8AKYFx20tM/rxKdHkOJIzsR9f/W1Kz0Uwalt+wNMBjWXdgIfM8mb+e
	BMoTTkd/5ZxECYo1lSIlfisrigXVr9/tDpc0G+YR7TOUzdmPwOrCGq+ttgNoDhjR5r1s96Qx8Sg
	4vuYpnpxLM/YP7rDjSMNf1PvSYSX/XmKPGbYcGVzszYC4hojGx9QEFCc7wmwiBkxAitA==
X-Google-Smtp-Source: AGHT+IFkT4+/HKSCxBC0OR4LEFO3iIJWdcvcuQZ4FUyLxnx0AlGCgOOVSXkLQIHCB3LxKmzkitwLKQ==
X-Received: by 2002:a5d:4942:0:b0:42b:2a41:f20 with SMTP id ffacd0b85a97d-42f7886d085mr2957881f8f.18.1764857585163;
        Thu, 04 Dec 2025 06:13:05 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:04 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 02/10] kfuzztest: add user-facing API and data structures
Date: Thu,  4 Dec 2025 15:12:41 +0100
Message-ID: <20251204141250.21114-3-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add the foundational user-facing components for the KFuzzTest framework.
This includes the main API header <linux/kfuzztest.h>, the Kconfig
option to enable the feature, and the required linker script changes
which introduce three new ELF sections in vmlinux.

Note that KFuzzTest is intended strictly for debug builds only, and
should never be enabled in a production build. The fact that it exposes
internal kernel functions and state directly to userspace may constitute
a serious security vulnerability if used for any reason other than
testing.

The header defines:
- The FUZZ_TEST() macro for creating test targets.
- The data structures required for the binary serialization format,
  which allows passing complex inputs from userspace.
- The metadata structures for test targets, constraints and annotations,
  which are placed in dedicated ELF sections (.kfuzztest_*) for
  discovery.

This patch only adds the public interface and build integration; no
runtime logic is included.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Reorder definitions in kfuzztest.h for better flow and readability.
- Introduce __KFUZZTEST_CONSTRAINT macro in preparation for the
  introduction of the FUZZ_TEST_SIMPLE macro in the following patch,
  which uses it for manually emitting constraint metadata.
PR v1:
- Move KFuzzTest metadata definitions to generic vmlinux linkage so that
  the framework isn't bound to x86_64.
- Return -EFAULT when simple_write_to_buffer returns a value not equal
  to the input length in the main FUZZ_TEST macro.
- Enforce a maximum input size of 64KiB in the main FUZZ_TEST macro,
  returning -EINVAL when it isn't respected.
- Refactor KFUZZTEST_ANNOTATION_* macros.
- Taint the kernel with TAINT_TEST inside the FUZZ_TEST macro when a
  fuzz target is invoked for the first time.
---
---
 include/asm-generic/vmlinux.lds.h |  22 +-
 include/linux/kfuzztest.h         | 486 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |   1 +
 lib/kfuzztest/Kconfig             |  20 ++
 4 files changed, 528 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e..9afe569d013b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -373,7 +373,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	TRACE_PRINTKS()							\
 	BPF_RAW_TP()							\
 	TRACEPOINT_STR()						\
-	KUNIT_TABLE()
+	KUNIT_TABLE()							\
+	KFUZZTEST_TABLE()
 
 /*
  * Data section helpers
@@ -966,6 +967,25 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
 				__kunit_init_suites, _start, _end)
 
+#ifdef CONFIG_KFUZZTEST
+#define KFUZZTEST_TABLE()						\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_targets_start = .;					\
+	KEEP(*(.kfuzztest_target));					\
+	__kfuzztest_targets_end = .;					\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_constraints_start = .;				\
+	KEEP(*(.kfuzztest_constraint));					\
+	__kfuzztest_constraints_end = .;				\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_annotations_start = .;				\
+	KEEP(*(.kfuzztest_annotation));					\
+	__kfuzztest_annotations_end = .;
+
+#else /* CONFIG_KFUZZTEST */
+#define KFUZZTEST_TABLE()
+#endif /* CONFIG_KFUZZTEST */
+
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
 	. = ALIGN(4);							\
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
new file mode 100644
index 000000000000..1839fcfeabf5
--- /dev/null
+++ b/include/linux/kfuzztest.h
@@ -0,0 +1,486 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
+ * for internal kernel functions.
+ *
+ * For more information please see Documentation/dev-tools/kfuzztest.rst.
+ *
+ * Copyright 2025 Google LLC
+ */
+#ifndef KFUZZTEST_H
+#define KFUZZTEST_H
+
+#include <linux/fs.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+
+#define KFUZZTEST_HEADER_MAGIC (0xBFACE)
+#define KFUZZTEST_V0 (0)
+#define KFUZZTEST_REGIONID_NULL U32_MAX
+#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)
+/**
+ * The end of the input should be padded by at least this number of bytes as
+ * it is poisoned to detect out of bounds accesses at the end of the last
+ * region.
+ */
+#define KFUZZTEST_POISON_SIZE 0x8
+
+/**
+ * @brief The KFuzzTest Input Serialization Format
+ *
+ * KFuzzTest receives its input from userspace as a single binary blob. This
+ * format allows for the serialization of complex, pointer-rich C structures
+ * into a flat buffer that can be safely passed into the kernel. This format
+ * requires only a single copy from userspace into a kernel buffer, and no
+ * further kernel allocations. Pointers are patched internally using a "region"
+ * system where each region corresponds to some pointed-to data.
+ *
+ * Regions should be padded to respect alignment constraints of their underlying
+ * types, and should be followed by at least 8 bytes of padding. These padded
+ * regions are poisoned by KFuzzTest to ensure that KASAN catches OOB accesses.
+ *
+ * The format consists of a header and three main components:
+ * 1. An 8-byte header: Contains KFUZZTEST_MAGIC in the first 4 bytes, and the
+ *	version number in the subsequent 4 bytes. This ensures backwards
+ *	compatibility in the event of future format changes.
+ * 2. A reloc_region_array: Defines the memory layout of the target structure
+ *	by partitioning the payload into logical regions. Each logical region
+ *	should contain the byte representation of the type that it represents,
+ *	including any necessary padding. The region descriptors should be
+ *	ordered by offset ascending.
+ * 3. A reloc_table: Provides "linking" instructions that tell the kernel how
+ *	to patch pointer fields to point to the correct regions. By design,
+ *	the first region (index 0) is passed as input into a FUZZ_TEST.
+ * 4. A Payload: The raw binary data for the target structure and its associated
+ *	buffers. This should be aligned to the maximum alignment of all
+ *	regions to satisfy alignment requirements of the input types, but this
+ *	isn't checked by the parser.
+ *
+ * For a detailed specification of the binary layout see the full documentation
+ * at: Documentation/dev-tools/kfuzztest.rst
+ */
+
+/**
+ * struct reloc_region - single contiguous memory region in the payload
+ *
+ * @offset: The byte offset of this region from the start of the payload, which
+ *	should be aligned to the alignment requirements of the region's
+ *	underlying type.
+ * @size: The size of this region in bytes.
+ */
+struct reloc_region {
+	uint32_t offset;
+	uint32_t size;
+};
+
+/**
+ * struct reloc_region_array - array of regions in an input
+ *
+ * @num_regions: The total number of regions defined.
+ * @regions: A flexible array of `num_regions` region descriptors.
+ */
+struct reloc_region_array {
+	uint32_t num_regions;
+	struct reloc_region regions[];
+};
+
+/**
+ * struct reloc_entry - a single pointer to be patched in an input
+ *
+ * @region_id: The index of the region in the `reloc_region_array` that
+ *	contains the pointer.
+ * @region_offset: The start offset of the pointer inside of the region.
+ * @value: contains the index of the pointee region, or KFUZZTEST_REGIONID_NULL
+ *	if the pointer is NULL.
+ */
+struct reloc_entry {
+	uint32_t region_id;
+	uint32_t region_offset;
+	uint32_t value;
+};
+
+/**
+ * struct reloc_table - array of relocations required by an input
+ *
+ * @num_entries: the number of pointer relocations.
+ * @padding_size: the number of padded bytes between the last relocation in
+ *	entries, and the start of the payload data. This should be at least
+ *	8 bytes, as it is used for poisoning.
+ * @entries: array of relocations.
+ */
+struct reloc_table {
+	uint32_t num_entries;
+	uint32_t padding_size;
+	struct reloc_entry entries[];
+};
+
+/**
+ * kfuzztest_parse_and_relocate - validate and relocate a KFuzzTest input
+ *
+ * @input:      A buffer containing the serialized input for a fuzz target.
+ * @input_size: the size in bytes of the @input buffer.
+ * @arg_ret:    return pointer for the test case's input structure.
+ */
+int kfuzztest_parse_and_relocate(void *input, size_t input_size, void **arg_ret);
+
+enum kfuzztest_constraint_type {
+	EXPECT_EQ,
+	EXPECT_NE,
+	EXPECT_LT,
+	EXPECT_LE,
+	EXPECT_GT,
+	EXPECT_GE,
+	EXPECT_IN_RANGE,
+};
+
+/**
+ * struct kfuzztest_constraint - a metadata record for a domain constraint
+ *
+ * Domain constraints are rules about the input data that must be satisfied for
+ * a fuzz test to proceed. While they are enforced in the kernel with a runtime
+ * check, they are primarily intended as a discoverable contract for userspace
+ * fuzzers.
+ *
+ * Instances of this struct are generated by the KFUZZTEST_EXPECT_* macros
+ * and placed into the read-only ".kfuzztest_constraint" ELF section of the
+ * vmlinux binary. A fuzzer can parse this section to learn about the
+ * constraints and generate valid inputs more intelligently.
+ *
+ * For an example of how these constraints are used within a fuzz test, see the
+ * documentation for the FUZZ_TEST() macro.
+ *
+ * @input_type: The name of the input struct type, without the leading
+ *	"struct ".
+ * @field_name: The name of the field within the struct that this constraint
+ *	applies to.
+ * @value1: The primary value used in the comparison (e.g., the upper
+ *	bound for EXPECT_LE).
+ * @value2: The secondary value, used only for multi-value comparisons
+ *	(e.g., the upper bound for EXPECT_IN_RANGE).
+ * @type: The type of the constraint.
+ */
+struct kfuzztest_constraint {
+	const char *input_type;
+	const char *field_name;
+	uintptr_t value1;
+	uintptr_t value2;
+	enum kfuzztest_constraint_type type;
+} __aligned(64);
+
+
+#define __KFUZZTEST_CONSTRAINT(arg_type, field, val1, val2, tpe)				\
+	static struct kfuzztest_constraint __constraint_##arg_type##_##field				\
+		__section(".kfuzztest_constraint") __used = {						\
+			.input_type = "struct " #arg_type,						\
+			.field_name = #field,								\
+			.value1 = (uintptr_t)val1,							\
+			.value2 = (uintptr_t)val2,							\
+			.type = tpe,									\
+		}
+
+#define __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val1, val2, tpe, predicate)				\
+	do {													\
+		__KFUZZTEST_CONSTRAINT(arg_type, field, val1, val2, tpe);				\
+		if (!(predicate))										\
+			return;											\
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable
+ * @val: a value of the same type as @arg_type.@field
+ */
+#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ, arg->field == val)
+
+/**
+ * KFUZZTEST_EXPECT_NE - constrain a field to be not equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_NE(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_NE, arg->field != val)
+
+/**
+ * KFUZZTEST_EXPECT_LT - constrain a field to be less than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LT(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LT, arg->field < val)
+
+/**
+ * KFUZZTEST_EXPECT_LE - constrain a field to be less than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LE(arg_type, field, val)	\
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LE, arg->field <= val)
+
+/**
+ * KFUZZTEST_EXPECT_GT - constrain a field to be greater than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GT(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GT, arg->field > val)
+
+/**
+ * KFUZZTEST_EXPECT_GE - constrain a field to be greater than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GE(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GE, arg->field >= val)
+
+/**
+ * KFUZZTEST_EXPECT_NOT_NULL - constrain a pointer field to be non-NULL
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: a pointer field.
+ */
+#define KFUZZTEST_EXPECT_NOT_NULL(arg_type, field) KFUZZTEST_EXPECT_NE(arg_type, field, NULL)
+
+/**
+ * KFUZZTEST_EXPECT_IN_RANGE - constrain a field to be within a range
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @lower_bound: a lower bound of the same type as @arg_type.@field.
+ * @upper_bound: an upper bound of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_IN_RANGE(arg_type, field, lower_bound, upper_bound)		\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, lower_bound, upper_bound,	\
+			EXPECT_IN_RANGE, arg->field >= lower_bound && arg->field <= upper_bound)
+
+/**
+ * Annotations express attributes about structure fields that can't be easily
+ * or safely verified at runtime. They are intended as hints to the fuzzing
+ * engine to help it generate more semantically correct and effective inputs.
+ * Unlike constraints, annotations do not add any runtime checks and do not
+ * cause a test to exit early.
+ *
+ * For example, a `char *` field could be a raw byte buffer or a C-style
+ * null-terminated string. A fuzzer that is aware of this distinction can avoid
+ * creating inputs that would cause trivial, uninteresting crashes from reading
+ * past the end of a non-null-terminated buffer.
+ */
+enum kfuzztest_annotation_attribute {
+	ATTRIBUTE_LEN,
+	ATTRIBUTE_STRING,
+	ATTRIBUTE_ARRAY,
+};
+
+/**
+ * struct kfuzztest_annotation - a metadata record for a fuzzer hint
+ *
+ * This struct captures a single hint about a field in the input structure.
+ * Instances are generated by the KFUZZTEST_ANNOTATE_* macros and are placed
+ * into the read-only ".kfuzztest_annotation" ELF section of the vmlinux binary.
+ *
+ * A userspace fuzzer can parse this section to understand the semantic
+ * relationships between fields (e.g., which field is a length for which
+ * buffer) and the expected format of the data (e.g., a null-terminated
+ * string). This allows the fuzzer to be much more intelligent during input
+ * generation and mutation.
+ *
+ * For an example of how annotations are used within a fuzz test, see the
+ * documentation for the FUZZ_TEST() macro.
+ *
+ * @input_type: The name of the input struct type.
+ * @field_name: The name of the field being annotated (e.g., the data
+ *	buffer field).
+ * @linked_field_name: For annotations that link two fields (like
+ *	ATTRIBUTE_LEN), this is the name of the related field (e.g., the
+ *	length field). For others, this may be unused.
+ * @attrib: The type of the annotation hint.
+ */
+struct kfuzztest_annotation {
+	const char *input_type;
+	const char *field_name;
+	const char *linked_field_name;
+	enum kfuzztest_annotation_attribute attrib;
+} __aligned(32);
+
+#define __KFUZZTEST_ANNOTATE(arg_type, field, linked_field, attribute)						\
+	static struct kfuzztest_annotation __annotation_##arg_type##_##field __section(".kfuzztest_annotation")	\
+		__used = {											\
+			.input_type = "struct " #arg_type,							\
+			.field_name = #field,									\
+			.linked_field_name = #linked_field,							\
+			.attrib = attribute,									\
+		}
+
+/**
+ * KFUZZTEST_ANNOTATE_STRING - annotate a char* field as a C string
+ *
+ * We define a C string as a sequence of non-zero characters followed by exactly
+ * one null terminator.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ */
+#define KFUZZTEST_ANNOTATE_STRING(arg_type, field) __KFUZZTEST_ANNOTATE(arg_type, field, NULL, ATTRIBUTE_STRING)
+
+/**
+ * KFUZZTEST_ANNOTATE_ARRAY - annotate a pointer as an array
+ *
+ * We define an array as a contiguous memory region containing zero or more
+ * elements of the same type.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ */
+#define KFUZZTEST_ANNOTATE_ARRAY(arg_type, field) __KFUZZTEST_ANNOTATE(arg_type, field, NULL, ATTRIBUTE_ARRAY)
+
+/**
+ * KFUZZTEST_ANNOTATE_LEN - annotate a field as the length of another
+ *
+ * This expresses the relationship `arg_type.field == len(linked_field)`, where
+ * `linked_field` is an array.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ * @linked_field: the name of an array field with length @field.
+ */
+#define KFUZZTEST_ANNOTATE_LEN(arg_type, field, linked_field) \
+	__KFUZZTEST_ANNOTATE(arg_type, field, linked_field, ATTRIBUTE_LEN)
+
+
+/*
+ * Dump some information on the parsed headers and payload. Can be useful for
+ * debugging inputs when writing an encoder for the KFuzzTest input format.
+ */
+__attribute__((unused)) static inline void kfuzztest_debug_header(struct reloc_region_array *regions,
+								  struct reloc_table *rt, void *payload_start,
+								  void *payload_end)
+{
+	uint32_t i;
+
+	pr_info("regions: { num_regions = %u } @ %px", regions->num_regions, regions);
+	for (i = 0; i < regions->num_regions; i++) {
+		pr_info("  region_%u: { start: 0x%x, size: 0x%x }", i, regions->regions[i].offset,
+			regions->regions[i].size);
+	}
+
+	pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%tx", rt->num_entries, rt->padding_size,
+		(char *)rt - (char *)regions);
+	for (i = 0; i < rt->num_entries; i++) {
+		pr_info("  reloc_%u: { src: %u, offset: 0x%x, dst: %u }", i, rt->entries[i].region_id,
+			rt->entries[i].region_offset, rt->entries[i].value);
+	}
+
+	pr_info("payload: [0x%lx, 0x%tx)", (char *)payload_start - (char *)regions,
+		(char *)payload_end - (char *)regions);
+}
+
+/* Increments a global counter after a successful invocation. */
+void record_invocation(void);
+
+/* Common code for receiving inputs from userspace. */
+int kfuzztest_write_cb_common(struct file *filp, const char __user *buf, size_t len, loff_t *off, void **test_buffer);
+
+struct kfuzztest_target {
+	const char *name;
+	const char *arg_type_name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+} __aligned(32);
+
+/**
+ * FUZZ_TEST - defines a KFuzzTest target
+ *
+ * @test_name: The unique identifier for the fuzz test, which is used to name
+ *	the debugfs entry, e.g., /sys/kernel/debug/kfuzztest/@test_name.
+ * @test_arg_type: The struct type that defines the inputs for the test. This
+ *	must be the full struct type (e.g., "struct my_inputs"), not a typedef.
+ *
+ * Context:
+ * This macro is the primary entry point for the KFuzzTest framework. It
+ * generates all the necessary boilerplate for a fuzz test, including:
+ *   - A static `struct kfuzztest_target` instance that is placed in a
+ *	dedicated ELF section for discovery by userspace tools.
+ *   - A `debugfs` write callback that handles receiving serialized data from
+ *	a fuzzer, parsing it, and "hydrating" it into a valid C struct.
+ *   - A function stub where the developer places the test logic.
+ *
+ * User-Provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * provides the `arg` variable, which is a pointer of type `@test_arg_type *`
+ * to the fully hydrated input structure. All pointer fields within this struct
+ * have been relocated and are valid kernel pointers. This is the primary
+ * variable to use for accessing fuzzing inputs.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function we want to fuzz.
+ * int process_data(const char *data, size_t len);
+ *
+ * // 2. Define a struct to hold all inputs for the function.
+ * struct process_data_inputs {
+ *	const char *data;
+ *	size_t len;
+ * };
+ *
+ * // 3. Define the fuzz test using the FUZZ_TEST macro.
+ * FUZZ_TEST(process_data_fuzzer, struct process_data_inputs)
+ * {
+ *	int ret;
+ *	// Use KFUZZTEST_EXPECT_* to enforce preconditions.
+ *	// The test will exit early if data is NULL.
+ *	KFUZZTEST_EXPECT_NOT_NULL(process_data_inputs, data);
+ *
+ *	// Use KFUZZTEST_ANNOTATE_* to provide hints to the fuzzer.
+ *	// This links the 'len' field to the 'data' buffer.
+ *	KFUZZTEST_ANNOTATE_LEN(process_data_inputs, len, data);
+ *
+ *	// Call the function under test using the 'arg' variable. OOB memory
+ *	// accesses will be caught by KASAN, but the user can also choose to
+ *	// validate the return value and log any failures.
+ *	ret = process_data(arg->data, arg->len);
+ * }
+ */
+#define FUZZ_TEST(test_name, test_arg_type)									\
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+						      loff_t *off);						\
+	static void kfuzztest_logic_##test_name(test_arg_type *arg);						\
+	static const struct kfuzztest_target __fuzz_test__##test_name __section(".kfuzztest_target") __used = {	\
+		.name = #test_name,										\
+		.arg_type_name = #test_arg_type,								\
+		.write_input_cb = kfuzztest_write_cb_##test_name,						\
+	};													\
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+						      loff_t *off)						\
+	{													\
+		test_arg_type *arg;										\
+		void *buffer;											\
+		int ret;											\
+		ret = kfuzztest_write_cb_common(filp, buf, len, off, &buffer);					\
+		if (ret < 0)											\
+			goto fail_early;									\
+		ret = kfuzztest_parse_and_relocate(buffer, len, (void **)&arg);					\
+		if (ret < 0)											\
+			goto fail_late;										\
+		kfuzztest_logic_##test_name(arg);								\
+		record_invocation();										\
+		ret = len;											\
+fail_late:													\
+		kfree(buffer);											\
+fail_early:													\
+		return ret;											\
+	}													\
+	static void kfuzztest_logic_##test_name(test_arg_type *arg)
+
+#endif /* KFUZZTEST_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed075..49a1748b9f24 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1947,6 +1947,7 @@ endmenu
 menu "Kernel Testing and Coverage"
 
 source "lib/kunit/Kconfig"
+source "lib/kfuzztest/Kconfig"
 
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
diff --git a/lib/kfuzztest/Kconfig b/lib/kfuzztest/Kconfig
new file mode 100644
index 000000000000..f9fb5abf8d27
--- /dev/null
+++ b/lib/kfuzztest/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config KFUZZTEST
+	bool "KFuzzTest - enable support for internal fuzz targets"
+	depends on DEBUG_FS && DEBUG_KERNEL
+	help
+	  Enables support for the kernel fuzz testing framework (KFuzzTest), an
+	  interface for exposing internal kernel functions to a userspace fuzzing
+	  engine. KFuzzTest targets are exposed via a debugfs interface that
+	  accepts serialized userspace inputs, and is designed to make it easier
+	  to fuzz deeply nested kernel code that is hard to reach from the system
+	  call boundary. Using a simple macro-based API, developers can add a new
+	  fuzz target with minimal boilerplate code.
+
+	  It is strongly recommended to also enable CONFIG_KASAN for byte-accurate
+	  out-of-bounds detection, as KFuzzTest was designed with this in mind. It
+	  is also recommended to enable CONFIG_KCOV for coverage guided fuzzing.
+
+	  WARNING: This exposes internal kernel functions directly to userspace
+	  and must NEVER be enabled in production builds.
-- 
2.51.0

