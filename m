Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D358434E55
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 12:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117648; cv=none; b=XHgWSK1ahkHcK0Yb9sZka8q4zX8lDMxLkTCISON42PaguCbJcL8i/M9G/OchkYHcdnDTrMBjdTPgctwgGGbE7sZDAtJpAa6YpR3YiwDpcM6v804LpDHrVjdI/C1RLOjCjFKl6fhtqmn6BxxivVjHX6E7JSPyFXxabs5vJfiBjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117648; c=relaxed/simple;
	bh=YvgJwlRpkS4j5aFo+iirEvbab1JzInwGnelmvUdllFs=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZOoRCpI3ZiW5dwm3fHbtVEz4jslNQfRGfLBOpRIMZwl+vW4fAT+wCOGZXhUj1cYLerJhnpBUzvZ8nd1QHBbu8fgqcuDO+IS/72P9DhBIpHNTVDLSCq10JqBMjMUMhEPbU6vCU41DUJZR1WWNyZgBwzQBJXFLwdLcy9jCOwL9Odw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZS8Zez77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZS8Zez77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441D71F01559
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784117647;
	bh=1Qoi+UWj99+JFyBfVjJ3X8HhkjskHToO4hndHwTkgUI=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=ZS8Zez77lkvzR2E3edpyn+xXc7laO5LJOum++DQRWFZ/8lgkjcm0JZTQ2YXjtQMdZ
	 hXr+/wEqd7SxfxBQPaCKQ+uuCYKHpuPv99syvBoJbjk03+kBBOi5oTaHFn6yVbE/HM
	 ntzJ3uzpdWzeoFv5EERUIfWFxmev8t3LaMyYU4KxLrk1uYjikIs5dYhC28IeVG+Cu8
	 r+24VE4I17f++cD6WyDkSdmJCDWNRhBJBIOwJ3wS6cZTnEljkhQAIia3YPRkWXhuv9
	 1Zvv2B2pBvlGWm0wH8ktyDCTvkY1iEdS26FEo2FlLleFNu0/1i94f4RzKj4uLr8quw
	 PhxrxIkMGtw8A==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39c86945164so44581441fa.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 05:14:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq5xFtD234dufkKcvCiVuMrq367HWk7daUYVQ1tAixAF53bHi3EI/fchqV8qhqYIKIUM6Xa/T7e9j4riLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCZVIXf08TGJaJ5QAtcDF1pUq7KoNA13AKZLwwF9yN58X+z+ET
	5DAT3z1NaDWcft0vM62gKJwNlJF1bSEwYa1uJItM15NmZG3qQC/xUU9v2hGNC34M09PVVWMsLHh
	1QIiDNCe+EKSVHd/PcyTg3B3RC6c/v95fu+E1OSPW/g==
X-Received: by 2002:a05:6512:2508:b0:5b0:e15:772e with SMTP id
 2adb3069b0e04-5b15d7a87e3mr637916e87.51.1784117645993; Wed, 15 Jul 2026
 05:14:05 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 05:14:04 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jul 2026 05:14:04 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
 <20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com>
Date: Wed, 15 Jul 2026 05:14:04 -0700
X-Gmail-Original-Message-ID: <CAMRc=McQbz3NgrKu-6OLp80VerWWRM1dCYkinznvrU4KYXxQow@mail.gmail.com>
X-Gm-Features: AUfX_myx3qsvrOOlj_433vZ0yt5OaPHQ_RTUX3Ukm6BF9xfctDg7hyDHWNlbUm0
Message-ID: <CAMRc=McQbz3NgrKu-6OLp80VerWWRM1dCYkinznvrU4KYXxQow@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Fix legacy/new SoC strictness split
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
	Andy Gross <agross@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jul 2026 12:05:12 +0200, Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> said:
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
>
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 7be14e99be28..cce21aae6499 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -57,17 +57,25 @@ required:
>
>  additionalProperties: false
>
> +# Do not extend the list.
> +# Legacy SoCs are allowed for single clock.
> +# New SoCs must provide both clocks and power domains.
>  allOf:
>    - if:
> -      properties:
> -        compatible:
> -          contains:
> -            enum:
> -              - qcom,eliza-inline-crypto-engine
> -              - qcom,hawi-inline-crypto-engine
> -              - qcom,maili-inline-crypto-engine
> -              - qcom,milos-inline-crypto-engine
> -              - qcom,nord-inline-crypto-engine

Huh, so it did get in first after all, I wasn't aware.

> +      not:
> +        properties:
> +          compatible:
> +            contains:
> +              enum:
> +                - qcom,kaanapali-inline-crypto-engine
> +                - qcom,qcs8300-inline-crypto-engine
> +                - qcom,sa8775p-inline-crypto-engine
> +                - qcom,sc7180-inline-crypto-engine
> +                - qcom,sc7280-inline-crypto-engine
> +                - qcom,sm8450-inline-crypto-engine
> +                - qcom,sm8550-inline-crypto-engine
> +                - qcom,sm8650-inline-crypto-engine
> +                - qcom,sm8750-inline-crypto-engine
>
>      then:
>        required:
>
> --
> 2.34.1
>
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
