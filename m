Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934453164BD
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293890; cv=none; b=Xkhs0u3RZ2qWF+oESarN7bYwwOInzgk4fI3RG7NWjRWvOc4hDnU5qzIzjoVyx9rDyJRT7IapWjOa+8rb9aUfXzt3p5KB2oOstypERAxCyCa4JcrpaykjO5u5q7DEWmE/UN0QK6VlivqdgP7XrTnOFfxBwQLx2xf0gR0ChQGPHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293890; c=relaxed/simple;
	bh=Pd4P4ZjKr+HHW58Tf2SLAY9QUfyLhUA5ZgTSmT8bTAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujOJV72fq9H/c2r8P3JMoONOtCPIszbmRxhaz3zMySzxqwfOTrhfBcLT+gWhIzKXcQcTKX6xzDTs/UbLgfQam+cTRnqN8qlgRj3B4XQYtpzHnY8npkSkMKgP3hbczUlKvwQ8VUjF5uOsCkAss0luIOQhvbgxkjOH9VMgczB6CaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPL9nqpa; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPL9nqpa"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so646835f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293886; x=1758898686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LT1ydHgovraiyOIOgetbRaAa0TBzaulhkSUGdqArzzs=;
        b=UPL9nqpaCvvGy8wDd5o3DosMxgZXx0RTXohbou61mAZ0pVEa8Gz0ldb8BiiK4C+zE3
         wW9z4bEGM5ks2awBbAL72l6GAPL+R+D46LmJSnCnYfBD6Mp+jVMzxr+FmuWzmXT1mbXY
         VK+yEXDpHTZ0lu6ocxgqqliJP77TkVPRKl/nu56MNJAnr8Dr/E4Kxr4Rk8DsI1d/rrbE
         lB8UnfOv0guXFtidLPVbiSCpfHxLFM4/12OKp9OPFH+zpcAAYfKsTaRW6ZQk1PRF+eX6
         Nde7fm6HyRqalFvyAEkGZ+SEVkpQ3l3N3ligiaThzm/7hkm3628tcy1Q0RKGtsdziH3W
         U3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293886; x=1758898686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LT1ydHgovraiyOIOgetbRaAa0TBzaulhkSUGdqArzzs=;
        b=qvIyY09qX0ESUTjJsbPpwRiRMgFn/M3rijZSvnIePT/REVjU5iL+itun6TAuo9esix
         Kl72w5Hm1ueB5PUa3JsC1Xu7kfNGZav5dXZTH4fZZ6Nl87uTwIbbiMTRfHXCIpAyimGL
         ESM0ni5poqRo/e31I5gFS36CZ4yiKWiDZdnyNf+DBt1B1yUs72BlcagpHvfax2CHzWrI
         j20wiWiMOhk8n4NUsWPRyE3TV4F+D5+f2DZVm2n+SIkk31uzqkLsWD1+bj4ZNgnqGzmq
         P2e+vKQGeguTKvknRGFFAzMa46bvawFP4HOxUXw8lN6MgpqxIGaIodbSbSjNhpKWjzRw
         mbfA==
X-Forwarded-Encrypted: i=1; AJvYcCUeVvCWokD7E+nhGSZqn4jaMcl6Hd+e/VJcqtk3tSwUOiVLcT297YC1vzWdEToqIw8Zr3wzpk+JrLu40fo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCC4MsYUTGBEJotGTx+tU05AC+osXDh0W6evdkxEjOUwKHfYxj
	63C+WzjQuvvexZUQ9Tz4Z0gP9rOHcvd0zt429ELqdakizxbTjgiRowvg
X-Gm-Gg: ASbGncvBzR8Y09Km/NfIHpIaMx6GHn+I4uPzq0j8WwFmADkchWiWkJFRbVZljXK0yVW
	T2972Y5MM1fSgZGrhYhtPveqLVHfEV6zNEpnhv9YSTEFuYkIT94M5T+3/6FHkBmO1vJwAFBbFS4
	3h2BgF8CVKTDyFjPpCg8PPp3rdBtilr06BnT3TwNRXpRJ7XSlqnLf7qT9eaAL1jmv23Akva1qwm
	ZwJff9sx/t0darTYd6VR48ZvVyZflq7Wgiv11QqGz9zNDpHDw6wKf2W8Y4aKPyMUybUisgyZDHu
	JKzi/g3LZJgFWmvysJIBwlo9aI3fL9PDZnHeWGHtFUcVhU2T4reZR4dXaCWz1Lztct6+9LajOcN
	7PkDzjwwJ41i04mRJdMZBRYL2wABPQLIGRns/1oAD48HOT3GIzBqa3k9qEUlV+HBRnr29eRN3hF
	yAFE+c3+1OHljm1NA=
X-Google-Smtp-Source: AGHT+IHfk6FVy/mkcxlh5PwT7Aua9hjkv4iEAL059Dub4DeP/hMzVm4A59PgONlD461DIHsT16Nu4w==
X-Received: by 2002:a05:6000:144f:b0:3ee:1357:e191 with SMTP id ffacd0b85a97d-3ee8407d5ecmr2286466f8f.30.1758293885827;
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
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
Subject: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for load_script
Date: Fri, 19 Sep 2025 14:57:49 +0000
Message-ID: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add a KFuzzTest target for the load_script function to serve as a
real-world example of the framework's usage.

The load_script function is responsible for parsing the shebang line
(`#!`) of script files. This makes it an excellent candidate for
KFuzzTest, as it involves parsing user-controlled data within the
binary loading path, which is not directly exposed as a system call.

The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
how to fuzz a function that requires more involved setup - here, we only
let the fuzzer generate input for the `buf` field of struct linux_bprm,
and manually set the other fields with sensible values inside of the
FUZZ_TEST body.

To demonstrate the effectiveness of the fuzz target, a buffer overflow
bug was injected in the load_script function like so:

- buf_end = bprm->buf + sizeof(bprm->buf) - 1;
+ buf_end = bprm->buf + sizeof(bprm->buf) + 1;

Which was caught in around 40 seconds by syzkaller simultaneously
fuzzing four other targets, a realistic use case where targets are
continuously fuzzed. It also requires that the fuzzer be smart enough to
generate an input starting with `#!`.

While this bug is shallow, the fact that the bug is caught quickly and
with minimal additional code can potentially be a source of confidence
when modifying existing implementations or writing new functions.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
PR v2:
- Introduce cleanup logic in the load_script fuzz target.
---
---
 fs/binfmt_script.c             |  8 +++++
 fs/tests/binfmt_script_kfuzz.c | 58 ++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 fs/tests/binfmt_script_kfuzz.c

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 637daf6e4d45..c09f224d6d7e 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -157,3 +157,11 @@ core_initcall(init_script_binfmt);
 module_exit(exit_script_binfmt);
 MODULE_DESCRIPTION("Kernel support for scripts starting with #!");
 MODULE_LICENSE("GPL");
+
+/*
+ * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
+ * that KFuzzTest targets are built.
+ */
+#ifdef CONFIG_KFUZZTEST
+#include "tests/binfmt_script_kfuzz.c"
+#endif /* CONFIG_KFUZZTEST */
diff --git a/fs/tests/binfmt_script_kfuzz.c b/fs/tests/binfmt_script_kfuzz.c
new file mode 100644
index 000000000000..26397a465270
--- /dev/null
+++ b/fs/tests/binfmt_script_kfuzz.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * binfmt_script loader KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/binfmts.h>
+#include <linux/kfuzztest.h>
+#include <linux/slab.h>
+#include <linux/sched/mm.h>
+
+struct load_script_arg {
+	char buf[BINPRM_BUF_SIZE];
+};
+
+FUZZ_TEST(test_load_script, struct load_script_arg)
+{
+	struct linux_binprm bprm = {};
+	char *arg_page;
+
+	arg_page = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!arg_page)
+		return;
+
+	memcpy(bprm.buf, arg->buf, sizeof(bprm.buf));
+	/*
+	 * `load_script` calls remove_arg_zero, which expects argc != 0. A
+	 * static value of 1 is sufficient for fuzzing.
+	 */
+	bprm.argc = 1;
+	bprm.p = (unsigned long)arg_page + PAGE_SIZE;
+	bprm.filename = kstrdup("fuzz_script", GFP_KERNEL);
+	if (!bprm.filename)
+		goto cleanup;
+	bprm.interp = kstrdup(bprm.filename, GFP_KERNEL);
+	if (!bprm.interp)
+		goto cleanup;
+
+	bprm.mm = mm_alloc();
+	if (!bprm.mm)
+		goto cleanup;
+
+	/*
+	 * Call the target function. We expect it to fail and return an error
+	 * (e.g., at open_exec), which is fine. The goal is to survive the
+	 * initial parsing logic without crashing.
+	 */
+	load_script(&bprm);
+
+cleanup:
+	if (bprm.mm)
+		mmput(bprm.mm);
+	if (bprm.interp)
+		kfree(bprm.interp);
+	if (bprm.filename)
+		kfree(bprm.filename);
+	free_page((unsigned long)arg_page);
+}
-- 
2.51.0.470.ga7dc726c21-goog

