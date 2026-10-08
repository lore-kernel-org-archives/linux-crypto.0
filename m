Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423814749C8;
	Thu,  8 Oct 2026 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448376; cv=none; b=I+Mj4nlUSD/jTpI/KpYF9xUSFjsxfDCnFJAx/lhrlfEDRa+38avSGLWNpNYzUb2npiGbWHHEcXvkh5cemaBDEuhNnRl4rKKk65F874/lt8yEFZejEPRQoyo1BHx164jK6S5nhhsBr4jN0nRYVq1u6qX8GZDx1X/019OrvoPcYr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448376; c=relaxed/simple;
	bh=bSPGUwNA9WVtjNFe1zBAskIFVZhvDGWyF2n96SD+oZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3UtYAqarb+j05Bqf31AdzG5jEDr7ArD9EwUcvX1X2XdGdoyx/NEaiBtqR3zWa/vBcCp+5lHJvowkSqLDTCDKzIEZYUKy3YTXgqGMMfJPwx8yWLbjN/oFuyGg47Y7kPQ4ahtOat6lt5WRN1LOEDan/FZPk5I0Plg8AKyoA0IMzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JVXA4vyR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JVXA4vyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=se5Hy2e74s5kNbpWYkS7MkJgiRenrPVP1MpSsYyMaFY=; 
	b=JVXA4vyRPis1O2kLSQtK8EPeXN0MQDUD4BhKMr5l5eS1VEl/yohaklcelSx3prs3iksgbOsQzah
	BOCYR0FK8igbf2zC3mCUMNwXFsT2ZG3XZ7XaZAPO4cE/mZnVwTNqbJ9fmksx8k5BDymR2cnG6iigm
	rzo/16H0AxzLBm2OHzf2M1nBUYLyDmhS7xHgAfeHaV/7ouALSvycb7uaCi7PWKqSu/AikHo2oshn1
	aXdtJqNjurd5iJbHEpZpyqNcHbPnROHR+SHaU4BM8cEo+wuG9d12/b0qjIHjKahW3u4/cfg0QHRta
	i9ZEYemetSijrIyc89162i8PvAeaBGzcrJKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjYW-00000001o4N-22wj;
	Thu, 08 Oct 2026 16:32:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:32:48 +1100
Date: Thu, 8 Oct 2026 19:32:48 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk@kernel.org,
	conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com
Subject: Re: [PATCH v25 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <asdVMLcq6hELZ-eU@gondor.apana.org.au>
References: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
 <20260907155916.999153-3-pavitrakumarm@vayavyalabs.com>
 <aqz45SDR8judkwk5@gondor.apana.org.au>
 <CALxtO0nptFbjV-h567rag=ibWTxb_2PtG4ZEKCiAufTt-g-bUg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0nptFbjV-h567rag=ibWTxb_2PtG4ZEKCiAufTt-g-bUg@mail.gmail.com>

On Fri, Oct 02, 2026 at 10:42:44AM +0530, Pavitrakumar Managutte wrote:
> Hi Herbert,
>    My comments are embedded below.
> 
> Also while bringing up an async ahash SPAcc driver against 7.3-rc1,
> cmac(aes) and xcbc(aes) fail their self-tests at tfm allocation, and
> I'd like to understand whether the underlying cause is intentional
> before I work around it in the driver.
> 
> All tests pass for every hash and HMAC we register, except cmac(aes)
> and xcbc(aes). For cmac(aes)/xcbc(aes) it fails.
> 
> crypto_ahash_init_tfm() allocates the fallback with:
> 
>     crypto_alloc_ahash(name, CRYPTO_ALG_REQ_VIRT,
>                        CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT |
>                        CRYPTO_AHASH_ALG_NO_EXPORT_CORE);
> 
> On our tree no cmac(aes)/xcbc(aes) provider satisfies that: with both
> CONFIG_CRYPTO_CMAC/XCBC=y and CONFIG_CRYPTO_LIB_AES_CBC_MACS=y,
> neither the crypto/cmac.c template nor the new AES-CMAC library shash
> implements export_core/import_core, so both report NO_EXPORT_CORE. The
> allocation finds no candidate and returns -EINVAL.
> 
> alg: hash: failed to allocate transform for spacc-cmac(aes): -22
> 
> The library shash matches ASYNC=0 and REQ_VIRT but is rejected on
> NO_EXPORT_CORE. No candidate remains. CONFIG_CRYPTO_SELFTESTS_FULL=y,
> so this is hit deterministically.
> 
> This looks like the case flagged in "crypto: sha256 - Implement
> export_core() and import_core()" (Eric, Sep 2025), which notes that
> since
> commit 9d7a0ab1c753 export_core/import_core "effectively became
> mandatory... since legacy drivers that need a fallback depend on
> them."
> sha256/sha512/md5/hmac gained export_core, but cmac(aes)/xcbc(aes) did not.
> 
> Is the absence of export_core/import_core on cmac(aes)/xcbc(aes)
> intentional -- i.e. async offload drivers must not rely on the core
> software fallback for these MACs -- or is it an oversight that should
> be addressed the way sha256 was?

I will fix this up.

Thanks for letting me know.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
