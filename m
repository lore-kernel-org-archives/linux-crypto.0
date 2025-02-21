Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E482505D3;
	Fri, 21 Feb 2025 18:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740163963; cv=none; b=AtyvFTEBDzsnCTKTs7Ppn6XoZ24zp1BbRdIDYevMi4kclV17QOc68IJszwn631zRqRr9jxcoszZVKnb7pmBDUlWpXyGaSieJ7/A29zQ3cxUZEc4faCFh6truY6kGe8ui1SlVU9RKP83omNZ74i0DrHcchJoRPhN1tbfudwtYJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740163963; c=relaxed/simple;
	bh=vu0ltDGFlC9tYwTkw3SAQv/rsW2bQo0Cg8RUF31r1bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1sIdjeA1FmB/K3yizHvWezSYIb8CNB+Q6htSm50B3ZTHqPSP0BCC85cjR6NYBQrFciQc+ZFRHysBMsQIMYZnqzalLtjX1h6/HCR9Goqfj2t+DU6uTInc+sZ2cwQ5J/S1bJJ+hoI6TUNvq2bGPPL7YzUrYKNVTdWpakUuvytwyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pL3PD508; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pL3PD508"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7FduBSMLh/i0qPWqlE52G0TkoLVQsc7mFC68GyadH68=; b=pL3PD508RGnMPOGIV511cM0Now
	hJNGm0FuTL3EG4zPLzRJYBtK72IOfB9S80FXg01SR1eXZURzayHITx44Dgx+aWz6MJSbdbrsF45Sv
	jlwv6IpxFQ1WvhT00frLnrS4jLRx9CRS1P/F32Vazqv6bvjrrlAp22YssilGulBKabhCfE9mO/vMZ
	Yf6inw84z1akzhjwJPE5XMVB15SlR0kYkgjJjPD8eoIIuxTMxmHp2178BlnZRxkotMqzbxM1oNT0L
	vYjDhGDkFzzFRW/10SM4+BS32Rie0nk/oX1E6Nlwt04BP0XjNbo76YkSrts3QuCsmBc0Qtb8wkIAL
	bApEr+Fw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tlY8L-00000002iJq-36td;
	Fri, 21 Feb 2025 18:52:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C6DDC30066A; Fri, 21 Feb 2025 19:52:20 +0100 (CET)
Date: Fri, 21 Feb 2025 19:52:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>, Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
Message-ID: <20250221185220.GA7373@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
 <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
 <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
 <772d8ec7-e743-4ea8-8d62-6acd80bdbc20@paulmck-laptop>
 <Z7izasDAOC_Vtaeh@elver.google.com>
 <aa50d616-fdbb-4c68-86ff-82bb57aaa26a@paulmck-laptop>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa50d616-fdbb-4c68-86ff-82bb57aaa26a@paulmck-laptop>

On Fri, Feb 21, 2025 at 10:08:06AM -0800, Paul E. McKenney wrote:

> > ... unfortunately even for shared locks, the compiler does not like
> > re-entrancy yet. It's not yet supported, and to fix that I'd have to go
> > and implement that in Clang first before coming back to this.
> 
> This would be needed for some types of reader-writer locks, and also for
> reference counting, so here is hoping that such support is forthcoming
> sooner rather than later.

Right, so I read the clang documentation for this feature the other day,
and my take away was that this was all really primitive and lots of work
will need to go into making this more capable before we can cover much
of the more interesting things we do in the kernel.

Notably the whole guarded_by member annotations, which are very cool in
concept, are very primitive in practise and will need much extensions.

To that effect, and because this is basically a static analysis pass
with no codegen implications, I would suggest that we keep the whole
feature limited to the very latest clang version for now and don't
bother supporting older versions at all.


