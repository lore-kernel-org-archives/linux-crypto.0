Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843991AB6D8;
	Fri,  7 Feb 2025 20:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738961930; cv=none; b=EncQPJtEzDZUVW2y2DqnYUzkCeGjBhzJlmOGu1GAHxUujkmLqK9U5Ikw7s+/8MO0Xc3XAUOuDixvF7bnhlWA1M5Qtruo+yCFPPB8YicZQS0LtEl5eAVOxRis+t0kz+xgymbPVd9Wn2DgZgdDq/+EOYO8DH4HARy0zSPjJEU5YHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738961930; c=relaxed/simple;
	bh=xAwZ9HQ5MAYCQ2LR1z5gYPvNqDl0kPb5mILIXPxKDY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XSjs1730Y0Scu8t/TGgh54GonDgLK0NhS26sDS8n9S2tKS85W921BhKd8U/jZLHFxMDWCPhGVGN/cdtdTiNx/flKMMd/zOQ1wAckbhw9OW9vHK/UVkBAPrp5gy40fNaMEGexpo0AVMYQVGXnyI2OGhGqA1uFa5fwdr8yfRoXfGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VacKsLnk; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VacKsLnk"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YqRCP5bPRzlgTwQ;
	Fri,  7 Feb 2025 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738961910; x=1741553911; bh=cPoTgIZpKmlByO7NU1gC7bDa
	ucVwG90zqII2j1CUOIQ=; b=VacKsLnkTdDYtPmt5J4MPD4Qx4KqDnMmmqgENTJ6
	EtGKhhNCL3FbJzNKd+ETkPPQM7+k0i3yX2iW8q/3iMGik+SUc/EL6VtGWa/NeKJN
	Xf+/DVOiqp671Tk9LAbh+uq9jSBWZPDCH6WEM2Pa99LrTCfC/C87dWCgPe+7K9Xk
	fMbRKCIgv980B/wIrp69eB1ri2/70yj+HAHygqGUrxfkh47z6ndhXJmkhf+Izy1r
	tAkHcBQg1sSGNalB0ZQLoJflY/+OnefFs9gkD6Te4zEZ5jQ7crrhLu+66NEMH6Yj
	Xsf+d717IbvZq+tYBbHv0evOn2tmB661eFAH2wyxXERWAw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Wva0VBNH7R1P; Fri,  7 Feb 2025 20:58:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YqRC05LwRzlgTwF;
	Fri,  7 Feb 2025 20:58:20 +0000 (UTC)
Message-ID: <38bde2a3-762d-49ed-a2a6-ac3bd698bedc@acm.org>
Date: Fri, 7 Feb 2025 12:58:20 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/24] locking/mutex: Support Clang's capability
 analysis
To: Peter Zijlstra <peterz@infradead.org>, Marco Elver <elver@google.com>
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
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20250206181711.1902989-1-elver@google.com>
 <20250206181711.1902989-12-elver@google.com>
 <20250207083119.GV7145@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250207083119.GV7145@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 12:31 AM, Peter Zijlstra wrote:
> Can we please fix up all the existing __cond_lock() code too?

It would be great to get rid of __cond_lock().

In the description of commit 4a557a5d1a61 ("sparse: introduce
conditional lock acquire function attribute") I found the following
URL: 
https://lore.kernel.org/all/CAHk-=wjZfO9hGqJ2_hGQG3U_XzSh9_XaXze=HgPdvJbgrvASfA@mail.gmail.com/

That URL points at an e-mail from Linus Torvalds with a patch for sparse
that implements support for __cond_acquires(). It seems to me that the
sparse patch has never been applied to the sparse code base (the git URL
for sparse is available at https://sparse.docs.kernel.org/en/latest/).
Additionally, the most recent commit to the sparse code base is from
more than a year ago (see also 
https://git.kernel.org/pub/scm/devel/sparse/sparse.git/).

In other words, switching from __cond_lock() to __cond_acquires()
probably will make sparse report more "context imbalance" warnings.

If this is a concern to anyone, please speak up.

Thanks,

Bart.

