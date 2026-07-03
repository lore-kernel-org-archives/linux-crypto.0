Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9503D2BEC4E
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783066584; cv=none; b=onom9PzxwbTgmhMLVHSTkcJNN0gV5dt/yTm78qmU03uk27KYnLAc2ZI2yL2mOzFRB1Plq7dBPjOMTJsTxKQyTHVk9euMnIW+koCZj1Zp1PEULNCkx0478z3G4ULtQ8f/YgFm3QBLV6n6sHn7E9+sXJD6JGAMcf+FdK9benT2vLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783066584; c=relaxed/simple;
	bh=qQC6pzd7ZW+6w81nTceX1afYorhY8BSlJVG/W/7Y+l4=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tSKl5OuNBxOFOpmm62PR72Bd9W4RLo7OeCIgKQCDOQG3/Db5aTl0Gj+iCn0/v9tALehOnwQo4+hKT+OFUgYPiq5RDGLEM4CVHCCjhQjnhMtAlfCVYC5PhCoQ/c1dJ5QX/D+J7jVqzN4I1OpH5bOtf1XP+pEhQ+6Nrp5PFIhVKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnxsbFRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnxsbFRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E931F00A3A
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783066583;
	bh=qQC6pzd7ZW+6w81nTceX1afYorhY8BSlJVG/W/7Y+l4=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=SnxsbFRrKsb107wQrvD0J/wnqyeeG0qlWaTxooQGjbvtWgOPp2ppKVs9iugUO2dIe
	 PTNpGIajPjxxqrbrVu9/tjuZpDcg+HEXephaY0hvvu1Y2hG0w+tx85iCYK7SNF5TiN
	 FcMMg9FnoqszzXErKQliIWqgLkOybc9CE0oM919hCCrUDMrBh6xuwtl0Qedz+HYQAR
	 l1tG7yeaRNe4dh5ialvoF80Y20+ydDEDMeiP7gbSj4KS9bSpb9VtTdofdwypWESm7k
	 NY+wknY2PT8YhPtrcSzsNSTW0lHRCUcRSB4xuagsJlWcXuX9ZOKBXQnQSb3QG5MUSL
	 PfrTX3WZqfSQw==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39afb0d9f7eso3172911fa.0
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 01:16:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrvV9lAUTzYs0N85DcvGRTG/NSAxbXJWOAACxYBvuKEWzFruPdyYvJMRZSC00mIywAZHF4DJ20eH7LHaoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsnGURTBFPAk17EpcxnNzlQB+/xjHi3tmEJLfdrcwWp822RQF/
	/l1JsVyDrnlRTqrScOHI+Y5l8SVb+clVkmmRW83T9c2LcpWfJ7oAn6aPOC0Pr6OWzIcfj3aO5+S
	TeYuus+WsfBEtv72RrqEvoq9BsgWKrVwb6GTjz6Kj8A==
X-Received: by 2002:a05:6512:124d:b0:5ae:c542:33ef with SMTP id
 2adb3069b0e04-5aec6795b43mr2021138e87.8.1783066582095; Fri, 03 Jul 2026
 01:16:22 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Jul 2026 03:16:21 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Jul 2026 03:16:21 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-6-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-6-66173f2f28b3@qti.qualcomm.com>
Date: Fri, 3 Jul 2026 03:16:21 -0500
X-Gmail-Original-Message-ID: <CAMRc=MdNrdAJmD-mgP0wXaiKid5pE8m4_9rOpXcrLk+T35sFgA@mail.gmail.com>
X-Gm-Features: AVVi8Cc4AXtmTJ4dPWDBNLruLtcz6tHIZccf9Ba9r0GLPfEhItZNEGvR8CW_x68
Message-ID: <CAMRc=MdNrdAJmD-mgP0wXaiKid5pE8m4_9rOpXcrLk+T35sFgA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
	Andy Gross <agross@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Jul 2026 22:17:16 +0200, Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> said:
> Add device tree nodes describing the crypto hardware blocks present
> on the Qualcomm Shikra platform:
>
> - BAM DMA controller used by the Qualcomm crypto engine
> - QCE (crypto) engine with DMA support
> - TRNG hardware random number generator
> - Inline crypto engine (ICE)
>
> Also connect the SDHC controller to ICE via "qcom,ice" property to
> support inline encryption.
>
> On Shikra, different BAM pipe pairs (for example 0x84/0x94 and
> 0x86/0x96) may still resolve to the same resulting SID due SMMU-side
> optimization. They are still distinct pipe pairs and therefore require
> separate DT IOMMU entries.
>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
