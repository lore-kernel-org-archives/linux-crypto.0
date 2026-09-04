Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266C6443E5E;
	Fri,  4 Sep 2026 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516129; cv=none; b=OmzD8+/ooOZjLL7O4ylUe7RFRPlX6952RcENFaqzT8Vhk5wjFqXJBO5vZj8PdLqInLqn8Ny8oXfgSrtG+Kz5UJheYoYHDcgVEbe1OWMxe63BxQwOJ4n4IJfNaFieQJTl2+n9RUlW7aMyQyCUyQMKyBBqksoEPCW4PDys3AHm1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516129; c=relaxed/simple;
	bh=9KwEfZwAtiP3lhV0nt96E1dun3XONRIZX5cQXvSCevA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0hfLBx6fhIm0NuM8nqHPtHsk2RlXYnuHUCdR5+pQCyTp6kdNyX0pyOf6z+/NJCFIRa69v7jg0/X3Ed39bPWbUEh32+CAX/PgF8b1RmXfw3yQySZJPCxjqjLJnEfmbi47CyzLExdrQMRCvhsM73upJ7VdUpeT1az/jhpkJQowQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LC2Gin7B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LC2Gin7B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zmX+7dO0oUuhU4iSuMvLGIWdFuhC6sfMy6MVCR3zm1M=; 
	b=LC2Gin7BQqpgjAG0JuKSHtS5ctwqI5I1zZqlmLpE8YovoXWm9ynCoRM7rxGSaTdfyfjCKZ7t2rW
	/d6UMgb74CetWuxCrf55jGofyZ+gHbp315g6wQPRfrZIcRteilxds3/LQ2BuIeNnmO36pG5zrp+PY
	f6CrEPghAxi6ez8CHpaeG4bYT5x/2esu+AGJsZne/m4Z4RxKaoeHk+l3WI/VtQVvvRXBsRLwXRwDx
	c13YOriErNittuwVtCS7Fwb1k6+gKK4fNcaRBFHd46ILfwD1zxHqvBbcVlfYmeQ8QTITUSNEfr1YU
	6BTkSwZLufyLz13bmKMnkC56lbOWGoPeLW/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QkF-0000000AnM0-1uUX;
	Fri, 04 Sep 2026 18:02:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:02:03 +1000
Date: Fri, 4 Sep 2026 20:02:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH] crypto: ccree - use crypto_memneq() to compare AEAD tag
Message-ID: <apqXG0nEOByk-ABA@gondor.apana.org.au>
References: <aoCdZiqJjb5XDHHz@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoCdZiqJjb5XDHHz@david.gall>

On Sat, Aug 15, 2026 at 07:09:58PM +0200, David C.C.M. Gall wrote:
> cc_aead_complete() compares the computed MAC against the received ICV
> with memcmp(), which short-circuits on the first differing byte and
> leaks tag-match length via timing. Use crypto_memneq() instead.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> ---
>  drivers/crypto/ccree/cc_aead.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
