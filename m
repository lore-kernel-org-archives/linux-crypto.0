Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7032431283A
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765383509; cv=none; b=j7p5Qdv0W7tJDw2Q4E8UlPz/wlmpi5sNpP/tDUM+NA/4uITDHFsHzTRNHmPqOu4PRM+yPdP5OzkLLKqTmXnnRMvHaKxLs3GszTUmxB/x0sVD0OG+yeC9faUMFTTeDRlFE7gUW7rKC8R+dsEG4dcsx9egPlh0CbEA3B347DbOTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765383509; c=relaxed/simple;
	bh=8fukvFVHvNsSJut9kyMPtVjty3xkgDR42FqSOIyq0Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mB+gD7v3IZSVIeXZTTx12yWSvtjp9FeAmd22vS6ToL0kAlsukozsd5CQPKsKXhPRAaWiY1W7GUN6YLLhNZcEBt6owpkJJ/nIkMXoWeX1HKxu26Z3lR4CfWDwSQ6xE0yHwZHT2lXO6dYjjpESFwzIpSXzqQXpF820S/BahkiFtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Knpx6Ys; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Knpx6Ys"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477b91680f8so77529085e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 08:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765383506; x=1765988306; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R7EEgKhSIj0MssK61oG5hvlzLQojw/c9iQ7wtMJnfU=;
        b=4Knpx6Ys5jZM/3xzn4TkUlQ5MOn07tNXFGzWuQHetRSxVoOxFT3OFL1dI6aUzMhyEu
         xnYtbM7h+xr7oTrp7lflQAsqfG0dB83aJPa0N0Lzyw30KdGksmfQW3kYujbtnt3DkuVA
         fwmEmugctaKD9pNusDQNeXd1UfmY+fHvGPOWDw8BAfKfkIxSgy+w8UbI4YYUCqj4I6jX
         aI8c6m7cRh6B35onFu9uYiBhaBJoI1i9z8h4Mkeyxj9du9M621C5tHRNfX5XJmAb/f0q
         TuIXXyB2cjbM17BbTAqn37phQDIzp91gAiU1SG6JW6826VDNB+PT3RdVCI3rvFZjl/bg
         gWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765383506; x=1765988306;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5R7EEgKhSIj0MssK61oG5hvlzLQojw/c9iQ7wtMJnfU=;
        b=vADNLQQkgbTAMICdHllZDMPwvbsLlN/Nw6FnR7Ywceffoap/LczVHLkseaNRsxpso2
         aESbIOh8EgM6TmTFx7MgY6q373ymFsghR2eOmyt991K7rUC4UO6C/+vLe83Cb0RpedNI
         3g0AIFMEX3bMUuRvcbF88P7cXB9G68684PBPkb1oGWBo8YwlLcLclGWs+6YkdoTp+ieY
         QvfH5pE5Z+c8y5z+Yc8wYqFdUIriJepNYyqvlPGtNzcwX0Ew/Lo69QjUgTK94LNID6rJ
         TbtYi14Fcal6Qx4D5nk3vUudFCcGPMYvOsLfjvejFi1Tlv/t228jtfrE+uqUecSmjm+Y
         L27A==
X-Forwarded-Encrypted: i=1; AJvYcCUKWVybdiYthUIeIZDxW4Yi9OZzZAI5bAIap6aCk2rCVH6gAiOTQ8EhQ3d8Nguk0L/VvIcQRHk49Glutbw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjz5QlOVpVwFPay/F+9Ye/fvm4ppRXvd1q8LTkEMEE1T3ShkPW
	n+O8NCyeNeDwzs+HBC2iS0+vxiCQPlL3QyZ70S4ScSWtVE8OaVAdJeWEvTGebgVM3A==
X-Gm-Gg: ASbGncvCWSR9OP0sTY0UbJnAIQecQ7OU389gGgWM75iMvHPxdOHQ9/9yMxZw/qhi5oo
	vvvpEirqlpwcHAxzhHEUdqr7apLk66VYGXHZWfl61P9V7+BmZWP3WxUPTE8VYYdlWTMtmgplSmz
	+LHl0TDC6Fyy/rwj0YNI5dL7/e4mybATvPGF8nYSgG/dLTsobcg1NtZqSV7d9ob9Qpy54efLvtT
	FTd/WOGtdt4p8DqZQJ3vP9sf/tVN77BYRBKfxn/U+NGWWd6pPHT+qBRPj7Rg6ZDKo2QTHAzzprq
	38oGGZN4w3+zAedJISeg4RopSGI3ttFmPkVWEofWUm+C9sXwXoWJYv9jLjsxeN1gteh2tuYoDOa
	zuu6yJ186Z8GdVGsc1kQvTOmNt+QZ7O4a3WR0ybd/WTu/JF2pL9zS6Zai+aAvF3b8alThd3zLSP
	PQKdsOKSI0/lVs8sGsGUR7Jop+z7RHWZatDndDFpKGa1n5zaA=
X-Google-Smtp-Source: AGHT+IE5gG+0fezF5tzXHFusF2dBV52zxvrbxnDDqwGYfilnFo0IcpTyJU4lWfuQsZFtfQAM3eL7LQ==
X-Received: by 2002:a05:600c:687:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-47a83cc5528mr15763325e9.20.1765383505415;
        Wed, 10 Dec 2025 08:18:25 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:edfc:ec3:194e:c3b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d3a75a3sm45109085e9.6.2025.12.10.08.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 08:18:24 -0800 (PST)
Date: Wed, 10 Dec 2025 17:18:16 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v4 00/35] Compiler-Based Context- and Locking-Analysis
Message-ID: <aTmdSMuP0LUAdfO_@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
User-Agent: Mutt/2.2.13 (2024-03-09)

All,

On Thu, Nov 20, 2025 at 03:49PM +0100, Marco Elver wrote:
> Context Analysis is a language extension, which enables statically
> checking that required contexts are active (or inactive) by acquiring
> and releasing user-definable "context guards". An obvious application is
> lock-safety checking for the kernel's various synchronization primitives
> (each of which represents a "context guard"), and checking that locking
> rules are not violated.
[...] 
> A Clang version that supports `-Wthread-safety-pointer` and the new
> alias-analysis of context-guard pointers is required (from this version
> onwards):
> 
> 	https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e
> 
> The minimum required release version will be Clang 22.
> 
> This series is also available at this Git tree:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
[...] 

I realize that I sent this series at the end of the last release cycle,
and now we're in the merge window, along with LPC going on -- so it
wasn't the best timing (however, it might be something to discuss at
LPC, too :-) .. I'm attending virtually, however :-/).

How to proceed?

I'll be preparing a rebased and retested version of all this when
v6.19-rc1 is out. One outstanding recommendation from Linus was to
investigate compile-times, but as-is, it's unclear there's any notable
overhead per brief investigation: https://lore.kernel.org/all/aR-plHrWDMqRRlcI@elver.google.com/

From what I can tell most of this has to go through the locking tree,
given the potential for conflict there. However, it is possible to split
this up as follows:

Batch 1:

>   compiler_types: Move lock checking attributes to
>     compiler-context-analysis.h
>   compiler-context-analysis: Add infrastructure for Context Analysis
>     with Clang
>   compiler-context-analysis: Add test stub
>   Documentation: Add documentation for Compiler-Based Context Analysis
>   checkpatch: Warn about context_unsafe() without comment
>   cleanup: Basic compatibility with context analysis
>   lockdep: Annotate lockdep assertions for context analysis
>   locking/rwlock, spinlock: Support Clang's context analysis
>   compiler-context-analysis: Change __cond_acquires to take return value
>   locking/mutex: Support Clang's context analysis
>   locking/seqlock: Support Clang's context analysis
>   bit_spinlock: Include missing <asm/processor.h>
>   bit_spinlock: Support Clang's context analysis
>   rcu: Support Clang's context analysis
>   srcu: Support Clang's context analysis
>   kref: Add context-analysis annotations
>   locking/rwsem: Support Clang's context analysis
>   locking/local_lock: Include missing headers
>   locking/local_lock: Support Clang's context analysis
>   locking/ww_mutex: Support Clang's context analysis
>   debugfs: Make debugfs_cancellation a context guard struct
>   compiler-context-analysis: Remove Sparse support
>   compiler-context-analysis: Remove __cond_lock() function-like helper
>   compiler-context-analysis: Introduce header suppressions
>   compiler: Let data_race() imply disabled context analysis
>   MAINTAINERS: Add entry for Context Analysis

Batch 2: Everything below this can wait for the initial support in
mainline, at which point subsystem maintainers can pick them up if
deemed appropriate.

>   kfence: Enable context analysis
>   kcov: Enable context analysis
>   kcsan: Enable context analysis
>   stackdepot: Enable context analysis
>   rhashtable: Enable context analysis
>   printk: Move locking annotation to printk.c
>   security/tomoyo: Enable context analysis
>   crypto: Enable context analysis
>   sched: Enable context analysis for core.c and fair.c

Thanks,
	-- Marco
