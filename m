Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889F83191B9
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 10:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765536550; cv=none; b=tV9YQ2wYa1ni3QN324cCoMbkuw2jcG3ov3sp81ZR/LsTom843BhD7onLtwn3Te8zq+bf4CUxsU+r29W4MQ2e5Fye1DvfZPaR/zExdEVOtWfOXEEavIVSxpsXQHv+5BMuX/mUSb4Bx9dD+itF51zGYUXSRll8chb+CK8mNB9/aTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765536550; c=relaxed/simple;
	bh=av9hKN2hbVjrZk+A7S1PV353SLAqNrjc7QnZ5XIVFLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cf9d6QjchQ/EwTf4FT4C9JDHpS2sMXRTyH0uyMqEnfMSTm55dpgT87EeVo3/pVmXXqTlPHCvIN1qu1okPcGBcjwjskgrjEZmapcp9NaDlLtwagITuH60im/ppHj6SRqBPqWVcWPPQufN8NpPqKJyMI7ZLLmNjiabR0VU0BI6pso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thRUkRx0; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thRUkRx0"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bfe88eeaa65so744884a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 02:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765536548; x=1766141348; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SA48npp6esm0XDSNny8uE3VVilMK0KzCGLSxi6mYbKY=;
        b=thRUkRx0uXjqWLwLYTxYGwAZyyoDS3T9uB/c4Lz5Qa3InFtQsgHEoLl52TEwSpTLlP
         uRjzZVhgD0M/asCP3+KcbDWNG7KdhW3NC+KLHM+GW6wJnhpqVD4ggvKDkNMZXnjTX/HR
         os9eyPjV4jWYDL5KB6YOGe614ciEIhrjEeI2xIpR4UihZuhvrYTjS8Wwu9mb8AFZXQ9v
         t5GJNx8PYH4Dr6v9xIYzLZLYtzEJLpMdKOpeFbVQc7NzAQ1ep/a3bmczB3HrJqFBuA9r
         Wz6B8HSizDzGuTzA56W8X40Zdw5ntj/g0B6LheZVQMfcAQVXjB3X3WrxRApQQrYax4Yn
         FJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765536548; x=1766141348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SA48npp6esm0XDSNny8uE3VVilMK0KzCGLSxi6mYbKY=;
        b=NMRMEWPIcsIE/iaN3b8XsGfXdb/JPsgViloXYYOLuro38u9iGB+7Agoxn5J58Jgqxz
         zk9tvtI1S4NPGH9ffJ0eAD1Q/z6m0GXg7YMtE2psQ6ET9vc5FjZLlj6IZSD+1Z2pUC0n
         y0Nq0hOYKlTCi6DYo+Mnbun7EmeLhM9Hzn6fisevASt0w4PAcyhM6nKpxYucLbnIijbw
         IokbDN2e2BdQQRFBxf93Ajl5HCsCuiud9cge+u5KXMNbgxemsx7uMUEULbszcokRTZy5
         YVnaC0QZl6636VsMNRXakX8WzOMSZP/toXRvM6hIczDNsh9FyfwwuEqnPkFiry9or92+
         zCPg==
X-Forwarded-Encrypted: i=1; AJvYcCWncYojE2NR86O2GenrblH+lM2plJv9s9CfOZvMOSZy//tlk9UcYWnDFG7kA8VRMgp0adU2JYIWXG8tPIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWGIUTI3JRtyYNVj46OIgqE3ztyuyk/8FyF9Uhnvj1aNeMrIqz
	z0LjDB5Rb/LVIuvVUuwbK3Iy0hQddIvklcqF1jCDu6w3zEX5NS2tKLnFNhbaT9s91pNF7z6dgE4
	nQ4//xWfsQ6LyYnnjlCR78sBHAcPdy6m58Ct7bcLn
X-Gm-Gg: AY/fxX7axTFx1yqN2NiaJa5Z4KTLKapzONQQ0c/UxOKbeEyDRqasiOlEKdj73JbSap1
	QVcxn7pKsXZwVOuSnQ7hh8VFwiPk+VpcZfAEI3PbJEk5DyvwZ7FmsWGjpjf+RiToEOcO4c1ZYTV
	lSG70VF3c2cLa7YgOi9WEgDJlMwNmiuXLjFCsGzCNWtbfvWUzOncp5Y5zjxVV2Qg95awA+4o6gx
	dvihBW4Es7L6a5eJJqauthl8xBjklhgYZyM7tfrrNb6n09Ek3FKvATqk22vTBG1TJyjitR442KP
	cLuuRmctP/eKf7A2ReFGAZu9IOA=
X-Google-Smtp-Source: AGHT+IEmwt/cYGSRMcLEQwRoz4IOBPZmG6ZdFUXvSQgttHHtD3I/ZoiZY45lTyY+63ShMc7m2jk9oXMIHs1yDaFc4yU=
X-Received: by 2002:a05:7301:6781:b0:2ac:2e93:29bf with SMTP id
 5a478bee46e88-2ac300f946dmr1219192eec.22.1765536547134; Fri, 12 Dec 2025
 02:49:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-8-elver@google.com> <20251211114302.GC3911114@noisy.programming.kicks-ass.net>
 <CANpmjNObaGarY1_niCkgEXMNm2bLAVwKwQsLVYekE=Ce6y3ehQ@mail.gmail.com> <20251212095943.GM3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251212095943.GM3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 12 Dec 2025 11:48:29 +0100
X-Gm-Features: AQt7F2qCLUKQusRsTOkfVyHaXl__KgFtQ_SoVZmDpwKuRXcKmzXhASdee3aZVrU
Message-ID: <CANpmjNMY55ytuWPh15O-tTe5zEQx3AN6LqrvB9NJ6dm6BsPnsA@mail.gmail.com>
Subject: Re: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for context analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, 
	Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Chris Li <sparse@chrisli.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Dumazet <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Johannes Berg <johannes.berg@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Dec 2025 at 10:59, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Dec 11, 2025 at 02:24:57PM +0100, Marco Elver wrote:
>
> > > It is *NOT* (as the clang naming suggests) an assertion of holding the
> > > lock (which is requires_ctx), but rather an annotation that forces the
> > > ctx to be considered held.
> >
> > Noted. I'll add some appropriate wording above the
> > __assumes_ctx_guard() attribute, so this is not lost in the commit
> > logs.
>
> On IRC you stated:
>
> <melver> peterz: 'assume' just forces the compiler to think something is
>   held, whether or not it is then becomes the programmer's problem. we
>   need it in 2 places at least: for the runtime assertions (to help
>   patterns beyond the compiler's static reasoning abilities), and for
>   initialization (so we can access guarded variables right after
>   initialization; nobody should hold the lock yet)
>
> I'm really not much a fan of that init hack either ;-)
>
> Once we get the scope crap working sanely, I would much rather we move
> to something like:
>
>         scoped_guard (spinlock_init, &foo->lock) {
>                 // init foo fields
>         }
>
> or perhaps:
>
>         guard(mutex_init)(&bar->lock);
>         // init until end of current scope
>
> Where this latter form is very similar to the current semantics where
> mutex_init() will implicitly 'leak' the holding of the lock. But the
> former gives more control where we need it.

I like it. It would also more clearly denote where initialization
start+ends if not confined to a dedicated function.
