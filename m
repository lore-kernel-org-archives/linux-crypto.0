Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ADD24C66D
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 13:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739282159; cv=none; b=m3/W+4XUNPyswR9dLy9GHVti/RRw9HBHihdHfdtucBVlV2cHHgMcHdEYysVzUy/sPshSGceI7U2PD+OUHdVy7CpTvSKaY5ph35cNPmoB1ZhWT94vaaBCadAB3o555Fz7axQ9yCzo5T+C0bgxcfSicltjedjvL0r0y7afXveIabs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739282159; c=relaxed/simple;
	bh=tvddLOD38SbA+nE14izQGPNoMlGp5ZWiCv7xIdyaTR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XdlNxB4YIsfcf6KknIJpsTp7kKMhJhObirMg2WiNwrHY2tvYVxqb239A4G/ESNXlHEivw5yZlXMHwBrAxwZkyPNOSgHBhuYBypTyRloJwzyf4uPIHhp7PwyRqYW3NcADkrhzsAE32jATBPJ0su18IpAfJdIhof7JuIuLt65JqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LjEEbJVK; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LjEEbJVK"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f44353649aso8177567a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 05:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739282157; x=1739886957; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AhF+JZnbICstMQ4SyijmaSYDsITfNwFybUAYOWyiZXU=;
        b=LjEEbJVKsnr9/Bsf8TZWXbIEH1ixlpJK61YR+lS6w6zVvRx0ZMR8sUTqELQhPhYvx0
         g6F8Xe/usYq8l/6WOpRHuk63HnkmtvH6PvLGsgcpB+9NeHgdaGSBIJq7nbE9ilO28O3R
         g3w0p4vW/9Pggxyymt7DJIK4Hpcvocw8jjphJjx7OaqZAwzzfqGCiK52B5fxCqrBWDSn
         JGYdvodniqgfzB9aSif2AxWUg746i+Z5vsZbd0bmnP4JxqvmBMgVZuEuui9KQ0lE1efb
         pciajeEA29strUtEP+X4Z67WFSHVxbszxRS3WwB/ywXHhenuZtNgHUZJIRZokwpsrs7K
         sNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739282157; x=1739886957;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhF+JZnbICstMQ4SyijmaSYDsITfNwFybUAYOWyiZXU=;
        b=HbSsDAh3MmkjX01Zxo+nrT+g36e+h9chUiedqrFNDNV8uGLv3wd2WjXJpd96ESY0UB
         m0+BtBDSwhZ01eWFLu/UZPHufrNpiDlPzzJvX3hGUuSmaFiSkAYCCq/vFAYKjx7IoxV2
         CtWdxKphjyN+4V5hBNMRqCmkoYf3+pb5H/7FxZQViqxBeLk8KAZLMeBquReSB5Gw3anb
         syO3V+JlmfSGTrbi3omLcYpKGQ+SsCQpK5zY5dALu0K2PAhRv5BhTxGM2bz6d2VFR2ir
         9D+kqyjQ1Hu/aYRsxSbvaaDGbmu0+rAI4F54wDC/rHvPBtpFAr4ou7U26oC0c+EfEmu/
         wmhg==
X-Forwarded-Encrypted: i=1; AJvYcCU76XaeetViwj0GVWvgLcms9tIBC9sS8+dQ2mufEDl2nvJfBLVnN4wGozeA3kgPOtrDf2IibIpOLH/yqMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFWgC9/5FOnJLOw1btGeMZvXt9z40x/NjvyMRCTSSBUW4bIqRb
	YWrSLctCcDOAe42irP9ETDmKQdDT+5aLqtldTqc5BR3riSPRARfz2m3StDSQbXVzoVxzOYtqwzV
	/OBQpFlnGkAdNoKsPztIpXkCFsYfudIJtQlVZ
X-Gm-Gg: ASbGncvPW5F0kjV4tKArBWghI04LNa+o95YG1o7VZWP5WUUi3Kt2WjFrgcw4CQgH2Y4
	uB8+9YrwxHCt37seTOxalzZTynQj52hEejLqSDHXAx4n7/uDV7RXToMhkTqWmx5R+/bAoym5Wb6
	5jIP5QMEX88yAP2OH/ADSkCLEmrrY=
X-Google-Smtp-Source: AGHT+IGroUNVHpMBAUy/bObZea2jE/snBP4iAn1fJ0F8Y+yGqofcGPH5OOKF/rW4Qwm5mzGvQOH1DLn2V2e6J52emRE=
X-Received: by 2002:a17:90b:1d45:b0:2ea:5e0c:2847 with SMTP id
 98e67ed59e1d1-2fa9ee17fb8mr4391611a91.22.1739282157250; Tue, 11 Feb 2025
 05:55:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206181711.1902989-1-elver@google.com> <20250206181711.1902989-9-elver@google.com>
 <e276263f-2bc5-450e-9a35-e805ad8f277b@acm.org> <CANpmjNMfxcpyAY=jCKSBj-Hud-Z6OhdssAXWcPaqDNyjXy0rPQ@mail.gmail.com>
 <f5eda818-6119-4b8f-992f-33bc9c184a64@acm.org>
In-Reply-To: <f5eda818-6119-4b8f-992f-33bc9c184a64@acm.org>
From: Marco Elver <elver@google.com>
Date: Tue, 11 Feb 2025 14:55:20 +0100
X-Gm-Features: AWEUYZkwbHjIdQKR2hqck9okMpxl0TDfWkkc2sBGpPLWquXQ8_lyXjiGcdcjlSE
Message-ID: <CANpmjNPxyWey6v1tj6TwtN6Pe8Ze=wrfFFjuJFzCQTd4XM8xQA@mail.gmail.com>
Subject: Re: [PATCH RFC 08/24] lockdep: Annotate lockdep assertions for
 capability analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, 
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

On Mon, 10 Feb 2025 at 19:54, Bart Van Assche <bvanassche@acm.org> wrote:
>
>
> On 2/10/25 10:23 AM, Marco Elver wrote:
> > If you try to write code where you access a guarded_by variable, but
> > the lock is held not in all paths we can write it like this:
> >
> > struct bar {
> >    spinlock_t lock;
> >    bool a; // true if lock held
> >    int counter __var_guarded_by(&lock);
> > };
> > void foo(struct bar *d)
> > {
> >     ...
> >     if (d->a) {
> >       lockdep_assert_held(&d->lock);
> >       d->counter++;
> >     } else {
> >       // lock not held!
> >     }
> >    ...
> > }
> >
> > Without lockdep_assert_held() you get false positives, and there's no
> > other good way to express this if you do not want to always call foo()
> > with the lock held.
> >
> > It essentially forces addition of lockdep checks where the static
> > analysis can't quite prove what you've done is right. This is
> > desirable over adding no-analysis attributes and not checking anything
> > at all.
>
> In the above I see that two different options have been mentioned for
> code that includes conditional lockdep_assert_held() calls:
> - Either include __assert_cap() in the lockdep_assert_held() definition.
> - Or annotate the entire function with __no_thread_safety_analysis.
>
> I think there is a third possibility: add an explicit __assert_cap()
> call under the lockdep_assert_held() call. With this approach the
> thread-safety analysis remains enabled for the annotated function and
> the compiler will complain if neither __must_hold() nor __assert_cap()
> has been used.

That's just adding more clutter. Being able to leverage existing
lockdep_assert to avoid false positives (at potential cost of few
false negatives) is a decent trade-off. Sure, having maximum checking
guarantees would be nice, but there's a balance we have to strike vs.
ergonomics, usability, and pointless clutter.

Can we initially try to avoid clutter as much as possible? Then, if
you feel coverage is not good enough, make the analysis stricter by
e.g. removing the implicit assert from lockdep_assert in later patches
and see how it goes.

I'm basing my judgement here on experience having worked on other
analysis in the kernel, and the biggest request from maintainers has
always been to "avoid useless clutter and false positives at all
cost", often at the cost of increased potential for false negatives
but avoiding false positives and reducing annotations (I can dig out
discussions we had for KMSAN if you do not believe me...).
