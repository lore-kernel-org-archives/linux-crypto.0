Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794394464;
	b=pk8hiBHLkP5Cyg1/9umA2NT9h7GQsid9iSS0KJh/tplwiw4UkgdYH91GSSwBEDeETyOu
	 qqI6TEjrTI5fAO64/wIJiYm7efYXhtg6dIeNNSnDIConei9cVGm3GM2oV2ecZARVZLFXj
	 /hnFkiAv/4FK/TqG4gZg38odnGNhxmaaGVw0a1uCAty9VXVJmLtwYF/p96mLF2bWVnW+c
	 336bmukxXl0+oKJMGAotVTJPMJd2E553k0irF+N1lC7HDDQgwMCRGukRtC2Sej2CzMwFX
	 M7Y9tDBiYfeXsylzlDdoluf4BLJdfIvIweTXf9IfitRpyuqUSeLDyoft7qbzt8pXCAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794394464;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=JEoFYnGuCeiBkVgGA3FxSyDwJ92WczzGCGhP9HcNC5E=;
	b=FNu8rHg/xWvgic3C6pK4skHAgJcUEa/y5A/tZQ7YwOt17NTZOdER4Ookqo7V8NRRYMb+
	 n4RmFRYJsWil2WO6JbQhGQ9gJDHTDuptV0cy95arE4Vzqld/9YMl3PfzyG7UpL0Ps4eQM
	 DWInjrrbfP/fxUmueBjbV9CbsHHKMgyDJCzhy0q72BksRX/+HJdhLBS4JP4KBd4KvGw2R
	 Wwc2J3XkDzYkrZaibgfK7o+quAgw10kmY7PCLJ1Kx/erVtbwht8wH/iPhU9Ld6CXIQg6a
	 RphI2vT8ImPy8BGUh/xTbqze4kEetz/zzgQsLyHOoEfmn1nrC94gG0bNCVsAW1Ci2Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=mSedsnIx;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A772E606A891;
	Wed, 11 Nov 2026 10:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A772E606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=mSedsnIx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JEoFYnGuCeiBkVgGA3FxSyDwJ92WczzGCGhP9HcNC5E=; 
	b=mSedsnIxW2LPbSStiogrDa17p/U6ptixXcUjQKb791LG+a6Rkw3uaFkjOrGKtLERU44ZFHq6UU3
	kYzPVX0xOrzPmYnyIBipfuHAT+HcvrPXY6pcGq40xDISNN+HTPFethPE2v6BaePPKMMV2Mkd6g/3Z
	h9AJmZl9Lc2zkOhlRyRuUspsd8lVv5365VkrCuCmYgepwqFeETsvXwvvMuasGMS5yOTPWtrQGBC0Q
	NidaYFnUQ97mkynzgaab534t2fEiuam1IbVGY5Md1RCXpEsh4tEA1QGoxoFGfiqe9HKCGxLoKDYGl
	IH094I9Wh4cRABO4eEVHp7G06hm2an9IRKsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR5y7-0000000Dm2r-3wtJ;
	Wed, 11 Nov 2026 18:54:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 18:54:19 +0800
Date: Wed, 11 Nov 2026 18:54:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sahil Malhotra <sahil.malhotra@nxp.com>
Subject: Re: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA
 mapping
Message-ID: <avRJW9494fF7Pyf4@gondor.apana.org.au>
References: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com>
 <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com>

On Tue, Oct 20, 2026 at 03:25:11PM -0400, Jeff Barnes wrote:
> CAAM can receive RSA requests whose effective source and destination
> scatterlists are identical. The driver currently maps the source with
> DMA_TO_DEVICE and then maps the destination with DMA_FROM_DEVICE.

Sashiko has some comments on this patch:

https://sashiko.dev/#/patchset/20261020192511.3389133-1-jeffbarnes%40linux.microsoft.com

Please also explain how your patch interacts with the other
patches on caam:

https://patchwork.kernel.org/project/linux-crypto/list/?series=1189382

In any case, as I said in reply to the other patches, unless
the caam maintainers step up I think this should just be removed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
