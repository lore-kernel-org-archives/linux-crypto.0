Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF5018BC1D;
	Fri,  7 Feb 2025 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738917124; cv=none; b=UEbYOGi6CHj/4XrhDW0db5hsp0tbsdUiv6PtOIZK7B+U+c/IDGQXxhRpS2hBZzCWxhAfFIxybEuk1eKfmzce0JUAlhU53kCE9zSAQJaheSQ8uHCi2Ec8/vDtWlSD7eXhpkR2FO9iUfYDIVt0Q8m5lrlpo0UkL63qL4Sit6knsmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738917124; c=relaxed/simple;
	bh=eeSINdtBrvPrjbWTpeaZBr86AvE1msJUnn6egUQhP9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pobp3WciKtQMajHmGk36HlU22AO0zqOoR8LrO4sNNYOBcTXevOKPjqjHahq+Ua1h94/XaJSk2jNNPaeghYWfdTAu1cRebEY9RZx399Y8sbuDRGrzfSEVnXXVsWRUaxKg8qOZ3LaMHDsof/njBFR7w8MbVB1Qosd8t3K+Rscnapo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n1aF/WV1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n1aF/WV1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MToFBoTN88Sw05TH5ZS066HLD3eJYQXco+AkkB2Qigk=; b=n1aF/WV1DDdRxaIXJUvr5MNqUK
	ifPIG3chJ0TLLOH62d9qj1v0lIBf+1MDvYz+tb9h7VwPWH3bWvGKqyGpVaweiMsJ0h2O5pTeUZkdk
	bKoQGNxthlrkH2htARmUYq5TuJM+m0h1eS0k5QZEHcF0YgBFW6PegATEF1BQyrF6ZgW8CJrV+spOS
	4bvaoq2YwNuIHbK6vKm6NIGgKkS4UKjAC7imF91I3fgPjh58wHl8Zp3Z0eHpJE2+oigZ+Kw2tjKgR
	TUV4Cqm3ICzRGmQPDoyzOaTKPJRk4WPnc085QqcR7VeSeTs59m+RFKzDkwEYHUc+pt4l+r41wQrum
	1ogE9ihA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tgJlg-0000000H8yt-07vH;
	Fri, 07 Feb 2025 08:31:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 7B47E300310; Fri,  7 Feb 2025 09:31:19 +0100 (CET)
Date: Fri, 7 Feb 2025 09:31:19 +0100
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
Subject: Re: [PATCH RFC 11/24] locking/mutex: Support Clang's capability
 analysis
Message-ID: <20250207083119.GV7145@noisy.programming.kicks-ass.net>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-12-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206181711.1902989-12-elver@google.com>

On Thu, Feb 06, 2025 at 07:10:05PM +0100, Marco Elver wrote:

>  extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
> +					unsigned int subclass) __cond_acquires(0, lock);
>  extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
> +					unsigned int subclass) __cond_acquires(0, lock);

> +extern int __must_check mutex_lock_interruptible(struct mutex *lock) __cond_acquires(0, lock);
> +extern int __must_check mutex_lock_killable(struct mutex *lock) __cond_acquires(0, lock);

> +extern int mutex_trylock(struct mutex *lock) __cond_acquires(1, lock);

> +extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_acquires(1, lock);

So this form is *MUCH* saner than what we currently have.

Can we please fix up all the existing __cond_lock() code too?
