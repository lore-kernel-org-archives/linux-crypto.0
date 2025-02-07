Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DCB1D618A;
	Fri,  7 Feb 2025 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738921292; cv=none; b=R5xpwuLiWanwirdgJBS75CItW4c/gjDN0DDR+GcKsBbTRlKcr1nkdrO6dG6HZbSplTJ4OzjhWDyKQ0UCO86Rnq1VQ4OrHguLHh0rZyaeUyiOJjp2nRKBsEPyOuLiQEYFxAEpjuKUOLDwveVbIVH6b4XzOby+whGG5aedBVLEbEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738921292; c=relaxed/simple;
	bh=cP0kGHuvU3nRFuyuh7Kc7W3rfxUKkOVYL5Mob7ZUKgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCarXidu8hj5eSnJHmDq4tWEGyb96Om3WXSzR5PztI8C6agOthUcPVZLPizILccNtUwQ/QIcXX4t4O+Dp0y1PIHFsOMeUkwYt8vkTwQyGmVmdmCzI45eKmcTCwuhMgzWtYIVnMtge9HaFaQW8+3GX65/5nBdJ/pSKLhQ97sHiRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W0PE77Qt; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W0PE77Qt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y1gqRSqWYUoS/5b4bvazFO7Ddo/G+ehsqfGlUNrq33s=; b=W0PE77QtqF8+1sI/uGMrmKcTum
	6MbjNVPlK/r7lq3fEtLxK7DIar/jgbEkq5rQMStZsn1YzeUUJJKrM0YOHEPiO5iiIVh1mTEPwgQsx
	DLsFn4XV4xB7ZGONnwOvWFYljnOHWJKo6k8qiI2Edw07tcYIE9vvXks8Si9jjL5ky9QxjWmDTYYNV
	XrH5mRb/iSXkukM7UaWenYruIzNnBX8U4NfxKUyL1wBBaeGmu2q/LldwyXpdkSopKUPaE0F4j+IJZ
	EtrqvIJKdj/0oI+yCGbc5rT/PpXvw8DN3NsgSDQkT9PMk/9lpoeSUNHnZkmD1mQiBJFFcwKllgWeP
	fE4idlew==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgKrR-0000000H9UC-0XlV;
	Fri, 07 Feb 2025 09:41:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1A6313002F0; Fri,  7 Feb 2025 10:41:20 +0100 (CET)
Date: Fri, 7 Feb 2025 10:41:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 02/24] compiler-capability-analysis: Rename
 __cond_lock() to __cond_acquire()
Message-ID: <20250207094120.GA7145@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-3-elver@google.com>
 <20250207082832.GU7145@noisy.programming.kicks-ass.net>
 <Z6XTKTo_LMj9KmbY@elver.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6XTKTo_LMj9KmbY@elver.google.com>

On Fri, Feb 07, 2025 at 10:32:25AM +0100, Marco Elver wrote:
> On Fri, Feb 07, 2025 at 09:28AM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 06, 2025 at 07:09:56PM +0100, Marco Elver wrote:
> > > Just like the pairing of attribute __acquires() with a matching
> > > function-like macro __acquire(), the attribute __cond_acquires() should
> > > have a matching function-like macro __cond_acquire().
> > > 
> > > To be consistent, rename __cond_lock() to __cond_acquire().
> > 
> > So I hate this __cond_lock() thing we have with a passion. I think it is
> > one of the very worst annotations possible since it makes a trainwreck
> > of the trylock code.
> > 
> > It is a major reason why mutex is not annotated with this nonsense.
> > 
> > Also, I think very dim of sparse in general -- I don't think I've ever
> > managed to get a useful warning from between all the noise it generates.
> 
> Happy to reduce the use of __cond_lock(). :-)
> Though one problem I found is it's still needed for those complex
> statement-expression *_trylock that spinlock.h/rwlock.h has, where we
> e.g. have (with my changes):
> 
> 	#define raw_spin_trylock_irqsave(lock, flags)		\
> 		__cond_acquire(lock, ({				\
> 			local_irq_save(flags);			\
> 			_raw_spin_trylock(lock) ?		\
> 			1 : ({ local_irq_restore(flags); 0; }); \
> 		}))
> 
> Because there's an inner condition using _raw_spin_trylock() and the
> result of _raw_spin_trylock() is no longer directly used in a branch
> that also does the unlock, Clang becomes unhappy and complains. I.e.
> annotating _raw_spin_trylock with __cond_acquires(1, lock) doesn't work
> for this case because it's in a complex statement-expression. The only
> way to make it work was to wrap it into a function that has attribute
> __cond_acquires(1, lock) which is what I made __cond_lock/acquire do.

Does something like:

static inline bool
_raw_spin_trylock_irqsave(raw_spinlock_t *lock, unsigned long *flags)
	__cond_acquire(1, lock)
{
	local_irq_save(*flags);
	if (_raw_spin_trylock(lock))
		return true;
	local_irq_restore(*flags);
	return false;
}

#define raw_spin_trylock_irqsave(lock, flags) \
	_raw_spin_trylock_irqsave((lock), &(flags))

work?
