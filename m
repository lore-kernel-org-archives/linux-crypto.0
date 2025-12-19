Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45F2C235E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766180866; cv=none; b=lh2dfnqYoFD9TmCjJkT53QB01wz/DV6r8g1Upw39XqEP8pdPlUYyQGVczxTjTekIm4WrP0kg+3j3NUFkuCyyv4sckpFDJu1oCUjBi8y+hIzaF4zJ305HH4OxXi7e8XUJTQD5OkrNbESzEtyqXLqIo8fINrCp/7ObHFhjzvv84BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766180866; c=relaxed/simple;
	bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pPbRI3lwJUc7dVbRkKOqFu9H9ctN6OjrDJhUQd6sDJdYCKrReeTw7etRL5nGG8c0zd4vJQxuCaKvYAI7vpZGT1MzwGzrSVjpGTUDWaHq8IjZt/UckHpR3MKCfbixV7Wx43JcYyzit/p5lj+6Ij6WDKuhVHkh3VDH4QpUuqsyMSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZbybHZHV; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZbybHZHV"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc0d7255434so1347087a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766180864; x=1766785664; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
        b=ZbybHZHVykrdpRAlGtriqn3wHVaP0BEV7RckU3M5QqDWGgWfvo2hRQBbphxvS2BNwA
         pLQzrwBPxR7Cax+FXCV/hUhwNkt3G3JC3gTCeB1WvXqlvvEj6IxAfy7hZHBa67+7q+ex
         HG4cCHZjp16WhljmP/3OuO0e6kNRarA12msX2ZrhpVhXUX3ANQUCUvxEhe8SS9He9o8q
         obqn5RvnxYUC+q75XIHGpumO6is2s9sPQnNCDIuDgJzOS5D8YafOkIAZN+vy+ar77UPH
         uIx2RfkQsx8sZvum/zbXR4najDOHCyezCoClEbFYMDFluQRWWOUCT29Tg9IAouUwjXo5
         DjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180864; x=1766785664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ms51wSRYcNMLU08U6XlitTxavoeEVdn7PylZ66BFoeI=;
        b=kyt9nljY6Hs7EUzNtoZYv8Y3uOmpaxvAlZk6gvos06QM1wmbzi6F5zrkk8w+uj1Bwz
         QycduH9Uk3DlpLudxh2tzfOlNdPo9xp3nncdZWcx0H4w45D4uCufmZAClBI73TvmJsyp
         8+BlR4xR9odcaRjr+ETZufFA0JgOEudNpHn8kBC91BRKlpHhkVg/GHucsAKqb8t3s7Bd
         xxrSyCXBcG5rZ8fXFB+hsHkrbjrd5dF7oZKIhbMCsENiTraxthpFffrkhfXu8sGP2tHC
         +pH4PgR99NE71OTSieM7xKuFa7XUS/Mfvo3y8wrTtL6KzfXxFH84Zfc4I9qFZ7rnJX60
         pJ+A==
X-Forwarded-Encrypted: i=1; AJvYcCWRgG7Cq23vQQrni9DZvJxAWlOyXeC0SAFqpBig2pJr5WusWNDFMP8yXzTPF4HLnIGIq1Qj1YsEep7Qk88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/5WpYLzx/S60L8I4JoeERJKvUl0ozAl6twHIIJS/HxwuutSFa
	tctsjsE9w30fJ/MrXtslpnbYecnaXdoszhyYBn+vlitJXCddyQXRJM6L+MXurVq3+F6zh+GnWJ3
	QX+9UX+idls8RA8/zy5g5QteyS9gnijIVtWZzn+Qf
X-Gm-Gg: AY/fxX4LBHe7FJaDy1bZdb0dw+oazhm19rPzxnkIpRaRTR18eFAnAOiz6VfTHmw9V6D
	vEt0hnH27G6QLOD8l6JpSZRBAgeodKMClL1XWdm3B7aFKkPkazC3eR/qCNSsyRD4F4ohZ5AuwAl
	f65B5sPt5u8TeZaKCnwK7qsQtc0tET72zd8cMXG0nyON8VWrZ6ET169yVehpDntBA/4eIkf6Twx
	bmVv8o1ZQy6Mc95HcHasiRAQ/TNEQq58J2W0e4EFyUIeMlHt2UhSnuvCTVCTcm7oV89VzdERELy
	YVl0UbyYM2wllFUd918mzDtQZUQ=
X-Google-Smtp-Source: AGHT+IFIxJn1IGPy0nHsxYCQasesjc20OB/If1nT0iJGZS/3DeBiPOVvBE4Lni1iekMVipiY5AEcIb2ButU5L5/gdvQ=
X-Received: by 2002:a05:7022:5f0b:b0:11b:9d52:9102 with SMTP id
 a92af1059eb24-121721aaff1mr2914480c88.6.1766180863274; Fri, 19 Dec 2025
 13:47:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-8-elver@google.com>
 <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org> <CANpmjNPJXVtZgT96PP--eNAkHNOvw1MrYzWt5f2aA0LUeK8iGA@mail.gmail.com>
 <ecb35204-ea13-488b-8d60-e21d4812902a@gmail.com>
In-Reply-To: <ecb35204-ea13-488b-8d60-e21d4812902a@gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:47:06 +0100
X-Gm-Features: AQt7F2oOvMMB1QIst16kG-Ehhh_fmZRMYn3rIRXwuCNiu1TQ-QKGkuW-c2bqFwM
Message-ID: <CANpmjNPp6Gkz3rdaD0V7EkPrm60sA5tPpw+m8Xg3u8MTXuc2mg@mail.gmail.com>
Subject: Re: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context analysis
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Dec 2025 at 22:28, Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> On 12/19/25 2:16 PM, Marco Elver wrote:
> > It's basically an escape hatch to defer to dynamic analysis where the
> > limits of the static analysis are reached.
>
> That's not how lockdep_assert_held() is used in the kernel.

Because there had not been any static analysis like this, and dynamic
analysis is the only reasonable option.

> This macro
> is more often than not used to document assumptions that can be verified
> at compile time.

In that case the lockdep_assert can be dropped.

> This patch seems like a step in the wrong direction to me because it
> *suppresses* compile time analysis compile-time analysis is useful. I
> think that this patch either should be dropped or that the __assume()
> annotations should be changed into __must_hold() annotations.

If we drop this patch, e.g. the "sched: Enable context analysis for
core.c and fair.c" will no longer compile.

It's a trade-off: more false positives vs. more complete analysis. For
an analysis to be useful, these trade-offs make or break the analysis
depending on the system they are applied to.

In the kernel, our experience with developer tooling has been that any
efforts to reduce false positives will help a tool succeed at scale.
Later you can claw back some completeness, but focusing on
completeness first will kill the tool if false positives cannot
reasonably be dealt with.

From the user space world we know that "assert lock held" [1] as this
kind of escape hatch is valuable to deal with cases the static
analysis just can't deal with. Sure, here we can make our own rules,
but I'd argue we're in a worse position than most user space code, in
that kernel code is significantly more complex (which is the reason I
spent over half a year banging my head to make Clang's analysis
significantly more capable).

[1] https://github.com/abseil/abseil-cpp/blob/a8960c053bf4adadac097c1101d0028742d8042f/absl/synchronization/mutex.h#L210
(ASSERT_EXCLUSIVE_LOCK() == __assume_ctx_lock())
