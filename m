Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38174231A2D
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 11:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581404; cv=none; b=Vnc0euuyWe46VdB2FU8eKRQnEIz5pI73C9+VLlrlvaPbaKSRD1Hx02n6y+2iRxLRTDrAEL98QiOaO+1TJ/4NuTVfY+gz6meRRLAKwk09xgYEWP1L3SysMi6AiPNBPF7M2LznsfmeQeM9ZH/FRqu80ti0NE2yrJ3g6BabivR/dYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581404; c=relaxed/simple;
	bh=kGaQqLH290LLk2l1Yv1s/U0ny9T69u4bQj32x/nIOqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unO/mrQAdUjLUHihveMoUgu3DA8TsQ26sbtNYm1I/zR1NWMIUp5PZdjbI5dTNJ7xQtmHAYjBncGjUfj0pSE6I9zGfEkWWYgeiElaJygOvTswPoXOfIUW2xG8Oqvfj5RTeDj3VhUWDEUjq2KpVTU9aXEh/fkC/y2q74PyB2cDvgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GDFJ/QoC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GDFJ/QoC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4GsaZ1LzYiQcYekmbfb8ROZsQgLjfYwAltLgXvFNE9g=; b=GDFJ/QoC5beUp8h6OQG5g6tDVc
	Nm2qJeEhkWFwijXtO9uCnf/URjMxc+UbAz2pinEeuO70VcaxnNjGShkJNZqbYyvQySCrLNd6HbEH9
	Yd/hRJhQQGHZIMMOwbO3gREkxVP0qCRsCDzL04cb4ULPUFTW4Xsxj+51kcAAUfDJxgfegkIf+hklg
	iGQXpLqycjA11KvDcLUkmyOJp2Sdi0G9jGTFVU1yXTCMwAutiph3xqvCEIpKWY6L6O8qAtpr8G/mN
	dvBxx02TwvQ3Pfk0YOQ4omqg8iJAWPiL5R/Syi4jaZrAIpUejDsn6gVhUcULWRznkC5B9clw75hEq
	bKnzD1mw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8HSg-000yWN-1g;
	Fri, 25 Apr 2025 19:43:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 19:43:18 +0800
Date: Fri, 25 Apr 2025 19:43:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/15] crypto: lib/poly1305 - Use block-only interface
Message-ID: <aAt1Vrt-sV92Udww@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <6c08ba96e4cb6a6219e06bb77006cba91e6e84a2.1745490652.git.herbert@gondor.apana.org.au>
 <20250424154801.GC2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424154801.GC2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:48:01AM -0700, Eric Biggers wrote:
>
> And it also changes it to call poly1305_blocks_arch() even if the arch doesn't
> have it, causing build errors.

Thanks I'll fix this.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
