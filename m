Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD671FFC6C
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080339; cv=none; b=H0a9vDdutIWL2GdRrLphFuAoZTyFStNjh8IPjxEMiQX3SXDJLIsfd535o5JrJcVPWgqNTy58PgYWC4yi6TzjpAWSls3WYqTRWH7f8TbHppYuKhjS+3QhpALRAqUt3FZWGr1EP+TYZb6qN79h6kJKjTA3jK1JOaTF3oec9mXEfsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080339; c=relaxed/simple;
	bh=R7NfOr2i/sd1rk+XA1fxYV0VoUux4hyfMe10hs/GFIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CH0SdxDH120RB3Js+vXZhdbE/PZxR9EVRoMM8PlcNSzYmTmhlbX9uPfQySQINNOi3YMdFjbE8LWCA0crJaEoXSqtmBg3Z4CIPmlt/dsVz+WAVodczUIx1GgxMtySE5LTh3aoMuZMUXwuID3VPWNjRPQoEOU4u39I6LF9hQ98pZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlAmr1h4; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlAmr1h4"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39101511442so1076009f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080336; x=1741685136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=istr0KCQ5s77c/egqf7KkvIi9CTO4kygD0ofOymfkU8=;
        b=rlAmr1h4tb0e7DR1b6Ty81Ysj52/sL90kwETBPR26PUOsIjJGG87QE9O3gItwv00Vs
         Z8DpPOcb65brK6KQIsGXxPMUtUjSTNOqY0d/GM2moRjBU4Uo8PMo4ov0WEkgnfnt6bKI
         GIZPjajsGg+HjL0fBOqC5XLFbI2kzBJplRdg3IBg4DGkNZMJqBQ752PRWW4ooCyx5MFR
         gz5sRV2QiT7pGJF18uh2zLFiGzF5nLVF4UlojBRP5Cziciad/zCwFhsHD1piNfFrhpY/
         A4N7N4cgX1wttIl0C0IwgKfHx6NaEqrRlTDgEL3ycBjmhW2BZp2kaHB6zJPOS3jVkfx6
         EJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080336; x=1741685136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=istr0KCQ5s77c/egqf7KkvIi9CTO4kygD0ofOymfkU8=;
        b=hpxOTzj0mfAqzVnLgUhrIeuI5LvcDmT87rH41dl+eVO3TQxW6rsQuziBgz9MwqEVt2
         B/g8iHN+K4n9BEgPYefd/Zt2yxPWyasbdxJpAGLiVjPftV04RWMs9LecgEe+ZBzJyzRZ
         dX2xPudtAQrJ5zU7Q3ycVAJZ+zWMOSmFZrZEPoZYRwljCiSlkTwbystO4rvWySJ9PfHQ
         E6HSAh9/RtglpOO2JmpoU5s3u03Bg9uCpiicEVE5kViZEs2uTH4xAB9qap6RDGcWCb7h
         zWc+oiESPZDZtNzt4fG0eBYFn5M93DgZOcTvTGPElDDYuNBEC1YPRAYaVR/r6oBo8cTH
         9wdA==
X-Forwarded-Encrypted: i=1; AJvYcCWDm3JvP5Vj3ix3DbOvQDurzpqX8r1EkQfheiefTcgoPEbBxJqQE3ap6uXAfIVh5M5AK8vCOvabTqMGk20=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSqt0/imY0fH7YaxJPboWlqZ9CdUsmLTy1dpWvyK+zQLmk9bWn
	bj5Z2SxtsO5/I0kssr+ijTpwj7uHeKtBRbtx5DTbGzkuTnkYtPCrcHoZDGn2O2n/A1BCUjxKkw=
	=
X-Google-Smtp-Source: AGHT+IEWpumMq7w2Do+3aHW1xJk7ZnkmrsU/t6znrys5DihZ08Xs8NOd+ecssoGGAfkjsqWUcHoulWJrMg==
X-Received: from wrbei4.prod.google.com ([2002:a05:6000:4184:b0:390:f69f:8c34])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1fa4:b0:390:f9e0:f0d0
 with SMTP id ffacd0b85a97d-391155feb2emr1821321f8f.6.1741080335989; Tue, 04
 Mar 2025 01:25:35 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:09 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-11-elver@google.com>
Subject: [PATCH v2 10/34] locking/mutex: Support Clang's capability analysis
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

Add support for Clang's capability analysis for mutex.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/mutex.h                         | 29 +++++----
 include/linux/mutex_types.h                   |  4 +-
 lib/test_capability-analysis.c                | 64 +++++++++++++++++++
 4 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index ddda3dc0d8d3..0000214056c2 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -79,7 +79,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2bf91b57591b..f71ad9ec96d0 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
+	__assert_cap(mutex);						\
 } while (0)
 
 /**
@@ -154,14 +155,14 @@ static inline int __devm_mutex_init(struct device *dev, struct mutex *lock)
  * Also see Documentation/locking/mutex-design.rst.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
-					unsigned int subclass);
+					unsigned int subclass) __cond_acquires(0, lock);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
-					unsigned int subclass);
-extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass);
+					unsigned int subclass) __cond_acquires(0, lock);
+extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
@@ -175,10 +176,10 @@ do {									\
 } while (0)
 
 #else
-extern void mutex_lock(struct mutex *lock);
-extern int __must_check mutex_lock_interruptible(struct mutex *lock);
-extern int __must_check mutex_lock_killable(struct mutex *lock);
-extern void mutex_lock_io(struct mutex *lock);
+extern void mutex_lock(struct mutex *lock) __acquires(lock);
+extern int __must_check mutex_lock_interruptible(struct mutex *lock) __cond_acquires(0, lock);
+extern int __must_check mutex_lock_killable(struct mutex *lock) __cond_acquires(0, lock);
+extern void mutex_lock_io(struct mutex *lock) __acquires(lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
@@ -193,13 +194,13 @@ extern void mutex_lock_io(struct mutex *lock);
  *
  * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
-extern int mutex_trylock(struct mutex *lock);
-extern void mutex_unlock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock) __cond_acquires(true, lock);
+extern void mutex_unlock(struct mutex *lock) __releases(lock);
 
-extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_acquires(true, lock);
 
-DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
-DEFINE_GUARD_COND(mutex, _try, mutex_trylock(_T))
-DEFINE_GUARD_COND(mutex, _intr, mutex_lock_interruptible(_T) == 0)
+DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock) == 0)
 
 #endif /* __LINUX_MUTEX_H */
diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index fdf7f515fde8..e1a5ea12d53c 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mutex {
+struct_with_capability(mutex) {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +59,7 @@ struct mutex {
  */
 #include <linux/rtmutex.h>
 
-struct mutex {
+struct_with_capability(mutex) {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 84060bace61d..286723b47328 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/build_bug.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 /*
@@ -144,3 +145,66 @@ TEST_SPINLOCK_COMMON(read_lock,
 		     read_unlock,
 		     read_trylock,
 		     TEST_OP_RO);
+
+struct test_mutex_data {
+	struct mutex mtx;
+	int counter __guarded_by(&mtx);
+};
+
+static void __used test_mutex_init(struct test_mutex_data *d)
+{
+	mutex_init(&d->mtx);
+	d->counter = 0;
+}
+
+static void __used test_mutex_lock(struct test_mutex_data *d)
+{
+	mutex_lock(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+	mutex_lock_io(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+}
+
+static void __used test_mutex_trylock(struct test_mutex_data *d, atomic_t *a)
+{
+	if (!mutex_lock_interruptible(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (!mutex_lock_killable(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (mutex_trylock(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (atomic_dec_and_mutex_lock(a, &d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+}
+
+static void __used test_mutex_assert(struct test_mutex_data *d)
+{
+	lockdep_assert_held(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_guard(struct test_mutex_data *d)
+{
+	guard(mutex)(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_cond_guard(struct test_mutex_data *d)
+{
+	scoped_cond_guard(mutex_try, return, &d->mtx) {
+		d->counter++;
+	}
+	scoped_cond_guard(mutex_intr, return, &d->mtx) {
+		d->counter++;
+	}
+}
-- 
2.48.1.711.g2feabab25a-goog

