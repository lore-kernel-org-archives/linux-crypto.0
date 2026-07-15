Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73D436BEF
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117601; cv=none; b=TfZbJ4xsndSl8bEz1mCa/LrhKXduWINXR/BqM9sSLTsQbyaLLEP8AbVds90UmwLz//23ztjqgaUzBYw1DipL8UZtAtNbEXNwUTIM4x8grMozGfu5PeJQJnlq8ZySqxjrrgDwPvEl1tS8arafJlPw1Hn+KIKXb17YV5tKgwM5Do4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117601; c=relaxed/simple;
	bh=gNl5/ZnFxiNLQCcvtvH8upGV8QmIKJ7OniNlJJrNsto=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hoqYGcx888psStR1CNLNAT+vK8+G2Kos3NGX6PjzRFvOrGAV/qVkSOzkXsjEsDyn7PakzaGGzCOUeWKvy4rYC7gt6yYxBcLV+F26R/xlfAp2DH9CWDXuqNRLPztoKOMn9uWUolM2qhS63REtZosc3xSClBFaq9QfL+J4kAHrrWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdVwuaRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdVwuaRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A01F000E9
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784117599;
	bh=IvqJ6hW+hUO9tvsLL6o5nEWp718Mhw+RBi7JmsGm4BE=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=OdVwuaRI70Nq2v/5ItDFn/LeHAMt2u46DJKRsbAvJHjoXiIwpQ5AqlIVlDYvxKvqB
	 ICTuouuOqFtR3W/JMCcAEDFn8EgaxTMnrc9mFU9JCmzFbU9cUeojpN819MHLxmQuyC
	 KWXKF6lp2/q6Xfd8iWulAcWLmYxTwVsyFe9DFDPV+tvMGZbcC/ezAqJb/X3FGZ7Lwn
	 9fkjgjagycosHNIPv+Dcp+7D0f3mmOBJdxWYcQmZ+3CJohmMg0qPhcPo0UN88lHdOR
	 ZQU0/agCgQLTG0ob4Iwxh3TDjYu86ryG4EhpHkPiNZ99XY1LBNeNSev76DNLVuEgnU
	 jyBnBK6YCGKbw==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39c94fccf3eso31998761fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 05:13:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpOsmN0DXt4thee5FQnAhWw1zMWYjYg5O+bGXmFZrN/1FS+Awc1SghSqe1FGdMHTtExZ7PEG1Mi896TGsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YylEPBwxf6Z++2zHBABbyhh6la7I6frdEh0cDTE4bVg2XWlh1o7
	EAXS8gCGqfLh9bvfz7DzKasEHBHLMIiAxCtUY25kJPQEWmVr2MxaBlyjwLWRDHLbH6Opw4Jsbeg
	QPKcogoFXh8XMuprlINv6ko5ECpo7EmNjBWtqVhICcQ==
X-Received: by 2002:a2e:a913:0:b0:39b:f25:6050 with SMTP id
 38308e7fff4ca-39db6d4d3a6mr6178751fa.20.1784117598343; Wed, 15 Jul 2026
 05:13:18 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 05:13:16 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 05:13:16 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-5-06a4ea97c209@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
 <20260714-b4-shikra_crypto_changse-v4-5-06a4ea97c209@oss.qualcomm.com>
Date: Wed, 15 Jul 2026 05:13:16 -0700
X-Gmail-Original-Message-ID: <CAMRc=MeWeMfry1UThKdw5U7mLcGc2LFOCiDikPEps5K+0nQg6A@mail.gmail.com>
X-Gm-Features: AUfX_mzuoja5mZwmlfZnsqzI2FkD2yFcwkvWpiPulhTnwjEhajmQYmGlODoqU04
Message-ID: <CAMRc=MeWeMfry1UThKdw5U7mLcGc2LFOCiDikPEps5K+0nQg6A@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to 7
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

On Tue, 14 Jul 2026 12:05:16 +0200, Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> said:
> Qualcomm Shikra platform describes the BAM DMA node with 7 iommus
> entries. The current schema limit to 6, so update the binding to allow
> up to 7 entries.
>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> index 0923fb189ada..e72adc172af1 100644
> --- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> +++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> @@ -48,7 +48,7 @@ properties:
>
>    iommus:
>      minItems: 1
> -    maxItems: 6
> +    maxItems: 7
>
>    num-channels:
>      $ref: /schemas/types.yaml#/definitions/uint32
>
> --
> 2.34.1
>
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
