Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA2433EC
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 13:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765891413; cv=none; b=S0N8SXsgQpCIKnftzhmaMqJDAz3SADiqI60+Pkc2oyw+OQ1AHZ+XC1lv47LImH6zdnaX8AJ1Zbi2QaR/2mUf96i8YVCbqPgN5rwm9//Mj+lhr00s8AiE+VKVjNFFRM704+qE05InEcvdDL890pe48t0Mn5/dBDkP9qGIPgepaiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765891413; c=relaxed/simple;
	bh=QV+61qVpdqsPiaPbfd08qHh+TzoR572QyzT9O2x4KLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdcB9wlK++lAxme9QKkaF2v+TsyX7Wai+eXBgt3MqqMLpabBmnSR0c5u760uuR7oaWsg5E9Zp1guStVLWwuf9Cr36ziLROvBeX22V1sB1sjCX6GxNQvS9ApB2FfWh2AEBpiLeI03ps70GS1FlAI54EnxwZRC8zoulo0kAw/emPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KYuw7Bzr; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KYuw7Bzr"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so50097905e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 05:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765891409; x=1766496209; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDxfhRBysj2yPZBzYVVRhpxcjKV0qpQrPWWhDK3SHYM=;
        b=KYuw7BzrbUMfAKbOrOhWuTPHNWxxKEuwVW5dWYZPtJMU5wFJ1ufOC3qIcc9YEVlOqj
         dG9J5HE9tepzKCWwwLO3OPYZUZ6EaQ9SBMurPmSp4BobCl4IPxkRSOO5xlCYmbYe840P
         DjojpISFW0m4/JTJzh6uejvlgxhDhW6lGqJIyr4oz+QGg29jbm2tnhtxKbf46uYt3YaL
         2V25zRNAFnI99YuGgxMOomP54DQkqGG0VRwW1m9/Ifp4m1GxUi+/aXwg9WpGGKGZ+8sh
         rAhIfIAc/U+0vyz00zPjagXYFm7Y6De8r+BO54KxfD0TKnLlTsTreMxoPdffsg3hzkGY
         scqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765891409; x=1766496209;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uDxfhRBysj2yPZBzYVVRhpxcjKV0qpQrPWWhDK3SHYM=;
        b=gWpMcZbQFjESaezAvW1yTSwezWbTCPYHlWO8rGgJiHquGoftYIKBwlE+Y+mb047aXs
         e5XdPe9sZ0/B0IDuds1dv1CZvpsT2yhmsZYBXIPQsu7Mp7Gsb9wf+i1bOIRJlo7n9+mV
         LL6GiN2ckzwNT/BnKCZXPdqPBx8yovIkTwHpvGgJCoXkiDelA9J0beql2NlkK1lW9J0F
         bHtCzZICmmk56ZG8XYu3gHVfNokRWKgAkWiAeHBUpzIP0gTBUS+7V9spOXgNcmfHPima
         AnXIOLyk15n3s3ZWEE2CWHzPp1xZ28bxLBJlRPSyV7ZFr12GLOrP+yAyjxMD0lUBpEG7
         w8Rg==
X-Forwarded-Encrypted: i=1; AJvYcCVb8WXQ21XOdhLZFvogD34YqMU+CKeFs8YoprZ56aWYHDDdQR+qsvBn4w4+dbfmM6gwTkJ64nWkS76JCrU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgXP0ZFwqTbjSoPeWL43kRr/zDxH7xXHyY5iHaqV6K5vdNsnFQ
	h9x/S9SJJxV2jW9ECgvq9ps5pHHnV9D7e46DO9haGS1oZMRYjOCDjLSS/mErC13SAg==
X-Gm-Gg: AY/fxX5hZRlJszkcRS9+UpRSpY8t0qjVslX3tlhDIioTB9Pint0E03jg8UTjxQESsjL
	WAkcEOw8HzCNGtIpRoAu8B31HAbvfmy/Q1zl5lLPhkf1IADMJ1NJdM0/aR+G0vZ1AShFdTBaQGx
	5anUaii7SOCu5X5XYXOXMfbFn5KxBlWLpAh5wYCMaHdR81n6DJbSUGHbG0Y5iUDVFGNTghPsC3q
	aiHbYYMic71Fk0refDy7foEP0bMDLVBxMmg6Q6ZNWQgf6IeeCz+JbXzVXf+B7Pq28Tr6mh3j30m
	mv5aMjfM8BmMSk+K55f6wlK/Ca3+0LcjpF3c/6pxe97czhNyGLoEthjGBiJaelfGQ5vxFyEeZ9y
	N+W0wTyXaplOPGPLQd7j82JU5VF7WukT1btYjORhr4/WX7qfE9Hj4zjTZjqwsdGttqlEvVcswcy
	86TqD5VdCHoHWDtT4joM8T8iefERFscjNV+lnH6nFkA6kbbcn9
X-Google-Smtp-Source: AGHT+IHeQgMekTiUSXYyDxvkGceEMaJToW+cfsdKtACjSuXcP89Hj1YmnWwqaTNfU+el5KGHlOYfZQ==
X-Received: by 2002:a05:600c:4f90:b0:477:6d96:b3e5 with SMTP id 5b1f17b1804b1-47a8f8ab02bmr133331835e9.7.1765891408469;
        Tue, 16 Dec 2025 05:23:28 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:ea4c:b2a8:24a4:9ce9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd8f86b83sm10764215e9.2.2025.12.16.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 05:23:27 -0800 (PST)
Date: Tue, 16 Dec 2025 14:23:19 +0100
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
Message-ID: <aUFdRzx1dxRx1Uqa@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Tue, Dec 16, 2025 at 01:32PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 15, 2025 at 02:38:52PM +0100, Marco Elver wrote:
> 
> > Working on rebasing this to v6.19-rc1 and saw this new scoped seqlock
> > abstraction. For that one I was able to make it work like I thought we
> > could (below). Some awkwardness is required to make it work in
> > for-loops, which only let you define variables with the same type.
> 
> > 
> > diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> > index b5563dc83aba..5162962b4b26 100644
> > --- a/include/linux/seqlock.h
> > +++ b/include/linux/seqlock.h
> > @@ -1249,6 +1249,7 @@ struct ss_tmp {
> >  };
> >  
> >  static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
> > +	__no_context_analysis
> >  {
> >  	if (sst->lock)
> >  		spin_unlock(sst->lock);
> > @@ -1278,6 +1279,7 @@ extern void __scoped_seqlock_bug(void);
> >  
> >  static __always_inline void
> >  __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
> > +	__no_context_analysis
> >  {
> >  	switch (sst->state) {
> >  	case ss_done:
> > @@ -1320,9 +1322,18 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
> >  	}
> >  }
> >  
> > +/*
> > + * Context analysis helper to release seqlock at the end of the for-scope; the
> > + * alias analysis of the compiler will recognize that the pointer @s is is an
> > + * alias to @_seqlock passed to read_seqbegin(_seqlock) below.
> > + */
> > +static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
> > +	__releases_shared(*((seqlock_t **)s)) __no_context_analysis {}
> > +
> >  #define __scoped_seqlock_read(_seqlock, _target, _s)			\
> >  	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
> > -	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
> > +	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) }, \
> > +	     *__UNIQUE_ID(ctx) __cleanup(__scoped_seqlock_cleanup_ctx) = (struct ss_tmp *)_seqlock; \
> >  	     _s.state != ss_done;					\
> >  	     __scoped_seqlock_next(&_s, _seqlock, _target))
> >  
> 
> I am ever so confused.. where is the __acquire_shared(), in read_seqbegin() ?

Ah this is just a diff on top of this v4 series. The read_seqbegin()
already had it:

	static inline unsigned read_seqbegin(const seqlock_t *sl)
		__acquires_shared(sl) __no_context_analysis
	{

> Also, why do we need this second variable with cleanup; can't the
> existing __scoped_seqlock_cleanup() get the __releases_shared()
> attribute?

The existing __scoped_seqlock_cleanup() receives &_s (struct ss_tmp *),
and we can't refer to the _seqlock from __scoped_seqlock_cleanup(). Even
if I create a member seqlock_t* ss_tmp::seqlock and initialize it with
_seqlock, the compiler can't track that the member would be an alias of
_seqlock. The function __scoped_seqlock_next() does receive _seqlock to
effectively release it executes for every loop, so there'd be a "lock
imbalance" in the compiler's eyes.

So having the direct alias (even if we cast it to make it work in the
single-statement multi-definition, the compiler doesn't care) is
required for it to work.
