Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582AA2EF66A;
	Mon,  1 Sep 2025 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756744999; cv=none; b=f47XLM9gFwG3Mc7cBemuQ4HiEMIpE52HYlrl+mUtPY/aypRLdTfB1ZNMGGemvMrixg3WONZi//M5laatCyBvAMQx6NpIG/3R5OT/MF4dcqvM26TmYtUeaaEuJnhpyIfEnJK+88cEkdI4pXMAsDvnMRV00TDtfyFlShk4a71yB0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756744999; c=relaxed/simple;
	bh=PjAcV8Pri16gdlPO+4S4c4wfzXPOKGnrjgBoxOT0UlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdAQiO86rI3r4+26ovMeZNHSpsFv1mpqTs5SyvSnPQEnDQGuB1fjzZcTvXNqGM5BIbfvTmY5dhJTSya1aMWiqDrzFZsJpvrHbG6OOyBu3abOD127dUNgHX9sqSSnzFOQ37fpXv/rew4CQjHKcIUuRu853C5p5eN87iYKqQNcE1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7EHVIeT; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7EHVIeT"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b869d35a0so13401845e9.1;
        Mon, 01 Sep 2025 09:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744995; x=1757349795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBvpSqbqbG4wFXeR5v1aPOZCpZfQ+jFjNgEJ1TDAElY=;
        b=D7EHVIeTHlDQRh9aWxX0Vz5Rckl7dj49d+nUdurLt2S7Dx+NIRL/KZCYXLxudLEfk9
         crb6FT3ORw/RboGva4/8WdfE1ERRvT/GLKYiadOHu/hl7IZP6yf4KEiD1zKoeHHouy+5
         BKSMkNKennHVLO1SUOhxV3ymyiht1BnTPQpduI8zx8zvufRZq4/ev8t5J/TAEmsPBPYK
         nOs7hYhrhN+XTZGCRzK5+kns7uP8ht6g9ZQs9wvgZQXc2xNldzT6/X4yyKo6nHaHfH+r
         BZlZhCIcyI2xBKI5VHcciMcLvGqavkpRoIm1FuHmYbSFUJnRB2rxzzls3EaogHM48BAH
         hScg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744995; x=1757349795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBvpSqbqbG4wFXeR5v1aPOZCpZfQ+jFjNgEJ1TDAElY=;
        b=R+d171wBTfV+UFvpbV8xTkxmwl/VO1TXPERBfVE7yTvSEjE06S6v1xc58WYq8y3Nra
         hcC0s29XKYJAeUJ7AE12TjcsLHGmQlipnEJhUwtC0QUFOYiBUyGVcdmtl79fnP/blGhc
         ZBzU4nMuI9x4EkPVLBwau+g+ob2tXxPpxzSOeJ48o8oEtYjtNmVVTgStHFsHRbMg4IQI
         jxkX6o9U8S/K9zoCphl65nPe//aoeNo9pc4b/pNEL1nAmNlhN7yGtT+8phinOZz6cQ/k
         eEXt0tZpXPK2mHM2xTOMADwQGMBo3jrMrqSuuwQxuetdpMzI81mL5S8T8wL1R0LSDnDR
         caEw==
X-Forwarded-Encrypted: i=1; AJvYcCUL5KVVftuxj89gf09Rvm5dhXE5Ps8+Yr0p37XyIWWrJ3y7Rph3X2lqPy2G1Cr8oUnV/DEW8JZMBQ0+3N7P@vger.kernel.org, AJvYcCVIk0SrZUc97tM69xrWwwee1SsapNzocHBYaTD6gdnIVlO0aAUe7GoojYioZLWAphLMLB7YzyQl5aprJfs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9IbJ++wSDRca9hue0lxFJ7jB7vFX0W6JZ9dhmRwDhSZfeNbYN
	qH2ALE9G+wTbXeebYAUiXv9oQUA3kpzIE35uPHigVQcMyPWUR4FkrEKM
X-Gm-Gg: ASbGncsEkaTnu7lHMf1p9qmmB9XtxwXSIMNsQbYhva8cK5AuuP+q5Kc04lyhhIVI5q3
	i7GFls+h8xgHfeBPHcgpACFZRYIep6HBm6ZwHfzV3U4Opn50Uh63W5L1GVAZDzRni0xkeaKNa8k
	J6uBSQj2m8N7/WiiFIS2l0R5g4Q+kEqZSF/1o/pH/JF7Y9uc9uOqimuxs/ZPJimBW5VV+DKoeYH
	tWK1BnZyJfW3cHI5yfRL0IG7zu2toZepbB4SbB026Opyjn4BXE5xTk8X6WOWtXrqHl7vngmKhNc
	Om7hOLe456kLV0HrhQqxZ1PhgOyZWojBxOKZBCQzzbwQRO5P87Dd6OFMY4qW0IWmPYe1AFys2WK
	2HQqNHX4R9tjDJX1Vi1MGR0qt6UOb2FxmaBa04nzbQakat/ija+GF6jSYil+Oti+V8BgF5IfrhB
	kmwABaN0CWrJJxbWkAKdhqtBMb6az3
X-Google-Smtp-Source: AGHT+IFKo5JULDcPmqclDIOUfq+BI0sCVaxhFcUfvTCD5F0z7DntK34OPynj2UmgxgB5QgJJz7ystg==
X-Received: by 2002:a05:6000:4210:b0:3d5:9efa:fbf2 with SMTP id ffacd0b85a97d-3d59efaff51mr3979157f8f.22.1756744994954;
        Mon, 01 Sep 2025 09:43:14 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:14 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 7/7] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Mon,  1 Sep 2025 16:42:12 +0000
Message-ID: <20250901164212.460229-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
rsa_parse_priv_key to serve as real-world examples of how the framework is used.

These functions are ideal candidates for KFuzzTest as they perform complex
parsing of user-controlled data but are not directly exposed at the syscall
boundary. This makes them difficult to exercise with traditional fuzzing tools
and showcases the primary strength of the KFuzzTest framework: providing an
interface to fuzz internal functions.

The targets are defined within /lib/tests, alongside existing KUnit
tests.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
v2:
- Move KFuzzTest targets outside of the source files into dedicated
  _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
  Ignat Korchagin and Eric Biggers.
---
---
 crypto/asymmetric_keys/Kconfig                | 15 ++++++++
 crypto/asymmetric_keys/Makefile               |  2 +
 crypto/asymmetric_keys/tests/Makefile         |  2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
 5 files changed, 79 insertions(+)
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index e1345b8f39f1..7a4c5eb18624 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -104,3 +104,18 @@ config FIPS_SIGNATURE_SELFTEST_ECDSA
 	depends on CRYPTO_ECDSA=y || CRYPTO_ECDSA=FIPS_SIGNATURE_SELFTEST
 
 endif # ASYMMETRIC_KEY_TYPE
+
+config PKCS7_MESSAGE_PARSER_KFUZZ
+	bool "Build fuzz target for PKCS#7 parser"
+	depends on KFUZZTEST
+	depends on PKCS7_MESSAGE_PARSER
+	default y
+	help
+	  Builds the KFuzzTest targets for PKCS#7.
+
+config RSA_HELPER_KFUZZ
+	bool "Build fuzz targets for RSA helpers"
+	depends on KFUZZTEST
+	default y
+	help
+	  Builds the KFuzzTest targets for RSA helper functions.
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
index 000000000000..42a779c9042a
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_PKCS7_MESSAGE_PARSER_KFUZZ) += pkcs7_kfuzz.o
+obj-$(CONFIG_RSA_HELPER_KFUZZ) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..84d0b0d8d0eb
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/pkcs7.h>
+#include <linux/kfuzztest.h>
+
+struct pkcs7_parse_message_arg {
+	const void *data;
+	size_t datalen;
+};
+
+FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
+	KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE_SIZE);
+
+	pkcs7_parse_message(arg->data, arg->datalen);
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..5877e54cb75a
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+#include <crypto/internal/rsa.h>
+
+struct rsa_parse_pub_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_pub_key_arg, key_len, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_pub_key(&out, arg->key, arg->key_len);
+}
+
+struct rsa_parse_priv_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_priv_key_arg, key_len, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, arg->key, arg->key_len);
+}
-- 
2.51.0.318.gd7df087d1a-goog

