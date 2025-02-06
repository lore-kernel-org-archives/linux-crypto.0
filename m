Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E12A1F8AC5
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865912; cv=none; b=AIohDLN7+OvlMRQM/wG6GR07+PWflj/h5SI76s+qDyIXLR2lRsWC1kVCyTalXtpyvoO1Omjug38mc550BDW1JTxzN68OMcZuPjbZUIHukkO3rjeiBnvqKg3prJ+J4NEpipnXs+XKMDWxOurcyiuHdnKpf2Sm5VPZ3sEN07yoA18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865912; c=relaxed/simple;
	bh=eUsEA8AKaMySMoDYSStoEnIC6yQaJkf66VdQ0LAAkhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kkg+SCRFY43FgRZ6FkB+9YEvJLS24dsnxZwXJE71gzAU36YxatVZZLqlZz7SHwpL4Amjy3Ym9aSFGYLgCVRJozgMlfCveHyYtCD03dInE+TfPc+lgTxf83Kx3GEInj88xnA39B7+AssyETREgvfXT+5GztP0W1q76/OWHvL8RsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0BZZumzI; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BZZumzI"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa689b88293so130824766b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 10:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738865909; x=1739470709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rczBmZP1xxTJDBYPo5xjGBbOgXwfpsKdWxPKt0+mHDg=;
        b=0BZZumzI16fwyyHccw7JiF1zmLs7MjWIGoLLf0A5shUDVgRSF33DoLfKuhAgVd8cwS
         Rm9DabHSKxAv8Z+Mzn0iCjlWNLRycGZ0voeTVoVhgKHZkYRPf8np9EsZRPALDLcozY3r
         m3U2+YOqDVuW/UYlDGg5yZj4GR3w4otclzxsZG4iqzU1whzEoHOl300OPG+kbW6auDsB
         h1bVOcPp9HFFLDZONkYYCCxv5T5VqASidd3p9aDw8qP17ZNWU/0aBB+xESWePpX6xE+w
         FL5klIKqz68LwPkueDFQ+j79a55okeiG9R8xcbg0K3sF3ombuOd5/AKcKCa9ca7M2e6O
         M7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865909; x=1739470709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rczBmZP1xxTJDBYPo5xjGBbOgXwfpsKdWxPKt0+mHDg=;
        b=tAvdBrMGR/8MZkn7j0xX2Y7kGvqfH7bn16pYattyPQR0KmsTq71mHjfU3zQXv/WNq1
         4FbmbHUK8iq3dob6ZI5BQxNKkIBHdldj/GYePQuIxdvFdkLolqnacAKDhg9lltSZR9um
         tGmI33eKqjON9uPrPcb4D5JsB6yy3xox5ySEGFB+LcOrO6v/07L6DLhVs0Wak3fvcnWa
         bXoeou/BG4S7GoFZm+P+Pj3v0r5tnP4YVIs4UwDy4Wt0siue0GCLBERCV1iPf0nlhzvO
         YQ2OfYiz75j8JmK05zRA6ZSjw700WiVRPkKhbn8LfK/vjW9YsDdvigpTC09EDE7r6K3D
         F9vw==
X-Forwarded-Encrypted: i=1; AJvYcCXRy1qM+72qnUUJq1lqMuMxjPndOvnaxLSLee1+F3H8Jdob43ebcc+yol+IWTIpsUpw2vRz7wDU0IVYXc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0T81VIv9ZcZwT/i3oIiUngw3939VNnEnQ0zV2HZHIyBLyLY/e
	B/PsCRWm6dtfQHzp+dxzawz7rP33BHSKCLRrPYG9tP1g3zR8c4PUlwvpMshP18mdSYkl1pz0AQ=
	=
X-Google-Smtp-Source: AGHT+IGVPfCAaawQkSTPD4Xv6V79uv64bqYTAjRa+/Jl4z9KcDjw7LPQAkOYBilNooqt7ZxMEpeteFTuAQ==
X-Received: from ejcth7.prod.google.com ([2002:a17:907:8e07:b0:ab6:c785:9cc6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7e92:b0:ab7:8520:e953
 with SMTP id a640c23a62f3a-ab78520ea84mr97837866b.55.1738865908835; Thu, 06
 Feb 2025 10:18:28 -0800 (PST)
Date: Thu,  6 Feb 2025 19:10:11 +0100
In-Reply-To: <20250206181711.1902989-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250206181711.1902989-18-elver@google.com>
Subject: [PATCH RFC 17/24] kref: Add capability-analysis annotations
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

Mark functions that conditionally acquire the passed lock.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kref.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 88e82ab1367c..c1bd26936f41 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *mutex)
+	__cond_acquires(1, mutex)
 {
 	if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
 		release(kref);
@@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
 static inline int kref_put_lock(struct kref *kref,
 				void (*release)(struct kref *kref),
 				spinlock_t *lock)
+	__cond_acquires(1, lock)
 {
 	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
-- 
2.48.1.502.g6dc24dfdaf-goog

