Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B987C120
	for <linux-crypto@vger.kernel.org>; Sat, 14 Jun 2025 00:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859728; cv=none; b=fuhDb6ZSKhw0cZG4ZWb/C97BHCJSO859fN/wC8G6bLWE8SzjAl4FI0kPR5X11Q7hzFbyqScXJoKiOB47eD6PMJ7hTkg/TiRbLlBnn1UliOtB8w+nCCKt54pGdM2sjfFU5CQI7C0N47Ofev2X0Euf8+tIzu13Z+5oFj8Qd5FOX6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859728; c=relaxed/simple;
	bh=foA6oyqgR5qgnydNJ6GYL4dauZjrmBgM5QlI2k6EVy4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PKKqnOnlD0pOuDoD9Cd0wiwuw4k1oSln9Zp36ZP3QBM3eVYCjx88ZXpO093m72X+00NLzrEQAEGe7sUhMV0/WOoaY9FeGqXIZjZRY+/Lys7LjLsiAp/j2fn1TVYXacHGxF1+efqNkYbY4ssLXIMCcCUf3YstB4Erhii3i8hWZc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g2ByygCU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g2ByygCU"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2728693a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 17:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749859726; x=1750464526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l3yN+pb1nHRQrMzXHzyq/fi9BjDqDpB+21NaqBWaxXY=;
        b=g2ByygCUSUkcR5IgFyj+ng2Nsda43wh7zlKOARFnf27gkG3CD0UEmQMsoZzIniEDBF
         fpQ7NJodK1jR+NtK63uXyJEFQAlaS3elPbjAqCMjrigIPH7SfOECERcciDzDvVuWjsb1
         ukh/dTJznt+o3X5Fr72Hk7gbk/iRke9TsHg8thBTHKC3Vuh+/en5frVKmXGNHOUnQEdP
         wlRC5fJ7wpEhBwHtu6obOpEU3/zbT2NkIvoTQLegw1MCVddkJPK3Ex8Uqo7v1EEX7vwq
         2RB044RSvmwfYm3eaw/chlXf6QaqlK79hXZKk07HKwkU9bbHnKqyM0GcjXszn3fWJg7t
         dskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749859726; x=1750464526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3yN+pb1nHRQrMzXHzyq/fi9BjDqDpB+21NaqBWaxXY=;
        b=udKTALMEx2hEXYCPx+VqguLzlA6z7h9ulVii8EdIB0zgIiPfC5ptAM9u/rT7gStGwL
         qCCBhnFREZGpwFJMqcRu4UcSnOLEUAXv1YDGGabVVXPPqjelnrrS3Zum+D8QH/KyXGdA
         LhxVh4YN3/KYKRtqKGammULHwCgBdvZcJyva59RNPnqp0sD+A0AEhxGgn+jx1Wt6QcXF
         5lNhFXKPRHAo5A2xkWLGa/vU197x9/BTO4DRywmZ+qFEjSXvi+4kstuvhvndjIGAoek5
         lODEfjH5SMhMxo7u9ByURVRcwUDtxkRRKnsfRR4nDsmK8VGfbRu+3nt9mlRsvvy7+3fe
         5jTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWocjhPCh51GSfju6eNV4ZhcpmvF85gje+mmn24b4+gmj0dc/p5lrTdXpkZ2BKsCmbi4p7B47/Q+Ze7IyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBPaHrRLdbToRie+YmtVJw5t53yPT9Ltj5SsAv4Gd5l8GrD4z
	NuKkVY03iQOmbov8QqsfpRVSekQx4gCUyJ793Ff4H5RZBthmQq8DKs+NEbJpX9u9oFf9LdeGVKU
	Y4ohmwA==
X-Google-Smtp-Source: AGHT+IE6UM0RmST7g5H5n/ibK6y/YCjmguPYg7pTwOXIkmY9pOYlCloFeEz5pTDQwVFdDlqtC5ZLYXEmAWE=
X-Received: from pjh14.prod.google.com ([2002:a17:90b:3f8e:b0:311:f309:e314])
 (user=yuzhuo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3504:b0:312:959:dc4f
 with SMTP id 98e67ed59e1d1-313f1c77fc2mr1955724a91.5.1749859726587; Fri, 13
 Jun 2025 17:08:46 -0700 (PDT)
Date: Fri, 13 Jun 2025 17:08:28 -0700
In-Reply-To: <20250614000828.311722-1-yuzhuo@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250614000828.311722-1-yuzhuo@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250614000828.311722-3-yuzhuo@google.com>
Subject: [PATCH v1 2/2] crypto: Fix sha1 signed pointer comparison compile error
From: Yuzhuo Jing <yuzhuo@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Ian Rogers <irogers@google.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Yuzhuo Jing <yuzhuo@google.com>
Content-Type: text/plain; charset="UTF-8"

In include/crypto/sha1_base.h, sha1_block_fn type is defined as
void(sha1_block_fn)(struct sha1_state *sst, u8 const *src, int blocks);

In lib/crypto/sha1.c, the second argument on sha1_transform is defined
as "const char *", which causes type mismatch when calling
sha1_transform from sha1_generic_block_fn in crypto/sha1_generic.c.

We don't break the widely used sha1_block_fn or sha1_transform function
signatures, so this patch converts the pointer sign at usage to fix the
compile error for environments that enable -Werror=pointer-sign.

Signed-off-by: Yuzhuo Jing <yuzhuo@google.com>
---
 crypto/sha1_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 325b57fe28dc..3a3f9608b989 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -33,7 +33,7 @@ static void sha1_generic_block_fn(struct sha1_state *sst, u8 const *src,
 	u32 temp[SHA1_WORKSPACE_WORDS];
 
 	while (blocks--) {
-		sha1_transform(sst->state, src, temp);
+		sha1_transform(sst->state, (const char *)src, temp);
 		src += SHA1_BLOCK_SIZE;
 	}
 	memzero_explicit(temp, sizeof(temp));
-- 
2.50.0.rc1.591.g9c95f17f64-goog

