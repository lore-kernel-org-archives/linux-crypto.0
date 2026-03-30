Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F22E8B67
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774855455; cv=none; b=JI/k1VJtPu2GAFLBj3OKw56HQEBrGuRaEOd4iD0JibyKlmwwHAn+6EbDoxoepy//HWJ1jfbDNiEeJ3MBSY1U16ZL7LyGt1Avit72QANdZUhdLZ/J415OuoszzocFs5h1t8SkvBatqJd89Wv+fCM7L9lL+1UireS+0BwwXmF6i+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774855455; c=relaxed/simple;
	bh=4JwX3jFjdk7R1D6dw/duUhkQimyTXLDV1kEdc15MnSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCRpxZF4wf7lAgU1oXcdsG0am1OhI4TNxFDyL5kva6ujpTvFrvHjm3jMLWxOjG5ttH2Zuq3M/Xnkuc/317BRhkinJiQbHkEeYhnAz5QhVYXyM20NSurny0gt74mBbG5DvGUuZV/NzYA+eZiIIcfEKqodRXNMcMp0XxsBWSIqiYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AsicJOed; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsicJOed"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b256a4c6b5so2102285ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 00:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774855453; x=1775460253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azL0YMkp/P7bgJBWb5WmA/dZz2zB31n5FihM/JzJhpA=;
        b=AsicJOedh1H2zfd1ykuDYeqsGGdT6EhTlHx+O8aak3fKe+45ZzbKUbohJ3jrWBYmYn
         eADB5AoBa4ZPLjYbHJsY4++jQ5eLKzHRGfMooGN3ma4HU2IZuU8pRgBCU+Fu0n0EdetL
         /R4yCy2ZAnVNNfk0kQ9KoCG5hzqDQMVGLNK2Ky673/YNyz9iRDud2eVr8e6hQ0/Wb2wI
         VmbrCJnb6uFsxVAEXT2J9CrZY5MfqKluX9Nvfuz/yT9bD4qxkktKb8Kk01C0/koIyYaQ
         jAiHjTkfLR/s19fHQKYYNucsDixAuhC5njNdLFyW/BRnSIRVhbRB/+6ufVXWa42pX5P9
         V44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774855453; x=1775460253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=azL0YMkp/P7bgJBWb5WmA/dZz2zB31n5FihM/JzJhpA=;
        b=YlSHj3dgZRLNneUgNL15uW1U+PHhSdb0BqGhdpyoZAUj+5tS5TzxmJIRbnqApP/oJA
         79OTPvogiPzdrWjt6JCRhmIxXuO8BXxEP7xLbcYgXxiLGXd4KlKOZtBMF0xmqw4rWIcs
         5DFiP0WIG6ATTu0lhIc50hFYhkD9blOaX9fBDy3AAeGbR/IVVuEdE0/2UgNWIgICZSrS
         yBZnXMY1sxUE495E5+5uW6rT4cHeT1E6Axi9WI1fBDLROUTObVe/fGm6uXKd0D7aLT0g
         8xMoevmMlR/grCAhscA7OgBdXWT6u7In+tOKyMdGh4XAWWQGpJ7USPgtaGfw0MNqzC7j
         LcNA==
X-Gm-Message-State: AOJu0Yx4E9R4rkLawjIZWQJhWF9hNYUqRFMhBwfo6kXizThF5us78NCQ
	+15LV0jsE3rKJHv32+hKHRz0M6VuvdP6GqeTHaX2Bf4BcfpfrnhjMSavVInqDjWlFiY=
X-Gm-Gg: ATEYQzzWi/HpS46RF1Y6S2T6aCnjkF9P2QrqLI1a5FdFosGiZ9d/hJ82nk+qExmfqby
	s7PvIrzJlsoV1xagOG0HSymGuRP1TutD1ocdfSOq5851yeolYurqa4rGlSKxUC41yCL7J3uhWH8
	Skx2rHrvCmxoTWOSrnNlYsbtnRgIp4+zkvvF6xoX/H1A0A+OXwydrfKUDymzn0XFzK47FqBfVVX
	8uN/ekSw/+Ynv0/I12GdcLa1Ci3Bui3lfu+qC0dMoq+tIb/WwoSozch9ThyQHbkq95i+yc+DsnH
	amX/fUwR6tyNa6AUZPv0szdgnjgU6NgBD233K4Krow+YQE99bVKlAmNkY6BhRUXvnfmQOfarPV2
	wjE10tjMlrKQoDxHw4CytFtqely4L/Fi/eCHumnj9hQCGQIgbebx0Dp+8hG4qz+ZJIB45Lm0/C/
	RZ2mcX51WX0CDYh9Lu322+YeEanKJteU0dy0gVAjGV4wco
X-Received: by 2002:a17:902:c94c:b0:2b0:5075:96d1 with SMTP id d9443c01a7336-2b0cdcc7f67mr121788445ad.24.1774855452861;
        Mon, 30 Mar 2026 00:24:12 -0700 (PDT)
Received: from cachyos-x8664.sustech.edu.cn ([116.6.234.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427c3a4esm87002045ad.78.2026.03.30.00.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 00:24:12 -0700 (PDT)
From: Haixin Xu <jerryxucs@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	smueller@chronox.de,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	jerryxucs@gmail.com
Subject: [PATCH 1/1] crypto: jitterentropy - replace long-held spinlock with mutex
Date: Mon, 30 Mar 2026 15:23:46 +0800
Message-ID: <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774854094.git.jerryxucs@gmail.com>
References: <cover.1774854094.git.jerryxucs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

jent_kcapi_random() serializes the shared jitterentropy state, but it
currently holds a spinlock across the jent_read_entropy() call. That
path performs expensive jitter collection and SHA3 conditioning, so
parallel readers can trigger stalls as contending waiters spin for
the same lock.

To prevent non-preemptible lock hold, replace rng->jent_lock with a
mutex so contended readers sleep instead of spinning on a shared lock
held across expensive entropy generation.

Fixes: bb5530e40824 ("crypto: jitterentropy - add jitterentropy RNG")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haixin Xu <jerryxucs@gmail.com>
---
 crypto/jitterentropy-kcapi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 7c880cf34c52..5edc6d285aa1 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -42,6 +42,7 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
@@ -193,7 +194,7 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
  ***************************************************************************/
 
 struct jitterentropy {
-	spinlock_t jent_lock;
+	struct mutex jent_lock;
 	struct rand_data *entropy_collector;
 	struct crypto_shash *tfm;
 	struct shash_desc *sdesc;
@@ -203,7 +204,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	if (rng->sdesc) {
 		shash_desc_zero(rng->sdesc);
@@ -218,7 +219,7 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -228,7 +229,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	struct shash_desc *sdesc;
 	int size, ret = 0;
 
-	spin_lock_init(&rng->jent_lock);
+	mutex_init(&rng->jent_lock);
 
 	/* Use SHA3-256 as conditioner */
 	hash = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
@@ -257,7 +258,6 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 		goto err;
 	}
 
-	spin_lock_init(&rng->jent_lock);
 	return 0;
 
 err:
@@ -272,7 +272,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 	struct jitterentropy *rng = crypto_rng_ctx(tfm);
 	int ret = 0;
 
-	spin_lock(&rng->jent_lock);
+	mutex_lock(&rng->jent_lock);
 
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
@@ -298,7 +298,7 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 		ret = -EINVAL;
 	}
 
-	spin_unlock(&rng->jent_lock);
+	mutex_unlock(&rng->jent_lock);
 
 	return ret;
 }
-- 
2.53.0

