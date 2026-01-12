Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4527531ED64
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246130; cv=none; b=abOfRfNOkC8bBls3oQR+VB0mVvlOQqdyzqTBRtV34Ff9dJvIA6sIyL44sqQ+AnxklzCdsYuOg7gWcVDbIO2XeDIk/RiyaKBx8VYSu1F5OYVE9IFZ3j8x6AHxFsaTKu1EoKCCvfFfiCRgmiZvGIklync4whcl51yNqbdBM455Gp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246130; c=relaxed/simple;
	bh=wMDRutPxox6hkPyPznb4TybXdAVmmts7fn8xxj+1g5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGlNIGniXsWCzSrf5lPXQS/1fHoZiY1Cr/sYFO4RUyzd40sbiJ92vfUaHK5iS2/2lY4OBil1Hy/fNlHNGb5ir2zzCv/XTshVFFnypz/xG8rInnHxM3815ZI1rK63IYCN794R4wY2sExkeuS8ldXFSKtp39yzzrUolCAs0c96ouE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A72aTiFZ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A72aTiFZ"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b86f69bbe60so244008966b.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246127; x=1768850927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYn/cfzIUiLg8O0jmeN0oIUjcH6e7FhIiA9EkVEqfyc=;
        b=A72aTiFZspKlLlgZYax1P8HDpOEO2xHOiGMYgnPRbYrNSHj3vKsdHpmtr3xm5D3JSL
         9H9K4tKuGImpsJro5mPs68y1uNQYdVpAK5G/3F2Yp9QyIEZxt9OQl6YraVyAqCgf95Wu
         mIzAdj6At6bh8mWmHsCIzINhu7lo6ml7WHbA8RF1JGPgfVXF499NTk/SQh8Vpsm4Qztq
         IXqmLza+Tr9wIr7w9WGy9+6NHdvMm7CrJA/di54Eo3ZqKpBI9XBbSf1YuOYXr0pNrd/c
         BVlXw4bCMp48l61QVRNLlDNhtVfn68lI9vrHawc13zCWeIB6hiIKbFT2XDXBzmzcSKM1
         YV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246127; x=1768850927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYn/cfzIUiLg8O0jmeN0oIUjcH6e7FhIiA9EkVEqfyc=;
        b=mklP216WnejnJb5PE1Qb7722y7h1f7vxoROhxnWh9Rs6FGRrYRthxMJxkIY7Q1bDKJ
         9Snf9TOV1I4Gl8n6zNdLq/T0J/6I/K8kHssuacJN3M4c6gLobLt6t9eRPaebS0afd4fg
         ToXG7QAHyN9m8LkvsYCKwMRb5SQK+T6zwhaMAwlqISaZF9GoA972tVjkIBwckdPjX5Ut
         awD/xq+yRbftrAZSH0/lXyeBjYuGx/g0pLMnrxQaWVz0fZdyo/OqepsCfJEn56kL6/Or
         fWqHnCHQ/AIoJUFtuW2HaKo1VnbEHhGnwOStM0Q7pTs7ohP4ShvrQPfajkTJZCh6gmyx
         72AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVKgWBf0Px5wKD5/iHBddIFs3Pc/06CmX+62HNtwr9KInaASc7UazWZbdDe89xna+kvH0ahc/ehwE3hP8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/hizP3YqWICuDPdZkyENmlQ7Q+Eq1dcXONvmZyF+MJ0jTP58m
	Gzy13rgwidsb8ADIvVHcW1eGs+8X3tluIw7gHHUH578TEEv8KytEppW4
X-Gm-Gg: AY/fxX5LLP+9S5Qag6hDxt2rCqiUxkR0tmoH6hNlMYCtndDZsGdxxYF+wq9zyOcX0sM
	obpIu+ah6bS4T8WdkHLLQGypIxMV/7RxJbr9FCvZ4AEwk4uzmMdMd8u1fZYTh4z6AcTXcAnM7e/
	lmvVO8MEucHd7JdNEOFtOj5FrcfZGE+nrN6ymiX7Tr+VWrrD+QqjodNDOHe4O2JN5F8TOKZXDef
	uxlTBSAgOkyZA5IsRCYXtCydM2hQn0czmb6XY+JHIydRNDcMt5o3hOXpvxREVtBrV/8T42MZ4CS
	rYZLtaTa9afqTwkNxNoggv6x9Bmo5WRizDd2abRdsYSAcY7TQm4gvfawcVKlSv+UqCcdEYL+LEU
	11JwLNHLTnVjk+oNc58vBWaI83VW9FTzmZbtE2x1zYkRWSv2QAMXeRYMdPL+Wiq09CL0gaaUxZa
	SdKvKN+INqo6v8lHkeHXtOU+kl9DtOH3xV91jFfTUvwZwEDL3pcw==
X-Google-Smtp-Source: AGHT+IF4pPwfnNX2FK6K6VgQD0pVFZdgZJNgLaaNTxNX+cYNIN/F+0YErplY46SPSS0fwiEVEMONCQ==
X-Received: by 2002:a17:906:9f87:b0:b73:2b08:ac70 with SMTP id a640c23a62f3a-b844539fc4fmr1937923066b.49.1768246126219;
        Mon, 12 Jan 2026 11:28:46 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:45 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
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
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
Date: Mon, 12 Jan 2026 20:28:25 +0100
Message-ID: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two simple fuzz target samples to demonstrate the KFuzzTest API and
provide basic self-tests for the framework.

These examples showcase how a developer can define a fuzz target using
the FUZZ_TEST_SIMPLE() macro. It also serves as a runtime sanity check,
ensuring that the framework correctly passes the input buffer and that
KASAN correctly detects out-of-bounds memory accesses (in this case, a
buffer underflow) on the allocated test data.

This target can be fuzzed naively by writing random data into the
debugfs 'input_simple' file and verifying that the KASAN report is
triggered.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v4:
- Remove the `test_underflow_on_nested_buffer` sample target which
  relied on the now removed `FUZZ_TEST` macro.
- Update the sample comment to demonstrate naive fuzzing (using `head`)
  instead of the removed bridge tool.
- Fix stale comments referencing internal layout structures.
PR v3:
- Use the FUZZ_TEST_SIMPLE macro in the `underflow_on_buffer` sample
  fuzz target instead of FUZZ_TEST.
PR v2:
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
---
---
 samples/Kconfig                         |  7 ++++
 samples/Makefile                        |  1 +
 samples/kfuzztest/Makefile              |  3 ++
 samples/kfuzztest/underflow_on_buffer.c | 52 +++++++++++++++++++++++++
 4 files changed, 63 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 6e072a5f1ed8..303a9831d404 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -320,6 +320,13 @@ config SAMPLE_HUNG_TASK
 	  Reading these files with multiple processes triggers hung task
 	  detection by holding locks for a long time (256 seconds).
 
+config SAMPLE_KFUZZTEST
+	bool "Build KFuzzTest sample targets"
+	depends on KFUZZTEST
+	help
+	  Build KFuzzTest sample targets that serve as selftests for raw input
+	  delivery and KASAN out-of-bounds detection.
+
 source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8..3a0e7f744f44 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -44,4 +44,5 @@ obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
+obj-$(CONFIG_SAMPLE_KFUZZTEST)		+= kfuzztest/
 obj-$(CONFIG_SAMPLE_TSM_MR)		+= tsm-mr/
diff --git a/samples/kfuzztest/Makefile b/samples/kfuzztest/Makefile
new file mode 100644
index 000000000000..2dc5d424824d
--- /dev/null
+++ b/samples/kfuzztest/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_SAMPLE_KFUZZTEST) += underflow_on_buffer.o
diff --git a/samples/kfuzztest/underflow_on_buffer.c b/samples/kfuzztest/underflow_on_buffer.c
new file mode 100644
index 000000000000..5568c5e6be7a
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * test_underflow_on_buffer - a sample fuzz target
+ *
+ * This sample fuzz target serves to illustrate the usage of the
+ * FUZZ_TEST_SIMPLE macro, as well as provide a sort of self-test that KFuzzTest
+ * functions correctly for trivial fuzz targets. In KASAN builds, fuzzing this
+ * harness should trigger a report for every input (provided that its length is
+ * greater than 0 and less than KFUZZTEST_MAX_INPUT_SIZE).
+ *
+ * This harness can be invoked (naively) like so:
+ * head -c 128 /dev/urandom > \
+ *	/sys/kernel/debug/kfuzztest/test_underflow_on_buffer/input_simple
+ */
+#include <linux/kfuzztest.h>
+
+static void underflow_on_buffer(char *buf, size_t buflen)
+{
+	size_t i;
+
+	/*
+	 * Print the address range of `buf` to allow correlation with the
+	 * subsequent KASAN report.
+	 */
+	pr_info("buf = [%px, %px)", buf, buf + buflen);
+
+	/* First ensure that all bytes in `buf` are accessible. */
+	for (i = 0; i < buflen; i++)
+		READ_ONCE(buf[i]);
+	/*
+	 * Provoke a buffer underflow on the first byte preceding `buf`,
+	 * triggering a KASAN report.
+	 */
+	READ_ONCE(*((char *)buf - 1));
+}
+
+/**
+ * Define the fuzz target. This wrapper ensures that the `underflow_on_buffer`
+ * function is invoked with the data provided from userspace.
+ */
+FUZZ_TEST_SIMPLE(test_underflow_on_buffer)
+{
+	underflow_on_buffer(data, datalen);
+	return 0;
+}
-- 
2.51.0

