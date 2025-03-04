Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29478202960;
	Tue,  4 Mar 2025 12:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741092939; cv=none; b=iDQJzYu13zyWJ9oyNOulFTPptnhmOHKgNGTw6SnD6r2XoJSbVvhCNLx6a7XRWG4nGC/yXe8lfW8LH/2peI9STugjtt9hUQkDCq/GNgiqCYZ2MvaPTi1egXboqHFh05fY4XYyUoo77OeQy7A5BKLfi7qNMsx7Lmv3GSqtvb59N2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741092939; c=relaxed/simple;
	bh=DmjwCKwsD93HO73VrBgBAQWDy8GDmDWgK3GfYhS4AJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDAxWGlruGLvIlbsZt8yLCF9LgpopZVCjjPLcMv2kTTFNfkl5E4ls3ou1fTIHfQHIpRQlHIms80MTGl1qnsgOqaLE9YLErGZV/8Ur3K4as6VMCR3ZOHikVnoptMUrAUOcAb7rkA9vak3a/aWol5e8FkkOVhVpLutJgzMg/JsZhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NRcGU9tD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NRcGU9tD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZOOYa20v84BFJHD1ayfwn3RBGuxwB4d68Xr0Wae/NAo=; b=NRcGU9tDBhoqGCIPbQGfFWXxKw
	RWjX7cPHBFk715BfPa7+c4U0pkvE2rlQvhrS5bwrgs6nXifwyYdsAyGI7UZ6kyLR9Ljx68sBkonBF
	dKdqrkAFi9nGHT5oQDFToz1VDbU5JNvHXZZ6Kzj8q6oy91t+BUKIvBbsXwVBmIlfc63kXhiOlYN0V
	4L4Px2wPqvym2Icjfet6mKLyn3t8Buzxg825uarwxAg2f27pqaQJpHSRifnuT6BIZtLDrAXCQvlX0
	4fXl8ITe0RdCSeDq3ofNrMlIGpeo1g5vpp6QVAJhsBjf7N9aSjC4Ez69+RHslFlbri5YYzDKwx1Rv
	GILKGJug==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tpRnp-000000002P6-1xXA;
	Tue, 04 Mar 2025 12:55:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B29BB30057E; Tue,  4 Mar 2025 13:55:16 +0100 (CET)
Date: Tue, 4 Mar 2025 13:55:16 +0100
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
Subject: Re: [PATCH v2 06/34] cleanup: Basic compatibility with capability
 analysis
Message-ID: <20250304125516.GF11590@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-7-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-7-elver@google.com>

On Tue, Mar 04, 2025 at 10:21:05AM +0100, Marco Elver wrote:
> Due to the scoped cleanup helpers used for lock guards wrapping
> acquire/release around their own constructors/destructors that store
> pointers to the passed locks in a separate struct, we currently cannot
> accurately annotate *destructors* which lock was released. While it's
> possible to annotate the constructor to say which lock was acquired,
> that alone would result in false positives claiming the lock was not
> released on function return.
> 
> Instead, to avoid false positives, we can claim that the constructor
> "asserts" that the taken lock is held. This will ensure we can still
> benefit from the analysis where scoped guards are used to protect access
> to guarded variables, while avoiding false positives. The only downside
> are false negatives where we might accidentally lock the same lock
> again:
> 
> 	raw_spin_lock(&my_lock);
> 	...
> 	guard(raw_spinlock)(&my_lock);  // no warning
> 
> Arguably, lockdep will immediately catch issues like this.
> 
> While Clang's analysis supports scoped guards in C++ [1], there's no way
> to apply this to C right now. Better support for Linux's scoped guard
> design could be added in future if deemed critical.

Would definitely be nice to have.


> @@ -383,6 +387,7 @@ static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
>  
>  #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
>  static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
> +	__no_capability_analysis __asserts_cap(l)			\
>  {									\
>  	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
>  	_lock;								\
> @@ -391,6 +396,7 @@ static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
>  
>  #define __DEFINE_LOCK_GUARD_0(_name, _lock)				\
>  static inline class_##_name##_t class_##_name##_constructor(void)	\
> +	__no_capability_analysis					\

Does this not need __asserts_cal(_lock) or somesuch?

GUARD_0 is the one used for RCU and preempt, rather sad if it doesn't
have annotations at all.

