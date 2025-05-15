Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AD211276;
	Thu, 15 May 2025 23:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747351563; cv=none; b=qlVe3T6Lp9R5YgKKkTnrlehtwfMPjMeyI3eOkzkVwx89WWPqE429XO9mYZyH6O9BEIAsFTNCxPaYcKO7153bOUvO7eLPFrkal/r2dgpqtFDLy0CcH06HBZRT2Seytp8MYytz1jTyCZ3ZMYmy8VpK49NtPuz/eCShvsRugeF/eGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747351563; c=relaxed/simple;
	bh=mw9/BAhXb2qHkrwYtyOMmpW0tLYOxZYPqTvqtKkGiVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XiBU4dtuagwgoKgVG8hnPMypyS8vuU90Ei3p2mzQ3T5h2isnnhqabgoRfOSAvUjTFhLFQGtTwcSDrLVj95cpsO8jUpoRywPacXJcQBo+D7P01gwyJAnfnRvCsbRK4XdXBIY81LZcZ9PB3T6ml0tZXhH0rG5PaKjQPJFO2NVwrEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ml1+uyx3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ml1+uyx3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hizxHZhxdPn8Y3F03YsB7R1Oe8f9AaxUsu11/H4PZZo=; b=ml1+uyx3eZ4QLvqtYky5FgMhKd
	NPBnNxmsz3/P6GYBqAFrgbb7EDfQgKNFZz4v8FB6zuF8mmzfAf7yiPrTQzrXa0mEyHqEeBDwLTvZ3
	LxYXcYaR5gMGvuLHdg5wqnC3D+YvoP+zjV4giDGo8Jow8H5QsYoTNDOlnf6+9wkFZiLDZNFKDcaW7
	79ainoySstVQRJcSPn7dxFWBTO9GyAhOO/ua8rS5l37DiUJ3rtzNU0IummbC14jYeHakBwkutnatg
	SiTCJD2Z/abzE+JsIQdn9T/XAcprkXOCjdO/n05algtqa5Ci9bVqE3CSqhstQ3IiSjF9s4dRDqDLx
	OloEVQZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFhxV-006SfU-0x;
	Fri, 16 May 2025 07:25:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 07:25:49 +0800
Date: Fri, 16 May 2025 07:25:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
References: <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>

On Thu, May 15, 2025 at 08:45:39PM +0200, Klaus Kudielka wrote:
>
> ...and the failing marvell-cesa self-tests seem to have magically disappeared.
> I now had five successful reboot / modprobe marvell-cesa in a row.

It's always unfortunate when a printk patch makes the problem
go away :)

Correntin, can you still reproduce the failures with the latest
cryptodev tree?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
