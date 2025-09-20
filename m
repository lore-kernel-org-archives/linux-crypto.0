Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674E17AE1D
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758372331; cv=none; b=b3oiBNID4WNJHiAd3H+1xMubMrfUF3NMfkCVoKVXA/xz/AVInCvYJupXpwId/Ne5wMUI63E3rl12dioyQh4lCXDNXolGxDT3w7RXCdzxfDjTg/hbABRShH33JSRi33PmPJPbu+QSHopJrV6SLycNptU49Rsl0iPmX+kuMYrtQcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758372331; c=relaxed/simple;
	bh=B2pdUGVo1hxX37az6KU5TDG01liBl6FvTa355/7VdK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rFgEiJTQkVqnHYbR9bd6OJEF6agLE4xVRBpzYKYIW6q3SIoxea6PjxArv3yqxXRCQ1dE7waVBmysWAHsqT6OZweXu8E8jZiJreBJ+7+25DyNhwkI1XaCJtqKKIg8tFTUmi3RI1uKshalByrmgJ2UZrRgFMMWuUg5ncJPXrVDnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBkC6o/x; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBkC6o/x"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2681660d604so27805815ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 05:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758372329; x=1758977129; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P2Xt5dxImFQDNB+zIOSzEq8xo9rsZmb+jmetH2dJjzs=;
        b=UBkC6o/xEMnutMrAvFhSCg3+/b6YUIt/IIkPi91Mmf1EIvbALnnziFHl6XT5dCqGoE
         TYPO4w1IlqTbNzNMbFJY0x102FE/zza2OmJxDWZO1w7/4wjpDO2YTtgA0F9ZdWKRi3js
         ek81yuj96OBUi8jYkJ4am8Uwqa48PbVWopzu+1dtQVRWQ/r/tQoMoSRQWz3CaRDDxg/w
         75f6+kHr0G9puDEv6susKk4BqCdbwZ0pqz9Q6y+Rjdp581BxYQNFLdFEbjSY+9T35MHo
         l8u6wlNQ6aRwmt9kHXjXwyn77wAYbyP9U5G+guw9UXIA5s15y4rNOOWGrgGSnUohpTtd
         CZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758372329; x=1758977129;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P2Xt5dxImFQDNB+zIOSzEq8xo9rsZmb+jmetH2dJjzs=;
        b=LQKVmaR9l9n3O6BZ/ny1RhVlYRTTDNJFwcDIUEjtql3Bl6YidfaSJdUiWRMJ5CJgWi
         orX/JNOcHZaUuihpWU3xjrHGyZ27tQNY6i9lmdOe+9qiOQ08whlvgan1dK01BjGTScPI
         GqMOe778ppjJINr4lNgwhtjYRBafN2Pjc9OSzbKm7vbv42X09fVGXHZrH10pXmKcxMKM
         AUW1RGJejVkw7p7sQfdb9eJzR3Twz1E48hH0V8NHpNc6MNIaBBTHqCjM5GfSSGjfPeBh
         nGHwCHPLGa1oIjWux6BoD2XiuWRzh6mLPMJI6Wc3AZVBH03XfUZjO3Bm1gz3x5Gv8atH
         D9pw==
X-Forwarded-Encrypted: i=1; AJvYcCX4JXE1vTPD7LWFJnw0dfkWYiEPGjDymxWIB17RXApuIi7za5po1J61QV23yB27itNm80oGD86/TiMICpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEf1gAxST7dUBV68s98YenWi9Lidnw4fuVgW6mISazxxonAN7r
	EItVf3rv3oigr/2BRpeizq3FTR1NAoKIbLiLj5SeNn6w9FhhdkMoK61OLS22UQVKgcTgC4kwgWe
	RG14X8x28mxNLFvzDrCnTJ/UaWJfpjwtyeLfrDHwj
X-Gm-Gg: ASbGnctxJkv/P8r5KKQeFv2gPGppOFnM3UGaVjp9qyyexAfwW1cqiyHz2pJCDF1AiCU
	Jv96OuXfjJXD7wEgZCMtotZqluif0ckihtcHsCDVQHG3idY2Qizo3epT3oQWRSWsCoZFuQbM/P9
	bhnAjlGhNGyFgg91uo8nkIM8cJf4pEHrHYYH2iu6J9CqWB9XDJqNNZ0YpWfTsMArrFXZNwR3Fn7
	HKY6o2f9dgIJVh7fb9v0W1zVc+Lm1TBTouwD/nf0+KaXkL6
X-Google-Smtp-Source: AGHT+IGp/N/ayplQqKKBxnGs6WOfyKUH/iITNGJNC3m56lH0ddprjnIe5eKw57ece8B9TDbj2UEYyt+VdKNzNYtu5ro=
X-Received: by 2002:a17:902:ccc9:b0:267:b2fc:8a2 with SMTP id
 d9443c01a7336-269ba46f141mr83309515ad.23.1758372328847; Sat, 20 Sep 2025
 05:45:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de> <CANpmjNO2b_3Q56kFLN3fAwxj0=pQo0K4CjwMJ9_gHj4c3bVVsg@mail.gmail.com>
In-Reply-To: <CANpmjNO2b_3Q56kFLN3fAwxj0=pQo0K4CjwMJ9_gHj4c3bVVsg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Sep 2025 14:44:52 +0200
X-Gm-Features: AS18NWBli1y9TeOySCtz0PRORw8H0Rr8apw4LW7wblD60qoNXqS9BvtJEM0Stlo
Message-ID: <CANpmjNNkRQmt1Ea-EsSOVcA94kPqH_WntdT-NGnTjRocT25tFA@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Christoph Hellwig <hch@lst.de>
Cc: Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 12:23, Marco Elver <elver@google.com> wrote:
>
> On Fri, 19 Sept 2025 at 16:08, Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Thu, Sep 18, 2025 at 10:45:55AM -0700, Nathan Chancellor wrote:
> > > On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> > > > On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > > > > A Clang version that supports `-Wthread-safety-pointer` and the new
> > > > > alias-analysis of capability pointers is required (from this version
> > > > > onwards):
> > > > >
> > > > >   https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> > > >
> > > > There's no chance to make say x86 pre-built binaries for that available?
> > >
> > > I can use my existing kernel.org LLVM [1] build infrastructure to
> > > generate prebuilt x86 binaries. Just give me a bit to build and upload
> > > them. You may not be the only developer or maintainer who may want to
> > > play with this.
> >
> > That did work, thanks.
> >
> > I started to play around with that.  For the nvme code adding the
> > annotations was very simply, and I also started adding trivial
> > __guarded_by which instantly found issues.
> >
> > For XFS it was a lot more work and I still see tons of compiler
> > warnings, which I'm not entirely sure how to address.  Right now I
> > see three major classes:
> >
> > 1) locks held over loop iterations like:
> >
> > fs/xfs/xfs_extent_busy.c:573:26: warning: expecting spinlock 'xfs_group_hold(busyp->group)..xg_busy_extents->eb_lock' to be held at start of each loop [-Wthread-safety-analysis]
> >   573 |                 struct xfs_group        *xg = xfs_group_hold(busyp->group);
> >       |                                               ^
> > fs/xfs/xfs_extent_busy.c:577:3: note: spinlock acquired here
> >   577 |                 spin_lock(&eb->eb_lock);
> >       |                 ^
> >
> > This is perfectly find code and needs some annotations, but I can't find
> > any good example.
>
> This is an interesting one, and might be a bug in the alias analysis I
> recently implemented in Clang. I'll try to figure out a fix.

This fixes the problem: https://github.com/llvm/llvm-project/pull/159921

I guess I have to update the base Clang commit hash for v4 again. :-)

And thanks for testing!
