Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6219DF9A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865879; cv=none; b=azI0y9Dhd5JY3OjLOXGsx3aZacuWaok2PJUtm7tKDo4IPHHGjHFvbcCAx2IAGANHZYSCqJ6gYq78nrOoUGJY1SjwDDFT8Wo2tKIQnvVkoAjOZdduzKocmvITM1G5VChXCqLG1UskK4kLbHggO+8UV6C/KaJc2plXUG/adU/QogA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865879; c=relaxed/simple;
	bh=xGjyV1mmuJOCMCkvKm/wdONdE3U0T4zFS8a+y0DCXOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=drtiC0GGHQRQCOK9Kx/4ARyn3JtucFNmsZ9vV3VqkcHO6St2Z8jv4gmnKarRbn0VtzELm8CXndl5VxZXBw5YmhCtMuhQirP8pfx7dx41gKlx6Vy7KydrgGpf14zosDlj/nT/Ye4BEAugPwBls4w2CvwhNBMqwb5T64Lnz04j+/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnwHMmxz; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnwHMmxz"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5dcef33edc8so1097599a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865876; x=1739470676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NkeMRttk3RYqT58NIYnzD7f2BrALmFrVkg1AkAEzinM=;
        b=jnwHMmxz31HO/SuKyVJLKnLoGlliGxLEh188YIEnq/kE1q2O441gQWrcroUHGVbFBd
         RQlr5FMtjFkA8Re/cURU8cn7tZTW7q5tV17z6pNzvdC1086RUGMu+uygO6/dMYbXmY2B
         C88qaNjwSAyrGcZ83l85dC6RXp4eoyDuw7hkcqHRBjahckpzh4h9EucC2X0GYLkfhiib
         1ouyyCBpDKneCs3tgyu3BS8BL4g5bWkZXAaBKQQ3A5AV12DONxn2EYu4W4GUMOIJ0CiC
         K89XdYPq4GxoCf/HRIZUHhWWV6Yz1yuUYvXt8+XeKDWYMA8fmmuMhZzsQ69CBfqiAoIO
         217w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865876; x=1739470676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkeMRttk3RYqT58NIYnzD7f2BrALmFrVkg1AkAEzinM=;
        b=sdCF6tQE+sMPM9HgcsPaMRLEbnxmHBIUbV+xDcX/14+Y/O4y2ugK0/vbwCO9s3a45q
         lOy+ihKozqwI9D2uQy2FS00+X0GAsVHrlRgQpt3eCgnOHWQHimn3TNigYAMtVM33/j89
         ebJG7r81ne+qFRWFeMx7QZq4gOoEM4rCiP0eZl6M52bl/Z4OiLYGVK56TDvb+vEW/Cn4
         iixYSa8YREfleSGKDtarrxz9vqgrDhfuk1AgXxzbMU+dIMaf2wxtUOBTohPJS9mEtYGi
         yCurAvJ0kpeivdO52kKuQc20rlh5U4BfDxbwzBmVxBEzYfiTVijzLOOkNqupdpoaG2sF
         geAg==
X-Forwarded-Encrypted: i=1; AJvYcCVYil4LCQtixnG8hVt6qQVGkoZnb2CorHD+AaRxDfMjtmg4aJBuf+W8XK57K55dBbIFdiuvt/spDPrQelQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJsvsjd+zO2r9fDkGqhPDMqN4Tk7Z0p2LAM71rBClRkNdgNkyk
	8GMBlc4PdFsoBgLg3KRvJXsDiZYrFGGXtY93ed0VuUwlFFJeM8HgRHA5WqiMXGPo5MlUICngyA=
	=
X-Google-Smtp-Source: AGHT+IGXY3SpDaruUK6VARumHi3XqNDM2oza8GEyGvEbUTnudtsurff0yLICaOG9kxpXPQLackltedLCRQ==
X-Received: from edat29.prod.google.com ([2002:a05:6402:241d:b0:5dc:764b:8e16])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2801:b0:5dc:d31a:398d
 with SMTP id 4fb4d7f45d1cf-5de450059cbmr548326a12.10.1738865875912; Thu, 06
 Feb 2025 10:17:55 -0800 (PST)
Date: Thu,  6 Feb 2025 19:09:58 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-5-elver@google.com>
Subject: [PATCH RFC 04/24] compiler-capability-analysis: Add test stub
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a simple test stub where we will add common supported patterns that
should not generate false positive of each new supported capability.

Signed-off-by: Marco Elver <elver@google.com>
---
 lib/Kconfig.debug              | 14 ++++++++++++++
 lib/Makefile                   |  3 +++
 lib/test_capability-analysis.c | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)
 create mode 100644 lib/test_capability-analysis.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 801ad28fe6d7..b76fa3dc59ec 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2764,6 +2764,20 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config CAPABILITY_ANALYSIS_TEST
+	bool "Compiler capability-analysis warnings test"
+	depends on EXPERT
+	help
+	  This builds the test for compiler-based capability analysis. The test
+	  does not add executable code to the kernel, but is meant to test that
+	  common patterns supported by the analysis do not result in false
+	  positive warnings.
+
+	  When adding support for new capabilities, it is strongly recommended
+	  to add supported patterns to this test.
+
+	  If unsure, say N.
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index d5cfc7afbbb8..1dbb59175eb0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -394,6 +394,9 @@ obj-$(CONFIG_CRC_KUNIT_TEST) += crc_kunit.o
 obj-$(CONFIG_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 
+CAPABILITY_ANALYSIS_test_capability-analysis.o := y
+obj-$(CONFIG_CAPABILITY_ANALYSIS_TEST) += test_capability-analysis.o
+
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
new file mode 100644
index 000000000000..a0adacce30ff
--- /dev/null
+++ b/lib/test_capability-analysis.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Compile-only tests for common patterns that should not generate false
+ * positive errors when compiled with Clang's capability analysis.
+ */
+
+#include <linux/build_bug.h>
+
+/*
+ * Test that helper macros work as expected.
+ */
+static void __used test_common_helpers(void)
+{
+	BUILD_BUG_ON(capability_unsafe(3) != 3); /* plain expression */
+	BUILD_BUG_ON(capability_unsafe((void)2; 3;) != 3); /* does not swallow semi-colon */
+	BUILD_BUG_ON(capability_unsafe((void)2, 3) != 3); /* does not swallow commas */
+	capability_unsafe(do { } while (0)); /* works with void statements */
+}
-- 
2.48.1.502.g6dc24dfdaf-goog

