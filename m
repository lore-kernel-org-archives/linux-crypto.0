Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374114085D;
	Sat,  5 Oct 2024 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106556; cv=none; b=jr0+mb06LdPK91pvgISwSIY3l6Ei8iQBHI6t16LbOkHHh+y0nMnQmj2fxpwJmukYtRl7snn5f4UPMxJt0pV4lZbeP6xG0LSeBLQWjrRrT9ps8Wees1ei6srsnxcGPTwY/j6mwSTgJq4Jf9wt7wSDqR6JnHOD/RN9OMuBq3HKZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106556; c=relaxed/simple;
	bh=1tbKmxlxcXA+hS7zlWOrxgFssaRDFCNYRlpmn/RlnZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSmGdmGathN0h9AS/ptM8bxRXLFgIo2DxC3gCffKY9AjrX+WgVDXCdqPlJZsKJsDcQsWRXnWYkFwdrvyWkKL0e/VEu8EjlB9ODvy26KhX6CmXM/SWoITB8pF47bvXCk2ItF/ixHmxWRGoL0dS5/ihBPJcwVwR8QB3uxDmCuHKpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bT4fUEiE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bT4fUEiE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Cm/+r/Iu7iT6qjqotRyzDFVjq3VicaFGGYKMIAH+pZQ=; b=bT4fUEiE0R4OQ3Jn19EjBbst3h
	/GULhvNMTDaKPlxeuW4LZeQV4LUEce/O1ovahnW9CimmKIL2fVpNvMrOaNR/HAu2txg8yDYQ9yCvA
	55EQWfbGNRyweHmFxiZB+AiLlVrnrhGEFG3eidD5AlC/aKaKlwozSczoy8jQQcbdxAo9mkvzdVGlw
	JG19blDhjeRPK9hKJWZ3RGBTn0MaJK9BAIIAJqKZvvaZP/8/NaRLZRsyd+Rys6Nmhf/LzTaJ5nvMH
	p2dlOvpMderqf9yYTDzBcgjWybS1BywLfac5/tgcuE2Nkt8ct/Ff8P3S19Qb/6kupjDb9cf715BGZ
	t7FEKkeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxIG-0071bZ-2j;
	Sat, 05 Oct 2024 13:35:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:35:42 +0800
Date: Sat, 5 Oct 2024 13:35:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Danny Tsen <dtsen@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, leitao@debian.org,
	nayna@linux.ibm.com, appro@cryptogams.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH 0/3] crypto: Fix data mismatch over ipsec tunnel
 encrypted/decrypted with ppc64le AES/GCM module.
Message-ID: <ZwDQLmwA1LvWx5Dg@gondor.apana.org.au>
References: <20240923133040.4630-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923133040.4630-1-dtsen@linux.ibm.com>

On Mon, Sep 23, 2024 at 09:30:37AM -0400, Danny Tsen wrote:
> Fix data mismatch over ipsec tunnel encrypted/decrypted with ppc64le AES/GCM module.
> 
> This patch is to fix an issue when simd is not usable that data mismatch
> may occur. The fix is to register algs as SIMD modules so that the
> algorithm is excecuted when SIMD instructions is usable.
> 
> A new module rfc4106(gcm(aes)) is also added. Re-write AES/GCM assembly
> codes with smaller footprints and small performance gain.
> 
> This patch has been tested with the kernel crypto module tcrypt.ko and
> has passed the selftest.  The patch is also tested with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
> 
> Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> 
> Danny Tsen (3):
>   crypto: Re-write AES/GCM stitched implementation for ppcle64.
>   crypto: Register modules as SIMD modules for ppcle64 AES/GCM algs.
>   crypto: added CRYPTO_SIMD in Kconfig for CRYPTO_AES_GCM_P10.
> 
>  arch/powerpc/crypto/Kconfig            |    2 +-
>  arch/powerpc/crypto/aes-gcm-p10-glue.c |  141 +-
>  arch/powerpc/crypto/aes-gcm-p10.S      | 2421 +++++++++++-------------
>  3 files changed, 1187 insertions(+), 1377 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
