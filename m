Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1A8204683
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080369; cv=none; b=EwFJoIlYDy+38eRrEatZOBN+ANNh4RM7h/mwh8H0xFtpB+IRy8+oSOEtdlxJAv67pp2WLS1TRa5kb4FfI6SNvyFQ6VcjSueh6WIkN45EvuaafWQXnCkINCuYZhL6gSHDcHTSHIBaxljFZG/9VejjTHywahgkszbMQLgiEceSSCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080369; c=relaxed/simple;
	bh=X1ktC5ZjhhR5WSX79RqJwEmztNg59gjqNnHaZ1eRNbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZMamePamrp8Ko+cs7pDxQ3QLHHT1P1dv5Fgl1yiMvZkIWXka/88CUGV1O15ugZSxQwWGWXfZVAfDKmqRiaAWdDqoxRS97qnCgeK5M4DhioCaHSTsU54KfktfARX1J3P9ryks9gPIbJYVS2KOkAgLjDBGD9CB0e3JtSGaCc8PQ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xg6WVpOx; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xg6WVpOx"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5da15447991so6390799a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080366; x=1741685166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ljSfvhYh8x6xwHsInA1Gu+wF89bLF/D0O2qs3l3oGhs=;
        b=Xg6WVpOxl4Uw1y9DqvyTg/3197RCryGmiSeYMqKUZTtF6ekER1WDtt4QMiXC1TPcg6
         HnOBzDtLMIUNk+pLQAEWYm23m6PNy2Axi/a9mFpCp7arNL23sz7yugjjTL0VVBPQmfB3
         rLoYFizmAR8YildAdPPxqlIMei1XwrW9W//4YPDHVd6dlGFtPOIPYs0SyfHSDWoVscUQ
         Q3zeOgQlAbM9V4q7fahK+x+vvd7CKuq2ESx/uiBT7Lr3XUn3mpCh3w4zYvjgh8D83Kme
         I+feMdM/bDcLp18cuqHklttRGdhpsf3ipe5zBWljPKEX9UY/59IQ05SWZKiEKS+iGxN/
         jq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080366; x=1741685166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljSfvhYh8x6xwHsInA1Gu+wF89bLF/D0O2qs3l3oGhs=;
        b=k8GG89t1KFvexQd2rHa7vHoI74bM29pbUHhtk6VsvcEA6tiyZ14r3Za1axJBGE0kip
         6DypXTwE/P33Nb7zR7EZD2Eywx+z8Iw56dIZzXqtt3gVxQzukAmYbnNS45sz6FKIrjvH
         sPKBdWFbdLa8ffmxfxvg4J9Y60M9ZeFolHKQ4kuHcQpikXmXyJnQMk8Y1bxEl49bZVuN
         1Ey4yqF1ADz62Wt0PGt3VPucvx21cqnKBml7Z2xWrNQ9br2cIwgAGqWH1+BRmoHl47k6
         91grx+c4RPgbQcs0hb5GPdOAXXuYQt9i1gre678XfRRm1rQhc7Zyl2ZRHzwSaFQvfUNy
         5T/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgCB97/YlxAET6bNY6N18Pq3kMr4P+Jwj3UPhj8M9cJQd4xpxWbf7y7kv2GAuJMj+OuCEFyE5gYnbvd9E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5nSIdN0Zn6ItyJWjfl9q/h77Xwdv6lxSVfyf4YCIO5v5ZqNIW
	OpsvapMSDRmx7fHPA5aAA+Q+CHBVz3QlPhIcpc+vL67NMOoaoe+OHjJaoKnMhiTRWJhY6YwbBA=
	=
X-Google-Smtp-Source: AGHT+IFrMBW+OhCnT9icBam/s/vk6OKWe4X42OWK7ynSC2VTQQKw5GLkAoEuFIfZ1S6J7yhnX5gf47Hang==
X-Received: from edbij24.prod.google.com ([2002:a05:6402:1598:b0:5de:504d:836a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:234e:b0:5dc:80ba:dda1
 with SMTP id 4fb4d7f45d1cf-5e4d6ad7afcmr43438170a12.9.1741080366105; Tue, 04
 Mar 2025 01:26:06 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:20 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-22-elver@google.com>
Subject: [PATCH v2 21/34] debugfs: Make debugfs_cancellation a capability struct
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When compiling include/linux/debugfs.h with CAPABILITY_ANALYSIS enabled,
we can see this error:

./include/linux/debugfs.h:239:17: error: use of undeclared identifier 'cancellation'
  239 | void __acquires(cancellation)

Move the __acquires(..) attribute after the declaration, so that the
compiler can see the cancellation function argument, as well as making
struct debugfs_cancellation a real capability to benefit from Clang's
capability analysis.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/debugfs.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index fa2568b4380d..c6a429381887 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -240,18 +240,16 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
  * @cancel: callback to call
  * @cancel_data: extra data for the callback to call
  */
-struct debugfs_cancellation {
+struct_with_capability(debugfs_cancellation) {
 	struct list_head list;
 	void (*cancel)(struct dentry *, void *);
 	void *cancel_data;
 };
 
-void __acquires(cancellation)
-debugfs_enter_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
-void __releases(cancellation)
-debugfs_leave_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
+void debugfs_enter_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __acquires(cancellation);
+void debugfs_leave_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __releases(cancellation);
 
 #else
 
-- 
2.48.1.711.g2feabab25a-goog

