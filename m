Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A9B2EDD7C;
	Mon,  1 Sep 2025 08:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714020; cv=none; b=svzsJMiYyF/HJPRQ8lXaXV3S7/Nk1sf7JAXlYtDfG3f6gw3BjTQjUziJ81dlzowuZwfr5bFpSypooQ0D1f905KG427ckmqpn+hZJQVD4iWA59DDIou8ZWajpLhTFqx6F8I7ycrBYK2fyFF0T4DLwLERpWn/bv4m8SV9VPlgxWYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714020; c=relaxed/simple;
	bh=VLpNS+bUWt279KK8jGyWrJFiwF8KwIr7Y32Y2kKXe9I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=sOwIXvcqWNLwEN2tNtyntwQQ3MtdTjDhbfSkMb+QuGzbSxsEe2oqy8EvV55fi9yqjBJPwD1YGAx9MoX1kikDThNVvYv3ieeBXKWfdA99x9AubjRf/4GUF8IIURkg4iajO8TQjH2t32W1kQ/c8DMpHT7ISInjEy6VsAMcDafjRbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGt8xmJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGt8xmJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C78DC4CEF0;
	Mon,  1 Sep 2025 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756714019;
	bh=VLpNS+bUWt279KK8jGyWrJFiwF8KwIr7Y32Y2kKXe9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dGt8xmJOTDfXL69BWi4P5wTdsZoYcC3mBi8hYyPJW074UCn9Tm0f4Rcm6dswzScl6
	 ZZcSNn9v7JdNMB+7opPjArafXDpgDaWucvRE3mv9BfUnFDneaptU5GWAiji+IIxIrd
	 /oq2sDDR4/T9k8qj8Uvi1fgLJ2oVEtRiEGQXrknA04Fnx19SDyg2pBkUpqMlLiYi9N
	 ULzqxUsEyr7dGL5G0Xw8zoxQtaFdu7qh5nkdps/GqMuElJ2EQqRR2Y6bzdJMJmv+cF
	 Vw6FrugYoSfUjlAHNQhoDEo0l/Lu0xXhIHmVkvvk3Umv1NKGEtzkySA+V3J4cjCG91
	 K+HBB/uBBd3nw==
Date: Mon, 1 Sep 2025 17:06:55 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: paulmck@kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Menglong Dong
 <dongml2@chinatelecom.cn>, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel test robot
 <oliver.sang@intel.com>, tgraf@suug.ch, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH] tracing: fprobe: fix suspicious rcu usage in
 fprobe_entry
Message-Id: <20250901170655.0757884ad7c2afb63ced3230@kernel.org>
In-Reply-To: <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
References: <20250829021436.19982-1-dongml2@chinatelecom.cn>
	<20250828222357.55fab4c2@batman.local.home>
	<d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 Aug 2025 04:11:02 -0700
"Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Thu, Aug 28, 2025 at 10:23:57PM -0400, Steven Rostedt wrote:
> > On Fri, 29 Aug 2025 10:14:36 +0800
> > Menglong Dong <dongml2@chinatelecom.cn> wrote:
> > 
> > > rcu_read_lock() is not needed in fprobe_entry, but rcu_dereference_check()
> > > is used in rhltable_lookup(), which causes suspicious RCU usage warning:
> > > 
> > >   WARNING: suspicious RCU usage
> > >   6.17.0-rc1-00001-gdfe0d675df82 #1 Tainted: G S
> > >   -----------------------------
> > >   include/linux/rhashtable.h:602 suspicious rcu_dereference_check() usage!
> > >   ......
> > >   stack backtrace:
> > >   CPU: 1 UID: 0 PID: 4652 Comm: ftracetest Tainted: G S
> > >   Tainted: [S]=CPU_OUT_OF_SPEC, [I]=FIRMWARE_WORKAROUND
> > >   Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
> > >   Call Trace:
> > >    <TASK>
> > >    dump_stack_lvl+0x7c/0x90
> > >    lockdep_rcu_suspicious+0x14f/0x1c0
> > >    __rhashtable_lookup+0x1e0/0x260
> > >    ? __pfx_kernel_clone+0x10/0x10
> > >    fprobe_entry+0x9a/0x450
> > >    ? __lock_acquire+0x6b0/0xca0
> > >    ? find_held_lock+0x2b/0x80
> > >    ? __pfx_fprobe_entry+0x10/0x10
> > >    ? __pfx_kernel_clone+0x10/0x10
> > >    ? lock_acquire+0x14c/0x2d0
> > >    ? __might_fault+0x74/0xc0
> > >    function_graph_enter_regs+0x2a0/0x550
> > >    ? __do_sys_clone+0xb5/0x100
> > >    ? __pfx_function_graph_enter_regs+0x10/0x10
> > >    ? _copy_to_user+0x58/0x70
> > >    ? __pfx_kernel_clone+0x10/0x10
> > >    ? __x64_sys_rt_sigprocmask+0x114/0x180
> > >    ? __pfx___x64_sys_rt_sigprocmask+0x10/0x10
> > >    ? __pfx_kernel_clone+0x10/0x10
> > >    ftrace_graph_func+0x87/0xb0
> > > 
> > > Fix this by using rcu_read_lock() for rhltable_lookup(). Alternatively, we
> > > can use rcu_lock_acquire(&rcu_lock_map) here to obtain better performance.
> > > However, it's not a common usage :/
> > 
> > So this is needed even though it's called under preempt_disable().
> > 
> > Paul, do we need to add an rcu_read_lock() because the code in rht
> > (rhashtable) requires RCU read lock?
> > 
> > I thought that rcu_read_lock() and preempt_disable() have been merged?
> 
> Yes, preempt_disable() does indeed start an RCU read-side critical section,
> just as surely as rcu_read_lock() does.
> 
> However, this is a lockdep check inside of __rhashtable_lookup():
> 
> 	rht_dereference_rcu(ht->tbl, ht)
> 
> Which is defined as:
> 
> 	rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht));
> 
> This is explicitly telling lockdep that rcu_read_lock() is OK and
> holding ht->mutex is OK, but nothing else is.

That is similar to the kprobes, which also allows accessing in
rcu critical section or under mutex.

> 
> So an alternative way to fix this is to declare it to be a false positive,
> and then avoid that false positive by adding a check that preemption
> is disabled.  Adding the rhashtable maintainers for their perspective.

What about changing it alloing it with preempt disabled flag?

Thank you,

> 
> 							Thanx, Paul
> 
> > -- Steve
> > 
> > 
> > > 
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > Closes: https://lore.kernel.org/oe-lkp/202508281655.54c87330-lkp@intel.com
> > > Fixes: dfe0d675df82 ("tracing: fprobe: use rhltable for fprobe_ip_table")
> > > Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> > > ---
> > >  kernel/trace/fprobe.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
> > > index fb127fa95f21..fece0f849c1c 100644
> > > --- a/kernel/trace/fprobe.c
> > > +++ b/kernel/trace/fprobe.c
> > > @@ -269,7 +269,9 @@ static int fprobe_entry(struct ftrace_graph_ent *trace, struct fgraph_ops *gops,
> > >  	if (WARN_ON_ONCE(!fregs))
> > >  		return 0;
> > >  
> > > +	rcu_read_lock();
> > >  	head = rhltable_lookup(&fprobe_ip_table, &func, fprobe_rht_params);
> > > +	rcu_read_unlock();
> > >  	reserved_words = 0;
> > >  	rhl_for_each_entry_rcu(node, pos, head, hlist) {
> > >  		if (node->addr != func)
> > 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
