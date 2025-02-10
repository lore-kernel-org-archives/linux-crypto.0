Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911325B66E;
	Mon, 10 Feb 2025 18:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739211038; cv=none; b=jh3LYO3Z/d5YeC5BIp/n476M5swDKOnVDhKWrgtUKIbzdVnN83p2olUdovNDbV3i4msr6CCfyBmsBXHgvzerzJQR80WvkLqPihRm9BoslVeJy3UKPYGVYJfjhilsxv29OF1UNsfgQx5cRf5EaFpzUF+7Ge2i01BcWjh/N0/dMlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739211038; c=relaxed/simple;
	bh=QCydUMBwaRsSOEGW5fhHh5FWsbHLXC5hIhgJjIbSnJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7TvGThgp4nv9J9yilNoia2ZvFHABzG5rZAxKXFJNCd/CqKVDzthFuM8rFXl2QKRWMfsJ3U8WT4atvprCQReiqmmOw6XaH8A7KPRNFvABpdNlYzANcDrc1ZJnSm5QXfJSmD5mvcTxAHJiyBpzZGqBkR+ljaya0zetPcIrdfUmT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qzADi6ZF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qzADi6ZF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YsCKy1Kt8z6ClRNh;
	Mon, 10 Feb 2025 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739211013; x=1741803014; bh=5d4NYfy5d24mQ4QZnrsHA0r6
	Om6Ygst0euippVvDqVE=; b=qzADi6ZFFLU6Af+cOra73jCVUrOlDcplHnonVv41
	624xPheX0jFtJvVm8kifQIM+nXVw1C89ak5I4hDbcT5Awspe5D1EkeinkOHm9VfK
	hM5PxhVWZRKn1hZb1qakWu4kx1xc6L6XGw0VwWBxWi092vad6pLrpgDUqA0SC/qX
	f7LBLRGZCI37sGh+Vo/U9LXhsrG1KMKc2QtqihbHMTlbgunhJFgFYAGI+xZVN6xZ
	x+nxQeZCEbHmprGNJjtarzQdtP5xQeUJrSyubFi0TexD3fv0qx2X7kM/2cibheRo
	/9jmZprEZB4Ob0e0p5JyfXqfVwosqw7V+DY7CcMyXD+XdQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vKI5VGS4czNT; Mon, 10 Feb 2025 18:10:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YsCKK2JxDz6ClY9g;
	Mon, 10 Feb 2025 18:09:56 +0000 (UTC)
Message-ID: <e276263f-2bc5-450e-9a35-e805ad8f277b@acm.org>
Date: Mon, 10 Feb 2025 10:09:55 -0800
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250206181711.1902989-9-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 10:10 AM, Marco Elver wrote:
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 67964dc4db95..5cea929b2219 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
>   	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
>   
>   #define lockdep_assert_held(l)		\
> -	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> +	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assert_cap(l); } while (0)
>   
>   #define lockdep_assert_not_held(l)	\
>   	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
>   
>   #define lockdep_assert_held_write(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 0))
> +	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assert_cap(l); } while (0)
>   
>   #define lockdep_assert_held_read(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 1))
> +	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assert_shared_cap(l); } while (0)

These changes look wrong to me. The current behavior of
lockdep_assert_held(lock) is that it issues a kernel warning at
runtime if `lock` is not held when a lockdep_assert_held()
statement is executed. __assert_cap(lock) tells the compiler to
*ignore* the absence of __must_hold(lock). I think this is wrong.
The compiler should complain if a __must_hold(lock) annotation is
missing. While sparse does not support interprocedural analysis for
lock contexts, the Clang thread-safety checker supports this. If
function declarations are annotated with __must_hold(lock), Clang will
complain if the caller does not hold `lock`.

In other words, the above changes disable a useful compile-time check.
I think that useful compile-time checks should not be disabled.

Bart.
