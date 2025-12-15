Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DE265CA6
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814038; cv=none; b=iwgPQM5u9hEhuf29QIrakV3zQzE3t15pLVOBfoYijv7Ld1Z9TtLH08xjLy4cwLM2JB6Qpkuul2t9viK2wUkAea97T0/+45maYaC9vwRukSu/QrOmASxrS6uvaha9qv5TjBF44BSxO21jZQeP0WX6ijOEhpbfq+HEcJ0QaSeKGl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814038; c=relaxed/simple;
	bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ag1jcYGljOjDY+BeaislgflhuWjln7b5opnFsKYtTkvXOHnji+kJiUBlcoARpgDnpGyd1gjD4qgmlMb89G+5CHfPnwgSGRQ4DlK3WqjIZYti2AvFOc+SHbOYfebWWxcvCGKOaLaK4fRwHBMbYr20RAOI1A6hFb4UXM76i6URuek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3L4zw4AE; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3L4zw4AE"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34c21417781so2665938a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 07:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814036; x=1766418836; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
        b=3L4zw4AEmfn/f/fNDRUYPZSuvtKzrwsroubw/hms++Iru0bPAOg4yCPRvuxfWa0kxn
         3fNefrdGFKRIlUWQCUEDTq/W/V7bjx6CYgrCX35l+YptIuyKMon+1fvuXGctfm1+lOBn
         Ue9aWoONOHB5HcsqyhG0YscCV8fqmMSPJhd8yBv9uc3XwX4DiHnKBzKicSklSfvlzv0t
         DON641wNsDKGmA7Pz9d0PVSUKYJXNKfFjcEyrVEb7w9IkSmvWKWRGSOQ9Ex1bU4u4zk1
         S6cDpe2SOGW5EwQ81vbEb8qrwt2GsOSDMc4HJ33uAyswTmhkliTz7zb7NdAZ5e/1MfFw
         BG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814036; x=1766418836;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROScw7LkVEobmMJDTvBXmeogZcMVtVRNIb25XYU/aOk=;
        b=fSCFJVce/OLJ58v2lXbbh8bwrqRmHVGpiJW8KNow8ckeKdA+x6iS5LB7EJ++GK3U0y
         nCG3txA2S6euoLLXOIgGUhK70tXaGQOQilhgyQMj2U3txYAxXN7RtychTGBvzNDfCNpO
         OzTgHZKUHbUVSozUJj6hJUa6mHexB65A4sbyS+a10UAcYPEoOrnLPaeMQeKJ/4rMQcWP
         9DTqaxMn3yFhIxrx5nxyAgsk7bCsCvPX9y2HETIZKT1A82PhMRSmbDvf63pg4VMlTYaM
         We03eTIT6bxir9NgQ+YgyoJDXmHjnIw66Ozk8X6635k6G3ZcT/39jnBjNPryDxN8vWwn
         YJjA==
X-Forwarded-Encrypted: i=1; AJvYcCVtpuEnsGRVx6PM8+upaiuTo0b0iIIVgR/8XZ1aVZ3wGHQRwK+xdHdTOCxgBJRw0ZhOAXFtn9oJvlrLA4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNlR7hGbLC3jEqULwMPyMyGiWIwdO4ESZFcFnO6PzmCu5PvK/k
	l7cnR0NAzDHTPXmPsC6WC3o6xavj8cjZmYPBFn37nrVVCVDGUImZrpC0joMw9Z57ur9IAhF6UZ0
	R46Voiqj1Jl/TJkBTNHEGxUiIDLijG5JEkqOSOZCm
X-Gm-Gg: AY/fxX4MQD9S/ZttfAadbOnQaIEaeUA4lPLZsgyEV6PuivB7rPnA8X3CJeWVsfeZaxN
	UXLZtzrM0aABYklqK+ug+yBBNWuUUf9/krK5tSaa1T8u+PBXoMtYbr0vcPaSEIFT3SbutImzv1r
	8EW9HXTPdWp7/U7h331CAy/yxuH8/L9jLSK/2EBk0wqhc3libraGTydfLm9zFNzTcF10LCw5m5B
	mDOisD3F2+CAlB2ITMDm/ARhadKCd1SjvQ1Axnd2m1HmhLRsFvBbb874mw5K196PJpmqB9kKEM7
	QATV0PUnXwXQx6qUXxzmJLWmFw==
X-Google-Smtp-Source: AGHT+IEqHtbIkXeCrxZ7N2Is3Z0BKjAm77k3VHnhb//Mc2q6P3kqxs3MPR3a7KluXzGQE7f0g+lEq90Z0zzfwOCm1e4=
X-Received: by 2002:a05:7022:1b0c:b0:11a:3483:4a87 with SMTP id
 a92af1059eb24-11f34be9ca7mr8171406c88.13.1765814035105; Mon, 15 Dec 2025
 07:53:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net> <aUAPbFJSv0alh_ix@elver.google.com>
In-Reply-To: <aUAPbFJSv0alh_ix@elver.google.com>
From: Marco Elver <elver@google.com>
Date: Mon, 15 Dec 2025 16:53:18 +0100
X-Gm-Features: AQt7F2oxzebZt0rcTkreaKMT4PDBgj_kZoo-YwczNEo1aa0S6zPi6Xbs61JFiQg
Message-ID: <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
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

On Mon, 15 Dec 2025 at 14:38, Marco Elver <elver@google.com> wrote:
>
> On Fri, Dec 12, 2025 at 12:09PM +0100, Peter Zijlstra wrote:
> > On Fri, Dec 12, 2025 at 11:15:29AM +0100, Marco Elver wrote:
> > > On Fri, 12 Dec 2025 at 10:43, Peter Zijlstra <peterz@infradead.org> wrote:
> > > [..]
> > > > > Correct. We're trading false negatives over false positives at this
> > > > > point, just to get things to compile cleanly.
> > > >
> > > > Right, and this all 'works' right up to the point someone sticks a
> > > > must_not_hold somewhere.
> > > >
> > > > > > > Better support for Linux's scoped guard design could be added in
> > > > > > > future if deemed critical.
> > > > > >
> > > > > > I would think so, per the above I don't think this is 'right'.
> > > > >
> > > > > It's not sound, but we'll avoid false positives for the time being.
> > > > > Maybe we can wrangle the jigsaw of macros to let it correctly acquire
> > > > > and then release (via a 2nd cleanup function), it might be as simple
> > > > > as marking the 'constructor' with the right __acquires(..), and then
> > > > > have a 2nd __attribute__((cleanup)) variable that just does a no-op
> > > > > release via __release(..) so we get the already supported pattern
> > > > > above.
> > > >
> > > > Right, like I mentioned in my previous email; it would be lovely if at
> > > > the very least __always_inline would get a *very* early pass such that
> > > > the above could be resolved without inter-procedural bits. I really
> > > > don't consider an __always_inline as another procedure.
> > > >
> > > > Because as I already noted yesterday, cleanup is now all
> > > > __always_inline, and as such *should* all end up in the one function.
> > > >
> > > > But yes, if we can get a magical mash-up of __cleanup and __release (let
> > > > it be knows as __release_on_cleanup ?) that might also work I suppose.
> > > > But I vastly prefer __always_inline actually 'working' ;-)
> > >
> > > The truth is that __always_inline working in this way is currently
> > > infeasible. Clang and LLVM's architecture simply disallow this today:
> > > the semantic analysis that -Wthread-safety does happens over the AST,
> > > whereas always_inline is processed by early passes in the middle-end
> > > already within LLVM's pipeline, well after semantic analysis. There's
> > > a complexity budget limit for semantic analysis (type checking,
> > > warnings, assorted other errors), and path-sensitive &
> > > intra-procedural analysis over the plain AST is outside that budget.
> > > Which is why tools like clang-analyzer exist (symbolic execution),
> > > where it's possible to afford that complexity since that's not
> > > something that runs for a normal compile.
> > >
> > > I think I've pushed the current version of Clang's -Wthread-safety
> > > already far beyond what folks were thinking is possible (a variant of
> > > alias analysis), but even my healthy disregard for the impossible
> > > tells me that making path-sensitive intra-procedural analysis even if
> > > just for __always_inline functions is quite possibly a fool's errand.
> >
> > Well, I had to propose it. Gotta push the envelope :-)
> >
> > > So either we get it to work with what we have, or give up.
> >
> > So I think as is, we can start. But I really do want the cleanup thing
> > sorted, even if just with that __release_on_cleanup mashup or so.
>
> Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> abstraction. For that one I was able to make it work like I thought we
> could (below). Some awkwardness is required to make it work in
> for-loops, which only let you define variables with the same type.
>
> For <linux/cleanup.h> it needs some more thought due to extra levels of
> indirection.

For cleanup.h, the problem is that to instantiate we use
"guard(class)(args..)". If it had been designed as "guard(class,
args...)", i.e. just use __VA_ARGS__ explicitly instead of the
implicit 'args...', it might have been possible to add a second
cleanup variable to do the same (with some additional magic to extract
the first arg if one exists). Unfortunately, the use of the current
guard()() idiom has become so pervasive that this is a bigger
refactor. I'm going to leave cleanup.h as-is for now, if we think we
want to give this a go in the current state.

One observation from the rebase: Generally synchronization primitives
do not change much and the annotations are relatively stable, but e.g.
RCU & sched (latter is optional and depends on the sched-enablement
patch) receive disproportionally more changes, and while new
annotations required for v6.19-rc1 were trivial, it does require
compiling with a Clang version that does produce the warnings to
notice.
While Clang 22-dev is being tested on CI, I doubt maintainers already
use it, so it's possible we'll see some late warnings due to missing
annotations when things hit -next. This might be an acceptable churn
cost, if we think the outcome is worthwhile. Things should get better
when Clang 22 is released properly, but until then things might be a
little bumpy if there are large changes across the core
synchronization primitives.

Thanks,
-- Marco
