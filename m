Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E811FAC4C;
	Tue,  4 Mar 2025 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130336; cv=none; b=K/Rt1WXOSPZtlzV5HomKzbAPwr7DMRUl7UUZ15fm07BxpK+hiWCJIRs3m5h8UVEz96TjCqRUpnpyY1GP+nUUyN5MjRyJXxqgLV1ujaacQLGlTWaGBzdQ+7rBi9CeOMAoe/8sQHfk+zWK7k1/muXjZoKrhjBxQJMdbZlekaXMpYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130336; c=relaxed/simple;
	bh=mpfPrnwQOsQJmiUikFDsFQPTsfjsaj5TCdcsQXqznb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dj0XHLbGqCfLMaRPN4rtrK28xuThA67Jt0HDPq1+eLntVeB8kvzHwssKbO0zB+bI8Khvr2iY8AqdSuab9nqUY4Pfd57Oq4EC6KnRiui0ZR6wWfOEMwTGv5q0j/lpSEhdLe3OLus72xRmTEyz5Nu8XzlzgThjXjwhf6NqPIyDgMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zbx3pJ88; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zbx3pJ88"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6s7d4qWnzlgrvY;
	Tue,  4 Mar 2025 23:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741130328; x=1743722329; bh=mpfPrnwQOsQJmiUikFDsFQPT
	sfjsaj5TCdcsQXqznb8=; b=zbx3pJ88/aWm64lt0xisI+0VCQk4V09O4xlB+sta
	trlSC5q5vjZg+uz4GPATaUFuPyg9EgwMyVhqBUPX7wsN/dArDDwDAUDx2QTwZcMd
	oNzD97BbtjGipc6Zd3HYrU6zn/2T7SfyGpgrEoLKiySM4GMMUST688cWJXKo3YyY
	9rtd8wDYqq0kcHVRiqBRyMAxuMLBwNq/Oz/vqJd2hDCmi2kBNLDTxx4VUs2cRpxu
	mmSD/4e+7WOvKwecYG5taKU8OuvAyZVSS4TuZjpfO4MBBCFLWFcEnEWTx4zBZtTB
	indcGU6nlcqWzZ948MkUhbtGEBu480OKenQWuA+h1oLDXg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lKQjTibG1Pt3; Tue,  4 Mar 2025 23:18:48 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6s6x5k59zlgrv9;
	Tue,  4 Mar 2025 23:18:16 +0000 (UTC)
Message-ID: <e51f4cb5-836d-4c6b-8c30-fef0501b1257@acm.org>
Date: Tue, 4 Mar 2025 15:18:15 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 34/34] MAINTAINERS: Add entry for Capability Analysis
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
 <20250304092417.2873893-35-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304092417.2873893-35-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 1:21 AM, Marco Elver wrote:
> Add entry for all new files added for Clang's capability analysis.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
