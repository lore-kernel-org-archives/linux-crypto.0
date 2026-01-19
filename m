Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F93C3587AE
	for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 09:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815660; cv=none; b=Ybt062wT8Hz0Az8Y6g0KjSej4a3UrluL2h8oYmjh/pnZDvJ5NW++cjd2e+v5FjiOAh1+V9U3Jxws6vC/L8NLMdwm69/bJ0vToXetZgKslU/D9O+JE4sxlnCNtsCI9+hLgzW9P8F9yEcNAwrz2zLSikvTiDBU9L/5ngvMn2QIbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815660; c=relaxed/simple;
	bh=y9/1uLJMC7+X7yi1h38x4esMDvrYwSDX9pt6Sh+Dy/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bXzDEGiYLlt1ph02C0OLb9Pwo1frs55Ojige1E3ooe+TFcqW9GG8fVHfzaBSSkm8mMpVi0R2jQUWrEgVfvIXNiMCWcw5UO5VhuT72CyUkUG5G5mhAcWjVpa33/pRgNYSw4iPrp11/s+M1z9Dx7pYr1npeR3LN4yC6ISICK1vrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lSImHJBn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lSImHJBn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47edc79ff28so25949025e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 01:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768815657; x=1769420457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CA3Nu437Rj+eAevya/i4iek0cQKs4Ymlx+qux+GVc44=;
        b=lSImHJBn+H6dS9/VrEouBwalyZflWzpJgQBwyX65HgE62415Bckxo4Bu/5W8G0TZzH
         ZWm070IlDWr73MbNf+U9SOQ1927APAYEc5S6T5+xGmYROb5bFuBAMbssknpHrzBTJvfq
         zxz6HmOUw4dO0X2Ziwe6p2S9qfFP01tYL79zXp6ca34KHL2vz7nXNNT0l5kp1Z8w2n0f
         Mm9p9jvGl0j28oYIvUix+b2KaEwTPY7pTji2P51gSrS/ubz6j6lUGRET9TFa1ffQacBV
         B1Ggusozm+sqPd2mhGIUicx7ioCLsPI6kIr+HXRgJeqLZQ830oXjTWWYBycc8mmlbNoU
         mV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815657; x=1769420457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CA3Nu437Rj+eAevya/i4iek0cQKs4Ymlx+qux+GVc44=;
        b=G/5BrCSfLMurpmmCSE2n1XVBmWv+1ExIjwNiUp00DqSZPSKmaiMYUcSn/YeQT0YzBr
         MrfbfkMXoakHFAwBTgB99lSjRUdrTyWPPW/jRrE7HE0s3pHvqR4usS5g3ORea6OOC7a7
         JCaH1IJe5W8xfJW/ntYMXkBQM8KPg4HsJQoJKqMivyxfwOOt/7bPZh3rnX4OHsqsl0at
         G5sja/LmohlusGkR/00gUtjJwg2yxNRT12hXxEVPT+g3HOtCJWJ5gEWtEidyYXhqo5cg
         xePGF4mfV2vNT6F5VDRyy78HZ4VnWrUG+1YsFz5H+jgVhhTU5GGs7AdhL6QBuYNiWdHc
         XM9g==
X-Forwarded-Encrypted: i=1; AJvYcCXcAy66EkZnqRqfiWyAR2ZSGPyE2z7YuUoFX69dK1BdRAM3S3q7Pp4fSB9sR+Z3HMA/sNeu+NTMpuf3zhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsOyz/r4+3PfqJ+khasrMQHNsz3pCBP7Xu8mJndd9pjP4aMqlb
	CIbbDBh5GtEbi7tLfRKkUIA+uDIMWb7OeEFtaS/efYuPxC58uC+fAospivI1sFLadvo6+3peEaD
	7jw==
X-Received: from wmbka9.prod.google.com ([2002:a05:600c:5849:b0:480:2880:4d51])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:6413:10b0:480:1e40:3d2
 with SMTP id 5b1f17b1804b1-4801e400518mr100658775e9.29.1768815656749; Mon, 19
 Jan 2026 01:40:56 -0800 (PST)
Date: Mon, 19 Jan 2026 10:05:54 +0100
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260119094029.1344361-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119094029.1344361-5-elver@google.com>
Subject: [PATCH tip/locking/core 4/6] crypto: Use scoped init guard
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, Bart Van Assche <bvanassche@acm.org>, 
	kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Convert lock initialization to scoped guarded initialization where
lock-guarded members are initialized in the same scope.

This ensures the context analysis treats the context as active during member
initialization. This is required to avoid errors once implicit context
assertion is removed.

Signed-off-by: Marco Elver <elver@google.com>
---
 crypto/crypto_engine.c | 2 +-
 crypto/drbg.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 1653a4bf5b31..afb6848f7df4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -453,7 +453,7 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	spin_lock_init(&engine->queue_lock);
+	guard(spinlock_init)(&engine->queue_lock);
 	crypto_init_queue(&engine->queue, qlen);
 
 	engine->kworker = kthread_run_worker(0, "%s", engine->name);
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 0a6f6c05a78f..21b339c76cca 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1780,7 +1780,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	if (!drbg)
 		return -ENOMEM;
 
-	mutex_init(&drbg->drbg_mutex);
+	guard(mutex_init)(&drbg->drbg_mutex);
 	drbg->core = &drbg_cores[coreref];
 	drbg->reseed_threshold = drbg_max_requests(drbg);
 
-- 
2.52.0.457.g6b5491de43-goog

