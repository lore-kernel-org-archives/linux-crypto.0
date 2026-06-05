Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDF54CA26E;
	Fri,  5 Jun 2026 11:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659562; cv=none; b=PgknFlzy5oGylFvxUAhVpsuF2XwVr+i5nAEVuzFYp6hMd/XvljSWw9Rzy02fSNb5w0DSgztXHI+XGfWl5CmNRq49MdI8/AFXIqJ0V+8QdNZlPWJw6lirCaVploIsCff+OvLDXmmIoJX+X+FxvI8YAiPIorL1b6giUTtj3JaTA6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659562; c=relaxed/simple;
	bh=zqH0Q9ITwZQODfgiXtS4y+OJk5FtZCErLivlcfamoMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1hllozU1ofdB2JUxhTMW2X9eGBA5yIcfiaBA4xMDwafXQzA7vr8/k5PGvD7tYEdBROC8RIh1NOzG8RWiKqrWLv5uIUXpoOQ0EGB0NlzeaYeLGDHrYFqYmqmj2M65ZDDhsT8lLclxYVsDbZpdNmKN2q/heEtPftZhAuIZdsMVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=en0nmYR0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="en0nmYR0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CHFPaICTJPqItjzPT3W6kuckW8eRD1ugtO9S1RGUb0U=; 
	b=en0nmYR0NtYoq2N/hRP19z/02wCbOpSkAmac2uob0FcV7wp+skXXBBBFQAA2dhUXsXsmsz+38I+
	8gCrPRppb7ohdmZ4CjVfanJMPCnhfg1bY3xO1pRGL8zeE1yiSK/oa9xBc+TN+47yn/7u+LBQhpM8f
	BBCRv0ftK1wIkllkFBlDq2RYvBovm6655DA8yw+VOeVZiplRsfGGX3I1xFOFe9vcdsLi81k3QEmDH
	17g2Owg4Yit88ZKvmxGLjH8dxMmJx5XwjT66yyfBGzQ40ov4MKXhczYwyY0aCNi3yh2zC2wt/ujT1
	ND9T95T178jCgz8V8ZPlMnzyGzSQxQE8vx4Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVStN-002olC-2u;
	Fri, 05 Jun 2026 19:39:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 19:39:13 +0800
Date: Fri, 5 Jun 2026 19:39:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH 0/2] dt-bindings: crypto: Add Qualcomm Hawi crypto support
Message-ID: <aiK1YfeKShMTApph@gondor.apana.org.au>
References: <20260521-hawi-crypto-v1-0-9176a3b51bc0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521-hawi-crypto-v1-0-9176a3b51bc0@kernel.org>

On Thu, May 21, 2026 at 12:36:19PM +0000, Manivannan Sadhasivam wrote:
> Hi,
> 
> This series adds the crypto (ICE, TRNG) dt-binding support for Qualcomm's
> upcoming Hawi SoC.
> 
> Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
> ---
> Manivannan Sadhasivam (2):
>       dt-bindings: crypto: qcom,prng: Document Hawi TRNG
>       dt-bindings: crypto: qcom,inline-crypto-engine: Document Hawi ICE
> 
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml                 | 1 +
>  2 files changed, 2 insertions(+)
> ---
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> change-id: 20260521-hawi-crypto-138bfd2a6ec5

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
