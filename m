Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9823B31A570
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783066639; cv=none; b=pZOunQ5ZkDONp8+BEpBpAXr8XqW/PNIEBcvTE4XBg1MNWebKqYN08vjdhzwTGMNX1Qt5EijH3Tju1qw7eCP9ykQ8zssQ12+8LPInEqup1koJ3/lPIijpc/G574XG3Rt5gl35mmVkzWx1iclD04BNE+mef2/radFr5YUkV0O8GeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783066639; c=relaxed/simple;
	bh=OUf0qjGFFxksslj6x5pLYjlkNxo4nBzeIug7Q6fIVs0=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IknDzQLr9NarFYD/9ZI8Ih+jxIHIuduFBaMQw5sTIZBVKt8VHM4/PJ81YhZ1sC8IOgZCtoyILML8l/+9Dt13viRTKmhDFBWnttNuApGH99m6FwyL0Th6ZZphNyb0s+NsaZm7hY2wVvfAGI8BRMuycDFuFS/TcQNfwFKDaBGNIro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfLt/9EI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfLt/9EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F3E1F00ADF
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783066638;
	bh=JwhY3idhTm383WR3+G7GxVaTBhOUK0/Ypiz1L3Lcda0=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=KfLt/9EIkrBWCtRywWlaMfYHFpedrq/wLqwVbccRBplz4B39klNFryzaVD/fs5d1U
	 3PbTKpBBWSasTXYYXG9TuzAeFKlJOSI5TlWeFiVPWu/2JXrjogd1IkpLFFWCM6KOFi
	 HeUNCYoQj/2P0bTMMoLkpM/Y+WE7S5y7StALfG3sEZ57FK1T1B16rlGTOkJhhzRnFe
	 DuSQyOcJ1a/5jUdOHSvI5m3RJTCHvSqoVeeAyEOMyHklwDqxdfSVGMnw0tO6KPJesV
	 NxBGWbPRIUyhq2uYNWn2o9WixrkTPT0FIghW6C2txBh9Ca55/oq6PWT91aR3V7adZ4
	 Dp67PIYNYZUsA==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39b0c6488e6so3168431fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 01:17:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp953AG/942aaSFxleUNX1bnVURX7HJ01edNOC0vgjBviOw9iaJCP2AayD+63o0V+1ZfoCl0NB8Q9lfHvM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3d56HvB8q9QAmkV+mFTulS4YZ7Y21G3XSBadHXATNyT3oV07i
	YugumeVvpk3TPQ8RRYwd9ZvxXBeU+t4/hLo9TXxAqsY/539gstKUPYHhpkLLZwIqSBxkyMxDppo
	M8ItKIR4P2nOIYJJJ1O3QTSaJ2PylyGGTscGNN5dnvw==
X-Received: by 2002:a05:6512:630f:b0:5ae:aeea:c60a with SMTP id
 2adb3069b0e04-5aec6797417mr1950427e87.11.1783066637026; Fri, 03 Jul 2026
 01:17:17 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Jul 2026 03:17:15 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 Jul 2026 03:17:15 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-2-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-2-66173f2f28b3@qti.qualcomm.com>
Date: Fri, 3 Jul 2026 03:17:15 -0500
X-Gmail-Original-Message-ID: <CAMRc=Md92bojjNn+YG=0RYgK8aN+kKs27B=_E-6=px_CSfamLw@mail.gmail.com>
X-Gm-Features: AVVi8CcvVahfa37Rc1yk796o3IULO9dBSYjJtrJ1IzN0S4aK3kI5E3-zWO8HD3Y
Message-ID: <CAMRc=Md92bojjNn+YG=0RYgK8aN+kKs27B=_E-6=px_CSfamLw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
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

On Wed, 1 Jul 2026 22:17:12 +0200, Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> said:
> Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.
>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 4f3689a24410..9e6d3af42971 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -21,6 +21,7 @@ properties:
>            - qcom,sa8775p-inline-crypto-engine
>            - qcom,sc7180-inline-crypto-engine
>            - qcom,sc7280-inline-crypto-engine
> +          - qcom,shikra-inline-crypto-engine
>            - qcom,sm8450-inline-crypto-engine
>            - qcom,sm8550-inline-crypto-engine
>            - qcom,sm8650-inline-crypto-engine
>
> --
> 2.34.1
>
>

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
