Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAFC4594A
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 02:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776972; cv=none; b=NiWa4w7iYiV4FhThs8kKPLsETyhLary76UgVC7L/eBNFrUn3srEOhzsgJsJ/ZCKiuNlFFH7lq23q17i30O55kmPLu2DqF9dAcJrGIHxrEC66IkngAwvcWlfDoPAnLd1lOC52kX70n2SbaY09zPnQd63Z3casSWYFoTwJ8wmqSgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776972; c=relaxed/simple;
	bh=CIiq4O4SYzsrl41a3Sq/ooiU5UwnHQ0mHK0VSwXuEJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXTMsGx2X0OHmy55Ndbnap+6H3BZOg989D66N9kB1tNiQdXxEXesc9T4vYRohqQRnq0Y/5+F5fS2N28SZUw5Lwq5FqOS3sCitevNuj04CCrGTtp6REgNquch+t/aHKjg1FuGw9vNn6K5SXnPML67MA4/tF6xAM5scbK9du5oxwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ve99cuKU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ve99cuKU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PnOlsHOCZEBnbB6c+B6Ouk6kI9VIfg8CqmfxCkFO6tE=; 
	b=Ve99cuKU56gikaC/Q+D/nxkSwDjsBpXNfKndxF71c5LosUAXJ3RGik48yI2gPN4jGuhzL0ufa7L
	0K11Xljx+n5hKEhjsR4qgBvxcjhdJezPi8aEXfD7mZh0LijKEnL7I67KZZy2i8p5hv8D/97mp7NUz
	/2YvXX1rOee38o46ZuBMQvki2nVSGBoDCyzBbCL5sRsQU+03LKzTgBuu6cRSPdkUnzjCbABBttFim
	hOMRONbY+6YJBF4MUKZRnCkizib4++g6FV54FNTVV0DOkL4Do8KpSH7IM9BTL4ccemfcDaqp8Ybxm
	3telM6b8J6QFduwe9sfuPy6jqOWFjJzDaSDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMcxS-0055zj-1V;
	Sat, 22 Nov 2025 10:02:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 10:02:38 +0800
Date: Sat, 22 Nov 2025 10:02:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: "David S. Miller\"" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>, lvc-project@linuxtesting.org
Subject: Re: [PATCH] crypto: drbg - simplify drbg_get_random_bytes()
Message-ID: <aSEZvitssGWPG1jm@gondor.apana.org.au>
References: <28d3bdbc-c3f4-4f51-9d83-73c4b4ac85cc@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28d3bdbc-c3f4-4f51-9d83-73c4b4ac85cc@omp.ru>

On Sat, Nov 15, 2025 at 11:45:12PM +0300, Sergey Shtylyov wrote:
> To begin with, drbg_fips_continuous_test() only returns 0 and -EAGAIN,
> so an early return from the *do/while* loop in drbg_get_random_bytes()
> just isn't possible.  Then, the loop condition needs to be adjusted to
> only continue the loop while -EAGAIN is returned and the final *return*
> statement needs to be adjusted as well, in order to be prepared for the
> case of drbg_fips_continuous_test() starting to return some other error
> codes...
> 
> Found by Linux Verification Center (linuxtesting.org) with the Svace static
> analysis tool.
> 
> Suggested-by: Yann Droneaud <yann@droneaud.fr>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> ---
> The patch is against the master branch of Herbert Xu's cryptodev-2.6.git repo.

https://lore.kernel.org/linux-crypto/aNH49MZHzZNOGSID@gondor.apana.org.au/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
