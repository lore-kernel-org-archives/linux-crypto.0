Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A4E1FC7E6
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167244; cv=none; b=KDiDTWPnfOEykH5bTSuvDsMPukg5Q7615AYOqXvncw1DAgln/aTXbYPHUB9Rt/FjBnrYCxnP8VBR3Cim0qNbNFTDUBsup+Dz1mGZDu46/hhzs26dN44e26Lt9GMkNHziNJ0ZXA8bjDApRf8IKxWBjB6xSochcah/sJSa2Vc3E8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167244; c=relaxed/simple;
	bh=ncoDsRKjh28vVH6GzAvugCMHO3v1MHxTwR6FKJOs+vU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBrQ4CYRvshivktVwMqNvS0wlejoWaTwFjGfgIxf6o9nOs2n08CC00S098fI8p8dZjGcR0zwo8BZB5h+5RxNPiEs1mX2PRrQru6IBb6Vxhb8RnSRD0KkrzRh7oExhVm9NKh3muwwOV0mk1xotMn336MFE054cA1hL00TQJSowK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rlw3cuGI; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rlw3cuGI"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fcce9bb0ecso4893962a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 11:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740167242; x=1740772042; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ncoDsRKjh28vVH6GzAvugCMHO3v1MHxTwR6FKJOs+vU=;
        b=Rlw3cuGIAxcg3WfnonzHELaqFki5MHtrG88b+PJaqXoftFWAZOw1iwZ7B1dfoO28lE
         cgOxQhBbPToKTYZs3SAS2fpr/CNVn2uKrY1+gYr7U9B87SQeqLulqBAGHMFnScG529Io
         J1afxgCpTtyCRUNAGoytzPI8L+xOVLjOZuTFUUMBeeZ0GWjqlEGww6XN2usVQ/obfe7s
         aF7KhEyDbzze8qpQOk1Pnh3cmgcvUS6vvk2GQW9xfM9dhI3T7rxZoCyoAAdjyddnwUBB
         WvzZVn/qykY8G9mwQKVo1B0YjmbP2Q1hQb4b/EccXjSfF+7eF3Jib9Hl4/RFrELxYXAd
         htZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740167242; x=1740772042;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ncoDsRKjh28vVH6GzAvugCMHO3v1MHxTwR6FKJOs+vU=;
        b=pmmkv+WQ3BXE32lIndx/wfkuTy93PeqERifixibKcNqYCJUhiIbL9NYP4Z2SGVBBwN
         /WbbW3/ykxtxAW7ye/Gif6J2Al8BTpRF9FnxzptsNaSvc2m9CcW/y884qET0ZGDOxk/H
         0DUj1DNPTeiLdP7G+lSYXSYlOo4rB9JVHgQu08PnCH1lnI169sk7XNG+wAXeTGZBxSgz
         SZt6AxdBF2BPiNeOxS4DsIyLDax5XrRpJqYIj2SOo4/HfhjaD8EnjN5uruHZ181PMLxq
         7c9c2Puse3mR3tZdcZ+CDNI2T+TbquECkkXN/oC196oObfycz4Am/xj4eQz8eN2w6wL0
         WKyA==
X-Forwarded-Encrypted: i=1; AJvYcCV+pngO9WVhV9bZjQ9IiYlz5dGbpNhxyRiKpfMNRdx2TAqIOliJSHUn/l12qrbnleMtVgdBKqwFuORhXRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+dzFwCylg1eykW5fp5xVrY0e5u/wdQriOTfxBAckAeXCzKbBM
	NfDXIpSXi7QSeH5eJ3qMBxhETDfKE3JxXEdzSiWir50UXIdgKge8/RAPIZHR8A38F7CA9JBuIXu
	cWldRZdO1ut3We17AxNjg7LZSbTtCnOWGvXml
X-Gm-Gg: ASbGncsq9CFUqJjOPT2fU/mV2MhqxZcLrJ286sBPO5bVCmy4gw6nwyLLrT2UH+eKcH/
	nKB+tZbreU6dH2JkZ7ZM+5Jf2+6rmZgJTISbtOpwWovRhGHiE5kzHlcePev5r8Q8K2fyZoBzjHM
	CELU/pqbE7avCD+Xsf9fWZSy0olb8WTTrFHLFe2rQ=
X-Google-Smtp-Source: AGHT+IGtec9D57fNEpwTOF5VC56kG+DMvBkePfQGlMMOOM8lBQqp82lJKRrsNscMiVitOb/6ZYzBRGWC+K08kh5F0Y8=
X-Received: by 2002:a17:90b:2252:b0:2ee:9b2c:3253 with SMTP id
 98e67ed59e1d1-2fce7b26274mr7182179a91.30.1740167242446; Fri, 21 Feb 2025
 11:47:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com> <20250206181711.1902989-16-elver@google.com>
 <a1483cb1-13a5-4d6e-87b0-fda5f66b0817@paulmck-laptop> <CANpmjNOPiZ=h69V207AfcvWOB=Q+6QWzBKoKk1qTPVdfKsDQDw@mail.gmail.com>
 <3f255ebb-80ca-4073-9d15-fa814d0d7528@paulmck-laptop> <CANpmjNNHTg+uLOe-LaT-5OFP+bHaNxnKUskXqVricTbAppm-Dw@mail.gmail.com>
 <772d8ec7-e743-4ea8-8d62-6acd80bdbc20@paulmck-laptop> <Z7izasDAOC_Vtaeh@elver.google.com>
 <aa50d616-fdbb-4c68-86ff-82bb57aaa26a@paulmck-laptop> <20250221185220.GA7373@noisy.programming.kicks-ass.net>
In-Reply-To: <20250221185220.GA7373@noisy.programming.kicks-ass.net>
From: Marco Elver <elver@google.com>
Date: Fri, 21 Feb 2025 20:46:45 +0100
X-Gm-Features: AWEUYZkA99crBxIegh1gRRcMrAoKxxzyxwRGmWJRS2whchm4-Eofmj8EM7dMgko
Message-ID: <CANpmjNOreC6EqOntBEOAVZJ5QuSnftoa0bc7mopeMt76Bzs1Ag@mail.gmail.com>
Subject: Re: [PATCH RFC 15/24] rcu: Support Clang's capability analysis
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Feb 2025 at 19:52, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Feb 21, 2025 at 10:08:06AM -0800, Paul E. McKenney wrote:
>
> > > ... unfortunately even for shared locks, the compiler does not like
> > > re-entrancy yet. It's not yet supported, and to fix that I'd have to go
> > > and implement that in Clang first before coming back to this.
> >
> > This would be needed for some types of reader-writer locks, and also for
> > reference counting, so here is hoping that such support is forthcoming
> > sooner rather than later.
>
> Right, so I read the clang documentation for this feature the other day,
> and my take away was that this was all really primitive and lots of work
> will need to go into making this more capable before we can cover much
> of the more interesting things we do in the kernel.
>
> Notably the whole guarded_by member annotations, which are very cool in
> concept, are very primitive in practise and will need much extensions.

I have one extension in flight:
https://github.com/llvm/llvm-project/pull/127396 - it'll improve
coverage for pointer passing of guarded_by members.

Anything else you see as urgent? Re-entrant locks support a deal breaker?

But yes, a lot of complex locking patterns will not easily be
expressible right away.

> To that effect, and because this is basically a static analysis pass
> with no codegen implications, I would suggest that we keep the whole
> feature limited to the very latest clang version for now and don't
> bother supporting older versions at all.

Along those lines, in an upcoming v2, I'm planning to bump it up to
Clang 20+ because that version introduced a reasonable way to ignore
warnings in not-yet-annotated headers:
https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/commit/?h=cap-analysis/dev&id=2432a39eae8197f5058c578430bd1906c18480c3
