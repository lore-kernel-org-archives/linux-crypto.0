Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEAA273D6D
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766180954; cv=none; b=uc+kB8AAp3zzAHysne6emaA50E6MdVR5KXwlaLJZ4f/gNhYj1adDay0hFc8EXvh9Y97txWF7Tx27sSN5al4rDSUIZSSGVFeDjnxn3difRd+B+vDbhdIhRf2oXqzaHadIUjogY/Ju5hi/PJsjNftqJdaaOpGJj3stedIvG0h5v30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766180954; c=relaxed/simple;
	bh=k9J0WFzlkYtCk1RXVJs8ICS2UcS46vYMNi/KF0RXH0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I1sskR2pVAHwXjnAW1kWbe8IdO+U2xTvI65KYvxfLHUvzL3OhOh2CDoZibik1XM6SfgmvwWVBsuF7K27xgpr2shdH6BkLerC38DdKImwGpML0SCxjH+qkTwc+AlrTaDumhrYNdG1c0IBHDcaZWQiWEMVB0kmznho7dN6cMVYgtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wxzxqX9N; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wxzxqX9N"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c718c5481so2113215a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766180952; x=1766785752; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NzDuEDjTM8ZWLDMfL/9YFXqkNSYfSWOUAvfjFgQokA0=;
        b=wxzxqX9NTO+ux5QSAcxOM6N4IFypnQhbKmPscGrkLhB0JOtlA75xFwJBn3T/ndKGFF
         dGu73fTDFG1w7J7q09Rt2RIg0RiPTxdyLZAi9Yo7VnX4CCGDbs+Al8VT5I+bWlMi2RSa
         2FbFx4vLCJK8j0nAmNQv4ZuhoB8LqGTKjzRN5XBCWHSTJLbQiVTuCIkipaAoML/6gSY1
         JVw//ZcP0nWpjLQ/CeXnGTPTOumpHJ4dU8U8gMyF3aTjQe321HLJGcUCIclL0o8h2+BZ
         7p+xcyKOMxVFgvpAYQBtWCVrv8RzLkh0A5kz4oHK0cAt/eZmsHmkQgBgG6tbS+FLp400
         uL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180952; x=1766785752;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzDuEDjTM8ZWLDMfL/9YFXqkNSYfSWOUAvfjFgQokA0=;
        b=vA1q0ni+mTu4SZaXS9kavEUCAKx9swvGs/sKvaKqUdledYA9RG9NlrGiboNWOAUi/q
         LrPPRMdpP7TdbTdnxo7SDtFpcasyqDdiXvYXA2nG1cetZJInhH5pmZGQqhlX3RYu6dKL
         JtbXf2lp5db9jmunBsOm+nfIfw0dU7ttlTSMt5WGrexcrGKTIry6/rkaClPLlIFgL8K7
         1eFvUaKh2pY4x6UaO/fBcZjjXLsCO2+QbwjrDqiapN3NGvf+xi66LGC/GuEifU8ceu8M
         ph0m4JulF9hHv50lgNcRvalRqtqmcYGp06/GvGkw4iHpoHY3/gMOwTDHs2FKhUISM/co
         gAdg==
X-Forwarded-Encrypted: i=1; AJvYcCUg90c5VEI7CN1dgU1tZL5bqg4yTCtnhj0G65f0wPXats8385GOxrkwJblR1EZWyP34YY/piOqz4DpeplU=@vger.kernel.org
X-Gm-Message-State: AOJu0YygtcIuar07m6mokYDdxYPZW7kOt0nc3jNzXattQMJ/26jrcbvX
	XwHU3iXwEe3kATQxagk7FQPqu8H1XinaBvVoGIF2mgqqUS1pSxVjHMH0PH5OzRyzHKxHatWkzq4
	4k7QpyEsE/pLVwWk08WCxxmtjOmlRiAebqRpklzG5
X-Gm-Gg: AY/fxX4GI7IT3H+Jjq9jAFQbFcEwVaBH45mRXzpOQ0sTgqzvizKdDCtQ0e4WU2LGGW9
	K3sqspTbj9UfQLHM26rKimkGSfSQZuuS8zha7s7nW0PGWQwiXxCgjueCLVe8W1qUl89OQ6ku9gL
	zm4e+MLQpKmzUGOCyDTXnKceLyHri0JRqiYm75eqHV+eAor80f/q7jmzqAA9Oog9rdjID1JE++e
	XUXLpzBtZlSDdq3uzkk9EBD4Tvu3uvCF47fzvxEbE/5UPVgdMTgrT87o7qMzXaPh8+sinYr7b8x
	KvRCcTKcH1Gb3WqYbiXJ4+GHnNs=
X-Google-Smtp-Source: AGHT+IH1wb+RKJ6da97DpXPpqA5MRT8qx5b7FDx5k2pjduqaEcwfYWMMGR5Rn4FLqe1i8Vtg4dzqeBXKvhP326Y4ZH8=
X-Received: by 2002:a05:7022:213:b0:11a:4016:44a5 with SMTP id
 a92af1059eb24-121722de1e1mr5781198c88.24.1766180951816; Fri, 19 Dec 2025
 13:49:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org> <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
 <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
In-Reply-To: <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:48:35 +0100
X-Gm-Features: AQt7F2rGv_yg31bAGJRVSa1c9k6UbjL-L12dGmORxx_mEF1TxDypAURYmp5bQlk
Message-ID: <CANpmjNN4JNG1OSWfGd2fAqTyYQ+Re7Czn796WD-47TwmuECxaQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
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

On Fri, 19 Dec 2025 at 22:34, Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> On 12/19/25 2:02 PM, Marco Elver wrote:
> > On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
> >> On 12/19/25 7:39 AM, Marco Elver wrote:
> >>> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
> >>> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
> >>
> >> Given the "one change per patch" rule, shouldn't the annotation fixes
> >> for rwlock operations be moved into a separate patch?
> >>
> >>> -typedef struct {
> >>> +context_lock_struct(rwlock) {
> >>>        arch_rwlock_t raw_lock;
> >>>    #ifdef CONFIG_DEBUG_SPINLOCK
> >>>        unsigned int magic, owner_cpu;
> >>> @@ -31,7 +31,8 @@ typedef struct {
> >>>    #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >>>        struct lockdep_map dep_map;
> >>>    #endif
> >>> -} rwlock_t;
> >>> +};
> >>> +typedef struct rwlock rwlock_t;
> >>
> >> This change introduces a new globally visible "struct rwlock". Although
> >> I haven't found any existing "struct rwlock" definitions, maybe it's a
> >> good idea to use a more unique name instead.
> >
> > This doesn't actually introduce a new globally visible "struct
> > rwlock", it's already the case before.
> > An inlined struct definition in a typedef is available by its struct
> > name, so this is not introducing a new name
> > (https://godbolt.org/z/Y1jf66e1M).
>
> Please take another look. The godbolt example follows the pattern
> "typedef struct name { ... } name_t;". The "name" part is missing from
> the rwlock_t definition. This is why I wrote that the above code
> introduces a new global struct name.

You're right. My point only applies to "typedef struct spinlock ..."
