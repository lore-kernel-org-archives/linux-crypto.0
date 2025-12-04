Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE8342CA7
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857602; cv=none; b=FqhWMkivJMc6/cLG2jBToiuqGbVZlIfKqTmQLRdkuTV5rF6JAq1kf//qTgdHPooW913bQBrojsVbcVeRbtmKccImE+QV1ppIaw0HysI5rFwrRn5pK+qhm9XSNhQxvFMb6gXtoNCKYjDCzCzZjQdn0kEd/P8kVOg001E4IkW4x+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857602; c=relaxed/simple;
	bh=TnJsqKSnzKIC0iSPoujmB0qizXCqm6TL46n3TvXH0Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSm9nI12LPQewotLq4AJzHVGQt7z1qi5mhbOKLsh9MzEY7afE1RQx+cdJ24DVa1Q2H14+/r0OqOJSUDfJBRWX04WgwzhGfzUPbodXMtkcNAHvg4bmsRbvmTOS3iXndrrDM2uj6PZXlArKiY48dmllWpf2Wfz0AJ2ObZLlkUzvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjzNgMOr; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjzNgMOr"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b38de7940so564605f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857596; x=1765462396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RabXc9ZxWPd5N856tl6EMMSdBPz7PelUrbPrIKztc18=;
        b=EjzNgMOrXM32j0zQjTcDbpsZPHyd1lrvWD4NN3/4aWetz0z4L8mg6qmDWB1pEhaHaY
         kcnCaVmx4OhUH9xoN35jj54HHeiFQdLkZzoHYQ06ttDXzxOGRymU5SjSLU7KcU6oJsiA
         zt6wdV/xvIFlBNId3P+P/ERdCc8weseOUImH5E5JyvpD1qKujw0kEM6oO3wxQMOwfeQP
         UTqr5BU67JkRkdSXj83aCxFIwlLi+wldYyyZlOtN7zljx5qZqRWdwi9tC0a13CTWgLq5
         9gJjwMVEal3vVzF5ZALnoCwFimoq0fhWeP9tkzqWO1o0QgZum2Ww314Re+ilmWms4w7j
         teUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857596; x=1765462396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RabXc9ZxWPd5N856tl6EMMSdBPz7PelUrbPrIKztc18=;
        b=Qzd3wAO5DalcVWat+UpHZ/wil1huw+vq7t/sv2dOqtXdhS5G7X3CIem3or6CTBXLLE
         oGU8QNdzfd9rOR3P+9A35gBk+FLi8+Ju5XB/ATNap2j07Yl/ok2979DBNyrepGcTJ7bl
         IIhhmL/UsdX2kz7zXxaT8tg9wD/LvK7DSfKOAy74rksQE2q9WuDABNCoy897CjM8a5zX
         Ob54B/HLth1I3mvz1dN9d5pxmVGf0D5tKPYqGWnhfmMUN1yS8GGZc4RvYP1k7oFP6RiS
         79Bz2+1WXjX5TpUFk3I9zzmzCvQnyORZ8KEYPtKsvBR6WBMOKk6IvOU/KPc4CK0RoeeU
         T2Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWQHifBm6GZQHhAo141FyzT8lhnEeYW65A6qHEkNnuIBqb2LwryfFe9W+4D/Zpgo14oPkOIxqj6UbCa5kU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwamQN7Msbwu5l1TZBik7fFXCWKKL4cPwEtjrmJwhqWseeZY14Q
	gf6ONhuwTN4Cl8xpqTWrKYpZnHHZz2Hb+w/YRIdq4Eg5cuRezZXkG//t
X-Gm-Gg: ASbGncvd+asSf6vDkew3ctAFHH6O8aZjphw7iNR5gEXBuXQNC47k2DRq4euPlKWXtjx
	fMZhjo3y/t9cGW1AhAasdsJ4Ra7G0Jh1A95DoN1Bzixtm6BRYG0ECe8irJpeZ+Xj+aR8ITSyvYN
	A3VnptXU/ST9Y+cGMESmWF893i3bhudsylngWdld2cfqknihGE1BbfDlgNPrmS+xmJCbB5OFfSa
	RAAGyNdn79XSn/JTgJI1xpeiY/oSQ7u0LqCOneaw5ICeS96Gs4Zos84Fg93GfOA999BuDKYjlJK
	DMASM6vGOlk65FiQ4XrD8C0CwbWwd15DQlW8mjRsxD8f/Kao4LyPjRWzB95+JZ2GNvB3WQ9eyUq
	AZg8wErPKlGqHKvg8RUjH2pDj1coonTlNqtVk8DThdvF+YKZaPYhN+LYibIXLbRse973PmB2vPU
	pdKvZtqn165pSqkLC8s73GLAqUWxAnCCJV1P88d3nFPJYx9lOrH3uEaxWNCCR9W4GleA==
X-Google-Smtp-Source: AGHT+IERDnLFLwOhzCzxM3fAOB4m9Q5P8T4LaKuBCRN+Nt+F4adsNxaxUHUrlib3xIGvfpKFuuE84A==
X-Received: by 2002:a05:6000:2306:b0:42b:3963:d08e with SMTP id ffacd0b85a97d-42f731967f8mr6489489f8f.22.1764857595783;
        Thu, 04 Dec 2025 06:13:15 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:15 -0800 (PST)
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
Subject: [PATCH 08/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Thu,  4 Dec 2025 15:12:47 +0100
Message-ID: <20251204141250.21114-9-ethan.w.s.graham@gmail.com>
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

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

---
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
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 17 ++++++++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 20 +++++++++++++++++++
 4 files changed, 43 insertions(+)
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
index 000000000000..023d6a65fb89
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,4 @@
+pkcs7-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(CONFIG_PKCS7_MESSAGE_PARSER))
+rsa-helper-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(CONFIG_CRYPTO_RSA))
+obj-$(pkcs7-kfuzz-y) += pkcs7_kfuzz.o
+obj-$(rsa-helper-kfuzz-y) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..345f99990653
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target
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
+		kfree(msg);
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..dd434f1a21ed
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+#include <crypto/internal/rsa.h>
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_pub_key)
+{
+	struct rsa_key out;
+	rsa_parse_pub_key(&out, data, datalen);
+}
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_priv_key)
+{
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, data, datalen);
+}
-- 
2.51.0

