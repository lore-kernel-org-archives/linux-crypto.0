Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583BB747F;
	Thu,  6 Nov 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421172; cv=none; b=Fh8EnTcWjIyo1BwbH9skgcrILs7CmwFNb1GP8+JV7jV+7CsXO/WeRcnEquj+K473ghMNMTw6jOsIK3KlAQrJnjLHUc3XEx9+tucTKCdithdRhUB30v5tMEJkh/Zx/aA+2krckqR82nb7u0WIvvRSpVx4w8IAtgCiGZWLk6C8brg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421172; c=relaxed/simple;
	bh=DmtXbkfdgrjUakjFF4v8pNlC6L/uCdFxq2rec7bqTNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7MqRVyAauE5M89CIlt5FUkaL3v7DOrl42U1uq7ItM8wmTkQYM9GjNpyYS5L4LmVaUD2HOH/iiTpOB+jZrJQG5FlS5zKEouiRmxh2eyxqYuZ0xIlepPAnPlp2yMsK1hlsXDA2aq3kgmpT7q6+J/0KwEzcswO6xg94sJSZzyw7OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AunTbToc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AunTbToc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6h0XYJa0C0MmaDb5Hw9MHXpbejzNVEY4uBPgSYailek=; 
	b=AunTbToce0lIyZ4NPZqctBCGC+qtauNngxURp3eGRqelaASyJ8kz5vR9eqKEvB2gxBfWaOMLOLt
	TngRLWF6iu91/zxEAbZkZ57qWSjyUDUmft13pozdJjOxUaHyL1h2wEFFeMcqYs0dML1BcHPnc1rlw
	0acakSwPBW2IcwrVdGkq7UJuqHVr0JAsp6xXj0FaaFRGhZhRZBQOFccbpCBEH2EZtAiWRezAfyOEw
	Nt46IsvctppxjkELLMjdXYKKN1bUDlLDKKIx+bOihS/kNbxOmG8uoZ7f2Afm3i6rKijFoJ5ZChnj8
	CimuqV7bcM3o351xhkwhMUIE07vAItUgdU9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGwFZ-000tFE-39;
	Thu, 06 Nov 2025 17:25:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 17:25:49 +0800
Date: Thu, 6 Nov 2025 17:25:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: nhorman@tuxdriver.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ansi_cprng: fix cipher leak in cprng_init error
 path
Message-ID: <aQxpnckYMgAAOLpZ@gondor.apana.org.au>
References: <20251106084851.639-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106084851.639-1-vulab@iscas.ac.cn>

On Thu, Nov 06, 2025 at 04:48:50PM +0800, Haotian Zhang wrote:
> In the commit referenced by the Fixes tag, crypto_alloc_cipher()
> was moved from reset_prng_context() to cprng_init(). However,
> this approach does not account for the error path: when
> reset_prng_context() fails, crypto_free_cipher() is never called,
> resulting in a resource leak.
> 
> Free the allocated cipher before returning on reset_prng_context()
> failure.
> 
> Fixes: fd09d7facb7c ("crypto: ansi_prng - alloc cipher just in init")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  crypto/ansi_cprng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Please instead provide a patch to remove ansi_cprng.  It's obsolete
and unused.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
