Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639AC1367
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 00:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740096998; cv=none; b=qcAJpp12iGmdIAviF43cHUi8xF2Z3Rz6QJIqD+e7HOXVMOM9GVrxp5/gwT19y2tmY8dW+/Iv9obUPtSq+p7s1JbTrj+JVbVvfv6RIfQd7TrD+t1WahLVdIZX/O/mb1vaA9EkyF79OMFimEJ/xBBvP6S0WL5qebLqCLobjP999OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740096998; c=relaxed/simple;
	bh=5+JG17y1no+XiXasWAV4LNR09aAS3RPd/O1cju1aFmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUGh6UzSxyI8lVvMv0PiYadMXV4ta5Hnd7MsvSENI8ZTUt+gioDhY3zXA2f+ZF3SWonnI98Yz/69mFaFAreDnTSmTXxq5EtzhK8gMCv0/TxLWIhfKixQg7bD5nScOyUQ1d4ViglAbnpncmre+8RvP8Z+RL4/KvieOR6tsZTgXdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJhRzla2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJhRzla2"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220e6028214so34235135ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 16:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740096997; x=1740701797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gOXx46W220E6FZEq/MsCwDe+Yct3ZgJbNWYU+dT6cGI=;
        b=tJhRzla2blHL+NHDdKaLzNy30ya+1ihUk+F8um/vEmP8mt8SbpmfKUw8ej+bGgH7Vi
         gN21PVLbWNVmNdVf6104bvcguGYHEGqdQ9MKqZpkr1Y2iMoybGHJcO3O2qPYJ9nMd9ug
         N6jZ9HxvgL7u3MQh39EJxOVeHmvpr4Q6fUFkwhg56LcOwBzESl163obUcH0BI9sNzmkE
         ZUy6tqiYmpZyeERCK5458tLNFtoS6fwM93+FY056P05B7JmLP7M+IfXn6+vjPNXtIrS9
         i32YqnYVI2HKu++4n+mFkOKok6atsaEoAmzrOj0xkol9IT0ymUNbICDZ5byO6gYjxSFn
         GFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740096997; x=1740701797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOXx46W220E6FZEq/MsCwDe+Yct3ZgJbNWYU+dT6cGI=;
        b=H+fYvzrghD4Vy3kS1IV2g9CdGOm4o+9lmy51u+0/jjqpOluXNfvMWw+VufQgOE9EBW
         uckMiIpZCv/NFTluh3VXXjE2zKFufNYpiFvFNn7pJtaaY56cANZ9+cvQdNg5WypV6SSQ
         d5R3AwflShNzEbvKbhdlEoITlU+KOrqzekyLCimZLZXN+n0gsEVPz0oWpdW3uI0qPDIS
         cy6lPACCs+gbo70HeUwBlqKICDEqGqSGITL0h933T7SwZKk5CeiOHu4e6xa0OxxPV/+I
         pZNJyITg53b4zrLc9IIzTm6Fl67advcy+/lQgPrq88yg+WLEFP/m2ZMe3o0YThS0eSLj
         qnPw==
X-Forwarded-Encrypted: i=1; AJvYcCUwwbowAMbejIU2m9Vf/M7X100RaU8KO7IYjdQM38z9A1+PRZOOTkNfv00I5ZskIfFxM8oPyzc4S0ZF4D0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiZ+OPHW1z8CHv1xhR5zxOz4WSlVOTe0eUxukHl0FetEhMLCRu
	/xsXQfi8g4bMRnnjVfcG8EfeTckXrB8lfAmelqPtkL+ySHKy6SHIWvQmtrfSlayK4t0kB4j50Nj
	i+cSZ41WM5V9awqUybd49XP+ap3yvtJ69VFHK
X-Gm-Gg: ASbGncsz3sOwsq0ZOjN1qcNgOGyN5zb3qB3b9DTiajEeyTUtPIXaqNMfKcNsWrEmb3B
	m/jOwtRTOUhZk54Nq3nZSCsza4CQXzT8Am7btjDenrm4xLGOcfXAJgrlPkaHIbCjazAmxDEcOXS
	m2rReI5QNbxT2/9uPkK79rGSelTU/d
X-Google-Smtp-Source: AGHT+IH300h5TwdZHkn4p/NdY4bFW5MIH3asYrmMXGsx9gCRIlN5VXz6gX2AUHtetV2+tubgqlPwXCwB1TZRnMvVO/A=
X-Received: by 2002:a17:90b:1d83:b0:2fc:3264:3666 with SMTP id
 98e67ed59e1d1-2fce7b221c3mr1828235a91.30.1740096996554; Thu, 20 Feb 2025
 16:16:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com> <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop> <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
In-Reply-To: <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop>
From: Marco Elver <elver@google.com>
Date: Fri, 21 Feb 2025 01:16:00 +0100
X-Gm-Features: AWEUYZmivm5bHZ6EpPSxW_3r18VidjaU61lIM_KUqGThNf6OIvndggmyl3l59og
Message-ID: <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
To: paulmck@kernel.org
Cc: Alexander Potapenko <glider@google.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Feb 2025 at 23:36, Paul E. McKenney <paulmck@kernel.org> wrote:
[...]
> Suppose that one function walks an RCU-protected list, calling some
> function from some other subsystem on each element.  Suppose that each
> element has another RCU protected list.
>
> It would be good if the two subsystems could just choose their desired
> flavor of RCU reader, without having to know about each other.

That's what I figured might be the case - thanks for clarifying.

> > Another problem was that if we want to indicate that "RCU" read lock
> > is held, then we should just be able to write
> > "__must_hold_shared(RCU)", and it shouldn't matter if rcu_read_lock()
> > or rcu_read_lock_bh() was used. Previously each of them acquired their
> > own capability "RCU" and "RCU_BH" respectively. But rather, we're
> > dealing with one acquiring a superset of the other, and expressing
> > that is also what I attempted to solve.
> > Let me rethink this...
>
> Would it work to have just one sort of RCU reader, relying on a separate
> BH-disable capability for the additional semantics of rcu_read_lock_bh()?

That's what I've tried with this patch (rcu_read_lock_bh() also
acquires "RCU", on top of "RCU_BH"). I need to add a re-entrancy test,
and make sure it doesn't complain about that. At a later stage we
might also want to add more general "BH" and "IRQ" capabilities to
denote they're disabled when held, but that'd overcomplicate the first
version of this series.

Thanks,
-- Marco
