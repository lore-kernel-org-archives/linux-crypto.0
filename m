Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91793242D6
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246131; cv=none; b=J94F3AoYgeq2PcNdL1A9zBTaeJkAol8lH+C44P0lhT2ZOgRzvQDic9jIIzedkL5IohABGjxmuBPvlc3mN23ZwPJCLWzi+bIeRCIIewExZsS1+X71SkLDpMsiU7gsElNlIiCWMFXOOBm5itz5fVS+ZNMTLRZ1uFtQheI8SAjDiR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246131; c=relaxed/simple;
	bh=T1ghGRckBD0Pyg/AIxM0N0GOULp6cwu0eueedEPTUkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la5n0InKscziwY3yFVSWEkWBagjLyn1HaQ5C6A/jnFnHptTU2uOayglZVm+Wfpq5PFt7nwm/GaKuenytkCGXI5eIlGcrGynmpzAdvMugeD6cuy+ZVsZxFKDunsFeBuOah/tZhVY3TZJc9ndaLV91CnDAHUY42JYPM8MNf632mRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fj8J4z5o; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fj8J4z5o"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so11448282a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246128; x=1768850928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scWvVJzBtZkgblH2r+AxXX3I8YFcDE4LdHFKMGvKaXc=;
        b=fj8J4z5oMjhXk/TAPFLWoo1NqXSuMRslawhcGPlP/Qm33aBSaaumSOqBKzgCvTcrPF
         HOiRFO4cfhChzmf8byRP8PzPZK4/5AQEI3Zlug/riHXx4TeGyFrDDreD9NMQC8sp7hXi
         dSYbvic5rj6uzg6OZiPdX2R6Jk8dceoCooolWhHR8TmAKjZxvEcnrMYJWE3S7vJl2Tog
         nLl9Hz1kBKZ6bo7KcrqmsQwJ7QdqZHyRNMY7suTqA0TbhTm2QldWa+QzEw6xEhclddwp
         UUVycIOUCkLNqCxMWfW3E+Kx8pr6wAJ9O6zIhByjldBn1ep7Gcagi+Ogp7o55HEEmvbN
         9UVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246128; x=1768850928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scWvVJzBtZkgblH2r+AxXX3I8YFcDE4LdHFKMGvKaXc=;
        b=F/jYQogapg6CE1hQkWs8ISkN2K+Ux4EWVJxIwOUqHYrxUmRNSKW1IMTBsK8vIikowI
         5cNYWU2q/h9CHdcLK8MYAWToLKr2bRGVDQVCT223X5x34hT6PiyMpjmOO47kHYr/IyYJ
         Wu5rsRZWxZWw9DgfvjTNXhLh+Fqm0S2VrRfNwiR9Pue7MWhilDmvVcJbHDdfZdnkTNOD
         E8iTt5quXKJXgT9fkn15MMtwNLLYn8Un4EyqCcsRI4RKY5ezg+NAeU5cV9MFuj5zHbPg
         Nbp4q2wrs9JqjlLl0pI9ZDAG7Tcl8SsMjwMhSq8m/a1Fat4iyT6p2dlcbX4PqgXORQ49
         w5lA==
X-Forwarded-Encrypted: i=1; AJvYcCXPraMEQUtV08ez0anRtN6fRr2WuTsP5owqkAcWrQtZWHHdbP/E3F/ezJdmxw80bbJ85MWd09ZxJJE6pe8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjDOvHPopB/6CAlDT5ZcyQm2gXEShvwlhNb0X+y2Cro1S8cNEY
	rkuqmUl0ganD691PnUTQS0w+cYS5DZz5OU5tm1ZFQs7Rxi2r6L2QMPX6
X-Gm-Gg: AY/fxX5WKi0puEfMTEwlQcsajdQvAIsLxevI/cpCjakLehSlZQIGUN2+4zhgsLCSbnB
	BiPNfm1YcJHIttd4eO5aquBTCqOPbtHZKO+UGrDwfHSpIySilxm4qpB7IroCoUSHwzU5o09bkGM
	tX+RO7atzGlWipf0cxb121pmPFJK3/4i8zrMS8SiTyEXblzLi0yaVpBuuUg0bt2RdWuUEuJm+2z
	PtPWaUeI8Im2HBcUx/Dz2YMQfX8Q23BGaX7W3N5rO+Z1im3D+n5MoOtFvpJzi/U3+9HXK68J12m
	s1HcN+t3tqPcEqHgl878Fnq1MCJ4LkdNY8BKI8LYduN9Nj9VuR6V/x23VzoWPtLE3VybEQ9EkvJ
	DQjRAXxrZhZAvBLb/rTU3yQeLPvmJJdZAcUNyIyPIvEX/WmnoWExGaHJpNawSSYvGeSJgZgNUmW
	VmeSl75PRDeZ+JQVK/ll7ksfJt57fhK9bwwmQ7ZHYBnFdJxkroZw==
X-Google-Smtp-Source: AGHT+IGPfeGvnJT5nmBAHSLDQSoFK40ixCTsrNs53O6zDl7hozUe2ok/2s0XG0MJ5qFaw2WUbDeLwg==
X-Received: by 2002:a05:6402:1e8c:b0:64d:f49:52aa with SMTP id 4fb4d7f45d1cf-65097dc6439mr18130109a12.3.1768246127869;
        Mon, 12 Jan 2026 11:28:47 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:47 -0800 (PST)
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
Subject: [PATCH v4 5/6] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Mon, 12 Jan 2026 20:28:26 +0100
Message-ID: <20260112192827.25989-6-ethan.w.s.graham@gmail.com>
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

Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
rsa_parse_priv_key to serve as real-world examples of how the framework
is used.

These functions are ideal candidates for KFuzzTest as they perform
complex parsing of user-controlled data but are not directly exposed at
the syscall boundary. This makes them difficult to exercise with
traditional fuzzing tools and showcases the primary strength of the
KFuzzTest framework: providing an interface to fuzz internal functions.

To validate the effectiveness of the framework on these new targets, we
injected two artificial bugs and let syzkaller fuzz the targets in an
attempt to catch them.

The first of these was calling the asn1 decoder with an incorrect input
from pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

The second was bug deeper inside of asn1_ber_decoder itself, like so:

- for (len = 0; n > 0; n--)
+ for (len = 0; n >= 0; n--)

syzkaller was able to trigger these bugs, and the associated KASAN
slab-out-of-bounds reports, within seconds.

The targets are defined within crypto/asymmetric-keys/tests.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Use pkcs7_free_message() instead of kfree() on the success path of the
  pkcs7_parse_message fuzz target.
- Dropped Ignat Korchagin's reviewed-by due to the functional change in
  switching from kfree to pkcs7_free_message.
- Restrict introduced fuzz targets to build only when their dependencies
  (CONFIG_PKCS7_MESSAGE_PARSER and CONFIG_CRYPTO_RSA) are built-in. This
  prevents linker errors when they are configured as modules, as
  KFuzzTest symbols are not exported.
PR v3:
- Use the FUZZ_TEST_SIMPLE macro for all introduced fuzz targets as
  they each take `(data, datalen)` pairs. This also removes the need for
  explicit constraints and annotations which become implicit.
PR v2:
- Make fuzz targets also depend on the KConfig options needed for the
  functions they are fuzzing, CONFIG_PKCS7_MESSAGE_PARSER and
  CONFIG_CRYPTO_RSA respectively.
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
- Account for return value of pkcs7_parse_message, and free resources if
  the function call succeeds.
PR v1:
- Change the fuzz target build to depend on CONFIG_KFUZZTEST=y,
  eliminating the need for a separate config option for each individual
  file as suggested by Ignat Korchagin.
- Remove KFUZZTEST_EXPECT_LE on the length of the `key` field inside of
  the fuzz targets. A maximum length is now set inside of the core input
  parsing logic.
RFC v2:
- Move KFuzzTest targets outside of the source files into dedicated
  _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
  Ignat Korchagin and Eric Biggers.
---
---
 crypto/asymmetric_keys/Makefile               |  2 ++
 crypto/asymmetric_keys/tests/Makefile         |  4 ++++
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 18 ++++++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 24 +++++++++++++++++++
 4 files changed, 48 insertions(+)
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index bc65d3b98dcb..77b825aee6b2 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -67,6 +67,8 @@ obj-$(CONFIG_PKCS7_TEST_KEY) += pkcs7_test_key.o
 pkcs7_test_key-y := \
 	pkcs7_key_type.o
 
+obj-y += tests/
+
 #
 # Signed PE binary-wrapped key handling
 #
diff --git a/crypto/asymmetric_keys/tests/Makefile b/crypto/asymmetric_keys/tests/Makefile
new file mode 100644
index 000000000000..b43aa769e2ce
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,4 @@
+pkcs7-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(filter y, $(CONFIG_PKCS7_MESSAGE_PARSER)))
+rsa-helper-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(filter y, $(CONFIG_CRYPTO_RSA)))
+obj-$(pkcs7-kfuzz-y) += pkcs7_kfuzz.o
+obj-$(rsa-helper-kfuzz-y) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..2e1a59fb6035
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/pkcs7.h>
+#include <linux/kfuzztest.h>
+
+FUZZ_TEST_SIMPLE(test_pkcs7_parse_message)
+{
+	struct pkcs7_message *msg;
+
+	msg = pkcs7_parse_message(data, datalen);
+	if (msg && !IS_ERR(msg))
+		pkcs7_free_message(msg);
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..e45e8fa53190
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/internal/rsa.h>
+#include <linux/kfuzztest.h>
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_pub_key)
+{
+	struct rsa_key out;
+
+	rsa_parse_pub_key(&out, data, datalen);
+	return 0;
+}
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_priv_key)
+{
+	struct rsa_key out;
+
+	rsa_parse_priv_key(&out, data, datalen);
+	return 0;
+}
-- 
2.51.0

