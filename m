Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC261891A9
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718645980; cv=none; b=iz8bNDXwJeUUmgG68hqIeiTuSPJWsc4wBnZYn5Jn9ST1x5cij1FVGVuQQk2XolkK5SgPMxco07lhgTbwo6+r7RO2NxGmz2DVGMPnj/X7kJbcL0r65hkTFfRU7Y8of+Vke0pB34GPUmrEIb+l4h+2IEnnyopoJUuVdhBTbGQzyjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718645980; c=relaxed/simple;
	bh=7tbngbM0thJzH7DBH8FLM8dfaladHgKX1kOLNHAYi7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oN5NunchMFvbFt0WP1m7vbPC+t9eGAAXHro3yJ1uyrZPxa5+PxGabRYDCI3jQXFzVDUB5gGHxyyHm5Gk7ipSZzMj7BNdKuMlQWctUV2WcRIk73xzKypp7mZby9BHA1JYlPS1tWYRqSGIFR/ZWd056b4i+wyhGsbC1ec6ZyKrOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YNT7NuiE; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YNT7NuiE"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52b78ef397bso5356317e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 10:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718645976; x=1719250776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IkTc3joUdIw3ZeosQL+9+Gg1cqpTq6IsWfB+l/kr07k=;
        b=YNT7NuiExncqKs6KZg4lGdUk+qzMQlEm1VklBTEfZpbjx4amJZNXJPxBnOQeMxR6Mp
         BB+0MFyxNzWgfSFIOMxuM/coIdAKNxpz5DYGb5ggLkYbUFBFR0M+UBcPtyjxhsKFvE/0
         n18N3j6KB1LkpI/mxnNY7ORWnEHwln/Bppa/ajZumV0Sjna0i7EIxKCdz1D4Ey8w6/t2
         oESvo9qz3IlMscUZbUrlaiCXAQs7NVaf+J8JI0LBow8vkH+QYe8kAezGBWIv6x3lSh/V
         3aVhcUAhel1D2XRliRUtHcox1Hz0rZ99RgK+LX98qsu21r5iQaVtF7WV8XhN+dmtIIM9
         Wh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718645976; x=1719250776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IkTc3joUdIw3ZeosQL+9+Gg1cqpTq6IsWfB+l/kr07k=;
        b=wO/cfbkIs54SWLf31JnnMuVhYoyyGRTCrAkSRBoV7uLKkzGI6g/brrNdvBoUVIhQ4G
         rbEnpYsJMkbbEJSMIgsfcf+mG8tjMf8Tn7CS8kY+pVIGWTOqoXSWA9SWiRdmatmQ6Lg8
         3LdqsQa8yGPhRKYw0RRkNlnDBzldLPLg4wuXTQDV378LbRA2Virmux3o3dKxgC5TlqYD
         KlIkZ3FCNUJuW4U7Fym1VM2yhKF+XxfaMgi2v0hpO18I2e7WUrVeTSJo3kJhw0PlB1V/
         YFWx7T1oxqW04fhhHmL6bngh9WgXLPpBWk/3eqclszqPD/5mPR1Fk3fHFywoeohat98L
         8hVA==
X-Forwarded-Encrypted: i=1; AJvYcCUSPsDY4AsWHfwPto7hnRxWrIY8s+EGTX3w3JaW2ednlQ7l80NNheYclcKFoVz9K17fcHCCgDGTK+O/GMV/Oh9xelJapwKHVgINgBhY
X-Gm-Message-State: AOJu0Yy1vlHromvPqh3OBHIZsZpdoDqtENW4M8Q7C/nGDhtcKPClQs8M
	bko2SLs4bJQ+svdu4dvI/M7UPZVs+QnMmU9PsicJkIrWK98jha/0psd6HcVzBiw=
X-Google-Smtp-Source: AGHT+IFqFPRmpS3LOzv4lOvGb9jjYE3HbZMF2oFd6BHrIpNVU/vzTJcDXnOpRRO0oZ9ZZxbHzjC2kg==
X-Received: by 2002:a05:6512:3452:b0:52c:ba72:9414 with SMTP id 2adb3069b0e04-52cc4ae9fbemr60960e87.32.1718645976525;
        Mon, 17 Jun 2024 10:39:36 -0700 (PDT)
Received: from ?IPV6:2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8? ([2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cb7c98b17sm560651e87.235.2024.06.17.10.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 10:39:36 -0700 (PDT)
Message-ID: <311e97da-3ec3-407a-920b-fd042392cf0b@linaro.org>
Date: Mon, 17 Jun 2024 19:39:31 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/15] dt-bindings: crypto: ice: document the hwkm
 property
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org,
 srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
 kernel@quicinc.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, quic_omprsing@quicinc.com,
 quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org,
 ulf.hansson@linaro.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
 mani@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au,
 psodagud@quicinc.com, quic_apurupa@quicinc.com, sonalg@quicinc.com
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-14-quic_gaurkash@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20240617005825.1443206-14-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/17/24 02:51, Gaurav Kashyap wrote:
> When Qualcomm's Inline Crypto Engine (ICE) contains Hardware
> Key Manager (HWKM), and the 'HWKM' mode is enabled, it
> supports wrapped keys. However, this also requires firmware
> support in Trustzone to work correctly, which may not be available
> on all chipsets. In the above scenario, ICE needs to support standard
> keys even though HWKM is integrated from a hardware perspective.
> 
> Introducing this property so that Hardware wrapped key support
> can be enabled/disabled from software based on chipset firmware,
> and not just based on hardware version.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   .../bindings/crypto/qcom,inline-crypto-engine.yaml     | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 0304f074cf08..0bb4d008f961 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -27,6 +27,16 @@ properties:
>     clocks:
>       maxItems: 1
>   
> +  qcom,ice-use-hwkm:
> +    type: boolean
> +    description:
> +      Use the supported Hardware Key Manager (HWKM) in Qualcomm ICE
> +      to support wrapped keys. Having this entry helps scenarios where
> +      the ICE hardware supports HWKM, but the Trustzone firmware does
> +      not have the full capability to use this HWKM and support wrapped
> +      keys. Not having this entry enabled would make ICE function in
> +      non-HWKM mode supporting standard keys.

Just check if qcom_scm_derive_sw_secret is available instead

Konrad
