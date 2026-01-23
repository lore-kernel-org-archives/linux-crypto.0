Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B5E136672;
	Fri, 23 Jan 2026 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157856; cv=none; b=NKxNtjnUci28G0gRAclt3B9w+18jTYyIKhceYQYMEO6bszqyLscwb+m3BEocmSvgq5dj0xtlrw9U+5+vxcWGTtWMrif5cemEmpxu8pPe/rzHIXRfA8gehVfX2+bPBK4FgN5ItYBijJR4zaLo5rJJzgp3q/j0Ihsf8TFcj51Zfc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157856; c=relaxed/simple;
	bh=jKM7y9OA8Ts5lLeDHbj2fY3ejsQhVag7YZy+7flDjW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhVQhLFUWV81zKEIy5Z99wTIAVUIJ9tSLpMmjid9ULEGgMu5NCzOFzWa/QQORedEOJ4ADacGftX4HDToHO1ydWGoc9KsOmH11gxwTRjZOYW5FCH7nDqXrJTY8+nQIAa5UOKpT01WkZLdFcHTGZvbDrAkGw+So52d/LEISMWFSZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SaLiAaAs; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SaLiAaAs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GqAez6IU6i4XAwM/6EtVwplPYXTstdRVXB7SnmbYRlw=; b=SaLiAaAsfel5pYPPeoItNDDHFo
	rICGOG7M/lbjPr/KDTy2AOZBL+6V0VWN6U+AJaN97+WX/UPqvGLkv3woVQqK0avtARPBjj0eIFGSr
	DXdpKwy7rKNi+HogbY2+GYJPpiLWPJ3nWPiMFe9+k8qWujcTZyYGca702uo9Kdax7Qj4VKpKCx0yo
	tOvfKEowM6JDpqciRh5M5Ej9KvnMieAgRiwNrRB5mViCd4R3vO0t38bY49jNVNmp+XfW6LMlaQ7Xc
	moZ5WrkYavZfdw9OPT9MkN2JO+wVWC+H+wM8w9Ff8+JKqpVjfbteFpWJjdj+am/JV2NY/yl5E0K3R
	Fy1u1lig==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vjCly-00000001xAQ-0DnN;
	Fri, 23 Jan 2026 08:44:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A0187303018; Fri, 23 Jan 2026 09:44:04 +0100 (CET)
Date: Fri, 23 Jan 2026 09:44:04 +0100
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
Message-ID: <20260123084404.GF171111@noisy.programming.kicks-ass.net>
References: <20260119094029.1344361-1-elver@google.com>
 <20260120072401.GA5905@lst.de>
 <20260120105211.GW830755@noisy.programming.kicks-ass.net>
 <20260122063042.GA24452@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122063042.GA24452@lst.de>

On Thu, Jan 22, 2026 at 07:30:42AM +0100, Christoph Hellwig wrote:

> That's better.  What would be even better for everyone would be:
> 
> 	mutex_prepare(&obj->mutex); /* acquire, but with a nice name */
> 	obj->data = FOO;
> 	mutex_init_prepared(&obj->mutex); /* release, barrier, actual init */
> 
> 	mutex_lock(&obj->mutex); /* IFF needed only */
> 

This is cannot work. There is no such thing is a release-barrier.
Furthermore, store-release, load-acquire needs an address dependency to
work.

When publishing an object, which is what we're talking about, we have
two common patterns:

 1) a locked data-structure

 2) RCU


The way 1) works is:

	Publish				Use

	lock(&structure_lock);
	insert(&structure, obj);
	unlock(&structure_lock);

					lock(&structure_lock)
					obj = find(&structure, key);
					...
					unlock(&structure_lock);

And here the Publish-unlock is a release which pairs with the Use-lock's
acquire and guarantees that Use sees both 'structure' in a coherent
state and obj as it was at the time of insertion. IOW we have
release-acquire through the &structure_lock pointer.

The way 2) works is:

	Publish				Use

	lock(&structure_lock);
	insert(&structure, obj)
	   rcu_assign_pointer(ptr, obj);
	unlock(&structure_lock);
	  	
					rcu_read_lock();
					obj = find_rcu(&structure, key);
					...
					rcu_read_unlock();


And here rcu_assign_pointer() is a store-release that pairs with an
rcu_dereference() inside find_rcu() on the same pointer.

There is no alternative way to order things, there must be a
release-acquire through a common address.

In both cases it is imperative the obj is fully (or full enough)
initialized before publication, because the consumer is only guaranteed
to see the state of the object it was in at publish time.
