Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5193B14B1;
	Wed, 10 Jun 2026 08:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781081711; cv=none; b=aQHx5p7nr4FS4iXitqu1mvrur+/I+MBrWeTRbQIHLIPiZ7Zy22ovqx7eDjlawaEcA/tdTbgd5WxLUmcAGAWCl4Qdg1G7JlMXw5b6DgBtiaMsbPP0DqmGGrp9UCrNU2jeJGlAuU5IGWnyZR/l7tCWsKSfcxqmb0JiD+dyoE4b2E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781081711; c=relaxed/simple;
	bh=DuXhchlQRc/ktqxlkDooSIAF8Anm4npGNhalnWTsdOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kriMMi+lhU31pRWPS892P2smx6xpTamSHc+CSFa4XFh5S0DGMo67ECSEVSRqcBVQY0MUCk4kkEbEvcW6y9DYQqfhYQRg3Fg2lARRguZiUnQevT+sYuygkWYSR+dGFROielsiIwoiU/OpYa/zIP/+HxLxjgAeyXxPPY5rfEVuP6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFTFhevg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFTFhevg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AAA1F00893;
	Wed, 10 Jun 2026 08:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781081710;
	bh=TRTyM5MS3WUrXryQN7PJQVfhWuatgRYyBVXvwmd2zTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WFTFhevgbbLMPMRo1DQ+HhUgrsa6YL87dv+/P14TPw2SeAnJ4j/R5BzbzBuw6GKmF
	 L2C59ozuazxirlRTHP0jo7MXXuo09SkNSfOrvrLWC9rTCpRna2CIC92Xzcygd8tzsG
	 cTTj/j6hJWCS5Qc8RPHK7EtEc1TV/Yv1ERTi9YUzWZbEeKPcrknqB7DtkZJ6F5Jjxr
	 UnyYIHnn9Nm7uApSxihY272Xjo5Gz/KB6n88X2T11FNm8Ei2EQMz4rLsghIdE5GneS
	 C7RTMULy+gPjqiYjCfQzqxNV5jpA+p1LBHteyCGP2JBI5QVOsEx+0C2Cfx4HXNji9a
	 EXduVOAXdSySg==
Date: Wed, 10 Jun 2026 10:55:06 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com, 
	yijie.yang@oss.qualcomm.com, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom,prng: Document Maili TRNG
Message-ID: <20260610-spirited-scarlet-tortoise-fad4da@quoll>
References: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
 <20260609-maili-crypto-v1-1-0f577df56a61@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260609-maili-crypto-v1-1-0f577df56a61@oss.qualcomm.com>

On Tue, Jun 09, 2026 at 02:08:56AM -0700, Jingyi Wang wrote:
> Maili SoC has the True Random Number Generator (TRNG) which is compatible
> with the baseline IP "qcom,trng". Hence, document the compatible as such.
> 
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

