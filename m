Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF6C30EF6A
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 10:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765535912; cv=none; b=IDP0KOHn4velUb2GMwNXSbHd8+RnHd1YRrOPToWMWgoi8AD5WE2ogHBZfAathnvEQBV9vLniSdVNfGbtVVWMqizhBRhtxYhkbV7j655OR11cx7KelhDSjHIv45s+xY7eY2GAeBIFnjH+ZODhHSwskre16vc+gKexWkm7WlpPsD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765535912; c=relaxed/simple;
	bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMcWALfm/s1SN+cgIuUO63eWE3Q+t8rHCvi15zjWeI15ltJib99TONld/3NhAQcIzrff18TZMLxFfAn5lz4og8fslFHf6MBrbeZP5yuXqMg9AWgVdF24SnB9IIUuBao+Z5daoXgfbG9XUx+fWZ7LrK9/HXuD7Ro3MmYfTLh30CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZWBV45nA; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZWBV45nA"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-349bb6f9c86so1469721a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 02:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765535910; x=1766140710; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
        b=ZWBV45nAwslwXNgSHG024c/Oy1RmaBreP/JPthjPK6Jn3HbrFhY/wFxrZTcGlUl/y1
         IS6CYLqUB1OtkjBoyRT7ra/01FbS2V1xFEGhQDGLun2iMirwgFf/D/bJ5Y3H6aKsjHJm
         bxk7aQuwkLRdpQ+JQgvYpMrvbsNQSQ91mBr94ywIb5UfQAUGOo75ot/0ykpD1NCrivgb
         Fsd/G8OtIM18F+PuPayPs4TkVif9WU0Mn5tXO6rLkdQ9bvpbkl+pVoGuSF9m8Z6obSID
         +7sWGc4mEzKG3LIAhrR0ynh93NV6ssWdE3dJW6XZLRzv4RvHHFFoIPDwwHs5uHOaPCzu
         Q9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765535910; x=1766140710;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nctQCqtW4QYyeaejz8PEb38w/v2g7uc6tb41WntjKNI=;
        b=RvHIFL4otzZcHFKTguhstc9tg8p756mmAPgX2/7oAi+C3CpaQly/1mftP/djb63DX5
         qmaC8vwjh0jU6jWY5yXEZ2nqEa4XZ3HID7PoNxVPjW0qvuPE16USCKQgZOBqjKM5nmMB
         y3TlWrQx8o77ZQjg0tNQbOM1JvFlhbA2Z0Rwz9m06cNZ65BFQ02t/iu03R8gdclB2b3G
         d5xJeNh/fz5TaD7+SV+QjU3u/Jg1xPs7vaOooafSR33KmN6rh+lS8f2CxY5SyMWdoJi+
         V8U0ebid2Ejn7ahfYSzJ18jP2W109XFHFR56baXpKcmVTWmcj0wHv2AthCRbeK2EOuPS
         5SAw==
X-Forwarded-Encrypted: i=1; AJvYcCXNEfSNsziqRwIu81j8uwvoJl99w5/FGQtFCJ7Wu/zvBpNpnTWP1GhaI7ArK6XnGtgtEtf6D0Awwzlvtkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjVToRyCxqmx2LRUtGXLx8LGWrxG//6t0wXBwArYwGGKi0H/xD
	RgGXJYHIQffWVjiwOtdfQaf5zIwRhwC6SynOlz+08j4+X5X1mvjgm7lPiRJuN/KgLnakxIVm4NO
	1zXXhl0JEk5DDaRnmV0SUEc3Hn1aMhdVG+iRmFQg5
X-Gm-Gg: AY/fxX50773vcgEYJUvpGt5IOajoX5IWHL26LB6sx8wpHvhU8eCjq05Ocp0sN5m2nr7
	7z+xC0eCVq2JDFNSf+Ic7oJsgmSavE/rMU2gd8Pt5lkhS0Fs/YSk7mCnFKDim16zetaZaSQOtNC
	3m/+d7jiw/Hw2bVl5GDjNNk9bR7dDkDaH/8Bs4uz6qStV3CMxvrgeAlMtrU3z9IzbFdtynI8TDD
	5Q+AY6mEifMja1NhYxaZY0vzp8y5nKhIj96d0x8870H2ytbrZm49nDUtluGSjtaijZbLxPYXCqk
	3MWaXcUWGNivzUbXt3PQd3MjlCc=
X-Google-Smtp-Source: AGHT+IHEQqbAgYefprbsSuiVLt7KDiCECxoW496oPYm+Bj8DbPCCV7ccSZXk9zoE7kqarbEHot35Mb+a9uphNkvnkwk=
X-Received: by 2002:a05:701b:2719:b0:11d:c86c:652e with SMTP id
 a92af1059eb24-11f34ac540dmr1125346c88.5.1765535910093; Fri, 12 Dec 2025
 02:38:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120145835.3833031-4-elver@google.com>
 <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOyDW7-G5Op5nw722ecPEv=Ys5TPbJnVBB1_WGiM2LeWQ@mail.gmail.com> <20251212093149.GJ3911114@noisy.programming.kicks-ass.net>
In-Reply-To: <20251212093149.GJ3911114@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 12 Dec 2025 11:37:51 +0100
X-Gm-Features: AQt7F2qnWyV-H6zf6AeMnZTuFb_nb7UwLLraoghpFqSJ0q6RecRlENqaq0woPuo
Message-ID: <CANpmjNPcw5AnpLpaFvyRee7mH12Ym-NKTx331xXEusK5zpiscA@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
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

On Fri, 12 Dec 2025 at 10:32, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Dec 11, 2025 at 02:12:19PM +0100, Marco Elver wrote:
>
> > What's a better name?
>
> That must be the hardest question in programming; screw this P-vs-NP
> debate :-)
>
> > context_lock_struct -> and call it "context lock" rather than "context
> > guard"; it might work also for things like RCU, PREEMPT, BH, etc. that
> > aren't normal "locks", but could claim they are "context locks".
> >
> > context_handle_struct -> "context handle" ...
>
> Both work for me I suppose, although I think I have a slight preference
> to the former: 'context_lock_struct'.
>
> One other possibility is wrapping things like so:
>
> #define define_context_struct(name) ... // the big thing
>
> #define define_lock_struct(name) define_context_struct(name)

Note that 'context_lock_struct' (assuming that's the new name) can be
used to just forward declare structs, too, so 'define' in the name is
probably incorrect. And to avoid more levels of indirection I'd just
stick with one name; if 'context_lock_struct' isn't too offensive to
anyone, that'd be the name for the next version.

Thanks,
-- Marco
