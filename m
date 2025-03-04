Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817411FC7F8;
	Tue,  4 Mar 2025 11:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741087304; cv=none; b=lj6DnEhyhZ1VRJ1JdWdSlVfF9dw5pDrx3FWWCzP8iQYde88+dHaCSyPkOcJBNTfciMqs8GvR2xykoM4iTLFm5XTWDqs73zWyUsfU7YaOHIFW7IU52aiNunYfOYfo12Y6gs4ombQNk1s/Pa1aWW576RfO5lNSAxaYkkL8F5K0vY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741087304; c=relaxed/simple;
	bh=G4rIjTvAN3MSAYInYwgzNgQTNoCcPC635BrmCLwJ9OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3fv5s7QCjQX/4vby1nQoJW30fyz75HroLo6744m57uPRU958hTs0V5us0xyhWbo0vsCrR1212P1J8mZ/68IZkax7DEvowtErEZIBlMJJzlhL9v/VSj4ufAMHKxFrUeXoH6wB/8NUmJUcyi0wypnd1bd5xAFdis45iCtSf4nrbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NLhOclrZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NLhOclrZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TnqWbk5+EzTofNzXNZf/lQYyzC/wnfe6I/8xtsT0bhY=; b=NLhOclrZC0zl92yrjEf3oFJWig
	kr8Ss/TwDTcr86gvSMjVEKVQmk6rFv6TL88NINFYDRp3DYj73/4yoejRdIMDBYn3O6cBnWD5VjvuK
	t5ZtFoYjSAW7g0zMwW0XfYD28WCsjHtUlFlIlpWp4mmrThbsVnSvY1UGwm1nG6fVNx+anNNlCiaLM
	BwHn820XzhDRHyhtfXFvy8YKeJyR/angRWzevLLxwGIDgmN6AD3PavlhiVPfFPqc6XEUOd0It5am5
	JPjv9ZOH0zGYKN+nN+2aq/dFxeLpeUZ3+ELTCyxbFrMeNn6a7DdP0V7qLCfqOLV1+E3UI+FadMsbt
	xxD4prkg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tpQKp-000000000gA-3GAm;
	Tue, 04 Mar 2025 11:21:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CCF5430049D; Tue,  4 Mar 2025 12:21:14 +0100 (CET)
Date: Tue, 4 Mar 2025 12:21:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 00/34] Compiler-Based Capability- and Locking-Analysis
Message-ID: <20250304112114.GE11590@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-1-elver@google.com>

On Tue, Mar 04, 2025 at 10:20:59AM +0100, Marco Elver wrote:

> === Initial Uses ===
> 
> With this initial series, the following synchronization primitives are
> supported: `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`,
> `seqlock_t`, `bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`,
> `local_lock_t`, `ww_mutex`.

Wasn't there a limitation wrt recursion -- specifically RCU is very much
a recursive lock and TS didn't really fancy that?


>   - Rename __var_guarded_by to simply __guarded_by. Initially the idea
>     was to be explicit about if the variable itself or the pointed-to
>     data is guarded, but in the long-term, making this shorter might be
>     better.
> 
>   - Likewise rename __ref_guarded_by to __pt_guarded_by.

Shorter is better :-)

Anyway; I think I would like to start talking about extensions for these
asap.

Notably I feel like we should have a means to annotate the rules for
access/read vs modify/write to a variable.

The obvious case is RCU; where holding RCU is sufficient to read, but
modification requires a 'real' lock. This is not something that can be
currently expressed.

The other is the lock pattern I touched upon the other day, where
reading is permitted when holding one of two locks, while writing
requires holding both locks.

Being able to explicitly write that in the __guarded_by() annotations is
the cleanest way I think.

Anyway, let me go stare at the actual patches :-)
