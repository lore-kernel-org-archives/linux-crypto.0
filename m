Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A922094;
	Fri,  7 Feb 2025 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738916924; cv=none; b=rWiGjhDqR+9xpcJYhQzqJYD/8oQX4WWvFwQ40BdXlzc5Z7DnTfwxMpgAz5GMPgvc/4UK1AQvqTmKpds3/w8VhRT1fT8cZ/KYMckPkvPwk/EFr+N4sLOBsLiT9jlVjmxCqD3eHWE8OgCdqskvki2Hw2+LZvAN1BGkM2/eso/KrWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738916924; c=relaxed/simple;
	bh=eOB27PjHevtyLexKfADRWQNAyfxI2DsXB5XW6/MWs00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6CgPeiDyH/SQL3nV5qZslDL3AlTDCxTQQdsYTyu6a51soPkdBFGwK+i2MAFLcj1iXvAm9GVjX4uyGOrHYFc4A3N6plUTowHiN08GzlHedxqEEPoofSiDCyVXeo+EXNp1s5f6CwM2FJlPSTtee+Y2hedf/b72NUl2lJ04zopFuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GWu+vxi0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GWu+vxi0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wzocH2UaJwexS/hhrxFs84p2uFTxUKaRksQr1v8H/HM=; b=GWu+vxi013sXsuiJtLeG4xT7Qg
	rdTiToLjwN31hgOXNlevz9aEIVtr/Y7GRkDGln5AziOWYjM2MES5QmBW6PFTNEgc6dKOb57qkcqW4
	Hp/WyjYV7zrEGAoexKGtIY44WFHWBC5Zl39z0QkF9Us1La8Kush6Qe9bfjoCIL1FA7dYOj/Oly+N2
	MX2q4mTqzYvlb0cW7uG4Mn8k6OlBG8MgsZAAzKK+BkcXfOMEj78ZxlHMOP66faI2EcrdEHkQ3plBH
	velJWDyAtySwRmzBFTDOkn1uCiIUEd/EfZ1Gfxf8jRvzIxrT8OhMZYqnwAjYfMRZ43bqsaHeWSW+F
	qSeEhDxQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgJiz-00000007U1P-0j34;
	Fri, 07 Feb 2025 08:28:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 451BC300310; Fri,  7 Feb 2025 09:28:32 +0100 (CET)
Date: Fri, 7 Feb 2025 09:28:32 +0100
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
Subject: Re: [PATCH RFC 02/24] compiler-capability-analysis: Rename
 __cond_lock() to __cond_acquire()
Message-ID: <20250207082832.GU7145@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-3-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206181711.1902989-3-elver@google.com>

On Thu, Feb 06, 2025 at 07:09:56PM +0100, Marco Elver wrote:
> Just like the pairing of attribute __acquires() with a matching
> function-like macro __acquire(), the attribute __cond_acquires() should
> have a matching function-like macro __cond_acquire().
> 
> To be consistent, rename __cond_lock() to __cond_acquire().

So I hate this __cond_lock() thing we have with a passion. I think it is
one of the very worst annotations possible since it makes a trainwreck
of the trylock code.

It is a major reason why mutex is not annotated with this nonsense.

Also, I think very dim of sparse in general -- I don't think I've ever
managed to get a useful warning from between all the noise it generates.
