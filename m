Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC793570AE
	for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 09:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815657; cv=none; b=gQkGFvU61LKfZeaHNG9qpZz8HXDeX7fOkG1GTWGKT2/QIqokiOjjOHO6+ims3S9wwaB5PANnDL2ewHR8HWrBKXfN7/Qq25eLfwxwHy9qCgOZEAb4qkESRojEBVWPrFQn9Bn/DrNadgYbttUzpWrmb1+04Y3aIQ2cegCMBZ02tvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815657; c=relaxed/simple;
	bh=imqmTq6qC6AvvOLRifzHIuTmTh3LUGINsRwO5tNrj/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=soij/RCdAECcj9cwmnb3cGEaYdoIAoZ2wNk+LoY6++zG4OgdEFpn8ouvSQYdGAf758r/+vhwngP3pS65nm5PMbastcRDEOwKWNLO7pko7h1ZCdlOJCwPohKaiCgoCYiW1/I3jdKdjiA38VtdhZvIrvcUCp9fdJQ0jm7w9/ZGlPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L0VmLEdg; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L0VmLEdg"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4325b81081aso3412862f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jan 2026 01:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768815654; x=1769420454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ewHt49qLKu+2CyU8hq2cJxrH6CXFZn4CCknA2bnTf50=;
        b=L0VmLEdgoX6kCOGL+kVmGoou8lkrcSDOzhY4t3FvkKZVtXnffe2NED9Ya/eFvT073L
         9qeidD7dBAfbdSFEhPGSQYdWlA78OmsNTD45oqGOil2WnYmQSwLpc3SLv37vF5BuVMzj
         /9mUS/gLpY84Divp/8aksNlIbLVBfInc4eKrBAOR/xsE8V5cAoPRgBPNGwMq+t1JUKO6
         aQXcPLFEFuRoFsKOaHZ7O1n4BG0BMTyIpbZSJclAZHpFkwYzF6GvGEpS9uoV3pIj1Y4I
         80Ts40bFE/H33kCqH5NXBZTm27PpFkoSTpVjB694pHSmUS6dPgJ9grJp6CqygVLJfTYc
         QHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815654; x=1769420454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ewHt49qLKu+2CyU8hq2cJxrH6CXFZn4CCknA2bnTf50=;
        b=tFX6PcjY3ix/8/y+mCnPLlgySMEO+8T4g6wtTYm5qgMMzDQn3fxi0s4By58BMaV1w4
         yBJb2qRX4Ca0K1v9jFC8WYKpTeiaiHQllhPIZ/LCoDkdOiDQG6G/aTUwiBOUWoaJ1j3C
         Q5oVljUdZ84VmuvPHy6xLYtq/oQV61yfC5LqIu7JCgPgObWON14Wvn4mOtUCwEmh5KfO
         8RXzFkwQ07KUZB11F/TSuJArq0qvX3y3noIc1xTIteXeqocL8vv2iwBLDyfET+OrqcEc
         DpTZ5hz1iBVaKBs3CIzhqtGlfRg+3neGuCTF5wSJihJSuZP/sMREftgXM97Pydl2gRQc
         wyjA==
X-Forwarded-Encrypted: i=1; AJvYcCVipaW/0FxfEgQ359oGHUVdHcr0a0NY0qZxxJcndQ+v+8bg5hcdh9j3WkU3C1FUPYNsyk5yZG+pbsJzxKA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSUQEBINymstsTfDwqxCGUn+83z4TEsadFrSXX1haNyzxUvyqJ
	bA4kNFUmbE/ofWx6OqeV/0IF7n1TwDSGslMEcV+KQ3P0oU9yYWaXldgRwag2UH7V5bLN5faG+Mf
	vXg==
X-Received: from wrsz3.prod.google.com ([2002:a5d:4c83:0:b0:430:fcb8:38c0])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64e9:0:b0:432:5bf9:cf22
 with SMTP id ffacd0b85a97d-435699709f8mr14538540f8f.3.1768815653726; Mon, 19
 Jan 2026 01:40:53 -0800 (PST)
Date: Mon, 19 Jan 2026 10:05:53 +0100
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260119094029.1344361-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119094029.1344361-4-elver@google.com>
Subject: [PATCH tip/locking/core 3/6] kcov: Use scoped init guard
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

This ensures the context analysis treats the context as active during
member initialization. This is required to avoid errors once implicit
context assertion is removed.

Signed-off-by: Marco Elver <elver@google.com>
---
 kernel/kcov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 6cbc6e2d8aee..5397d0c14127 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -530,7 +530,7 @@ static int kcov_open(struct inode *inode, struct file *filep)
 	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
 	if (!kcov)
 		return -ENOMEM;
-	spin_lock_init(&kcov->lock);
+	guard(spinlock_init)(&kcov->lock);
 	kcov->mode = KCOV_MODE_DISABLED;
 	kcov->sequence = 1;
 	refcount_set(&kcov->refcount, 1);
-- 
2.52.0.457.g6b5491de43-goog

