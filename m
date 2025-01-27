Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD71EB3E
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737993767; cv=none; b=ZFBYqlRYnnAJtmv0k+CtD/v5Spipdu69v4BHhCnsnlmUhL0zmwUZjXcWdbpy+wz0d8ENFWevLdA7WjXT4tK7XA5PuaA5i3iaCzyl0va+jMuoDUrnVmy8WsW1ucfXGWpGNdoHgC9JR4ufNueiZEe6odaCZIBmVgBG+cdr7HPME0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737993767; c=relaxed/simple;
	bh=ypzyUrw1ero/of6OXCluDqw06nEhnIfgt7EfEhaFk2E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxVOBYIGmRlEe1ozZ+5c0wvEQ7CTS3RBJ6CDXgrsxPNa9cUl21ohPC1nvBe5i6dsaOaPmURQyEL5SUPIByJjZbkqX7znPlgMCANDy0FbPnaYHfDJwEWdmli6/nix2613IUwYFMk9lbMqZtgENb/i7Y9JFmhX696xJ6DFQfer5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MrCCvJ58; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrCCvJ58"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38637614567so2193552f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 08:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737993763; x=1738598563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nNY+0sAGFkXvbhbjHd79wNz4oFxcFYD6ernLjk7MRaY=;
        b=MrCCvJ58gI1Rb0wZC/3yZiIqK/eTq8W3DH80S1LnkfWXeKkPzeAOt7cTEKEu2HpHRv
         6QsszHB198zjUxCU8Uo1UOe5nIEnbE/5NccFq/jlyrUEngSGdlOcr6nXjZdRrgmQt9FN
         9cTb5nIiERP1IfAfYjVpdqq4BXf9o1IPTRqAjZvOME8zD9lRL2KOE2ThuYSIYNrqSQx5
         6PcNmUnq3MqO/Uk1q41NlnUmoQHVnyAVyFtXoQ7DmxiCVZAPATKeLyt72IuwvSzUyEh3
         u6AWQa7y5wo/pRz4Lr4PWNVr92LnADaJdrlQIh7JpEfMPzwRnlaB/4EjHOoOT7FY5KGa
         ez1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737993763; x=1738598563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nNY+0sAGFkXvbhbjHd79wNz4oFxcFYD6ernLjk7MRaY=;
        b=kWMGkk/6kxZefwEjtiifmBbH8xWd7QwDZxU+OLGgMWiad02qYz1fxaOI0YlyLJi3p2
         VtmuwlTEKYHgjnSpIMu2MMtlU8X8fKlvnc79yBGsMRQ63IMgV7aCBdkyz7xI4nsUXJqg
         mDoT+V4z5h38ib+IvsutsO8cmFee945FfZAzEbFnIx1IiIsptuZsK9tl6sewQ+PjezB0
         qiRiO4M/Z4MeqbGXaIdFFPko3fcPRuWSQrGiI/9957HAxoVt7XbdLLIE12w6alW5C5md
         4bFrP/WQSchh3ODvfB1TsAxTq6hEnAdcBAUVIdjzqyWliFVJkQRqrTOxZf4tJvrRFAju
         FNGg==
X-Gm-Message-State: AOJu0Yw3E64royjl0IrsjDuwQ5CQ2l5LXXSIAFi7Zni/fpaSYz6hzO6b
	eAsbiljORQdRfZtzjFaYXB1Te/baTzD9Yo4HnfMCgo9uqXFbuH/S43Rc4C6B
X-Gm-Gg: ASbGnctUKa+yfCSCDIW2K9k6P4p1YPtGf5b3g5Pjs5RvhvxhMm0n2ytwh3qyE2lir8k
	4JibaVohzm6OqXIOtzbSE5lCgXL8+hsm+7WUefeqPXC7x0hhZ5nKe86LeDpNVtBzO+dVz1XWfDJ
	hFkNNuh58aLGVW4OGHBq2heCswpjEmV9RCXvJdZ9aAVKinx+GfCLDCAU+zJ7fKXSDLJqv5zwgYE
	sMmYqcvuR199Lwtcx9dwgT50Cu0oqJVvdKzmP/vm2dA5WzrwGEEoZANsogHixjTthKcRqrgDS6Y
	RYPHLepV+gJOmmyGkWyY5gjmxkRsNPMuCeGj1VmJ4c6nDkuvSmE6bbe/TehybmGI3UDn6wAo1y7
	9UUJx6QC7Zk2+XA==
X-Google-Smtp-Source: AGHT+IGsvhP6vyY25h9afZrLe4ReYAGHqcYNZSGnh3vi+Ba56YQmGbL9LP7D3ANR50458EOkQQD0xA==
X-Received: by 2002:a05:6000:2cc:b0:38a:88f8:aad3 with SMTP id ffacd0b85a97d-38bf57ce970mr38734178f8f.55.1737993760736;
        Mon, 27 Jan 2025 08:02:40 -0800 (PST)
Received: from legolas.tailacc6e.ts.net (p200300d0af0cd200382d8b52676bd4c3.dip0.t-ipconnect.de. [2003:d0:af0c:d200:382d:8b52:676b:d4c3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17d74esm11737431f8f.37.2025.01.27.08.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 08:02:40 -0800 (PST)
From: Markus Theil <theil.markus@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	smueller@chronox.de,
	Markus Theil <theil.markus@gmail.com>
Subject: [PATCH] crypto: jitter - add cmdline oversampling overrides
Date: Mon, 27 Jan 2025 17:02:36 +0100
Message-ID: <20250127160236.7821-1-theil.markus@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As already mentioned in the comments, using a cryptographic
hash function, like SHA3-256, decreases the expected entropy
due to properties of random mappings (collisions and unused values).

When mapping 256 bit of entropy to 256 output bits, this results
in roughly 6 bit entropy loss (depending on the estimate formula
for mapping 256 bit to 256 bit via a random mapping):

NIST approximation (count all input bits as input): 255.0
NIST approximation (count only entropy bits as input): 251.69 Bit
BSI approximation (count only entropy bits as input): 250.11 Bit

Therefore add a cmdline override for the 64 bit oversampling safety margin,
This results in an expected entropy of nearly 256 bit also after hashing,
when desired.

Only enable this, when you are aware of the increased runtime per
iteration.

This override is only possible, when not in FIPS mode (as FIPS mandates
this to be true for a full entropy claim).

Signed-off-by: Markus Theil <theil.markus@gmail.com>
---
 crypto/jitterentropy.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 3b390bd6c119..2dceb5914aa6 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -145,10 +145,30 @@ struct rand_data {
  */
 #define JENT_ENTROPY_SAFETY_FACTOR	64
 
+#include <linux/errno.h>
 #include <linux/fips.h>
 #include <linux/minmax.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
 #include "jitterentropy.h"
 
+/* FIPS mode mandates this to be true, otherwise allow override,
+ * show correct enabled state also in FIPS mode
+ */
+static bool full_entropy = fips_enabled;
+static int jent_set_full_entropy(const char *val, const struct kernel_param *kp)
+{
+	if (!fips_enabled) {
+		return kstrtobool(val, &full_entropy);
+	} else {
+		return -EINVAL;
+	}
+}
+module_param_call(full_entropy, jent_set_full_entropy, param_get_bool, &full_entropy, 0444);
+MODULE_PARM_DESC(full_entropy,
+		 "Enable additional 64 round safety margin, to reach full entropy (NIST definition)."
+);
+
 /***************************************************************************
  * Adaptive Proportion Test
  *
@@ -178,7 +198,6 @@ static const unsigned int jent_apt_cutoff_lookup[15] = {
 static const unsigned int jent_apt_cutoff_permanent_lookup[15] = {
 	355, 447, 479, 494, 502, 507, 510, 512,
 	512, 512, 512, 512, 512, 512, 512 };
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 static void jent_apt_init(struct rand_data *ec, unsigned int osr)
 {
@@ -273,7 +292,7 @@ static void jent_rct_insert(struct rand_data *ec, int stuck)
 		 * alpha = 2^-30 or 2^-60 as recommended in SP800-90B.
 		 * In addition, we require an entropy value H of 1/osr as this
 		 * is the minimum entropy required to provide full entropy.
-		 * Note, we collect (DATA_SIZE_BITS + ENTROPY_SAFETY_FACTOR)*osr
+		 * Note, we collect (DATA_SIZE_BITS + JENT_ENTROPY_SAFETY_FACTOR)*osr
 		 * deltas for inserting them into the entropy pool which should
 		 * then have (close to) DATA_SIZE_BITS bits of entropy in the
 		 * conditioned output.
@@ -549,7 +568,7 @@ static int jent_measure_jitter(struct rand_data *ec, __u64 *ret_current_delta)
 }
 
 /*
- * Generator of one 64 bit random number
+ * Generator of one 256 bit random number
  * Function fills rand_data->hash_state
  *
  * @ec [in] Reference to entropy collector
@@ -558,7 +577,9 @@ static void jent_gen_entropy(struct rand_data *ec)
 {
 	unsigned int k = 0, safety_factor = 0;
 
-	if (fips_enabled)
+	/* entropy safety factor can only be enabled, not disabled
+	 * it is always active in fips mode */
+	if (full_entropy)
 		safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
 
 	/* priming of the ->prev_time value */
@@ -583,9 +604,9 @@ static void jent_gen_entropy(struct rand_data *ec)
  *
  * This function invokes the entropy gathering logic as often to generate
  * as many bytes as requested by the caller. The entropy gathering logic
- * creates 64 bit per invocation.
+ * creates 256 bit per invocation.
  *
- * This function truncates the last 64 bit entropy value output to the exact
+ * This function truncates the last 256 bit entropy value output to the exact
  * size specified by the caller.
  *
  * @ec [in] Reference to entropy collector
-- 
2.47.1

