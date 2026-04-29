Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BBEBA34;
	Wed, 29 Apr 2026 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777497104; cv=none; b=OrINyUmop6kBrCEjKTNLBijkS3QQ85uzykRXNEpZrp0wuZz+1LAinxBPXAI7yfYUSirLk0a9oLqVGhzAYeE6TtJQnzpe90EyBJjtBcprPq9iWQbT0GUMZwJoLwGnMK1iQIQ3sAkyUvaUND8wiC2yJw5hufpLCrsXDBYRgYt5Vh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777497104; c=relaxed/simple;
	bh=MRSJho1zZoNjgvRjTorbWpBPzXTaPpyCP6FGZl9fLEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmgDaoi9wSokx++M1Fx3ROfsPu5qnyTt1HHYYM6xhB66yC+FOyGRJ5yV5/8zEJEMV7hqzvqrWXOK3jxsD2eC1cqo4/p53rt+RsngHlJZpVLvnuA5H56mS5GuoUHiL9SyXmaxrKdmp8K0/GmBxqdI8fMMy/UGMpcf4fbEISJ2iVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyPxQTtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyPxQTtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C342C19425;
	Wed, 29 Apr 2026 21:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777497103;
	bh=MRSJho1zZoNjgvRjTorbWpBPzXTaPpyCP6FGZl9fLEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyPxQTtBnD6hY9ZQifbdFDd1MdEbZnqfpvN2xCaJd199Vhs3N44ytaHP4HY89l2sp
	 UySOr4Rh7YggJu7K4msWINmI/TeeQm4nBR3HQkmG7X6QMgeTMpidUtIkVdqPvS+98E
	 xqTB7c7gl2fFFpeyyTZ1pOyNmy6x3qiD3wIV71lwYGD4vJl6Uslajv5sZlBVCecB58
	 KjVoGWvSbQjmCW+VfgzjgXxBKkhru0Dd4eWuVvQL1MXXkuDwCIQFgLR2w2ShXMwbjb
	 zijpctcS8JR2xyHCnymIPVPGwMHuaM6ksQwwi5d56QNaCdfZ8aKEU5W3cIodEaDVrH
	 //D+jRJUcgVJg==
Date: Wed, 29 Apr 2026 21:11:41 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, edumazet@google.com,
	ncardwell@google.com, kuniyu@google.com, davem@davemloft.net,
	dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	ardb@kernel.org, Jason@zx2c4.com, herbert@gondor.apana.org.au,
	0x7f454c46@gmail.com
Subject: Re: [PATCH net-next v2 1/5] net/tcp-ao: Drop support for most
 non-RFC-specified algorithms
Message-ID: <20260429211141.GB621449@google.com>
References: <20260427172727.9310-2-ebiggers@kernel.org>
 <20260429185828.1539480-2-horms@kernel.org>
 <20260429194456.GA621449@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429194456.GA621449@google.com>

On Wed, Apr 29, 2026 at 07:44:56PM +0000, Eric Biggers wrote:
> > One more question, on the commit message and documentation rather than the
> > diff: Documentation/networking/tcp_ao.rst still describes TCP-AO as "May
> > support any hashing algorithm"
> 
> That "May support any hashing algorithm" statement has always been
> incorrect, so I wouldn't pay much attention to it.  It also appears in a
> table describing TCP-AO as a protocol, not the kernel's implementation.
> 
> > and does not mention the newly enforced
> > whitelist or the -ENOENT failure mode.  Should tcp_ao.rst be updated in
> > this patch to list the accepted algorithm strings and the rationale (e.g.
> > the 20-byte TCP option MAC cap), so userspace has a documented contract?
> 
> As stated in the commit message, the list of MAC algorithms supported by
> the kernel's implementation of TCP-AO has always been undocumented.  It
> should be documented, but I would suggest documentation improvements
> belong in a separate patch.

The missing documentation is added in
https://lore.kernel.org/netdev/20260429210856.725667-1-ebiggers@kernel.org/

- Eric
