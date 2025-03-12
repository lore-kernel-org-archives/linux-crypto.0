Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6335948
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741746612; cv=none; b=Pgkcfr/gK1whIYd5ioO5Cf6m+Cg1tNnSZmczPDn/lhY09tPMl3qOLT5NAPAE44U7f21+a7wW2M0VuVC4I9kCtfi3q9wQ1OrA+xCNHx9brv0oLwbH3doTb/+Q2DvqwbmqaCZNt9zYkyoISNi8zVA/vjk7pYUJijCgK5hnYO7dBg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741746612; c=relaxed/simple;
	bh=4I5IPR0RcD/SeqxCxoC35XA6iCStYvs/ZTovOAwA/KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zc/cnx18YLKMegbaWQSQrxqH8w9WRRDjYn14yEsUV3tSCVcMYfktdO6mW/4ZNwGQk6ayP/rV2NKPWbo1e6Kk5xF2GZ73U3P8oysosql2E83cGFCKP892ayfHGSiaHmjRdRZDnZ6V4rnIUnN/rDD2ZJWAITj1XP5C9xs5PFuiJ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QmBMcjWf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QmBMcjWf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u2XRPUaB/PfSRMeUCpsBJpjajgnneHSrxurH4TJ/f7E=; b=QmBMcjWfAxv7KE7RkF72FEKTBI
	fnhnfl9xXIDhJeiSU3hSzgALvz6EUS0QQZxJ9c9HoFGe1U9/wl+IUFPuisChevvH34MXlNkDGT4lt
	rjNOaBvIHlFS/UQbH+eQL6IsikW4yNoJqyO+t54uIn3CPymOMTTPptDlO5Imf8vEHpIPL5iW8Fr8E
	m3QrQDm+Zfau7/yENGmGE92v82nd+9YuSZdcUEh/GfgyHPvU/REX1abEBbXEvV6UuCUAx5PqNXhXK
	MT/2sK5TnarU8V38stpek3bidlmv0Ky9yBMBosLSmaPai7VJeEcYpEuApjJ+Gc4V08hNKe0YumSC5
	wl5ma4aA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsBrC-005lbG-0F;
	Wed, 12 Mar 2025 10:30:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Mar 2025 10:30:06 +0800
Date: Wed, 12 Mar 2025 10:30:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/3] crypto: hash - Use nth_page instead of doing it by
 hand
Message-ID: <Z9DxroRzYKSu2u6j@gondor.apana.org.au>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <e858dadf36f7fc2c12545c648dda4645f48cab22.1741688305.git.herbert@gondor.apana.org.au>
 <20250311174431.GB1268@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311174431.GB1268@sol.localdomain>

On Tue, Mar 11, 2025 at 10:44:31AM -0700, Eric Biggers wrote:
>
> I guess you think this is fixing a bug in the case where sg->offset > PAGE_SIZE?
> Is that case even supported?  It is supposed to be the offset into a page.

Supported? Obviously not since this bug has been there since the
very start :)

But is it conceivable to create such a scatterlist, it certainly
seems to be.  If we were to create a scatterlist from a single
order-n folio, then it's quite reasonable for the offset to be
greater than PAGE_SIZE.

> Even if so, a simpler fix (1 line) would be to use:
> 'sg->length >= nbytes && sg->offset + nbytes <= PAGE_SIZE'

That would just mean more use of the fallback code path.  Not
a big deal but I was feeling generous.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
