Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDAD250BF6;
	Fri, 21 Feb 2025 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167846; cv=none; b=ty0tXuFg8kf0ip1zHY0XZjjr5qHIIG1pkHZ2sMJxNsY8mDcael7GuVG8x/KLMmuZiCb5vrHPxqVHIsW4xEdUJ8a17ZO/UL6hmeXkFhAlzci3xc07n2dZ4TD9+pxtrgegnBCQBOEcAIFayj8vuaRLXyfGRCOnztxYYcJtANxMlnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167846; c=relaxed/simple;
	bh=hL9ZIhAp39JgGtPt+XHHRB4UdgOeBbU7cs9PT+4BMkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ9b0BW8HHbpMplSPkg/6m0J266Rzi402REaSwOcuJO2aRx/E41CmJITPEhMpc8THXM3GN5X0mRBh5PgjMkAMQl9ilh/XQ+FR99Hh2tv3LzDzq3RZNnL8TzYhI7dsVwK/H486GlQYZHeze+I/BfDT/3BLb2gDDQ5J9B2ahVIo4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SWBFReg0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SWBFReg0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hL9ZIhAp39JgGtPt+XHHRB4UdgOeBbU7cs9PT+4BMkc=; b=SWBFReg0sTydDxWqutWzxPGrwu
	NCNVu3eNqj4Wt32yqzHXNXYFq/dyOvrIqMmx44qGbwLyeQjR2PiHTvWcoK78xp3M3gO4sngFAoY4b
	bhz8pezCZQ/FJZVr1Dfyv0Xqz0aUAEFM8f1T4xTF59hDfzdDFRBQR4XOHEM4NJWYhAM1JlKpM+jkY
	/LyjZAzTtQ5xy+u8UuzTbqQNAvW3R457uwsDz8neQExG1oIzKAwOTTeUjOQYj40xQkX4o4qm6iUKv
	k6N9ywqwLf4oA5kqSN0cGZdINzvC1l3Kh+v38htfNQKSGlOPsClxI4Xm6LW1YBxkMj0bnuzJq/k67
	MbwoCBXw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tlZ96-0000000Ew9O-2QH2;
	Fri, 21 Feb 2025 19:57:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C10D730066A; Fri, 21 Feb 2025 20:57:11 +0100 (CET)
Date: Fri, 21 Feb 2025 20:57:11 +0100
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
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
Message-ID: <20250221195711.GG7373@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop>
 <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
 <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
 <772d8ec7-e743-4ea8-8d62-6acd80bdbc20@paulmck-laptop>
 <Z7izasDAOC_Vtaeh@elver.google.com>
 <aa50d616-fdbb-4c68-86ff-82bb57aaa26a@paulmck-laptop>
 <20250221185220.GA7373@noisy.programming.kicks-ass.net>
 <CANpmjNOreC6EqOntBEOAVZJ5QuSnftoa0bc7mopeMt76Bzs1Ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOreC6EqOntBEOAVZJ5QuSnftoa0bc7mopeMt76Bzs1Ag@mail.gmail.com>

On Fri, Feb 21, 2025 at 08:46:45PM +0100, Marco Elver wrote:

> Anything else you see as urgent? Re-entrant locks support a deal breaker?

Most actual locks are not recursive -- RCU being the big exception here.

As to this being deal breakers, I don't think so. We should just start
with the bits we can do and chip away at stuff. Raise the LLVM version
requirement every time new stuff gets added.

