Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066D31D3560;
	Mon,  7 Oct 2024 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310117; cv=none; b=BR1UpNt/Bijg/NETkeHIsjZIfi4fjAQvKh5IV4kARB41e+MB7zf3HavbW4QVqCHBq9VtDLakoaGePbWqpg4XIhuaj9cjoQHkLpg1HqqlUXVqL/ugBy9XNyR1iGZ0kl3JxuABZk3l7cjjiJ/lJa4LS2ykpvaiIVZMEUiyT3AzgLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310117; c=relaxed/simple;
	bh=UcArVB2WrJQTu0xuLEKElBUf00mQa6MNc9pj2CRTqFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YIDz7wYJK93NC7YeMSrNfiv6RLz+bsT7Q/zFFHQL7xmzq3skHbWZDm5OJuVsBD45V4C5mRQLvL9OGi2rG/lnyOTkE9/40vpIW70JNYks1ElQ1Q0vbasdfQTKWnh3gt+oppPMfIiNcj+dxnNGWNUJe8ZauvtQDGIl1HvltW0W/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=xzIjojC5; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="xzIjojC5"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id AFE6888B78;
	Mon,  7 Oct 2024 16:08:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728310114;
	bh=+VpmP0fcyJ4CvVzbF2fPZNTRpsuYq852AIzc/SBidtU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xzIjojC59GxXRKRyu56hXd98pKsVTbyL5R3E22FUEE3Cm+gMGHRZ9MBK6DHgEnBC+
	 j/fN/jMlSBxGtNtZNvWQZmzaiM5906Itwyy1RidcsUqo5qjZKhgOaQg2irZ0aRxsOc
	 GX9GGxZexQtw3+CDRIy007j6VG7zD73biVSG+5SIqwzutx/PXVOBssYDZgcCiowyQv
	 0EB0XtLElyCYQ+NvTeKEAYdlLub7LVH5qqchcU79KAUzQQLPKyxM/fhC+X3AIH+DQZ
	 igRNWj2W4n3wOWX7ZtZKMqbBgQrSsJSxVK5O7x4PQkoqHP4mWIdqzYOI4s1Qt73yqz
	 1MKzuBt3CypfA==
Message-ID: <a7b2d849-ce6c-46b3-bf4f-c619106e2edd@denx.de>
Date: Mon, 7 Oct 2024 15:53:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] dt-bindings: rng: add st,stm32mp25-rng support
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-2-gatien.chevallier@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241007132721.168428-2-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/7/24 3:27 PM, Gatien Chevallier wrote:
> Add RNG STM32MP25x platforms compatible. Update the clock
> properties management to support all versions.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
>   .../devicetree/bindings/rng/st,stm32-rng.yaml | 41 +++++++++++++++++--
>   1 file changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> index 340d01d481d1..c92ce92b6ac9 100644
> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> @@ -18,12 +18,19 @@ properties:
>       enum:
>         - st,stm32-rng
>         - st,stm32mp13-rng
> +      - st,stm32mp25-rng
>   
>     reg:
>       maxItems: 1
>   
>     clocks:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: rng_clk
> +      - const: rng_hclk
>   
>     resets:
>       maxItems: 1
> @@ -57,15 +64,43 @@ allOf:
>         properties:
>           st,rng-lock-conf: false
>   
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - st,stm32mp25-rng
Maybe this match should be inverted, it is likely the next generation of 
stm32 will also use 2 input clock into the RNG block and it will be only 
the legacy MP1 that uses one clock.
