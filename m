Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663A22B9BC
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745718434; cv=none; b=lAVf+TeDvn/cq5DktZIXh8MhsuUXxqhRFdk2h+pMHidEjRD8eIch9ltfHyLn5cGhMeLvVw6z6vQf9UKVeAck3qiUPABjvo3Mv/VQLImOysVAxgsA/tUR/PkZIUOmbpNfvWP2hOxPtLJoFcz0J48TVMa2etH3DUma6vRsr39gZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745718434; c=relaxed/simple;
	bh=5bWlirapCiDXg44V9FbSrkrLal4TjlmvbfhguUpc8tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqbeDO0teqbuRIKbCeEM5dmWU7EJHKDoHOX1wJpe/93CYrGZ1kM1V7AbyC1UYjNHeM8tlL1ZLwCqvat/OifWjAr1EhNLFslcra7KGPnMKgNld2fLYdJpgfPK01y/nAx+sTweqxym1yrWUUrNegGlVB1p+F0HAv0aq5TSx3Et2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ui92wHy1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ui92wHy1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eSrFnAV3Xd/3UYdeZM+PfGY6B8rC2IYArNbgCiMa6EE=; b=Ui92wHy1Twpvok60i7LL5TiUgW
	uR97Ib2iyk/jUExjKk+WmYAYSqXS2uxmX3sbwtlPnT3eDrLph4+m1ZrUFCo05YYv4kk2JTIyPK1H5
	oKKo7AkPdi5MAoysehz6lOFneW8ncwAxpVX1jMqlmW2xrRHNgA40qSJhux1Paqi2HB2EzbzhhVRIw
	ofyX71xJ1AGCKOWIP1yzprXmqG2HkjKUBtb8YGiCcpndWco1lHeMbif5NHd9pXBNGR21AuI98pzR9
	CULj4PKBBGqPGXNieG3v5fnCImiwR5fQedSTx2WocLNSql8ldT+umcqk633eMbZjMcNveSCqpXwvd
	52MpuHTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8r6p-001Jm2-1F;
	Sun, 27 Apr 2025 09:47:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 09:47:07 +0800
Date: Sun, 27 Apr 2025 09:47:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 02/15] crypto: lib/poly1305 - Add block-only interface
Message-ID: <aA2Mm-eDnnnKzsAc@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <7c55da6f6310d4830360b088a5cc947e1da9b38f.1745490652.git.herbert@gondor.apana.org.au>
 <20250424161431.GE2427@sol.localdomain>
 <aAt21pphcto2Cjxa@gondor.apana.org.au>
 <20250427014108.GE68006@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427014108.GE68006@quark>

On Sat, Apr 26, 2025 at 06:41:08PM -0700, Eric Biggers wrote:
>
> It doesn't seem to be worth abstracting out further.  Especially with the slight
> variations in different algorithms and APIs which are hard to handle correctly
> in a shared macro.

The fact that using the sha256 partial block code reduced the
poly1305_update function code size by half proves that it is
worthwhile to have just one implementation.

I've gone through every single shash algorithm already and I
don't see any variations that would be an impediment.

> You're assigning desc->buflen to itself.  Which presumably you missed since the
> macro obfuscates what is going on.

I still don't get it.  I'm assigning the new buflen as returned
by the macro to desc->buflen, how is that a problem?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
