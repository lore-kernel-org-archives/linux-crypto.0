Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35B37F00C
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772654735; cv=none; b=ZhOVeALegBbUWSOywglfaEsD5McCc+5XLgooDuCCm1isy1h3/9+2JjHyFuAXr5J9kHwdh45IlIEHYsAHAbdd7CsDYyebagjqdUwpv3Uc/NRkDWyiIiHhgynSEB81fVQBLGG13jxvxocVLf5dFnMsdxwxXo4uqOtb7SPODs7gj3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772654735; c=relaxed/simple;
	bh=xjYD6G5CbGg5JtEVXKmlHBeAo19LTw9xBknLuqx9SLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J7f/8ygS72t+UlAidqR8ciDU9BqcGHEiam0a8j0KBBf3bPl6rDHWswyuJSnDZoI3R0ACZ2wbyI6vTEHB7cUeG6r2thV8q8qVGH8Mu9flgJW/1zh6d7dcRolDXm6THLW2uuKRkq6PnEMQ+fbfMJKTCuPEUhbmqhhs0xoFzP6Wr1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=oJ1OIMXj; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="oJ1OIMXj"
Received: (wp-smtpd smtp.wp.pl 28053 invoked from network); 4 Mar 2026 21:05:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1772654725; bh=bEhVJmS85dWuXz+i/uzPhkGcpMPxtb7lSKola8x84hc=;
          h=Subject:To:Cc:From;
          b=oJ1OIMXjqjeXFFszYYc3yJgoFq7PYYsoyzNz47hzV8pdAlQtEaCjfxx7YY1FHvGfy
           N7skD9lCQo2nwpqjEQwuqzUWd8K5Kz3Btb/SKwzPoJRNeb47AIQt+4tMB/xDfLaVFu
           ftfhuPAnY4idLRa6BgS36h72UjMoo3a5v2yD/HFRpepiJNdG/Z75q1yksiF3ilFdS+
           Jjd82u5zHToUvAOD8WvRbcN+Unx7XA62cVr+CuFvJfzFmkhC+3/xKhjlM0eiIAWfeI
           FoCE62fG3Od2X+c58DoHh1o+8FPwpq+yyw48SA3yLaWobrtPaU5RFS84QPZvKaFDtP
           YiRyDKc9+FJPw==
Received: from 83.24.116.171.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.24.116.171])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 4 Mar 2026 21:05:25 +0100
Message-ID: <5df659ba-4850-4c04-8153-9fb55af81bd0@wp.pl>
Date: Wed, 4 Mar 2026 21:05:24 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: airoha: en7581: add crypto offload
 support
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, lorenzo@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260303193923.85242-1-olek2@wp.pl>
 <20260303193923.85242-2-olek2@wp.pl>
 <69a73dcd.7b0a0220.1ac46b.9bfc@mx.google.com>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <69a73dcd.7b0a0220.1ac46b.9bfc@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: 98f13932068cf993ee8247d24573eb09
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [QerX]                               

Hi Christian,

On 3/3/26 21:00, Christian Marangi wrote:
> On Tue, Mar 03, 2026 at 08:39:18PM +0100, Aleksander Jan Bajkowski wrote:
>> Add support for the built-in cryptographic accelerator. This accelerator
>> supports 3DES, AES (128/192/256 bit), ARC4, MD5, SHA1, SHA224, and SHA256.
>> It also supports full IPSEC, SRTP and TLS offload.
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>   arch/arm64/boot/dts/airoha/en7581.dtsi | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/airoha/en7581.dtsi b/arch/arm64/boot/dts/airoha/en7581.dtsi
>> index ff6908a76e8e..4931b704235a 100644
>> --- a/arch/arm64/boot/dts/airoha/en7581.dtsi
>> +++ b/arch/arm64/boot/dts/airoha/en7581.dtsi
>> @@ -300,6 +300,18 @@ rng@1faa1000 {
>>   			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
>>   		};
>>   
>> +		crypto@1e004000 {
>> +			compatible = "airoha,en7581-eip93",
>> +				"inside-secure,safexcel-eip93ies";
>> +			reg = <0x0 0x1fb70000 0x0 0x1000>;
>> +
>> +			clocks = <&scuclk EN7523_CLK_CRYPTO>;
>> +
>> +			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
>> +
>> +			resets = <&scuclk EN7581_CRYPTO_RST>;
> I guess you can drop the extra new line between clocks interrupts and resets.

It makes sense.

>
> Does the driver supports these property tho? For example the clock is just
> enabled or tweaked to a specific frequency? Same question for resets.

As far as I know, the driver doesn't use these properties. They may be used
in the future.

>
>> +		};
>> +
>>   		system-controller@1fbf0200 {
>>   			compatible = "airoha,en7581-gpio-sysctl", "syscon",
>>   				     "simple-mfd";
>> -- 
>> 2.47.3
>>
