Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F83783D3;
	Fri, 17 Apr 2026 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776411533; cv=none; b=SsJvM/U7vyv0hO55naR1uHM3s9y3MblxI4zpk4pWPr9H/QvXOjRfwtkVrcECPHDf1PSIr+jxxboSgGeZ0TrRVCNN9/UFgHv6oRzPGLUVlcMPycvrh9bfC0AEriEmN+RSm3A+GGkJWPg9rrelxK+4LbiorY/uSIWDGZKLCXZq1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776411533; c=relaxed/simple;
	bh=3+OoYA4kjHqVG8ZM6xSU1J5mm5fDqQDHcOlMugEH9eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3mm0QixPTxOTjloy6J0EWXpaJG2xvqTRjsa6l4UgP1dM30kwo++zBhz6U/VnryRDhAzsVESCoICRwtK7uXwKvQnpA08hFOxbbnuKjMDkYrxK7t2QqK+9omuYeny7OQuTrIa40u5N2ZdJeTTrXnwTjG0eCfE6VfDPK0PWqxVTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzB1+Cd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzB1+Cd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45854C19425;
	Fri, 17 Apr 2026 07:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776411533;
	bh=3+OoYA4kjHqVG8ZM6xSU1J5mm5fDqQDHcOlMugEH9eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WzB1+Cd88hHIPfUFdl+7otALEfYIgMVBaObhaNm0pYivMjcr2qQvGVUQjKtU179FV
	 nI1MfoQ9XVzg5VQyITgNjVx6eft7YnQsvjdn0AP2UaQt6aB2GXnE8zoOGWkhNmfj7Q
	 S6IWXS7RznV5xYEubsOfbZcZAOXCEbk6EGX5PFmXVxrjguTkdlWNeS5D/TQY3yqgXY
	 /2unCLIHs0J1tArJMB4TmbFrK6a0OD6Q18S3ttnu0m/jNFyqzcGisGm10kKxtml8Fd
	 hDlLxduTLJKfvXi3jD2/DPuMuY6KYaYXreppTE1OM9Toab5nC1pbOXeyRuRRF9zQvP
	 TPt2WBXV11Y4A==
Date: Thu, 16 Apr 2026 21:38:52 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeHjjGEhlikSsxCX@slm.duckdns.org>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeGIsGi9fBqu9EZT@gondor.apana.org.au>

Hello,

On Fri, Apr 17, 2026 at 09:11:12AM +0800, Herbert Xu wrote:
> On Thu, Apr 16, 2026 at 02:53:41PM -1000, Tejun Heo wrote:
> > 
> > Oops, that's a mistake. I meant GFP_ATOMIC kmalloc allocation. kmalloc uses
> > regular spin_lock so can't be called under raw_spin_lock. There's the new
> > kmalloc_nolock() but that means even smaller reserve size, so higher chance
> > of failing. I'm not sure it can even accomodate larger allocations.
> 
> We should at least try to grow even if it fails.
>
> > Another aspect is that for some use cases, it's more problematic to fail
> > insertion than delaying hash table resize (e.g. that can lead to fork
> > failures on a thrashing system).
> 
> rhashtable is meant to grow way before you reach 100% occupancy.
> So the fact that you even reached this point means that something
> has gone terribly wrong.
> 
> Is this failure reproducible?
> 
> I had a look at kernel/sched/ext.c and all the calls to rhashtable
> insertion come from thread context.  So why does it even use a
> raw spinlock?

Yeah, the DSQ conversion is incorrect. Sorry about that. In the current
master branch, there's another rhashtable - scx_sched_hash - which is
inserted under scx_sched_lock which is a raw spin lock. This is a bit
difficult to trigger because each insertion involves loading a subscheduler
which usually takes quite some time and the whole operatoin is serialized.
In a devel branch, I'm adding a unique thread ID to task rhashtable -
scx_tid_hash:

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git

which is initialized and populated when the root scheduler loads. As all
existing tasks are inserted during init, it ends up expanding the hashtable
rapidly and it's not difficult to make it hit the synchronous growth path.

- Build kernel and boot. Build the example schedulers - `make -C tools/sched_ext`

- Create a lot of dormant threads:

        stress-ng --pthread 1 --pthread-max 10000 --timeout 60s

- Run the qmap scheduler which enables tid hashing:

        tools/sched_ext/build/bin/scx_qmap

and the following lockdep triggers:

  [   34.344355] sched_ext: BPF scheduler "qmap" enabled
  [   35.999783] sched_ext: BPF scheduler "qmap" disabled (unregistered from user space)
  [   92.996704]
  [   92.996947] =============================
  [   92.997462] [ BUG: Invalid wait context ]
  [   92.997974] 7.0.0-work-08607-g4e2e9e22ddbe-dirty #423 Not tainted
  [   92.998759] -----------------------------
  [   92.999285] scx_enable_help/1907 is trying to lock:
  [   92.999903] ffff888237aa9450 (batched_entropy_u32.lock){..-.}-{3:3}, at: get_random_u32+0x40/0x270
  [   93.001047] other info that might help us debug this:
  [   93.001716] context-{5:5}
  [   93.002057] 6 locks held by scx_enable_help/1907:
  [   93.002677]  #0: ffffffff83a90d48 (scx_enable_mutex){+.+.}-{4:4}, at: scx_root_enable_workfn+0x2b/0xad0
  [   93.003872]  #1: ffffffff83a90e40 (scx_fork_rwsem){++++}-{0:0}, at: scx_root_enable_workfn+0x407/0xad0
  [   93.005053]  #2: ffffffff83a90f80 (scx_cgroup_ops_rwsem){++++}-{0:0}, at: scx_cgroup_lock+0x11/0x20
  [   93.006380]  #3: ffffffff83c3de28 (cgroup_mutex){+.+.}-{4:4}, at: scx_root_enable_workfn+0x436/0xad0
  [   93.007535]  #4: ffffffff83a90e88 (scx_tasks_lock){....}-{2:2}, at: scx_root_enable_workfn+0x511/0xad0
  [   93.008757]  #5: ffffffff83b77c98 (rcu_read_lock){....}-{1:3}, at: rhashtable_insert_slow+0x65/0x9e0
  [   93.009909] stack backtrace:
  [   93.010298] CPU: 2 UID: 0 PID: 1907 Comm: scx_enable_help Not tainted 7.0.0-work-08607-g4e2e9e22ddbe-dirty #423 PREEMPT(full)
  [   93.010300] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
  [   93.010301] Sched_ext: qmap (enabling)
  [   93.010301] Call Trace:
  [   93.010304]  <TASK>
  [   93.010305]  dump_stack_lvl+0x50/0x70
  [   93.010307]  __lock_acquire+0x9e8/0x2760
  [   93.010314]  lock_acquire+0xb2/0x240
  [   93.010317]  get_random_u32+0x58/0x270
  [   93.010321]  bucket_table_alloc+0xa6/0x190
  [   93.010322]  rhashtable_insert_slow+0x8ac/0x9e0
  [   93.010325]  scx_root_enable_workfn+0x893/0xad0
  [   93.010328]  kthread_worker_fn+0x108/0x300
  [   93.010330]  kthread+0xfa/0x120
  [   93.010332]  ret_from_fork+0x175/0x320
  [   93.010334]  ret_from_fork_asm+0x1a/0x30
  [   93.010336]  </TASK>

Now, I can move the insertion out of the raw scx_tasks_lock; however, that
complicates init path as now it has to account for possible races against
task exit path.

Also, taking a step back, if rhashtable allows usage under raw spin locks,
isn't this broken regardless of how easy or difficult it may be to reproduce
the problem? Practically speaking, the scx_sched_hash one is unlikely to
trigger in real world; however, it is still theoretically possible and I'm
pretty positive that one would be able to create a repro case with the right
interference workload. It'd be contrived for sure but should be possible.

Thanks.

-- 
tejun
