Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0AA2040A9
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 13:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741093801; cv=none; b=im5dL4+TpXmofMQBrJ6qheRL0HZHsZBHbRzNHN7ljstkP+rdWBy88Rp54WNf4kEUX+k/6+HKoWnZSpEn+3Qzfc2r+Wfoubk5ZuHb5HhMS6P+Ak7zvxHega7VtRDQBRp9thXmSHpE739Tl3wzw1Lhgc75by2ITqM138+ZY99yzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741093801; c=relaxed/simple;
	bh=NcEqiAia7PtxdRC2CO01i7tbbhPiGij2sr/fLY4ZFuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ueP0rbMBJJyUp1gdnKFqUkHIAyE5tUcOwPSa8hQmAFF/KJwfq924ukTJNFhCeslqUJ6einMFWQj7G88Udzg3Yxwjw7nU/RikvvMo5h9j7fgto9y/2J+dwDPVEMWTqbTwVBv3uhq/v57IT1gH5XmMbNWmVj0P4M8EJw5tntETHnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lgAjNSH8; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lgAjNSH8"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2235c5818a3so70851725ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 05:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741093798; x=1741698598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x117HPWY7hfxCsyRoomSLqnsp6TkG/IZ7mxFwBfWDy4=;
        b=lgAjNSH82Xe0CP1ujbQj7vPkQrbO8ZclVJWv90V5wBvqUXjqSghCtyJRvjhHIr8M0M
         /OuZ4QHZQQcC65o62tiWI9yXaGXaihz74p0q1M61rW7DhwwcOWkY+OH6eWqC8+tu4jeB
         gEPiv6zkAHwYBMbLsuplq0EamVVXdhbDLdQGy8c/4sSkij5yOdAiUBW8wucJUbUWkez6
         4MTzAblno9u3tr+lOa3zW/i0MubBIC+Q7FOFgvnMrJAS5fPu8mzyQ4XySxRkuIvs5U24
         NY8dqCuTDoey43LQG0iIUoYJWNvGXCPHBqNNZpQ44+X9R29pTR131iCB9XKXPt0H0JVN
         9GiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741093798; x=1741698598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x117HPWY7hfxCsyRoomSLqnsp6TkG/IZ7mxFwBfWDy4=;
        b=bK75tKw1Buw+Hyu8U33L58yC6+GGmrNqqZQHch7hHZlBvC7tk3kKfiMRNO1bVWD8EK
         wPmRb1vIU01ovCJfurZ5/8nYYskzJfKIBiGjXiEYwEjrt6B6rkw+dPxE9xPNX0F0UZhy
         7E6pqGHiHUV7y54M0mmz+7/UOuu7t7miQnk7wmXjTMgiyhu8MAPhunzkqNElOxfnMh4w
         a9PaAqm5d8xOXj6PkCpzxbhJZ/f0CpLXcaePuJrBNbf+vq9BHUsuYRPdFh2pMNVVlx0h
         D+bziRhVxHeoR/gZ2sRRxW+xgU4OxfiMBQ0vKZt4y6zbMtWxp4bZ/Zdk1QhQlaXHbsQT
         YEKA==
X-Forwarded-Encrypted: i=1; AJvYcCWIt76d4oJYKAVKK4Da8ZJAze0bROuhtrMiJLTFIj8LZmv1qJ1JZnU8bCnfaniKkKWcRABDp0QQ5wbmqZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyG5X0OpJH2x77lSeDV4gt/g54MaSL94vG63o4m/KiYqsc67BS
	8Vh3UvoC4klXV+ctGrihMh+spnXA4fpQs/ahVM/PkbLLxgDkR8orz9atNOu3EqF8ddmmXUQsqw6
	Z1iA9yhlqK7SDq0TorAK7gUKrAVfagH7w4zXm
X-Gm-Gg: ASbGncvZ7XawK7zRxw8jB2nHwinK9dMpxqMKja70TdR5cwIXJWOm8e9RtzRBAhk7grs
	Oby55XunaTgymoatTn0FeTcQvkc6L4PZ+swh65DfF4unpEWV/YldrpxpNh6uau6Dr2r3gIfnyEq
	PMH1FjFGfsSnOSXA9i5dNKuA7hgoKsRAFTfyvUwMtdF1L03L36Dz9waQFB
X-Google-Smtp-Source: AGHT+IFiWcYRRwZhjH3eoEETTKHMFeBTK3Bvk1Dikxat7wutRisU34tzNCYhuoO1ktV/UerXXSrorJjwJzvEu41/niQ=
X-Received: by 2002:a17:902:ec91:b0:223:5ada:2484 with SMTP id
 d9443c01a7336-2236926e8bemr319887595ad.44.1741093798418; Tue, 04 Mar 2025
 05:09:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com> <20250304092417.2873893-7-elver@google.com>
 <20250304125516.GF11590@noisy.programming.kicks-ass.net>
In-Reply-To: <20250304125516.GF11590@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Tue, 4 Mar 2025 14:09:21 +0100
X-Gm-Features: AQ5f1JpRduzHYdRlbPZG29NFbDiaHAHst1RMQPMNTm3NjpUDRIeFlhtOLA45DL8
Message-ID: <CANpmjNNNB8zQJKZaby8KNu8PdAJDufcia+sa2RajWm6Bd2TC4A@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] cleanup: Basic compatibility with capability analysis
To: Peter Zijlstra <peterz@infradead.org>
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
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Mar 2025 at 13:55, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Mar 04, 2025 at 10:21:05AM +0100, Marco Elver wrote:
> > Due to the scoped cleanup helpers used for lock guards wrapping
> > acquire/release around their own constructors/destructors that store
> > pointers to the passed locks in a separate struct, we currently cannot
> > accurately annotate *destructors* which lock was released. While it's
> > possible to annotate the constructor to say which lock was acquired,
> > that alone would result in false positives claiming the lock was not
> > released on function return.
> >
> > Instead, to avoid false positives, we can claim that the constructor
> > "asserts" that the taken lock is held. This will ensure we can still
> > benefit from the analysis where scoped guards are used to protect access
> > to guarded variables, while avoiding false positives. The only downside
> > are false negatives where we might accidentally lock the same lock
> > again:
> >
> >       raw_spin_lock(&my_lock);
> >       ...
> >       guard(raw_spinlock)(&my_lock);  // no warning
> >
> > Arguably, lockdep will immediately catch issues like this.
> >
> > While Clang's analysis supports scoped guards in C++ [1], there's no way
> > to apply this to C right now. Better support for Linux's scoped guard
> > design could be added in future if deemed critical.
>
> Would definitely be nice to have.

Once we have the basic infra here, I think it'll be easier to push for
these improvements. It's not entirely up to me, and we have to
coordinate with the Clang maintainers. Definitely is on the list.

> > @@ -383,6 +387,7 @@ static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)       \
> >
> >  #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)                   \
> >  static inline class_##_name##_t class_##_name##_constructor(_type *l)        \
> > +     __no_capability_analysis __asserts_cap(l)                       \
> >  {                                                                    \
> >       class_##_name##_t _t = { .lock = l }, *_T = &_t;                \
> >       _lock;                                                          \
> > @@ -391,6 +396,7 @@ static inline class_##_name##_t class_##_name##_constructor(_type *l)     \
> >
> >  #define __DEFINE_LOCK_GUARD_0(_name, _lock)                          \
> >  static inline class_##_name##_t class_##_name##_constructor(void)    \
> > +     __no_capability_analysis                                        \
>
> Does this not need __asserts_cal(_lock) or somesuch?
>
> GUARD_0 is the one used for RCU and preempt, rather sad if it doesn't
> have annotations at all.

This is solved later in the series where we need it for RCU:
https://lore.kernel.org/all/20250304092417.2873893-15-elver@google.com/

We can't add this to all GUARD_0, because not all will be for
capability-enabled structs. Instead I added a helper to add the
necessary annotations where needed (see DECLARE_LOCK_GUARD_0_ATTRS).
