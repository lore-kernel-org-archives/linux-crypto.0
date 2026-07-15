Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702BE423E85;
	Wed, 15 Jul 2026 09:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107249; cv=none; b=t/ur1+0J6qwIx7JO0phKkz8NJSMKgaeNiW/P6ZP11Uh+KyxCGIsiYxq7gYPDuizT0RWAJJLqr1veRSRWhqQeCX5918h0dS9T8xAvyln8RPxT9a/WwsK2/kz+U0QslD7L8KrDLWhm6kCo6YSdaPY1M1/oQTat9taExpWmSKDz2r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107249; c=relaxed/simple;
	bh=8icWg+MuYK6o8+nvyjTEbBOrLRu94DyCkjeA10u9Cqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJn2nbRfuZExsZ7SovFPAr5tzqb0hTYaayhCP4e5nRx8ouwHq8vPSW1m+fiOP3kutfyxLkGZ0DywtQ6eOhPOYVz7Oxjz+avkoRD7HuoLlVxkwQCBeEiVlHiDHrne3Mv4/lzU/jHZG8W+OvIuKgkYgW+HeZ9+D2i/xOwgixY0XCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8f8/guC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8f8/guC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3BC1F00A3A;
	Wed, 15 Jul 2026 09:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784107248;
	bh=LgtzXpBKpqrsbizlT4+gM3HB6/jCX4YYOzDpd315EWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X8f8/guCsQzLR6QXo73QciVGDuKazQdQ0i2ryhxGPfDSYFnWbOyfjSRiMuvtXqoBH
	 Lzx5ra8rUtHWleE3q5yUND8d6M7V6DU8488aHf3br8UM4kUlh5qgvalKoHRuVUTS0M
	 Xv+A2MW1H72Je5KeC8Auw2iJssxR+F5wHsHwdANIK5Y8xQvvngRLlk0Gdf8rrwlN/A
	 sMR7wIfVMlEMcicI+e+2RdGt5RWRMgpIKmF4v3sS76NJlqB4aGhXp+fiTkjutJPoQ8
	 AIzFyU16rPmB5ByoLnMB2yjQz7nJBeOYCaW6iV2RieVp/E2/kQ1b7XjDbL6qnmHReJ
	 xphQ2Es0B/7uQ==
Date: Wed, 15 Jul 2026 11:20:43 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v4 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Fix legacy/new SoC strictness split
Message-ID: <20260715-icy-berserk-pigeon-909f8b@quoll>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
 <20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com>

On Tue, Jul 14, 2026 at 03:35:12PM +0530, Kuldeep Singh wrote:
> Couple of already merged SoCs(like sc7280, sm8750, kaanapali etc.)
> describe ICE as single clock historically which are recently updated
> with mandatory 2 clocks.
> 
> Keep only the known legacy compatibles flexible, and make strict
> validation default(of power-domains and 2 clocks) for all other Soc
> compatibles.
> 
> This ensures old DTs are valid while ensuring any new SoC (like hawi,
> milos, eliza, nord, maili or any upcoming ones) must follow latest
> requirements by default.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++--------
>  1 file changed, 17 insertions(+), 9 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

