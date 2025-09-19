Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE5C3164B5
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293889; cv=none; b=qdyS8Q5X3gjMu1s7zyj2jSaaIliNPiuke5knBp0P1sA0nE0F+yRAObWZHdGe0a/TjrwAINEg/EVnbZ2lbZQX7jnBRx1GaWtnPBciqTv93cpwSgnFD0xh2fgmQIxsudNTOuWbVEYGI4edR6onpEChKpMAkUXb+yNr+jR2obrBJok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293889; c=relaxed/simple;
	bh=z4XRQgx/v9aMDHTqeuKkcVV2lob3wsrHL0J2Rkuf4lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxBMhjO7dycCdelXsMz9QfUCZ60QsD7Z6sTo4QkBXcaieeCqEpt8Cc1iItBIU2ih0LYEl6ubd8xhg9RHh5Nk6HdAYIqG7iCIVp0vdoqndvnkqiBr7hbpPbOQhaTy4KKCGGCUTds7z5b9Qj1aYje8sE5KADM15UffbOwilrFCsVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ndL66Goc; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ndL66Goc"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dfb8e986aso19509765e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 07:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293885; x=1758898685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wa5F8osjsxPwGqDjaoLyZTZuU1vO95PkOFG1IS0GKrs=;
        b=ndL66Goc6s91o2EtgHWCwvtiQxsc18t85qSefhQXDFaAVJbQl1E/cRoAwxauK0d0Mz
         I+XfyP82yUY+WmFCv3cSXzUcip03iXKXTTDNpblPmq/NMt9fq+OTe50kY1sm2Zf0+umj
         TVM6u00JkBVfXkgMcmeh1FcmToQzszDx3/0Rma9KfuWKoj0UWmEpRu02kYCXfVPBoEJL
         TpoxHZUD95o6G7tpGAKqPaAMbld6nulm0/LvVKstJoxHX44pGpTM32FPixA55aT454pM
         f5gqQcL87cX7aN1FWDRNKBnoMIkK3Yca5+FqwbiVVzgshlbKlOBJJqjeRxJqiZslFm3d
         c21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293885; x=1758898685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wa5F8osjsxPwGqDjaoLyZTZuU1vO95PkOFG1IS0GKrs=;
        b=lHqU786WC6f4LXvpugp3n1FP7wQXLdFWnOX3jJ/bnK6W6wr18J3g3mznXlkOouItIf
         J7GhvzvxnC43pme8Ac8UrXGoq4ZRSl1idpSnFCjpSlNHCLFfCv8p+0uyPrrD7LsDrotF
         ff0spYfTgoJRbMqNtejI6LK7sC92EZb4+hppU2y0+93787FX6UuxzMY7d8JZZ5HN1GCJ
         cIywou56VDJNF17jdCUCIGbd7cuS1Fx7jEESXQO3Fa+yyuqrBCebbbP8j+hau37s+7MR
         A/oXnQyl+nHNxsD6vMWV8okqCrIuipqTehpHDL36rRQtlg9ebKqs85Eg88dMI1StkzvH
         phEw==
X-Forwarded-Encrypted: i=1; AJvYcCXMLwzDXOG4Z3MxVzR93Q4M7L+fwjZcCuJcUCUbbVkvOirV8BptQEHM0EZXV3+6xV9DPzMsvmZloWAlEYU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0X8HojuHLDvhDIyxNdUeWlPAzXxRQwd4AJfoFk5Ein3+8Nvt6
	SynAsnQPISNIe5jVdQCKMoSxpy1YikXX0drv88DAc68t8L1NCpdHXnyD
X-Gm-Gg: ASbGncs+HLotjtDVlPztyKa/pwtEGUSdhtygedX/T0nOFJibext88ivepsKDH7NU8aL
	rWVwW7law/wXmrNcbcLdfEWmIEZpo5o1J8YuNWEJaALW4HqGn+ql6OgABFg1Z+xW5GRhv5lePyt
	QpqjH5ZcL1PLXqKfkqZ1T6k5s8LtA/J6sg+DS6+ESP7cS5YiV9nFdhh3UOCb1u4b2s+d//hvFnK
	b/LAdOKkz2uSGUsolSaPBfJoVooYm2Hl8dCG0OrilPAKBGRKYD6c4mdHfIxD6vPoECQ5u0b8oA6
	00uBs09urKzjs/hdG/RsEGRAsb2xwgyXEJw0mqFTLZkMRmmOS+Gg6o2bskpVe27jtSh76hAT/in
	CpOdnX9tQ7y1sTAobFYBGcxcgrZIypZQ8DMjBH9pwOjdiQ+HNU1tSq2M6qOtc0s7t7fgwRvAMiG
	QNFgD/Tijylt0Dizs=
X-Google-Smtp-Source: AGHT+IHdJYIXqz3C4OR8m/GvaJucPOCvchvPgeW6LDDv3ZVv3CkV0oEsEwnK0vfoZjKlHtOSmNp5DQ==
X-Received: by 2002:a05:600c:4ecb:b0:45f:2bdd:c959 with SMTP id 5b1f17b1804b1-4684c13ec45mr31051625e9.8.1758293885086;
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:04 -0700 (PDT)
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
Subject: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Fri, 19 Sep 2025 14:57:48 +0000
Message-ID: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
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
2.51.0.470.ga7dc726c21-goog

