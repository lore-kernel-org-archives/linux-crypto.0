Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E99A1EC01F;
	Thu, 20 Feb 2025 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740090971; cv=none; b=V50qxolcWR9vZ9/EJ/JF0xQMlM/C1b4ZD+Y+ldJpGTn9KuZswzVRonYP6pJClRFnL8OuDWeq+Jn5BKo8IlcECjNS6904J/WSi6p3yTidOnBnhbaLQP9U94Hb2IP9YcNrXxaClH7VYw3eeiX4GBc0QsEb+L+Pr/ZL6eJ7dDt52K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740090971; c=relaxed/simple;
	bh=NxbLe0M3BChvVfjcttKakBoKBCdnuodr8JnG2bwAuVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEf3eczDy9KPOn5TO6coA9EaD9Oojv3TEzZP2AqrcqK9f+h4Xm9fHqbbta9Mdabg3SngwnpuRLMhXdWpYpXuui0F97MEE7O36TKCuf6LWtE3A1Z5KU2Wsr+PIl0x26QzdfBLTyb82jMh90Q7hOrF+rXNny7r1kn6VkyBxCtVCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDyKg2pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDyKg2pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1158C4CED1;
	Thu, 20 Feb 2025 22:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740090970;
	bh=NxbLe0M3BChvVfjcttKakBoKBCdnuodr8JnG2bwAuVg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=FDyKg2puhExOStHHCGZfQvF0OJ5i0wDNvhiSU1ndTj99/u1ULIkxjmxbhBkJbKSPD
	 DIv1SBe9o77eIDEzgn1JThcHqDtktta6Ru/UtZHcqvgXwOV94od+7Hn+SrwX8anFiX
	 ZL7XJk3OuMQs0CgHiB/Uiuck2W61xST6SIdHayOxjuxVdSoZcVZ08MwmY+mPAr8ToV
	 rxscLQPcKml/GHQ3u9DY7PBkw/dIjdGpm481LCCt+wHTMwDWccSrTNV3j1Lh7/KH30
	 BtTl89zqMsHO3OUFvWhEi5aAaPOs0fdqRPxXPbGJMMsdjYs3baERWvUBNDMfTOXxcM
	 qnVeMw3xfmLow==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5E986CE0B34; Thu, 20 Feb 2025 14:36:10 -0800 (PST)
Date: Thu, 20 Feb 2025 14:36:10 -0800
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
Message-ID: <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
 <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>

On Thu, Feb 20, 2025 at 11:11:04PM +0100, Marco Elver wrote:
> On Thu, 20 Feb 2025 at 23:00, Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Thu, Feb 06, 2025 at 07:10:09PM +0100, Marco Elver wrote:
> > > Improve the existing annotations to properly support Clang's capability
> > > analysis.
> > >
> > > The old annotations distinguished between RCU, RCU_BH, and RCU_SCHED.
> > > However, it does not make sense to acquire rcu_read_lock_bh() after
> > > rcu_read_lock() - annotate the _bh() and _sched() variants to also
> > > acquire 'RCU', so that Clang (and also Sparse) can warn about it.
> >
> > You lost me on this one.  What breaks if rcu_read_lock_bh() is invoked
> > while rcu_read_lock() is in effect?
> 
> I thought something like this does not make sense:
> 
>   rcu_read_lock_bh();
>   ..
>   rcu_read_lock();
>   ..
>   rcu_read_unlock();
>   ..
>   rcu_read_unlock_bh();

If you have the choice, it is often better to do the rcu_read_lock()
first and the rcu_read_lock_bh() second.

> However, the inverse may well be something we might find somewhere in
> the kernel?

Suppose that one function walks an RCU-protected list, calling some
function from some other subsystem on each element.  Suppose that each
element has another RCU protected list.

It would be good if the two subsystems could just choose their desired
flavor of RCU reader, without having to know about each other.

> Another problem was that if we want to indicate that "RCU" read lock
> is held, then we should just be able to write
> "__must_hold_shared(RCU)", and it shouldn't matter if rcu_read_lock()
> or rcu_read_lock_bh() was used. Previously each of them acquired their
> own capability "RCU" and "RCU_BH" respectively. But rather, we're
> dealing with one acquiring a superset of the other, and expressing
> that is also what I attempted to solve.
> Let me rethink this...

Would it work to have just one sort of RCU reader, relying on a separate
BH-disable capability for the additional semantics of rcu_read_lock_bh()?

							Thanx, Paul
