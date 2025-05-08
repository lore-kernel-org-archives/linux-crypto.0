Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A060B210F5D;
	Thu,  8 May 2025 05:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746680843; cv=none; b=E1aKxqmdhAWeWZ6OqG5pX1Nu+grvMaF8KCEw2BpWfjW8qHd+wOjWnvgdNslOnglrSo3n90EfPuYVLbuWp8GmUQsnZeqkRv4S0s+BJyMJDEIKuKjCegBnhmGLoiH5qpV5cXQ+AHqyegAVreLGi8aDP5JmktTA4Dew9BNWvqWQCZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746680843; c=relaxed/simple;
	bh=2AodfOl+DzZV+5X1clph/wNbzPwOOuBCV5AXOp3pEL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNWTXuYtjCGoAWdv5DS3GkEXq0QYCCcKYmby5PODC3qINfxNExdXtqBm5BmXo61ED/oRkofeABNBXT76OcmAvAOy7uvk8WQaz89ZK+YsjLTKGBkeW07GHuI9jTs21j+Mx9+GoX0VnDar53ubb5OtpGflKix4Oy8MbGz6WMRddnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g3corOdq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g3corOdq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cjI3IizsYbTYi4iQOWq3owNuADZbruV8ZU1tsNatJEQ=; b=g3corOdqDQ3ypyVy4U3seRFY2w
	USvAqrNk9eRoN263McUJRNOWEm3uWnKuB+4f+y7brYQzCWyesY1r9wynTzcciA6oIfv9BawFN5AlK
	1yaG+SfHeFVg+lqLYkTzK4H1mN5DxnXxGcvimiNfDtKRvyeugiFKQbDbQ/h1T4agWd0cNLwCyEflK
	4twoxuf6BXJwZk6/Y/FeGVZWsGLaDX19l9nDlUTe/yYVw1y452Do4d/vpocc8zKVs2LDNMtoxNxeJ
	/m6CpuFChkWNviv/Utmo9KcUWZyBDokTElYej3mHwwlGVdOyQmIkCr6/D4Kg30xFbmNiWgdP7EiRV
	bimj4xFQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCtTX-004RSX-1W;
	Thu, 08 May 2025 13:07:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 May 2025 13:07:15 +0800
Date: Thu, 8 May 2025 13:07:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Wanner <ryan.wanner@microchip.com>
Cc: linux-crypto@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: crypto self-test errors kernel 6.12.4
Message-ID: <aBw8A0EhcDV3RXCV@gondor.apana.org.au>
References: <468a8e17-d564-441d-9893-72b0ed48d8bb@microchip.com>
 <aBqvJJdXMcBpp9mC@gondor.apana.org.au>
 <9a725b81-9fed-4713-b56f-5b182f95e97a@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a725b81-9fed-4713-b56f-5b182f95e97a@microchip.com>

On Wed, May 07, 2025 at 08:27:18AM -0700, Ryan Wanner wrote:
>
> Yes the config file is attached and here is the boot log, looks like it
> is fixed on v6.15-rc5 and I do not see the error. Is there multiple
> commits that fix this or where the async tests have been disabled?

Aha, so there were some fixes that went in after 6.12.  My pull
request for 6.14 said:

API:

- Remove physical address skcipher walking.
- Fix boot-up self-test race.

And these commits look like that they might help:

      crypto: api - Fix boot-up self-test race
      crypto: api - Call crypto_schedule_test outside of mutex

If not then I guess you'd have to do a bisection search.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
