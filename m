Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0EC202982
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080355; cv=none; b=CPEv6J486mbGuyAou/mjlRRNxvyt7SGBwtP43SJWQeGN6q9ANDg8l9qA7satI/902QqTZx3tqnlHyT9fcsPwIl4S5Wx0LyQpOo81HR1S6f08PpkSczSh1Ij4tnifztRiPfgczdcQtZjaXsWutHq7u7wuEWyfy9l5poHVQhA+lvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080355; c=relaxed/simple;
	bh=PiALtBw0DYxsKuBO8J1H1AaY1cU3EmQ3QqFWUaJ2ULI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=frkJgB2+mr6Ox7/K6HAwRquKTbYueI+XjUdUXfy2jexhTzEpIUVjFZfsT3Rf0Hnhgv+q2f5FSd6pSdtOp74HaZOeyyZqRsA6yKQ7Lr8+MJALqPdrhGPQdLqNvAy6r4I4WYDpv3ze6ZnsXtm8OLuQ/SoTmW8YFRBgsKWCLdAgIF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xseS9zns; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xseS9zns"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43947979ce8so21212045e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080352; x=1741685152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cDlOE/N8Ae1M5H+4yLEwuBDz/LRLExYZEp/cosJZ8Bg=;
        b=xseS9znsQ87t34sYX/gUp0g2hQZ/UNonxdPqn5B7LJMZ2/n7mRqN7ey1N4I8/VvGVt
         wcqf61xpLrOaUgfB5G5XrT8rOSZRNnLb2FSitfzM+H6koewUYHd0S6p6SgDDtZFjjw2v
         ga4SWEVQifSr2qCCjU0KUdxhurb8xDPE+OxbN7/QDf4dVDhNGp6o7JXxe8nDqH0SGobz
         lNlVgFk5sBuAoTqrKl1j8X+4hLptwTCAuGatsEJ28qbXzZ9wbk1D4H56dU0F19rDETHD
         8tyMll8rxrEUkc51aH24J2tE+Ah6qHHSVyCVRdLZXRhZsxTzKw3L2W5RpkrxNf8Tprgs
         WjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080352; x=1741685152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cDlOE/N8Ae1M5H+4yLEwuBDz/LRLExYZEp/cosJZ8Bg=;
        b=bRxyjllvaB5B06mz6B0PFizWYzw6BDSrONpy7UKgRneGwBhZqPmYWgyrlVFAQ2Kvfs
         sByriXO9X4eP5SFMMHJO1vAqTXjKQyGKJVXUmmFsKwXpeSnNHmdl7IlKT3O+8vHmylv/
         O+IOtJyJ4GuHSvfAgTt8OLE6n5DUJNx+Ys2Z9VUcET7N/uBAUxASBziMQxscyONyRJRG
         UYsMUQ97OfvHKPHCEONa+mkvEt02ksfar3hPfc5t/FQkQjyaPSdmiIA6qw5gvDTXl+3T
         KuUxBn7U/S0d7rIO2gRAqb+J2N5pspqP3thmm5xx6xhY/Env83NueJJ5QSgX20NLWXYF
         oipw==
X-Forwarded-Encrypted: i=1; AJvYcCX/SrnHgutnFNDw+OgBAXidNw0Q+w++zaSKOWGstmKe5Kl1tgcx4p4EAQE7mfpXcVSHHKxL7N0bZ802ZAs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxut4R1tPmF1yEbK7sBQNndmPLbJNjDN2FeJFGBnC8BWyx2exoe
	AU4fzVntn+q4VUK5IVw2fKbtqoRXdA1fk7ds22C7VXVGGRaigvoVGgQ79svQqRsPHJIhy9Lr7w=
	=
X-Google-Smtp-Source: AGHT+IHedqiVSmrcvr28lGY8V3DB1o4f03/YwjOgy/3VYsVwJNq1WARMZql7ViymW31VHT1lz95raXYaUw==
X-Received: from wmqa13.prod.google.com ([2002:a05:600c:348d:b0:439:64f9:d801])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190a:b0:434:a4b3:5ebe
 with SMTP id 5b1f17b1804b1-43ba675830emr110121215e9.24.1741080352374; Tue, 04
 Mar 2025 01:25:52 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:15 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-17-elver@google.com>
Subject: [PATCH v2 16/34] kref: Add capability-analysis annotations
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

Mark functions that conditionally acquire the passed lock.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kref.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 88e82ab1367c..9bc6abe57572 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *mutex)
+	__cond_acquires(true, mutex)
 {
 	if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
 		release(kref);
@@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
 static inline int kref_put_lock(struct kref *kref,
 				void (*release)(struct kref *kref),
 				spinlock_t *lock)
+	__cond_acquires(true, lock)
 {
 	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
-- 
2.48.1.711.g2feabab25a-goog

