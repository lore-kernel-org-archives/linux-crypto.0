Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4227472;
	Sat, 22 Nov 2025 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763780930; cv=none; b=J6U+fh1LIiWeLL3FORywFXRYjiXXoBmEBxeRC79BmMiGRJXWVYciZKyNJ0HKC4j+Br/8gONMNCNmppxmQnx3ButEeXXvENM+RWfL6MZRBZBDO5gnFAuAnk+XYX7iKXQOW12dfroek62GNqn4w0gj96qSaf2WMtAP6pN7k/drREU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763780930; c=relaxed/simple;
	bh=vN+FyIaICEY97nr+Et/CF8YrYu9I3L1ZwAPw9FvWsq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBE7fuO3GBJyVdmD22Hgy/QJR20WUMdh0MU+eqbHTf6HvXvF6BEyVbfjqH726aaz70AqYy2gpryvuomEcXXoIxZm/OR3Jz3EuUkKlXLl6xO35xIbXfHYGF3AmoNouTEy4jlNjMbbppZQkvvfXMdLNFS2AAtCpXGIKcfrB0S0f/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bR+tOO8H; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bR+tOO8H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RvB1V42cJPtuNjI9dynxdUi4q61WtZdQDqkBNhQkF20=; 
	b=bR+tOO8H/kJFnhgXRH2F7JReQIFpq+lMrb8zNS2D5SZDIrX89JWMXessmMTeDMuxMnLnqzE2MJH
	3P3AQAUIwIQyuwnwpX3elzULNSkf0J3XvBon+NNTPA2lqBhNEmnuhPOOg3JLMMNN2pe2vRrcAP+oQ
	cSj1/GdbYsIeCIcRe1CAq3D8j2aXnM/Mi6aRB4AfFNveiql8FJi5nEUUMInigdC79HJLWMPXHvf5G
	M0ZFsyui3r5Gk5VNq5oUadIh1ZrS4x/elGKPnyN6jO1EWnbsSo4xLn502HxXCVs8cKLji73ZO5A1u
	z4IuyLbYfYeMfAK21FSqgRFsOvzbIVIPrIqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMdzJ-0056Qf-1P;
	Sat, 22 Nov 2025 11:08:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:08:37 +0800
Date: Sat, 22 Nov 2025 11:08:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: torvalds@linux-foundation.org, ebiggers@kernel.org, ardb@kernel.org,
	kees@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <aSEpNYgrYRGOihxy@gondor.apana.org.au>
References: <20251120011022.1558674-2-Jason@zx2c4.com>
 <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
 <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com>

On Sat, Nov 22, 2025 at 03:46:38AM +0100, Jason A. Donenfeld wrote:
>
> Saw your reply to v1 and was thinking about that. Will do. Thanks for
> pointing this out.

It seems that we need to bring the brackets back, because sparse
won't take this either:

int foo(int n, int a[n])
{
	return a[0]++;
}

But this seems to work:

#ifdef __CHECKER__
#define at_least(x)
#else
#define at_least(x) static x
#endif

int foo(int n, int a[at_least(n)])
{
	return a[0]++;
}

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
