Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDAE314A6B
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763126560; cv=none; b=B4skO1KPKpijFWcp5JAr6xh4Dt6VhTJMdBAb4sX79yBn0Vd0bw9TrU8b4LErHrtnDuQ4fG5hoWe3owRCSNKUnE9+Q5F/vDeThY7Yzwubc/+HRt4gqTI/4ytdmO4VuDZaW4Iq2QyQXPezFKkRHQ2x2vIrjmJsGARu2cmnbkywLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763126560; c=relaxed/simple;
	bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a96NhwsXgJQw4/qNkKLywCtDmIOMgTtXovwmouL+93LmBkrldZrTk+ljsix9fCRhtuZTXVrTY2MWkqyuorOmGHA5Jm2WUJ/Y8L+nSe0iHDwZ45SOZ6Axvaicv3rsjRjgInmD+zvV961itSmlzu6FZHwAOacrRErny8g3EZXoWWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E7ddOafH; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E7ddOafH"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-343dd5aa6e7so2264082a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 05:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763126558; x=1763731358; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
        b=E7ddOafHhPb5QWq24mSAuEe9DZvtfFj7qtODwlLawtQJlmpFk8W7Y8n3jwAVPsBt5c
         1oTez8GmZCPnOyL6Yisc8QnrkRygZTvGDY/WskDu5UqsRZZsPP6Yo8VP0/Y+xHHWpL8o
         BoA+QIE42S66eKhoUszplz+w92NtwTHBXHodQzFTDFRPYAFjBlk60RgryU3cbP0H8KfN
         +alh7Q0ojcALPBF8As9eN6Z4mc142KmZp/gBOPYw0B7T3QfvQIouSaoFc5fcZ2oPhWGI
         qj0xfhASDSe2CXxZuP4SRE+GUMzHdPF3utwvbNQ2J4nmYXzzoA2sWraJlPVeHJhOotB4
         jXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763126558; x=1763731358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuZEuvQ3jmbwZpx7rFiCevGNtHp2p1kTZ05rKerm0EM=;
        b=ON4QzX1mBg9HZIhBIVzNy+LuS6ulHJZ5spM/gj27glhFN1dzv31areTfy9y7AoPnX/
         yym1CgMZjGRVbBnMQTAzwI7IC9YFfv2uhagbLmjdn2677a9G0UTnzg3FIC7i31Ijpl+o
         Y2E9X2mF8ljCjaRUBBY1WAmTzVDPsWat338rANkPBGEvxR4lBQg3X42xHN5WfLK/NxPI
         E28K+wZy2TYsCHN5ZHjgbn/GEJS7w5D88xcrhi79xDBC066qGU2qrKc1zAms1fjtlH3k
         cNzu4mHqiXfmqynvL1gAy44vXYmeQXZzmLP7vuWEdf4ACxqw3cxPZmoz6IFb6x3n6zuC
         ba0A==
X-Forwarded-Encrypted: i=1; AJvYcCXK3dg5M0JVoEXhqhujdeMjh9Ghb05BC7Rn5r2fYAFRLEa76OPQRm+wHjpRqz+bqfnhNtQpLURIvGdMAtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv95dcZgDzns7SkIV6Z9qxjYPgI8xF897Ur8O4gSX9dev+bcfT
	/kYx9fJIXPkhZ36gTrHUTnyxd2iBnBch+TvWduRTtmoQrwU3G++THrGIMtg4YAw0AsCnwduBXFQ
	DNZar6fKA5vs2GbC1WPfBWFFSPJdW5rlrT8wLw7xh
X-Gm-Gg: ASbGncumxF9NiK0q8N+zkZfLamLQ2OF3P5O07wY+peSQzQUq8ZIv+g2tuK3kuCdF7ge
	EaeCrhuFcuZA5hFpwtCvIm8N//KvSsfo883Vo1Ab/hP3SW7tdydW10BXu60MFS6uZHGz0iDlSAv
	DtrANhk6ill84nWJnqlTHu9CfICrQR0ZsSfwuUAJ7Q31JqHdz7DyZord1J9XDcMAxa/T+UoGwxh
	IKaJsINkRW9+dTMTGODgwWoJhXPWgmLc62ciZBoiumUXZT+Jm5Dum9EseIPIJWl2CPq7HJRx80o
	QOiGFcBDHWBqRO58bb/KN16jIO9t7asagXV6
X-Google-Smtp-Source: AGHT+IHRKhpP3vzCADgRzmvW5BbtF22FP7gG7Gcfgimn7ZOifR3jME27ZrJCzM+Xqri+6sVXI0f8t3/Rxc2hYDVrt54=
X-Received: by 2002:a05:7022:6288:b0:119:e56c:189d with SMTP id
 a92af1059eb24-11b40f9ed09mr1186107c88.5.1763126557688; Fri, 14 Nov 2025
 05:22:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com> <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
 <aM0eAk12fWsr9ZnV@elver.google.com> <CANpmjNNoKiFEW2VfGM7rdak7O8__U3S+Esub9yM=9Tq=02d_ag@mail.gmail.com>
 <20251114043812.GC2566209@ax162>
In-Reply-To: <20251114043812.GC2566209@ax162>
From: Marco Elver <elver@google.com>
Date: Fri, 14 Nov 2025 14:22:01 +0100
X-Gm-Features: AWmQ_blyYEkItbzeXoq8SnAQp2jhwPLGdi6tZz7V3PtwgmJC3W4HiUeTEvac_zI
Message-ID: <CANpmjNPniOK9K6q2sx7KRrxckeAdCyVnTi4qwLqoFoYzYb7L2Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
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

On Fri, 14 Nov 2025 at 05:38, Nathan Chancellor <nathan@kernel.org> wrote:
> On Thu, Nov 13, 2025 at 03:30:08PM +0100, Marco Elver wrote:
> > On Fri, 19 Sept 2025 at 11:10, Marco Elver <elver@google.com> wrote:
> > [..]
> > > I went with "context guard" to refer to the objects themselves, as that
> > > doesn't look too odd. It does match the concept of "guard" in
> > > <linux/cleanup.h>.
> > >
> > > See second attempt below.
> > [..]
> >
> > I finally got around baking this into a renamed series, that now calls
> > it "Context Analysis" - here's a preview:
> > https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
> >
> > As for when we should give this v4 another try: I'm 50/50 on sending
> > this now vs. waiting for final Clang 22 to be released (~March 2026).
> >
> > Preferences?
>
> For the record, I can continue to upload clang snapshots for testing and
> validating this plus the sooner this hits a tree that goes into -next,
> the sooner the ClangBuiltLinux infrastructure can start testing it. I
> assume there will not need to be many compiler side fixes but if

I hope so ... Famous last words. ;-)

> __counted_by has shown us anything, it is that getting this stuff
> deployed and into the hands of people who want to use it is the only
> real way to find corner cases to address. No strong objection from me if
> you want to wait for clang-22 to actually be released though for more
> access.

Thanks, Nathan - having ClangBuiltLinux infra help test would be very helpful.
Unless I hear otherwise, I can send v4 next week for review - in case
of a v5 I will wait until ~March (as that coincides with Clang 22
release, and for lack of time on my end between Jan and March).
Could also skip the subsystem-enablement patches for now; only the
patches until the MAINTAINERS patch are the bare minimum, the rest can
be taken later by individual maintainers.

Thanks,
-- Marco
