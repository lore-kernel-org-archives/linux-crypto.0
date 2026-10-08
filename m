Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30CD47206D;
	Thu,  8 Oct 2026 08:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448590; cv=none; b=dgTB2h2BDMGRlhRlykq1cS+F+4hCr4UwcsE04EWpK4X1YdjnVXy21KnaRyetfQ1QVC99HN6joN1eQIfBkmTXzRB8EzZ74XLGMnxfsIDqi4p5w+NFvqzC1B3icN5TmNh4veXeYLulC5UVNp9xBUE6qVKYdqE7jzYv+5yHy6AC/LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448590; c=relaxed/simple;
	bh=52PWPkkSBeKlJQE8U411SF09zasg2JpEnqS5XrIESD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp7YuFMAQhnuHSASabYItRy4gzA84sRvq49KxqbsH6NRW4/LpCG0Kl9iMTCjic7muwFYhzp8C+/QzTIfFWBlk6RqaMZHNtABWzaS5VmslYBT8jOE4e371TbYkQkGMP5o6ZxpbMNds7ZhSV/3Cj9DmnUalyCW1M51KjERrFrc+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=E80Z7VWo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="E80Z7VWo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9WX991k/EwP8NDLtyOX+ZpuAfd+ibtLEBSgnh2Kmjq4=; 
	b=E80Z7VWo6wl0gv8XVreOSQhM0YJXbo/ja3JeTZ53hOlVYj2tX5Y1/TY1+RCH7/8jt/ltZnpZBlZ
	Tejy09djcqe6HqTieYdXIbdPTaK/Z5GxCxEDL7AUQEMGXM2JpNsqj3OfAuFQaWeKYZVfaPgAQ84/P
	U79xYVsq60JHSygtMsk8BFOgQIXacM0yf5sGD47UwMjhy8R5ZXdJj8eOBgXKneL1KBRLQHJ9ykWwj
	6OghTPoL0ypyHYnUt5zKTVIUq3pDot64nxUS7frZgvPtrpyEpsWA67rTOAVYfFBFIEyarUBiVuezD
	hpOVIelHd9z+3Qhjxb+essDHIZFvHMJqg0WA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjc0-00000001o96-0Kmo;
	Thu, 08 Oct 2026 16:36:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:36:24 +1100
Date: Thu, 8 Oct 2026 19:36:24 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - reject overlong RSA CRT parameters
Message-ID: <asdWCJgRzQuH1wH0@gondor.apana.org.au>
References: <20260810154024.3178145-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <ao4xobfWhs5Ss8Uy@gondor.apana.org.au>
 <752d9ff313bb52a7f8d2295161c1d9a4@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <752d9ff313bb52a7f8d2295161c1d9a4@oss.cyber.gouv.fr>

On Sat, Oct 03, 2026 at 11:21:44PM +0200, Jérémy Jean wrote:
>
> I don't know for sure, but it is still getting fixed, e.g.,
> https://lore.kernel.org/all/FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com/

Can you please repost with a Cc to the new maintainer?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
