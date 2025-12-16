Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD035503B
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765891601; cv=none; b=qqGWhZg/sbjWPNMnq9nbJs1PsXHhg2S3LHa4oGmtpiU+ZZrRQMOFxur0aVoTwSkz8mAtLPRv7FXlUBBb+bRHfYN8THIpKPpEw2J/Eq9ONR1guYZY/jXqiEHs56xThY7lZAtywEZIQHX9ERbftfUU+PZHFAwqWk6ypRB95Yxqroo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765891601; c=relaxed/simple;
	bh=XzSmUQ9wBuoAsnnswWznp0kvFEGZQ0Tj3+vUePVVnwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fB19PfZElyXQQihGLPd7tZ6Uh0iYXkSRg2imYOIK3jOi1a+17qGPDKXmAhems2Dk6pEGmGh+d6PsIxRXXtbmG/P0iixKT7DkzvDEafc/Dx7enFZtjBuP7Qzg/GjBZp1yhz1/i/N/Bs7Tf3TCG4ds0rVtNmAgpzDKkJpTStl32No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=buYJu0gC; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="buYJu0gC"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-647a3bca834so6943874a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 05:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765891597; x=1766496397; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3V/ozmG0P6zbhJMhekfGn6dV/6uy4a54Tyfq8of8mrw=;
        b=buYJu0gC4OU4CKzN0mxTwWWLvQ4CNFOE6E5ISWagDJYeSPRRTZEJblsZjS10eKAI9o
         pQdfa6WhBntvFfS1/XfQ9/yKOraEw6DxVQO1uzuOL+URVzk+f/q/8DnJktaiNSd7DBJi
         tnvbE/8vjuq16rtJWuUvHoaCMvXhFVVpMb5RvybkAgLEXB0x4AmWNOt7wO8kDRH24QY6
         cvXAamGreZz8arkujIiH+dEPwH4lss3HYi/D/FkrIOKheflpobF84oPK+vMLJ5LcyDpB
         VceNZB1hflgT0S3PNCJ/TA87AIeCNjz1cBLeBQM6/Y56AMmE5BbW75KkDYJQlrauWTp6
         g5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891597; x=1766496397;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3V/ozmG0P6zbhJMhekfGn6dV/6uy4a54Tyfq8of8mrw=;
        b=EZTsQ2Fr0EF29GqcIK5Kmx6ys5RAmmFnSDOO+Qvo2pEgHCSftaTPqRbQ48tpup5xQ/
         LS6hiO+ZkBcVqsPaKH2BI9w3elw+j8rCMIcaf5ukJhsMLCqm1cEEjEKiWgyXD3fjeDrt
         fz4GoHAYfT83HlogFpiXqbAAbl2sufeG8gcktSiXfo0WQVk8GsioUN73Ybwl42OvGRXL
         vq9OYE/HHqV0Rl4wSBGTENQDR/qH6Omw9nKrw5VYRWnqjLgx1DAyaWo22N0TbwERdlTF
         w1hVug3Qn0uOQFCuhn8EulxHA6/xfXUgX7uRyWiHcmwi5Jn8RHojJEX3nl6MmZrvdxke
         zATQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/v/hX0mGOjjzV1qsmqe1pMZImkyNcrug51p9Ji7Lg1rHdhjfFeVeszcyWbgDx4obAitHOQeuPSb/3Vus=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf5yHd+ETFOZ41cqyO/5OFG82L3iWLQlbB0U4NrD/SQj9C/vOa
	F/e2yn19U2rLOLQU/2E9WoZYEWVTNdmZ0dIU3iJtE3ZmdTgBZFYP76ftjENNUKVfUA==
X-Gm-Gg: AY/fxX50dbkOv4ppwVr7q3VWAECozyQBaF2U+Ld1NmM1ENtYWplh2ZqTuuv1Dk8gKfM
	cKXXQ+KkZx+YhA0AIKB0GFAeX/lTnWVwvUtMjzaTgzU5wyoRzB7Zs0fUayl1K7DT9HqIuKs6QSx
	nozfSU2/whlT7El/Fj4r/uiY2n7faN6863yuddiMZ2sj1WMPlrf9ElhQzlzhUGTdXujosF8EkfY
	QMVbGWdoYmI+0eKLZtwovbDiwBBNsaWWxg8cCjvvRFO6RdR2erQDtfAOD8MkkkYFgXf+cZge+ax
	cI1AdYxb7oUChjUN4NKXpE/UKFKavOeR7n24kTC17I5/64AMfFg9ENRN8F278zk4LMxzy1R2yDA
	sOHGSeqb8D1sEpki+me5EhO/LRvT/X61OBfwhQAQQCWg60X3ydZQmlGIx/05bx+9NHa0nnjhEzx
	YFSuRZwX60flo321MPhU425a4RoBAEzSxNWO0YxvgwPehA9+U0
X-Google-Smtp-Source: AGHT+IEXN8c4l2W138SpFxaraGM3jOuuGwcwQYafzXlaDOwN/Hd+sEz4uwdMcyiAnZ9D77N2tR3XDg==
X-Received: by 2002:a17:907:72c7:b0:b6d:9bab:a7ba with SMTP id a640c23a62f3a-b7d23a97591mr1453601666b.42.1765891597176;
        Tue, 16 Dec 2025 05:26:37 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:ea4c:b2a8:24a4:9ce9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa5d0b0dsm1693444566b.67.2025.12.16.05.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 05:26:36 -0800 (PST)
Date: Tue, 16 Dec 2025 14:26:28 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <aUFeBHuBJr-Y512D@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
 <20251216122359.GS3707837@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216122359.GS3707837@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Tue, Dec 16, 2025 at 01:23PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 15, 2025 at 04:53:18PM +0100, Marco Elver wrote:
> > One observation from the rebase: Generally synchronization primitives
> > do not change much and the annotations are relatively stable, but e.g.
> > RCU & sched (latter is optional and depends on the sched-enablement
> > patch) receive disproportionally more changes, and while new
> > annotations required for v6.19-rc1 were trivial, it does require
> > compiling with a Clang version that does produce the warnings to
> > notice.
> 
> I have:
> 
> Debian clang version 22.0.0 (++20251023025710+3f47a7be1ae6-1~exp5)
> 
> I've not tried if that is new enough.

That's new enough - it's after
https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e
which is the minimum required version.

> > While Clang 22-dev is being tested on CI, I doubt maintainers already
> > use it, so it's possible we'll see some late warnings due to missing
> > annotations when things hit -next. This might be an acceptable churn
> > cost, if we think the outcome is worthwhile. Things should get better
> > when Clang 22 is released properly, but until then things might be a
> > little bumpy if there are large changes across the core
> > synchronization primitives.
> 
> Yeah, we'll see how bad it gets, we can always disable it for
> COMPILE_TEST or so for a while.
