Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C922D4CF
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jan 2025 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047192; cv=none; b=asVVloKt9qqaSWN1fdwUnFJEw4zCH5nT6HxAIJsWFniSbOquWaiDfusNz4zCtW91VCve4WkSuVtH9rRyRSxj9Saz7INZambpBBb4JYlQUhTl8UdqNyNcNOUwa5fc/q6LPtgMZqpSoFu6t3W7uAdk8K4tblkaF7gtdsmKjXTNyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047192; c=relaxed/simple;
	bh=W+QGc9oosMrG2hvhQQqwCmRtn0fdpGyURO0Yr4Zq1co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qagPhODwBQGBqfRlkkU+At7KPJEleNEKLE9KdOdKsqRljZKdX6s3rGWDvfkofPRPaavRvdEsUgweaa2LqTZfQZ9pxwp3F6ciQ3Q/Ncfu/FpVnXIfjHnmrK59RqN16XyetTlVQeG1/yT0wJBe6e6lLkyJjAYqM3YApy780Z43gd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QAy0B+XM; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QAy0B+XM"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa69107179cso246761466b.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jan 2025 09:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737047189; x=1737651989; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BUIr9PWzb9ez1XMOIgMRecuSTosnClxVHi549vZTFOM=;
        b=QAy0B+XMNCd+Vld5BC8lhiUO7muW33DE7ITBNoqDuLScEIRdYgMNG+qt3W70gqpHHI
         X2/mW0WUlBcDl15j9rBtJMoeOTPseb7dtDBiRUV3ElwBGYKJhmSHEPM47SGH2LhQGiJf
         F0VfieJ+6+fwKTdJ1YM+eX9J3CycUFbokQlRKPikW9R49ou15DikiTped/y/250JBFgK
         Kvi15zHErjAiOhkviT/QW0q2m2TdygueOXVrOn8S3s+sOvpIBLOs4JGdqUGRc2iD2tKK
         Or64eT1wk+RBnPkPZnbqjvAZK/9rAGEAcMVA8a/c/b+BbdA4WPPvmT94yE97fTus7y07
         8xvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737047189; x=1737651989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BUIr9PWzb9ez1XMOIgMRecuSTosnClxVHi549vZTFOM=;
        b=AbkmDRaaW5WXOzBUrFAiEEv++h7+ag7oIwSAdBFmxw2gDn9EXA7tqvzgCjALzRQF8v
         biY2O0IOIhZXQTlSEHw1Mwnfw8SPtoX6x3A+KKpbHrMEm9IQ68lDK7pyRm/mD1S0IRyp
         hPv6kGVRcoH5ZxSKbxP3iXmFAQX+p94qLbVPOVo/OPUj42MhJ7dojZS2qt44fIfzQdTp
         bAiS922hsxPmj4Dnvz2bvp7aJjr/biUSi09FvNR23P5PkcoCGURKOsXrNqyUmtj4VEx+
         EnbJ3/5ebt9wjkb/MML4z0GVA18adolLfvJ1lTGSIZMQnJLwdKPCOoCx+I5zIR+y6Nt7
         jLzA==
X-Forwarded-Encrypted: i=1; AJvYcCW30uim8tzZgLDPEKHqLVynS6QfkCEu80kNEosnpPWzOGcFvUqtPZSSxU6lZgrXXULuAUjsb+8etnoMMxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YynkfqovhfIw5W7Xq5rQPYZDiB7l8zt9ujuJSILwbC8bqIStG4b
	5vLCgTlQSypIiKrEMiD8IOXGd35wAeu81ln5+gXa+w7hZ9bNIQEnUIqcVDQZFzs=
X-Gm-Gg: ASbGncup1FHEdnRgic3cu8mRDAqOmi63VEjTGZ8qMMc+qqhweSbd33DnhccYpjCslQE
	voDFLp0Ml66PNS0p59f+052z1ErjYTwllwWhCoLEKKpNBH4D6heBQy3Bxpxbk9oGq+4DTX2WG74
	bmi4bB5CPQsT94za1vQpm1d7WKGGP6yygZqBa3H1Q7yV7tW23U9DSSydOPzoqVElOsOT9ij7Oyo
	J6oJnBa34/KKxhZzT+FpmeuCzR0ANpWiFM2Pod9lL0hKNi0vvFbfkkgM7CWEzhDREmP
X-Google-Smtp-Source: AGHT+IEWnTHAyFXkE0XlaBZ/9fyifrzBZNDc9Ug+NzTkqqLyaR8APJQHdyWg+XE5PT7+tDEl09HKBA==
X-Received: by 2002:a17:907:2d06:b0:ab3:47cc:a7dd with SMTP id a640c23a62f3a-ab347ccb3bdmr852600366b.25.1737047188599;
        Thu, 16 Jan 2025 09:06:28 -0800 (PST)
Received: from linaro.org ([2a02:2454:ff21:ef30:d082:eaaf:227f:16cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f87d70sm21166266b.142.2025.01.16.09.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 09:06:28 -0800 (PST)
Date: Thu, 16 Jan 2025 18:06:26 +0100
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Melody Olvera <quic_molvera@quicinc.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Trilok Soni <quic_tsoni@quicinc.com>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH 2/6] arm64: dts: qcom: sm8750: Add QCrypto nodes
Message-ID: <Z4k8kibtnlnpKspN@linaro.org>
References: <20250113-sm8750_crypto_master-v1-0-d8e265729848@quicinc.com>
 <20250113-sm8750_crypto_master-v1-2-d8e265729848@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113-sm8750_crypto_master-v1-2-d8e265729848@quicinc.com>

On Mon, Jan 13, 2025 at 01:16:22PM -0800, Melody Olvera wrote:
> From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> 
> Add the QCE and Crypto BAM DMA nodes.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sm8750.dtsi | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
> index 3bbd7d18598ee0a3a0d5130c03a3166e1fc14d82..1ddb33ea83885e73bf15244c9cbd7067ae28cded 100644
> --- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
> @@ -1939,6 +1939,36 @@ mmss_noc: interconnect@1780000 {
>  			#interconnect-cells = <2>;
>  		};
>  
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
> +
> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +
> +			#dma-cells = <1>;
> +
> +			iommus = <&apps_smmu 0x480 0>,
> +				 <&apps_smmu 0x481 0>;

Should be equivalent to iommus = <&apps_smmu 0x480 0x1>?

> +
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;

If you don't have clocks here, you need to provide num-channels and
qcom,num-ees. Otherwise, there is a risk this will crash if the BAM is
not up while being probed.

Thanks,
Stephan
