Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3FA26A1AC;
	Wed, 30 Sep 2026 00:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728536; cv=none; b=oZez42YbHaERExk+heVUymh7k3/UncU/3EXdqwyOsaeGR+z4yq3fN0jSRSGv3ax0AZYO49lNMucm6ouiDp2w9WDJC9XJACsTdDMR84VcQURXlyDO9xw4z1DKgke+UZE9ugzK44D+9xf/HRgKY8kWRHfdpQeWOMY492aA7twHQxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728536; c=relaxed/simple;
	bh=Vr5kbx/Wxo2uiemM56xIN6W/PPs8cLnBrrHO4OmJDLA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WECfUxYnvnsZWsuJ9eEPnE60tY5TGmJVs0NyikHRrWSp0kqWuLDazhSaf3vhExWfMufcEBHBqepD2l53w4bw+TxpfSURqD7YfV4bsla9ml4aFUMoMEupgFuAY3BlloNvl/inFiUcKS6DQoGRuR7utXCz/5bDf8lZMuvx0i7GtVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGXI9v6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGXI9v6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831D81F000FF;
	Wed, 30 Sep 2026 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790728535;
	bh=+zMz3pARJwKwANTMZ9Ker8rEGNYg5ecscOmKVXfHuss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OGXI9v6aDu7NK77ISmFND7TDVDaKjmE6K1TqOA49jS2s21Xp17XrJwUjH15QgfyQa
	 NaH4vZGX93CVY3HqTfNGeBfbSTS7aWcXXPURdpJgp+d6xbjgDlZvmlnaIKTpVROyem
	 tCg3PjGXPtSP5/qEbA3N7yVVJbrVXKMBjD61p45lpzmkLkJzT/YorirJ8tODYVxX5S
	 PABBXH13M/nWnRJgdWMEbtZ3/LkDOC900glf0QyUKnozOYzBkWp5vHQIM0CdEhlIVc
	 l06t3VsehnZtmP5E5LCaAS05TjG/jLP3TnwiIgsnJh+DgceLNm9quKOj1nf5CVzgq4
	 +06FtidTuYtMA==
Date: Wed, 30 Sep 2026 09:35:26 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: paulmck@kernel.org
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, Neeraj
 Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, Boqun Feng
 <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Thomas Graf
 <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Steven Rostedt
 <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, John Fastabend
 <john.fastabend@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song
 Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, rcu@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Roman Gushchin
 <roman.gushchin@linux.dev>, Chris Mason <clm@meta.com>
Subject: Re: [RFC PATCH 0/3] fprobe, rcu/tasks, rhashtable: Switch fprobe
 and BPF kprobe-multi to Tasks-Rude RCU
Message-Id: <20260930093526.53be607c55184faf05e8d1f8@kernel.org>
In-Reply-To: <41b37fed-af5c-4559-9e4e-696ef8ccfdd0@paulmck-laptop>
References: <179060575297.372125.10581329083761385407.stgit@devnote2>
	<f593867e-dcef-4f68-b609-a253f489f7b8@paulmck-laptop>
	<20260929082828.cd9844b5e632a23fd8308dbf@kernel.org>
	<b39d3368-fc5c-49a6-b47e-c58224a23e07@paulmck-laptop>
	<CAEf4BzZGdpbX5TdtgbDvDZEsj4wDQiLX94dz-wKfM9aCQJHzzg@mail.gmail.com>
	<41b37fed-af5c-4559-9e4e-696ef8ccfdd0@paulmck-laptop>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 17:41:57 -0700
"Paul E. McKenney" <paulmck@kernel.org> wrote:

> > > > Thanks for the clarification!
> > > > So I think we can replace rcu_read_lock() with rcu_read_lock_sched_notrace()?
> > > > (also, maybe we need to add rcu_is_watching() check)
> > >
> > > That would work, and yes, you are quite right that if !rcu_is_watching(),
> > > RCU is studiously ignoring you completely, no matter what your preemption
> > > state is.
> > >
> > > > Current code may involves lockdep in fprobe, that is not good.
> > >
> > > Agreed, that could be problematic in any number of contexts.  ;-)
> > >
> > > > BTW, if we want to trace some code in extended quiescent state, do we
> > > > still need this Tasks-Rude RCU?
> > >
> > > Well, you need something other than vanilla RCU, anyway.  And Tasks Rude
> > > RCU is one candidate, though it is also a candidate that might annoy
> > > people wishing to minimize IPIs.
> > 
> > Would RCU Tasks Trace be a better candidate given uprobes and
> > sleepable BPF depends on it? Would it work here?

Hmm, those can be sleepable, but this is not. fprobe is based on ftrace
so the callbacks are non preemptive.

> 
> Quite possibly!  Of course, there might be corner-case ftrace/BPF issues
> that you and Masami would know better than would I.
> 
> David Woodhouse suggests the new Atomic SRCU for a vaguely similar
> purpose:
> 
> https://lore.kernel.org/all/20260920211920.928306-1-dwmw2@infradead.org/
> 
> Now that Tasks Trace RCU is implemented in terms of SRCU-fast, there
> might not be all that much air between David's suggestion and yours.

OK, let me check it. But at a glance, this atomic SRCU is still a bit
heavier than rcu_sched_notrace, for fprobe. It involves smp_mb and lockdep. 

So if all of these rcu_read_lock() in fprobe are replaced with
rcu_read_lock_sched_notrace(), isn't it enough to switch the
synchronize_rcu() to synchronize_rcu_tasks_rude() for avoiding
`if (!rcu_is_watching()) return;` ?

(Note, most of replacement will be done by [1])
[1] https://lore.kernel.org/all/179064115227.394389.16910234241400391996.stgit@devnote2/

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
