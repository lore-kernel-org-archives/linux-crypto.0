Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCF23535E;
	Wed, 27 May 2026 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779846028; cv=none; b=B/aDKZZnfJIL6m+FAlcKVflVfALEsbiJIXcvzf9eXt1OPHX6ykxOJmUsWzzwxFtCnaI4nHS2COjCVX3tdotewGedIYJgSyjHSvDmtDWXoCxtH1Sa97fn6wy3odddoitFF7KnxifXa0pgvOtoJBLflKJLLpV/jZ6gu9eayuck5bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779846028; c=relaxed/simple;
	bh=3MUBBPppyO0fH/F3MIaALrwek2Q97thIaEAQ5B+cKYA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qL2ffsEjF+i931W/1UCvsLm4LlkLrARE0y33YKBvI/P2CJMMENJm5p1MFyR4T3APKINSpc3Td4s0IMIevbUPkhNf1jHdVJAAAOqUdvDNMTGp3cex6VdD3jV6rHoS+sEyVcN4LpTyHF9Trx2EPIHrgp6IjYzweR/8vPFH8+baWxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaSlg+qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaSlg+qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604B71F000E9;
	Wed, 27 May 2026 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779846027;
	bh=k7APhuaYn+BJj+G8pdfSIyx/xH1eGaLzG4YtD0OwtPg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HaSlg+qimU8q1kQ7AE/GGxz+RGhvpNsO+GUGBwXE4Z5UEtAT6JlyIacLBE7BVuo1x
	 g5rrWFWLHmLoirH/+CQ5Vnh5xJvINDkydgK14Bqd4WItdRLWEMVeJ1MiSRn2RMACjf
	 AMyOMHuJcNM+XDaSIdIPHWN9H/pY4bJ0NBshse3V3XmTPyI6usqvRp2cBfwFIBSZ+G
	 NLWiUE8CcyyOhxhIyUbL6i/OT9T+X8nN8P7LxeE/HQlqGkeny4uXidwpe14ndoKsNb
	 fdTB73jSvTpG1EvEXr2DIGSbyaN09e2cUSJa37FoJB5j5FzKd+gKbeYjWPPY9JipHQ
	 ko85lM5WD4T4A==
Date: Tue, 26 May 2026 18:40:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Demi Marie Obenour via B4 Relay
 <devnull+demiobenour.gmail.com@kernel.org>
Cc: demiobenour@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, Simon
 Horman <horms@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Eric
 Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
Message-ID: <20260526184025.0ca0e979@kernel.org>
In-Reply-To: <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
	<20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 23 May 2026 15:43:02 -0400 Demi Marie Obenour via B4 Relay
wrote:
> The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
> It can be removed entirely at the cost of only supporting synchronous
> operations.  This doesn't break userspace, which will silently block
> (for a bounded amount of time) in io_submit instead of operating
> asynchronously.
> 
> This also makes struct msghdr smaller, helping every other caller of
> sendmsg().

Acked-by: Jakub Kicinski <kuba@kernel.org>
