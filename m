Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A080B253325;
	Fri, 21 Feb 2025 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740161287; cv=none; b=olBvQVR5Amn4dR/DzfHBmh++24QU1KCnHMaTOSsUJcslq2ILLTCKjVWoD7y5UnYmyWe7NW46Mn5tUJEGUy1orJzchPSDUCS9l+gDjUEQ/gqR73N/Hc6hIXT3HLHnGrBYXxiJP6i4ZSQXsxwH6qtGiN6IrMDZeeqFfzjK7Aaaaq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740161287; c=relaxed/simple;
	bh=Y/T/PdrZXuNEmM28jb0cjrrGJIUltIkZp2ReGmK4x2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFZdgDaQ0tLO8BeIrCYiXvd3FHCuYTS5/yRF0rvR+ba4ujFznrdM/smFcRk9k10mASefE5HbaGMG7F5b1gyeF58fEQbsoiM/LSxlX8iIXTGq0u2c5cOpFdx9cgMffdHbeprwHQ9RttCOzQCRbmk4JkyXbRxghqPb9Qfhm7KzNjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9H5tiM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9H5tiM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2044C4CEE8;
	Fri, 21 Feb 2025 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740161287;
	bh=Y/T/PdrZXuNEmM28jb0cjrrGJIUltIkZp2ReGmK4x2s=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=e9H5tiM+fJIWbO6m5RlayMr8jnFSf4eV8gurRAmsvHkdSxsRjYPmbGLfRRDhRnQMf
	 NY/acCPXS2FSbQYcO+3hPtVlohM8MQUv3eIv8TaPypTSYrcsSzlJUauwxnkhUvbNtE
	 ZpfOSYcsBjKNM1se9fVYgMrY8TtjO5daXzzt0qUC27nN/v2yYMeJhXj6EhEi/EBTlS
	 8FRJMSNGMhCgK3gTnX0eEGzWsn/jC5ARgOIRqFltWknWYmylq5Q2v0xbw+63/eLvmm
	 AxMy8EHrppvSfo2z35qLk3eMRgd6sPUFJUOneeFGP4Ol9LI+tY9QllWxPwiJwHBxEk
	 6UPGpnBPI+EjQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 94967CE059C; Fri, 21 Feb 2025 10:08:06 -0800 (PST)
Date: Fri, 21 Feb 2025 10:08:06 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
Message-ID: <aa50d616-fdbb-4c68-86ff-82bb57aaa26a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
 <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
 <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
 <772d8ec7-e743-4ea8-8d62-6acd80bdbc20@paulmck-laptop>
 <Z7izasDAOC_Vtaeh@elver.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7izasDAOC_Vtaeh@elver.google.com>

On Fri, Feb 21, 2025 at 06:10:02PM +0100, Marco Elver wrote:
> On Thu, Feb 20, 2025 at 05:26PM -0800, Paul E. McKenney wrote:
> [...]
> > > That's what I've tried with this patch (rcu_read_lock_bh() also
> > > acquires "RCU", on top of "RCU_BH"). I need to add a re-entrancy test,
> > > and make sure it doesn't complain about that. At a later stage we
> > > might also want to add more general "BH" and "IRQ" capabilities to
> > > denote they're disabled when held, but that'd overcomplicate the first
> > > version of this series.
> > 
> > Fair enough!  Then would it work to just do "RCU" now, and ad the "BH"
> > and "IRQ" when those capabilities are added?
> 
> I tried if this kind of re-entrant locking works - a test like this:
> 
>  | --- a/lib/test_capability-analysis.c
>  | +++ b/lib/test_capability-analysis.c
>  | @@ -370,6 +370,15 @@ static void __used test_rcu_guarded_reader(struct test_rcu_data *d)
>  |  	rcu_read_unlock_sched();
>  |  }
>  |  
>  | +static void __used test_rcu_reentrancy(struct test_rcu_data *d)
>  | +{
>  | +	rcu_read_lock();
>  | +	rcu_read_lock_bh();
>  | +	(void)rcu_dereference(d->data);
>  | +	rcu_read_unlock_bh();
>  | +	rcu_read_unlock();
>  | +}
> 
> 
>  | $ make lib/test_capability-analysis.o
>  |   DESCEND objtool
>  |   CC      arch/x86/kernel/asm-offsets.s
>  |   INSTALL libsubcmd_headers
>  |   CALL    scripts/checksyscalls.sh
>  |   CC      lib/test_capability-analysis.o
>  | lib/test_capability-analysis.c:376:2: error: acquiring __capability_RCU 'RCU' that is already held [-Werror,-Wthread-safety-analysis]
>  |   376 |         rcu_read_lock_bh();
>  |       |         ^
>  | lib/test_capability-analysis.c:375:2: note: __capability_RCU acquired here
>  |   375 |         rcu_read_lock();
>  |       |         ^
>  | lib/test_capability-analysis.c:379:2: error: releasing __capability_RCU 'RCU' that was not held [-Werror,-Wthread-safety-analysis]
>  |   379 |         rcu_read_unlock();
>  |       |         ^
>  | lib/test_capability-analysis.c:378:2: note: __capability_RCU released here
>  |   378 |         rcu_read_unlock_bh();
>  |       |         ^
>  | 2 errors generated.
>  | make[3]: *** [scripts/Makefile.build:207: lib/test_capability-analysis.o] Error 1
>  | make[2]: *** [scripts/Makefile.build:465: lib] Error 2

I was hoping!  Ah well...  ;-)

> ... unfortunately even for shared locks, the compiler does not like
> re-entrancy yet. It's not yet supported, and to fix that I'd have to go
> and implement that in Clang first before coming back to this.

This would be needed for some types of reader-writer locks, and also for
reference counting, so here is hoping that such support is forthcoming
sooner rather than later.

> I see 2 options for now:
> 
>   a. Accepting the limitation that doing a rcu_read_lock() (and
>      variants) while the RCU read lock is already held in the same function
>      will result in a false positive warning (like above). Cases like that
>      will need to disable the analysis for that piece of code.
> 
>   b. Make the compiler not warn about unbalanced rcu_read_lock/unlock(),
>      but instead just help enforce a rcu_read_lock() was issued somewhere
>      in the function before an RCU-guarded access.
> 
> Option (b) is obviously weaker than (a), but avoids the false positives
> while accepting more false negatives.
> 
> For all the code that I have already tested this on I observed no false
> positives, so I'd go with (a), but I'm also fine with the weaker
> checking for now until the compiler gains re-entrancy support.
> 
> Preferences?

Whichever one provides the best checking without false positives.
Which sounds to me like (a) unless and until false positives crop up,
in which case (b).  Which looks to be where you were going anyway.  ;-)

							Thanx, Paul
