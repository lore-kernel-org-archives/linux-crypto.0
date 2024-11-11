Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640811BC9F5;
	Mon, 11 Nov 2024 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731363212; cv=none; b=Nr+Z/vP5rrxLKEYpYRYEG1A4BnDAiUx8waiFmEKagkTMl5daMdFbbbCnIsGUbYI4dRKcZiKqpF0aGJR1bxyZs69UU8TeILIWZRrxYeYXsI8T1Sy9lDeqJIKu3VnGXZE+ZdH1PPjV5/a21fKsx0xIL+0PfpJzzwPrM9C7rKgnmAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731363212; c=relaxed/simple;
	bh=EzOqKCAezFm7x87BPNt/zzxHJFID7yktvqQaAuxYHNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfLiUMXQxF/j1v5neDlG4lvyLeBEicj89hCZpMZsqSKPLMU+x8LKDlDkm9Lk1sJDwbkIbZTrjuYxLxkMKh81Kr+RI2jq435AkEOitG/C1zD2SLJd3PDHsF/5+5LIYT2E/Pa8ewx8Iomv0ZAWDNBUuKtTdLVE4OyaGkPUPP63MRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFqhzx5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFqhzx5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD0EC4CECF;
	Mon, 11 Nov 2024 22:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731363211;
	bh=EzOqKCAezFm7x87BPNt/zzxHJFID7yktvqQaAuxYHNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HFqhzx5PQDJ8XTbqjKmtAw93yoOw8x7o/ZUMlJBX+8O04Mr/GRzq+M1/6R39B45zY
	 CEF098rtQHm7qtp5m7M/1uTI9rREirdMB2PusnrS8s6pRCochsLOpz2QnRL/FZjN1Z
	 NRHQ8URAAfWaLgAJ3Yrplk30QyGHmim3xUQBWWaMATzoEGBgMGlMmGIDaxPdWNPbUt
	 GEGDY1eh6Jx5f00TQKh8b8cf3pswctkUFSOHhrmAa5qUZdagddMg20xYjzrbsf1gUu
	 R6X4mDmSW0nfnFLOwPPZqnl+cjIfRBoWDEx/IKX/10fWcECLdSJ2f2VrudGmCjCKSx
	 CztEQHgDVNw6A==
Date: Mon, 11 Nov 2024 16:13:28 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, conor+dt@kernel.org,
	jbrunet@baylibre.com, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	khilman@baylibre.com, neil.armstrong@linaro.org,
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com,
	martin.blumenstingl@googlemail.com, clabbe@baylibre.com,
	vadim.fedorenko@linux.dev, krzysztof.kozlowski+dt@linaro.org,
	krzk+dt@kernel.org, linux-amlogic@lists.infradead.org,
	robh+dt@kernel.org
Subject: Re: [PATCH v10 17/22] dt-bindings: crypto: amlogic,gxl-crypto:
 support new SoC's
Message-ID: <173136320834.2047628.12512361262712701273.robh@kernel.org>
References: <20241108102907.1788584-1-avromanov@salutedevices.com>
 <20241108102907.1788584-18-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108102907.1788584-18-avromanov@salutedevices.com>


On Fri, 08 Nov 2024 13:29:02 +0300, Alexey Romanov wrote:
> Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.
> 
> 1. Add new compatibles:
>   - amlogic,g12a-crypto
>   - amlogic,axg-crypto
>   - amlogic,a1-crypto
>   - amlogic,s4-crypto (uses a1-crypto as fallback)
> 
> Difference between this compatibles:
>  * Different registers offset and the number of setup descriptors.
>  * GXL doesn't support hashing like the others.
>  * G12A/B and A1/S4 crypto HW don't support 192 AES key.
>  * GXL, G12A/B and AXG require a reverse IV key before processing.
> 
> 2. Add power-domains in schema, which is required only for A1.
> This is specific vendor design: in old SoC's power domain for
> crypto HW was not configurable, but in A1-series it is configurable.
> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   | 24 +++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

