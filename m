Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54410251791;
	Tue,  4 Mar 2025 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130756; cv=none; b=cNiBWrjA6657SupUSarNYzsbhK2Rq37gXUQwpzZK8ZT2o83DYcDrSEehEbbufIXDtOPsIgKdBqR2F0Kq5mbis5n0ANulfxAVlUbdJS0SI2bX7ZUJR0i7L6JSdW69asOfBniMLcokeQki4jAWfkxaR4HzSnYK1OfWm12qwd42Guo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130756; c=relaxed/simple;
	bh=Kn7qVp0mzd6dkXGA461Q0CC0Zi+WOQy1ejDrsM+Tp0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PY0Lu2pVBldCzsg8rcJjVSuswQWUoNAHkuCJXZYJ/UWrcGOcoJoW5olw8d8uZizi5+YMbm97iflV5TWa9SmftpyxP+lcojkILeoplWveIcHMbay5uAftdx5zE1ZyponChc8r2z54ruO7UgosyKCq+agcEvoEwzXq6DXxqsGL32g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oB13Sa1K; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oB13Sa1K"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Z6sHh0zQFzlgrvY;
	Tue,  4 Mar 2025 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741130746; x=1743722747; bh=3qsqsr/Fl+QQduWnOktKAK2C
	k7TNKvdm5JbhbYHImYI=; b=oB13Sa1K9Rm2wdjBfxycPG2tV03DAhLPL+CvoUe6
	iprleQ2kUbK1xtasWsfBz/B8dSDtnwVmd+8j5gfKxLSCjdca5E0Wei5+3saURawR
	5RstFsFSkaUP4iIGbEpxfkbweaCAgs9PD7Ak5+VeZ4kSVzIxC7P5H6qyypirNQfe
	o4c8IEMBwjlMjQDAJwWJZV4b6hooN3lCFD24D3gSIARuOJvSoOOPjkYVlRWPcZ0l
	S4lpbqtIWkU3mt9SgtgoPneUXgwq80FiJ1yLnPdko/HE7v5GR54pCX3HzbvnyhM3
	BgGRV9afkFPNYJsCZsm9e+SBOMqq0KCW4qmsJcxVqPS5KA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7g_uA6NodYDz; Tue,  4 Mar 2025 23:25:46 +0000 (UTC)
Received: from [172.20.1.83] (unknown [192.80.0.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Z6sH14gHwzlgrv9;
	Tue,  4 Mar 2025 23:25:15 +0000 (UTC)
Message-ID: <8a894ff8-8707-4601-b67d-7bf0496e36ce@acm.org>
Date: Tue, 4 Mar 2025 15:25:15 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/34] compiler-capability-analysis: Remove
 __cond_lock() function-like helper
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
 <20250304092417.2873893-24-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250304092417.2873893-24-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 1:21 AM, Marco Elver wrote:
>   .../dev-tools/capability-analysis.rst         |  2 -
>   Documentation/mm/process_addrs.rst            |  6 +-
>   .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +-
>   .../net/wireless/intel/iwlwifi/iwl-trans.h    |  6 +-
>   .../wireless/intel/iwlwifi/pcie/internal.h    |  5 +-
>   .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 +-
>   include/linux/compiler-capability-analysis.h  | 41 -------------
>   include/linux/mm.h                            | 33 ++--------
>   include/linux/rwlock.h                        | 11 +---
>   include/linux/rwlock_api_smp.h                | 14 ++++-
>   include/linux/rwlock_rt.h                     | 21 ++++---
>   include/linux/sched/signal.h                  | 14 +----
>   include/linux/spinlock.h                      | 45 +++++---------
>   include/linux/spinlock_api_smp.h              | 20 ++++++
>   include/linux/spinlock_api_up.h               | 61 ++++++++++++++++---
>   include/linux/spinlock_rt.h                   | 26 ++++----
>   kernel/signal.c                               |  4 +-
>   kernel/time/posix-timers.c                    | 10 +--
>   lib/dec_and_lock.c                            |  8 +--
>   mm/memory.c                                   |  4 +-
>   mm/pgtable-generic.c                          | 19 +++---
>   tools/include/linux/compiler_types.h          |  2 -
>   22 files changed, 160 insertions(+), 200 deletions(-)

Should this patch perhaps be split in one patch per subsystem (mm, 
iwlwifi, rwlock, signal, spinlock, time)? Would that make it more likely
that subsystem maintainers review this work? Can this patch be moved to
the start of this series? Anyway, if others are fine with this patch and 
its position in this patch series I'm also fine with this patch.

Thanks,

Bart.
