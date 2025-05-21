Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DE236453
	for <linux-crypto@vger.kernel.org>; Wed, 21 May 2025 08:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747814619; cv=none; b=LV412GsdPRgUjyALf+Cu5ztRfWVfoE7/mR+V83thRhNfBb9qjnibPjFnqxYvjVLcSLjRSR0rlXnpSj62+5hkMgXoWLaRkaNdZTKGqK1AoN1NpTUcP4vQ5MREPwn7QJ0Sw+g+qodIwqqv7T/OYxUS4jflD3vJmkK1D11h6aQw4aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747814619; c=relaxed/simple;
	bh=gf3k/+lG1RwL+Ya7yeqRxrvj7C4fDBD4SxiUfnKICpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEh3qNFVEA1H90Xtzekb3LSvmmff7VBzkKlcv5s92y5+Gby4ZOFbhvvNC2+3V4waw4AxnxFOjwxmgftlvPiWnWPKkGRYkqD1OUQ1zc+wPVfap270uLecJKvNUQXf7gIBK1nZTptVExC6BjM4A0zwkgOSSKUyv/2EozqZQlFwKl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PJb5mfkN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PJb5mfkN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T83edshsAbKPrnnLD56VNZL/C8+22gRLYvq9cRRljc0=; b=PJb5mfkNbApaiIGZ8wUZJzv1Ub
	j3w93Nlm2cFDO0UrnotDYmJEOhvw/s2fL2f39t/fXneFsdyqYEIJ3UmQaWDHwlr4p1HRlVRX1Film
	FqEDpMkVybo7DIpGPlCa7HsLk9yp6F++LIHZdUd3MYzVu6oZA1QRHfcTxNzR4mLuemw0PjwPjP8bz
	K7xSov6AWTAT0RVwvLOPzr64V7GSlMYkVW7J7cdBJz2pOpuL42/0kq6RdQlHCaF7ng64L16/ad25l
	i2zgPNk2Hl1cuSIr/SvAtr93aPsVn9uVcnYtaCfTxm8tqSnPEcDK5LuoiWNrjLZCt/lUNVTRM9CTv
	suaWaCIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHeQF-007kLg-0F;
	Wed, 21 May 2025 16:03:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 16:03:31 +0800
Date: Wed, 21 May 2025 16:03:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [v2] crypto: zstd - convert to acomp
Message-ID: <aC2I0_F2BJbexte4@gondor.apana.org.au>
References: <20250521064111.3339510-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521064111.3339510-1-suman.kumar.chakraborty@intel.com>

On Wed, May 21, 2025 at 07:41:11AM +0100, Suman Kumar Chakraborty wrote:
>
> +	if ((sg_nents(req->src) == 1) && (sg_nents(req->dst) == 1)) {
> +		ret = zstd_compress_one(req, ctx, &total_out);
> +		goto out;

This isn't right.  Even if the SG list is a singleton, it could
consist of multiple pages in highmem.

What's worse, if src and dst are in fact linear, then you're
dereferencing bogus pointers.

Just get rid of this optimisation unless you've got numbers
proving that it makes a difference.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
