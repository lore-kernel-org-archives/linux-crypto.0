Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795774365;
	b=zNz3pRTWzuKP6XXNHWFigUltg/dQEgajXIRZ0eNI5gc+DfcFWOEHE1G861S3FjCiMW+3
	 3fUiKvEpeeGIKOo3tfHvrA3eX1v+Lcjkm1w6cn8k551gvvz00eev1u9Al0Bu8hYK9b9K4
	 h/EpsutSIFqpJlwUOtFUTk/pgzTFH57ywWEBPJFVaAjQglcErOgVbuwpCNIpfQJtWLCI3
	 0aXyOg6OaAH4UKpVTdK84nMm5hLqDdLeP2ggqFxRHgupm8zCylmCXZrwwVG2pCrj/7vGX
	 QyPneWmie2G21zkGHLGJ9nF5RTXtiYxjJPWat4T/wNMSzfLtHqzhh9UyL6ebfy0orZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795774365;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=v1/2YqpCnIwSCbwLLDUxkqgFBM6zZChxPmbs8wgtA+k=;
	b=Dem3dZcv2HAzvCyfyLex3Um4RzMbFng4qChein6+uqG4PHiz+eXSePoaJJ3gfKmg++wN
	 tHe3mlZh1z9TMvfONAIa5upVaqDeUTKx5RKFKLvsfU+7jQrB9LUtx3OoFknA2sQpEhmhv
	 hc4aJ28kG/YRRFYMaHuF/GVX+ojfV44RmCe7yekONeEweh5b6eQ0mqpwVfIbUfOz9kwzb
	 zV+/7Y2RvgnXA1/DsGJ6TWRqK37vLxO1MiJ68dtRkrvzFCuVKJg2IKc6rxpYgmi+/wWKL
	 +RGWJ4IQ36umj2WJn+rqiVAQOrZcq7gG6d6GY9zomRUK5eUhS/bcXzkpLgpFflOQgmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fBSmtxPJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB600606A31E;
	Fri, 27 Nov 2026 10:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB600606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fBSmtxPJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 383C81758;
	Fri, 27 Nov 2026 02:12:35 -0800 (PST)
Received: from [10.33.50.35] (e142021.arm.com [10.33.50.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B6FB3F86C;
	Fri, 27 Nov 2026 02:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795774358; bh=c0/6aFDfGtHa/8JQkzEFzcPkvj+Wr26/24s6cKwSZCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fBSmtxPJFJbeboQw9s+OXlHilp+OaovcEU5LIl1/Cw+DtoGBkQnd0nqKd7/SaZl1y
	 j1hOmIWQGJa+hcR/AtcXt6RKNRg0+L+9h6G2E4MG2+42VOynwL/NvBRH8/hUCqDnrS
	 a/yTDaH5tcedXgKOZyL4ilJHfyP8zJUH1/TpaZRc=
Message-ID: <194329c7-45d0-4493-af07-f972694c075e@arm.com>
Date: Fri, 27 Nov 2026 10:12:32 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] hwrng: sun55i-ce: Add Allwinner A733 CE v5 TRNG
 support
To: Alastair D'Silva <alastair@d-silva.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, Olivia Mackall
 <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Chen-Yu Tsai <wens@kernel.org>,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20261125210532.695823-1-alastair@d-silva.org>
Content-Language: en-GB
From: Andre Przywara <andre.przywara@arm.com>
In-Reply-To: <20261125210532.695823-1-alastair@d-silva.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 11/25/26 22:05, Alastair D'Silva wrote:
> This series adds True Random Number Generator (TRNG) support for the
> Allwinner Crypto Engine v5 on A523 and A733 SoCs, and enables it on the

so while I agree that the TRNG part is probably the most practical 
functionality of the crypto engine IP, the encryption/decryption parts 
are still there, and we have a driver for the older IP. And because the 
functionality shares all of the registers and probably most of the 
descriptor generating code, and Linux is really after code sharing, I 
think we want the driver to live in drivers/crypto, next to the existing 
sun8i-ce code, if not becoming part of it.

Cheers,
Andre
> Xunlong OrangePi 4 Pro.
> 
> Dependencies:
> Patches 3 and 4 depend on the OrangePi 4 Pro bringup series:
>    [PATCH 0/3] arm64: dts: allwinner: Add Xunlong OrangePi 4 Pro support
>    Message-ID: <20261125124407.4098345-1-alastair@d-silva.org>
> 
> Tested on Xunlong OrangePi 4 Pro (/dev/hwrng).
> 
> Alastair D'Silva (4):
>    dt-bindings: crypto: Add Allwinner A523/A733 Crypto Engine
>    hwrng: sun55i-ce - Add Allwinner CE v5 TRNG driver
>    arm64: dts: allwinner: sun60i-a733: Add Crypto Engine node
>    arm64: dts: allwinner: sun60i-a733-orangepi-4-pro: Enable Crypto
>      Engine
> 
>   .../crypto/allwinner,sun55i-a523-crypto.yaml  |  68 ++++
>   MAINTAINERS                                   |   7 +
>   .../allwinner/sun60i-a733-orangepi-4-pro.dts  |   4 +
>   .../arm64/boot/dts/allwinner/sun60i-a733.dtsi |  12 +
>   drivers/char/hw_random/Kconfig                |  13 +
>   drivers/char/hw_random/Makefile               |   1 +
>   drivers/char/hw_random/sun55i-ce-trng.c       | 377 ++++++++++++++++++
>   7 files changed, 482 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun55i-a523-crypto.yaml
>   create mode 100644 drivers/char/hw_random/sun55i-ce-trng.c
> 

