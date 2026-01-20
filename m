Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40E8392C3A;
	Tue, 20 Jan 2026 07:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768893856; cv=none; b=gyZtHRSiMQ6nRgy5O6wFSU9yM+c9YoDUSG1Q1x7pxp0jsRG1irDAIrB0yxC491AUDkYydJGvZQybToKfWSUPBQt9elIDyxBMQEZ4386xJcNje7v0/PzwbNiSrfUn9wTJFyMm6MNwbcEmzTjBf8KyMLko3RJ0/PgfxpgLP02h21o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768893856; c=relaxed/simple;
	bh=tiH5YVbL3094wk6xrhxCuF+vnDU65uGfJx6ab8aN+uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OuAXWmJqgiNqBTO3w9TasDSL8k7zEpjAtQgj3b//J9VM6XDI+N7PeX+wLbYNvLQXK+zmF7w1Ju7CUGoOgx8+/3ws4/fSc+4+sH7yPDnvB+r6FjNR1izw/UXnTQFhUI9q2QZsI8U8wyKJFYufup2vS96xzR81BYtV6M2IsW2Q7pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14809227AA8; Tue, 20 Jan 2026 08:24:02 +0100 (CET)
Date: Tue, 20 Jan 2026 08:24:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bart Van Assche <bvanassche@acm.org>, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip/locking/core 0/6] compiler-context-analysis: Scoped
 init guards
Message-ID: <20260120072401.GA5905@lst.de>
References: <20260119094029.1344361-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119094029.1344361-1-elver@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 19, 2026 at 10:05:50AM +0100, Marco Elver wrote:
> Note: Scoped guarded initialization remains optional, and normal
> initialization can still be used if no guarded members are being
> initialized. Another alternative is to just disable context analysis to
> initialize guarded members with `context_unsafe(var = init)` or adding
> the `__context_unsafe(init)` function attribute (the latter not being
> recommended for non-trivial functions due to lack of any checking):

I still think this is doing the wrong for the regular non-scoped
cased, and I think I finally understand what is so wrong about it.

The fact that mutex_init (let's use mutexes for the example, applied
to other primitives as well) should not automatically imply guarding
the members for the rest of the function.  Because as soon as the
structure that contains the lock is published that is not actually
true, and we did have quite a lot of bugs because of that in the
past.

So I think the first step is to avoid implying the safety of guarded
member access by initialing the lock.  We then need to think how to
express they are save, which would probably require explicit annotation
unless we can come up with a scheme that makes these accesses fine
before the mutex_init in a magic way.

