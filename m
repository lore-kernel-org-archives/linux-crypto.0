Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2653130ACEE;
	Sun, 12 Apr 2026 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775985466; cv=none; b=H1eN5z7p5W8ChQzbOMEZ/PD+jI3q4mC0B5Vb5iKEbM44eXh0syHB6YD3T8Em+TeteJGzpOlw/Bz9hiHPrGdt9mzcT/c46pHTVn7IpHRX8x5/xF80gR0WcUHKclqiWMIosUYnFzD/rKdEVybSBSFVTVEcvSH8bEV1mOJhZJ76bUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775985466; c=relaxed/simple;
	bh=fvrNMUzA3MvPw66gA6PA4fnj2brLlEqedrSiNGA/6es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ8l19eLiNp2Dr4Jwa1g9c+a5CEkB5Asars4puCbdT6qo+BGEM69xdcuCgpb9kcN07OrpHbtWvP/u0FeZA29+8yU9kXfY5e1W22EpQy8fypxCGIK/ocAZfUMRsJdNoPRwVRNtnf59eRj09VK56PLZA7bvAGarlXxSXh2GOzcNFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hJegd6ze; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hJegd6ze"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Fdc9h36AiSMWdb4hDulIMSwIQJhzslJqA1TmA/U3Qdo=; 
	b=hJegd6zeBEQYrAHMy6yvE1ZuuCye7gc8pSSUhtpxcCLN1x+8ilAA1U0rTYqaXP1KMsHf7mBpGzI
	Gs42uuL7x75K6QmB2H6GUws2A6BlNHgdX6kxnkEj9nq4VkTa6QkYz7m/yiKpZSPF78Ws46EfQW1MJ
	e0KuhBBqtJpfIpE6YGBeTusg1ypXV6iFkYTayrKgJdegqA1H/yNQrQoUSUcWrwkLu/0jgpdd7wqmV
	s2MBJC4PmQRZHHg61bFID9xQDlkmKUTTi+rDnJa+/ztun8cs8f5CGLRRT2QfE//+d+1PfNzxAE73N
	Ni3w7ZNgtgihQJiXQMGUsLtxh2gzSeGZ5Y3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBqXI-005UW4-1E;
	Sun, 12 Apr 2026 17:17:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 17:17:39 +0800
Date: Sun, 12 Apr 2026 17:17:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - use sock_kmemdup in
 alg_setkey_by_key_serial
Message-ID: <adtjM8mVs_iJhRj1@gondor.apana.org.au>
References: <20260405194940.990619-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405194940.990619-3-thorsten.blum@linux.dev>

On Sun, Apr 05, 2026 at 09:49:41PM +0200, Thorsten Blum wrote:
> Replace sock_kmalloc() followed by memcpy() with sock_kmemdup() to
> simplify alg_setkey_by_key_serial().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/af_alg.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
