Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C32282E1
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747022398; cv=none; b=rmpG7oQ9/mHxDpyt05uDT7k8v2JFNVHkfqQMKVodHMyBMRhmxoQUDhGp1o2LzH2fm+RqTuEYZw5dcfyQ5PXR0McqsTH9twGYyCUYp97ycmD9ofkNV0mLnUkoOvjDOErA2SH9ooNu7G8I5kZGcW70ZqcsgtIst7DsyfBUoL2cXn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747022398; c=relaxed/simple;
	bh=YnsBVD+6dwjead29qVER1FqfKB5jaH37YWBBB6GKM/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBQz/KRkeWdWGa7fJZf2+FacGpZFCZJqcBuua2euJp8IEzONAc3JSTDYE3EsbAFPX9s0BY47OxppCABcopGpNitOpukTxPbW4aerUjMemNWDy6OFRzwa9UCALMDIudElt2Ln1V0ZMFVGpaWFr9VvOwr8o2cFjy2YXZGeK9p0LPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LArwtZy3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LArwtZy3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nRtJqc25r0wkvhjgzu3c8QRSE3JxSjG6f44blZSuVY8=; b=LArwtZy3WeEWQ0jCrQ1+h480Tg
	UDyBQxysPAt1zq73J+SflIRQPybilw0hipYHl1g8tRWdPLOCST6wZTOeJqSFrM986hq/TEVlxR067
	a3UPPE5wS15zIgQrO0ZmDAZrFQ2ZqwaXQ+ESHhuAOyOBbGfnq+xe9NN20+sQyky4su7T+7Y9keFW4
	gOvsDntnI2W454PNYfR1kjIHusWl2/8IZqZDq2su/kXRU1Vzb2cjPN30Gpyz+UB/p72dOs8oPAlih
	IWVG4C3tMH63fl7AWV1HLyZ1mKVelPti8PN4BlCmzeqGSt1DAJeu56d0ye9E4DoB0W+8Dg/Ji9Ms2
	P5YflHeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEKKO-005KxP-22;
	Mon, 12 May 2025 11:59:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 May 2025 11:59:44 +0800
Date: Mon, 12 May 2025 11:59:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neal Liu <neal_liu@aspeedtech.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Chengyu Lin <chengyu_lin@aspeedtech.com>
Subject: Re: [PATCH] crypto: aspeed/hash - Use API partial block handling
Message-ID: <aCFyMIQml6YXCyoc@gondor.apana.org.au>
References: <aBnJ-fhTAuuf4Vfa@gondor.apana.org.au>
 <JH0PR06MB69675F76775A8771A358F0208097A@JH0PR06MB6967.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JH0PR06MB69675F76775A8771A358F0208097A@JH0PR06MB6967.apcprd06.prod.outlook.com>

On Mon, May 12, 2025 at 03:56:34AM +0000, Neal Liu wrote:
>
> The hmac implementation is not purely software-based.

It is purely software based in the sense that it simply converts
the hmac hash into the underlying hashes with ipad and opad computed
separately.

That's exactly what the new ahash hmac does so there is no point in
doing it in the driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
