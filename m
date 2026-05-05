Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E13290D0;
	Tue,  5 May 2026 09:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973686; cv=none; b=b/f1ReSYqHT5iBGLcvg6iPflBxno/d+CseUUmpA6UDM2lAu4DzaK3pikDGhfHiQf3RmlgeSdcs7grhWyTYXfesQXTo2eB8m0HPgrlzq/LfEsqqYKaQLyDewyosCYrQYIj3rWxuk7AOWSIuGPP0EGWZxS6IRe9fLsagCtQ7Y7QJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973686; c=relaxed/simple;
	bh=w31Yk0407YjHr10KjUzcroT98Lcz4kj5ZgA26+MOkLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnlTJsfNzY51CD5H4QZGyJ3yjs5j7mh7kNj9JqPNEgIIjj+igaIA6+6WRX9IMG+5obCsUZF1t30qtZLTDBIOHRlMkErimJu+7uo9gvFsam7GWBgGtSWnQa7+ZKHcb6aRy9ysUBOsGHJ7p51vCBGykQBFD9ajk5H04P7loNdcv+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qqbfjqEc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qqbfjqEc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KtC1pSYLnRwEjuDnHg5iLuol5nAgQy/1Km+lTvxTC60=; 
	b=qqbfjqEc/uorYE7VTx89kXqX9GAIlP/xRyfT5HGfGs1rhDMBb9qnswtLxxlRwADtDwqawLChSrh
	UaN8jbHm8WI5/5pi5Uv4uMSxtZmCVm1HgMaURGH52wvpYV4Y923CqD60XjmWzXkcIXdq2mFyfyL9U
	ea7I6A3gSi7sdyMGu+WBP5/DpwdW4n/MFznZFqp+nWVm/hOx4M17KCKMbhOX4Ym0qEEb0mhiu2LZY
	DYKBvqQ0cEBhTdqWOYZgY85JWrv5XjFNmYRiuc5ffm37kUXoqPa7ug+Lvzsl7n173Tth/m9qPdnFM
	E+OIgvtu21O6M59wUqZCzKf2t/a6Xa3gd0Ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKCAX-00BOB0-0u;
	Tue, 05 May 2026 17:34:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:34:21 +0800
Date: Tue, 5 May 2026 17:34:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>,
	Vitaly Chikunov <vt@altlinux.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - fix unknown OID check in
 ecrdsa_param_curve
Message-ID: <afm5nQs34VB3FA24@gondor.apana.org.au>
References: <20260502190903.252061-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502190903.252061-3-thorsten.blum@linux.dev>

On Sat, May 02, 2026 at 09:09:04PM +0200, Thorsten Blum wrote:
> The ->curve_oid check in ecrdsa_param_curve() rejects the valid enum
> value 0 (OID_id_dsa_with_sha1), but look_up_OID() returns OID__NR on
> lookup failure. Compare ->curve_oid with OID__NR instead to ensure that
> only unknown OIDs return -EINVAL.
> 
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/ecrdsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
