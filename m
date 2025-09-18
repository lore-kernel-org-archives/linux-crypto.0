Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1449B30F80C
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758204359; cv=none; b=k9MeIrXds4E2g58Wl/k/V+zi99xVX2/HJS+NUM9uKO8GuhKodzxme3lvRX+3wBoJRviMB0FKdAIm5rWuQJ+VUjdrADCZY164CS3xDgaNzhIW86uDtcO0pyTV7JPfI0gkXmTVyoyJ5gd0rQrUHOi3B5w/0XSuxf8tBpGvSMEnl7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758204359; c=relaxed/simple;
	bh=XFcGm4n25LjnJFGDK2b27nnDI1GSqUMtWzLfu8WiFPA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Atn8hNYkuUr3Vb76e2IUxHkTigAHuYaruTd2qgntGpFlD26dwuh3AFeOt39DOj6gAPjPtwIgxV5Bgg+usLuovWJglCvFsUnrj8I4mw/iXqJVF1fezMjkBqssc2uUwU4ewAwwIGmE7rwjp6cUYepANpi1qODVMrLTHy5xyi1vnlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4sxWOnQ7; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4sxWOnQ7"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b04b06659d2so140704366b.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 07:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204354; x=1758809154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P08xa+RVj+NYVod6vjIgPrZ1iS5A/lHieiP5dR8CwWY=;
        b=4sxWOnQ79ANQM3JC1XllPyIO7H4UMp0MKzX729sQvl1VPEjn2iFHnmKjo0aetESpEp
         FvS3eiHGAq0YpQlybdpObbqssOPVc2ip6VLHgdepLQjAX6qYujz9iCO2hsvaC1EURup4
         93lJDUby+9hE/jmz9mZ84/AEfeKeRwYLdaddOyFfEOurSMsMesabJAOcYPN9aE1Pukl4
         shIxzErubhK3eumsBP5XI1Bjcf0qT6XtH9fQateOm5WF7HypGDNLHBTxUE+07tLW4h4D
         Opy0oc8FAmgy4N7BcEpYP/dxAIRfORDK91CCdyui+oIHl5kYkUf3w3yB3Auzx4ZtEBZW
         DkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204354; x=1758809154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P08xa+RVj+NYVod6vjIgPrZ1iS5A/lHieiP5dR8CwWY=;
        b=eHmMAvOXYUQI+pAytHrrloraLbdqnquGNOraliXX9ba+XeZpAWnxkC6qqyBuCLhV2G
         0VoiS/xwa1dYlxREQ7qfHayw1sBJ0r83xA01MPwNUKHlHGPbWGhx8fddoi/OavItS086
         kI3PDuKz1pD4vc2PBucKChUCqp9tsSqBpPV50WluRSn9Mxgws/09uENhcvnEJwlLE83u
         FplW7BXdFPUsvUl18y7FBXKsNr7p2gVqJgqm9q3AnCmFDc8rOvH/9DwGrPdm7hNojVgC
         vRRa37h0Kir9hQwwkEe8Motur75nxabY14Px70DVOZzBoHacoQVxGenS4ydWw3fCfz31
         Dr6w==
X-Forwarded-Encrypted: i=1; AJvYcCVsEzpQSAxEePBQH/ag4aFYjf8ap4V2dMVa6KKcNF0UkbcQFWu8Tq64O1fPxrHDvIOe0HR5ekRFIhNCTEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX0gZhgANwhNXNltWe6fEAsmJACjGceVKL/0Ebis0XYy4+Px+v
	8+T6RY/Dy2JwSUDJBEpjUV1oCR+91nFdtf5ZDkRcwseBG2BxoNFrIeiWoFg2VRqPxES7fq18F9K
	cdg==
X-Google-Smtp-Source: AGHT+IHZ+a3x7r6KdORv5r4v9wd2gkoHcaTmO7cGwNrZRZhrY55/kmzK7UzQjJUKer1HTJFogryCh2DgMQ==
X-Received: from ejctp26.prod.google.com ([2002:a17:907:c49a:b0:b0d:2e46:f67])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6e8d:b0:b0d:5e0d:eaa4
 with SMTP id a640c23a62f3a-b1bba003769mr678528666b.16.1758204354138; Thu, 18
 Sep 2025 07:05:54 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:21 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-11-elver@google.com>
Subject: [PATCH v3 10/35] locking/mutex: Support Clang's capability analysis
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

Add support for Clang's capability analysis for mutex.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/mutex.h                         | 35 +++++-----
 include/linux/mutex_types.h                   |  4 +-
 lib/test_capability-analysis.c                | 64 +++++++++++++++++++
 4 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 9abd7f62cf4e..89f9c991f7cf 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 847b81ca6436..7e4eb778d269 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
+	__assume_cap(mutex);						\
 } while (0)
 
 /**
@@ -157,13 +158,13 @@ static inline int __must_check __devm_mutex_init(struct device *dev, struct mute
  * Also see Documentation/locking/mutex-design.rst.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
-					unsigned int subclass);
+					unsigned int subclass) __cond_acquires(0, lock);
 extern int __must_check _mutex_lock_killable(struct mutex *lock,
-		unsigned int subclass, struct lockdep_map *nest_lock);
-extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass);
+		unsigned int subclass, struct lockdep_map *nest_lock) __cond_acquires(0, lock);
+extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
@@ -186,10 +187,10 @@ do {									\
 	_mutex_lock_killable(lock, subclass, NULL)
 
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
@@ -207,7 +208,7 @@ extern void mutex_lock_io(struct mutex *lock);
  */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock) __cond_acquires(true, lock);
 
 #define mutex_trylock_nest_lock(lock, nest_lock)		\
 (								\
@@ -217,17 +218,21 @@ extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest
 
 #define mutex_trylock(lock) _mutex_trylock_nest_lock(lock, NULL)
 #else
-extern int mutex_trylock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock) __cond_acquires(true, lock);
 #define mutex_trylock_nest_lock(lock, nest_lock) mutex_trylock(lock)
 #endif
 
-extern void mutex_unlock(struct mutex *lock);
+extern void mutex_unlock(struct mutex *lock) __releases(lock);
 
-extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_acquires(true, lock);
 
-DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
-DEFINE_GUARD_COND(mutex, _try, mutex_trylock(_T))
-DEFINE_GUARD_COND(mutex, _intr, mutex_lock_interruptible(_T), _RET == 0)
+DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(mutex, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr, __assumes_cap(_T), /* */)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 
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
2.51.0.384.g4c02a37b29-goog

