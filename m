Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099301DE2BF
	for <linux-crypto@vger.kernel.org>; Fri,  7 Feb 2025 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738920755; cv=none; b=ZZ27gNFMQ125XxQu9iJMMvKyH6lJojEJXsc9lEpW2UBeLtD93mhDNdbtMutP6WfS6KChp3aLxzFMqKiQomLwqRSBiqI5mekA2HbJUzwUJdHzUvlBi+BE/4wCkBrXdge3OMToqDpoDD6gmq0ZGm2ExQGdYo8stObsNfnu3528m+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738920755; c=relaxed/simple;
	bh=U5K/bmzzMNTyixCzS6tI8UaoaljUYYEAWu8cFv9t0pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSNPhjTzU2iG8uIHWMDYtYEop6GlfLQaZVvBlD/do7TAjPBL4IKs0FilV9rnlQtamPoOcOgyJ7CaoEGlhCodZHSXpsd/470HRAIdQ2ivSfx3s+CJz6OKv42R/rdOfsceAyuvqW2SMpmY6XMO8j6SEIGmtra8GHOxtd0K+Fj4HmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bHL6i3cA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bHL6i3cA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-437a92d7b96so18207585e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2025 01:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738920752; x=1739525552; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8aNJoNQ8/KZ3zGcS/1S9RhAv2oCaPXrYb2HHOjsrgw=;
        b=bHL6i3cAT7vabO+bZZtblsPU319t7gHKa4r7TN9mgVIzch3XtAbhmeIM3M8cs+YR1I
         XNoeMT4nNam83PXa/4qxThRK8jXQex+TQZ2BoLLhx/KLbKtbTD9Y6Bj+XmK8/J+U7ay9
         qOUpCMZYgwalRG4+VDZn1eBhCn/+w8u3llRWHVYb0g+Ee5SJuLKdMXFOGa/4e4lOg60Q
         WjJh02y7N+pDiN8WnIj2bVptFTPcYbbFd8coHsCm3cQZhZYVDCUtFkh0/nFBwu2Znk99
         gujzBgckMGRAiWxFMA2udjfXQf1fZHsO3dGEOrDHc+P3aQxjYIMtFvl+VuDgkj9fYmC+
         sA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738920752; x=1739525552;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8aNJoNQ8/KZ3zGcS/1S9RhAv2oCaPXrYb2HHOjsrgw=;
        b=twxnLgIdkZ7p/F99r3Gv4XXuE2A4zcP9/J971vMvsXq7xVbr5MGEqRQHFm0i5bmrN7
         9GaDvQRenH51qQ5GxGcvSAjiCtoS+iZ7WMWV0heFMIOQ5Hf0yHc5p0Tg1iM0TrOU6WYQ
         FdId1eRw6FedMoJATu8a8w5W2KMKY6xaU9Ka7vEKbsVNskrgzsVkkW+Ftq0hnjtWBOTx
         WY8zLozxwy1YVcARjwWXvRK/NgzO2eJNiA7E8RHeG2WuO7Gtz0EqH3nOwV6x9o2hcmp/
         Ur7ZXSQvtaQw0AJvq4ZHsIG/2euXJtbYtudfy6G8Yu+cPL6Ge077fxhdSOz/iMb7Ek+1
         ppJw==
X-Forwarded-Encrypted: i=1; AJvYcCVsdC9/yaHOiE6zICetHBjPDjyYF+i/7m3gxAnK93jeBz8BKHcJaPj3y5q8DkhUnEbozdmk8o7g9jsClUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpdiiTaOT6K2wKhJHl/USNWyQ762MJ6ERiZx55pcVXMp77+8wK
	h4T5kUPRtVyFt/WUvfPRAx4skIjBfplD9DALe22bq/pvhZOz/NOn/TNCoQVV8Q==
X-Gm-Gg: ASbGncuZY8y8a5eWlpGDQx9O5Gfp6nv6+ROOi+jxQLOk/M3ts/9wa0kCttvyqVkSEnv
	OmISuOV6kZX7tBqDe8SdBjZO2749SwLOXUNtwROzNMFRqD2BJLcFDmEJE05p2eePIyqgWYAhl53
	H8dhPbl1yZnVbqvqNg55lUp7ADfCLdEJWyzVh1pzKU6HGsi+8o4oboVMu2X9+h2ZNo5nCeuhzdd
	j/1Tn+I8CsBfTsSlJNXvbAuNo4QkB7GPBYGY/9d8g20d91bVFrVwvoQ8ezn8ovZ0xLdKnumeEuH
	hKJSQCyRL8tQrilh
X-Google-Smtp-Source: AGHT+IFjez7z/oMyp8FZ4MzUt+FHIKHXHPa3EjEklv71c4Z6v/8R41o727c+Gb8EycHsA7aojSutXg==
X-Received: by 2002:a05:600c:19c9:b0:434:a0bf:98ea with SMTP id 5b1f17b1804b1-4392498c08cmr20059475e9.9.1738920752144;
        Fri, 07 Feb 2025 01:32:32 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:9c:201:fad3:ca37:9540:5c99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dfdc1acsm48592775e9.40.2025.02.07.01.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 01:32:31 -0800 (PST)
Date: Fri, 7 Feb 2025 10:32:25 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <Z6XTKTo_LMj9KmbY@elver.google.com>
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-3-elver@google.com>
 <20250207082832.GU7145@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207082832.GU7145@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.12 (2023-09-09)

On Fri, Feb 07, 2025 at 09:28AM +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2025 at 07:09:56PM +0100, Marco Elver wrote:
> > Just like the pairing of attribute __acquires() with a matching
> > function-like macro __acquire(), the attribute __cond_acquires() should
> > have a matching function-like macro __cond_acquire().
> > 
> > To be consistent, rename __cond_lock() to __cond_acquire().
> 
> So I hate this __cond_lock() thing we have with a passion. I think it is
> one of the very worst annotations possible since it makes a trainwreck
> of the trylock code.
> 
> It is a major reason why mutex is not annotated with this nonsense.
> 
> Also, I think very dim of sparse in general -- I don't think I've ever
> managed to get a useful warning from between all the noise it generates.

Happy to reduce the use of __cond_lock(). :-)
Though one problem I found is it's still needed for those complex
statement-expression *_trylock that spinlock.h/rwlock.h has, where we
e.g. have (with my changes):

	#define raw_spin_trylock_irqsave(lock, flags)		\
		__cond_acquire(lock, ({				\
			local_irq_save(flags);			\
			_raw_spin_trylock(lock) ?		\
			1 : ({ local_irq_restore(flags); 0; }); \
		}))

Because there's an inner condition using _raw_spin_trylock() and the
result of _raw_spin_trylock() is no longer directly used in a branch
that also does the unlock, Clang becomes unhappy and complains. I.e.
annotating _raw_spin_trylock with __cond_acquires(1, lock) doesn't work
for this case because it's in a complex statement-expression. The only
way to make it work was to wrap it into a function that has attribute
__cond_acquires(1, lock) which is what I made __cond_lock/acquire do.

For some of the trivial uses, like e.g.

	#define raw_spin_trylock(lock)	__cond_acquire(lock, _raw_spin_trylock(lock))

it's easy enough to remove the outer __cond_lock/acquire if e.g. the
_raw_spin_trylock has the attribute __cond_acquires. I kept these around
for Sparse compatibility, but if we want to get rid of Sparse
compatibility, some of those can be simplified.
