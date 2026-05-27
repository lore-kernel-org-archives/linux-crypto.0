Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86D3ED5C8;
	Wed, 27 May 2026 10:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876512; cv=none; b=c5pvSM3bYwL9rTK3NptSKTp7e8wDf6jTefErZR+ZgPBEeEs8WVBMflyAvTi5A0mDgSg/3AwhewucuumIXA6tUx6FrtTARAT5zyTkzVB+I29qHHxlBcjzBorcARGP1x8zoJT5Iv8l2TiiG9N7taq1RhQjzoLDhWfOGzr2RFjO5Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876512; c=relaxed/simple;
	bh=7Bwdl+lRo1o4SDfnm78z+Ky9F59wDAn+QntQxboCuCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8mTJdC+X8rk8Hov2ijjqGv7IAtJnXKoXrTs504y0aSkYWR/SFTQ2i9heJCkh6Zx5H+SAHOKzLuOVT55en2CsCOqz8fVBHhkDU2Z2Wfkd1lF7/Cok0q+FFDXcQMHBE5DCmdhD+FXYOb+x3FNaW8Ffq/gVF8gYxIveTvQGD2Wbog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWf39Rvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWf39Rvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07581F000E9;
	Wed, 27 May 2026 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779876509;
	bh=rIpiJo4iCvjtRLJCUK0kvO6KWTuUncctdjuI6Z6+PQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KWf39RvxLmV0Nl+vilSfwl74YjQVWACxnTiCx26aUEnrVpysov1woI1ljZ4EzWiEj
	 O77lDsCAYY4natY2LkN9j/GTMgByYhWJJVmkx313bM2kkmuoDwcdv0Cy0SDQaTnKwT
	 FWqBcTOn94EmVWgTzreCduP7PpjwFiiDOAflX+ojBb8JFCvQDo40Wp343CI/zD9AVf
	 VXZFU0Wx6T7z1y4YJ62BlNIJoRZARcpBPtONaseHqRAw1VyjweXf9nR8+rtsaSbT6D
	 RYuQn1sgnH1Gr8QNc5c7CxtaWU3cGE/+GyehXFvY3X5d8oBb5F+8w3a6k6fS5ErlM1
	 ILpuLr0yq0bCQ==
Date: Wed, 27 May 2026 11:08:24 +0100
From: Simon Horman <horms@kernel.org>
To: Jihong Min <hurryman2212@gmail.com>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: inside-secure: add EIP93 ESP packet backend
Message-ID: <20260527100824.GJ2256768@horms.kernel.org>
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
 <20260523121522.3023992-3-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523121522.3023992-3-hurryman2212@gmail.com>

On Sat, May 23, 2026 at 09:15:21PM +0900, Jihong Min wrote:
> Expose an EIP93 packet-mode IPsec backend for netdev drivers that need
> ESP encapsulation and decapsulation offload without advertising EIP93
> itself as a netdev.
> 
> Add provider selection, capability reporting, SA lifecycle management,
> IPsec request completion, and provider fault notification around the
> existing EIP93 descriptor path.
> 
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Jihong Min <hurryman2212@gmail.com>

...

> diff --git a/drivers/crypto/inside-secure/eip93/eip93-ipsec.c b/drivers/crypto/inside-secure/eip93/eip93-ipsec.c

...

> +static void eip93_ipsec_abort_requests(struct eip93_ipsec *ipsec, int err)
> +{
> +	struct eip93_ipsec_sa *sa;
> +
> +	while (true) {
> +		bool found = false;
> +
> +		spin_lock_bh(&ipsec->lock);
> +		list_for_each_entry(sa, &ipsec->sa_list, node) {
> +			spin_lock(&sa->lock);
> +			if (sa->aborting) {
> +				spin_unlock(&sa->lock);
> +				continue;
> +			}
> +
> +			sa->aborting = true;
> +			found = refcount_inc_not_zero(&sa->refcnt);
> +			spin_unlock(&sa->lock);
> +			if (found)
> +				break;
> +		}
> +		spin_unlock_bh(&ipsec->lock);
> +		if (!found)
> +			return;
> +
> +		eip93_ipsec_abort_sa(sa, err);
> +		eip93_ipsec_sa_put(sa);

sa is the iterator for the list_for_each_entry loop.
However, here it is used outside of that context.

	"If list_for_each_entry, etc complete a traversal of the list, the
	iterator variable ends up pointing to an address at an offset from
	the list head, and not a meaningful structure.  Thus this value
	should not be used after the end of the iterator.

	https://www.spinics.net/lists/linux-kernel-janitors/msg11994.html

Flagged by Coccinelle.

> +	}
> +}

...
