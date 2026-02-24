Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CB92B2D7;
	Tue, 24 Feb 2026 03:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771904429; cv=none; b=r6wRLodVZSfT5xINHCviozFoSFQM2tb8HdHunSjKxKqCxMnyp7kwvGtf+4f5fMVo1aYlOCglKF8tw1gszWwfCeFRKiV4ozjgr/Y/UzSvszP5o7OKhmklcEulWdIs4tuK2Yel+j8FYG67YJmvC+lLOAFPJzp36rUTJoSALefsioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771904429; c=relaxed/simple;
	bh=GskEmqNHkUKG1mVWBRA0G0sO0IrSfjE1D+yupoFUShc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=itjNEtFuQS3dpSrrRTjsFvmfeZeowOe0mbMcxOnCmrgIIUJ/8B9bPYU1eO4Tz12ta0oeoG2pM0ki0SUQDyuPdiUyT1khn+jwfV1LLzB9y/SbIP+gGDP/RJWxWD0L6xmMjJDreTS4eCkcSgLRtiMkk2vBhuHpVFviuS8p3C/4Rks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQfearRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQfearRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B0BC116C6;
	Tue, 24 Feb 2026 03:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771904429;
	bh=GskEmqNHkUKG1mVWBRA0G0sO0IrSfjE1D+yupoFUShc=;
	h=From:To:Cc:Subject:Date:From;
	b=QQfearRpdj/It2GP8hPUqn8EL2lvgUjHhVKIWQACkqMVBWa3OQkZNVGD1GRBPg0Yp
	 oi+tq849mO8pKIoDrNvn22ESyqetuVQtc7nDlFJBqPv2i02br/JQhrYct4RUeO6Mzh
	 wK0A4vGsIJZeZozk2X2/hIjw6YPVqt51xXLdeJmmgtM8PBnbKZpwOGTEMTq1nXuOC0
	 6QYnthfLrRcZ7I2aqGL4xtHkJy66PuZ7csKmOS/RUmkwTs6ml/sHUziA/h5LUKo2ws
	 CwcJ0Vm0jK7E4UbatVpP7mGvxyXfH/7vicgS1MiJEiTdMMApze2cYtpS5IYgmyZqar
	 7wyLifh3CtZjg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] kunit: irq: Ensure timer doesn't fire too frequently
Date: Mon, 23 Feb 2026 19:37:51 -0800
Message-ID: <20260224033751.97615-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a bug where kunit_run_irq_test() could hang if the system is too
slow.  This was noticed with the crypto library tests in certain VMs.

Specifically, if kunit_irq_test_timer_func() and the associated hrtimer
code took over 5us to run, then the CPU would spend all its time
executing that code in hardirq context.  As a result, the task executing
kunit_run_irq_test() never had a chance to run, exit the loop, and
cancel the timer.

To fix it, make kunit_irq_test_timer_func() increase the timer interval
when the other contexts aren't having a chance to run.

Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch applies to v7.0-rc1 and is targeting libcrypto-fixes

 include/kunit/run-in-irq-context.h | 44 +++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
index c89b1b1b12dd5..bfe60d6cf28d8 100644
--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -10,36 +10,47 @@
 #include <kunit/test.h>
 #include <linux/timekeeping.h>
 #include <linux/hrtimer.h>
 #include <linux/workqueue.h>
 
-#define KUNIT_IRQ_TEST_HRTIMER_INTERVAL us_to_ktime(5)
-
 struct kunit_irq_test_state {
 	bool (*func)(void *test_specific_state);
 	void *test_specific_state;
 	bool task_func_reported_failure;
 	bool hardirq_func_reported_failure;
 	bool softirq_func_reported_failure;
+	atomic_t task_func_calls;
 	atomic_t hardirq_func_calls;
 	atomic_t softirq_func_calls;
+	ktime_t interval;
 	struct hrtimer timer;
 	struct work_struct bh_work;
 };
 
 static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
 {
 	struct kunit_irq_test_state *state =
 		container_of(timer, typeof(*state), timer);
+	int task_calls, hardirq_calls, softirq_calls;
 
 	WARN_ON_ONCE(!in_hardirq());
-	atomic_inc(&state->hardirq_func_calls);
+	task_calls = atomic_read(&state->task_func_calls);
+	hardirq_calls = atomic_inc_return(&state->hardirq_func_calls);
+	softirq_calls = atomic_read(&state->softirq_func_calls);
+
+	/*
+	 * If the timer is firing too often for the softirq or task to ever have
+	 * a chance to run, increase the timer interval.  This is needed on very
+	 * slow systems.
+	 */
+	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
+		state->interval = ktime_add_ns(state->interval, 250);
 
 	if (!state->func(state->test_specific_state))
 		state->hardirq_func_reported_failure = true;
 
-	hrtimer_forward_now(&state->timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL);
+	hrtimer_forward_now(&state->timer, state->interval);
 	queue_work(system_bh_wq, &state->bh_work);
 	return HRTIMER_RESTART;
 }
 
 static void kunit_irq_test_bh_work_func(struct work_struct *work)
@@ -84,14 +95,18 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 				      void *test_specific_state)
 {
 	struct kunit_irq_test_state state = {
 		.func = func,
 		.test_specific_state = test_specific_state,
+		/*
+		 * Start with a 5us timer interval.  If the system can't keep
+		 * up, kunit_irq_test_timer_func() will increase it.
+		 */
+		.interval = us_to_ktime(5),
 	};
 	unsigned long end_jiffies;
-	int hardirq_calls, softirq_calls;
-	bool allctx = false;
+	int task_calls, hardirq_calls, softirq_calls;
 
 	/*
 	 * Set up a hrtimer (the way we access hardirq context) and a work
 	 * struct for the BH workqueue (the way we access softirq context).
 	 */
@@ -102,25 +117,22 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
 	/*
 	 * Run for up to max_iterations (including at least one task, softirq,
 	 * and hardirq), or 1 second, whichever comes first.
 	 */
 	end_jiffies = jiffies + HZ;
-	hrtimer_start(&state.timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL,
-		      HRTIMER_MODE_REL_HARD);
-	for (int task_calls = 0, calls = 0;
-	     ((calls < max_iterations) || !allctx) &&
-	     !time_after(jiffies, end_jiffies);
-	     task_calls++) {
+	hrtimer_start(&state.timer, state.interval, HRTIMER_MODE_REL_HARD);
+	do {
 		if (!func(test_specific_state))
 			state.task_func_reported_failure = true;
 
+		task_calls = atomic_inc_return(&state.task_func_calls);
 		hardirq_calls = atomic_read(&state.hardirq_func_calls);
 		softirq_calls = atomic_read(&state.softirq_func_calls);
-		calls = task_calls + hardirq_calls + softirq_calls;
-		allctx = (task_calls > 0) && (hardirq_calls > 0) &&
-			 (softirq_calls > 0);
-	}
+	} while ((task_calls + hardirq_calls + softirq_calls < max_iterations ||
+		  (task_calls == 0 || hardirq_calls == 0 ||
+		   softirq_calls == 0)) &&
+		 !time_after(jiffies, end_jiffies));
 
 	/* Cancel the timer and work. */
 	hrtimer_cancel(&state.timer);
 	flush_work(&state.bh_work);
 

base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.53.0

