Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF808239E82;
	Fri,  1 Aug 2025 11:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754046836; cv=none; b=Uf1H+p3alu9yROMeB5ZbuccK8hEsmzCafHBvEq9uj1vjRNeRQFdMOUFfm6g8kz3WEpaAehcLtPLUnnZLqy4xmlJPKQX1+mKtSyzv+QGc8eK/auG561qyV6YKbi4kBNObavWfBk60+jX0J5rQJw5VCE4f9Jxn1XeI2CzXRU7wDTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754046836; c=relaxed/simple;
	bh=I1NEtaBSLXjt4L5r/ip7ZdHNXrCDf2F9jSdM65XNUdc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mprmr7GpEu8BIrfFPZkZ9aB/ms62lfIHsvTxuO5P1+DeloIbOemov5t8TYCHIR3kRXZzagR9JNLSo0kOd4fLr1E98OWmmjJP8I2vxqw+ZD87+F8L/31t4atD9YXQZl5uxSgInvDEnt4J3TJ9I7u3NQmSa3Esoxjl+1GS7XZQBHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTHuNHaB; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTHuNHaB"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b3bdab4bf19so1599276a12.2;
        Fri, 01 Aug 2025 04:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754046834; x=1754651634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D2pJWIW2ffJA6mnDRFk1GyVzqLmZytM15VpbVSAxTPo=;
        b=JTHuNHaB4ynIYbMGybJb0RGd1ZAYNEd0cye//5VhRoWTHwiBP/nlvs3yuOT/bAX5WC
         NygUGTwxX4rBwImtRV/FMZW3E3TUhcnQFyHZJ5MKZ3skPCxvJyXlI5In3ToE02b7yuAF
         7Cwy6AjSni3S+LRRLdTjG29Yiy0PWmcKxvApBbTi3v4FEC7+8iuRf35lJHpZgsRD+tgk
         cGWgwg1g4SE3lGrJxR50fW8pHs706O49njTT9PoMVTLeG5XTEILu8PjnHVle2HwniiiF
         LgMbIYu0aIVIBW/lqW6zpweKZM+AG29DoOviR6v24d6sU7LybPyfjCVwMnfCmmB1t5/9
         ykWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754046834; x=1754651634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D2pJWIW2ffJA6mnDRFk1GyVzqLmZytM15VpbVSAxTPo=;
        b=qe7fnsM8y7HEHBuC6/EJwWy0Pi7NRTe8y3nniHMRHigd0azzI4yaKuIXuf+BmmNyDP
         /XLQRNz7sO4rvcHxtqzOKpEdPQCX1QFUgTN3FAW6XdlcamYhqGE8yYmspDn3dUi4lNPY
         +Bt3OnQk3DJ7Og0R9ahkmcbTmgU2t/M1NDB87UIkM5Swhq7ndPjs5JpS243RPMhc6Fis
         hPCp+vPTXArawgpb5E6ifw1/VGlaNtYfcJ9gdlOxepIdCAArazyVqeGrbEVYyPNAdaFT
         PpbtSZGTHXziXpDbtNIuOQ9AeTlPJ+9O2mbWa6GUPj1nfw+JAWbNcsmiP4o1JxVM8Csf
         L6VA==
X-Forwarded-Encrypted: i=1; AJvYcCVPXNUNnjpBmw1KABSQXAmdm/qHmP9gPh3dbFIAQ1a/BkeAzbnpgM15f+vm1g6BVK/A9JxQFg7E6ZXia6ja@vger.kernel.org, AJvYcCWeANkSnyc3KGoPXH+3e/88OP2NWu0CSn0sC/tHcp2NSZz0bsAssMP1NrFWHN125yM/Iv2fQpQayDPeCoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfkoqo+aR6RWwbk17PvRoB2oHNyQ3Aqz2IPlHWJZP9uYfDW1MB
	XBwBqGuCvGwFOa2mhp8/Wo7SAuXrV2yDHWDz0v3H9ja0LZ2KcaLLrFv1T9dLRI9MAdjjEg==
X-Gm-Gg: ASbGncvTl1w5lLOLEn/tevLqbiGIpUQjad2QAEpxCEC3xwKZbnQodTwR2XnRxK7bHFu
	1BCDBzwwECnc1fywogNMsrvHeNUE9+rPEXbEt2+/UTcns31R94Xl2LoXzivS4cTCpychWfoWhIe
	KfP1NdwznntEA2pRsyPtDTTDxaBmszxbY/FZ1+XH8Ee3JD5l041fG+zjEdkVeaRTh+Nlm4QA7TK
	eDRzC6Lk25pShd6N4cydeoe2KhRuy04sWPzB6C+cm7kh9SVZEg7JY8Q3LzBdVB30l5hC+g5WfB0
	inYJSE0ivEUGeMdst3ayB4XcIvFHzi+qNv+9HOqaufutiCMnXohMZY/zeyBmMukyBjUrbHhwjNA
	XnXNBoHoPdp5We/kkOg0Rb8MbtLgko1fUhY/YvHluTNRx7X5h
X-Google-Smtp-Source: AGHT+IE6ke9mTSfy66z+INYMD++cBNLZ1ztgTYwduR+cIIG6VHegxybaCmAYJwJMFxrWLY7jKwYDMA==
X-Received: by 2002:a17:903:3bcb:b0:240:b28:22a3 with SMTP id d9443c01a7336-24096ae5760mr186428355ad.29.1754046834059;
        Fri, 01 Aug 2025 04:13:54 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c80:a6e0:3232:35a4:62e3:6fd8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8ab3d9dsm40649845ad.182.2025.08.01.04.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 04:13:53 -0700 (PDT)
From: darshanrathod475@gmail.com
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Darshan Rathod <darshanrathod475@gmail.com>
Subject: [PATCH] crypto: padlock: fix assignment in if condition and minor style issues
Date: Fri,  1 Aug 2025 16:43:45 +0530
Message-Id: <20250801111345.1849656-1-darshanrathod475@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Darshan Rathod <darshanrathod475@gmail.com>

Refactor to remove assignments from inside if conditions, as required
by kernel coding style. This improves code readability and resolves
checkpatch.pl warnings:

   ERROR: do not use assignment in if condition

While at it, also cleaned up minor style issues:
- Removed extra whitespace in a multi-line comment.
- Fixed parameter indentation in cbc_crypt_copy() for consistency.

Signed-off-by: Darshan Rathod <darshanrathod475@gmail.com>
---
 drivers/crypto/padlock-aes.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 1be549a07a21..f5db0442a422 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 
+/*
  * Cryptographic API.
  *
  * Support for VIA PadLock hardware crypto engine.
@@ -77,8 +77,8 @@ static inline int
 aes_hw_extkey_available(uint8_t key_len)
 {
 	/* TODO: We should check the actual CPU model/stepping
-	         as it's possible that the capability will be
-	         added in the next CPU revisions. */
+		 as it's possible that the capability will be
+		 added in the next CPU revisions. */
 	if (key_len == 16)
 		return 1;
 	return 0;
@@ -223,7 +223,7 @@ static void ecb_crypt_copy(const u8 *in, u8 *out, u32 *key,
 }
 
 static u8 *cbc_crypt_copy(const u8 *in, u8 *out, u32 *key,
-			   u8 *iv, struct cword *cword, int count)
+			  u8 *iv, struct cword *cword, int count)
 {
 	/*
 	 * Padlock prefetches extra data so we must provide mapped input buffers.
@@ -493,13 +493,16 @@ static int __init padlock_init(void)
 		return -ENODEV;
 	}
 
-	if ((ret = crypto_register_alg(&aes_alg)) != 0)
+	ret = crypto_register_alg(&aes_alg);
+	if (ret != 0)
 		goto aes_err;
 
-	if ((ret = crypto_register_skcipher(&ecb_aes_alg)) != 0)
+	ret = crypto_register_skcipher(&ecb_aes_alg);
+	if (ret != 0)
 		goto ecb_aes_err;
 
-	if ((ret = crypto_register_skcipher(&cbc_aes_alg)) != 0)
+	ret = crypto_register_skcipher(&cbc_aes_alg);
+	if (ret != 0)
 		goto cbc_aes_err;
 
 	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
-- 
2.25.1

