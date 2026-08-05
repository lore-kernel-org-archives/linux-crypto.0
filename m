Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D723C553A;
	Wed,  5 Aug 2026 21:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785963783; cv=none; b=gCxpQGPoInurzu1hSz1F2cBZJOoSpwuisyEyehz+e42NubaOTdM/AS16fl/KzAof2eQR3VhwznSeYo/1itVEpUaVWpaSxMrGKdrT36ea/n6UGQD2JLXslRIsirKJLB0Q4pRNX6OAjnUyoLnmVrAUJ9XAZJCxqLr1vbsOXLAigMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785963783; c=relaxed/simple;
	bh=LMdYLlZL+CVGccdyTJ0bY2lMW//xkuB55hgbYwiwdM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJvaSG5zTdg4/2U0oAXnLKd3GhQCi9+FDZTxetqQfBMx+rQIdfZHcyvqTmb9JAhfXhnbHYXYZTY20BAzQ0IWSrUPNIg3bnGZPfycTpYmed9Zy63xxsitWOHvCDMsGr2H/dCCsfDCJqfS8uY2Ts1nu+E+cdp+EIh6wpxh57jbH+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0QTtP7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0QTtP7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F41F000E9;
	Wed,  5 Aug 2026 21:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785963781;
	bh=SxvK5a03FJ38wuKC1pxvo0LtEV/wyHVsi85zctMEBuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b0QTtP7Yf6C5L8fiVy+r5DqnQMRutxqeJeK4Tx7mo+L9cInVx/1OafiF/+ZHTYgwW
	 03UVJ+PyWZBuqMKGjreSzsZ2wTPeiys8oXn1DQFLitmBhy5C8d7gko8F9Yn2YIOtKh
	 3xAGF8F4h9AQ11cGgF0w7ttlBeGZ+E819XuBEpSHscm8st6zConhloUvlqqcMebPUt
	 tpzAKULB7bMwWanimH7LVuwiI5anoQPjxd1LlyxhNNXBXHGMmcpP5Kem2NmeqBN+d3
	 VgoP8Sxq9YzpXiKMF/fLXp5Wd1ekvWt+Ksn7et8f8RuVxSXsizVrXds2U79FfNsLg7
	 7QhXMPhRRyxCg==
Date: Wed, 5 Aug 2026 14:02:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/6] net/tcp-ao: clear the aes_cmac_key when done
Message-ID: <20260805210259.GI3438@quark>
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-4-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805143611.818559-4-thuth@redhat.com>

On Wed, Aug 05, 2026 at 04:36:06PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Clear the local aes_cmac_key structure via __cleanup() function
> when we're done with it to avoid that sensitive data could leak on
> the stack.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  net/ipv4/tcp_ao.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
> index a56bb79e15e0e..12c724fed8a26 100644
> --- a/net/ipv4/tcp_ao.c
> +++ b/net/ipv4/tcp_ao.c
> @@ -141,7 +141,7 @@ void tcp_ao_calc_traffic_key(const struct tcp_ao_key *mkt, u8 *traffic_key,
>  					traffic_key);
>  		return;
>  	case TCP_AO_ALGO_AES_128_CMAC: {
> -		struct aes_cmac_key k;
> +		struct aes_cmac_key k __cleanup(aes_cmac_zeroize_key);
>  
>  		aes_cmac_preparekey(&k, mkt->key, AES_KEYSIZE_128);
>  		aes_cmac(&k, input, input_len, traffic_key);

Similar to the bluetooth patch: This is okay, but it seems the TCP-AO
code has never really tried to do key zeroization, which is why I didn't
include a memzero_explicit() here.  Lots of cases, like the various
traffic key buffers, have never been zeroized and still aren't.

The '__cleanup' trick makes this specific case trivial enough that sure,
it might as well be done anyway.  But it would be nice to have a more
comprehensive patch that actually tried to zeroize all TCP-AO keys.
Otherwise random individual fixes like this trickle in over time and it
takes a lot longer.

- Eric
