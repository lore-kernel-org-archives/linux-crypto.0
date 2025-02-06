Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF631D619D;
	Thu,  6 Feb 2025 21:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738877382; cv=none; b=Rbn61KiNx4tCYj6SEF8fwmFWOudyogJjXeUCnsGzW3DW8GsQOykHgpaqNt8c2/ilh8YxagaH8iG2wMnfSEnhNtGXXSwJSMQqfgYWYbFsy21Fcrq7cDIiFrQHaNwE+BL93hyRsr+2zTb9WxZn/aUrrKUpgiemhSr285AP8KVCN3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738877382; c=relaxed/simple;
	bh=V+agB2RgEaJE6GABRMSM1kt8oPczg2s4klAFFVYvIO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2tFtRps25n36uk7/OtCcOiXTcu5o+27wVO2bB6M/nFWhzX3KAVCY3wLctrXf7vLDPGuNB7nnqTBXcgku/pAb85DC3ii5sB5zBkh8TVO1IKIwxrF8Veaq/tl3E8qOKmCrCELFnhZyIVmLzT9Kt3/ShPvcv9Qj+XYb+EnamFvcAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yUhEgFbx; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yUhEgFbx"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Ypqxb3yCRzlgTwF;
	Thu,  6 Feb 2025 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738877367; x=1741469368; bh=ygRwFLCUciivthCdQYJVLmlK
	5fpOtVZDy4dVAV/W3mE=; b=yUhEgFbxzsS+oxc9l6BoSmJ8G72/YtxdS8rXiQg/
	fi1Ee/BF9gtkmoU//eiyffo5NnvZPRfYsIS12uvt3MsvcH7o5i3AhGEvdznPwqEB
	ybbD0NcivhuFBcgACdN981oThG2ZrbU+50GqWb5/fqdG8YM50Vy2NY5LMYbZY75s
	qRukSRU0zjIZSj8uPoCFXjq7LtnaS3wHbEWAJ9DyqLJrzPV0VMCwzuaTScE9jxq1
	xJO8/li++bH5ssw8vuYocpKDi8dlegssBKlz7hX2PKg2SDBmAd/JvwlGytu1IFKy
	jAGPlEjN10yccRwH1a1ekeRB47cDSrqNBFl7AVed1lBHcA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NqM4EdqVb7bb; Thu,  6 Feb 2025 21:29:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YpqxB2wn3zlgTw4;
	Thu,  6 Feb 2025 21:29:17 +0000 (UTC)
Message-ID: <4ce8f5f2-4196-43e7-88a2-0b5fa2af37fb@acm.org>
Date: Thu, 6 Feb 2025 13:29:17 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 07/24] cleanup: Basic compatibility with capability
 analysis
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
 <20250206181711.1902989-8-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250206181711.1902989-8-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 10:10 AM, Marco Elver wrote:
> @@ -243,15 +243,18 @@ const volatile void * __must_check_fn(const volatile void *val)
>   #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)		\
>   typedef _type class_##_name##_t;					\
>   static inline void class_##_name##_destructor(_type *p)			\
> +	__no_capability_analysis					\
>   { _type _T = *p; _exit; }						\
>   static inline _type class_##_name##_constructor(_init_args)		\
> +	__no_capability_analysis					\
>   { _type t = _init; return t; }

guard() uses the constructor and destructor functions defined by
DEFINE_GUARD(). The DEFINE_GUARD() implementation uses DEFINE_CLASS().
Here is an example that I found in <linux/mutex.h>:

DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))

For this example, how is the compiler told that mutex _T is held around
the code protected by guard()?

Thanks,

Bart.
