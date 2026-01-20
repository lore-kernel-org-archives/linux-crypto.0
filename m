Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30E7379984;
	Tue, 20 Jan 2026 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768906343; cv=none; b=N41gaAO+RTrR455Q72JL6L88r5vtiavVFDjdmsU4bozTgbL5dz8QB/yodRqPlKwnXjyFZ7FTuQol3lyLKs7qSdk6+CqzRONSCAvovlMUJNWP2ZS4ODRxs76pn8c7fzl9z6etn6oTXNTE62zS/t0h4sQ9zV9U0Zxm85I43QhRGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768906343; c=relaxed/simple;
	bh=7tTn9KomlvNB6ws9NmjAQ2DQsDaQvHCfQzljpMZnb9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I14L4la/M7HODoNjthmwEHngaubrzVNUw8mRYaIF/KCOE3Lbd4GZJCn4Tg//gswOq1kOKuOhmEvBoPDmDBjQ86goDAzgVGRvwDfjD6I8fimhSYyVLzwBo4VBHMtXe9LlDk0cLavEp8ohWAccElSZtC6w7T1Uvr3xI3I/qk51zMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=POGQsvVP; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="POGQsvVP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qkRq9Kh+t9q2WeybfZmZ0D2kPKKoLj074IxXeupVa34=; b=POGQsvVPUouyYNoj21sDqBPYKZ
	R0lCPeU5PRUnjN8MYEExDU20JEhGYMjxgs3bHFc43CwzxDrAUIp4J3NWjt4DYhHjj6peWPSyPdUAm
	6HHdmNtG4AUOAnoVy30ZQtX9lB99C1cCkXmHBVfvkSd7Z8HVc63IWlEcdzbKwIZSu8CB/nWt+I+tG
	U5nDyOddIWAX1IePkez6A4+ZLukEt9GQMNHdzWv80ifqFYIA2NbDkDWfregXWOoQ4mQxKSfDbvAZl
	d3xwt4+zPTEpB3W4t9ePIX0x+7KVg8sFTAyT2++38imeqMTa+Gl3And/cNLGx+jj5EAyuz/H6NhRX
	IMA2qUpA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi9LI-0000000DqiH-27xI;
	Tue, 20 Jan 2026 10:52:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 022A5301C52; Tue, 20 Jan 2026 11:52:12 +0100 (CET)
Date: Tue, 20 Jan 2026 11:52:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marco Elver <elver@google.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bart Van Assche <bvanassche@acm.org>, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip/locking/core 0/6] compiler-context-analysis: Scoped
 init guards
Message-ID: <20260120105211.GW830755@noisy.programming.kicks-ass.net>
References: <20260119094029.1344361-1-elver@google.com>
 <20260120072401.GA5905@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120072401.GA5905@lst.de>

On Tue, Jan 20, 2026 at 08:24:01AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 10:05:50AM +0100, Marco Elver wrote:
> > Note: Scoped guarded initialization remains optional, and normal
> > initialization can still be used if no guarded members are being
> > initialized. Another alternative is to just disable context analysis to
> > initialize guarded members with `context_unsafe(var = init)` or adding
> > the `__context_unsafe(init)` function attribute (the latter not being
> > recommended for non-trivial functions due to lack of any checking):
> 
> I still think this is doing the wrong for the regular non-scoped
> cased, and I think I finally understand what is so wrong about it.
> 
> The fact that mutex_init (let's use mutexes for the example, applied
> to other primitives as well) should not automatically imply guarding
> the members for the rest of the function.  Because as soon as the
> structure that contains the lock is published that is not actually
> true, and we did have quite a lot of bugs because of that in the
> past.
> 
> So I think the first step is to avoid implying the safety of guarded
> member access by initialing the lock.  We then need to think how to
> express they are save, which would probably require explicit annotation
> unless we can come up with a scheme that makes these accesses fine
> before the mutex_init in a magic way.

But that is exactly what these patches do!

Note that the current state of things (tip/locking/core,next) is that
mutex_init() is 'special'. And I agree with you that that is quite
horrible.

Now, these patches, specifically patch 6, removes this implied
horribleness.

The alternative is an explicit annotation -- as you suggest.


So given something like:

struct my_obj {
	struct mutex	mutex;
	int		data __guarded_by(&mutex);
	...
};


tip/locking/core,next:

init_my_obj(struct my_obj *obj)
{
	mutex_init(&obj->mutex); // implies obj->mutex is taken until end of function
	obj->data = FOO;	 // OK, because &obj->mutex 'held'
	...
}

And per these patches that will no longer be true. So if you apply just
patch 6, which removes this implied behaviour, you get a compile fail.
Not good!

So patches 1-5 introduces alternatives.

So your preferred solution:

hch_my_obj(struct my_obj *obj)
{
	mutex_init(&obj->mutex);
	mutex_lock(&obj->mutex); // actually acquires lock
	obj->data = FOO;
	...
}

is perfectly fine and will work. But not everybody wants this. For the
people that only need to init the data fields and don't care about the
lock state we get:

init_my_obj(struct my_obj *obj)
{
	guard(mutex_init)(&obj->mutex); // initializes mutex and considers lock
					// held until end of function
	obj->data = FOO;
	...
}

For the people that want to first init the object but then actually lock
it, we get:

use_my_obj(struct my_obj *obj)
{
	scoped_guard (mutex_init, &obj->mutex) { // init mutex and 'hold' for scope
		obj->data = FOO;
		...
	}

	mutex_lock(&obj->lock);
	...
}

And for the people that *reaaaaaly* hate guards, it is possible to write
something like:

ugly_my_obj(struct my_obj *obj)
{
	mutex_init(&obj->mutex);
	__acquire_ctx_lock(&obj->mutex);
	obj->data = FOO;
	...
	__release_ctx_lock(&obj->mutex);

	mutex_lock(&obj->lock);
	...
}

And, then there is the option that C++ has:

init_my_obj(struct my_obj *obj)
	__no_context_analysis // STFU!
{
	mutex_init(&obj->mutex);
	obj->data = FOO;	 // WARN; but ignored
	...
}

All I can make from your email is that you must be in favour of these
patches.
