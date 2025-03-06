Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EB018E351
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741231102; cv=none; b=pK/0PNrbuAAtBBBnQYHaoxCInDQE2rRFgEHfpW9cg0+vnm7y/tqB//StTu5CJifjoRvme7Mict4qHu7eVynlXyaEu/L3bvDP0YZMVZ7GkRthnv+EVTbVyEj+EFCvoU6rW1pGXGawIhmfF8HSt9K227NUnoOUfaFvt0c9BvJ8bvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741231102; c=relaxed/simple;
	bh=CLkVwIRRYuwHXh9/Uy0YWgD/GHjGQ8f7lvuK5I1HRVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTIugqWZW5KNRP7ikwI8wkgrs5HTqQJlvDXIuWcq0ufdplTtJHHMRxqCm63u2bVvU8CAOs9XlCYlR5ZJG87g3pjYP2THFmqU+7Ws55H0i0pBAnu8MwFMIxAsKsHXFFyvmECjS1EkK6PNxT0Zo5ES/uteEHo6/SxzB4XJbdLDbJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=D+72hUGk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="D+72hUGk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P7vqTI3+XeMnirnCnjPN5Api7gr/HHmK9QIyu7+n9xg=; b=D+72hUGkDVsVp/VLSwk/J8HBBR
	Z5O1Vx5smJ/oqwJwCod8LyHkWuB9IjuLF0oldDWjooZSccgqY9FXGtPSifQLCw24BPQadwLj7SeBV
	hWGBk8Tpmq3lX+HgbPfxwbaiRUSs3FNLz+cPMgoUjMnWbJKMaNI1UIqZ0Fpe1b/B4XN5rqtA1HKHb
	FsGeaXHa9uHm/ZQq7/UfwdvVaZ5TT8TCciusbKdQl9jx48WmgjqcOm2cbR19oAeaZdju5qNRwDOG/
	oChQjlACg7nAkClyWijhuMJbwr9jy2nHxOfkfwasp74W+/bJirWIChgDIDjTrR9KkWujXQOQwkOId
	NN6CMc6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq1kV-004AJf-2D;
	Thu, 06 Mar 2025 11:18:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 11:18:15 +0800
Date: Thu, 6 Mar 2025 11:18:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <Z8kT90qXaTo15271@gondor.apana.org.au>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306031005.GB1592@sol.localdomain>

On Wed, Mar 05, 2025 at 07:10:05PM -0800, Eric Biggers wrote:
>
> Why?  All the callers keep track of the address anyway.  I don't see a need to
> bloat the scatter_walk structure beyond a simple (sg, offset) pair.

Because the existing convention is error-prone and relies on
the caller keeping the mapped pointer intact.

But I will consider your objection about bloating the struct.
The places that I've changed are simply storing the object on
the stack anyway, so there is no actual bloat.

Do you have a usage scenario where this struct is embedded into
something bigger and bloat is a real concern?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
