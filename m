Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5020D3B42E3;
	Wed, 10 Jun 2026 08:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781081750; cv=none; b=au/+53xUqDPkykeiWbTNmdRumw4Diq7g3/GBKdQpyT4TLhPG9Z6cSGPmHah1lC+e5TtAshsbNmyIX/6NJB6rP96UXyuk2Pdb5FcNlhR/jhcJove/QzpondIZ5La4V0fBlnChHtefe11Z2QGS1pqWK4l5oShrShlTheo6pfrv1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781081750; c=relaxed/simple;
	bh=a+sRRfUHrctTpYK/ApL0KiB3sJRFNC0i7dDQnfFBUMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjoh0w4Tact5BEHVvzAfyytG1KWhbWWbGYmME35iU6IL6EuMz4XW9p6tlqwPqIvIhxxbWlL5+NfvDiKbzSBiJsACLgVaqQLkyWq29VF1D6TusbMDPHLBrwomSzR0esoCofTkxT+xOdix2ixrI1pTGTyYymF4478jeIVXMqN255Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrV72KXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrV72KXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DAB1F00893;
	Wed, 10 Jun 2026 08:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781081748;
	bh=24kKy5m5HqAQmbOX/28c8jXJQdgJGurt3Jbpga0TnVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nrV72KXMNgv+FyEiA6zBLSfuTrO1Oyl0jd/qHTN9eyMrqIGYaSWqpYAxv047yykcu
	 +H5l6v4Ao/iBZfhF+al+Ku7JuwuEiCGtGVAMjpW6pgYdVzuVXJrhbdEkIbBw1FHTwX
	 8jnFqibXksS/KsdyuiBDfm4BBstgFacRznXa7h2InV2ux4SjeyozM3Kvf6Mii58xfk
	 P0zab4JHJghv3X2dC0em6As9xbLwfhK0C59OOdqM1flbQ46O+gG+3BH8BlFcRouVy9
	 gBEz7jx3xeD86orh0OUftlU6DgE0tPWgwa3Yt/NnrVLO/temtCjus8nFVm6ROENHec
	 +hdIZYx7MgEzA==
Date: Wed, 10 Jun 2026 10:55:44 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com, 
	yijie.yang@oss.qualcomm.com, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
Message-ID: <20260610-mighty-dalmatian-of-piety-2fa184@quoll>
References: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
 <20260609-maili-crypto-v1-2-0f577df56a61@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260609-maili-crypto-v1-2-0f577df56a61@oss.qualcomm.com>

On Tue, Jun 09, 2026 at 02:08:57AM -0700, Jingyi Wang wrote:
> The Inline Crypto Engine found on Maili SoC is compatible with the common
> baseline IP 'qcom,inline-crypto-engine'. Hence, document the compatible as
> such.
> 
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index db895c50e2d2..c9489f6b8081 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -16,6 +16,7 @@ properties:
>            - qcom,eliza-inline-crypto-engine
>            - qcom,hawi-inline-crypto-engine
>            - qcom,kaanapali-inline-crypto-engine
> +          - qcom,maili-inline-crypto-engine

Why clocks are flexible?

Best regards,
Krzysztof

