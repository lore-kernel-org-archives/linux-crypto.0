Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8092521C16D;
	Wed, 14 May 2025 09:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747215724; cv=none; b=LkOl4oz6RhId3P6VcgeHwEDdCyKWQSjICBwPwB1AvuDpDWjDmueltrW4V7ZItUpA8DkH7TaQYgcKhLiF6uoDsITT0Xazv10U9iGMkGME3+kq9q9enNu3A7x1Y+2LT/HDf9QHowuDNOBmj6qbbDlK2iKkbE2Sia9Vf0V8Rmc239A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747215724; c=relaxed/simple;
	bh=0Ut16LIaYGIjFMbKLp14mbhIT9qAkg/mTMfHtgyYx3w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BiqzX/RfIwm5ExxqwBSD/6l9o10y+bmH8sbhOEpqM4lc6tQUn7e324E0okX9RGDnxBMY4OoOLfKyTq3ZTisJXvJRe1w/BXRAE0D0FGWdyqMBYH3Tccg2r6C/5f2syDW1ixX4rKARUhHPWZfbPa+i8+QEFFQvz+Ry6WaUz9p+K1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=p9hJyjbA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="p9hJyjbA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0K2DM5nV5WtDSjS9jWdRAsQawmnoY/TG6puxv5DwAmk=; b=p9hJyjbApouhBcGjnABahtwNoQ
	uEQ0OGw0yEiSl/pRhId/FW1/573aE+v5M6DAHIsjr8rHygIPxQSZlh993gALhgAtFPwwAswBesmRY
	gKcSsoZl1a9VJX5IFC5mKKEpEUpMjbEXxCZ79DANqnje+eHjmrOkEDJgoTXUNSeof8+vXpcQLYxAu
	biALK1ffIYikhFhiPfaFOmpScVO4HCYg1rf05np8UoesycDs93adGDiMqTBkH2vWAMlOzC+pO6+HC
	reZgy5+yE2qLqrAvYXdroA7tsdp8/XpDLYVemHXZEELCcAZ/aW1u5znuVlvBS0WOoj5gV0to2TCDo
	tz4UuOcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8cN-0060fl-2v;
	Wed, 14 May 2025 17:41:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:41:39 +0800
Date: Wed, 14 May 2025 17:41:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org, dtsen@linux.ibm.com,
	segher@kernel.crashing.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Message-ID: <aCRlU0J7QoSJs5sy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514051847.193996-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As discussed in the thread containing
> https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
> Power10-optimized Poly1305 code is currently not safe to call in softirq
> context.  Disable it for now.  It can be re-enabled once it is fixed.
> 
> Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/powerpc/lib/crypto/Kconfig | 1 +
> 1 file changed, 1 insertion(+)

I thought this fix should be enough, no?

https://patchwork.kernel.org/project/linux-crypto/patch/aB8Yy0JGvoErc0ns@gondor.apana.org.au/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
