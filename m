Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2102A25F996
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741104373; cv=none; b=U/N1oZSQoHbJ3LtBoKQYbnrcAYyfNtwhvUpclraAJPuBUCUMXgP1EzLDlp5jnE1XJ66OaJQttjh3t8e6YyqvgqOCPQ1IB5fMSkPoS9pZ6twgwYAMVSnCT5U3V4+2nZazd3lU0TosQPy/QvK56AppTEV1cM/V3uOPChhhZ5WIOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741104373; c=relaxed/simple;
	bh=WWkPvNPAsAK/o9BV1/7oCW3olPK1i28GTmpPd97Esgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GfDjzc3Hpgg1oeDEULX9Zk5H+ks3JExjGJ1FjvB9+mQAa6dMwhwoDSJEuR6BeEl26xENC+BSo8rOafuH1uPGf/rjFqQXrrCDTQGCZC/nybXndKUqsEJHvg0DXGd+gMizM2SZTBIWBKKVCPAbOnosOBwB5BkuhVQwUY6YAUlQpSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z9HOCrOx; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z9HOCrOx"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso9420622a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 08:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741104371; x=1741709171; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1t6ivLIoIuftK2f6E0pPM+6bkcWx6f6OEyc75s3kSwQ=;
        b=Z9HOCrOxgbWushjjjNNkwcx9LKZumjOrDWDWYrSFZVwByCC3MPD1pvISqu/wDAtyuc
         YMBhbv2R70SVZXOnu0MOtBL7Og0Z6dSY6mY5QaE1TjYTghl3t2/dcgtWi07T677SBW6y
         F++hDWUDhN1nYsEmn/8vGVpeNrT3JT7aG6de1v2wxpVL8Qm9MCWfZf7Wp6dcqdEUUFNZ
         zlvekDTGvU+NRADexTCVCpEpKjLhuXeXSkjFKtzq2oS/M5hovCbfMqHd19CCWAkR3lzX
         XUl22CFKGBH0G2aZKmOAxQWQdcT8KLcHcahH7sgWn0gvzlODtN896EyrQCvU9Cj/bTW9
         q3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741104371; x=1741709171;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1t6ivLIoIuftK2f6E0pPM+6bkcWx6f6OEyc75s3kSwQ=;
        b=ZWWIto8WBAdtcqLlpQ7f8PAaEfCvrg0cns68p8+BNNGy5K9Gsfk9GvbDy1c31LZrEP
         r3wVA1LnYdWM+RWHRDmeMsrznmII3KprX07+tE0GwSTwuje2nlT+UMy02LWLys4VMePQ
         +HGx01ARvMfhRd3Tspq2Igd2+1cgWVLsBzwiuU4yp31lpbVTo2WaHmI8lc0mF+46V9YW
         d7jS1aNuljJe1jDdQWIOfgEemMsHJf7RSeOgBcdUg0d+sZSeEGX9U8x3YMeYnox+ARwA
         BMXQ3UykVQ1PjB4pqpWLNGhJUQEHIUoDl7qovyhDBFL9BLVjw7RuIxekjnL1gD9yYcFA
         RFcA==
X-Forwarded-Encrypted: i=1; AJvYcCU6Y0sk9hB5TTM/1e++xZvEjiqI5j69UyDLcHAzpecPBYcgXwoTLerXumK4j+SVU4k4b28W07WvkUZBpxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWU5jkpdTeIigsOnD4WorNl2ESboSNCZ9BH2zusLQfBviNxGjU
	ty2Klh4u6fpaD/DUed0/HF2c7c7mM3zEgaT63k8LxlFojU6zL1+HlCSgajNp7PGhERfhlUcbeQl
	8BkiBmz3EZbu1S4ysHoVjrNbwKBHprLDqkdSA
X-Gm-Gg: ASbGncvEbjzuVQUIH38FNzFyUOe3gpLRrCcVLofp4zCEqkR210WzP2+bwydShL8f8kv
	4KIi6K5eMXetZ9QvC3Ndgj9ZqrJFPoED2c8TFvMFMQZS5upGBrY0VcKvWDDbjiBWXBC8AsKVI3e
	xWs6ae5wXZjlgt3TPhI8CVcD3x42wr7f2vK4ltvYxi4U34uFigtORLrLwY
X-Google-Smtp-Source: AGHT+IGC++S0t8n6ETtzwl720fo704PFOyUfTbjjLTjxsG9B6ISbxU7AjY+lsYqZ8bJrf6DliVj8kaBM3qPLyBgfJME=
X-Received: by 2002:a17:90b:1ccd:b0:2ee:c918:cd60 with SMTP id
 98e67ed59e1d1-2febab78da2mr27444913a91.20.1741104371050; Tue, 04 Mar 2025
 08:06:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com> <20250304092417.2873893-3-elver@google.com>
 <20250304152909.GH11590@noisy.programming.kicks-ass.net>
In-Reply-To: <20250304152909.GH11590@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Tue, 4 Mar 2025 17:05:34 +0100
X-Gm-Features: AQ5f1JrbHN1FRthi_aRGgJ-kY7WYoWmU4g-pqTmD_Y1oCMFum9IakZQE8Yg9HXM
Message-ID: <CANpmjNOR=EaPPhnkj+WwV8mDYNuM7fY2r_xdjORv2MGGxxH_0g@mail.gmail.com>
Subject: Re: [PATCH v2 02/34] compiler-capability-analysis: Add infrastructure
 for Clang's capability analysis
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

On Tue, 4 Mar 2025 at 16:29, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Mar 04, 2025 at 10:21:01AM +0100, Marco Elver wrote:
>
> > +# define __asserts_cap(var)                  __attribute__((assert_capability(var)))
> > +# define __asserts_shared_cap(var)           __attribute__((assert_shared_capability(var)))
>
> > +     static __always_inline void __assert_cap(const struct name *var)                                \
> > +             __attribute__((overloadable)) __asserts_cap(var) { }                                    \
> > +     static __always_inline void __assert_shared_cap(const struct name *var)                         \
> > +             __attribute__((overloadable)) __asserts_shared_cap(var) { }                             \
>
> Since this does not in fact check -- that's __must_hold(), I would
> suggest renaming these like s/assert/assume/.

Yeah, that's better.

FTR - the "asserts_capability" attribute was originally meant to be
used on runtime functions that check that a lock is held at runtime;
what Clang does underneath is simply adding the given capability/lock
to the held lockset, so no real checking is enforced. In this series
it's used for a lot more than just our lockdep_assert*() helpers, so
the "assert" naming is indeed confusing.

Thanks!
