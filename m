Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD8A1FCF6D;
	Tue,  4 Mar 2025 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130832; cv=none; b=MEaYX5A0gb+jFaFu82pEAtVlZCv15wN4XcTy6rkr9qMYjVu4KtJ20aCZKu0XQE7phGABK/mrNw/4tTQvHv2oqIE2LdX0kHPQvFwLr4gSXGVeTZKR7z7ng/hpeAyD3JOR5P9g6+3gClSJnrlwjK4qWS7RJVf1Y8dQBO1S024msrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130832; c=relaxed/simple;
	bh=Qw5/bGmyQE+iCZqsD3pE7+EFXyCPko6EoYa4i8oEbRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ocSy8a0IlvhdtmpnckWNQ+PTZkyloXT2iMqvvBm2lpokzXI+WJuydb7tURDlC4SieJ+5oftydgLhotw6OYiCfMqOpdZi4L37MBl5aSmNMH7lEqrZeQiAtfHXVD1CY7nwKykgQ8l8sCVhGDiRRbB9eR53iPU20wWV9Dm+h/FFd/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QQMLVPj6; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QQMLVPj6"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6sK93jSkzlgrvY;
	Tue,  4 Mar 2025 23:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741130823; x=1743722824; bh=Qw5/bGmyQE+iCZqsD3pE7+EF
	XyCPko6EoYa4i8oEbRg=; b=QQMLVPj6y/NitiNwvoAUlJI0tohtEFKlioq2bd4L
	D3gIuGjDaWtN+tW6kPagTZ4mHGfb9XF4PluNoqbDOKLG3glBe6wSChSG+AaeZ2rA
	3KVteSrf4kThnmmIjmed2SoBMwIlXUfMwPSGcsRZubnWth4wZCkTaaBzgm1fzP5f
	1xbzxVkYS4fpxkGq+wB1kj36gsA7ufid6z2wJjXYAmlL32rts1lUsCiZH2R0VPgY
	7PDoW/cJHGCzA3TnCUNMKyQiBkIGcZUa8N6bwoX2/N+K7WLDSKf1GalHn6/GjFv+
	jKBIdvBTHmZLDrEDWNeTs5yWo74Iv3HEnUqkXFvBQdr6DQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BKmBJ3m1xUKU; Tue,  4 Mar 2025 23:27:03 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6sJV4Pl2zlgrv9;
	Tue,  4 Mar 2025 23:26:33 +0000 (UTC)
Message-ID: <6c57fb9d-b33a-48ff-8358-cdfa449173a5@acm.org>
Date: Tue, 4 Mar 2025 15:26:32 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/34] compiler_types: Move lock checking attributes to
 compiler-capability-analysis.h
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
 <20250304092417.2873893-2-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304092417.2873893-2-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 1:21 AM, Marco Elver wrote:
> The conditional definition of lock checking macros and attributes is
> about to become more complex. Factor them out into their own header for
> better readability, and to make it obvious which features are supported
> by which mode (currently only Sparse). This is the first step towards
> generalizing towards "capability analysis".

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
