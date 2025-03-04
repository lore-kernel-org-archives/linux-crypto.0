Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318D25333B;
	Tue,  4 Mar 2025 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741098652; cv=none; b=J7V8ZHmPlGBs9XHiX9X7Q0Y21YmW/CAxEWGPy8QM2ErPHj+j1FY8n9idCKIXp5juZD6k6+TwQ1r38M2YaMnRvYww7dt3BL96favdJiJ/3dr4FsY1tMwA9jvCPl+QYrPsMT5FJqRXZRje0MYf3SaBYoPNjAzb0cFOcIJRkc0Sq4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741098652; c=relaxed/simple;
	bh=9VvfiKn9vnthqkbug7Ck5fZJaYFPZHMHw0rvMhQVYiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwNwMnyaYAJJGIlqSKfwxFsf7AdYWSoXESAQ+h8vtOS6QjJCo4F9v0sNyBhk3T5rsfA6znhhTGqwvDKFwSXJ24igMQF58bCaVr97oJrJGQa8pxDrqoIRSL0E51CBkmiRe89jEc3w5wIn+ajQYTIhh8r/Yo88pyspTbMrHsb2tXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O6A3Q3iA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O6A3Q3iA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9VvfiKn9vnthqkbug7Ck5fZJaYFPZHMHw0rvMhQVYiM=; b=O6A3Q3iA+uzXiB6Q0PMcUMDxQo
	XV+JY16vUmBfQmM2B+uRgLmqShMA3uh6f8JFrnV+XiI7bR2TZgptt7gbyiuWUSQAvRx2p701xzj3d
	kZ3++SZNDrzZNFhKzXnk8E8UxzGcTbP9HBoJjjlTThSUrLtUz6cPNxCnSW/e2VEJnUtvRXswD3nKe
	NqJ9geRKxEURnQoRKQ82se5REGKKm/jP7sEhZpocyT93TcRZ9k64JTSpk/iNVbGnBPCkLsWQNRCIv
	cz79tS8cXsg7goeZ8BZOfjYYeOnt5avSRu753nrk6ShXxKlRllZJxs/2Z2EUmvGXQptvg2i3DTdeV
	za4evRtA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tpTHx-0000000037U-3a7E;
	Tue, 04 Mar 2025 14:30:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5D27A30049D; Tue,  4 Mar 2025 15:30:29 +0100 (CET)
Date: Tue, 4 Mar 2025 15:30:29 +0100
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
Subject: Re: [PATCH v2 08/34] locking/rwlock, spinlock: Support Clang's
 capability analysis
Message-ID: <20250304143029.GG11590@noisy.programming.kicks-ass.net>
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-9-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304092417.2873893-9-elver@google.com>

On Tue, Mar 04, 2025 at 10:21:07AM +0100, Marco Elver wrote:

> To avoid warnings in constructors, the initialization functions mark a
> capability as acquired when initialized before guarded variables.

Right, took me a bit, but OMG that's a horrific hack :-)

