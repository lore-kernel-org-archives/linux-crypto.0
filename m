Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F135EDBB;
	Thu, 22 Jan 2026 06:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769063451; cv=none; b=bjuIfjRhg1zmXzIxHK6dW9NUQojvw/8jIYtLjNIu3BZ8f1WgJ5lpKiWNAjysGnio5lQtOaBntG3GpGLLHcgM7txfsydRQYbnD+Xl6Wxo0fW5Oo2JRRsesSmRmmAOR5tjZyONrUhkJigT9FpkR7HLvoLjw7wV6qFj/Q0ZGUeOjlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769063451; c=relaxed/simple;
	bh=gI4VneopsdqVesCDKepfvDU9rL2mj/n7kdeCVIu3J5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IH86OUqR9rVBs1BLRs7iILCjpUKm8EYvqAU/Vcju5xzxMrUvlBPpSKq7lVi7F/bWOFqYsAtvm27esb0jfukmiJkSEwGKYrwPVgzh1IbZ6hZwvUsOUE+OXZoi0+Vf2Vw15vDn9oLj9W+bufAqPmtPunYursWKrg1yU4doeQeM+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F0E59227AA8; Thu, 22 Jan 2026 07:30:42 +0100 (CET)
Date: Thu, 22 Jan 2026 07:30:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Marco Elver <elver@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bart Van Assche <bvanassche@acm.org>, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip/locking/core 0/6] compiler-context-analysis: Scoped
 init guards
Message-ID: <20260122063042.GA24452@lst.de>
References: <20260119094029.1344361-1-elver@google.com> <20260120072401.GA5905@lst.de> <20260120105211.GW830755@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120105211.GW830755@noisy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 11:52:11AM +0100, Peter Zijlstra wrote:
> > So I think the first step is to avoid implying the safety of guarded
> > member access by initialing the lock.  We then need to think how to
> > express they are save, which would probably require explicit annotation
> > unless we can come up with a scheme that makes these accesses fine
> > before the mutex_init in a magic way.
> 
> But that is exactly what these patches do!
> 
> Note that the current state of things (tip/locking/core,next) is that
> mutex_init() is 'special'. And I agree with you that that is quite
> horrible.
> 
> Now, these patches, specifically patch 6, removes this implied
> horribleness.
> 
> The alternative is an explicit annotation -- as you suggest.
> 
> 
> So given something like:
> 
> struct my_obj {
> 	struct mutex	mutex;
> 	int		data __guarded_by(&mutex);
> 	...
> };
> 
> 
> tip/locking/core,next:
> 
> init_my_obj(struct my_obj *obj)
> {
> 	mutex_init(&obj->mutex); // implies obj->mutex is taken until end of function
> 	obj->data = FOO;	 // OK, because &obj->mutex 'held'
> 	...
> }
> 
> And per these patches that will no longer be true. So if you apply just
> patch 6, which removes this implied behaviour, you get a compile fail.
> Not good!
> 
> So patches 1-5 introduces alternatives.
> 
> So your preferred solution:
> 
> hch_my_obj(struct my_obj *obj)
> {
> 	mutex_init(&obj->mutex);
> 	mutex_lock(&obj->mutex); // actually acquires lock
> 	obj->data = FOO;
> 	...
> }
> 
> is perfectly fine and will work. But not everybody wants this. For the
> people that only need to init the data fields and don't care about the
> lock state we get:
> 
> init_my_obj(struct my_obj *obj)
> {
> 	guard(mutex_init)(&obj->mutex); // initializes mutex and considers lock
> 					// held until end of function
> 	obj->data = FOO;
> 	...
> }

And this is just as bad as the original version, except it is now
even more obfuscated.

> And for the people that *reaaaaaly* hate guards, it is possible to write
> something like:
> 
> ugly_my_obj(struct my_obj *obj)
> {
> 	mutex_init(&obj->mutex);
> 	__acquire_ctx_lock(&obj->mutex);
> 	obj->data = FOO;
> 	...
> 	__release_ctx_lock(&obj->mutex);
> 
> 	mutex_lock(&obj->lock);
> 	...

That's better.  What would be even better for everyone would be:

	mutex_prepare(&obj->mutex); /* acquire, but with a nice name */
	obj->data = FOO;
	mutex_init_prepared(&obj->mutex); /* release, barrier, actual init */

	mutex_lock(&obj->mutex); /* IFF needed only */

