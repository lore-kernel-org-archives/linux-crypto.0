Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D2E14AD30
	for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2024 15:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724427615; cv=none; b=sIt3CaUCA2O09zlsWTpnWNZ4NY/ozINTp9+ZHtA5OHje5A/V8smwKOFmP0jKgyWmB83ZACO63Sw10sfpE07JhXxBxTQeTUC4M1XRnjYJ2dbETYI2fkFXRez6qLJdcWhCKb2zaJide66ADop3jqKOOHOcRlXWR49SWAPnYygZZg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724427615; c=relaxed/simple;
	bh=GaP3IZrd5RcE9Ge4dIzx32rmwqF5NAyUSCzfoCvnFqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dde35W6/yMOzgemZFRJer07pFQThj/c3H1fzbbKYYYdOSBR+RhbVBq2R6Pw0It0H8Qpi39U45LgTwbnigTgFsq1s5IBA/MZk0X4CYrmr63KW5cnGUlTv7+vehXD3WS7GfvDsf+P6cz4C11iBFHoVnjUMlUKNW2+z9IkcKhUrK3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CBHi8NBK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CBHi8NBK"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-201fba05363so17769065ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2024 08:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724427613; x=1725032413; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7PswcGyJCTUDaExiPb+cp181Qy+ul9NVt4xbxRyvgH4=;
        b=CBHi8NBK50ce1ZSLXcvgXuFRyvK3+rzQXgSny7GMaTBigXH6bgnAbnvH84FKCD55mv
         3EHyp40zA5RFx+5qXqCPRpgFo0YlORHzAgJuB5QbsdvY+wHkqekT2gstx/ksKOHpUrXt
         bajZAMYUR6CCtn2I/5musaR3pCM/ZttOsKdWQgfm8msehHm9xZkkWvZ0QAQ5lcMGsmZ+
         XBEPAa+kFE0tEQg1YJOrpYRHUXIA4NwwFyGrPG5ncaxf0nedAcfWjbvp+8DImEam9ma7
         DfyQm1/sYphsmSdVZOCC2TgHKJHYbHYnQWbdRDY+tGBIGWAmGMnom9u6lCjCk+qA5NR0
         7hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724427613; x=1725032413;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7PswcGyJCTUDaExiPb+cp181Qy+ul9NVt4xbxRyvgH4=;
        b=CPnFValEur3tR3mBVFOuMgCwSyBPtm41ztn1FJSOMq2kPn+5RwoJG9RtgssMmL5oQ5
         UBTKhumcr0zcX82bioPk74VN15OJ6ZxeUC/Vu9KQuUYYktcrCjyHKHyJ298ePn8/giwk
         a42HLq66lbe2nPE0n6wrvi8a/XIDXIh61V4nGlCWMhDudAy+oygYzy8ZFDXa8UOPtKmK
         0wo8nsHf8i6LZBcvEdJDwPj01MCyJIY1UWuDufv5lyAGonru1dr9WI07bduUlDxOeLnJ
         MRPtYvUFNuYXKTuOFJ2FuFMePPt/2uWcuIkx1WgKj5C6VIKMgs0UVE6FTxIbYY7fchJI
         Rsdg==
X-Forwarded-Encrypted: i=1; AJvYcCWuZczaActjjrS06hY2Fnj+AGsFddoPH3Umbx2wcDuQTs13XrJEDlTBlqM2lci0jM0BG1h4TQDXsTmyPKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAYAYuffNV8nLo61kcu8uz2hwZtgG8jd5KRK81D/6EzQh0/l7i
	TzlG5oiBGZpkx2nQMJgljMollX7atYATm6JC6ZnzJlmIza7hjj26YLw59Kjq5w==
X-Google-Smtp-Source: AGHT+IF74dSdz3Lddcc4Y1HpHeUo4j1K1gSy0t0eup/KCqO1Hsm3KR379cw9PEgNYC8BJ6xrSdPAcA==
X-Received: by 2002:a17:902:e5ce:b0:1fd:67c2:f97f with SMTP id d9443c01a7336-2039e4e7cf1mr23598545ad.28.1724427612976;
        Fri, 23 Aug 2024 08:40:12 -0700 (PDT)
Received: from thinkpad ([120.60.50.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038556686asm29835955ad.40.2024.08.23.08.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 08:40:12 -0700 (PDT)
Date: Fri, 23 Aug 2024 21:09:58 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Md Sadre Alam <quic_mdalam@quicinc.com>
Cc: vkoul@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
	thara.gopinath@gmail.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, gustavoars@kernel.org,
	u.kleine-koenig@pengutronix.de, kees@kernel.org, agross@kernel.org,
	linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, quic_srichara@quicinc.com,
	quic_varada@quicinc.com, quic_utiwari@quicinc.com
Subject: Re: [PATCH v2 01/16] dt-bindings: dma: qcom,bam: Add bam pipe lock
Message-ID: <20240823153958.vk4naz34vgkqzhrb@thinkpad>
References: <20240815085725.2740390-1-quic_mdalam@quicinc.com>
 <20240815085725.2740390-2-quic_mdalam@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240815085725.2740390-2-quic_mdalam@quicinc.com>

On Thu, Aug 15, 2024 at 02:27:10PM +0530, Md Sadre Alam wrote:
> BAM having pipe locking mechanism. The Lock and Un-Lock bit
> should be set on CMD descriptor only. Upon encountering a
> descriptor with Lock bit set, the BAM will lock all other
> pipes not related to the current pipe group, and keep
> handling the current pipe only until it sees the Un-Lock
> set.
> 
> Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
> ---
> 
> Change in [v2]
> 
> * Added initial support for dt-binding
> 
> Change in [v1]
> 
> * This patch was not included in [v1]
> 
>  Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> index 3ad0d9b1fbc5..91cc2942aa62 100644
> --- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> +++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
> @@ -77,6 +77,12 @@ properties:
>        Indicates that the bam is powered up by a remote processor but must be
>        initialized by the local processor.
>  
> +  qcom,bam_pipe_lock:
> +    type: boolean
> +    description:
> +      Indicates that the bam pipe needs locking or not based on client driver
> +      sending the LOCK or UNLOK bit set on command descriptor.
> +

This looks like a pure driver implementation and doesn't belong to the DT at
all. Why can't you add a logic in the driver to use the lock based on some
detection mechanism?

- Mani

>    reg:
>      maxItems: 1
>  
> @@ -92,6 +98,8 @@ anyOf:
>        - qcom,powered-remotely
>    - required:
>        - qcom,controlled-remotely
> +  - required:
> +      - qcom,bam_pipe_lock
>    - required:
>        - clocks
>        - clock-names
> -- 
> 2.34.1
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
