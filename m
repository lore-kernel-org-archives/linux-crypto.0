Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB7579CD;
	Tue, 11 Mar 2025 03:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663023; cv=none; b=NfDO2C4q3xCwYYaDPWnsl8xx0CNqDt0Ch0kfrQAnuJ7kz++/HsH0QnMt33RSVqkerSRIgm+EkgFfRzFDP1dnK5KtPB+PCydsPnJ4SWz0gdJiaUjP04NmDrm4Q8b1G1lLVwsKYK7V6BaoN+ZJXXk0mzPqc2z2Hh6WZcRR9rH4g50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663023; c=relaxed/simple;
	bh=wiHslj2vjiuXwutcRpNaYqLLvHQbhIGMFa8wKOFpTJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1BupEquKVy1M3X01A4XXPPe7AbJaOc26aMJMOD43azpmN2L2ttXTFrq7Cs3KHVYBmHaOxJn7rIR/xnHTawLhHslzhf6WgrigK24+qO8NjHyFhNoP6D59r4dYsMDJ2SxE0jUYDsSlK2UbfkZW/aRENNSrp6C9uROfrN1dFlkq9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FaEMOFmK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FaEMOFmK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=467e1is8JOix9VmEjoYUFqmjDWXAeS20j6FPzgXuBZo=; b=FaEMOFmKlp37xTq3t2jZ6GFsBK
	WUy0BdFvFvYPQEM0KSRxWdad60YYNftFHQL7mfVyu9eRSy+wR5DuI7UkeKm/QCPRLlH1i1D4CEItt
	nkff7u30VzQ0wHsw33tpFSpV+50IRQh5abUe/ptxgg7Ite3Ul9GUEbcJRhrHD+HWjAkXEUXZYVu/j
	TdebpSDefs8Gxrxxrt1OeXitYgGuJFSFZXvwE487FEIOUjDl/iS0cRSNQuMXhqDugOag44OFo1QUy
	ptNJa8aOeTj0EIBEVs1wmSDpDeY9Rjo/NiJU0dBgY6EPCYc5fCDY2jj0wqMDyqCDAkjGz5cgbrsL4
	6XyPXCdQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trq6x-005TXu-2l;
	Tue, 11 Mar 2025 11:16:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 11:16:55 +0800
Date: Tue, 11 Mar 2025 11:16:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 7/8] crypto: scomp - Remove support for most
 non-trivial destination SG lists
Message-ID: <Z8-rJ5nOjqO-_kBW@gondor.apana.org.au>
References: <205f05023b5ff0d8cf7deb6e0a5fbb4643f02e00.1741488107.git.herbert@gondor.apana.org.au>
 <914f6ea6-bb6c-4feb-a4ac-23508a8ff335@stanley.mountain>
 <Z8-qcLGAIaZXo5fc@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8-qcLGAIaZXo5fc@gondor.apana.org.au>

On Tue, Mar 11, 2025 at 11:13:52AM +0800, Herbert Xu wrote:
>
> > 5b855462cc7e3f3 Herbert Xu                2025-03-09 @174  	if (req->dst && !dlen)
> >                                                                     ^^^^^^^^
> > Is this check necessary?
> 
> This is not trying to catch a null req->dst, but it's trying to
> detect an combination of a non-null req->dst with a zero dlen.
> 
> A zero dlen is used to allocate req->dst on demand, which would
> conflict with a non-null req->dst.

Actually I take that back.  Yes this test should be removed as
it's a remnant of the NULL dst code which has no users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
