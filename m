Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590AA342169
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768142549; cv=none; b=n7k79ZwkV+YBZgiaXq5Ksre1LrX3E0SaE9LATafP7tZXhsQ10eKjCCtxvSh2Hr3HWu/F68D41xzy3BiENqxGe1ljtCswoUUZl7xRyfMcA9qgsosaX2ToGH0ne3QjgtVtbzf3rmya5bvRbu5cb2uFTFermwdS7DKugPsQwnJQwpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768142549; c=relaxed/simple;
	bh=nwibogWEaRHQR0G0uXO7BApOaM+RxcF4pitpiLWDTZg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rhED17Pt3guCJ5Zx3o+/9n98KDksUtNPoKHmkWMEj2+3dVahQsMta2ton5MUc9oPcPQctl+K60fyY0bhfo+S9/tci90mE52Pye+RdQJy5BstbrXR9HEmmJ5Z/kpLIHqgE6W8Ki5x2rIBCUOrZ3OkEx6tQ2xJExFM/T+1arQaGoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=c77L/krc; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="c77L/krc"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b921d9e67so9624684a12.3
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768142546; x=1768747346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MkabSAxRfLn0dHpHfPolIqVil9ZYQkOUo+uqCMKmtA0=;
        b=c77L/krcX+Mfr24+FUl4++gD6P5i5AGxy0m+b1eI91GhsDm0sayjulKachXmaIlYnj
         wCOILRVKwoNMqwNVxiWqRG/2EpusMOG+6mI5UGjqQhrvQX/0x8TiI6/sD/LxA6Hib49A
         w1bH1nFUZyZHE7gn2ZaU+W23FBJAHpOkkENkXq3dyjTbNfVtcnT0ibchItmEiZ1Np1qd
         rc0qk+dTF5Uvu980fQlLsCVoritMg6f6VP48BGlFIXsO11MCq0nYJAdrEc8pu+EFAWms
         a9jgZUFbr9W0Mz4E+TgG2PBR7kf7gSyNi/WRoJKvSsndQ8k0T0kWq1Tnsly+JbkLGMdO
         RD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768142546; x=1768747346;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkabSAxRfLn0dHpHfPolIqVil9ZYQkOUo+uqCMKmtA0=;
        b=Lo2M6FeQ1lKZjcoM8R//+3+i1SdW6qTwtnPITJNJFndci7sd/3H/xWKXyLGJRKDMLm
         JED0Ec9p9pG6/0KCGDuzOr9ICDKZlwwsyBoFWYDuPIvzpOB/7rhmaPrjhqSYQibgMzLb
         /wI2qv388/+ODJkcDHsXN0Jixkx+ce+nuXxNzHOdS5Myb9Z2zmB5QFWM7/bCQUdAeT0v
         ukd08S5BMECNXBU4UTWsk/UscAnvH6Ij/RDGWr18C7SM17USaHlEZgDf83c+iGfRqlIU
         AETPiLDUjW7aVe2FPbUM/HocCZfZMF/ukuhWFvdVZ9fS8gCbN/oJMr3hsXBHBQ/KXm9+
         G5og==
X-Forwarded-Encrypted: i=1; AJvYcCWwyjywLJ893AeFerLzAAnZPo4oFdmRxhlz3ESRnep4CcturWStTuVfZz7U6c+d5zH1LzkfLsfcPdN2Wes=@vger.kernel.org
X-Gm-Message-State: AOJu0YyodnIkZqlsj8It8P8f+7ohp/xOPpptk97HplF6dfTI1GlYb6o5
	WJFgN3QCfErBDzJoGLngcIe7zxANKJOlQlGVErA5SD80pa55sFMjTjFSy3SdQfn8SM0=
X-Gm-Gg: AY/fxX5J1iJBJUyMwMCz+cdqpwtKufQ3YNrBDSXPB5gQwHW3v8GIO5O4dHfVKXHiF0z
	qkjarkKZ8Oxb8o8ZhikFNxefEB/6jF3X+8whqwM6nelNrnGRjcQ+EdnTA9lWsvGWZFC6yBkPH6x
	SA12Rr5g+ezkNV3p1Fqvo0mfRE9HbPQe32JFqtVSnUoIehHqpWou29vHspBu2POT9EPWqZBbO5c
	esAmy13uoFE/gqUW97vieBwwoQz1CfFpL8nN9ziWkkyZPsJ8pylz1E52xKLvGoP3lhA+aTT7v+I
	UOIOT8Fjaly3JheSNPAhvLFkyxhR8qyQM5qPdyqAnOjII8jTDJTNcInlb1hgNxlduca9Eykf7eH
	uc9n4c3RH1xe8w45n+8W8wE2ssxwKxOJnRaaSGbEYde1ftfB1a/jCdEFDqJXqFvWnsLUG5DqjU5
	UWuuezpbDY6K2A+GE6WqC2cfnK3NwGt+xcFA==
X-Google-Smtp-Source: AGHT+IFonU/ClDvId9huEtx8OVZbpqDSrZa3cVBTJbulbnKxAZxCbWxaUM02TgbsxBJ1Mah6guhUAA==
X-Received: by 2002:a05:6402:1469:b0:641:8a92:9334 with SMTP id 4fb4d7f45d1cf-65097dceb25mr14589135a12.6.1768142545311;
        Sun, 11 Jan 2026 06:42:25 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507be658b3sm14914417a12.18.2026.01.11.06.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:42:24 -0800 (PST)
Message-ID: <2cdac084-4924-4ca2-85d6-2e6d9bf284aa@tuxon.dev>
Date: Sun, 11 Jan 2026 16:42:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: claudiu beznea <claudiu.beznea@tuxon.dev>
Subject: Re: [PATCH v4 12/15] arm64: dts: microchip: add LAN969x clock header
 file
To: Robert Marko <robert.marko@sartura.hr>, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, vkoul@kernel.org, andi.shyti@kernel.org,
 lee@kernel.org, andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linusw@kernel.org, Steen.Hegelund@microchip.com,
 daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
 olivia@selenic.com, radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com,
 gregkh@linuxfoundation.org, jirislaby@kernel.org, broonie@kernel.org,
 lars.povlsen@microchip.com, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr
References: <20251229184004.571837-1-robert.marko@sartura.hr>
 <20251229184004.571837-13-robert.marko@sartura.hr>
Content-Language: en-US
In-Reply-To: <20251229184004.571837-13-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> LAN969x uses hardware clock indexes, so document theses in a header to make
> them humanly readable.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
> Changes in v4:
> * Move clock indexes from dt-bindings to a DTS header
> 
> Changes in v2:
> * Rename file to microchip,lan9691.h
> 
>   arch/arm64/boot/dts/microchip/clk-lan9691.h | 24 +++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>   create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h
> 
> diff --git a/arch/arm64/boot/dts/microchip/clk-lan9691.h b/arch/arm64/boot/dts/microchip/clk-lan9691.h
> new file mode 100644
> index 000000000000..f0006a603747
> --- /dev/null
> +++ b/arch/arm64/boot/dts/microchip/clk-lan9691.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */

Shouldn't this use the same license as the dtsi including it?

> +
> +#ifndef _DTS_CLK_LAN9691_H
> +#define _DTS_CLK_LAN9691_H
> +
> +#define GCK_ID_QSPI0		0
> +#define GCK_ID_QSPI2		1
> +#define GCK_ID_SDMMC0		2
> +#define GCK_ID_SDMMC1		3
> +#define GCK_ID_MCAN0		4
> +#define GCK_ID_MCAN1		5
> +#define GCK_ID_FLEXCOM0		6
> +#define GCK_ID_FLEXCOM1		7
> +#define GCK_ID_FLEXCOM2		8
> +#define GCK_ID_FLEXCOM3		9
> +#define GCK_ID_TIMER		10
> +#define GCK_ID_USB_REFCLK	11
> +
> +/* Gate clocks */
> +#define GCK_GATE_USB_DRD	12
> +#define GCK_GATE_MCRAMC		13
> +#define GCK_GATE_HMATRIX	14
> +
> +#endif

