Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A420A5E1
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733153089; cv=none; b=ravQiM00Jj13qFktWoZ2/nzEer/PQ0zcWVC5uHWIsG1pSc7wY9bUARnFhmKC5p/FRK0pDpbwwFlTB5oZrCqieIdBd6O2a9xX2XghZLSoVdUrcq+xquuZ804Mh3Whhc1WEqtbkauFAZXqnn4jKZsjmkFwo3Y9AAqjGeyIzjV4Hrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733153089; c=relaxed/simple;
	bh=goFeMCUVRbDjipThdghVVJLskLf8H473+GNXYnXXrDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABVj9opwdjRV2wTmutdVNXxWRuLGMtaWicfZr+QUuiACI3aDInSJ0IxHwvVtQJuHIaMUnuqjS9SYUrlUTny/seJeZ77IG3+h9iQZQ+5nS7AbBTLDlHGuTdu2O6WrZBgKkIsOP4swN39e9ToDsr2mxcgmzdNSCOFY3S5r2C8o6eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uRx6VuxM; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uRx6VuxM"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e3970ac2dddso3383890276.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Dec 2024 07:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733153086; x=1733757886; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=05ZXtxtYDYApb+lIzc95yV2LA74LDricN9fUjzTVsRg=;
        b=uRx6VuxMhqjU5kzREUBVrmyWJSJ7t6VMUn63IrxrbKfo9zn62de77W8cHQYI1pZNTb
         +Zf2y+HArTa8UNB7E0w4Sv93LqC/jOfvYSZvfhPTmZs1Hm/pEXeobFAd+FCNtGULtsCC
         vRGSH43uofb1IDl+y0iRlmNSWBsOSa+b10ouag4h2ikswTJEuh+DIixdHGtOUEwl7JCn
         a9t7QKqJ+YDq1wEn2s9ViNVOGoA5L1waoMBg5zdknUGpgn4AyuH3L5gxmTChIvDQNjX9
         npjRvDIQcRyjJ88CRS9jyg/86RMeV+KQzJCzexa74VLy3Xq2ye1HPCUwi16MzhDQ6Gqd
         Uflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733153086; x=1733757886;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=05ZXtxtYDYApb+lIzc95yV2LA74LDricN9fUjzTVsRg=;
        b=FhmZ4h2XrDTuFzWlkEhTcU4tjiecB65ENha/waq8RDv5rmoOWpE7Ky6cSaCoG9M3Rt
         uXGvt9ya9haGiGkjef8g6FDaCkNTYdBfLVepAIcssJZJoc3aUGzP6xAzES7VXQxr0EH3
         w2b+zjEf6yxaHk+5SQoOMXQWs1E+E7i17CsVqesrnvxgkOjXTpEs3DIvw+s73gW9FDUr
         nSZYubC4Sc3PkUkFFtjYh6/gCnBUJAhatIlV5vLbXtkfEt4ElzC9y4HW7D3UyXNiHYik
         2mnI1w+SLQG5BhUS2UE0YUpnHmKVCPALGWVJklhTtN7b+n2a/ttcV7MFxif1cbSA84sR
         NtWg==
X-Forwarded-Encrypted: i=1; AJvYcCUU7Zfd4YUfmcqNzsQaxhpxzYMjBSo5MNPNEpd/EmgvIY0+ll3bmQ5P1GpQedQPBhc58WdpCDoCOH2HUmg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5NhqNx44qTHj03vcFv4Kkeso3jLoeqofsh4D1nSJ3HC6/Xl0f
	YqZzn6S9v0GHfY/QQ4qSuEtsXKDx4smH6gli2LkShAKz3QmS4b7/OE4Jfrsp00e3F6Ksw9qnUyr
	DHfv7z00MEBo1R+qTpb6vnKeWm/ynllGKfKVYXg==
X-Gm-Gg: ASbGncsei39GKg4sxBO5xKxpmZ+JMy6xJs1iDvpC2R5cMpusRIwntjue6vD8tN9Lt3h
	Fb7MvDrqL9NJgHkOowzDc8JnV4QyrAXDI
X-Google-Smtp-Source: AGHT+IG1/7GNikn+o7qWaeU6OlA3SHIeQqG6VzX6iFXwmrBOhF0bD/LXd61skcVAWua1i/pv/Z75jusfAxofKt3ImP8=
X-Received: by 2002:a05:6902:2e0e:b0:e39:9b9f:7f87 with SMTP id
 3f1490d57ef6-e399b9f830cmr6954354276.29.1733153086437; Mon, 02 Dec 2024
 07:24:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130094758.15553-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20241130094758.15553-1-krzysztof.kozlowski@linaro.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Mon, 2 Dec 2024 16:24:10 +0100
Message-ID: <CAPDyKFqiar=EKBHG=PHimjNcdLKsVdx+BRZReEJzHr8_qoayeg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Drop Bhupesh Sharma from maintainers
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	Bhupesh Sharma <bhupesh.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 30 Nov 2024 at 10:48, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> For more than a year all emails to Bhupesh Sharma's Linaro emails bounce
> and there were no updates to mailmap.  No reviews from Bhupesh, either,
> so change the maintainer to Bjorn and Konrad (Qualcomm SoC maintainers).
>
> Cc: Bhupesh Sharma <bhupesh.linux@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

I have queued this up via my mmc tree for next. If anyone has
objections to that and wants to funnel this via another tree, please
let me know!

Kind regards
Uffe


> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml         | 3 ++-
>  Documentation/devicetree/bindings/mmc/sdhci-msm.yaml           | 3 ++-
>  Documentation/devicetree/bindings/net/qcom,ethqos.yaml         | 3 ++-
>  .../devicetree/bindings/remoteproc/qcom,sm6115-pas.yaml        | 3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index c09be97434ac..62310add2e44 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Qualcomm crypto engine driver
>
>  maintainers:
> -  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +  - Bjorn Andersson <andersson@kernel.org>
> +  - Konrad Dybcio <konradybcio@kernel.org>
>
>  description:
>    This document defines the binding for the QCE crypto
> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> index 8b393e26e025..eed9063e9bb3 100644
> --- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> +++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
> @@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Qualcomm SDHCI controller (sdhci-msm)
>
>  maintainers:
> -  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +  - Bjorn Andersson <andersson@kernel.org>
> +  - Konrad Dybcio <konradybcio@kernel.org>
>
>  description:
>    Secure Digital Host Controller Interface (SDHCI) present on
> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> index 0bcd593a7bd0..f117471fb06f 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> @@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Qualcomm Ethernet ETHQOS device
>
>  maintainers:
> -  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +  - Bjorn Andersson <andersson@kernel.org>
> +  - Konrad Dybcio <konradybcio@kernel.org>
>
>  description:
>    dwmmac based Qualcomm ethernet devices which support Gigabit
> diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,sm6115-pas.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,sm6115-pas.yaml
> index 758adb06c8dd..059cb87b4d6c 100644
> --- a/Documentation/devicetree/bindings/remoteproc/qcom,sm6115-pas.yaml
> +++ b/Documentation/devicetree/bindings/remoteproc/qcom,sm6115-pas.yaml
> @@ -7,7 +7,8 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Qualcomm SM6115 Peripheral Authentication Service
>
>  maintainers:
> -  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +  - Bjorn Andersson <andersson@kernel.org>
> +  - Konrad Dybcio <konradybcio@kernel.org>
>
>  description:
>    Qualcomm SM6115 SoC Peripheral Authentication Service loads and boots
> --
> 2.43.0
>
>
