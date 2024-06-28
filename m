Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C987EF;
	Fri, 28 Jun 2024 00:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719536003; cv=none; b=DCYtHeKtinpUsLVC82+msAHM2fXqXWm613SqzpTgQqolv+qe8SQb72Ya8RiAnGxy7ngxk1i05S2dvPSIeyRFjQgx+1yBb/dpDwjkkzJl/XAbL2KfvFvLy4A5bxZ7LUsZKYp6Ec/0jgaBrZlIjy0Wlgsz+tWInTlxEEg2HK2dQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719536003; c=relaxed/simple;
	bh=md4UEyG78C4av5K4/Tc6cdXxdAV8iqaxrjZavqHeHHs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ISM0o4uajbY4QUf/hnNxNbKTXAvK3xGfa9n3dIQ6A92mN0OGC8xY1R8XhnZRGezC0hydTz6yR8ROUpCX82Krgwyjctmb5Ev+zWL79MvEsaDpccv1CcypbUsVZA8fs9oKnv5TVUBciYiT7zsyoJ/sAJEx7/adcq4a6mnemKq/kgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sMzrE-004FY5-0A;
	Fri, 28 Jun 2024 10:52:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 10:52:56 +1000
Date: Fri, 28 Jun 2024 10:52:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com
Subject: Re: [PATCH v6 01/15] crypto: shash - add support for finup_mb
Message-ID: <Zn4JaMjT6K+4gX2C@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621165922.77672-2-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +static noinline_for_stack int
> +shash_finup_mb_fallback(struct shash_desc *desc, const u8 * const data[],
> +                       unsigned int len, u8 * const outs[],
> +                       unsigned int num_msgs)
> +{

I haven't got around to my version but just to recap, I'm not going
to plumb this into shash at all.  My mb interface will be ahash only.

At the same time, I will add a new vaddr interface to the top side
of ahash so that vaddr users do not have to create an SG list
unnecessarily.  The API will handle the mechanics of plumbing this
into drivers that require SG lists.  Whether all vaddrs are allowed
or only a subset (kmalloc + vmalloc) is yet to be decided.  Of
course it wouldn't be hard to extend (kmalloc + vmalloc) to all
addresses by simply allocating a bounce buffer + copying.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
