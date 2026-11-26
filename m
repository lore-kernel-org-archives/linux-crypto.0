Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795673153;
	b=2DtSh0BxqytJ5+Qudv4lkImoyLY3wKPze8kwbIiJQhg2Jw2IAzXQ0skLxp5IsTlaofRM
	 gHhaQ6nduO8Mc4Sun34BtwTG5rj4lAEZvU568+t7tuvCGa8kHq32u8VgfNLFh/Lho7NRL
	 dGTDseMAaLj5un71+n4c5nHS5JCPwA96bGPPdqhzu7S36V9WWqtiLck6jYncumdtELQUz
	 ipYelnd9qQvi4vg1bX5PZ2BPQzcwYtRQy5Gd+32CLscFklupDTN7yRk+YsjP2I/HDWq6u
	 Y7bTHGDhYKsUywdFmP51SHmzVZg5fhDi9XPEs+GzI41C/y8w3LkvAR6mAzfRRmaBfIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673153;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K2w/1aODXGS11yhT735RxqUDNCVWG/JQybAS9j/Br5k=;
	b=HpAYvvJ3S897BioGL1foUSEZaKAR2lfhGq26Vva7UUcHcxoUPlYkU9f1GGVdlOmcN5ZD
	 RTzP8bZLFljn7q9XON8e1s8Q+vvlXmNUVeBnHIoIc4OXMd7dRrKjN+3JDDrZSLLyxjd71
	 sqNWyfFFgM/vVdBCkniemzECtjCJ2qoh4927KLomL8pRcGGyy7adQFLIsyM8hIxqJ/LJC
	 XeGLLgYBMblgT2r43+4Cgbjj8R2sA+vNy7/w/J3J+Ziq7cETB3pJQNqOvTjZd6HtYiwGm
	 Hr8eVsw+x85bl43K6sP3ikjUIny3A2uIJ8Py2aRQn8g1b0TbBhMwTZ+7DKH3mnqHkdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=srQXsOnU;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412CB606A321
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 06:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 412CB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=srQXsOnU
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso6135732a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 22:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795673151; x=1796277951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K2w/1aODXGS11yhT735RxqUDNCVWG/JQybAS9j/Br5k=;
        b=srQXsOnUbIe+yOvXGizDiHcRFTgXgUPec+iEgJL1LEhpt3YAOtiqM05U4GLRXt0O9/
         xkDUz/3GJ4yr3FIv+na6BI7SeML9XpT5NXqoxbKwJnb8Y//JjMBX7TSRjuRWHcUIKvoy
         xpZIo5OwRAbfjJytv4UbC6X6LuDUnb5iahRKKQXYGG+xXalz1c5I/w00YfmZcb/XlLao
         4BCh7002fVseUAfru66L0WlX+B5QT9wXXaE9HUtox53ft1b8Byr8st8kn3rVQOnDmmTY
         VRa25e7sKqRXPXH07S2KT9PrHYjy4DsGFALIBKVBndb4dTjj1jUez6OtBOyinsSYydDu
         PXKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795673151; x=1796277951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K2w/1aODXGS11yhT735RxqUDNCVWG/JQybAS9j/Br5k=;
        b=byNeYa8JoNLbZ/DOlTwop0VQgI4zyK8WqkPtjtplZxQJ75QnYjxvociNhr0ImQicHu
         Zbtkq0m9Htiwj36UVpuNHW2TrE46aPIXa6QFgACLUKuFRHLLr4TY2fvJ8qjzkipPQcGe
         JzQpTZ7Vf3Wd/muK22Hmac3brdu0Kw6m87Ygi1UqtlfQfHGBgQfQIpWpfEiSY+UMab/K
         YdMGURyTgFH9fK5Mloj3N7CVJv9B9uhqmVH05JNqd+ySX9v0AWTQK/pQ20m9rqQ93rWj
         n47XZm6R3o5pzQ1KAdv7kixOAHOsbL4qS6tREeuPh6TSoZETxKqNoP0k7IXPQ+AvXmxx
         YQMQ==
X-Gm-Message-State: APuU4Z9cv/MeGCt4utrid+HVQLRWkn2/7Gb98x7LnDkSDACPhm++2/ro
	ibTbcqZBwETMHPW+X66Dl8mehkh6mM/EaYhD+k4wOLcVN858dOLYT1F1
X-Gm-Gg: AZFdTZdSo8KDn45bEBNSsF/Up7190qkyPSP0FPbGPnAq4+SOe/nQ/5uFWQbCcv3U2Ve
	kaGkr1tj5AvYFq9qVhVzx9QffH63+N4lJb3WY/Obb3FAAXQLibh7SM0VW9K1GqXmXJ0GQWtKuPY
	K5NvjjaMnjLDkxTGZS0isKv2yvr5fO+zN7CR31Ck+R72EXibqmiI57+IaW52sOASOIVswHGyA1W
	EhRamgri4KwTmGRnpBF+5Ejn2CTmE0o8ew+w6XWS1548Szh9tAPbBvOK7HgqYRYIVziUxo0uRba
	4t4TqYMoZQ7LJf+ELIuQNAqUly3/N1/l4RJ4pf5vW6CWgnF12Iwap5MLEJusOnS9BI5lfTsdUuV
	PN87HyrCNXsRbMo9OigsPODUxGqAS2GQTtdO2Pfl3Nt7CUDjklmunyUy2BTreZys6m0xYBcx6pG
	JIH3WaUeGMwcWNgQT7/x+6ukIzcQ7N9e1AxgWIjJjy0RLaRoNV1iCTa9im2rp1+mwy3nV96uc4Y
	bSarfgB9NXA01NjY0pO0wUEDxfCCXTrUvY8V9fH+p29nz5ykVhf2s1FC9zrjfTluVDCenmEHES/
	LfdbUoGncSDG3XzfzVSRLcFTsSw0vA171YeReHFIdKaMPiDLkw==
X-Received: by 2002:a17:90b:57c6:b0:3a8:786a:cfed with SMTP id 98e67ed59e1d1-3b41c9617ffmr14060282a91.37.1795673151496;
        Wed, 25 Nov 2026 22:05:51 -0800 (PST)
Received: from fedora.tailc1fb0a.ts.net ([172.219.65.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ec698dsm33465721a91.14.2026.11.25.22.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 22:05:51 -0800 (PST)
From: Artem Novak <artem122novak@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Novak <artem122novak@gmail.com>
Subject: [PATCH v2] crypto: tcrypt: avoid 32-bit overflow in throughput calculation
Date: Thu, 26 Nov 2026 00:05:48 -0600
Message-ID: <20261126060548.24746-1-artem122novak@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126055600.23172-1-artem122novak@gmail.com>
References: <20261126055600.23172-1-artem122novak@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cast bcount to u64 before multiplying by blen to prevent 32-bit
overflow when calculating throughput on 32-bit architectures.

Fixes: beb63da739f7 ("crypto: tcrypt - Add speed tests for async hashing")

Signed-off-by: Artem Novak <artem122novak@gmail.com>
---
 crypto/tcrypt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e6834bdde9b9..1e6132045c24 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -28,6 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
@@ -734,6 +735,7 @@ static int test_ahash_jiffies_digest(struct tcrypt_ahash_request *treq,
 {
 	struct ahash_request *req = treq->req;
 	unsigned long start, end;
+	u64 bytes;
 	int bcount;
 	int ret;
 
@@ -744,8 +746,9 @@ static int test_ahash_jiffies_digest(struct tcrypt_ahash_request *treq,
 			return ret;
 	}
 
-	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
-		bcount / secs, ((long)bcount * blen) / secs);
+	bytes = div_u64((u64)bcount * blen, secs);
+	pr_cont("%6u opers/sec, %9llu bytes/sec\n",
+		bcount / secs, (unsigned long long)bytes);
 
 	return 0;
 }
@@ -755,6 +758,7 @@ static int test_ahash_jiffies(struct tcrypt_ahash_request *treq, int blen,
 {
 	struct ahash_request *req = treq->req;
 	unsigned long start, end;
+	u64 bytes;
 	int bcount, pcount;
 	int ret;
 
@@ -777,8 +781,9 @@ static int test_ahash_jiffies(struct tcrypt_ahash_request *treq, int blen,
 			return ret;
 	}
 
-	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
-		bcount / secs, ((long)bcount * blen) / secs);
+	bytes = div_u64((u64)bcount * blen, secs);
+	pr_cont("%6u opers/sec, %9llu bytes/sec\n",
+		bcount / secs, (unsigned long long)bytes);
 
 	return 0;
 }
-- 
2.56.1

