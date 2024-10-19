Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DB517DE36
	for <linux-crypto@vger.kernel.org>; Sat, 19 Oct 2024 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339045; cv=none; b=C380ByGa0Q3msW58hQNjqWBlc+5Ya4eR2RiJ1gPLPAYo3zeIS8IKB4MMuScT/9fcygTJvpsHVWMMFjjvl+aZx+5Eg1eZ2TBf/PD7zSgE1R7KiZR4zTuvNN2jOFM/VkVgah8zJoczrKGALLaKk0JAn/JIf8xT87+6C5hV3By2SyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339045; c=relaxed/simple;
	bh=RF+gbGHFaM8flsq6zqGgKP6lN3Yu8doXn/91PQYIXUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZgn1kPT4nJoCmFZy0/0RhjjoELqET0OrvZiKIamJvUUKwriiZSOIh60oFEyi8yMkiFblbPMiKql0nIcwkKjwBdybTXAGUOSK3Mdv7yVJgFCp3zeVP5USeaUDCmXVvr1bD8Ho136BLnAvc46pdxjKVGybmQxUWe5o9ONDrfjyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Y3ejfSS0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Y3ejfSS0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8A3k6sOSOFixGvWV1wi0LZvyFrAmd3zWMDkGNVp677A=; b=Y3ejfSS0yDHmI4TBFYBm76TKxQ
	If6iVgbRb624ZXaUT+vCSCqdzmDpVojtJXjR4vZytVjXgB/NUxf1Cf3y2jLDbLvVGhK0kAxbqOyAJ
	aR/SIqSNdVv6JgwRMCcWyeXlodrzNaaaHyZ2313CGSUwEskK1SQDbCnNkPztes1sY/E5EbGsPRJvO
	hPTMoWBHetMrGeMj1jBFtvw4vMYERn3veg6guTKRc6SRmHh98fUbsGHpTyqCt7O9FLEKMUOBFjrun
	BLrQYzvoGKLSmZ7qJl1ycXoRuoduOmrmmXgOOObSFCuFiHQp/6+aVJtQSaOgv1/gN2XNcpOfVrgA2
	fgOTb5gw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t2853-00AaOZ-0R;
	Sat, 19 Oct 2024 19:57:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:57:13 +0800
Date: Sat, 19 Oct 2024 19:57:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Switch back to struct platform_driver::remove()
Message-ID: <ZxOemUqB8FARuJXS@gondor.apana.org.au>
References: <20241007205803.444994-9-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241007205803.444994-9-u.kleine-koenig@baylibre.com>

On Mon, Oct 07, 2024 at 10:58:06PM +0200, Uwe Kleine-König wrote:
> After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
> return void") .remove() is (again) the right callback to implement for
> platform drivers.
> 
> Convert all platform drivers below drivers/crypto to use .remove(), with
> the eventual goal to drop struct platform_driver::remove_new(). As
> .remove() and .remove_new() have the same prototypes, conversion is done
> by just changing the structure member name in the driver initializer.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
