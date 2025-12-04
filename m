Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B906341AC0
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857590; cv=none; b=p84FZon5RD7A90Rj++IEQ1HwFn67oIIfKGxX+EdtRfjpOI5d/FvEhTNUwOilDEbrzxHS8/eLsS7q3w/wWuVlSGhNBSXV0+5i6aH1aTt8ZtzqYECPVF76+1qMhjbDrKYAnmGbaaX6yEC8WS7U94p3ph7ZRdz42LUFqzizL2dS3zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857590; c=relaxed/simple;
	bh=gGOyyVjVMhMF3sDm6WRBw0+IQtrWF8GPAGIMRplta2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOwM+Cnp8Vv1d1+eLa829Vfz2YHdZCbu/2JmfS8G0DmjN41X8Xo3BfqAvIqSvWCN068jZmO++pdYpl4z+AYu/6whwzTcDCYe0s6W0vuiXJp7foghhpSvt1K4jBa+Q9OBziSnsLz6Qkvg27JQJGPRh+iDd3+HfumJgnHjHzbcICM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DnNEoFkd; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnNEoFkd"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b32ff5d10so1398672f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857587; x=1765462387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isyNyNcz2cmNMZXUIhi196/Z7TRsBZBkmSpv3VPEYmw=;
        b=DnNEoFkdX816PUig11YRbjWEMG+GnW0Id+UzFswX/dQVsxjcLb2oj1hi/gyoo6CFIe
         Sxcwpsu8r42jbEcaw2ZXmcNjhoT4aXlQ9xrtRyYPdieL8c0lKStznZPmFfZPkKR/h2jX
         E4qEJDayNpRExtVEHItSRQ3ft9evBrb1Kx1Dx8T8gY0ApX0Pp38eTu4KifrEtF+12N5F
         FAsjtMGbE42JIJJimCh8DBA7mjDVjUBn/SJV1NkTWSkg19JzvZWFIfZH9k5UaaU1U95W
         qDy+lc5BiS1dPjwnFlr/FHFm8DmdhETuC+FfoiZxO3gLjWfzuLn0mtuL3l0dFpCbCarS
         kwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857587; x=1765462387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=isyNyNcz2cmNMZXUIhi196/Z7TRsBZBkmSpv3VPEYmw=;
        b=LV+yBI6rmL3vws0I8MdBo3FPvQtxXGSW8+QSw06yFDzPSDS+ufVQPuP3XTaA7ctvnK
         iTYgxHcabZDNx0bJdQ+Cxfvg+tyiACH20YRKdRbd7eiTq4fvxX1QyQFbn14Bvyh3ZmJg
         buNfCNwsF51kIu1QkY1FV1Hoz8jJXijvBZCg2ybVAtHGZchvlmnGz5Yj5ItxhQQlr+3C
         IU/2ZmQN/M+e4BJ1z9/1ZPfTZsIqrAcVJGXSrCwhFdb0mLQQrwRbs9jyyYmlKlJwT9TA
         G7wmi2EsJbaLqAkmS6jkZtVslKz9Cdc5/nOs6/dMS0t8Yi8ZFEHizHPEFOYSPrdVc7fL
         Si4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/9qhtUA1bBJmdgWVMc5JIw+/wPff5T3KcEqLqsGsbJ7Vzaiti1gKbDwy65GdJHqokrfpkRwC+UMDLNgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKb0x5ydbN7zMNgiwotKpmL/jo16OO/RlzZhj3hMwVtSstyvvK
	LimFRFxxStsn2r2ZkgI+A7aV06gkuqUo/DU8dz7i0z8DL6J89sxGhLHc
X-Gm-Gg: ASbGncvAgzB4VS95AasZIut6Xn3COoz08FlO0nA8j2uNZrtdLL6k3vrQZTDkcNio470
	CGsDvxHGOVUaVCL+ae8a14XrjBy7ikpo5/ooXS+i+BfyhgEvxrB85gek5Xz7IeHuaPk7oIlpZJJ
	Yba5CFC6ZmJtq5eg7g4kMIctru4qnh2+j/EWQAH/tpFPjHt7J4MgzGkew+B5cVgdqa4rztc83Fs
	iYdTIxGbOh/qCra48D6RZnM2Fns9LTiV56QXfAGAR+OaGzOBZfgVKXS/RkVaFmAOA/oawhX2KJH
	iiMoOJoRShvklDFwMOsi/QFbog80tAnu0+T+/VeOiBpx/hKXFh/lvWKgdwsQgM0GF8HWiAtG+wP
	c2QYMQ7L7s2Qr5+W5ujxJVsker9WhJXQjfCXUEdX7u+G3eFyG0k7R6psevldwqsaOWcPymeQhlX
	SjB20lNhFjCaGh1UuLoPwBlc1iY6nE8R/ZTCPLLAETwKNX7//WjzMv5poxlrQWEtO2eA==
X-Google-Smtp-Source: AGHT+IHzNmWdyGZHlpy0d/ld4zER7YnP7X7/VxSK89F6ur9TtLx9dRwcFdqJB8Vqqm6xuvTuLO1sQw==
X-Received: by 2002:a05:6000:290c:b0:42b:3661:304e with SMTP id ffacd0b85a97d-42f78874e61mr3830533f8f.16.1764857586521;
        Thu, 04 Dec 2025 06:13:06 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:06 -0800 (PST)
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
	tarasmadan@google.com
Subject: [PATCH 03/10] kfuzztest: introduce the FUZZ_TEST_SIMPLE macro
Date: Thu,  4 Dec 2025 15:12:42 +0100
Message-ID: <20251204141250.21114-4-ethan.w.s.graham@gmail.com>
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

The serialization format required by a KFuzzTest target defined with the
FUZZ_TEST macro is overkill for simpler cases, in particular the very
common pattern of kernel interfaces taking a (data, datalen) pair.

Introduce the FUZZ_TEST_SIMPLE for defining simple targets that accept
a simpler binary interface without any required serialization. The aim
is to make simple targets compatible with a wide variety of userspace
fuzzing engines out of the box.

A FUZZ_TEST_SIMPLE target also defines an equivalent FUZZ_TEST macro in
its expansion maintaining compatibility with the default KFuzzTest
interface, using a shared `struct kfuzztest_simple_arg` as input type.
In essence, the following equivalence holds:

FUZZ_TEST_SIMPLE(test) === FUZZ_TEST(test, struct kfuzztest_simple_arg)

Constraints and annotation metadata for `struct kfuzztest_simple_arg` is
defined statically in the header file to avoid duplicate definitions in
the compiled vmlinux image.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |  4 ++
 include/linux/kfuzztest.h         | 87 +++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9afe569d013b..2736dd41fba0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -974,6 +974,10 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	KEEP(*(.kfuzztest_target));					\
 	__kfuzztest_targets_end = .;					\
 	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_simple_targets_start = .;				\
+	KEEP(*(.kfuzztest_simple_target));				\
+	__kfuzztest_simple_targets_end = .;				\
+	. = ALIGN(PAGE_SIZE);						\
 	__kfuzztest_constraints_start = .;				\
 	KEEP(*(.kfuzztest_constraint));					\
 	__kfuzztest_constraints_end = .;				\
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
index 1839fcfeabf5..284142fa4300 100644
--- a/include/linux/kfuzztest.h
+++ b/include/linux/kfuzztest.h
@@ -483,4 +483,91 @@ fail_early:													\
 	}													\
 	static void kfuzztest_logic_##test_name(test_arg_type *arg)
 
+struct kfuzztest_simple_target {
+	const char *name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+} __aligned(32);
+
+struct kfuzztest_simple_arg {
+	char *data;
+	size_t datalen;
+};
+
+/* Define constraint and annotation metadata for reused kfuzztest_simple_arg. */
+__KFUZZTEST_CONSTRAINT(kfuzztest_simple_arg, data, NULL, 0x0, EXPECT_NE);
+__KFUZZTEST_ANNOTATE(kfuzztest_simple_arg, data, NULL, ATTRIBUTE_ARRAY);
+__KFUZZTEST_ANNOTATE(kfuzztest_simple_arg, datalen, data, ATTRIBUTE_LEN);
+
+/**
+ * FUZZ_TEST_SIMPLE - defines a simple KFuzzTest target
+ *
+ * @test_name: the unique identifier for the fuzz test, which is used to name
+ *	the debugfs entry.
+ *
+ * This macro function nearly identically to the standard FUZZ_TEST target, the
+ * key difference being that a simple fuzz target is constrained to inputs of
+ * the form `(char *data, size_t datalen)` - a common pattern in kernel APIs.
+ *
+ * The FUZZ_TEST_SIMPLE macro expands to define an equivalent FUZZ_TEST,
+ * effectively creating two debugfs input files for the fuzz target. In essence,
+ * on top of creating an input file under kfuzztest/@test_name/input, a new
+ * simple input file is created under kfuzztest/@test_name/input_simple. This
+ * debugfs file takes raw byte buffers as input and doesn't require any special
+ * serialization.
+ *
+ * User-provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * provides the `data` and `datalen` variables, where `datalen == len(data)`.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function that we wnat to fuzz.
+ * int process_data(const char *data, size_t datalen);
+ *
+ * // 2. Define a fuzz target using the FUZZ_TEST_SIMPLE macro.
+ * FUZZ_TEST_SIMPLE(test_process_data)
+ * {
+ *	// Call the function under test using the `data` and `datalen`
+ *	// variables.
+ *	process_data(data, datalen);
+ * }
+ *
+ */
+#define FUZZ_TEST_SIMPLE(test_name)											\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off);						\
+	static void kfuzztest_simple_logic_##test_name(char *data, size_t datalen);					\
+	static const struct kfuzztest_simple_target __fuzz_test_simple__##test_name __section(				\
+		".kfuzztest_simple_target") __used = {									\
+		.name = #test_name,											\
+		.write_input_cb = kfuzztest_simple_write_cb_##test_name,						\
+	};														\
+	FUZZ_TEST(test_name, struct kfuzztest_simple_arg)								\
+	{														\
+		/* We don't use the KFUZZTEST_EXPECT macro to define the
+		 * non-null constraint on `arg->data` as we only want metadata
+		 * to be emitted once, so we enforce it here manually. */						\
+		if (arg->data == NULL)											\
+			return;												\
+		kfuzztest_simple_logic_##test_name(arg->data, arg->datalen);						\
+	}														\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off)						\
+	{														\
+		void *buffer;												\
+		int ret;												\
+															\
+		ret = kfuzztest_write_cb_common(filp, buf, len, off, &buffer);						\
+		if (ret < 0)												\
+			goto out;											\
+		kfuzztest_simple_logic_##test_name(buffer, len);							\
+		record_invocation();											\
+		ret = len;												\
+		kfree(buffer);												\
+out:															\
+		return ret;												\
+	}														\
+	static void kfuzztest_simple_logic_##test_name(char *data, size_t datalen)
+
 #endif /* KFUZZTEST_H */
-- 
2.51.0

