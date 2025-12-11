Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFD3093C7
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765459209; cv=none; b=UB3nVeZah61mESTEdA23eN/8Ca3CxzQAvBTaVMm1l3nEk5tg001wfA2ix0oIyf/1Hs+5POAmYSTo+BYdrM8Y4Uz1Lfj6z5Em/BhTy+ax/ZgSSlgsFnsYSTquEQBEycgAkV2t0H3TKySGooOPOtOiKOI5ndSfdSodN6dxitZr5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765459209; c=relaxed/simple;
	bh=xRpDisg42q3mlm2OwRhnv/Ng4aisbLnak6Lk2WbPerY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prSx9U3MAuE1Q8drn+nzHwdzSNH/gdwfO61EsDsW04uo5m3lWcysX6fDn+WRm6sFSnXIF84Xi42lp6Su5INJ0Ub+Uo/OEfXDVaubs7cdusyd1JUe2VGHWKNAWa2kypwVyRwnwBe87NX8Tt4YIHWU3xOv/b88sdUEJfZPFsCx0LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HflTkvn8; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HflTkvn8"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78c5b5c1eccso1098557b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 05:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765459207; x=1766064007; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aINMqpJxr1DSJJ7CC9TS1ttoat4qqoJbgL8dBerwdo8=;
        b=HflTkvn8hEQ5fY2RqhhszTXvTmLEvYgLZxCMcnDSLfuaLZuIErpFKXRxgf+UuHaC0O
         ZWeKNTs7qu+FT9MSt5UmeiYJQKzWSBhC49Im5iu+3YkzkxQJhXdRdqpSfKuiJ0WxI64c
         kPOlp4Q3bHCs0CYCUUh/Qt6ROZppFoOT9wu966KN8irGVJ58lhvNKcFIWsNtE19V++73
         OzRACFkmqDfIBaa2T9UEy6OzZdNiqJoxxuSB3FFZjmsiv7nibC0FHtgSTm4nffmNRTv/
         M/Dgzvj4OkQWQV3C3r/DSGsRc6QP/dXuVQAJsTnrvMWXM2YYqklOjG4eMkTYB2TDgvWU
         Ghlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765459207; x=1766064007;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aINMqpJxr1DSJJ7CC9TS1ttoat4qqoJbgL8dBerwdo8=;
        b=Sk6cHNmBT8OwHmblP7IQ/Ime3PWGtSmX8asoB1vUDO1/ZyJ20mjzxU8TyVUN6zTogz
         sBhOlx0NY/8vX4W2Nwtk3ISXZQ1N8cKmSDiHUXEBdKRpAPXElkXJsc2t8NvxWYR79EFk
         mDQGJGR7O1ocuhXF23fS1idEDmGHh0poWlMrryTrePjl7tOTKAiXFIveUuHOQVAFp+Yn
         bYtVKUohp/As2YeY8/IKhZN63a8geXI4JN6dDeeyxCcmN+RQwygJT38Iodzj3aSx7sOD
         qDC5H2gr7b00YTCYzndCrgC2ML9mXrtwkBLmhmKBzlhbbrfR/pAQkkZ/8xje9zR6TuuJ
         gIhA==
X-Forwarded-Encrypted: i=1; AJvYcCW/zG/cU2JAgYd3jM3S9U6pI4j40JMQP6dNdRaazD5oTDlWAyoqeEXEGXmrwsyqgc3cAvYerCNDdyz5jAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUhN5V/O59Hwly18coM3MS9rdIect94ZLI+7K6hiT1eTQILnLU
	wPIFTcDkltuH4Q4WgXHmsI84pdaxBYmyHWMX3c+RThA8XYnMGuvBBA0gf8x2Vp+Nnx240j8Lwkc
	P/5q1BItSZDpZzT9QsgNmyXUcERz/hBi+Jptzgmh5
X-Gm-Gg: AY/fxX4F/cIKuhSEFd0Ch872bnUQYnKL+uyKXiUpdxQKDUsWfWx1CHNzlVAS7IUWvyc
	tJ8BzJgowKIpfkoX6UdgNfA9vBmDomPhuYg5ZCx1frlXNQxV6YGxA9ZqWYzUDw10qSlg+/OxX1M
	298UOhB6CMDHihouRq6yp2v52e669hDmqCXrDwTqfdNv2qFE6AW1Hg5t3ZjYOsUfnKwh2JrA14P
	YiHxEdcLmPcEgDv2VbjwEOGHAkdrRMwkwEZ+V7QKncu9/jVDABaqSDxwrbGUMwdh3glgfbL3ahc
	3JEXaY9jR+Espcpzv3PnzHzfHn8LxJYtxSE=
X-Google-Smtp-Source: AGHT+IGU9q+gRj8IYb1h4AykO50aa48oSg8Xgu9uuuuWfwfeI68H5yAO2hlPZXd3hwVQKsk/WdTiuzJsjMsANS/WvBA=
X-Received: by 2002:a05:690c:14:b0:78c:3835:496a with SMTP id
 00721157ae682-78d6dfa0ba0mr18429857b3.24.1765459206488; Thu, 11 Dec 2025
 05:20:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Thu, 11 Dec 2025 14:19:28 +0100
X-Gm-Features: AQt7F2pfFUoFUVEdkJ6Nswms767xMhA__DttYAE1PqX0AgFhiN8dcasmhdnfxEw
Message-ID: <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 13:17, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> > Introduce basic compatibility with cleanup.h infrastructure: introduce
> > DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
> > and destructors respectively.
> >
> > Note: Due to the scoped cleanup helpers used for lock guards wrapping
> > acquire and release around their own constructors/destructors that store
> > pointers to the passed locks in a separate struct, we currently cannot
> > accurately annotate *destructors* which lock was released. While it's
> > possible to annotate the constructor to say which lock was acquired,
> > that alone would result in false positives claiming the lock was not
> > released on function return.
> >
> > Instead, to avoid false positives, we can claim that the constructor
> > "assumes" that the taken lock is held via __assumes_ctx_guard().


> Moo, so the alias analysis didn't help here?

Unfortunately no, because intra-procedural alias analysis for these
kinds of diagnostics is infeasible. The compiler can only safely
perform alias analysis for local variables that do not escape the
function. The layers of wrapping here make this a bit tricky.

The compiler (unlike before) is now able to deal with things like:
{
    spinlock_t *lock_scope __attribute__((cleanup(spin_unlock))) = &lock;
    spin_lock(&lock);  // lock through &lock
    ... critical section ...
}  // unlock through lock_scope (alias -> &lock)

> What is the scope of this __assumes_ctx stuff? The way it is used in the
> lock initializes seems to suggest it escapes scope. But then something
> like:

It escapes scope.

>         scoped_guard (mutex, &foo) {
>                 ...
>         }
>         // context analysis would still assume foo held
>
> is somewhat sub-optimal, no?

Correct. We're trading false negatives over false positives at this
point, just to get things to compile cleanly.

> > Better support for Linux's scoped guard design could be added in
> > future if deemed critical.
>
> I would think so, per the above I don't think this is 'right'.

It's not sound, but we'll avoid false positives for the time being.
Maybe we can wrangle the jigsaw of macros to let it correctly acquire
and then release (via a 2nd cleanup function), it might be as simple
as marking the 'constructor' with the right __acquires(..), and then
have a 2nd __attribute__((cleanup)) variable that just does a no-op
release via __release(..) so we get the already supported pattern
above.
