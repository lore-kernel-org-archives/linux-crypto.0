Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84531E0E1A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865889; cv=none; b=c1BL2UhNI6ODqwCBpZH92h/bYQsgZIf6c7aRubKxrXi+0lPTVsckXuMu+HMea1ZaNBwGqjE0pMhEgnUGLwMBnWfPKmnxu1HWXiWkjU7fbS51tV0xmeoDQdfXcD57JKmN88I2IDaCqBQ3Z4CCKua0R42cN9hHTyPVpJXK4yODTPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865889; c=relaxed/simple;
	bh=NC/giOsxEdW/2YEKwyZ/rqMsDsoQXLA5Fl9b5LdcKjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m8ZxKGCDy89Pltw4YlNdckHEUH0E5lWiEH3gMozDajYpCkDsoAC93xB0t0ZeQB31uJDy0gs1b2WNY4yI+Fp35xfbXGhGjF/cAHiVaQRYrZuzyF46ukVSp4EGmj2vxbGy273p3w8+r6VaiMZdEpBo8T0/gsbAIQyNwOMCJ4p7go8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYpNoJMK; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYpNoJMK"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa689b88293so130786966b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865886; x=1739470686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B9zo14rswWWzdXk+7RXhASP4eQAv2ef2DvmlHG5M+4Q=;
        b=LYpNoJMKrv7QAgp9cXs2m1IV91l7Bzo+YU98sn32nTGzsEhZxs34RSpl4Ltx9Ranqh
         Y4WvTY6cM7l5waJzCuRqpRc96GYq6Ex6mZ8MHhxRecMiHoR6nEnaf3Wu9J/JCv3eH1MR
         wc2Z6oiqqEmGr6ovVaQvHDE5Va5fVs5ky8Gz00BD7iIyMLLVByj1H5lArIuJ/5YS5h8a
         ZeSFnVtg0Ccya33GQzNJb7r2WqWzAWPv5DukjPKua57otUhFDrTQREeNFyU/T/lbWOGh
         tEs0PeScPpCe5RVRET1TMyBvF9IKs2+YbA7RVlMPPioBmqJD+w1FgT0s9gP+m9Hefw/H
         r5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865886; x=1739470686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B9zo14rswWWzdXk+7RXhASP4eQAv2ef2DvmlHG5M+4Q=;
        b=xQxL3h+nYd3WPxYV+PFQFe/oOO5AhoaZvaIDqyIKt2LLUZzkb50OJXShMCSt7pjJ9l
         L8Q9pusErZui+pGwROf//d/fUfde+8PrR57aSHQ7nk8TWBdawCVE5NN9sRsqAlzxddB3
         JV247ggxyHV+FdV1x28iuiGXNwJq9IBL/nA0STV1ywz0mBAAtyO/3mFtT3tX1UlzTvfc
         wVrpR48uACc2Ijm+43nnhNcrU6B/x9AMeXEJlGeGnBbq7d45sctkyD+InIr91ONO35Z1
         SBX18q5ct14oDQG8/O9uwIq6TvNS3spL1w1FilDEtjDy3SwYyfiadOgRRNIikhRbzu84
         6l2w==
X-Forwarded-Encrypted: i=1; AJvYcCUzH0bOnnfDvR6NXaWXoCXe/CNqR1JbVcb8FHSte1jmOkIhm5kLZciobNRJVKhUWqkOxQz0j8SWURYH1iU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY0ArVWyUJd8c3L4/2rvuIgBWypqR4NgHx0m4nEL1UXG+ayDGA
	cknGI4KOrXYBAX12pLY9e6gdzN/qmRDSaBGq5y5U2fMw0IOHsFhoLwtUdbmJakgbO912h1Od3w=
	=
X-Google-Smtp-Source: AGHT+IFu7xPJdokZBAxGmpTaLRXegeAIT0R1AZB6cJDpPIO2PbBj0EGjZIpu4bBVqoqg73DZbQallQnyAQ==
X-Received: from ejcvi3.prod.google.com ([2002:a17:907:d403:b0:aa6:90a8:f5f8])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7216:b0:ab7:647:d52d
 with SMTP id a640c23a62f3a-ab75e322c0dmr999272366b.51.1738865886143; Thu, 06
 Feb 2025 10:18:06 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:02 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-9-elver@google.com>
Subject: [PATCH RFC 08/24] lockdep: Annotate lockdep assertions for capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Clang's capability analysis can be made aware of functions that assert
that capabilities/locks are held.

Presence of these annotations causes the analysis to assume the
capability is held after calls to the annotated function, and avoid
false positives with complex control-flow; for example, where not all
control-flow paths in a function require a held lock, and therefore
marking the function with __must_hold(..) is inappropriate.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/lockdep.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 67964dc4db95..5cea929b2219 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
 
 #define lockdep_assert_held(l)		\
-	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
+	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assert_cap(l); } while (0)
 
 #define lockdep_assert_not_held(l)	\
 	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
 
 #define lockdep_assert_held_write(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 0))
+	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assert_cap(l); } while (0)
 
 #define lockdep_assert_held_read(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 1))
+	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assert_shared_cap(l); } while (0)
 
 #define lockdep_assert_held_once(l)		\
 	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
@@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert(c)			do { } while (0)
 #define lockdep_assert_once(c)			do { } while (0)
 
-#define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held(l)			__assert_cap(l)
 #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
+#define lockdep_assert_held_write(l)		__assert_cap(l)
+#define lockdep_assert_held_read(l)		__assert_shared_cap(l)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
 
-- 
2.48.1.502.g6dc24dfdaf-goog

