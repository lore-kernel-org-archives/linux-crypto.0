Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EC22356C9;
	Tue,  4 Mar 2025 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102165; cv=none; b=KWq7yZt/t1HPbviqWvBXti4GQG/7JGTkERWqwXi09jl5zVfkzFIC37rOVuz5rmfiHyriULFgRyv3+cSk9zONw6TmtF4z+q72RMLLCuj319AqtdxoC8ev0w1uxY7r4lV9pwVCnWDpaRMV6IGM7kE8C/Xb9KgKgePxCVY2d4xWR2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102165; c=relaxed/simple;
	bh=vqeB9SrNqzQ09LSrU5OcmZtpCdJ+dHGgTXQ7UhOc/dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhqvUaADZNIaqUq9i/s5LNXCgiDYAHA0+09d/WqXhbhd9kQGm+iP+vdt2nVxp9dKueMU1h91StQz0gTm51zadedma/xVbRPGOWYLVq0lq8NXvzAIl5xFxQh5l7TciRhX5W52+sY1cEqwklhbjMR3QS/9qEMSAjs1JJVE/cT/Hlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1W5CazB; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1W5CazB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EwH5tL2R1Nh04CIVB45yHJPEmwvHf497lkyWPZPvBAk=; b=W1W5CazB8j4q0EfGur/vmxU19O
	eEoNwKx6EAg72UeTKnxPaU9ZtjpCwyh9lIjGDsQf0rV1pgrRwUF1HYtHxEjrPXnHYkGOUJNS7EXxR
	1m7AZvOzW4Sw5h0lFssqklz8fS3BTVoqXH38JNwRoof43KdPhl890cCl2gL4g6ENZPIEpt0jRuvf5
	eSagUChSacvZLdi4xgEyu0YwV01kKiDNu9WgIhghhjKFj15zNQj3Ouv7XnuaFcEaJ07gR6lLB4Kl6
	gX/DZJYtbhcjsSsO0+pDLrZp4MKb8Vfgjd5pIcrzneGsTQtdvDe8uv2Zccy9jhPumr3FLZkb2pUCh
	JI6hpqFw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tpUCk-0000000048f-3L3R;
	Tue, 04 Mar 2025 15:29:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D7DFC30049D; Tue,  4 Mar 2025 16:29:09 +0100 (CET)
Date: Tue, 4 Mar 2025 16:29:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
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
Subject: Re: [PATCH v2 02/34] compiler-capability-analysis: Add
 infrastructure for Clang's capability analysis
Message-ID: <20250304152909.GH11590@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-3-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-3-elver@google.com>

On Tue, Mar 04, 2025 at 10:21:01AM +0100, Marco Elver wrote:

> +# define __asserts_cap(var)			__attribute__((assert_capability(var)))
> +# define __asserts_shared_cap(var)		__attribute__((assert_shared_capability(var)))

> +	static __always_inline void __assert_cap(const struct name *var)				\
> +		__attribute__((overloadable)) __asserts_cap(var) { }					\
> +	static __always_inline void __assert_shared_cap(const struct name *var)				\
> +		__attribute__((overloadable)) __asserts_shared_cap(var) { }				\

Since this does not in fact check -- that's __must_hold(), I would
suggest renaming these like s/assert/assume/.

