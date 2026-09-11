Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7FA370AE5;
	Fri, 11 Sep 2026 05:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103512; cv=none; b=Z/BicTplLE3sFemTOiOS8d0mMqx//Bo23qUEu0sap0LiD9TLYIRwSS+5Mv5L+xRVo/tOSw7a8bEumKBzdshr+kSrvlEu6ZUI/PPljYrnBVW/Sl0I8aVUUMwFr0OmvUyKhYRjIIGQ/r8NEKK4o5aaePRTcWyk8cqHHSkndMayOEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103512; c=relaxed/simple;
	bh=zTRO5l8Fw8OQgn3M9YkJ9FHYVB68o2irE5tvYpS6Pwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pst+R5MYcIEa88I1m7jFAa9a8eSK72tm1Nje/Yfn3wRKlFOy2TxQLJHmFiSFHIJ/HtkEi+QrrA6TyS8Hk+5pzj9dLOkegJFNJg7/4Vd/DY9wI+RXXABMUniUDg6opOmXCc7C/L5uxYuG1Rgmxs2zAd89hpD9ErqpI00izUwOPHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FPpRcCqb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FPpRcCqb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ddAzPgaeZN1Eo4zbb417P1QFgsE6+UJy+d7193lDT+Q=; 
	b=FPpRcCqb13XEi38G9p25v1uaNvjVwvMnFQsaBaRZIitUhlJaXxhKSL/bWBqfA+8S4puZt+PxkMv
	bvTkjTdTX0zYvfo8pDL3yoInh2tiWVUKNIuAcg+YQnWdzpcQKuh5pHolk3IqC3iEIlGTHTrAn1+H8
	3T4dmPfhajDE8PbAqqEA9Z+p/UONEk2JAdCtILSTMDOiDY+34CJfnTgku6y8nz9WimmSXjnPkXuWy
	T1HcLqLzsMEacoUAkXSZMgpC2hp7oN2XKH8A7ELU7x1mMKrbbnyeMZvAkwvcqTQ0H+hZwXupCXRqE
	NtoIHu8EJDEIuMVDFkMopH24Tu/JPxH6fWuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tY7-0000000Ctu1-2kjJ;
	Fri, 11 Sep 2026 13:11:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:11:43 +1000
Date: Fri, 11 Sep 2026 15:11:43 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Huth <thuth@redhat.com>
Cc: Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Pascal van Leeuwen <pascalvanl@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: inside-secure - Zeroize temporary arrays on
 stack with sensitive data
Message-ID: <aqONj13pcNZtsCiT@gondor.apana.org.au>
References: <20260819151845.835768-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819151845.835768-1-thuth@redhat.com>

On Wed, Aug 19, 2026 at 05:18:45PM +0200, Thomas Huth wrote:
> key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[] in
> safexcel_cmac_setkey() contain crypto key material that should not
> get exposed to the outside once the function is done. Scrub the
> arrays with memzero_explicit() to avoid that the data could leak
> via the stack.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260813134953.979481-1-thuth%40redhat.com
> Fixes: 38f21b4bab11f ("crypto: inside-secure - Added support for the AES XCBC ahash")
> Fixes: 7a627db9cafdb ("crypto: inside-secure - Added support for the AES-CMAC ahash")
> Acked-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v3: Fixed white space damage
> 
>  drivers/crypto/inside-secure/safexcel_hash.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
