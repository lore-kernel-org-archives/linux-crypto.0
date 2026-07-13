Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63885314B9A;
	Mon, 13 Jul 2026 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783913400; cv=none; b=I8wNA1NScRkb5w6ur7ec/TcVltvDJ6q04C0XW67XoBUIVUbpVyf/iHqI8u1HH9gFaZrGe+1J1tVWcPaHD5V8voXdL3glU3hTXRYBF1jtDYELAqV3YBV6H9VczAdlMU0mhhXhHk71aWGd3O+8DONAHpNcfFe1XRSXuX1u0ARtNJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783913400; c=relaxed/simple;
	bh=0fLHp3CzbW0QN7iyprsZKhCyqh1bbYd8e/dGqmaU8vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfDjsFS1A6hZ9lQFLznAnsJZCHg2hs/fcgPtr99wpqJd5p5mpIDV7TFPkZqG/Bbspwcb/2v9VcvUg1f3nX8qoqRVepOiQktpI744tiaP/cpl4kw+UP1anjEopEnLKkxCf7nETesCv5M8dxcuJrzCFzrSZ553URkB8vM4orktGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gc42qLb5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gc42qLb5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=50wEN0K9vjzdLT0ms8EAj6OnQvWo5x9SZ01cJ1qyEQo=; 
	b=gc42qLb5rjui3CbjhtlrD8raMwM9eajAYqxoGhPefAh0AB5VrMVFB7WHkE2y6d8i6jlPubrMg70
	h/Tp1EeUhTYAqVL8ePP1rBx0qzagn5njN2HEaPIdnwnUA428Jm9M7dxQjAWysFNkrcTpjvtKY8RIr
	F4bwBai7t9ZZOsLmnGY2lxplSV8/p2ta2IP1a4m/1tyE+WvA0Ur3I5ZYN0UrwGe1dxUlBEeMxuEP/
	SzwA1uUOy/NBZBw0L2E90ANIFf4ULi6K3beLll6bkcnTRieABvyNmhkoDRFQA1tvojXBY8nO1pBIz
	5emnlk4e95amqLqh9YJuQ0rHHuqyLyq7ovPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7Me-0000000Cy5z-3lIy;
	Mon, 13 Jul 2026 11:29:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:29:52 +1000
Date: Mon, 13 Jul 2026 13:29:52 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] crypto: pcrypt - Remove pcrypt
Message-ID: <alRbsLpptbdSsBlf@gondor.apana.org.au>
References: <20260713032600.44355-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713032600.44355-1-ebiggers@kernel.org>

On Sun, Jul 12, 2026 at 11:26:00PM -0400, Eric Biggers wrote:
> pcrypt was originally intended to improve IPsec performance.  However,
> it's no longer useful for that.  Reports from the rare cases that anyone
> has actually tried to use it over the years indicate that it actually
> reduces IPsec performance, e.g.:
> 
> * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
> * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
> 
> It's also undocumented and quite difficult to actually use.  Its design
> is also broken, in that any unprivileged program can enable pcrypt
> systemwide at any time (by instantiating it using AF_ALG).
> 
> Meanwhile, pcrypt has been a regular source of bugs, including at least
> four that have received CVEs.
> 
> Let's just remove it.  No one seems to care about it anymore other than
> people looking for vulnerabilities.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Looks good to me.

More than half of kernel/padata.c is only used by pcrypt and can
also be removed if pcrypt is removed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
