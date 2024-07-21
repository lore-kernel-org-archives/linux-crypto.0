Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ABE34CDD;
	Sun, 21 Jul 2024 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721565568; cv=none; b=L2RjebqinQwH70BSoSzIjhFK/glCC6cRJMEznUBEz02jw7ir8LIm3eufg8GF3EFkrstfild+URSd9SnHRf2Sr0MeiiWIWjXMsdFbfg0+LN0AkktcJwWo+NjEOfPjap9ThVUOh7MK/FfBaUXs/W+cJg7bqUm7j+fgUMzqperq+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721565568; c=relaxed/simple;
	bh=dLpzo+g9QxqIXUqWOmJ49ilN5WyuUFwXoG2IaYfSQwQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=bYsmgPj55z5x/anJX2Ja2nUDglDBIqLbaKbXKka4qq5I+38G47qZKL+M/ZhHD/tCQH8sD7zb6ZZiwgnG9OVe2wu2FBYvNoP7JIrECzN2PGM56KBLk3udT2zBmL6IZCPpnN+IrgCjzCXAjRjuOVovsSx7cE+lSCMm35vHg11NO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=Aqzh2IEU; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="Aqzh2IEU"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721565556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sj5SdsqLshc4Doxk2l9rRTDcIsxeSlUSxAWNQexm/js=;
	b=Aqzh2IEUbLZelPokueajyNss61XGrhiEx8UMZHAYQEqttTaau3po0oi5hPLT0RcHrfK2a5
	DYLTQuxz0u8Fbr3TNM/t4f3QyF7cUS2yEmGvUVo3o1eCTCMkgZDJK6udj4MqIPObpSLPl3
	tGotN5fnfMBlIyXYwMEVQFxKoX8mY4AIFbKitvtUzm3IaiuhnZRbtpnIFFt0o1crmBVN/q
	MxX2vJGORObyq83tDpYIesoZiTcaHRf5KZJ626JsozN0AyWW5AG/tXimIZ1X6MnDuxgn28
	B53l4ERZojHT0kwb0j1yb4P3m5D7187NaN0CcVSYmSW4NlEPYxVa+uQo3kv6jg==
Date: Sun, 21 Jul 2024 14:39:07 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
 linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>, Conor
 Dooley <conor+dt@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 devicetree@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>, Sascha Hauer
 <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 linux-rockchip@lists.infradead.org, linux-crypto@vger.kernel.org, Philipp
 Zabel <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>,
 Francesco Dolcini <francesco.dolcini@toradex.com>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, Heiko Stuebner
 <heiko@sntech.de>
Subject: Re: [PATCH v8 3/3] arm64: dts: rockchip: add DT entry for RNG to
 RK356x
In-Reply-To: <Zpz5-2q-C0oQBqoa@zx2c4.com>
References: <cover.1721522430.git.daniel@makrotopia.org>
 <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>
 <Zpz5-2q-C0oQBqoa@zx2c4.com>
Message-ID: <bfd6a1608ec5b9e0b4d7a77bd2a56309@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello all,

On 2024-07-21 14:07, Jason A. Donenfeld wrote:
> On Sun, Jul 21, 2024 at 01:48:38AM +0100, Daniel Golle wrote:
>> From: Aurelien Jarno <aurelien@aurel32.net>
>> 
>> Enable the just added Rockchip RNG driver for RK356x SoCs.
>> 
>> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
>> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
>> ---
>>  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  7 +++++++
>>  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
>>  2 files changed, 17 insertions(+)
>> 
>> diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi 
>> b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
>> index f1be76a54ceb..b9c6b2dc87fa 100644
>> --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
>> +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
>> @@ -257,6 +257,13 @@ power-domain@RK3568_PD_PIPE {
>>  	};
>>  };
>> 
>> +&rng {
>> +	rockchip,sample-count = <1000>;
>> +	quality = <900>;
> 
> As I already wrote you for v7, quality is out of 1024, not 1000, so 
> this
> won't hit 90% as you intend.
> 
> But also, I think putting this in the DT is a mistake. Other drivers
> don't generally do this, and if the hardware is actually the same piece
> to piece (it is...), then there's not per-manufactured unit tweaking
> needed. So keep this in the actual driver C like other drivers.

Actually, if we find out that some samples of RK3568 have HWRNG that
performs poorly, we'll be able to regrettably conclude that this driver
cannot be used at all.  As we remember, RK3566 has been already proven
to have inconsistent HRWNG that may perform poorly, which basically
disqualifies the RK3566 from using this driver.

Thus, I agree that the per-SoC-variant parameters should be moved
to the driver code in the final version.  However, this is still
a development version that has the parameters in the DT specifically
to allow easier testing of the different parameter values.
