Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4747188733;
	Sat,  8 Mar 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741422719; cv=none; b=jZecdzbIpHdcEuI9N+bv1tQyqNbJw6CtWBZSwU5SFqY47FdRxeOocgfnwwwDKDrmQbMZY1DFVt1t5vZFKO2jBY2SW+rFrmb8RTyFTykOIESkY6iNxAkAw+cmbG14GmzNYE0R5f2SRAzgd7AT9WSkzOK6yVZYLHeBG21FRRqMshA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741422719; c=relaxed/simple;
	bh=3AsAGj5LITHXckcZQFBdOahjYXqygagfms+EvBYg6tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKW2z7Afkb19mip5m3cqaLcmX6YZY4Zw58otDIb/ePIqzWi7AmIVWlHfmYmFlTaCPED/J6pDQXnqJKJjkRtjTbBtFD/8SlUxIqrgnxVr2KgKJ2tP3OHYT+5psgvMNUxmQ+AqKIcqM2uJ90ArkPPxqiCFDov8nmjXEiN8lZyDugA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QI50Qy7Z; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QI50Qy7Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nyxHSaV8z8EHDAet7YFpM8+cziZwMLw5X5/7w5W9HEc=; b=QI50Qy7ZWTPiZn+8oSjsCPpktY
	AuU12D4/x8l2Js4+Oa8kMsemd1qsFjhPFxQtCaHiE1sgqY6ydFxaM/4CJofYAaJNQUiDFKyyshGyL
	ISLzAIGhCSME6i0v0KqGUEeqvW23PHcZR2JvSAcG3gpwGf5+MdiyDqIjz8fBLaAbZxlMejQM+TPKK
	3HX0IhUYUkpWPfHIWv5cG/oTubX7Z49E1oeAh76AylWgbiv3VsKDUjX+/8puazBwuSwPD3AhX0+mh
	5ZAqFKkPex8kTLRdjaDzQZThm1brv1eKJzeX73IoVMu6CRKNN+5QPQuL76Nb2QFdJ2o5N6FTEs5qU
	4Qb2ALGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqpb4-004of7-0l;
	Sat, 08 Mar 2025 16:31:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 16:31:50 +0800
Date: Sat, 8 Mar 2025 16:31:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: inside-secure,safexcel: Allow
 dma-coherent
Message-ID: <Z8wAdqekLEyBqVwK@gondor.apana.org.au>
References: <20250226214243.3745682-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226214243.3745682-1-robh@kernel.org>

On Wed, Feb 26, 2025 at 03:42:43PM -0600, Rob Herring (Arm) wrote:
> Some platforms like Marvell are cache coherent, so allow the
> "dma-coherent" property.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../devicetree/bindings/crypto/inside-secure,safexcel.yaml      | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
