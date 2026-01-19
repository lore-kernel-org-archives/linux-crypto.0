Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3696C358D03
	for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815662; cv=none; b=A+idvqoSoq/x+rvx7PNH4AB/kSZrHy8NQubRc4QPzkiPFviRo9JrthPT6fOdpeFV4mERsUttsecd+KdmgrEDLTeC3v4O7p7G4/5Uio3LlXw9YI+43EeT7RCGgj8Qq7LwlYTxufHlX7K4ZN+24wC2JY8WdY4C0OYIAho1Y9N+qdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815662; c=relaxed/simple;
	bh=fI1glmYoH1DqxqK83xKlTtx/Ar+iZrLYeSgCJ+MEbqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qz2Nbpe88Ks9SdhDzj2/AofKpVJgJl8vw8bDqUz/+34m1psrOqWcylY7k4AqRjAZXGY1WDE62QVSN0bVUD2BEkb7kzgqVTx78fiE/nxsn0GUM98X61Cm5NaBZXPKU+vd43qVKoRIiZnux5XjomT6CIiV7j0fPL/SuMBl44QEb34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uu0zsUK2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uu0zsUK2"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477c49f273fso38248575e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 01:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768815660; x=1769420460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5O5shuIyt2OF6tzGpJJeUtztHqWv8B89x7ZKRetoFcY=;
        b=uu0zsUK23jzmEiaM2Subjz/ybCMO0DMBce9778NGTfo96iqoQN8UXZCF7eAGW1zAT3
         4bXPHXoe4IY5Ab74cv7dW31EZpR0dAPxrNmiOqWzKk1duMMqVIfwXumBLoV6SLivHliF
         OVGP31IrWiXyDXqxnrIMDT07qTvhg5kaA2eebblQxjVyRlzpwrKlyvxmgXw2uiYRSt4a
         qQkayttv06jd9yRvkrwzByurgxm1GzM2kHfF2jfp0JcvmcjoKD8Gt4yh4FMawZOogYYJ
         gib4rQeHt5rR/+JTTx9fvr3DO0QmcBz87i8Ktb0EwJX3xBvcluAHub0hFBzJewhzcXUx
         f69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815660; x=1769420460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5O5shuIyt2OF6tzGpJJeUtztHqWv8B89x7ZKRetoFcY=;
        b=fWBgdSNmbbc0Wsr9j/cR1UbQw6PJGvVubXeCwWtBRh6r6BbPIetO2xsT+4hNwUun8K
         d11cGe8FQaOWVa+vR524CP4NR6yOlgMv74HHA6HUgt/pHOpkDhumGob5kXZcTf6GUaJn
         gpsDpNM1ncGt4jQjVxNy+tBdu7GXoC1bM1V3HXnKtChmkSYQnQcxHwaShIvcWTezSr2b
         WWdxifeYsPKLHjcbBKuj4/rl8SYUqz0SV17vNvSqulMI3m5k/Qfy+BpK9re8x+e8AkAK
         OdHjE9l7zcSU8Y/qRc47QEBgzqR9CnSPik8ABJ4ES8JN/IW00SYR1ocLbcBszGxXZffe
         9iGw==
X-Forwarded-Encrypted: i=1; AJvYcCVjE+i9bffWOLgjx/IY8x5qoeXzXiGU/2IDWP7Z8nVHnnCw5lMgNj6MRWNin5UaKknqLp7Co/zR10uxN/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YypqvMu6FzDH3uowQ2OjFGNUjF3hSOJZsmIHWGlY5iSigN6IAPY
	S+bBndsKzee1rRuWnfNl0B5qG18tPc5inrfTX5f06iAS+OJbJp/0rVEsJvXAQRvu68eX4qa/j1s
	ozg==
X-Received: from wmbhb2.prod.google.com ([2002:a05:600c:8682:b0:480:3842:3532])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b81:b0:480:32da:f338
 with SMTP id 5b1f17b1804b1-48032daf48bmr41618245e9.14.1768815659820; Mon, 19
 Jan 2026 01:40:59 -0800 (PST)
Date: Mon, 19 Jan 2026 10:05:55 +0100
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260119094029.1344361-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119094029.1344361-6-elver@google.com>
Subject: [PATCH tip/locking/core 5/6] tomoyo: Use scoped init guard
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
 security/tomoyo/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 86ce56c32d37..7e1f825d903b 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2557,7 +2557,7 @@ int tomoyo_open_control(const u8 type, struct file *file)
 
 	if (!head)
 		return -ENOMEM;
-	mutex_init(&head->io_sem);
+	guard(mutex_init)(&head->io_sem);
 	head->type = type;
 	switch (type) {
 	case TOMOYO_DOMAINPOLICY:
-- 
2.52.0.457.g6b5491de43-goog

