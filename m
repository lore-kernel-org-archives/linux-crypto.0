Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756581;
	b=PezL6Jb1EvMPMqWZG6vyd1DIIyPwYxDN84GUfu4Cfs2Eo19uF2SDkt8JXDx9nXsr3QVM
	 MXdy/W9CYJWCtwSjXJ5c1U9+1cNDwBSvzuPizAXiMsLuxUee5kl5bXyXtBZO8o8eZVxkX
	 icDApkQ8yl41o8DjSWRvOwzgDp9j0Dr7z/gIREYUnGm0rRdcvBLO80e8zRsXPFUdftDoW
	 JdzTuadfdYaHRRIMp23rkjzDtRRYpGbuAw3SFB6mB9Fp8/DCixqp1MK020WZf2xmUo/xG
	 c+M0aEcrhDnE5ZQAqzCjw/CliL9XI9mJvz14aD66OicrLAMdtnSCFrqZc29N7KRDi3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756581;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=nfhBI67yLMgUWHOtvcXlkNwJ0+cwobmSMeAxNWE5nVY=;
	b=nd5D+Qz2kwMxxgKTLD8E44hNFcQt/FvYyz/eu4QYBuYc0W1tpNfPeGHRzG1rQgj8UN4Y
	 MeUrgmovs+J7R6hTwwTn7RscbZU3svpFCZz628al39aVxsBmaqIkjSmCtP8pBVGKiX2Pa
	 obm2rLX3GSO2WRHZYRX9m85dKUXZWVKEDkf0tVydRgcn0+8vjsh+yOdgqv54SVUs8MJgh
	 h/K8Wo9n8rwoRUeWAcb3S7euiL79GrZ+u6DQK7i7j/j0R92q8yVs7gvHLhCNiBfB1OaW5
	 ljbcT1QlCqXk8Q7daJX0ynU2UMQKXTD5NRZzgWRweYTtEFm0oe5NR7kKEQUGq6GChZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WpvoWmP7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FD606A31C;
	Fri, 27 Nov 2026 05:16:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 007FD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WpvoWmP7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nfhBI67yLMgUWHOtvcXlkNwJ0+cwobmSMeAxNWE5nVY=; 
	b=WpvoWmP7vQ2DQy/uXlXG9Wb0SoNDm9j8xJVNXGQLx2MkDH4jQaln/BYsCCVoThWYd74BUWw2rng
	10B4LsRVxTzauiXvsMhQ5WYC+VrjbaFLC53/h/FYyGjxZkEgZhEE4WnESLFc9prcd5yUMiYIugKK6
	6G5tgCoRDPE7q/D3YBw5PY5hsK10fPjFflCI6zgL4sARCQ3KCbg19S5yMOSY6KY61WaSC7gPD4TL7
	/esNhC8BFL/7IBsbFXbH/3+8OTlFsEfuAnZo1MNmxBmtivPtBvHlZpnJIDNYB9EJsck+AR1LuF7FP
	0jrtvGByHAWx8CYe7hgdNGJf+aHHMSN8VfFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoJk-00000002VWe-3uDE;
	Fri, 27 Nov 2026 13:16:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:16:16 +0800
Date: Fri, 27 Nov 2026 13:16:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v4 1/2] dt-bindings: crypto: Correct Shikra QCE
 compatible hierarchy
Message-ID: <awkSIHBTTJbvnDJM@gondor.apana.org.au>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
 <20261120-shikra_qce_fix-v4-1-5249e31394ce@oss.qualcomm.com>
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
In-Reply-To: <20261120-shikra_qce_fix-v4-1-5249e31394ce@oss.qualcomm.com>

On Fri, Nov 20, 2026 at 04:59:52PM +0530, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, while the existing
> "qcom,sm8150-qce" fallback allows the clock property to be omitted.
> 
> Shikra follows the same QCE clock requirements as QRB2210(agatti).
> Update the Shikra fallback to "qcom,ipq4019-qce", which requires the
> core clock to be specified.
> 
> Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
