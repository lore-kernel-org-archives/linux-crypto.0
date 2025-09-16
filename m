Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A429B77C
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013293; cv=none; b=nzpMpVB5Zq3NViaPcYzy9Fi1pfxxUQk2rdFGy7FG87UojoAWOv/0Uvf9TAY9inss9pYFqMqkLsSzFIURN0HtXdfY08raNhCWFE5+EJxlFXoZuV7ynKCjYQ0ddMuYYl0bdNXHLSFIrPbeUsC6Reia3rntGfYODetrFxgisG3d/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013293; c=relaxed/simple;
	bh=JJCw6mv16EeG+3BtXxjY/l2oWcIXNWBdkiWvUlFHp88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b16/3LwzlyjkZGnaSV97V7VuFLHNWJQ9W0yducZ3/1STS5Ptlz27GvuEUnPgVrpyp5V64O8cl8NuAnBzU/EOwJuu0n6uvZ684W0z1frBdDinqdvsB/vx0HUtdlNTswyj/D9Ml8BO+1wrHSXL0+XQIi6I3+f/Cgqm3igRhgTXkZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N58pLXJ6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N58pLXJ6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45e03730f83so23923565e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013288; x=1758618088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO9AFhAl9ilu83R9AZsAc7oWiIru4g9kqtmWSFQA0xE=;
        b=N58pLXJ6T0qHU3h2Zwf7fuXi6gHhTD6H1TRqgoxFYisWjb8hZg+7Mkeg0e4cMlY5FH
         PZuZo9hYshBC83rNwd0WYy6b+AtaFa9GrHZklM+8cdQXec15oatowoCs9l3MjheAaz9f
         57sNME+3wnVwYHgcnR3LBfkAoDqGswjRbONRx3c5pYxpKJzOtNKbIUlczKwsi6PSCUZI
         aCNhd4HaJ8cllZnffPrOQUabKK9AhOq4/Z3YHRHUb+hQu7XdBcLwGIPSHWQALuzEbpli
         tlcUsUycnugwmAcW47dzMwul7hjxjYim29OQEHK5My0ddYRjfBlmxuzhTSoBbR/hyRGK
         F07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013288; x=1758618088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DO9AFhAl9ilu83R9AZsAc7oWiIru4g9kqtmWSFQA0xE=;
        b=neTgf2q5NmU5tYclhUqnibqc6hzLw1ZGSROeIIMYBiYFRFuRl3zN/uSjAa2+aK7Yux
         tKT2oSNUTCKk7dcxpmwYF6hwtPhgJIyKSICJI34WM/id9GwwEj0g89bfZgJZ7z3OXzwf
         uZiJHmfDhUT9gOY7JUPV9RRE7iIO7pQYr/YnyxsAAyYrJTQF5MwQ3n6vQSuSmMrRVdt5
         z8LPl7H85VYVprlzMlrc2OGLb7JwoI7qudwZeZtlmN3DBoIA0eRAG6bUmostsAmIzLFK
         C+6iVr7tG4bpIqkM5OYiWHhCShf5Gw6kfXUFuGma7tLBnfbbam9jD+OhOLtVl0cSazKz
         16jA==
X-Forwarded-Encrypted: i=1; AJvYcCX1FSiQVlh2YH4qpqRC7x4TQUwqZikev+AxzSmarawrnDft5MH1lKjFKFCAz5G/7aFDO8+vNMR3cU+BP44=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2RD5CZqVafqgS2Y2TBnNL36moQXuim0UwMLJsHlBzMqylPlNP
	EPBtgP7HRLYmMm5s64fWB8D1BoC3iBmg4ap1X6rl+nC/gaQ3LugeLpIm
X-Gm-Gg: ASbGncuJ9q1ih3j2ujZdjZgRtuRD+ml0TOetAkc6vDhIhxeFVGB0nCGAc2pBLvJx2do
	NkY0zsqw7c3yCEZnxprbIq9qsoRH/kv92DMTNLTfEd6E6EkCh3IUlSCcRCZux0VP993iexIbWz2
	PsMzZSJGQgcKKThb769iX9lEeTqZGABOEBlBY0M8/WjRWCdJI5N/ofJ1V9wFNAbVZLEZniApX0F
	uYgw72rD6SB9va25ixbjVDOdKMI4rZmNjLg5sEfxI2qNSkuusL9V0afp8Bj4a62AOjQmJxH8E0d
	DMpJ/YfCfZK1Y0xDP3UIte5YhC6PU3cdPg4jYLS0Xaj8jwI0Dmm+ubJGkvXUBJ1T4+OS0jQ/PyD
	U+eSojMMOOcPmNUsnnukNSBMqtKyjLyVMrZ1M7Uhq4dOO87E9lv21XzRp5rlCrhzAcUdC+ojrnl
	9gez0Y0BU3xsxGzqmPuPLEMsw=
X-Google-Smtp-Source: AGHT+IGotFF9hMuk2BHhjmZio101NvNZ9u1/TzQ6HKksgBv+fiil5SUdoiHKC9mTRtqP9GooBIX06A==
X-Received: by 2002:a05:600c:3b87:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-45f2d345de3mr59942395e9.3.1758013288120;
        Tue, 16 Sep 2025 02:01:28 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:27 -0700 (PDT)
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
Subject: [PATCH v1 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Tue, 16 Sep 2025 09:01:07 +0000
Message-ID: <20250916090109.91132-9-ethan.w.s.graham@gmail.com>
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

Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
file under /drivers/auxdisplay/tests.

To validate the correctness and effectiveness of this KFuzzTest target,
a bug was injected into parse_xy() like so:

drivers/auxdisplay/charlcd.c:179
- s = p;
+ s = p + 1;

Although a simple off-by-one bug, it requires a specific input sequence
in order to trigger it, thus demonstrating the power of pairing
KFuzzTest with a coverage-guided fuzzer like syzkaller.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 drivers/auxdisplay/charlcd.c             |  8 ++++++++
 drivers/auxdisplay/tests/charlcd_kfuzz.c | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 09020bb8ad15..e079b5a9c93c 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
 
 MODULE_DESCRIPTION("Character LCD core support");
 MODULE_LICENSE("GPL");
+
+/*
+ * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
+ * that KFuzzTest targets are built.
+ */
+#ifdef CONFIG_KFUZZTEST
+#include "tests/charlcd_kfuzz.c"
+#endif /* CONFIG_KFUZZTEST */
diff --git a/drivers/auxdisplay/tests/charlcd_kfuzz.c b/drivers/auxdisplay/tests/charlcd_kfuzz.c
new file mode 100644
index 000000000000..28ce7069c65c
--- /dev/null
+++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * charlcd KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+struct parse_xy_arg {
+	const char *s;
+};
+
+FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
+{
+	unsigned long x, y;
+
+	KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
+	KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
+	parse_xy(arg->s, &x, &y);
+}
-- 
2.51.0.384.g4c02a37b29-goog

