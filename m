Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD63A7835;
	Fri, 27 Mar 2026 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774605954; cv=none; b=RH3gnoi4YY1VlB4RqgMVpMS+blyxMcPdH08Bdw+NSUhn342Mzva/di8SZwl18McDoCvfo4CA2uFd207sZekwpwkdwOeIFgU1OEasu1GPksEbq0WvMJq2rkCE+AbTCtJzC00we6OlNlx4rys1zO/kWamE/bO+wf6v+eXGyGWR3fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774605954; c=relaxed/simple;
	bh=SD4WIoInSUxzJ8yu61IfNBavLwrXW6dfemh5da9t/mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjbCtF4NtIdg+4SFLJBDX8rdiz+pI7hLzY/jX3YVZSdHK7BsYxomLsufJQi43aB6csLwZrWn5tuQIt7yXlHcGfK2qAmSxZ2SrhGQ0ih93q/CU3MQEmjSz5bcIMhb5CSVHhAYrqtJKDHNR9KyH58vrAkpvLTAP28LzATctD++vAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iDzQtWr4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iDzQtWr4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qVbhFv/XcO9+q78HxV+iWik4JkdOB4EYBnC2TiYyTeI=; 
	b=iDzQtWr4IfsM0iDPFDs8gE99OVtNG98vjhv//ZcF0n81EU2YNuj4WpyKDyLdR5grsWclZTu7V0K
	7tWJVw0W0+l9zX8RF5dOAKzWbFTW6id1rAHJaQ+E3BmfnuEwuBdpIl+SNfTBT3fFNoLQ2yTmZeyiA
	wAKmxCUO9aq4j8QaOOYV+AuvuRH9LVYfuogqhOP2m6ExqD4K+i6Tja2Uq+kdjGsDOIaga5q3rwoKa
	iuXIefTjwAMwTa2fH7HVFgt/Seb8ZAoCfuwUWJjVlQl2w4YcLC42APfQwKNEDxNNaX0CtlJFDC1Ya
	KmQGIy22oFPYLINxaENTv26ltlWLLXngBGFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63ep-001bkz-0d;
	Fri, 27 Mar 2026 18:05:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:05:30 +0900
Date: Fri, 27 Mar 2026 19:05:30 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: s5p-sss - use unregister_{ahashes,skciphers} in
 probe/remove
Message-ID: <acZWaiutqd-z8YR7@gondor.apana.org.au>
References: <20260317080450.1054742-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317080450.1054742-3-thorsten.blum@linux.dev>

On Tue, Mar 17, 2026 at 09:04:52AM +0100, Thorsten Blum wrote:
> Replace multiple for loops with calls to crypto_unregister_ahashes() and
> crypto_unregister_skciphers().
> 
> If crypto_register_skcipher() fails in s5p_aes_probe(), log the error
> directly instead of checking 'i < ARRAY_SIZE(algs)' later.  Also drop
> now-unused local index variables.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/s5p-sss.c | 27 ++++++++++-----------------
>  1 file changed, 10 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
