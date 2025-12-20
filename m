Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F6221FCB
	for <linux-crypto@vger.kernel.org>; Sat, 20 Dec 2025 12:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766235172; cv=none; b=Y2YJIdzOE0EtACKOFjOv4M2w5TUZrOzRjpMVRkoWNNA7LxjDhIhUucZXkemZhtFO0nhyXFaqLHz+zKWABhZfAK99/j/B5G6VpZOFUk6a3/s5C8valdWZRq7icH49XX3uliz14ZnemgshaKQ9GmaJ6YI2ucJGkhrGHHrCBEclkdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766235172; c=relaxed/simple;
	bh=mfOXg447RAZ1jn16CEUFd8WZttm8IVc21yuyK4Wgy4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bPjdSBYpHkt8Kw3+bsnFR/KEiZwVOed1mJ8Thwa+q7gn1qEDarEGhroYHd1QdB+baH/YQFrqfNHr7+VUwnGhfjp3pDYfXoUkwRAG+tw4kvonBBtBBY+puMpBLn1Smg67aoAJO2XKqIJ/fFWS9qm+KVPFS54igpBjT7K+eO/mg2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bPzgDfq9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bPzgDfq9"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f2676bb21so33212395ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 20 Dec 2025 04:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766235170; x=1766839970; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mbJUZ0xTndCf3VdowDat4Wdfn4Fu9I8D0dKSNYqhcFE=;
        b=bPzgDfq9fMDn8+Wn6skuS1G73sQ7mE/xuR3bGKFzGvscKj8iRm0krkBQC4xdEiAPxV
         ZgEPCvrPT2Arb/NySSwQ8QY7P/pNlxxsZ39TCWDGVlX0JAfv2rMtl7PXOfFmE3N3wUGi
         SD+OdfZIgvaxPIXDF2CL862Vj6b4GgMJZW5jW5BYu5yxJMW1ehcAPXSv73kkyTPQolwA
         XjvfeSm9iU/cCN1Bqf04WXgqf6kZtWVfMNLWto5sjqhp1BB/ksyKF7nwz/oaBh80+Eqg
         suwEhsZ3pfiPNoO8lC3KPrBhJqFsIdRNnSdloBwNQtZSLmZJuoWdwljVoUg/gdhozOh1
         WhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766235170; x=1766839970;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbJUZ0xTndCf3VdowDat4Wdfn4Fu9I8D0dKSNYqhcFE=;
        b=XFUXTiaFaJ4+cVbhqMW3+/TN569h9dgroRsfe5dpLagby7HgLjBn9YpkLQhDHwoPiv
         vXnT3LD9gqKgQSoYt4KRtizuaHWe4ydAIKb/xtYi2LywCZTd0D5jjYLXGjepMSIyemNy
         5XNWwPOo4m/2f5eCjtrFjWnuYM2yekFp+VPjO9u1snv2phTf1ey5Q7DOviYblsSR7hn3
         6OAJxQQ2TGxQ8nXpKfSBJZ0Ava88/vADmZMwNKspLLhxSU9JMcsf9x3+kvCqoqw8BT1r
         5qkH6bs043ETYkhq8TIo6bjVj1A01+00HpkizjdtjurzNmOemV8sjMwmSKdrm6pikc2E
         uK7A==
X-Forwarded-Encrypted: i=1; AJvYcCUtu7/jAhBODOY/IBaZPcGr41sqwJiFttm2yUzX/Kt5yNZ71uXUvZ/EU7cWnWsVJ2TiU3oPJCPCf2vaEUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDOHbmCHOvtqiF7pmr19PWuTWergyp6oQfpxFMwVVlVkwZQ4Jm
	/49B3q45vMU31vT61aSTAGfj40I5jvD0p3YBgQnSIoEebW8mIOHPBMRzeuKL9xUnqm013qVbw6l
	NB11ti/CgeW6WWlG/862rT47qs+PjU2TpGxGtYWs3
X-Gm-Gg: AY/fxX4dRwld5YCRbdU2VSP1AKMgOG+tPZ4pPEQPs1xsD3DSrLHzSwRp+cJ+UctRfi9
	hzbRoK3MAOTd6xmuh2E54+ebr/VkAF+xZKMJJrkCTqqNovnldOu9e/RelOm5FutHTNjQLO2pPWC
	pWKgO2mhtyMzhxO35ntG8JuQyfPFUBJO2YqNt9KvwDRzTP+CE0czpNHEr/gcMjwXtBIMWv56hN5
	V7ZeMEK4cbZvZHPCOb2Oajw9S9A3mu+2UxSlInPre011v+jcU1F6wT8ZyIj1MS1b6SM4GNqoIFL
	88rY9apqC4YKaQyQD5N6YWfIj4k=
X-Google-Smtp-Source: AGHT+IETmgOAcDHbF6MqcLCKTf5epOZwA9tGllY35Ia+ZmQjsZsBscMmnIOEXdoPmuZFimi3nJyivgIHK6DMRk5k25A=
X-Received: by 2002:a05:7022:6722:b0:119:e569:f626 with SMTP id
 a92af1059eb24-121722e0444mr6670285c88.31.1766235169708; Sat, 20 Dec 2025
 04:52:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-18-elver@google.com>
 <81d2defc-8980-4022-a464-3d285aff199c@acm.org>
In-Reply-To: <81d2defc-8980-4022-a464-3d285aff199c@acm.org>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Dec 2025 13:52:13 +0100
X-Gm-Features: AQt7F2oG2tk1HNWJ4txFgkKVTgQOAoxLExF81nhreitjIuVCBm-zQmVADhDjpfw
Message-ID: <CANpmjNMAGYeFK-jYafSihmA+T7wi3zC8Sb4fJ+ZjzDK5jGuMvQ@mail.gmail.com>
Subject: Re: [PATCH v5 17/36] locking/rwsem: Support Clang's context analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Dec 2025 at 21:55, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On 12/19/25 7:40 AM, Marco Elver wrote:
> >   static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> > +     __assumes_ctx_lock(sem)
> >   {
> >       WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
> >   }
> >
> >   static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> > +     __assumes_ctx_lock(sem)
> >   {
> >       WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
> >   }
> > @@ -119,6 +121,7 @@ do {                                                              \
> >       static struct lock_class_key __key;                     \
> >                                                               \
> >       __init_rwsem((sem), #sem, &__key);                      \
> > +     __assume_ctx_lock(sem);                                 \
> >   } while (0)
>
> Just like as for lockdep.h, I think that the above annotations should be
> changed into __must_hold().

My point is the same: we use it to delegate to dynamic analysis where
we reach the limits of static analysis, to avoid false positives [1].
Code should apply __must_hold() or __guarded_by() to called or
protected variables respectively, which is both cleaner and the
idiomatic way to use all this.

[1] https://lore.kernel.org/all/CANpmjNPp6Gkz3rdaD0V7EkPrm60sA5tPpw+m8Xg3u8MTXuc2mg@mail.gmail.com/
