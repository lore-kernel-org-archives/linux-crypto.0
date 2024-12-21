Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EB93F9D2
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734779776; cv=none; b=WP/YGhHRyhnwvUh9Toybmu4hSqU339SLNKQbRKCuEZEM7h+c6AzFeOvMecnhz2HnHWr7TYKJiBGpAwCoQgtKuge4G5Ol+bE5VPjqEVP8E5a9v8ewzHS8JTNpV7XqC/8HKMZEOVS3i//T4ud9mqWHgn4Q1j0rDkyPNpIchM0/lGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734779776; c=relaxed/simple;
	bh=x0JdKtD1kZ/HTC8SJHi4T7RSs0+FGiTDDrPQPnNnH/E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NXBRtfmLRTJ2RImkEjp6KSms888cVZLlYOf75DPq3zaUnF+bHs797TkWRxL8dMV0nsr6IaXSJP8O6wa31Dm26RXHkIvSeTmZXCJ2f0VaM5jDfDESTSGVOwjTsY25kLdIhhVYL6eq9dITyeOXw/f+j18B5XMj+YhR9q8UZBmiAIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ny5pyb3A; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ny5pyb3A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qr1AfjYW9tjdC51dCfI2rjKYaI45NoLzzL6sFqcfNAM=; b=ny5pyb3AUNoHWzq4fADG87iX+E
	xyWyx2Kj4EBT0/5Vc6xmDyz31wGNCdzc5TuMv/C4/5tR2eZhg5Kk8H704GPHmqTQIYW/jLZgXQVhp
	uHz87sUKB3Nt2aGdRGZ1oIXRa1tw4ULgdGmLOaPpsJv2ZVRy1IDQTZt80JnH7VwmWt7kt6d2B9ciu
	eZWw0LkaxKQkmTBGOMNBoUmsVszV0Evs35Y+Ncr/hSJB5yHGBYzmEOzIEuhiXpmR0/cX8BLiMycr1
	AIJHSs66k4ukMromrKTAW6V59guQkQ5v4YXwu+QsH4/rcRMj/B2JK4XvutBspaApw27XDwJvu4dcc
	06vWfEbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tOxFu-002QWY-2n;
	Sat, 21 Dec 2024 19:16:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 19:16:07 +0800
Date: Sat, 21 Dec 2024 19:16:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 07/29] crypto: skcipher - optimize initializing
 skcipher_walk fields
Message-ID: <Z2ajd9PdI3noj-oT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221091056.282098-8-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> @@ -326,13 +326,13 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
>                return 0;
> 
>        scatterwalk_start(&walk->in, req->src);
>        scatterwalk_start(&walk->out, req->dst);
> 
> -       walk->blocksize = crypto_skcipher_blocksize(tfm);
> -       walk->ivsize = crypto_skcipher_ivsize(tfm);
> -       walk->alignmask = crypto_skcipher_alignmask(tfm);
> +       walk->blocksize = alg->base.cra_blocksize;
> +       walk->ivsize = alg->co.ivsize;
> +       walk->alignmask = alg->base.cra_alignmask;

Please do this instead:

	unsigned bs, ivs, am;

	bs = crypto_skcipher_blocksize(tfm);
	ivs = crypto_skcipher_ivsize(tfm);
	am = crypto_skcipher_alignmask(tfm);
	walk->blocksize = bs;
	walk->ivsize = ivs;
	walk->alignmask = am;

This generates the right thing for me with gcc12.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
