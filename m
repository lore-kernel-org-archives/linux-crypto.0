Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59B5372B3E;
	Fri, 23 Jan 2026 05:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147920; cv=none; b=W8OYwIwc6XfKBm9wIADndA6cTPiqoXkLJJ84+GmkmonZq9N4QTW1vj91NAXmMinq3SomFIQsYrmWLqqzmEb0KsU6K6I5Dv/nZzl6gSejlnZFiVlhaw4bI1JzdBbg2kCu/xqYFLyunR9ynNfC0tLzCLpcRuUUmFg03PSf0OXjmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147920; c=relaxed/simple;
	bh=Z9BLh7HqWTGB4sGjq5B96LOmxVi9lHzJMVbXKngzPnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIymfEVPy6FBT2bf0VacC9sBnIpRDT67iZsezsLpEZLSfUnSQ0LEatytdV9dV/+Csoyr0b1eWKsryWTmBqEim+JTazfcgD+vqcsW/dKx1QTgjaNaVk1BAkxNZ/86p6JBaAqK34HQu4ijUuspKMYH6WATFEv2qW1VqtSRlhtRlOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FAMnQCtt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FAMnQCtt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IRMc7Ew0xnVtRngB4SfCYgq/gZJ6LtzQ5tHEgyLytZ8=; 
	b=FAMnQCttpJAEe70CinAkPbiwJy5K54vM0bL06FiJAW+kIiUDjX9fz0o+LAvJhfnbYiMEofk9g0y
	KvxHSTkbpx6poltnX7Hdyl3h2e41fMX3+uulFMHiXPoHYxc3F/aBEnZkhwLabKhNFq2Jfz17V/Hmg
	bRsFZFUG/hJH/b0QxJPALZUSr/KQZOjrRguhAO67VWuwpWHsUbR/X7xfpFAx/Wgp4P/8+eLDjJQiR
	sMMO7jTZjDJqiTKQchTEtPos+vGW04DsxgZEgbldR0TLHGRCvOj8DY4EtwSr2pJR5mrtMGZKmVIBY
	LuJ1MsXAHaSVHb0Bb76P94rjtavwk/hi01BQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjABb-001VOY-37;
	Fri, 23 Jan 2026 13:58:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:58:23 +0800
Date: Fri, 23 Jan 2026 13:58:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Bendezu <alexanderbendezu10@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: blowfish - fix typo in comment
Message-ID: <aXMN_6vunR0HGOmr@gondor.apana.org.au>
References: <20251228000101.12139-1-alexanderbendezu10@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251228000101.12139-1-alexanderbendezu10@gmail.com>

On Sun, Dec 28, 2025 at 12:01:01AM +0000, Alexander Bendezu wrote:
> Fix spelling mistake in comment: endianess -> endianness
> 
> Signed-off-by: Alexander Bendezu <alexanderbendezu10@gmail.com>
> ---
>  crypto/blowfish_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
