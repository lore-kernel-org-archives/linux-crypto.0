Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B9036894D;
	Sat,  7 Mar 2026 05:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861308; cv=none; b=QLsqvmSaiwAVmYyEKeqMto/WmMRXW1FNpqwjEVJ7p3sU85z0OCCC9TXcVI3d5gKIoQwVd5YIeS1s1IqGo3twRySX4XIgYIJkGWg631Zj9mzVWa+syTHG29e0TOLVGTr8QKzzCcggDqntyw3YTaPZyJXgJ94NLimKkqOi9JQLcUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861308; c=relaxed/simple;
	bh=OQNbLzyU3Qmf6r/JkKGRWkfEDA/7PAQQuo2Gn3W6BJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyxBlD+KAhFtd8NdlgQ/biiN/JjTM0vVpHMFoQ59p0JUFJEPELSyT02F+UPVu7rpCJFl4JSd4tg3SgddOEUf5rv08JNaJoy05WXIrvB0N44C3EvAD/MadxzgWsF1dUXz9fdLRyUyrISey+9cOCRiAojob2EwBXE5fQ6xK/NI5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fXVndNcp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fXVndNcp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yo+IddqOCrOr1IYUEm6NZ6DdLQMY9Wy4rdVxCyJhmkQ=; 
	b=fXVndNcpxKTn5xK1z1lOIwRIPB1RKDW4SyGoPNXMlQG5N7+T3j+MydEQ+H9JSLlgACtmJWLQ43i
	ljSl7Rg2WsU+UjBfLTBAtLemvDUEZEAkcbFg25W3YdEDakzpDwPI5X5MrbzkZdKw2L9M5AH1TwwNj
	ODi6UFnkmEXmmOM4250AZ6A4/EoMdIStSc0H105KFl7wtQ9Dmdbm9eMNRxMIlXdixhETX4GdpAqgl
	ilZoyQqmdlReymwUoj/VW2/+OnHngiSjxW7OEMBCNKEulNmZqXbKHxq1ET+VGTOqr3wuol3s1sLZO
	YAdPGZKnC02FAGb12znO39g2mQNF04Austug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykD5-00CJVz-10;
	Sat, 07 Mar 2026 13:28:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:28:19 +0900
Date: Sat, 7 Mar 2026 14:28:19 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 the Eliza ICE
Message-ID: <aau3c8RwVMSkb1lZ@gondor.apana.org.au>
References: <20260223-eliza-bindings-crypto-ice-v1-1-fc76c1a5adce@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223-eliza-bindings-crypto-ice-v1-1-fc76c1a5adce@oss.qualcomm.com>

On Mon, Feb 23, 2026 at 10:44:02AM +0200, Abel Vesa wrote:
> Document the Inline Crypto Engine (ICE) on the Eliza platform.
> 
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
