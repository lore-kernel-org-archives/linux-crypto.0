Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A122172F
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739520160; cv=none; b=twLkGSRE/awsG5l7mJq6I51Hld6RiH3/vVclmZJryfyCoKWKeAb4qMlkMEBGn8inIvUnsUfXYtxESFmQPpy6nwXLijSvHvnJgL27WWLa4Vjun/cxcep6V+dgIxlVZqXpY+uPJrgxJEM8FQdpDqPhfB/IbBQltMe0btvjtR6QAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739520160; c=relaxed/simple;
	bh=J4oE9m5naq7S2XKzW7q89ShYD12xzWhIuRo6goJRevg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bfswnin18uidwCNt8GJb3jqokMjxhHulCiVGVvVhKJpVtrWM8OXTmvSAqT6WZwJ/HqHjJtTpBZycoi8KP4r8txJOejhvILI7NI0FvKlBt/u6RX9gtHOJ6A9E7ikzqvSAconDSwHSNFBSJ4Z7wrnvz89vjNOgXJHN1gEnh/nUwjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VI8QIQhg; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VI8QIQhg"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5df07041c24so378768a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 00:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739520157; x=1740124957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=26W2SAUaIn/oBZFf4Dbol+vvHRk+xozS2dfD+9MdceM=;
        b=VI8QIQhgOIHArVollrtXW0e6lwFeVwBFixUH58R2sRSG6H9FQi2CO5Rke3MEUIFxCd
         NVnk/IOLKWLhaTB11lZph5SgojBnFC4oM77GQs3RdmnYIlgKq0gzpto/Ak74zoAlkhJd
         RyEwx2moj/jbUGSLxGjgXFM9e0ZOv01HS1R9mpgomf/RrCF6nsq+TUsRDv5PoMe9hLIz
         VuJsOyrALXZV3cgDo12onEodPE/Sp9PCyf1Mjhr7G36XmxiK4eUA6+15HmiqtJs1NN32
         vUqehV5qnh5LcWEI0TWKUOCkFOxGRF4CKHyMgOedvxZo82q4wsQsqCRtRywlkroFIg/Z
         amIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739520157; x=1740124957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26W2SAUaIn/oBZFf4Dbol+vvHRk+xozS2dfD+9MdceM=;
        b=Skrd2jKd26lxMKjGafCq3sLoBqP6FBXQ9E4hypk8EajLQmKifchAliX3uOBku3WXPD
         WrP5xnEs5d2M8nhBrP6gNqM8SX4+cNH2e91U7mJTQ6FDf92l5TfY9roBHaelJIESjaNS
         4BUrq+WDvnR1HmXrDFWhZPC6hXNWI3AlEhVPwrgJGATdY8udnkNyimiMG0ziIlz8HXQI
         467VZY11VF6wd3ubwMc4dRbcQL7PUHk+vqpnWk5lwmw4c0qAUsMD3G6r/BMdXiklwh/7
         yqBmLBhc2o3Yc2nB5wI34MZ3vttn/fbyUyf/0sGTZ1WO+Ol5mhw3qvf8qos2lcSswnLz
         sEIw==
X-Gm-Message-State: AOJu0Yx5bvzDCbE0neYFgR3/ZeyphTAa7/fgCWQinLxk5UFPJWR21oEv
	bLmxsAhdOeHA3JF1wUGriwdHZ3YM33rsYCaaT9OO7gEr9DIpwihE1pGntXY50+30Lw==
X-Gm-Gg: ASbGncvmRK4yeWw9TFvgKyZTks/rLo7pZ+FZwTKRCX2UZP5Fii/w7N5G8b3+lmAEEQp
	2DKESMTb1y5lrEli0umCjSNRX1pnvKnlon5v1b17dmtUNGCZP5UahZlvLq9Sapax8+S7WravXR6
	wphadrB8arR8coHpRzk3Gzi+q69Cr1nEmUirGPh5ojGBaun5T45eS+eIIXqZelp1MbQOjLk59Va
	ilxO1Fjx/YdaxGQnRWlbRqxVAnBCtNSZRHkRfjPcSEHc+MdbLMydEaZe0qvLTsmmXIuWhbKa8wF
	M/DAkP61WL+/rar7UIx+sAlq5zsmhts6d8yqR+5LCUz5LqZUUjotbR5cDeDKFSuJD7p+oH3xGNl
	vwsIMbSmhVQVr48Q=
X-Google-Smtp-Source: AGHT+IEPTh1YcTLerk5K2U23kd8GMiHsc17UjsmKGY0Bd14FJYGsFHF/k7RQF4/xMiFAoqWYDHlmSQ==
X-Received: by 2002:a17:907:6d11:b0:ab2:f8e9:5f57 with SMTP id a640c23a62f3a-ab7f33bb639mr1012697466b.21.1739520156597;
        Fri, 14 Feb 2025 00:02:36 -0800 (PST)
Received: from legolas.fritz.box (p200300d0af0cd200c9869c6f52eff023.dip0.t-ipconnect.de. [2003:d0:af0c:d200:c986:9c6f:52ef:f023])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53231798sm290928666b.16.2025.02.14.00.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 00:02:36 -0800 (PST)
From: Markus Theil <theil.markus@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: akpm@linux-foundation.org,
	Jason@zx2c4.com,
	Markus Theil <theil.markus@gmail.com>
Subject: [PATCH] test_hash.c: replace custom PRNG by prandom
Date: Fri, 14 Feb 2025 09:01:57 +0100
Message-ID: <20250214080157.44419-1-theil.markus@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use default PRNG, as there is no real need
for a custom solution here.

We know the sequence provided by our seed
and do not need to do bit magic in order
to obtain a non-zero byte. Just iterate a
small number of times, if needed.

Signed-off-by: Markus Theil <theil.markus@gmail.com>
---
 lib/test_hash.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/lib/test_hash.c b/lib/test_hash.c
index a7af39662a0a..308446ea3431 100644
--- a/lib/test_hash.c
+++ b/lib/test_hash.c
@@ -17,39 +17,21 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/prandom.h>
 #include <linux/hash.h>
 #include <linux/stringhash.h>
 #include <kunit/test.h>
 
-/* 32-bit XORSHIFT generator.  Seed must not be zero. */
-static u32 __attribute_const__
-xorshift(u32 seed)
-{
-	seed ^= seed << 13;
-	seed ^= seed >> 17;
-	seed ^= seed << 5;
-	return seed;
-}
-
-/* Given a non-zero x, returns a non-zero byte. */
-static u8 __attribute_const__
-mod255(u32 x)
-{
-	x = (x & 0xffff) + (x >> 16);	/* 1 <= x <= 0x1fffe */
-	x = (x & 0xff) + (x >> 8);	/* 1 <= x <= 0x2fd */
-	x = (x & 0xff) + (x >> 8);	/* 1 <= x <= 0x100 */
-	x = (x & 0xff) + (x >> 8);	/* 1 <= x <= 0xff */
-	return x;
-}
-
 /* Fill the buffer with non-zero bytes. */
-static void fill_buf(char *buf, size_t len, u32 seed)
+static void fill_buf(char *buf, size_t len, struct rnd_state *prng)
 {
 	size_t i;
 
 	for (i = 0; i < len; i++) {
-		seed = xorshift(seed);
-		buf[i] = mod255(seed);
+		/* we know our seeds, no need to worry about endless runtime */
+		do {
+			buf[i] = (u8) prandom_u32_state(prng);
+		} while (!buf[i]);
 	}
 }
 
@@ -143,11 +125,13 @@ test_int_hash(struct kunit *test, unsigned long long h64, u32 hash_or[2][33])
 
 static void test_string_or(struct kunit *test)
 {
-	char buf[SIZE+1];
+	struct rnd_state prng;
 	u32 string_or = 0;
+	char buf[SIZE+1];
 	int i, j;
 
-	fill_buf(buf, SIZE, 1);
+	prandom_seed_state(&prng, 0x1);
+	fill_buf(buf, SIZE, &prng);
 
 	/* Test every possible non-empty substring in the buffer. */
 	for (j = SIZE; j > 0; --j) {
@@ -171,9 +155,11 @@ static void test_hash_or(struct kunit *test)
 	char buf[SIZE+1];
 	u32 hash_or[2][33] = { { 0, } };
 	unsigned long long h64 = 0;
+	struct rnd_state prng;
 	int i, j;
 
-	fill_buf(buf, SIZE, 1);
+	prandom_seed_state(&prng, 0x1);
+	fill_buf(buf, SIZE, &prng);
 
 	/* Test every possible non-empty substring in the buffer. */
 	for (j = SIZE; j > 0; --j) {
-- 
2.47.2

