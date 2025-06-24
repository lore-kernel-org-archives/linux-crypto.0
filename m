Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08922FF37
	for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750749535; cv=none; b=ledegseDLzOvl2zdFaxJavakX2d+fCWnfb8YyXnOoXeOz2GIdlcyNv+lS+N2CFe/8LQUQ/uOGeTlXc1HQXMF79OFtVFBEE8zbzpKNvex4HcYoVk/40dP6oHmsV9BZyVS/ZY9KSzZMnovpgnyxJ0PRSk0cQt8jqR8PnYmgupNWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750749535; c=relaxed/simple;
	bh=lLTXEYlUZ4GhNVH36tePDrs71r0Tbb+UAAbvWJzpRwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LA8v3mW1TBjzQ4G9k0Prfl8cbfDN2FUBDolTq38IElVgoQ1n3rRnh0ySMoCe9jyzu4XbJOVkV7oxBXQ3AgR4Ya0tvvnSc5jKFSLaJOUmv8is98neFYVtjz1pSr8824QxjIKM89ayia8GCTxDt3lgarbCKqVfvUVKsg8K6qTPbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=KqtDCytv; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="KqtDCytv"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-adeaa4f3d07so994448066b.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2025 00:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1750749532; x=1751354332; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2OVh4Jh0rNBjL9Id+4yEZcEDrJ76F7tEWKqVxELxixE=;
        b=KqtDCytv6sULEM/q6YZzp3fQFpTRasjQLiaQXGyA9CWdOrVxOqje62v7NQ0wRJ1xvX
         8fhSujsUQwUWpigKFHe+YLktEVtj0m5MDx/EOHmeuM7vBNCjHYv0HITGPXyVkKfKfloT
         YX68FDgDgC9i01H63/dFN0ExThSeD0S0NzBtih2SDbIX7TaoBLpBMh7UmaH2VHNRxDKu
         HClYjijxO3g/BvFsj1sOE++fFP8m5U879B1HAkH3/an8hkf8A03j8N8V5WwErzLNMKKZ
         HpaNXGKE50To9EnNShX/s90Ne7p5db3fU2uttith7ltm6ShIryFBEalzwt3Otsh7Hh+6
         TEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750749532; x=1751354332;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OVh4Jh0rNBjL9Id+4yEZcEDrJ76F7tEWKqVxELxixE=;
        b=VOqOUQMje21P0kECEKSGkaSKmoc+vrW6Md8qI+pUr77LeDwqHGvVbCL1M9T518JEtJ
         TYq987bI55aou4wFRbgIUZTRo9Bbc5PWAhBWQUAJ7zd/mYPlk4BhmcrqB3Z8HC8NRGh5
         AEvdf0DHbzbfir0HEnZqAo4mk9mocXIFvnNifzJZ5Iynz0SWtetn8hDLrTBcw6o6N/HH
         Q9ryheTGAyKxhVAi+Az7PDt3nPEQdg/V4FY7PuF5AL9k6SdToX5zmSEeGmNfJghrHiBG
         gNO0wF7il5wHr/pL6U0E67mdizi3YEQ/WV4ifLwbAj9oMROL7mfJeRE6yVpKNX8Ov73F
         ehKA==
X-Gm-Message-State: AOJu0YxvKvBTxirKcttBrHc6TX00lSxiDbYZRR5+n/UazROZc7UKxphh
	WIyhCWE6C7Rivt1p+v/oXSt4tiYLEXCX6kiohVFD81DIXemDx+pgbGxqBdtMmCuVpX0=
X-Gm-Gg: ASbGncueBpnCvb5BOKhMKjsOU1Mxjp2vb411E+Ah4vMANFvgCvTKYcIL95vj3EXwKdq
	1IMNdo3mlxKNdsZbEsOe40xZ/p4cOihaYaE8kPWOV6VGrLHgcnYgolcHdcm8i9/ZTLE0jlo1nLs
	MhJ2DBEpdXCqHNKw6kB3eUm6xWo/e2qnH6cwv6hhuqZllPUsKFFcOn3ad3tMYo1d/nzYt315i95
	wKGhQWP3R1FdzmMS4IFllDhzDU3tt9hp4vTAAGeONkDuAxRW9KAzSK6Pul83v3K/P1zHHMV0YLq
	P95Kobgj8aofaVKepSNc9ODbZcLSJrQMBGUK8yG4mURmZJwNc91ZbWsjMPZMn5RL2pQxR4U=
X-Google-Smtp-Source: AGHT+IGI8iwrZ7v404228P/a1AWPFqYItuYifRpy4WeOeTkndey/Diu8iL6ffoSt7fIYpvcvq1pPSg==
X-Received: by 2002:a17:907:c16:b0:ae0:ac28:ec21 with SMTP id a640c23a62f3a-ae0ac28fbcdmr130864566b.13.1750749531544;
        Tue, 24 Jun 2025 00:18:51 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae054082d0esm830333266b.79.2025.06.24.00.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 00:18:51 -0700 (PDT)
Message-ID: <1524eb69-e3d1-42f5-94fb-cc783b471807@tuxon.dev>
Date: Tue, 24 Jun 2025 10:18:49 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] SAMA7D65 Add support for Crypto, CAN and PWM
To: Ryan.Wanner@microchip.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, olivia@selenic.com
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <cover.1749666053.git.Ryan.Wanner@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11.06.2025 22:47, Ryan.Wanner@microchip.com wrote:
>   ARM: dts: microchip: sama7d65: Add crypto support
>   ARM: dts: microchip: sama7d65: Add PWM support
>   ARM: dts: microchip: sama7d65: Add CAN bus support
>   ARM: dts: microchip: sama7d65: Clean up extra space
>   ARM: dts: microchip: sama7d65: Enable CAN bus

Applied to at91-dt, thanks!
