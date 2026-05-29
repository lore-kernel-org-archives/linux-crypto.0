Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209C3382284;
	Fri, 29 May 2026 06:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034509; cv=none; b=DJuHXY4CIX9uA5J2pNIOnUkTnGz60ty4DK1Fub9q+Hn+3Pzbq6HCIjD1kVDsgl7oY5LtC2AvYkiS6SfeZeZDMbrptnQUNIrlI9xyjkC9G1D5LhIl8zbPhO+3S2E6D0HkLUuBwgXFPzxy07dwmHuJuYUP3omlagpPlpqmra8dJJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034509; c=relaxed/simple;
	bh=UHL5irC+jy0fDw9DfMoY3CDTaycCydvKvHUemrdSr/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=batiQxqbtijpAsCi64Y2/c8dITGr4v7Fd2aiFUOy1iVQzloo4Qz6079s7XTS72xsLKx/gpefuOUn3VnxPzoivBYzztzmSbf8RWrw2QT+6a26rA9IgTyV1+O2Dg21yWJ808oekX8+jb0juXu3Mtdna3uA4HMgi+jHLTgrU95PTU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nKuGfWDT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nKuGfWDT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8q0O8v/XFpp5eMpsyQexTrGAmsDicjcosLJ4+wS/wvo=; 
	b=nKuGfWDTW1equZTYD2T4GnzRLtsvToCahaE5qoe4a9uzh+7qaZQluTdQ/6sdatSF19kGzitZN9j
	ZehY6ZYjNbtdEl0BYa4xo2fkjJr1ldxek8+LAdxHVGgJ8rCkqRBP8RR3dSGOsUI9/SrqN73/Q4c2V
	LSKjxCU5JKvbK6vHBclBzEyz9+IL1f+DtXthpNDP3xvxsCFLL4o6ghFIQAX8mYZSo3luD2l6qrdmp
	LhPBvAMKI/OQ+kv5zIgpQgBEWzUlKpbSA56xka3pN6TnS/cKxb5DC23oEE/DIcuVsDu9pSkVKwlG/
	ZW0jzBj3Rn2yFi+TJCoycDlZHd/a+bgq9pKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqHO-000d9o-0n;
	Fri, 29 May 2026 14:01:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:01:10 +0800
Date: Fri, 29 May 2026 14:01:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - remove empty sig_alg exit callback
Message-ID: <ahkrph04T5yMnnm_@gondor.apana.org.au>
References: <20260519083630.147673-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519083630.147673-3-thorsten.blum@linux.dev>

On Tue, May 19, 2026 at 10:36:32AM +0200, Thorsten Blum wrote:
> ecrdsa_exit_tfm() is empty, and sig_alg .exit is optional. The
> corresponding .init callback is not set either, so there is nothing to
> release in .exit.
> 
> Remove the empty function and leave .exit unset.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/ecrdsa.c | 5 -----
>  1 file changed, 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
