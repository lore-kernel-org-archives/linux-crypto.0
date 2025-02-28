Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705C1A3158
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 09:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733384; cv=none; b=LqwjZUzaEXtYd1BRArFo9fgU3g/IuPArxlDo/K1W5V7vic+m00GtxtMG0UXN1UjpaGnlP36iLWWoF53bm5nmOxclV7gseJxHgvsbiSn1qsisIyhhekau8iwHAi8/s/fCVRlTlToOOJkdPBbsIFnEPknuXibUdUo5f4+k01AK28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733384; c=relaxed/simple;
	bh=Y70nHE0lEa3Ct0SWKxJ3dB33NI8C+zExK8msRuokeNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2PEL0Scc9z5Rr4+78Kx8VEGynDnLWceD9KVo2Z63ghs/MEw53CjL9MRzvHKgTJl7NgI2KIr4QaynRWuQxe3EccbnTpga9s+Ea/0+Fzv7uYh+bSdanMxswZ5vtP/PW+K2YpzgAEq5+5muDyFE2X/v8xOvL9jSNIwtL6fbuzftyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JAYZtr1T; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JAYZtr1T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0FNYDq2SttcZXHo+8gMrrvSagl6JhOfUMCThV0iia6k=; b=JAYZtr1TbN1j3JzhTTf0NBSeK8
	n+jxONFnOzOmXlwZe7VEEvQ5cl+B49LHx7XGb6S5tq9kuXNOt6zJszYHbCc3xxxRaew+HsT/xhJSd
	TCj2NiDb45QUhwJiJwoM5amrtfFTaasv6v7myfbOQVM2abu7g+tu2DZFYLQ5C4aKZIqN6BiICJe0M
	VjKDTwFPZdF8DTTSL6l2IKqSJ+7UwplOu7vwiszw2fxUw3bEsY8n7+3hX51f5mwdxlhTlv3l40THL
	npxcAyW0YSyr8fE7ctcYjaA7v/YrwaZ63yP1onJHe2cQ4/Vwq7vTXoLlY3oj6pblTKo+D8yafLFTr
	SAfyrgIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnwGg-002WJA-2G;
	Fri, 28 Feb 2025 17:02:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2025 17:02:50 +0800
Date: Fri, 28 Feb 2025 17:02:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <Z8F7ui5KaSo9a22B@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <Z8Cq7OYkaNtzJoWe@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8Cq7OYkaNtzJoWe@google.com>

On Thu, Feb 27, 2025 at 06:11:56PM +0000, Yosry Ahmed wrote:
>
> What tree/branch is this series based on?

This applies on top of the cryptodev tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
