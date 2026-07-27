Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D36487BE;
	Mon, 27 Jul 2026 00:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112393; cv=none; b=NWZVOYGL7CqsKDlB3+prEIfftj9RVM9fzWKG1ezAsfmmkZQhfghdx5lz+kJ+yErdM1vhxWdo9pqklcN0M77RXdEIkn5EC5WXrF1sxQ4LZo/C/sjDY6fIHV6uVYf4gPR3emtm86YN+4oKbdc7cq1fAPb7TpkYcMdljePBpriVFs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112393; c=relaxed/simple;
	bh=UY3efD0vkIgCls6go9OLhLVM9zyOHMV4VoR8ZEwJ2IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfVZe9feiby/wxElTNUsAV4o+W3m4fdCbLVwlgvsvDkai7+qyEINwEMdEPne5czVTamWhxzjRICYTrWcgTF/2608VvtImvCqAoKsJd1B50TftIndRgvm9EInGI/nzsJFgeXZX/sF22lf1lvxvyHqhnGA9aBw3z/TvtPc55dQbus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SE48nxfk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SE48nxfk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=71cCBAS8A2hoPA6O2oKeS13s7oPVP5QW2HLk5bUeTeE=; 
	b=SE48nxfkjA5poAhFHR1/I/OkTgWQB9Z49t37XkjzVEpR13Bj1smE+YZslraCkehB8IgCxhLjgJM
	5vlfGpDJNG/OYtLjwHHD6/zpZpWGcNYTUFJ95VBuF+ewFdWVW967gxlJiE3ryh6gn/8LyuAtm2rnR
	jT8DGEZI/7RLNA74REgg3ta3f+0hVZBkwyWYoJ+bK31EdmpBPpAlCotJ5MJtgaxSR3j2sgDeTTCq7
	FQuBskVr22eJRAaErnQ9NaocEAVv6dlXfsjtB7Y3HMSArfJr0Atm3jkFXY17R+UktYw3lndgINRYK
	TuH9PHfnlT73S5WB+mbgln1uepF27Z3pamyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9HH-0000000GywW-1o2q;
	Mon, 27 Jul 2026 08:33:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:33:07 +1000
Date: Mon, 27 Jul 2026 10:33:07 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v4 0/6] Shikra: Add DT support for ICE, RNG and QCE
Message-ID: <amanQ72mRGN2tiVd@gondor.apana.org.au>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>

On Tue, Jul 14, 2026 at 03:35:11PM +0530, Kuldeep Singh wrote:
> This patch series enables SDHC ICE, RNG and QCE support on Shikra,
> aligned with how similar support is modeled on other Qualcomm platforms.
> 
> These DT and dt-bindings updates were previously posted as three
> separate series. Based on review feedback, they are grouped here as one
> crypto-focused series.
> Previous threads:
> QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
> RNG: https://lore.kernel.org/lkml/20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com/
> ICE: https://lore.kernel.org/lkml/20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com/
> 
> Prequisite patchsets are already merged so no longer tracking.
> 
> Validation:
> - ICE: driver probe at boot
> - QCE: kcapi tests and driver probe
> - RNG: validated using rngutils
> - DT: validated shikra-cqs-evk.dtb with dt_binding_check and CHECK_DTBS=y
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
> Changes in v4:
> - Update Patch 1/6 commit message to accustom hawi special case.
> - Collects tags(Krzysztof)
> - Link to v3: https://patch.msgid.link/20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com
> 
> Changes in v3:
> - Fix commit messages.
> - Collect Ack and Reviewed-by tags.
> - Link to v2: https://patch.msgid.link/20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com
> 
> Changes in v2:
> - Add fix in ice bindings to specify 2 clocks defauly for non-legacy Soc
>   compatibles.
> - Update commit messages.
> - Link to v1: https://patch.msgid.link/20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com/
> 
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: "David S. Miller" <davem@davemloft.net>
> To: Rob Herring <robh@kernel.org>
> To: Krzysztof Kozlowski <krzk+dt@kernel.org>
> To: Conor Dooley <conor+dt@kernel.org>
> To: Bjorn Andersson <andersson@kernel.org>
> To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> To: Harshal Dev <harshal.dev@oss.qualcomm.com>
> To: Vinod Koul <vkoul@kernel.org>
> To: Bartosz Golaszewski <brgl@kernel.org>
> To: Konrad Dybcio <konradybcio@kernel.org>
> To: Frank Li <Frank.Li@kernel.org>
> To: Andy Gross <agross@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: dmaengine@vger.kernel.org
> 
> ---
> Kuldeep Singh (6):
>       dt-bindings: crypto: qcom,inline-crypto-engine: Fix legacy/new SoC strictness split
>       dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
>       dt-bindings: crypto: qcom,prng: Document Shikra TRNG
>       dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine
>       dt-bindings: dma: qcom,bam-dma: Increase iommus maxItems to 7
>       arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes
> 
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 27 +++++++----
>  .../devicetree/bindings/crypto/qcom,prng.yaml      |  1 +
>  .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
>  .../devicetree/bindings/dma/qcom,bam-dma.yaml      |  2 +-
>  arch/arm64/boot/dts/qcom/shikra.dtsi               | 52 ++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 10 deletions(-)
> ---
> base-commit: 49362394dad7df66c274c867a271394c10ca2bb8
> change-id: 20260701-b4-shikra_crypto_changse-f2d6d5bf04b5

Patches 1-4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
