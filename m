Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094FB23D29F;
	Fri,  9 May 2025 03:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746762198; cv=none; b=sfo0blfn3x43MnfzJBMzspMuGCZqn7CBKs1FNVA1jn9TKIeCuAUowNJrtPHwKhle8uiJoPvbeSHy9zv+BSiBO2zmKp/BGiqPL2hu9RphhQTICuhQp4fwJhrPT+Hx2TWb1LIMFKyDBR36/lKw6fdoimN1iVQZKcrJ6jnG40o785M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746762198; c=relaxed/simple;
	bh=dkgAWJ0H7e2FQVD5K7M0InW6zg3HUvA18Kt1Cavcnfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiA5BVDYHWThF3SZeNHDNG20Bk4wGRWJnZEDZnb0msesO1M7jii2oNICMYJRuxaLLeU8GuzbUyOOUxha39RLS4k2aWpymp/dWppS1C2XVWJZ6Cn0gRe1tMbgEq9f4/3xgFUP9msWoYAIv5qXqpEu+PHbptw1MfQqtTbTpy8961c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rbk1b0vu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rbk1b0vu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MgvkC7w5PYOeAubPmZHQ++5Bvo20B7PfGo6lMa0hvMU=; b=Rbk1b0vuTIPNlmgnw4AX5MTcUc
	YFbjecLfSx9qZo8sdS3KQJG7Qpk7Gt0blMUB65/6JKWviwb+FuH1MnDZ8SwXiH5ZMT8FpAhXMN9lC
	79tLEG91NQlAW8G97ERVpk/c/JfV/R+O6gBpwQIEzdzqT6tmduGO0dvzl35xFxxB89fd2x8BEJGhP
	VEniirdHGbLSndSSf0NxvYZWAfgimLaNvz+Ssoep0di2aY06CjKx82uT95nHhaPRLW4YD7VSOPIu/
	SKAhO0CnIG/3FDL/cZEzfPPoHvBG0/Dz7jCPvABMypIrape4Ow3pgZRckyTSmekwZCWLBUBrIJCc8
	+4Qr4lAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDEBP-004kTa-2W;
	Fri, 09 May 2025 11:13:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 May 2025 11:13:55 +0800
Date: Fri, 9 May 2025 11:13:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aB1y8_T5uEEZhyrp@gondor.apana.org.au>
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
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBy06xyzh5kKC48a@Red>

On Thu, May 08, 2025 at 03:43:07PM +0200, Corentin Labbe wrote:
> Le Thu, May 08, 2025 at 09:10:13PM +0800, Herbert Xu a écrit :
>
> > Do you have a boot log without this patch to compare? You seem
> > to be getting skcipher failures as well as hash failures while
> > the original report only had hash failures.
> > 
> 
> 6.14.4 boot log at http://kernel.montjoie.ovh/477911.log

OK so it looks like on your machine the skcipher ENOMEM failures
were always there.

Let me stare at this a bit more.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
