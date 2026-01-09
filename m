Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D55322B61
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767992822; cv=none; b=c2dLZXW7JwAg9pmNUDUK504jgf+C/loVDw2Gjt5ves8AGKmD1OT0BreeeR73CE4Sqohh5pKuFBrFDo3OaXChfLDke7XwBWisf8nLtTDtmA8q3/yi2utD7kaydY8iJFE7oFCTTjXLWdTDyBwq+Vx75Nbv5R7qWcSfr8HR7uH17+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767992822; c=relaxed/simple;
	bh=wZYProj9n7cDm7L+0im3lC/7Zt3vu+GEy+eJDL5drSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBKJZTcmx1YmObCYARSPJ9AgC097856rDgCnJITc+KwweDQv9i+eQC8JILC7m9X+i5Uc+KSSOKWmi+BH97fqS6zrXizWy9jzpYbRJ+6fByICWjqXJLKZYUXvaYqMR9il+Gz6JNdzPP/wy5V9taAkiuTiCKOW7hNBa9NVmGDAyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpJi9uo3; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpJi9uo3"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-4327778df7fso2896833f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jan 2026 13:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767992819; x=1768597619; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YiRRXuPlaLabH8Y/4leOeBvuw8o8W+AqfnKT5Dc7EA=;
        b=xpJi9uo3bSPMI7oc/H3S6O2n13/XYzTeaGwasdMt876auDtG3k4GPHGxGH1rAl27uc
         Td6/pZwm43cgCu+oICgBkNWhmv72cCcknScYEPhIlnI0aLEEnM1vPvaGQPCfOVvO5vZM
         VI7xfv1hx5JYTlkQMh6u/IdmhnupWKRBuT6I/aaIQ7xIEFOr87e7Dk4H79chj35uTfnm
         TFj14bhculOSAia3vmuVcJ1ktj4wBGcjk9smHTVc+stTS/ZMyqYme8ue7wEwWH8SQGwP
         mGD9UOGvCr51xICxjJdsCpZFo2R7dVVdY//yZ+RxNTOojvhIslJRXh9brFYRkIxl1k8U
         UlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767992819; x=1768597619;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5YiRRXuPlaLabH8Y/4leOeBvuw8o8W+AqfnKT5Dc7EA=;
        b=YVF2jqR4kZ6fnfPEuAUIlioKtiaAB+or4LAEb5zlk/rrDgqcCFSkMRZEaDcSilak/0
         /F90tSLrIGlhzRQ5Zbuy6SorAx1d8dGrPVUXW5dxVCBQUImJVdtb0uiOAKmDEPANSWZu
         EW/NfFksjJsxunZLBQNDMvxSPdT94Tb1cKccZpyiKJ1yq3iHhEAP3zgdtif+KOawlFSZ
         0AF4kdA0lPBzHaZC5Uu0fVfWjA8QlnPKw3SkEOa9fnsiyHc+7fSUvBdQmWjfGu4FYl8y
         adhN1je0JNNB29mR85khIBfaoYKbBhWtE+psQ6/drRYoc9GSGa9tsYmSvmHldH3hj9eK
         CZgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHP4inuD58xKVQiI2kS8tpJKcXOjzNJf6cu/glIekDcxF+5QOIjmJff3DngQ0lsJXTeXZs0Un4WivMmKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSmoyGl6hgiYH7nM8cGhIySaCnW06p/wj1NDsAApKDN26Ie6/l
	vETfblv12BVpovrYhBaMGRguk8+giFCaMJsd+H4M3rXMy1uMrS+lW9V9cwQsUg00bA==
X-Gm-Gg: AY/fxX4l49IBXyRQmH2XumBzH6KQ6q43250f3eY9q/c3XhESFNogRDU7WKlyGw96PPz
	kWO7ZVMUhSqomA9lshuY9ODScZG3pNz35v+jeHConBu/sDz1R1n3tVqpc4wB9d2UkXfZxIZqW6e
	/DpGo0shnM8gyEkDz/hVoLyJsVXyrSe5dCP1d46rsT1mxmmZaZxjkj8q6aXpEylKh0dEid8mit/
	M4dUmaqwNP+1QNaEfb+1oQx85brs4v7hzH7PtPWwm/V5ut8U7qmiGe/43twBREmQliyLmKUcYZK
	XmIMCvCMavLsk3Io2BHTtVHfS0/1FBYedqYRebpLQb5SvW+dFKIAo1rdzAwIwbaHKop/GHR6pdS
	g5kjdhahtHOi94c8eXjZDZN99MkAGWZ9HDV97bPQJSQp31zUraiLiQoDAW1jDSUaqXPbDXXBNRA
	bLOMl5bEry7vjPXycIp1fB3/ie/CbiDELgzdRELguaQhmil6ZK
X-Google-Smtp-Source: AGHT+IGq/RRhgqPG360sNev62yK5kDA+HwwG1xM6/+WULZOG4/KY3n5LdCQUAGWoCEcUzU7iAOtzbQ==
X-Received: by 2002:a05:6000:4023:b0:432:b951:e9fc with SMTP id ffacd0b85a97d-432c37636b0mr12665932f8f.47.1767992817879;
        Fri, 09 Jan 2026 13:06:57 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:2965:801e:e18a:cba1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df9c5sm25214398f8f.22.2026.01.09.13.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 13:06:57 -0800 (PST)
Date: Fri, 9 Jan 2026 22:06:50 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context
 analysis
Message-ID: <aWFt6hcLaCjQQu2c@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-21-elver@google.com>
 <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Fri, Jan 09, 2026 at 12:16PM -0800, Bart Van Assche wrote:
> On 12/19/25 8:40 AM, Marco Elver wrote:
> > Add support for Clang's context analysis for ww_mutex.
> > 
> > The programming model for ww_mutex is subtly more complex than other
> > locking primitives when using ww_acquire_ctx. Encoding the respective
> > pre-conditions for ww_mutex lock/unlock based on ww_acquire_ctx state
> > using Clang's context analysis makes incorrect use of the API harder.
> 
> That's a very short description. It should have been explained in the
> patch description how the ww_acquire_ctx changes affect callers of the
> ww_acquire_{init,done,fini}() functions.

How so? The API is the same (now statically enforced), and there's no
functional change at runtime. Or did I miss something?

> >   static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
> >   				   struct ww_class *ww_class)
> > +	__acquires(ctx) __no_context_analysis
> > [ ... ]
> >   static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
> > +	__releases(ctx) __acquires_shared(ctx) __no_context_analysis
> >   {
> > [ ... ]
> >   static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
> > +	__releases_shared(ctx) __no_context_analysis
> 
> The above changes make it mandatory to call ww_acquire_done() before
> calling ww_acquire_fini(). In Documentation/locking/ww-mutex-design.rst
> there is an example where there is no ww_acquire_done() call between
> ww_acquire_init() and ww_acquire_fini() (see also line 202).

It might be worth updating the example with what the kernel-doc
documentation recommends (below).

> The
> function dma_resv_lockdep() in drivers/dma-buf/dma-resv.c doesn't call
> ww_acquire_done() at all. Does this mean that the above annotations are
> wrong?

If there's 1 out of N ww_mutex users that missed ww_acquire_done()
there's a good chance that 1 case is wrong.

But generally, depends if we want to enforce ww_acquire_done() or not
which itself is no-op in non-lockdep builds, however, with
DEBUG_WW_MUTEXES it's no longer no-op so it might be a good idea to
enforce it to get proper lockdep checking.

> Is there a better solution than removing the __acquire() and
> __release() annotations from the above three functions?

The kernel-doc comment for ww_acquire_done() says:

	/**
	 * ww_acquire_done - marks the end of the acquire phase
	 * @ctx: the acquire context
	 *
>>	 * Marks the end of the acquire phase, any further w/w mutex lock calls using
>>	 * this context are forbidden.
>>	 *
>>	 * Calling this function is optional, it is just useful to document w/w mutex
>>	 * code and clearly designated the acquire phase from actually using the locked
>>	 * data structures.
	 */
	static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
		__releases(ctx) __acquires_shared(ctx) __no_context_analysis
	{
	#ifdef DEBUG_WW_MUTEXES
		lockdep_assert_held(ctx);

		DEBUG_LOCKS_WARN_ON(ctx->done_acquire);
		ctx->done_acquire = 1;
	#endif
	}

It states it's optional, but it's unclear if that's true with
DEBUG_WW_MUTEXES builds. I'd vote for enforcing use of
ww_acquire_done(). If there's old code that's not using it, it should be
added there to get proper lockdep checking.
