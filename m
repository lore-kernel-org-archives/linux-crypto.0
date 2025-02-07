Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B18C1662EF;
	Fri,  7 Feb 2025 08:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738917229; cv=none; b=b1mg9AM7pVWP+iiOAyOyypEJWYD1gikrthmZJAJdmNUZb2GVTnOQD51UYGDacoLj8tnVX9QyMlMpZfHFDp/WKZd/spm3c4VpHl/HTaayfUmkn97BKFgHh7Pk4HVi+VK9PUiZ3vpPo0TzPCakz5swvuBhUU/I1pK0648h04Ui9Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738917229; c=relaxed/simple;
	bh=rEyHxETDDNZrKnj0uGzVSatZPl0zol+heJ1YboWObbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trXx/9X+pe3l0gGbjGGxzPeggBf9UNEuTx0hyvsl82oaBknmHsSfELKUEfPkHL3yjDRYtHWP645xJ+mjUh60cxywDyd7FqhRl+AqgTAbrJxat+J8vG+39WbGVfIZTZwUPzaiMAyuHYI1Pg9mNWoOx7mGMdLVWm7i/I5tXIGrW2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SHcdBsCn; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SHcdBsCn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BS6iDdO4KJAv6Qvg1+T7FVPsD1MTg6ZHoV7nJRWxmPs=; b=SHcdBsCnGAKozLK3fxywAwg34L
	BVZPfTBDE1VZ10TjXglEiLiuaAB8RrcyO2F8rz7/C2J98vfWOYNkNrpkQJT9C6DtFoRrmMQ7LSo+B
	HmByJT+181U0H2f1v3QDbBdIl89CaNSkifK0XxetTK0hlDQkXkdVlJdh9p5ngZ3s0b+vNLphhs7nl
	gvcCC4KbKJPJ1jzoXFEIavvv29vyxdkrJNPRJOHzNPRkDrtH2xbf/rfahL+4pdo/AwOhMRqwUXX4e
	5My+1oS6ezE3ciKCo+G4a6I3Hpbb1AZ00WbiIazjNftHCjllrSaicLbDmFY77bbrSQPaVUHLDFnKB
	zt+Nr0ow==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgJnr-0000000H901-2oF4;
	Fri, 07 Feb 2025 08:33:40 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3A7A2300310; Fri,  7 Feb 2025 09:33:35 +0100 (CET)
Date: Fri, 7 Feb 2025 09:33:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH RFC 01/24] compiler_types: Move lock checking attributes
 to compiler-capability-analysis.h
Message-ID: <20250207083335.GW7145@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-2-elver@google.com>
 <552e940f-df40-4776-916e-78decdaafb49@acm.org>
 <CANpmjNP6by9Kp0rf=ihwj_3j6AW+5aSm6L3LZ4NEW7uvBAV02Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP6by9Kp0rf=ihwj_3j6AW+5aSm6L3LZ4NEW7uvBAV02Q@mail.gmail.com>

On Thu, Feb 06, 2025 at 07:48:38PM +0100, Marco Elver wrote:
> On Thu, 6 Feb 2025 at 19:40, Bart Van Assche <bvanassche@acm.org> wrote:
> >
> > On 2/6/25 10:09 AM, Marco Elver wrote:
> > > +/* Sparse context/lock checking support. */
> > > +# define __must_hold(x)              __attribute__((context(x,1,1)))
> > > +# define __acquires(x)               __attribute__((context(x,0,1)))
> > > +# define __cond_acquires(x)  __attribute__((context(x,0,-1)))
> > > +# define __releases(x)               __attribute__((context(x,1,0)))
> > > +# define __acquire(x)                __context__(x,1)
> > > +# define __release(x)                __context__(x,-1)
> > > +# define __cond_lock(x, c)   ((c) ? ({ __acquire(x); 1; }) : 0)
> >
> > If support for Clang thread-safety attributes is added, an important
> > question is what to do with the sparse context attribute. I think that
> > more developers are working on improving and maintaining Clang than
> > sparse. How about reducing the workload of kernel maintainers by
> > only supporting the Clang thread-safety approach and by dropping support
> > for the sparse context attribute?
> 
> My 2c: I think Sparse's context tracking is a subset, and generally
> less complete, favoring false negatives over false positives (also
> does not support guarded_by).
> So in theory they can co-exist.
> In practice, I agree, there will be issues with maintaining both,
> because there will always be some odd corner-case which doesn't quite
> work with one or the other (specifically Sparse is happy to auto-infer
> acquired and released capabilities/contexts of functions and doesn't
> warn you if you still hold a lock when returning from a function).
> 
> I'd be in favor of deprecating Sparse's context tracking support,
> should there be consensus on that.

I don't think I've ever seen a useful sparse locking report, so yeah, no
tears shed on removing it.
