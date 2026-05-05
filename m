Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0331340DFB4;
	Tue,  5 May 2026 09:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973122; cv=none; b=iQbzhog5XhcgHiRomAi3xhNnf1u/QRiWgNs3za6VLEIrQ/EWqx0Dtp7qNCSjP0NV5fJdpXhJObFMtHc10EFxae93vN7xfFtUWKYUQvbQw3SPlVgc3Yigw56xPTMzX89P74ogrpLTFHD9mjV60gsIUFBV2bXjnN0TllomGAfTLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973122; c=relaxed/simple;
	bh=jQZuSHlPCSr31JXr5NTB6uV+d8TVb+8faIKs2BlfyrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVOJdz5sShVz39X8Hj0K2/eSmd7KAqPrd1efjk4PAVntOmoXFQARuamwTtS47ReGdfv8Av1Hb2JJPxNuoAHWNlCrafioJzWRKwryzZ9G0zbDf4EEaAAXtLJa680wg8zzHrA8mmviybrtjajR1uK9yV/toLnL29ptL4fyZV8Z3zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZVFCs2cr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZVFCs2cr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bn67SPYgjHR7W91CM48G4PPpIGIRXrMoBsiCKI3tEkY=; 
	b=ZVFCs2cro1avZWOJlJMx45/giVskVKarywwFrEO5tkMtdBEFtoBwMXuI7UQ49WOxDG+CRiB1rOH
	KnpuqFb3KqR03RFzzWN2nu8sr+/YmbzNduIIdX1RGoUPGN+uTOXL4lKo4GuSPDA2Um8CAfLfF8/x2
	dqyICrIIRFht5nbv+7wXV5CKMjweAAJqX263GjTNwNHjszFP+snbTmLFwOTx4XN4FJVyPpySTLmwi
	xi413hXVsqnMgd0AjnVYYLSoa8BbxCXAIji4za/Y6HXSs9v/iQEi/m+WDvRUeewiq+j2HZwiR6z5h
	O8541OK0OOicxGru0zhC2W+F6KTq5lyjKwog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC1i-00BNqz-2H;
	Tue, 05 May 2026 17:25:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:25:14 +0800
Date: Tue, 5 May 2026 17:25:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,prng: Document Glymur
 TRNG
Message-ID: <afm3epy9eIK0S_KE@gondor.apana.org.au>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
 <20260424-glymur_trng_enablement-v2-1-0603cbe68440@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424-glymur_trng_enablement-v2-1-0603cbe68440@oss.qualcomm.com>

On Fri, Apr 24, 2026 at 02:05:07PM +0530, Harshal Dev wrote:
> Document glymur compatible for the True Random Number Generator.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
