Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E761E21CC6D;
	Wed, 26 Feb 2025 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740600020; cv=none; b=N6lGIrTJQwYy0sd5Q7nHWH8rmZWB32NdmZz79yP8hh25vrX5QbBkoabaxb0fJ1hrmjcivpw/3+YR1q4QZRTT5Nw3XkT7Xl4RHkRBwf0qRgYkaCBeOddkKu3LEofEv3vILEjFTCPwbvFlMZji9cT8jQBBNMMRBOj/SB8Ro2/xOf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740600020; c=relaxed/simple;
	bh=2NZZNRHCN1D1wJBiE7xyhOIwsgdG234riLaTh6G31Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1iX3B/9CkrRvu1bGsl/gp2vLKHagRgOsR4XY6gIyRDzO+ogzK+WgQLbenJkJxVEIJCYUJBm50wjIB28KdeNi7SWzZTWZiNbmU3X+g7n9DaB/XAuQemyjQEiJi+Yap+RYBZM85N2zvyjKHlBrCuC/T9WFvo7KpBmev6Pm3U1tmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bs5zT0IP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bs5zT0IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C263C4CED6;
	Wed, 26 Feb 2025 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740600019;
	bh=2NZZNRHCN1D1wJBiE7xyhOIwsgdG234riLaTh6G31Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bs5zT0IPho7ZJiovwtijGcEwt3DdmOO9LTEEirR9VhizuuoLVhuhzvzU8xitLlRhC
	 m111NfEJmSn4p/cLUL7aMq+1RND0f/EADUUjXODJuU4vA2Wd+weN8keyJDs0YeIc9H
	 fn2EdJEwzUkxo7g5b/ciCpzd0xxLuPZ8paQ2gQX0ueeKoCClJjielKEGecPPLUoxQL
	 QUM5HvSnjsjD4NP3MhkxuaMf2Xmj7U7Iu6Ly7ecLJeWVKVJRA9QlVpC+fixHhKmE4B
	 8FCFOGukkObRVQQ2Q3NIYb4uD2J1yRR07CV4aVa+pFadZlka2hrsLYv06Rv+l40HY/
	 FnoricZTxFoQw==
Date: Wed, 26 Feb 2025 20:00:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: zswap: fix crypto_free_acomp() deadlock in
 zswap_cpu_comp_dead()
Message-ID: <20250226200016.GB3949421@google.com>
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226185625.2672936-1-yosry.ahmed@linux.dev>

On Wed, Feb 26, 2025 at 06:56:25PM +0000, Yosry Ahmed wrote:
> Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
> the per-CPU acomp_ctx mutex. crypto_free_acomp() then holds scomp_lock
> (through crypto_exit_scomp_ops_async()).
> 
> On the other hand, crypto_alloc_acomp_node() holds the scomp_lock
> (through crypto_scomp_init_tfm()), and then allocates memory.
> If the allocation results in reclaim, we may attempt to hold the per-CPU
> acomp_ctx mutex.

The bug is in acomp.  crypto_free_acomp() should never have to wait for a memory
allocation.  That is what needs to be fixed.

But really the bounce buffering in acomp (which is what is causing this problem)
should not exist at all.  There is really no practical use case for it; it's
just there because of the Crypto API's insistence on shoehorning everything into
scatterlists for no reason...

- Eric
