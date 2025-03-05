Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913B72D05E;
	Wed,  5 Mar 2025 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741191440; cv=none; b=Z31ylmkQQohV8NRB0swfnR/jvy9wwuaIQnwouhKBm9FNvJDNSoipxTEJnNeJFBL+NZl7U4SmUleI2agWJjA8h3fLagTuQFqsGdDvrwWRsK3k/vJSaS7jXJnKaDLV687r59MyZAv/C4N8m5RLpI78ZeRXiL3O8t2P9pYTgLG9Np8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741191440; c=relaxed/simple;
	bh=CbTXzzl88Ktw/wWR5/ra95x9JfLO3RWPe1jQjpC7yEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+fISIdtGv4MBTMmoQQtSBj359sgaTcg8Uy1vpeKrlAcx3Z9C9478UAw/pwmKZMHTV/oevWo5ivIv1L/4f09YaBmoDeo49BwD/VHrkzA52LscEgWHbUj7H7epfbtM6dFkT3f5jJJJDfwDExsi0QTX1w0L1aLkj8NOmhU4CQIkkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oK6Ax3Bf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oK6Ax3Bf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3jN1+xJ/BcC8IjBdHqdwVy40EWJGNjtffvW7aUuKF40=; b=oK6Ax3BfZA/yGM1I2bGbwg/+7L
	7DoHVzMrKWZSVWODvVnu043ZuRCUkEtnyWZpFpC9ACAfR5w0d+m50zvWUl0IxIViVKGMhwqUyBEPl
	H8zJW/t82dDsAJSQpjC1XAfDGplcCxLlCL3rpV8UALi8s2vKi21L9ifSnbcdAitxEhO8qH2VRTrzL
	6jfMXB/HmpmJg3yOELu0OyY7CYSE805iw7EHbUiPhQXIukDgKHf3dR7hNRUMB0HFx7Yd1mUBF39+N
	EmksIGdewmK97ldh89ukpJ4Q9q/3Ajurv5egf3BVUsdALPYckRL5poS1YWW7/fvch9uPYQ3+j2A6D
	mjFjZYug==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tprQT-00000000coL-1dqW;
	Wed, 05 Mar 2025 16:16:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 79D7430031C; Wed,  5 Mar 2025 17:16:52 +0100 (CET)
Date: Wed, 5 Mar 2025 17:16:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Marco Elver <elver@google.com>, "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bill Wendling <morbo@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
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
Message-ID: <20250305161652.GA18280@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
 <20250305112041.GA16878@noisy.programming.kicks-ass.net>
 <76f8c8e1-5f32-4f31-a960-9285a15340e3@acm.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76f8c8e1-5f32-4f31-a960-9285a15340e3@acm.org>

On Wed, Mar 05, 2025 at 07:27:32AM -0800, Bart Van Assche wrote:
> On 3/5/25 3:20 AM, Peter Zijlstra wrote:
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 248416ecd01c..d27607d9c2dc 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -945,6 +945,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
> >    */
> >   static inline struct queue_limits
> >   queue_limits_start_update(struct request_queue *q)
> > +	__acquires(q->limits_lock)
> >   {
> >   	mutex_lock(&q->limits_lock);
> >   	return q->limits;
> > @@ -965,6 +966,7 @@ int blk_validate_limits(struct queue_limits *lim);
> >    * starting update.
> >    */
> >   static inline void queue_limits_cancel_update(struct request_queue *q)
> > +	__releases(q->limits_lock)
> >   {
> >   	mutex_unlock(&q->limits_lock);
> >   }
> 
> The above is incomplete. Here is what I came up with myself:

Oh, I'm sure. I simply fixed whatever was topmost in the compile output
when trying to build kernel/sched/. After fixing these two, it stopped
complaining about blkdev.

I think it complains about these because they're inline, even though
they're otherwise unused.

> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 80a5b3268986..283fb85d96c8 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -1026,21 +1026,25 @@ static inline bool dev_pm_test_driver_flags(struct device *dev, u32 flags)
> >   }
> >   static inline void device_lock(struct device *dev)
> > +	__acquires(dev->mutex)
> >   {
> >   	mutex_lock(&dev->mutex);
> >   }
> >   static inline int device_lock_interruptible(struct device *dev)
> > +	__cond_acquires(0, dev->mutex)
> >   {
> >   	return mutex_lock_interruptible(&dev->mutex);
> >   }
> >   static inline int device_trylock(struct device *dev)
> > +	__cond_acquires(true, dev->mutex)
> >   {
> >   	return mutex_trylock(&dev->mutex);
> >   }
> >   static inline void device_unlock(struct device *dev)
> > +	__releases(dev->mutex)
> >   {
> >   	mutex_unlock(&dev->mutex);
> >   }
> 
> I propose to annotate these functions with __no_capability_analysis as a
> first step. Review of all callers of these functions in the entire
> kernel tree learned me that annotating these functions results in a
> significant number of false positives and not to the discovery of any
> bugs. The false positives are triggered by conditional locking. An
> example of code that triggers false positive thread-safety warnings:

Yeah, I've ran into this as well. The thing is entirely stupid when it
sees a branch. This is really unfortunate. But I disagree, I would
annotate those functions that have conditional locking with
__no_capability_analysis, or possibly:

#define __confused_by_conditionals __no_capability_analysis

I'm also not quite sure how to annotate things like pte_lockptr().


Anyway, this thing has some promise, however it is *really*, as in
*really* *REALLY* simple. Anything remotely interesting, where you
actually want the help, it falls over.

But you gotta start somewhere I suppose. I think the thing that is
important here is how receptive the clang folks are to working on this
-- because it definitely needs work.
