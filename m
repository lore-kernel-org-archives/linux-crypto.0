Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8272D1FDE20
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080321; cv=none; b=hTEedRhjZ8v1tkKvNpnsvO0zQmOBslt/LcE0zbdj9DbObJuzhIKUjwh9df4Zalf4JDpRXHoajgOh//qqEIblAVb/TRm21Nx+5duImt1Wmv6GLprUJS7UAIbf5kyaThzvqUhS1xVcX7Z2TQfLi9NLt/C73FQkJWClAm9zBqbNxUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080321; c=relaxed/simple;
	bh=D2pcj7eNNhKsXgn3XF0f/0vqaucKJ4Nfaio7BEZzV6o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EeMSVlOi9DduwyjppWR/pMzI+D4UFDSvhZbi3OgCiLG/pqtpxCUR5nw2IpgHM8foKKQ1sNg4ZuYU8AzXFSRkxVyUcY2vXiigo8EDs0eDX6Hx5Mz2XCEsy1nl5tTO5zAhnVv28LK5iXIkrKcgc4JfxUEGjREwGkwC9hRlsKslOeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vs8i/HV6; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vs8i/HV6"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39101511442so1075827f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080317; x=1741685117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pBc/zi9P1R3Zwtykno3mWYwrt7ORJZX5qCpzJBRDBb8=;
        b=vs8i/HV6DjeHWQAQxEQCNitaVYS8XL9+trpbOHP1l4G/my82PKizypDOWhD/EgaXqc
         0Hv33SmCakD1i6cHlzoK8Yn7WvrMaaIkN2PMzPNNHBXVWIJK3xkk7h2jmxM7dmPFzjC0
         caWTr6DUwaCVPNegfLSC+pZIR546MFC1tX1MNwmUMOUeShMUlskTlTwTVKibldL11QN2
         WNsd8wjtP7TpVaHFIWP3ktrz/KR+6HvqpaAJTzg+2IqG/h1RiB8TtjUT06o0O6X8lohU
         KA4KZ9F7ML3czkQk2twoOEfRLhVUEs10pKfabJzKEIVXaQ5LE9fsvHDAls9+qXN2qF45
         JNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080317; x=1741685117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBc/zi9P1R3Zwtykno3mWYwrt7ORJZX5qCpzJBRDBb8=;
        b=veetX+CCQF6acEj4XUkleh1+UoeASo7y7P2itaGJ1BsL8oVgpGJulUfH0B/biLy7Qa
         6GlIOOzTnUMyIfzzmZ+5tDsQ+uJ5uGcxHdk77ARSgxs56arcgDI50CqME53YiRFJTQQB
         sil7KVNnErzTdqHjAZirRel6QF960SHEBjU90QvGs31VEw+Ns/4xrvYeBBtes8L1wGmA
         S7kUVEHhg3HnnVIzW5V4xk00+DrYhwI1PU7D5y0Wuq6YpVh2jFLINkLIIWHLAqZK54nm
         W1+Bb3B0unMWOIlVDfhJ/GIm5JyBDk9Rdz52BToRPhx/s8FHp0u5/1zIAdXY0DYva1uT
         O6Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUkpN5dZ2l2XQV9Ys6EZzjU7djxoug2M7GYXUa5Dm7CcfMVavPcvSWLXdIPTo6+K+g5v1LHg7fF40ezC/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCEilxZFeXtoOmr++HyX/6PHMtG9DoPBNxUdpfoJt5lebQ1GoI
	tPsTKB1eVzg2cRH4gPVbtGP/SEvpyPX8yN0k0NNSkO0ENpqTSGq9pWMowPcr5VgOQUXk5So83Q=
	=
X-Google-Smtp-Source: AGHT+IGQB/YIYjs3mcCeFc0d30zRBIg9YuV3qxz71mKDL9Wrd0L0zSrw4Y93Il/Zy6Ca4Q/8RxD18WTRwQ==
X-Received: from wmbfp9.prod.google.com ([2002:a05:600c:6989:b0:43b:c927:5a4d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:186c:b0:390:f0ff:2c10
 with SMTP id ffacd0b85a97d-3911561abacmr1839931f8f.19.1741080316822; Tue, 04
 Mar 2025 01:25:16 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:02 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-4-elver@google.com>
Subject: [PATCH v2 03/34] compiler-capability-analysis: Add test stub
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
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
index f30099051294..8abaf7dab3f8 100644
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
2.48.1.711.g2feabab25a-goog

