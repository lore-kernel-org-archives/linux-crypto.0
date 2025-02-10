Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D38325E44D;
	Mon, 10 Feb 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739213651; cv=none; b=Co4tBqMR0NfxBACCKsq57kO6/dFArRDU5DX+yR978ezSXKRiSbLFb0z+05cUXVyg8Mdcs8y+e4fu29yRHi+Lta8R7LkoGPMmOCsVxZx1fFBzkpF/lPLuI+rh94cJE2uemDH3nINzrGXLAyeXUqDBuD2Mc58Z/Ycfapbi0sOnh64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739213651; c=relaxed/simple;
	bh=lJHeH8odNzMc5QUg2xelDHy7ljydmPauDEjgewx7TQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPc3Do0fL6l8If1PMmZP5tX374sDhT4Cq434rZGvyp9Tys1734Vyk4Wio3OMXKz12eW2RvK7lqM99Di8GyMVP1q5cvfn1o8tXTChERCmO6qd3dCJ1srRh9UY5X+4nmkWQWOyaN7Qazr+C9DYJpoNaejzDlCRkGpgn56jbp6CDKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3K5ArPU6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3K5ArPU6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YsDJK2K8fz6ClGym;
	Mon, 10 Feb 2025 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739213632; x=1741805633; bh=lb5MvhpLjR41b3jztycQhMa7
	6fKACTOTpukAQOD291M=; b=3K5ArPU6dDNNRL2Vq2M9akFR9G2JqA0Oo/cTNdAr
	yQ/vA189YFxHth4ETLBCbwcr3SE98mlT4UTKWylTaRvp7v3DJkf4wXJMEEEHgWQd
	zVv837zB4W4x6QFIsSeGKfbJW81oN5Mwy24wMBVR//4dya6CM/YLP8i5gqGpCT9V
	3zanmo+jPITMKHjlUH38wkIm5Dqp5qg0Y8gAIP8BSpci8qXMM6ulkaDkO3KKLqfV
	1K9LMy+HTHS0ASAiaRYDCPUy3HxENuji6rnHjQzPqq8wtsedXxPsOlFC9HmoKnVn
	uTU2r5dqSqz0s+i8zUfFDOtEYZs78KqKmXW/2ziCJgRwDA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UXKEr8zbt9QF; Mon, 10 Feb 2025 18:53:52 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YsDHs5q4tz6Cnk8y;
	Mon, 10 Feb 2025 18:53:45 +0000 (UTC)
Message-ID: <f5eda818-6119-4b8f-992f-33bc9c184a64@acm.org>
Date: Mon, 10 Feb 2025 10:53:44 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/24] lockdep: Annotate lockdep assertions for
 capability analysis
To: Marco Elver <elver@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Bill Wendling <morbo@google.com>,
 Boqun Feng <boqun.feng@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@kernel.org>, Jann Horn <jannh@google.com>,
 Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>,
 Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-9-elver@google.com>
 <e276263f-2bc5-450e-9a35-e805ad8f277b@acm.org>
 <CANpmjNMfxcpyAY=jCKSBj-Hud-Z6OhdssAXWcPaqDNyjXy0rPQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CANpmjNMfxcpyAY=jCKSBj-Hud-Z6OhdssAXWcPaqDNyjXy0rPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/10/25 10:23 AM, Marco Elver wrote:
> If you try to write code where you access a guarded_by variable, but
> the lock is held not in all paths we can write it like this:
> 
> struct bar {
>    spinlock_t lock;
>    bool a; // true if lock held
>    int counter __var_guarded_by(&lock);
> };
> void foo(struct bar *d)
> {
>     ...
>     if (d->a) {
>       lockdep_assert_held(&d->lock);
>       d->counter++;
>     } else {
>       // lock not held!
>     }
>    ...
> }
> 
> Without lockdep_assert_held() you get false positives, and there's no
> other good way to express this if you do not want to always call foo()
> with the lock held.
> 
> It essentially forces addition of lockdep checks where the static
> analysis can't quite prove what you've done is right. This is
> desirable over adding no-analysis attributes and not checking anything
> at all.

In the above I see that two different options have been mentioned for
code that includes conditional lockdep_assert_held() calls:
- Either include __assert_cap() in the lockdep_assert_held() definition.
- Or annotate the entire function with __no_thread_safety_analysis.

I think there is a third possibility: add an explicit __assert_cap() 
call under the lockdep_assert_held() call. With this approach the
thread-safety analysis remains enabled for the annotated function and
the compiler will complain if neither __must_hold() nor __assert_cap()
has been used.

I prefer the third option since conditional lockdep_assert_held() calls
are relatively rare in the kernel. If I counted correctly, there are
about 40 times more unconditional lockdep_assert_held() calls than
conditional lockdep_assert_held() calls.

Bart.

