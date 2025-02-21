Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5572A94A;
	Fri, 21 Feb 2025 01:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740101217; cv=none; b=NTVwP8bQ3noiwhiYUd2f5u4Lqxa9Cc5m8kccU2WiQzzfM/GmvNH8Jz0f9l+qFB6uKaFQcGHwGxz6kSJgiFT7o1zhlid9IqTGaaCZ7DDrNt62+DuhRPaagAQFNnVB46WdvULMAAaNDM8z/0nuu8yG8EdTPecJrBB3Et5K7eTBu4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740101217; c=relaxed/simple;
	bh=z0ba38Mwb/77bp059pfXbDuObMcVMksMDAqKXmfGcuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTkEwYoBl42WS2C3Hsdy0N97EMY5ofkBFQGOCje9gfuXnIX3meuffdC0LU8USdfytNXlDPb8/QPYQ9YbHTu9eR8oGqUfU58oQ5jMPZOoXGPt7F7BI/QctVODzpqIpAbz33iofi6QqUkdClZH6Q93ZahpsWN0Bgt0oi7Dohj+XaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XzSceNiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XzSceNiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B53C4CED1;
	Fri, 21 Feb 2025 01:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740101217;
	bh=z0ba38Mwb/77bp059pfXbDuObMcVMksMDAqKXmfGcuQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=XzSceNiJkcaKOCLQOOyMbKjfo8aHXTm2791fyHjotFCHhaqLZexqw1cgzC5oUxzAk
	 n8NAPEGB3c99/sBBxy5L8js2OQ40jOVqadWS04zy4Qh7nZEFPUpM86PRwGVvXq1lji
	 Oo8KHwWErPxmuEX63+1FTAIQyo4oc+VUSvjk4EHIpWP1ibtSggZ6eKfiCReM00gYvo
	 MtjVei1j7h3S8loJ3mRY6ymkVujd1uhl9kDYOjt9+pItFUb8Sti1Db0S24emQv06js
	 7+I21imZSShsxle0rXeih85mpde7I+E/5SSihDB+zaYo647NeEtFXCL/UlY59NF0vl
	 tFDvhcJqzxJ5w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A122DCE04E4; Thu, 20 Feb 2025 17:26:56 -0800 (PST)
Date: Thu, 20 Feb 2025 17:26:56 -0800
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
Message-ID: <772d8ec7-e743-4ea8-8d62-6acd80bdbc20@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
 <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
 <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>

On Fri, Feb 21, 2025 at 01:16:00AM +0100, Marco Elver wrote:
> On Thu, 20 Feb 2025 at 23:36, Paul E. McKenney <paulmck@kernel.org> wrote:
> [...]
> > Suppose that one function walks an RCU-protected list, calling some
> > function from some other subsystem on each element.  Suppose that each
> > element has another RCU protected list.
> >
> > It would be good if the two subsystems could just choose their desired
> > flavor of RCU reader, without having to know about each other.
> 
> That's what I figured might be the case - thanks for clarifying.
> 
> > > Another problem was that if we want to indicate that "RCU" read lock
> > > is held, then we should just be able to write
> > > "__must_hold_shared(RCU)", and it shouldn't matter if rcu_read_lock()
> > > or rcu_read_lock_bh() was used. Previously each of them acquired their
> > > own capability "RCU" and "RCU_BH" respectively. But rather, we're
> > > dealing with one acquiring a superset of the other, and expressing
> > > that is also what I attempted to solve.
> > > Let me rethink this...
> >
> > Would it work to have just one sort of RCU reader, relying on a separate
> > BH-disable capability for the additional semantics of rcu_read_lock_bh()?
> 
> That's what I've tried with this patch (rcu_read_lock_bh() also
> acquires "RCU", on top of "RCU_BH"). I need to add a re-entrancy test,
> and make sure it doesn't complain about that. At a later stage we
> might also want to add more general "BH" and "IRQ" capabilities to
> denote they're disabled when held, but that'd overcomplicate the first
> version of this series.

Fair enough!  Then would it work to just do "RCU" now, and ad the "BH"
and "IRQ" when those capabilities are added?

							Thanx, Paul
