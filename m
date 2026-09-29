Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01455547043;
	Tue, 29 Sep 2026 00:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640245; cv=none; b=EHIa0COE5gsdBrQg/nbvNhJaL89T+Q+jI9J7LvzE6QWW9/X52FTLGkbL2bYYwYNTmQtwFjy1030bnSUVFKsGw2/ix7POBDwqcpqUacs0Ev7TZXNNtQAW1SRJ2lDrHdF729NpQpwMcDqIecD1ey3/4MvrslNHJDF1A3XlZMc4n7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640245; c=relaxed/simple;
	bh=bnUECgU5+EwbXPIvPZVqNLz9h8+DJ3e77vseyFGD9OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxGmz9Jw3NpFGLrqdlNw7WLYkSdroUaNzPiqyH2NpTKiYo1768v8kDpxadUMKaKz9TGQnzb+yxuTeVk8ngdc+8W0w0ZEOaGqaMeds/1PVDKT0tRxwB+YG1eg6Mb3aqBQZN4Qnn92/qU7Mjvg/lQtGkcyKPXyQlDWE088N9zR/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVKlUGN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVKlUGN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2D31F000FF;
	Tue, 29 Sep 2026 00:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790640243;
	bh=DRnBJ6TZn2EqPgrsI/oMx7hQuByvRrG/07BxKPjgCcw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=GVKlUGN+6bUxP3ejzrTQB2xhN6P1PHvHhkDQBCbGnaRfcpkEUJQgfEJRnRipdPZoo
	 rGnGGGhncHxcnH3RiUYdiBOCucmvKvoLu53OU8JC+IPseRItAuv/+HrAJY/0okx9/G
	 t6LOrPSDlqCJ+0InmASeb25GuWqw9G3W1hiUvlOehFEm9+Gl/LqXEWRdy/6LutvXly
	 GG/D/F1fpv8J8HYPYvDdL/DCLFos2FejXX0VRgyBp3zjR0sF8BtfuwBpLcqElYPn8H
	 R9bvofryboZGYBxTbz+SuMmVUHIB9zch6N7MSb0Uo0IYsQ1EfRIS5mZbt0oGpAmyPt
	 4qJ+NBccheHyg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5F990CE10F4; Mon, 28 Sep 2026 17:04:03 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:04:03 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>, rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Mason <clm@meta.com>
Subject: Re: [RFC PATCH 0/3] fprobe, rcu/tasks, rhashtable: Switch fprobe and
 BPF kprobe-multi to Tasks-Rude RCU
Message-ID: <b39d3368-fc5c-49a6-b47e-c58224a23e07@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <179060575297.372125.10581329083761385407.stgit@devnote2>
 <f593867e-dcef-4f68-b609-a253f489f7b8@paulmck-laptop>
 <20260929082828.cd9844b5e632a23fd8308dbf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929082828.cd9844b5e632a23fd8308dbf@kernel.org>

On Tue, Sep 29, 2026 at 08:28:28AM +0900, Masami Hiramatsu wrote:
> On Mon, 28 Sep 2026 09:25:02 -0700
> "Paul E. McKenney" <paulmck@kernel.org> wrote:
> 
> > On Mon, Sep 28, 2026 at 11:29:13PM +0900, Masami Hiramatsu (Google) wrote:
> > > Hi,
> > > 
> > > Here is an RFC patch series which removes standard RCU read lock
> > > (guard(rcu) and rcu_read_lock()) from fprobe callback paths
> > > by switching fprobe and BPF multi-kprobe to Tasks-Rude RCU.
> > > 
> > > Motivation & Problem
> > > ====================
> > > 
> > > Currently, fprobe entry and exit callbacks (fprobe_fgraph_entry,
> > > fprobe_return, and fprobe_ftrace_entry) execute in the tracing hot
> > > path where preemption is disabled.
> > > 
> > > However, fprobe was forced to wrap hash lookups with guard(rcu)() and
> > > rcu_read_lock() because:
> > > 
> > > - rhashtable defers bucket table deallocation using standard RCU
> > > - unregister_fprobe() and BPF waited for a standard RCU grace period
> > > 
> > > Taking standard RCU read locks in the tracing fast path introduces
> > > several drawbacks:
> > > 
> > > 1. Unnecessary Runtime Overhead:
> > >    Every probe hit manipulates current->rcu_read_lock_nesting with
> > >    memory barriers, and rcu_read_unlock() adds conditional branches
> > >    to check for special quiescent processing.
> > >    On debug kernels with CONFIG_PROVE_RCU=y or CONFIG_LOCKDEP=y,
> > >    this additionally acquires and releases lockdep maps on every hit,
> > >    introducing severe lockdep hashing overhead and tracer recursion risks.
> > > 
> > > 2. Fragile Dependency on rcu_is_watching():
> > >    Standard RCU treats idle CPUs (and user-space on nohz_full CPUs) as
> > >    Extended Quiescent States (EQS). If a function is traced while
> > >    rcu_is_watching() is false, standard RCU is blind to the read-side
> > >    critical section. In such contexts, synchronize_rcu() does not wait
> > >    for the reader (risking Use-After-Free), and lockdep emits an
> > >    "RCU-illegal: rcu_read_lock() used while not watching!" warning.
> > >    To avoid this, ftrace callbacks normally require FTRACE_OPS_FL_RCU,
> > >    adding extra trampoline check overhead.
> > > 
> > > 3. Asymmetric Synchronization with fprobe_return():
> > >    fprobe_return() executes under preempt_disable_notrace() without
> > >    holding rcu_read_lock(). Prior to this series, unregister_fprobe()
> > >    only waited on synchronize_rcu(), which does NOT wait for pure
> > >    preempt-disabled sections, leaving a potential Use-After-Free window
> > >    during probe unregistration.
> > > 
> > > I've tried to fix the last UAF with simply introducing guard(rcu)()[1]
> > > but Sashiko found the 2nd problem [2]. So I decided to implement this
> > > series.
> > 
> > Unless I am missing something subtle, Sashiko needs to be taught a
> > little bit more about RCU.  Preemption-disabled regions of code really
> > are valid RCU readers.  If you have a reproducer showing that this is
> > not the case in some situation, that would be a bug in RCU.
> 
> Thanks for the clarification!
> So I think we can replace rcu_read_lock() with rcu_read_lock_sched_notrace()?
> (also, maybe we need to add rcu_is_watching() check)

That would work, and yes, you are quite right that if !rcu_is_watching(),
RCU is studiously ignoring you completely, no matter what your preemption
state is.

> Current code may involves lockdep in fprobe, that is not good.

Agreed, that could be problematic in any number of contexts.  ;-)

> BTW, if we want to trace some code in extended quiescent state, do we
> still need this Tasks-Rude RCU?

Well, you need something other than vanilla RCU, anyway.  And Tasks Rude
RCU is one candidate, though it is also a candidate that might annoy
people wishing to minimize IPIs.

							Thanx, Paul

> Thank you,
> 
> > 
> > Adding Roman Gushchin and Chris Mason on CC for their thoughts.
> > 
> > 							Thanx, Paul
> > 
> > > [1] https://lore.kernel.org/all/179055575009.241711.6358052647499787191.stgit@devnote2/
> > > [2] https://lore.kernel.org/all/20260928005114.9C9FC1F000FF@smtp.kernel.org/
> > > 
> > > 
> > > Solution: Tasks-Rude RCU
> > > ========================
> > > 
> > > Because fprobe callbacks already run strictly within preempt-disabled
> > > contexts, we can transition fprobe and its deferred table reclamation
> > > to Tasks-Rude RCU:
> > > 
> > > - Tasks-Rude RCU detects grace periods via schedule_on_each_cpu(),
> > >   forcing a schedule on every online CPU. This guarantees that all
> > >   preempt-disabled sections that began prior to the grace period have
> > >   completed before memory is reclaimed.
> > > - Unlike standard RCU, Tasks-Rude RCU does not rely on dyntick-idle /
> > >   EQS tracking. It does NOT require rcu_is_watching() to be true and
> > >   does not trigger lockdep warnings in pre-RCU/idle execution paths.
> > > - Within fprobe, guard(rcu)() is replaced with guard(rcu_sched_notrace)(),
> > >   reducing the lookup lock to pure, non-tracing preempt counter
> > >   increments without lockdep or RCU state manipulation.
> > > 
> > > Feedback and suggestions from RCU, BPF, and tracing maintainers are welcome!
> > > 
> > > Thank you,
> > > 
> > > ---
> > > base-commit: 5bfa9f1a9dcb6ecb607adbc1c0226605c972935b
> > > 
> > > Masami Hiramatsu (Google) (3):
> > >       rcu/tasks: Export call_rcu_tasks_rude()
> > >       rhashtable: Add use_tasks_rude parameter to defer bucket table free
> > >       fprobe: Switch fprobe and BPF kprobe-multi to Tasks-Rude RCU
> > > 
> > > 
> > >  include/linux/rcupdate.h         |    6 +++
> > >  include/linux/rhashtable-types.h |    2 +
> > >  kernel/bpf/syscall.c             |    2 +
> > >  kernel/rcu/tasks.h               |    8 ++---
> > >  kernel/trace/fprobe.c            |   66 +++++++++++++++++++++-----------------
> > >  lib/rhashtable.c                 |    5 ++-
> > >  6 files changed, 54 insertions(+), 35 deletions(-)
> > > 
> > > -- 
> > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> 
> -- 
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
