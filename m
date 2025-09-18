Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27831BCA4
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204417; cv=none; b=TuRXx+nDXFJHKm0qbQXdxrO+DSsqJFurBDCjodEHI97OL2oNyYWVoAwJgWyrfm5ihQGPeo05st/O3wXiomg7Jzpu6W7rgsElbLAAhSt6tEAddCf/SdoiQccK4WMobXEu2JMW0sa2p1S9FEpzTsm0uA45a8cP6vH1puetqyxV9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204417; c=relaxed/simple;
	bh=f/yC9haOsA7BuarNCC3Pq5BbPzMSt2OIoizyVyq6JDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A3pUcCi431ZA9+IorXgaKJGyA9OlxPRQZJpjsMiIepiauR+4Zav7YrUw0JfcevZzK+GuoIinh/7Tudy3gJl2XsWNmZpMmNKcFVYgjUq26vds3IbGgJHR/Xon1SDOmclYIMNDfI+bZGQv5EPWDvjNyb3wpt/fsXqt0h2lWJeVZLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t8vOpk6Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t8vOpk6Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45f2b9b99f0so6250265e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204413; x=1758809213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6Ln8CuHzwdFEdgMDhrRww1RTgWw9IPMarfKDLj88go=;
        b=t8vOpk6Y6MEgPKLXIi7qXgMLuYC4bVa0rSPtnndiMyaunSpEWKjVPtfUV+ejO0COBA
         wjVshp2hzkV7120q2Q08p0t9hKJ876Hy0TBRd9++xWoyXryVNRTc06uhzRRyRM59YmEw
         Cgg1iVIpG2fRw4MRVDXrdTWzkq062m8PubCivdk1EQZX9uGhXdMHyQV1Iea4Srrtyn4U
         95v7q/vRZquGECEezm8/yA+W4jsqRDltKwptgx085O0ZYBCmCaK/89MQ5E2FDcMNvCK5
         dbL+YDYd3eWuxcSWDDkAnTvUWomi8meVJALt/B6KumBe+elCbQ+UNsPsw/+B/r1y38Ua
         vFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204413; x=1758809213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6Ln8CuHzwdFEdgMDhrRww1RTgWw9IPMarfKDLj88go=;
        b=FEAdzgJaifNYeyjZ7SZHCdaj7t0hbMu0YOvwKDlrZQmB9zoCzZsF8MXp5J+t7QoCXP
         XmWWjyke2tOJfRkZRBEexjMikRfz0Yurb+yQTNZOvSD+R5VmCfrD90rIFd8cP1Gm5cSk
         Axn2DhMHqxnZQuiJnKR2PRgj7+qKPjxPOO3h9CTJf+TQpTadBxzmTFcV9HpXXWrsnU7c
         k82s6TkyHcCzgyb2G2TSu/m+1qDtkSJKXcrHAxlKg+6HNELPgPeREHwbBea8Cw3XxMox
         KxHssmIqDG6fbnFT8ntT6J5zeEPDBvJFkGpC5Ls2WSLMV6+I4WuERapDBXFK0LwlX9Cl
         FmOA==
X-Forwarded-Encrypted: i=1; AJvYcCUOpmyCFGRotWTaFO5MTZHlxUHSY/vUfbK8lk/+HHSrCJwG8BRgS8MorkmfVQHuvuT+ZVUsO6X3V9YgRWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmVSpB6GRF6MHOJlmqzpJJNhzr+pLNL6008QnmIsqMOFvwSzIg
	KWqBOScX9G73mSMosbA0m9jAP85P5pVpdc2YSVAxMuhslzCN9LXdq9GbJUPj1nlRwIkJYVtS3bM
	RFg==
X-Google-Smtp-Source: AGHT+IGP0WbxoqdPlneUX2xKJu9++ZlvQ/e8NDERumQ6O0subVDhFhk6LjXgg12JZHvhR56srQ1YmvrO2Q==
X-Received: from wmbhc26.prod.google.com ([2002:a05:600c:871a:b0:45f:2859:5428])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:cbd6:0:b0:45b:47e1:ef7b
 with SMTP id 5b1f17b1804b1-46506364ce0mr25439175e9.17.1758204413172; Thu, 18
 Sep 2025 07:06:53 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:43 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-33-elver@google.com>
Subject: [PATCH v3 32/35] printk: Move locking annotation to printk.c
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

With Sparse support gone, Clang is a bit more strict and warns:

./include/linux/console.h:492:50: error: use of undeclared identifier 'console_mutex'
  492 | extern void console_list_unlock(void) __releases(console_mutex);

Since it does not make sense to make console_mutex itself global, move
the annotation to printk.c. Capability analysis remains disabled for
printk.c.

This is needed to enable capability analysis for modules that include
<linux/console.h>.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 include/linux/console.h | 4 ++--
 kernel/printk/printk.c  | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index 8f10d0a85bb4..6bc0a42e118c 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -488,8 +488,8 @@ static inline bool console_srcu_read_lock_is_held(void)
 extern int console_srcu_read_lock(void);
 extern void console_srcu_read_unlock(int cookie);
 
-extern void console_list_lock(void) __acquires(console_mutex);
-extern void console_list_unlock(void) __releases(console_mutex);
+extern void console_list_lock(void);
+extern void console_list_unlock(void);
 
 extern struct hlist_head console_list;
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0efbcdda9aab..e0bfc66152aa 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -244,6 +244,7 @@ int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
  * For console list or console->flags updates
  */
 void console_list_lock(void)
+	__acquires(&console_mutex)
 {
 	/*
 	 * In unregister_console() and console_force_preferred_locked(),
@@ -268,6 +269,7 @@ EXPORT_SYMBOL(console_list_lock);
  * Counterpart to console_list_lock()
  */
 void console_list_unlock(void)
+	__releases(&console_mutex)
 {
 	mutex_unlock(&console_mutex);
 }
-- 
2.51.0.384.g4c02a37b29-goog

