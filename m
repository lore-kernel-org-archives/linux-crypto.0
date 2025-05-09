Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6916021E094;
	Fri,  9 May 2025 03:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746760773; cv=none; b=QVuTTfmBFjqmvirtHsyyBxPu2qVHCUxlgCbpXt1IAYkZ/qx2PPg023hdphaOsDLdytqLOGx0pVbQJR4FQJKxJrYw2GW4U7DspVn+DrS1RysiDtQbtcLjjj4ZpbJv0XoVyWbFRkgcZkuxn7ATWrq+ICJLGg1/J5/7DahZJXK0EtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746760773; c=relaxed/simple;
	bh=orWV0KwImVaIe1Pg1GNgaP87AmVSYay0c+IU0+2Y2iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dN+BvhFvOFoqvn3E+u08Aqx8put4ereWCBO5oY/DcoykymxL89kaFNvpByrCZ2CRjkIPsj3ykwm0mwFPj3t9aWJuXvAM2wSTp59+i4pBdt87ZKwZn5ixlJjoymHvf4FHj7MSkoznc2gkf0mgl48TnAseyTbNPpJWCnxf9EZIkkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JqtZjoxF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JqtZjoxF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dE7KsY3C69gRveUcK9458KB7m3NHQralEt4kxp669RU=; b=JqtZjoxFaHNb7nB2mMWLV1uOZC
	3BrNBdJRfR76KqHBqGWU8ir/hwBsVUKSLPy5W8eiUplGCjtGXdlVaBFd+gxDGGI69iEIDnEbBZGS4
	m1mEJW/I7OB5QIi2ieSaLgYcqYQa5ft1SJo88FNjCdtNqA/3phTkiu4QaQqa6j6baUUo3WUFZv5Fu
	6oP9hBvOQ3WynYwUF2SH+P2qtXISd8N5K7sAfRQskPBT0ncza+SPNFmEtKS7vi78E3fQy2foN+kwS
	ti3LTEUB2gY2OAUzuux85m/OeF6bojizQ0/l/8y1vYkwSdzFp0J0A1UZr9VNOKaVE1Vxy7n6cM/lK
	dgI/8Y4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDEGk-004kX5-1M;
	Fri, 09 May 2025 11:19:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 May 2025 11:19:26 +0800
Date: Fri, 9 May 2025 11:19:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB10PqZNk0L-ly70@gondor.apana.org.au>
References: <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBy06xyzh5kKC48a@Red>

On Thu, May 08, 2025 at 03:43:07PM +0200, Corentin Labbe wrote:
>
> 6.14.4 boot log at http://kernel.montjoie.ovh/477911.log

What's interesting is that the skcipher tests are failing during
the random tests which means that they'd already passed all the
static test vectors.

Looking at the driver modprobe code, the skciphers get registered
before the ahash algorithms.  so their tests would have started
sooner.

I wonder if the skcipher code is corrupting the ahash state when
run concurrently (and chained together).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
