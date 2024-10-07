Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A61D5CD4;
	Mon,  7 Oct 2024 14:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310121; cv=none; b=Y/DHE6DU7rFMK39dqkhU18epwmx0BiVMbF/IYPKu+YDsmxWs++b/Fqy3g2fSt0Cr/6ZFqoUJhZJ4BldQPxT15GX7MqCq4UIxPF2e2fDX94JHdIldxy6FkT1exfTmGNUrQ5SfqvRn2nnS0+B2Jlx7eOu0VEYjcnW24pZQNLFdJAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310121; c=relaxed/simple;
	bh=0gwcW04YTGYp7p2fDOGuzg6HMNLDsqtnQVfcT2rS2Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0Vsnlbb+to6J3Z0kknxD2RNqirJxaMRRKj4HV8I2++8VjE71skAvkLY4QZVjrKmIdcoko0y9NRqIeSzLSeXlbtWBgMRAtW2JyBMtdBku6ArqrjR41jqVwcMgmzKhKWfDgHXX21/fJXwXSTEPKgKQY1tikQD0qzmd0xs5Wn7aUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=KAtGW40E; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="KAtGW40E"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id DC1D888D25;
	Mon,  7 Oct 2024 16:08:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728310117;
	bh=k0RGQ4a+fyExLgkPRtc1Mu++azcL+u8A2VeZz0bllTE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KAtGW40EpkCgtUeOQ/i0ajt2U+XnSDbBf5Y2mnt++nrxmseacif1+14StVXjffw+i
	 BrgA/aUDHnTUlYxuyiK008bmZG3Xtl8OqGirXwh9Wq16nzfUPrfUBjhzXFXZdF1vgW
	 sxQ0G1KsbobFt4Y4lwRYkw0upGCGoiWj2lyW/0mlagFXAmRClB584pmusgMfjW/iOz
	 xi3eOaIJhsiQEiWdF2UG27HHjtv3Znd/17EYChZKIsjByqhTYxZ1oHyetTTwqk5Wiu
	 6Fk7lqH5SsE7qKYd/esThqEcgMgoETe5cM2GkKB2G4J45/mS+6hkQvS/MHbD1z8Daa
	 /QYun9jDQl6IQ==
Message-ID: <869fe073-c20f-4611-ae84-8268a890a12c@denx.de>
Date: Mon, 7 Oct 2024 15:55:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] arm64: dts: st: add RNG node on stm32mp251
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
 <20241007132721.168428-5-gatien.chevallier@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241007132721.168428-5-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/7/24 3:27 PM, Gatien Chevallier wrote:
> Update the device-tree stm32mp251.dtsi by adding the Random Number
> Generator(RNG) node.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> ---
>   arch/arm64/boot/dts/st/stm32mp251.dtsi | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
> index 1167cf63d7e8..40b96353a803 100644
> --- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
> +++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
> @@ -493,6 +493,16 @@ uart8: serial@40380000 {
>   				status = "disabled";
>   			};
>   
> +			rng: rng@42020000 {
> +				compatible = "st,stm32mp25-rng";
> +				reg = <0x42020000 0x400>;
> +				clocks = <&clk_rcbsec>, <&rcc CK_BUS_RNG>;
> +				clock-names = "rng_clk", "rng_hclk";
> +				resets = <&rcc RNG_R>;
> +				access-controllers = <&rifsc 92>;
It would be good if someone finally sorted the access-controllers 
property in all the MP2 nodes alphabetically ; that's separate 
patch/series though.
