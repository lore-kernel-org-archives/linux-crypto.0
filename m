Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F24E80BC;
	Tue, 29 Sep 2026 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684987; cv=none; b=NJgSbYDrlo7aVsmQk1xQSlZt6sSWoHWmhyFWigynRZwMndm+iNti4TKAOSN1t26Vg9Ed1cLv/JDTr94yUJuquBLqJyXEdFqbyqYIArM4ogiRglfF9CRtjcQimTnxm4oEcUud5PkOT+qPK8M0vCtZu8RBAo7vVNdBxShDpl52hko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684987; c=relaxed/simple;
	bh=VHAhHnezYBd7J/bmChRu3tuXqghhmGSANCHL/AYasUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByPbZLZYiFU7WNzNo5q2Xh4Gy+Z6nQVYCdDa0hsgxplhR9DpmcobpwCxRF8GR/6S7GoAp32smza4PBEgw/7izgJSH8/xZu6IWKUQ8EZ9I42laccTZYCV+tvlZwdb41YFxRuhODFa6oMQJbWIv+LHd/1+88EKHtqF7RaASQtvLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ikipT74B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ikipT74B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CbN2+lu8v6PEj1VxXWPoKgsEuGGU/IXvOnEXwuo7n+Y=; 
	b=ikipT74BRQz7W/l6y17QkV+wIec8UsusIAsPujpkyK7LP1JnfuvPmFTLIUXXtEUuOliNesX2eMM
	5XsQiNZrXXb4K4aV2svDnX0jv2fYG+GzpqXsqWkTwzPje9vCdJC8Jfbgx0PS6IannPBunFeuf+KSy
	0zLXa0rQtAt2MI21gkwWPdYg14AgixQG4VfhZivQLUP/zzWABTLKNBf+6Iq9YM0yfU4Y7RTvw5kku
	29jIOsRYBj9hfQFLGLFQzyc+0MaeTnq4JJNGNkgt7cqPUf6u+cVl/F1P634jbqG8luZgg72NFsZ0Y
	E3kpymrxSOUIRnq00En5vdtxql/Zf14yNEJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xBWxY-00000001mRV-0mCe;
	Tue, 29 Sep 2026 20:29:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Sep 2026 22:29:24 +1000
Date: Tue, 29 Sep 2026 22:29:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: vjardin@free.fr
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: caam/qi2 - algorithm priority be a parameter
Message-ID: <aruvJECCDNdguMdw@gondor.apana.org.au>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
 <20260928-for-upstream-caam-qi2-priority-v1-1-e4a8e5f01dbc@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-for-upstream-caam-qi2-priority-v1-1-e4a8e5f01dbc@free.fr>

On Mon, Sep 28, 2026 at 04:01:03PM +0200, Vincent Jardin via B4 Relay wrote:
> From: Vincent Jardin <vjardin@free.fr>
> 
> dpaa2_caam registers every skcipher, aead and ahash at a fixed priority
> of 2000.
> 
> It is above the ARMv8 Crypto Extensions (200 to 300), so on any DPAA2 SoC,
> every in-kernel user of AES, SHA or GCM moves from the CPU to the SEC,
> whatever the request size.
> 
> Whether the SEC should be the default or only be reached by driver name
> depends on the system, and there is no way to choose/tune it.

You can easily change the priority from user-space through the
crypto_user interface.

So why not lower the default priority and let the user adjust
it if necessary?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
