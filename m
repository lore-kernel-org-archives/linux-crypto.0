Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEDB221D90;
	Fri, 14 Feb 2025 08:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739521145; cv=none; b=evfRxb9Gej13sAWeBu4mCCEnqoUVcSPpdwPE54wjPbS9uuL8vM14blUW0THLEP2zChA4nM58QJ7jJRanWAA+OlgdtXX1EXqXodY/giN9/viq6UHOCFqCM53pKZw3wb6OfDAMhApdMw0zOJWuUSR4LUZmBV5f7u4BkIB8YLj2bfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739521145; c=relaxed/simple;
	bh=fOot9ks4zOYnhfukRzBB19GvU5tMdnQm8j6umBxaIhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYlqJHgpmpNO9UykK1igzOIULoN3DmBxnZiHwJNNUWvapJbdtX0MY95W1OajZCQfGpP7DOA1ClbIdJW86A5K2kg0O6C7a3SnMti6hTCJH0L1V/3Uu6focfAHPQRMDSVcZHvdi1DAqdUMe+XILNg9YwhXclZEETHJtZ3TaV3S8bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dUVnAY8n; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUVnAY8n"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so12427245e9.1;
        Fri, 14 Feb 2025 00:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739521142; x=1740125942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHi1SPPbLAKlT3fCCmNKbz9/vboESIp1vN36khagmYY=;
        b=dUVnAY8nEZtpaFG5AFb3Hle9paJrYFKuGxd9j1yp+Sgw4Yttpe3gkBMMCLNmRbIhrS
         OOt9S9+/QVA09UchA9nkk4Bv2JgMb57dSXGM9OJ1H8fi/oWposNMkB1WTF4z2Qv50PqM
         roC7pRPAYDxkb+rO46qHiJ2wEp9FWH+ZFCSZaTUjSSZj2A1fOt4R6z3TKK03o5iJHXWz
         YUZfssT8a359iOLOaJSVMdULT8TOoQbMLQoJobphfJjAdV8mnij7edCEfLN8GxpahkUH
         MJ9OIyNeCLw43Pt9K4blzQYaayr3A4uRFTT6PzTEUQwLJRSb6ieG7bQRAnEX6u0xWfOQ
         jJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739521142; x=1740125942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EHi1SPPbLAKlT3fCCmNKbz9/vboESIp1vN36khagmYY=;
        b=S3bzId0Lb72IleOBgyZAPBjBFtQqc1Iqk6mj3tR4+zYUJeJy2Hq4/PWJG1UGB9KdIj
         Aegg1GySnhQSb3XjbuLwwNuAgGbNrbfL3q/zibP5QB8nequJwG8nss8FqrcrL53b2DnB
         v5+Lo6x74KVCe4YdqZ3ZvyVAVlwgScjs1lMatnVtE5keG9h0X3LW/RfRc0bQFvonlpHA
         2XAXh4nUu/PH5u0Nd6DdNzPri0SS3Ur+ZTHq1f3EYeOGsyxXe/kj0zxHE/BeeGatQIcm
         106nZwj10OjAKBEaCeiUCfXa9R/4jMrrVmGTJW9UlVExhX3BytZHLBUkR/1ovbdJeoBC
         LWlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX0ZcqSfTMRzjl5X7JAVMLVXZhLj6X1nt34bGM5vuhKCwhTT0fmhqRjqox1NW9oFPSXI4lh2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ03xi/qMZyADwXlr5GrUyTViVKjjTZ0xrCG4KWw+hbrTXINHw
	W8r9m0/BN8zA/lSU7toII93bDxWGtfo/6iiIdRTjk4sWTEvTRtN9mVnpRqHDp5+hqQ==
X-Gm-Gg: ASbGnctg2U8mnklqp5iPTzSpGS4brN3hWbQlqYUsEXf/BjoGkCI42vzZ9QtlgrFEqOU
	eqdCzAFU6rzZ0jp7MXdXgYwUq63xqiajhgyHPmZrMmiTeRkAzm/duP8oBtqrSAXHD7wtENmQOyl
	p0hUR8jtiqZsL0y080yilSgPDukpf7u3H7gvL/fwyte/434AjPQJg4+iXmE/Umi/q/X4wprPm3z
	EnXriDHIgMF1pofau1JOxoflz2+yS4qnPJXA7HrvwL2XDAnF+XbLnGDaZXrZxToswKzkyvSurMm
	BYX3jMZcRYEiGNlkWnRQwM6L145gYZSm01h5bLCqDoYX4zxIyzLsR6psdQ6ZBEtQLvlPxtKIG5d
	dfuh7OpzwlkwD8ss=
X-Google-Smtp-Source: AGHT+IGSslfMzw+/medH9A4AJpGix2aLOpsPIvyARm/roylppQth8pkhMSHZ6mYg/od8dFF/yShwkg==
X-Received: by 2002:a05:600c:46ca:b0:439:6a24:1067 with SMTP id 5b1f17b1804b1-4396a2411b3mr9333445e9.16.1739521141228;
        Fri, 14 Feb 2025 00:19:01 -0800 (PST)
Received: from legolas.fritz.box (p200300d0af0cd200c9869c6f52eff023.dip0.t-ipconnect.de. [2003:d0:af0c:d200:c986:9c6f:52ef:f023])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04ee48sm69409735e9.3.2025.02.14.00.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 00:19:00 -0800 (PST)
From: Markus Theil <theil.markus@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	akpm@linux-foundation.org,
	Jason@zx2c4.com,
	Markus Theil <theil.markus@gmail.com>
Subject: [PATCH 1/2] prandom: add usage comments for cryptography
Date: Fri, 14 Feb 2025 09:18:39 +0100
Message-ID: <20250214081840.47229-2-theil.markus@gmail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214081840.47229-1-theil.markus@gmail.com>
References: <20250214081840.47229-1-theil.markus@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it more explicit, that the PRNG must not
be used for cryptographic purposes.

Future code may also check such things in checkpatch.pl,
but it is probably hard to differentiate valid testing
code only by looking at paths. Therefore this is left
out here by intention.

Signed-off-by: Markus Theil <theil.markus@gmail.com>
---
 include/linux/prandom.h | 2 ++
 lib/random32.c          | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index ff7dcc3fa105..63d1fe4b30c8 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -17,7 +17,9 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
+/* WARNING: this API MUST NOT be used for cryptographic purposes! */
 u32 prandom_u32_state(struct rnd_state *state);
+/* WARNING: this API MUST NOT be used for cryptographic purposes! */
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
 
diff --git a/lib/random32.c b/lib/random32.c
index 24e7acd9343f..c808745a4b53 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * WARNING: this API MUST NOT be used for cryptographic purposes!
+ *
  * This is a maximally equidistributed combined Tausworthe generator
  * based on code from GNU Scientific Library 1.5 (30 Jun 2004)
  *
@@ -48,6 +50,8 @@
  *
  *	This is used for pseudo-randomness with no outside seeding.
  *	For more random results, use get_random_u32().
+ *
+ *	WARNING: this API MUST NOT be used for cryptographic purposes!
  */
 u32 prandom_u32_state(struct rnd_state *state)
 {
@@ -70,6 +74,8 @@ EXPORT_SYMBOL(prandom_u32_state);
  *
  *	This is used for pseudo-randomness with no outside seeding.
  *	For more random results, use get_random_bytes().
+ *
+ *	WARNING: this API MUST NOT be used for cryptographic purposes!
  */
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
 {
-- 
2.47.2

