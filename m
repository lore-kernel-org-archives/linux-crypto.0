Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35F723E358;
	Fri,  6 Feb 2026 11:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375697; cv=none; b=C2guL77+1gZWl+/mP1h1dopg1OFYcZJTTkskxyRGroksCS8X+I8EpX+bnHiajoLReKq+FSK763+V2KC/6P3i7ATF8sBBEHJ7EYy4TaTeOxvC/wAczr2M0MU/NZO+j6EGq0i/oIc1HLfj7eGyB9Wap9B9uoZiiqNdI/4X+03agkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375697; c=relaxed/simple;
	bh=HlIaLPdmmdTGuaToHflI5TmFN9d9smFHx+t02sFm/lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/4MQ3l+MEVVcdOm7Fut5qi5CD4491cOWiD5cH1dtpPExTp0hcklzoGHxz5URQvMyZyaWmSVO5RgOUOje9vyHckl2LxGOKOUVYe5uZzlVOApb81B8JlTqmAhq5/DsM0HKYFtWcjqU6+27j0pzLo/F3gN/se1hVf1iyWKR03C4Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sZgauSPE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sZgauSPE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zz1tgrC4A17F5zQsNu+CfmKXmgeWlVTZHlF5t+YyTUE=; 
	b=sZgauSPEtAmuJ5thr6QeSMOYrbmOUjwWTA/4o415LlyMv+dFq+hcw4PcF+EzxiHntoq6yN4WUyk
	hMAajSrtWR9VQVTDNJd9UE2pFtH7RsmB3RWu9FsSqM3+riotBULKsRLlj3ReTX3lQDTuBjGzk8CfA
	GLVXTAW4D0MLreC5k9wCuG28mU5y0BGmHh8sPAfkQtFvjUYNI6kVtHCoPtQsaMViNHsTrzMvtpoRl
	zP+6H/+C0w1/BfB1o4jP+4b2AiqMrSA1OzSKmJ7V2l1ChC8hVn54NG0pgxdi6D4hW73jbSZdV53nr
	F+wdEB3fxtRzA4ixJmXqv485RYR/Ug4I+vJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJaY-004zX1-2f;
	Fri, 06 Feb 2026 19:01:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:01:26 +0800
Date: Fri, 6 Feb 2026 19:01:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cesa - Simplify return statement in
 mv_cesa_dequeue_req_locked
Message-ID: <aYXKBtdTn6ypYnOv@gondor.apana.org.au>
References: <20260131214249.533350-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131214249.533350-2-thorsten.blum@linux.dev>

On Sat, Jan 31, 2026 at 10:42:47PM +0100, Thorsten Blum wrote:
> Return the result of calling crypto_dequeue_request() directly and
> remove the local return variable.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/cesa/cesa.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
