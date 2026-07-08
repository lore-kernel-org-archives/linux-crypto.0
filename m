Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3C3C379F;
	Wed,  8 Jul 2026 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783493195; cv=none; b=m5ySYQwQj8ZAUCVbFuiqEAhE+UA0mwGUUxDetLx5cffuzZQpxP83fUCwiOz5DrfBBGxpMfAsUF9CpryKoIVsdFpPEynig+mcYvhh4XPfkL/KGWA4nmaaWK4XRh0Zx8VR/46gPbPFcmRod5Ggit7pVhT7C2ctvTSsxu38KWyrKNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783493195; c=relaxed/simple;
	bh=HFxUDoP6Ex7YM2OMJMeS5Y0WZJn/ZyvL5L53UAwwuZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdL2LxyJQOZvz4S0i9Vi9GCcRHWCFOZmQhH210F8e7gUzz2N/7ARXBKEih43XVnKUr4qwSw7PzHkyTa711z45Oo84MXNhYHftgtYxpyTtei9hGF1g73WeT3Qk16hwiQo4aB6brkXMAP6EcGzre4mBawHrVhQweGp5d4WL1nC7G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OO4Lu/dK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OO4Lu/dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FEC1F000E9;
	Wed,  8 Jul 2026 06:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783493191;
	bh=f5iDONaBp7PwW4JhBqAoWBz19tuSVl08JtaCV0icvb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OO4Lu/dKbJfUWfzf5g4o/1B117+RUF/zI34kIgMlVs4Luzda0dW2U7WnRiKZoMOu+
	 KNn6qGDJIdeSFsr2jMhGWFgqm3ajRcJxyW8l0o3zdo+s1H+tXpdq8quECScpoYdfrS
	 xXj+IjYy3poliTQaKnZQCbdz/kt0dRzx7TsRw5pRqMRiLqf5S+GgYJ8kzCrArB8/46
	 GNlD4sQAw2HbH+iOt3zfQdzGovHMC0D7LeD0kyOAbeKdmKk317E+ZUegQaXR3k8au/
	 REjjd1fyY9P3L+MaZGKgl4KbbZDk0FloK5FVOGpWeXJg13FF2n/d4kGqthbhmGLdrn
	 8uLe7GMIdaqtA==
Date: Wed, 8 Jul 2026 08:46:27 +0200
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
Subject: Re: [PATCH v3 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to 7
Message-ID: <20260708-benevolent-congenial-waxbill-6bdee0@quoll>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
 <20260706-b4-shikra_crypto_changse-v3-5-23b4c2054227@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-5-23b4c2054227@oss.qualcomm.com>

On Mon, Jul 06, 2026 at 05:01:33PM +0530, Kuldeep Singh wrote:
> Qualcomm Shikra platform describes the BAM DMA node with 7 iommus
> entries. The current schema limit to 6, so update the binding to allow
> up to 7 entries.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

