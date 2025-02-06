Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15CF22FF23
	for <linux-crypto@vger.kernel.org>; Thu,  6 Feb 2025 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879358; cv=none; b=dLXCaICbfg4u4RFFO4luzFqM3sUfjnSnEsE9/7QE4i2OAstma7XrwxCANBsEJOgLKkzpfSjjIf9LZcp8nhGTxf3z+0a8qcH1AzsnntLwooL80MXDxDxzNGCO08sUZVCirQcUzcGIHFEzzhYZWvxw1TzW6CbHl6mitjQrpdPAIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879358; c=relaxed/simple;
	bh=yhX7RJVwaA+Lpx5zbK94yXYQtEnJwzrvecNure0CHC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LfVZsyovw3SiPJhg4ESTO2nqsOINWGk0Gp+tOSFHynxAQn4v+MvXh+IRYZZ7j6KGHDbvtrfoUcW0LLk7paen/lPRPtJ+1ce8zclEjzsCcBOhpKo1/wDucc5gXLkPnRO6C0twfhsvQ0ZI0uY5AHSkwENIQ4zZJu8m7b+g6by18sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kxIVV+nl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kxIVV+nl"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2f83a8afcbbso2282642a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2025 14:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738879356; x=1739484156; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+VZ6pc7yhUf3GbCnbHnQECLXNAA4wAPKI9VijFmeNYk=;
        b=kxIVV+nlOzHE5Iqj8I8vuEVrs88qB4A69R7D27IpLydGzluqwEmvEeSeFI4g4aZVLZ
         uyi37TBXdKGgF8z1hkcMXg192VnrJnBfWsqFfqhxTWKJYX8FpJRbpxlKtJmtsuo0EXsY
         Jep6UxWiFFrn6uj73IuGYC8lGeXzD7J55V5P4jt75iLIs16WRizCYm9bj12JO6A77Tg7
         qe68Nt0aaZ4/yEb2/NvTci9s3nd0EVg/ii1Ng9zOWSpidlOL7jReuregTMMFa4h6hGKe
         NINmtRSHo3/YlblodsPrwC8AwpCvaONm0NecI/4PAwfmkb5qnInTbe2rS92+xBG/xemW
         XvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738879356; x=1739484156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VZ6pc7yhUf3GbCnbHnQECLXNAA4wAPKI9VijFmeNYk=;
        b=P5Hd0uJHrGy+IgkSQGqZZcGWQ+/KfnIgN29+DA89bPeL+Dm75V33l29FcR04hLB864
         LFqAq2w28889C9BJsCULmV/fUZWW7kFNnR6IW0rZfrTVDSVpM5PtJTHWjF7fIXu92zwM
         J2fuRShdhnJKqONKYYul4WUAAy6BfmoJVlA5XRhxAkPEZxec3rx0WIp5Ew9gkSE4kdQA
         mcZZ0+M/fn9SwHode3l/vtXoKlEHDwP/khyoG3sw4qfnwrpY3T6w/uDkjCxIJLSNlqQR
         egNauAHNENs6QM1ov5F1KMogDFeyXNtnzyOXJS0cCq+f4pNohF0YBYek7bUUBcVB9FX7
         R8bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxpojokLddyxBl5foFvCNiLJm3SWRFfKszrFEQfmRRHryXXQU+6oStFdkf+alrA2VVgK/KzSrCrKRpUEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGFmh9g36mhOwabJb2KrA9DqxSv4TT8TJzvGpsmiewx0eJqRkK
	BUVJR5/sz+ft9RRtXSlCEJLGWdyqbXMBYyrqCElaf5fhgGe0tzRFykKx99AgFlvFTsq6bLgmEhd
	+IzyHHyZTw0e+aGivtvltjIBV5fTgqe9IS0Xy
X-Gm-Gg: ASbGncs4JB9pJtbc076Zf/g95ACNAXxxRuPv+ULHcKqUJFF3B3b3NWvlxkyMEG9yU4N
	QkwGVZ7ULJu9skxIBWX3tOMY+rFiHhCNTFnUMT9pqFubJx9xiTQXNR95NqpUlgc4YXkKp6fPM9P
	2gg7IKuDLcVXK6BiBi5GKyyg0vkDe5
X-Google-Smtp-Source: AGHT+IHT0gKSH+kblZFLx/Wzk00J8ULB9nNNudVm2CwEFSzub8EVmI8aYK9egI+4TLHMpy13Xtg4Kl5eKF+OeEA9kSk=
X-Received: by 2002:a17:90b:1a91:b0:2ef:949c:6f6b with SMTP id
 98e67ed59e1d1-2f9ffb38596mr8748127a91.13.1738879355643; Thu, 06 Feb 2025
 14:02:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com> <20250206181711.1902989-8-elver@google.com>
 <4ce8f5f2-4196-43e7-88a2-0b5fa2af37fb@acm.org>
In-Reply-To: <4ce8f5f2-4196-43e7-88a2-0b5fa2af37fb@acm.org>
From: Marco Elver <elver@google.com>
Date: Thu, 6 Feb 2025 23:01:59 +0100
X-Gm-Features: AWEUYZnffMY9S6S6so6pFI6Su5ySq6ByivopC2ArucfUZC95P3tyJXAV2JoDeGo
Message-ID: <CANpmjNMGH36vs8K9Z8tnJc=4xSeeQjeZGyhZj5KSUwh0kQ06MQ@mail.gmail.com>
Subject: Re: [PATCH RFC 07/24] cleanup: Basic compatibility with capability analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
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

On Thu, 6 Feb 2025 at 22:29, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2/6/25 10:10 AM, Marco Elver wrote:
> > @@ -243,15 +243,18 @@ const volatile void * __must_check_fn(const volatile void *val)
> >   #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)             \
> >   typedef _type class_##_name##_t;                                    \
> >   static inline void class_##_name##_destructor(_type *p)                     \
> > +     __no_capability_analysis                                        \
> >   { _type _T = *p; _exit; }                                           \
> >   static inline _type class_##_name##_constructor(_init_args)         \
> > +     __no_capability_analysis                                        \
> >   { _type t = _init; return t; }
>
> guard() uses the constructor and destructor functions defined by
> DEFINE_GUARD(). The DEFINE_GUARD() implementation uses DEFINE_CLASS().
> Here is an example that I found in <linux/mutex.h>:
>
> DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
>
> For this example, how is the compiler told that mutex _T is held around
> the code protected by guard()?

DEFINE_GUARD is the generic variant usable for more than just locking
primitives. DEFINE_LOCK_GUARD_X is a specialization of DEFINE_GUARD
intended for locking primitives, all of which should be
capability-enabled.

So I added automatic support for DEFINE_LOCK_GUARD_1 (keeping in mind
the limitations as described in the commit message). All later patches
that introduce support for a locking primitive that had been using
DEFINE_GUARD are switched over to DEFINE_LOCK_GUARD. There's no
additional runtime cost (_T is just a struct containing _T->lock). For
example, the change for mutex [1] switches it to use
DEFINE_LOCK_GUARD_1.

[1] https://lore.kernel.org/all/20250206181711.1902989-12-elver@google.com/

(For every primitive added I have added tests in
test_capability-analysis.c, including testing that the scoped guard()
helpers work and do not produce false positives.)

The RCU patch [15/24] also makes it work for LOCK_GUARD_0, by simply
adding an optional helper macro to declare the attributes for lock and
unlock. There's no need for additional variants of
DEFINE_LOCK_GUARD_X.

Should the need arise to add add annotations for DEFINE_GUARD, we can
introduce DECLARE_GUARD_ATTRS(), similar to
DECLARE_LOCK_GUARD_0_ATTRS() introduced in [15/24]. But it's omitted
because DEFINE_GUARD() can be replaced by DEFINE_LOCK_GUARD for
locking primitives.

In general I wanted to keep the current interface for defining guards
untouched, and keeping it simpler.
