Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20F138C427;
	Tue,  5 May 2026 08:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970876; cv=none; b=KT7Y53SPHt21DPLHsrP/jCwrJSroxiqSH+/Ts4ZwTjKhEdcHcfJm0W7ybhNWYQsNAHWIIrSfQaMzFkNO5xSv1sb5b1NfOWlT9fNMQm4egGnp4RHnneTTYouGRUsHibx2UVgZswyKU8MzOxQ0nkchqAQu6C5w1tqH58uawBmg2g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970876; c=relaxed/simple;
	bh=mW0SEWD0NApSpUyePf7/gJ1bATcit5i1WVbQKhelrgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7t+C+HOEQ56xzfdV01DH2VZhVwzxuWEx7z3ZAiZszC2Tu1LEYL17dof6mCnZIhsumVExrNKSSIeMSIWFkH4O3YqckEiJ1oXzynIf7nWj7BjO4/tCWOVaNP6VoX6itU+0CZDY3JAL/xDgzv/HqfotucYQMKUVzHDiFXUvbcmr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SmHCwth8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SmHCwth8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xkOf/k9BTFBeWQQK17PtMPigLQSyK+IanG5bxvh6ESM=; 
	b=SmHCwth8KmZTUbbnMcl8zmWEhZgmsCGZh0ykELJuRrMImHsOk36bDPkx+pZFjC6z4+KT/HDD8Su
	N/SenhN6LDpLIb97pSPN/vOBhhVrOgyis9LAdpH3eRO8PveCg8whS/ADZETEZAKZ53UdyrXRIqe49
	H39BFmJxeEsNeBdOzXLlfglykSnccJCY776q8DaehUuhJZS7jWn+7sFiF+CFXTcoFICJR6w6+MpU0
	eD9lO52TzJCSfPb8JJreHlrdIkpoREBhz1F6fLTnhh9LdBpC1swKta0OBJdBz4wsShaK/+jG34M7M
	UtrucBvYJGZ7HxI3+sdKFRr4OSd4ThoB4lgg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBRR-00BN4w-1Q;
	Tue, 05 May 2026 16:47:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:47:45 +0800
Date: Tue, 5 May 2026 16:47:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom,prng: Document Glymur TRNG
Message-ID: <afmusbmw6YdznrYs@gondor.apana.org.au>
References: <20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com>
 <20260416-glymur_trng_enablement-v1-1-60abcfd45403@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416-glymur_trng_enablement-v1-1-60abcfd45403@oss.qualcomm.com>

On Thu, Apr 16, 2026 at 05:56:11PM +0530, Harshal Dev wrote:
> Document glymur compatible for the True Random Number Generator.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
