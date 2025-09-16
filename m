Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADADA29B233
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013293; cv=none; b=PXHijfRN36p4OScUYNTOgy3CUop4XMT1I0YF9fevtC+AyBydjmd0yyzQBvMBGA1Bz+Y8nexC4AHTVR8Pt3rUEF/EYIrhpofc7AyytY4/LC0FwkRe1Tgt9Vv7ZUt/DhggxK8n1AeJlEtmFPqh6DyPyirKdu5AGo+UpBekxtnV8bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013293; c=relaxed/simple;
	bh=b4STATL0Uju972ND8+fFwA9UTCoZh60N0y2XfSf6TNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqPw45jeW7cJnGpLc0ckwgDrnW8U8PAuRBoafAS6VS4B5M9BdTP5d0LOBwLkCi787ljKycls3jyxJQnEBy1czOH2zNDCtTskzrjI5Ds1OcNz3LxFdidFLTU/5GlEzCrJshhSxnfcIC0/jrbfCC28WChZjRVk3gAtQDEtnx/fkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U8IoFben; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8IoFben"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45de1084868so28103005e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013290; x=1758618090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54a6vrNAUJqXpuCeRFEgTKA2RP5sTalC0x0PuLBwSM4=;
        b=U8IoFbenmzVYutBdqet8d9Ceo8HAGhVzkmj3bYsgqUZbOsbCpQgR8SXa36jpm8kmcg
         vBeBRCjDmwKisWBHwVKafk58CX5FnBKWO2qggwnm5SsPoMdRWHtf8KKgyAKs53Q5HIUA
         lsLqiLezkGPLY/keh6uhm0MdYECBt3UVpFhHKmJz0FKrEXvuHK5zFOFMCPV1ZtOn96HY
         Zwu/twwxnaXEyH9gLqlKxRVLSzmACRCuNiLW7q68p9NF4lSB0fH5GHTc1I+1B+s/Mc8M
         zFDWMy9PHoMbr/zmfj9s5n3nTpDVqCU6rQQ39dLrL03cGWF1GOI5d9e2J2kEYC8qZ8o4
         PHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013290; x=1758618090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54a6vrNAUJqXpuCeRFEgTKA2RP5sTalC0x0PuLBwSM4=;
        b=NM2iAze3PYtnScKEyZp+wefmIhvRo5j5AYQ/pJu/YvGbmbznfw0npwtBYaB58sm9Wx
         wOmA4EyxUB9q6qTEPC5ADb6jPhzAZpfBmmsJtey2i3W0Msgm3nHeVcxTvzMXgJ8v+OjC
         N2ya33/vHOP9d7m3jrRrj+fpZJWDbwvHPiGoNEYPnUhS2UN3ebDfT3Ec4Z83T8vVznUN
         r7puNIuBmoC5NL2+4ha94kgq34VtP90E2zEKeBdoIITnlOC65fJfjysn4htSvXUk+TdX
         4FRLjsT8pssS01QaK8y+cjuwNkKwvdGI4AohJ6HB8ddPFnFucM3jSwxfjNtWoTbLqaIm
         TdiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1luEewAYS2bgk1XXKjpd4IYk232HVyxyZwSEnlJGhN/w3dcasg7JY8VK8Pd+V/4hdgZvDEA8awKNERTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YykYCvCnB4TQFHFxI2PLN33l3SOOQYbSGMx0i3qFAuc3emfLgdt
	UPkgEwwK3s8FZzdDhG6tOEp2n7OI8imwbwM1627hT8si8mW7LevwHTJX
X-Gm-Gg: ASbGncucTEWpUR61V9rAULqbb/i4Vv9JOyq4cuhgqBUXUngajNyAfEw9QrWh8eqstzO
	AeeBuQej6RxBpiGlDGGYHoga9NiKW3dTgz2b5pEKphA2+gYx2iKUgv64YQjigfj3iCDzMSpaxwW
	miyuAV5135HUXz8qLA4VYwfEGBuLROAT8eMV5Q8JVa8NdWS2cA66ulYX6WQ/FwpTzeBg41qs3Kn
	TBt/1BCk4gGalFbOQAbopVXP938m81DdvOwLBX4xoKsJO+Jz0U0PBlnky2jkIyFmLMFoUUnfjaq
	3W13oH8NSZDe8cEzvn6jpOV49/RqWuUZhZJej/guFNRMNgigl56IurAkb7j5itr6+FCijiWFNkZ
	lu9wfAd8UayVR8PLcV7TZ9zyC97mNwAwACiGBNzFYNFzcn9N8O6w0TpCQG/3THbCYWRV5hzq7Zf
	T3DmKymcX0a3hB
X-Google-Smtp-Source: AGHT+IGQ/nVkVKJ3q2nqGsYpu+DG+PZAA8Y4Ac4hVZt9d7cPYhzkDVimhmHreOcxPfvEMqJ6F549CQ==
X-Received: by 2002:a05:600c:4446:b0:45d:f7e4:bf61 with SMTP id 5b1f17b1804b1-45f27ceb2f2mr101342565e9.4.1758013289608;
        Tue, 16 Sep 2025 02:01:29 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:28 -0700 (PDT)
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
	tarasmadan@google.com
Subject: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for load_script
Date: Tue, 16 Sep 2025 09:01:08 +0000
Message-ID: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
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
 fs/binfmt_script.c             |  8 ++++++
 fs/tests/binfmt_script_kfuzz.c | 51 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
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
index 000000000000..9db2fb5a7f66
--- /dev/null
+++ b/fs/tests/binfmt_script_kfuzz.c
@@ -0,0 +1,51 @@
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
+	bprm.filename = "fuzz_script";
+	bprm.interp = bprm.filename;
+
+	bprm.mm = mm_alloc();
+	if (!bprm.mm) {
+		free_page((unsigned long)arg_page);
+		return;
+	}
+
+	/*
+	 * Call the target function. We expect it to fail and return an error
+	 * (e.g., at open_exec), which is fine. The goal is to survive the
+	 * initial parsing logic without crashing.
+	 */
+	load_script(&bprm);
+
+	if (bprm.mm)
+		mmput(bprm.mm);
+	free_page((unsigned long)arg_page);
+}
-- 
2.51.0.384.g4c02a37b29-goog

