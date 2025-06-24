Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6DD280CC8;
	Tue, 24 Jun 2025 11:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765081; cv=none; b=ZRmOd55fI5ZfwxmzycltIfQl+ELRo/d0fEd1YHuLBM8BXolhy6MToNawK1oHOJFknQD12/REtpLZasylRFR1EU2LGXBFbFLU7LHzGS+kGP8sZRVMF9x2ZxL3zCfnQoNaCVnh5UiXPdbZodpVfxOcr3IsKqEFZyDqODyF95xu4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765081; c=relaxed/simple;
	bh=UDqHUC1Dk/VABGIPyur0bI86ybDe6y9IgV48sFN7+FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOPIEGs0Ug9Qx9GSheCMw9BNNxpTEPRJQcVOyjaXGPPcGw/SqawZ1PcKGFnZO+WgLs5Z9L0dl8BkpgxUDPBHQbJkRmEi8nEoRmdBoggeiwqaVohz4lAr+czHfX2ccyZSYWsIfks6DttOXvp17+F6klBKWrP026vlaklBnl7y7Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XdcsDf2f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XdcsDf2f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LZw/6ty1L9t/CWo/sbTmTozblmSQyHbGRwJGD4t0DbQ=; b=XdcsDf2fuEV4TBlbZLfvGdQter
	wUK1WOqRbS11RNHFOa8uFjUxabBINzDphdqKPhFFhsy8EJepnioHiwlYbvY1/UZ0B12RHuLlFAihV
	9J+SFguuI4QmZ0vKQqwjm6AAuF3QueRx+Pgfa8xX7azdzQAwbpxMt9dJeaKRE0hNXsLrvTeQf3PDT
	8XPkgwGIJ+e+EQQGAOYr92JK8UtPe3WaTGI7hBB9gi7j5bsh1AcrtM52xUEbI3VOkWjgkxxKPI8lm
	GuWAkscajSbsnAX6BRDlpgJa48QonYKH+vYMrcO0q3WrcKSph565VWkJ20iBBOm2D4BFCsAlCY2Y+
	JROt7SEA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uU1iv-000ZI6-0w;
	Tue, 24 Jun 2025 19:37:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Jun 2025 19:37:53 +0800
Date: Tue, 24 Jun 2025 19:37:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	dengler@linux.ibm.com, ifranzki@linux.ibm.com,
	fcallies@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com
Subject: Re: [PATCH v12 0/6] New s390 specific protected key hmac
Message-ID: <aFqOEfmr6FP7FDj3@gondor.apana.org.au>
References: <20250617134440.48000-1-freude@linux.ibm.com>
 <65e586b07ff55f21f3909509b6591f41@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65e586b07ff55f21f3909509b6591f41@linux.ibm.com>

On Tue, Jun 24, 2025 at 01:34:41PM +0200, Harald Freudenberger wrote:
>
> as the phmac implementation uses the newly introduced CRYPTO_ALG_NO_FALLBACK
> flag, we can't deliver this patch series via s390. I talked with Heiko
> about that and there are two options:
> 1) We (s390) pick your patch 4ccd065a69df ("crypto: ahash - Add support for
>    drivers with no fallback") together with my patch series for the next
>    kernel's merge window.
> 2) You (crypto) pick my patch series into your cryptodev-2.6 for next
>    kernel's merge window.
> I would prefer option 2 as most of the patches anyway deal with crypto
> and Heiko and I do not expect unsolvable merge conflicts with the next
> kernel's merge.
> So what is your opinion?

Sure I can do that if you wish.  Is it just that series or are
there other dependencies that I need first?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
