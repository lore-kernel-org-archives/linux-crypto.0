Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19130BA2D;
	Tue,  4 Mar 2025 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132367; cv=none; b=cUmgiM7hA9VVPUnBzikhFxZPtOYR9/MqDUiXiArkhrfTsmxrCYky+ZzsukjADT2OEZlSuhIh4TKhhSZCYKt6m+8NHIX6P0vRYOOmzY9xLWpg7oWQGZcjwmVmcaRY3mup3omnogd+aYj+6wc9KfooOCWcBY5wHNM2dKvCGNPzqUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132367; c=relaxed/simple;
	bh=GzAWcRX8mnhoy6yRVM2yOlxSf1S1oVBL6EeNjpBBZXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjGocBPxpAG8rOqyC6jwNmWKW6awpIvjaaWbRjf1uJwpgwEt034jVK9VngWpqyvHDdzIKDF5Hynsx102LjK3fvNK3JDWmChi+hiGfe6wJYHhJSZNqAB1StLqcE+DQuD2riWAmASaIexNkhyHhk7c2SfMSxHSuCz1CYlMRWKiHus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4sw8nYkh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4sw8nYkh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6stj0T4SzlgrvY;
	Tue,  4 Mar 2025 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741132359; x=1743724360; bh=GMUyDP6N1T2OZYC0PjNUXiLu
	v++Na4Olt6GZl9AIPwU=; b=4sw8nYkhaUEoGORzhJxVvAjHU1kyb2RGNRxtDfQw
	c+G7yier0o5K0TbZh73+BUqMRzG397oIgrZTzi0NmPRT96cSuBn4yKGGihJQp3BF
	tKPlSFgLHNERJ53xf9piyxjULnOXdrbJgMDbCTu+/JoBDxNfs9L5WavRIfQ5VLWU
	a6HM5S1iFwFXqwgn2f9s98tdd3GRKkHHcTu94WJVQJguR77pEkSwuh0lsD6kuz8T
	CEMVlwLJOjwbc5F52M0pQ8SKtnAX5qYTjGvxj9wS9xF5Jfuq6pN83z3fOIYe2aAN
	I/8Pqi23m9B/8+ScDhKPflojL8YU8I0FetyfvYvWIlf42g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f2biFBQdsyo0; Tue,  4 Mar 2025 23:52:39 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6st14hQLzlgrtN;
	Tue,  4 Mar 2025 23:52:08 +0000 (UTC)
Message-ID: <41a14b09-9f09-4abe-8caa-89cfe2687562@acm.org>
Date: Tue, 4 Mar 2025 15:52:07 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/34] compiler-capability-analysis: Add test stub
To: Marco Elver <elver@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>,
 Waiman Long <longman@redhat.com>, Will Deacon <will@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org
References: <20250304092417.2873893-1-elver@google.com>
 <20250304092417.2873893-4-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304092417.2873893-4-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 1:21 AM, Marco Elver wrote:
> +#include <linux/build_bug.h>
> +
> +/*
> + * Test that helper macros work as expected.
> + */
> +static void __used test_common_helpers(void)
> +{
> +	BUILD_BUG_ON(capability_unsafe(3) != 3); /* plain expression */
> +	BUILD_BUG_ON(capability_unsafe((void)2; 3;) != 3); /* does not swallow semi-colon */
> +	BUILD_BUG_ON(capability_unsafe((void)2, 3) != 3); /* does not swallow commas */
> +	capability_unsafe(do { } while (0)); /* works with void statements */
> +}

Is it guaranteed that <linux/build_bug.h> includes the header file that
defines capability_unsafe() or should that header file perhaps be
included explicitly?

Thanks,

Bart.
