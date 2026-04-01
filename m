Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A2236494B
	for <linux-crypto@vger.kernel.org>; Wed,  1 Apr 2026 07:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775026879; cv=none; b=pwfsLql7HsZgX27X9WJPWQuFdwfqkN4pvr1gkOXkhZxH4L6KiWrHYGe6bpyNu/RkB2uvsLZgPOLS29HAQrw3iJDZ/bOLnWYViCyCnoqJjUj6yS/PEKlxui8sRFov6PjL1UoTYqI4IucKx4CMUjuJOJtCCVDuK/chBUGWwlDzvHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775026879; c=relaxed/simple;
	bh=Bwy9wfZVxlaokc+KfkVhltejvIhjmBP86LTsX8ZfOas=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=iuHxSCFFMUWuH9xc7ZVu80XNZ348NbJSW8qdTk4znta0ES9bPpHJJdk9OrBw0IxCQfBNb0o6inVvVxdtd+WMB8En3ukK8sBk6c2t5vMhIXDFrvutl9Ino8ulouWXp8RKqm8TyeQKvwnP1gHSHtSDrTVQ85aiiktzn2lzPegHjoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4JYGGEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4JYGGEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B794CC4CEF7;
	Wed,  1 Apr 2026 07:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775026879;
	bh=Bwy9wfZVxlaokc+KfkVhltejvIhjmBP86LTsX8ZfOas=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=j4JYGGEcBg7LF3ms6EQ/NMTfsrXfiCl38v9cn3ApM4rvtteVdR/pUF+/v2vJ9nByF
	 +TuWqJwzEHg420L+Vznghf54sQ56O8XZBwL4CYVpHk8I8yswkYoT6HEu2uRAGh2a2E
	 s5aB3ppxLphII3yXnEY6skMdO8VYiFVUBm0jERB9497EJpmGHxxkDkUzsRrZDWZHp6
	 6sYYEUMx9wPqeqToYvLDds4ylUJgijOgzkAwTvDZ5Jdn2pP7dXYpBefO08h5WDSELj
	 4nw+PWzq2jXLw//9+79vpUENeyjs0Ffh9kO8fNpGoCMZUXmW4zLGpXPALWX0iWGcbL
	 zj2nwNTtI9WVQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BC8A1F40081;
	Wed,  1 Apr 2026 03:01:17 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 03:01:17 -0400
X-ME-Sender: <xms:vcLMaVY8FL-o1qcxYn795HpiD7LgdWdCSPSfA53u46BTBgQQgF_dRQ>
    <xme:vcLMaXPIqZg7IRQvwUo6jazmaB_SXir3YUbY5IBi-Qr9HgfMlps0qWMuoE40cgUui
    gROuQg8mSkP7bHQlDkK6ESMkNa48tYKnyoTv9-NYTA2FUFghH1aVbE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvgeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtoh
    epvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgr
    rhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtth
    hopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtph
    htthhopehjrghsohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:vcLMaTBjCSZpfBVI6o_vYGMNibhNdbffHOlv7cVvEUpP8t2-0bqltg>
    <xmx:vcLMaTm7qQPTSk0lQgJWrtcWG7-_3fM7CSv75CsWbizCSHgt8nzOxw>
    <xmx:vcLMaedI4IcBkLT9ktjBs16bBdWxECms9QGFv5gO_n34mxkmm5eI7g>
    <xmx:vcLMaXSPW3HslaxkXbpjEL9_qxZZew-M5ubEsWXcLheJf5GBOyleBA>
    <xmx:vcLMaVsKW_F23UINJL9xdKQhpIVGWW80qxTvgW2mWX2dhbBOjkod3yqk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9C02370006A; Wed,  1 Apr 2026 03:01:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A2hVHX09Hs_c
Date: Wed, 01 Apr 2026 09:00:57 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org
Message-Id: <55da45c4-4f06-430e-a14b-ecfeeb8d22d1@app.fastmail.com>
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/9] lib/crypto: arm64: Remove obsolete chunking logic
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 1 Apr 2026, at 02:05, Eric Biggers wrote:
> Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
> NEON at context switch"), kernel-mode NEON sections have been
> preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
> restrict the preemption modes"), voluntary preemption is no longer
> supported on arm64 either.  Therefore, there's no longer any need to
> limit the length of kernel-mode NEON sections on arm64.
>
> This series simplifies the code in lib/crypto/arm64/ accordingly by
> using longer kernel-mode NEON sections instead of multiple shorter ones.
>
> This series is targeting libcrypto-next.
>
> Eric Biggers (9):
>   lib/crypto: arm64/aes: Remove obsolete chunking logic
>   lib/crypto: arm64/chacha: Remove obsolete chunking logic
>   lib/crypto: arm64/gf128hash: Remove obsolete chunking logic
>   lib/crypto: arm64/poly1305: Remove obsolete chunking logic
>   lib/crypto: arm64/sha1: Remove obsolete chunking logic
>   lib/crypto: arm64/sha256: Remove obsolete chunking logic
>   lib/crypto: arm64/sha512: Remove obsolete chunking logic
>   lib/crypto: arm64/sha3: Remove obsolete chunking logic
>   arm64: fpsimd: Remove obsolete cond_yield macro
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
