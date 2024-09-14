Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F61CEE91;
	Sat, 14 Sep 2024 11:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726313945; cv=none; b=LPO2C/aYAwMBQSMLf3R9X9zc9GLX6AumL0Yh6lq3DanSmEwcm3ZAUhkdaLkvXYWGwcBXGS/dWSq0RCJJU6rpq3ooCedWf7MCV05Hft8AuKMJmxIEfIFu/qsoPVK1bb1abpfFgWSixig1xibI1J2r/XOVFP327+zycSsdAHYJO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726313945; c=relaxed/simple;
	bh=ZetxoFkJPQb/caRq2nXVle/q6AKRnAsQAsgPvbySKdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dzy1VX3qEQRSRi0xOZ/MjIdTrg3xeDi0hTI6VHMAUo9Z40+TBuKmrGJ6Umi56/MZ94EE4Wp6ymXvrs4sgaIZasspUmoBk3tC2lqD//KXDzr6lhk+AAHg326Yrh2TB6w0s543lhI9qU0XO48g+JKHdtgpW0RYvGSXqaZQH1B5Ez4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HN7cIBNT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HN7cIBNT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gLxnozObWeiGuYd0f0ninBdAY8bV9ObeswetAFDkWzQ=; b=HN7cIBNTWgHHX5Smzgag+JL5FV
	Xx2EKCftFIN621TlZZanyUmSlOcJP7Ab/2TzA3ERe0EerCBvDe9yJ6tz3hg9mklMbM5ZlK7LMkFOW
	FsYyKOV/i+s2GGGdESp1ywtRWazaHuEzPE6ZUT1O9w0MBG3FFfz6M38utx2degT9Wpm1RozhwM/t/
	lLpCa7HBidzbzY1NeeeR3z10daiJ5bSmmsaFqWZnMKLZOmUAep6AGbZx0X/+sljIsVxYu/nKYfRnj
	XlvkoWYQSXE+2DHN2sIc+8ZHnYCxRQ3nviOm8bWG2YDMfNQTSwUXfpJqHKnB1ZDTFk+MfQJIpdgqf
	mitymivQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1spQxE-002Sd2-2O;
	Sat, 14 Sep 2024 19:38:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Sep 2024 19:38:54 +0800
Date: Sat, 14 Sep 2024 19:38:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tomas Paukrt <tomaspaukrt@email.cz>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: mxs-dcp: Enable user-space access to AES with
 hardware-bound keys
Message-ID: <ZuV1zguLBsBZnGB5@gondor.apana.org.au>
References: <1di.ZclR.6M4clePpGuH.1cv1hD@seznam.cz>
 <ZuVKtuMqiCu67hn2@gondor.apana.org.au>
 <24h.ZcXr.7FvRaSxxibG.1cvNHL@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24h.ZcXr.7FvRaSxxibG.1cvNHL@seznam.cz>

On Sat, Sep 14, 2024 at 01:32:37PM +0200, Tomas Paukrt wrote:
> 
> Please see the comment in the following patch: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d16af0b4cfac4b2c3b238e2ec37b38c2f316978
> 
> The goal of this change is to allow some users to use AES with hardware-bound keys from user-space without compromising others.

In that case I would suggest introducing a flag so that the key
can only be accessed through the keyring subsystem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
