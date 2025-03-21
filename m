Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98C31C2DB2
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742559677; cv=none; b=V3gbruvIENozbm8XbsgdPonlF19m7VLk5FogCyf1WQYQ1OYkcyXAd8G5rzQN6WCDzwytWAFoA6gdv2axpFVdrIYRTVW+aU6ZX/R2r/nnCOwOFmvBUh8Qz5w3MPvmfrDPW8lqJhhsQmEd0iPSkIxG8GYyxCnku6CUKfPV3s+h6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742559677; c=relaxed/simple;
	bh=VMSxpQ/HLkGmz+7f9nTCm9sijD8TbQziO8YgMqI/7Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KT/gP7CU3LSSX8x21RUYvzbFYxWUIshuTbwJDW1epPjXDFSM4mbsfXzu3OPMDtYF8Oez5nL35PPcEW3m24oILvIUUgG/wCzvfaDbyyi82jioI2qJsBPtlSOEJ3BsqXH6yUMNz3tjfZZk3jKAwi+lFroDNROd33rVfdnJfHdGMrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FvnM8Cq/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FvnM8Cq/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2rmjnTdgzElwiYL3D8IaH1hNAh2x13Fm/Y4VP/7lrvY=; b=FvnM8Cq/d+cnJ4jMp5XtRL9gTL
	TbVo2YwmLnMBbgXd5LKwXGsd4H1eyDgsFtOtSazLOU100kgnYaJ42rPOLAquMdVXayMWVkBoZdK8r
	H9ls1TyOsg2xzNEYXtlkfRG5IPlztR4vqAcz+vFYpH4lWSP3C4iE96D9BE5J4kbUH6pGnIS+meX+w
	OFUk7eXMktnMYhAlPtAHopxmajFFhMnDmj/dER7XPufc4aA8R2wBcohOXypXce7Wr/TsOcdh5Agwj
	uCXlGzSAMS2BaylCFMX3J8cUxTOdzpbtiTPzvpD2AXs5LbEgq7g1ufR+zeLddTjlb1/psg0LqafAm
	IHg1dovQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvbN8-00917b-2b;
	Fri, 21 Mar 2025 20:21:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 20:21:10 +0800
Date: Fri, 21 Mar 2025 20:21:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: arm/ghash-ce - Remove SIMD fallback code path
Message-ID: <Z91Ztqm-qtZNgpJc@gondor.apana.org.au>
References: <Z9zupEU1itUXzaMn@gondor.apana.org.au>
 <CAMj1kXGz=nFchp683XqTvKFxLWXebvxMW496awB95L8JUwxytg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGz=nFchp683XqTvKFxLWXebvxMW496awB95L8JUwxytg@mail.gmail.com>

On Fri, Mar 21, 2025 at 12:51:42PM +0100, Ard Biesheuvel wrote:
>
> Are shashes only callable in task or softirq context?

The entire Crypto API is designed on the premise that it can only
be called from process and softirq context.  Hard IRQ context has
never been supported.

Of course, that doesn't mean that we actively deter people from
doing so.  If you're aware of anyone doing this, please let me
konw and I will look into it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
