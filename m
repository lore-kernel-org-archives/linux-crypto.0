Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A2342C506;
	Mon,  3 Aug 2026 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785781257; cv=none; b=Ch/FNSZekj6z8hcI0er9ejUGiFpGxnv+Im3P8ShiFfkP3PZEx2bN2W0i66WKB7bozyreQTdliBGOCSFkerIWc/gy9MJyF02AOL928Q1R89sVzvipXEv6sFu3gTyKUvzoBEHqAQCyRX0oTJTXFrzUQf1OLRcdv6IEj8bRr8BMxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785781257; c=relaxed/simple;
	bh=4fIElJzbktf3/aIZPkoZy2uGtaz3mM7nKQOWZRf+n3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F2qGvQHSYSyqHB0zYrTCMRtaOeZXW1Wz7jvJYLE97kBspUI35H9TunslMxwbXisY2WeVf4wJLsd0neidCEGN0trI/nxG2DpoVBuEIDlC2Qd5bXsfpaKGu7b43kutepjEzbhWke7IipMeOqerGjme+E22Ep9uWB516LWNOqwXnms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqDFzokj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqDFzokj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750501F000E9;
	Mon,  3 Aug 2026 18:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785781255;
	bh=Ytqr53wRpRBi1hwBXyjb/LDzB8AgUgTi5XzW2X7uceA=;
	h=From:To:Cc:Subject:Date;
	b=eqDFzokjJ4UkSCm0g5MwTLc7hqNxBGujfigDXTsQoOZ1mgfXHa5XSDCk1nekyRP1Q
	 O6s53uOTWG+3hE2BykUvQKMaoQtQ53D1OmQcGr1z7OtoBy88a98O4z/Y/YoSw69EuI
	 lC5FK7QK2TV+CiCkm3hQO2GvRbO//7Ti4UBzbgIlUeVKqxlj+RfQZJ9KK5MT06wYu3
	 Q4+vsJBEBdc2cuDHBMzeZtuf6y+XVomGy4tg174GDH++AGLBmzON7I4Of3+OzxqiFI
	 mueOzj2zrDk+o/B4nGJH9cSR4JpTvlNZxKQjKCyjy2UYwQrqevxGewu/bkKqcZGk/q
	 760/7p5IQgykw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] kunit: irq: Continue increasing hrtimer interval for longer
Date: Mon,  3 Aug 2026 11:18:41 -0700
Message-ID: <20260803181842.44648-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, kunit_irq_test_timer_func() stops increasing the hrtimer
interval as soon as some forward progress is made in each of softirq and
task context.  Update it to use a more aggressive strategy: increase the
interval as long as the hrtimer is running significantly faster than
either context.

This resolves an occasional hang in the CRC and crypto library tests
under qemu-system-s390x.  It was exposed by the change in the default
preemption model on s390 from NONE to LAZY.  That seems to have exposed
the issue by allowing some forward progress to be made while the actual
system timer tick is still starved, preventing jiffies from increasing
or the task context from making much progress towards max_iterations.

Fixes: 201ceb94aa1d ("kunit: irq: Ensure timer doesn't fire too frequently")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 include/kunit/run-in-irq-context.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
index bfe60d6cf28d..3802b6fb218e 100644
--- a/include/kunit/run-in-irq-context.h
+++ b/include/kunit/run-in-irq-context.h
@@ -38,11 +38,13 @@ static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
 	softirq_calls = atomic_read(&state->softirq_func_calls);
 
 	/*
-	 * If the timer is firing too often for the softirq or task to ever have
-	 * a chance to run, increase the timer interval.  This is needed on very
-	 * slow systems.
+	 * If the hrtimer is running much faster than the bh_work or the task,
+	 * then it is firing too fast and might be starving those contexts as
+	 * well as the actual system timer tick.  Increase the interval.
 	 */
-	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
+	if (hardirq_calls >= 20 &&
+	    (hardirq_calls / 2 > softirq_calls ||
+	     hardirq_calls / 2 > task_calls))
 		state->interval = ktime_add_ns(state->interval, 250);
 
 	if (!state->func(state->test_specific_state))

base-commit: 6d22ec26295c1412d765e3d687e46224fc332928
-- 
2.55.0

