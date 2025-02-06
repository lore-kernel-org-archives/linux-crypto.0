Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D7519AD5C;
	Thu,  6 Feb 2025 18:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738867241; cv=none; b=bQYThlHnuJVvtjmMbVjgOKCuto0NXOrFsxijwIpV7vG6hnTrf2hgV/Ve/XG6sdA3XzbEPMWbVK+Z5MpXbMrFmCYjx25dtzhIoDAMPTZAIKzBUI72UPZkrKYVObE3iz2yMqRxWdkXdulZQ2tqGLJC1RqV/+n9Z+1C0MjVQ370Sxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738867241; c=relaxed/simple;
	bh=M8bEQYxFgIZXGc3dK28iqCXF28r3p8omn6PZdXy7WdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvHX1nryv8WRQJHuWgiPG7GcTDOgo2WfDY4QcIcJky8ltxuUqYlqwlH6jqPHpzLdy9ljquN6zd/yLFB0+rVG1LItazNbh4VzjCIEBSvCRrxN5EACTZATmACVR1t9ETPaAgBonYqwXrSQnjrDVa5RdmuzaBm66P2uWxTZnsiBON8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gQY7Abju; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gQY7Abju"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YpmBb3nppzlgTwF;
	Thu,  6 Feb 2025 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738867227; x=1741459228; bh=Yyh2TZL3d6MbabLSKwMavcSP
	t1k8xkVlfy9IlZ2yLS0=; b=gQY7AbjukeFYZRvynmv9xAl333JAUREgeUAW39M1
	oI0dt8G0xdTi2bW8TGQDOUOB3ERhjsK+5HE8ji3ptEjVVJOeH5Q1AefgDqjpHTV1
	8diTeX3KUTgfTXQnlsBPFtXrFiRrfsujAwjONQkkyeMYIPfIXNIfrn7M/+SbHi6F
	qGK04lxZ2wOjgQXU+WnlaE1Xgj8sqmlSEKL5mpJygasHIIYt5NEp90jvbqUd9efL
	x622wzdVmIjhfjIbfTSKXa3kFU9nKsVFNE5HsFWLOL1fbuLkxCCXqT6rLuomqLeV
	xLpuDIknhfbflWYpCvplOPSYxi+/GIVHDbJXZl+Gjgvb2w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MKbvYFl6_0ku; Thu,  6 Feb 2025 18:40:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YpmBC6m3KzlgTw4;
	Thu,  6 Feb 2025 18:40:19 +0000 (UTC)
Message-ID: <552e940f-df40-4776-916e-78decdaafb49@acm.org>
Date: Thu, 6 Feb 2025 10:40:16 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/24] compiler_types: Move lock checking attributes
 to compiler-capability-analysis.h
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
 <20250206181711.1902989-2-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250206181711.1902989-2-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 10:09 AM, Marco Elver wrote:
> +/* Sparse context/lock checking support. */
> +# define __must_hold(x)		__attribute__((context(x,1,1)))
> +# define __acquires(x)		__attribute__((context(x,0,1)))
> +# define __cond_acquires(x)	__attribute__((context(x,0,-1)))
> +# define __releases(x)		__attribute__((context(x,1,0)))
> +# define __acquire(x)		__context__(x,1)
> +# define __release(x)		__context__(x,-1)
> +# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)

If support for Clang thread-safety attributes is added, an important
question is what to do with the sparse context attribute. I think that
more developers are working on improving and maintaining Clang than
sparse. How about reducing the workload of kernel maintainers by
only supporting the Clang thread-safety approach and by dropping support
for the sparse context attribute?

Thanks,

Bart.
