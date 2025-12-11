Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6631DE2C9;
	Thu, 11 Dec 2025 03:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765422199; cv=none; b=hiZYow7sJy82V6n0xYvWNv6r3VGdoRbZ7NwLPaeq0pyQNVakmKHKOzSPLgug+Ggzm02TYPxH0w2b6ynpaIqWdU78gKUYyR+tfUGZv1bdOaEUXFDPL1qunHgkqbvtcAmS3iKmCOEhDl3cdhOQIgi+aGeqBSiViRlyYCOau2q8sfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765422199; c=relaxed/simple;
	bh=HcpJNg+AKrG0Gq3yrtOMOdMTVJzthJTE1hWChChF5zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1gc5GrDpRfjxPWxn1A4ksv3D87mVLSkG+fJuI30yy+wzFer3RZl5eq71X4MYLu4daaaUEWkpW8b6kLxLT2GmHYeHgQzxYV3+/JSAn6/APn0J+U62uBdYjiLYZtOQ1ZrdP+ieLXKK1dsSnOHei9VXqd2HdYNF7CkkfNGEjjhbKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oUiza1v2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oUiza1v2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QVqdbRRFrX15Ivg63+Vus29+rCqCe9lqqydPLM8MyDw=; 
	b=oUiza1v2HuFRwnYQd6dblRTj+0pMVKYX8oZdK8LBKuhJxeiuKW2kq1OW6fpyUUOIU19BdPLg+up
	I4gLKuU5WOF6wYnbknTdZw10V2tdceWcAhlhxVmyvVtdhEXgrJqVj0PJvRcJS9RNqtK7RbVUKf1cl
	nWv5ZTsnl9RpclVD8xOosv8JFk1+fqRFux8cXdjxWeEZpAEVMhFoMkO3LZV37ef68YkgEePy93tVb
	WNoXklHWm8cSeKi1rOX6EXxjBn1pbqCiF87mAxITVn3dnj8/EE1NeWEwt0W9Zu6DcT5SCp8xKonF/
	AKeFKuf6SKMe7qOXZYdF5uLPWSZS7kS2mvog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTWxV-009PEV-0N;
	Thu, 11 Dec 2025 11:03:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Dec 2025 11:03:13 +0800
Date: Thu, 11 Dec 2025 11:03:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 11/12] crypto: testmgr - Remove nhpoly1305 tests
Message-ID: <aTo0cfjLr5qi2nmY@gondor.apana.org.au>
References: <20251211011846.8179-1-ebiggers@kernel.org>
 <20251211011846.8179-12-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211011846.8179-12-ebiggers@kernel.org>

On Wed, Dec 10, 2025 at 05:18:43PM -0800, Eric Biggers wrote:
> These are no longer used, since nhpoly1305 support has been removed from
> the crypto_shash API.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/testmgr.c |    6 -
>  crypto/testmgr.h | 1372 ----------------------------------------------
>  2 files changed, 1378 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
