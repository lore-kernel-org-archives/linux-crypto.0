Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E762780F3;
	Tue,  4 Mar 2025 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132678; cv=none; b=Uj0kugWEbX2Kd40rarLDgnQm5p3ZxuyHzTK6DJNx/yvqhf2S1JdYVe3jIqXMhohyg/jQBSpGjGXSCURvzDxS3rbZAKSC90+uLzgHNaaa9NttNK7Ps2PxszfWhp1y8d9p4Qe9jRwpQnKl0G7YeSdhAGaf/U78Y1yghqyVep52eec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132678; c=relaxed/simple;
	bh=4McxKMF62VjEK3ut4lduNqPf3C1DP3PVLOXSXMdGbfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=siSYMKWO9GksCwS0+x755bgtFwNcXHlNbcCAgw+Av/sNh+eS+dSXtHOalneWk7ibhi4pga0BXr/nIxRKA5PZaKpacUwS9U9JqTopDO41S7YqLCCw+YooOB4bc3qRNXXuzPjJkyg8kcl/EyKYbsojtP79SSa0GwI5ghq3NCbZULk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qqoYoMyB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qqoYoMyB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6t0h0vB0zlgrvY;
	Tue,  4 Mar 2025 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741132670; x=1743724671; bh=4McxKMF62VjEK3ut4lduNqPf
	3C1DP3PVLOXSXMdGbfk=; b=qqoYoMyBHVEcDMNVTCouq3hF+nsCT48DBMIz5Baq
	VCDAEXiCU9AbPaEls8Hm3Na6O6ym50iawu3rOkOFIgtdroAZiqUEi+vSrmZPizXK
	gIxo7Hllokqnl2QlNNTtcxO7EltAFZKC1C4QpbdC+v2dPOgczJON3NvQTrjPiTEl
	XCCJx1zRFBPhIaRCiFY0LHQO+N5+vr7nBL0nJZKDfhdueg1jeb7PERp3gNolegYO
	DGMdm3Cgwnkyg+r+p1JHe2QHkoec+2x4IJIQ/S1nI76AbB3zqRgbr2wyE7rIqHki
	bqF0RNrXbcGkIP6FH3aOi0npqneFCOAjnqNAcBhPQh1jbg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KN14XilGcEh4; Tue,  4 Mar 2025 23:57:50 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6t010HfGzlgrvV;
	Tue,  4 Mar 2025 23:57:19 +0000 (UTC)
Message-ID: <3d18d4cf-65bd-4623-bc23-1a0ae350e29b@acm.org>
Date: Tue, 4 Mar 2025 15:57:18 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/34] cleanup: Basic compatibility with capability
 analysis
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
 <20250304092417.2873893-7-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304092417.2873893-7-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 1:21 AM, Marco Elver wrote:
> Due to the scoped cleanup helpers used for lock guards wrapping
> acquire/release around their own constructors/destructors that store
> pointers to the passed locks in a separate struct, we currently cannot
> accurately annotate *destructors* which lock was released. While it's
> possible to annotate the constructor to say which lock was acquired,
> that alone would result in false positives claiming the lock was not
> released on function return.

It may be worth mentioning that Clang's thread-safety analyzer not
supporting alias analysis plays a role here. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
