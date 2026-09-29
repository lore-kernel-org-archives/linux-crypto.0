Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C495231E831
	for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 00:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790642046; cv=pass; b=q4OlJxdVmfCi9dAcosqkvcTGrj4N944z9zgUXC4A1rCRmPBMw8KjBh7lwRyeyQm7c/QKLY1a4bl4k97qXoF6cyqn1hbWNDvW8r7Q/RPuVPafR/yzcsYsON2sRr8RejPn7epwjJiMWb5f0avgy7+xu0xw3vqFYB2wQf+9r/EEkKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790642046; c=relaxed/simple;
	bh=mqqf+qQWt+Rbqdkot/GN8JguHjkq9KCxIN9/UveGBuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fq3AUgNT2DaVyzv59ZIEJH+u5aZ2myyi4Aiw8K8t3I9e7zGATHdcaH4gepWJkHWkSJwU88XE6tFWzMA7tJ8Z+l1eNSBcp9Crk/jd1RcLz70R0AFKAGRGzqIc+s5fA3Ip0iUH465Qm6G1eVsCCSfJuYn/sYEq4Vnja4tpY9vvg6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n7iBESiK; arc=pass smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n7iBESiK"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f38so16179355ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2026 17:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790642044; cv=none;
        d=google.com; s=arc-20260327;
        b=kKwRW/RGilqWCEh0JMArXzMNCtzwD8r0eSdLJN9p2XOAx3Q9mfweIcE8F5R47PK1f8
         wGZNCi7QlBoT/xA1lV1aApVgRtd7VQxAjyy7cO0HCadl1s6TklmoZXKam0IQbRXC88+o
         H8zLHqMhSXFG+D9uGlxRZqAbQjjKm4KLqWfK0+JfXEjqe7iFyai4xpxpgSJQUu1p42LF
         hvWFuKXdrmBUngWDtDfaE4pumAQs9SiEbQDL7RmCJIvrXmqXxIxRJUcajS8zJQpZDm2b
         RLHGDumTjEfg168+SFR/Dy2y+Q2pHAaO5j6oCawh69/Kn9PaEfWvsPPZgFb/qKbqlF8C
         6Qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XJgia+oGABNjKIVqlZno+TYa0ToXTohZneVjpc1WXaQ=;
        fh=fTwANSnRbbGmozC9KWN4joxh6LNnmHZqm2Q/cuE/YzI=;
        b=q7EHhYyRpUJmgiCLLaLkX7Z2Q2l/I8HHtfufT2YahTo5LSta0wPl8yFIr6RzJDZnL9
         ot3v4SM/4MNMoH9g74fl2pk0U9kU+6gRhhHf60loCk6n6Wa8yl1UeKL2jfWmc7tYbZpL
         HDMh2r+Sv40omYwC3lMZwM7Rr/bzCw4sqZjg/VU+I0jd9BFtk2tgEiJSsDlxmMmtmek8
         fONK3gNC7S+cGl7zmom1bOXHjY4/CvHVLnSorOmcv0wS0x/lzl95T7SOUB5p1FOCplrA
         tr6NdkzSja7BuYF1EcbCIMYS8ym/UXOX7Bv/NFbfNEDgSKkGznICOTQ3ulfXjUI13ih1
         LxXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790642044; x=1791246844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XJgia+oGABNjKIVqlZno+TYa0ToXTohZneVjpc1WXaQ=;
        b=n7iBESiKQuXPl+D1SnhYCYUtZp8c2Ol/jzYYR/hVn8ErMURwt82lFz12MoGlOwaRdk
         nteXEKXL2S825s+ImVdSJZYoSF2q+w4EmE1BXPwa8Gh7qAV8tU0tiaWeQQA2jDirFk49
         f5brpDOXk1KWrsoldKuyCojmftqwTPQSvnOXRRb+8QIAIqBsaub1HF0qPT0DlnZxKwcM
         nb+ZSg+/CsOY9aWUIdux3RhV0zAQPkw+dw+gkmIjpFFf7neewsWZuI7/9w6cgDjLM2j5
         OHApmLI7jCSj9Lv7sNLQUug3/dbuX+9qLEmZLsxHLhVWU0twhGysgqhJlyY4Tirtju7k
         CkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790642044; x=1791246844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJgia+oGABNjKIVqlZno+TYa0ToXTohZneVjpc1WXaQ=;
        b=EQh3Lu34kYqOi0bvgpadHiKgVQ3WvRZTWzRqvHb8PtrlRoUstpwjj3wu0ZHcU73R1K
         NViYZu6cE+00ejhXSGufMrvliJu+bgyBYXppa5CULdSrmXZvc2M4sXPvKlU4pc1Fn6Nt
         2kbE72Ncoz5oO+4e6shOQ0zGer5EE54mAlF50vJUNsbA08kQ/xQDmIUj5G1IDdqxdm6T
         hgSYBRQlPekcJaFFquDpJ/RCHcyW5G6/an2rmRGwkdMk1DHj5C3Wu09I9lzhdWtyUl9U
         d2mNAoLSmtk4dzSjT+q84L6kcEjvaMo0UynNx7mBuB2/UpjxrOxhIUctsTEVyTcPUdOd
         Y2PA==
X-Forwarded-Encrypted: i=1; AKwUvBwygg10Gzi2vUtJhQ3p5jBVtXNtP6DIJ6znwaJj0qhw+XjdKpH2z9gcfjzNgVcoEokzXk3oyDegsuXbn+s=@vger.kernel.org
X-Gm-Message-State: AFq9FYK4IL/wMgl756DQdqMBr3CQzdUvNxGc08V9mgL06oaDMNy+ZfSD
	XeeIanN7K9n+/IIJseAgigcePx/yqHO7gMOveWjHqkYCCLC4xXEge7PcEbtYx7wUKkE7igQb4sH
	GQlJ442A7ThalecHGWSbDC2sugXCv8sk=
X-Gm-Gg: AYBFou0JdWMdtz1TJdoO1ELpROvu/jkkgRZh3M2efRe7wv5rrKcPe9KkQlQy38oiVh+
	mfj1zFG+4hhvuMU6djyrYjaij65detPAwiwA3hj2TMyc1B6pEvHLoanRo8/VQDpS6XAV3tMlBKw
	/BoJRy9digBDeb3AKMIx2B3ATuMeotNU+dbIuSZLAqoC8NObG2k3jQ8Tc09dWge8XS1BpMmNC4C
	bF8yVLOtr48poTasWbEDDYfhPfzmcQbtxHX6z1ziI32+hV0DMKwEVZSs74S3sWXTYtxs3kqpul4
	LSheIgep5j2CNLwccwZ3oLB/AR8wYapNbugjy4IqdqQhCuHaU4FPVWfGBHIdAzUZOblySDxTYgJ
	QyNEX4Xc2JqXCZyOPFc9/vMCdeotH7ha+iqWL
X-Received: by 2002:a17:903:1b2e:b0:2df:9e2d:862a with SMTP id
 d9443c01a7336-2df9e2d8d3fmr73249655ad.54.1790642044011; Mon, 28 Sep 2026
 17:34:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <179060575297.372125.10581329083761385407.stgit@devnote2>
 <f593867e-dcef-4f68-b609-a253f489f7b8@paulmck-laptop> <20260929082828.cd9844b5e632a23fd8308dbf@kernel.org>
 <b39d3368-fc5c-49a6-b47e-c58224a23e07@paulmck-laptop>
In-Reply-To: <b39d3368-fc5c-49a6-b47e-c58224a23e07@paulmck-laptop>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 28 Sep 2026 17:33:50 -0700
X-Gm-Features: AclHuK_dKxBmfWWtMMiZMhNO8faLQ6MSkCT-v4tR7n5AaQQqt0IRUGrLd9FCGkc
Message-ID: <CAEf4BzZGdpbX5TdtgbDvDZEsj4wDQiLX94dz-wKfM9aCQJHzzg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] fprobe, rcu/tasks, rhashtable: Switch fprobe and
 BPF kprobe-multi to Tasks-Rude RCU
To: paulmck@kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Thomas Graf <tgraf@suug.ch>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Chris Mason <clm@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 5:04=E2=80=AFPM Paul E. McKenney <paulmck@kernel.or=
g> wrote:
>
> On Tue, Sep 29, 2026 at 08:28:28AM +0900, Masami Hiramatsu wrote:
> > On Mon, 28 Sep 2026 09:25:02 -0700
> > "Paul E. McKenney" <paulmck@kernel.org> wrote:
> >
> > > On Mon, Sep 28, 2026 at 11:29:13PM +0900, Masami Hiramatsu (Google) w=
rote:
> > > > Hi,
> > > >
> > > > Here is an RFC patch series which removes standard RCU read lock
> > > > (guard(rcu) and rcu_read_lock()) from fprobe callback paths
> > > > by switching fprobe and BPF multi-kprobe to Tasks-Rude RCU.
> > > >
> > > > Motivation & Problem
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > Currently, fprobe entry and exit callbacks (fprobe_fgraph_entry,
> > > > fprobe_return, and fprobe_ftrace_entry) execute in the tracing hot
> > > > path where preemption is disabled.
> > > >
> > > > However, fprobe was forced to wrap hash lookups with guard(rcu)() a=
nd
> > > > rcu_read_lock() because:
> > > >
> > > > - rhashtable defers bucket table deallocation using standard RCU
> > > > - unregister_fprobe() and BPF waited for a standard RCU grace perio=
d
> > > >
> > > > Taking standard RCU read locks in the tracing fast path introduces
> > > > several drawbacks:
> > > >
> > > > 1. Unnecessary Runtime Overhead:
> > > >    Every probe hit manipulates current->rcu_read_lock_nesting with
> > > >    memory barriers, and rcu_read_unlock() adds conditional branches
> > > >    to check for special quiescent processing.
> > > >    On debug kernels with CONFIG_PROVE_RCU=3Dy or CONFIG_LOCKDEP=3Dy=
,
> > > >    this additionally acquires and releases lockdep maps on every hi=
t,
> > > >    introducing severe lockdep hashing overhead and tracer recursion=
 risks.
> > > >
> > > > 2. Fragile Dependency on rcu_is_watching():
> > > >    Standard RCU treats idle CPUs (and user-space on nohz_full CPUs)=
 as
> > > >    Extended Quiescent States (EQS). If a function is traced while
> > > >    rcu_is_watching() is false, standard RCU is blind to the read-si=
de
> > > >    critical section. In such contexts, synchronize_rcu() does not w=
ait
> > > >    for the reader (risking Use-After-Free), and lockdep emits an
> > > >    "RCU-illegal: rcu_read_lock() used while not watching!" warning.
> > > >    To avoid this, ftrace callbacks normally require FTRACE_OPS_FL_R=
CU,
> > > >    adding extra trampoline check overhead.
> > > >
> > > > 3. Asymmetric Synchronization with fprobe_return():
> > > >    fprobe_return() executes under preempt_disable_notrace() without
> > > >    holding rcu_read_lock(). Prior to this series, unregister_fprobe=
()
> > > >    only waited on synchronize_rcu(), which does NOT wait for pure
> > > >    preempt-disabled sections, leaving a potential Use-After-Free wi=
ndow
> > > >    during probe unregistration.
> > > >
> > > > I've tried to fix the last UAF with simply introducing guard(rcu)()=
[1]
> > > > but Sashiko found the 2nd problem [2]. So I decided to implement th=
is
> > > > series.
> > >
> > > Unless I am missing something subtle, Sashiko needs to be taught a
> > > little bit more about RCU.  Preemption-disabled regions of code reall=
y
> > > are valid RCU readers.  If you have a reproducer showing that this is
> > > not the case in some situation, that would be a bug in RCU.
> >
> > Thanks for the clarification!
> > So I think we can replace rcu_read_lock() with rcu_read_lock_sched_notr=
ace()?
> > (also, maybe we need to add rcu_is_watching() check)
>
> That would work, and yes, you are quite right that if !rcu_is_watching(),
> RCU is studiously ignoring you completely, no matter what your preemption
> state is.
>
> > Current code may involves lockdep in fprobe, that is not good.
>
> Agreed, that could be problematic in any number of contexts.  ;-)
>
> > BTW, if we want to trace some code in extended quiescent state, do we
> > still need this Tasks-Rude RCU?
>
> Well, you need something other than vanilla RCU, anyway.  And Tasks Rude
> RCU is one candidate, though it is also a candidate that might annoy
> people wishing to minimize IPIs.
>

Would RCU Tasks Trace be a better candidate given uprobes and
sleepable BPF depends on it? Would it work here?

>                                                         Thanx, Paul
>
> > Thank you,
> >
> > >
> > > Adding Roman Gushchin and Chris Mason on CC for their thoughts.
> > >
> > >                                                     Thanx, Paul
> > >
> > > > [1] https://lore.kernel.org/all/179055575009.241711.635805264749978=
7191.stgit@devnote2/
> > > > [2] https://lore.kernel.org/all/20260928005114.9C9FC1F000FF@smtp.ke=
rnel.org/
> > > >
> > > >
> > > > Solution: Tasks-Rude RCU
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > > >
> > > > Because fprobe callbacks already run strictly within preempt-disabl=
ed
> > > > contexts, we can transition fprobe and its deferred table reclamati=
on
> > > > to Tasks-Rude RCU:
> > > >
> > > > - Tasks-Rude RCU detects grace periods via schedule_on_each_cpu(),
> > > >   forcing a schedule on every online CPU. This guarantees that all
> > > >   preempt-disabled sections that began prior to the grace period ha=
ve
> > > >   completed before memory is reclaimed.
> > > > - Unlike standard RCU, Tasks-Rude RCU does not rely on dyntick-idle=
 /
> > > >   EQS tracking. It does NOT require rcu_is_watching() to be true an=
d
> > > >   does not trigger lockdep warnings in pre-RCU/idle execution paths=
.
> > > > - Within fprobe, guard(rcu)() is replaced with guard(rcu_sched_notr=
ace)(),
> > > >   reducing the lookup lock to pure, non-tracing preempt counter
> > > >   increments without lockdep or RCU state manipulation.
> > > >
> > > > Feedback and suggestions from RCU, BPF, and tracing maintainers are=
 welcome!
> > > >
> > > > Thank you,
> > > >
> > > > ---
> > > > base-commit: 5bfa9f1a9dcb6ecb607adbc1c0226605c972935b
> > > >
> > > > Masami Hiramatsu (Google) (3):
> > > >       rcu/tasks: Export call_rcu_tasks_rude()
> > > >       rhashtable: Add use_tasks_rude parameter to defer bucket tabl=
e free
> > > >       fprobe: Switch fprobe and BPF kprobe-multi to Tasks-Rude RCU
> > > >
> > > >
> > > >  include/linux/rcupdate.h         |    6 +++
> > > >  include/linux/rhashtable-types.h |    2 +
> > > >  kernel/bpf/syscall.c             |    2 +
> > > >  kernel/rcu/tasks.h               |    8 ++---
> > > >  kernel/trace/fprobe.c            |   66 +++++++++++++++++++++-----=
------------
> > > >  lib/rhashtable.c                 |    5 ++-
> > > >  6 files changed, 54 insertions(+), 35 deletions(-)
> > > >
> > > > --
> > > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> >
> >
> > --
> > Masami Hiramatsu (Google) <mhiramat@kernel.org>
