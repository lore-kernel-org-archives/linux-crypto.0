Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED391BC9ED;
	Mon, 11 Nov 2024 22:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731363105; cv=none; b=YwmQ4ZP8St3B727lD2+LIhszgwGDEGbaxtGrFwm2B/oAnYqRCkswNtSW/sQLC+iUGvO2WmGhY6gSpkamEIHHA4Kj1lDwUbMImcJnMjq7dwOlh/TAqp7h5NzikZAajFiHA3kTxjs+kEZXglA4LHp64WbiB3XDal0eMEzL4A0e0XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731363105; c=relaxed/simple;
	bh=VIlzaR283Tdog9da7uW65IBczFdM3meS/Gu8+t/7E2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/ZXZCm9p3xNn2yShWMZqfisJRw8p7CXlEJMM1UIUueTZSRf5TuHOjiSjl3nnQ+BWpEwZma8CZiQMniSlUaVEScPnvrpAVS1lPIuJMdBeQHYPspbHgxGRm6bNJuspNzlIaxI5ZH2TjjzZ0+tX6X5psBLMmwHWkfT5p+HALeN/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwIbMchG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwIbMchG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1683C4CECF;
	Mon, 11 Nov 2024 22:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731363105;
	bh=VIlzaR283Tdog9da7uW65IBczFdM3meS/Gu8+t/7E2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwIbMchG3v9mStMdJDE99fEU5q8y8nhv75vwcihmLLyzshiIPNhqxd0bI6mYRlrpN
	 c4I1F3n6Is3dqtj7oNyed9AGnflAapIpjYsZrX4aBAA3bjiPtuNv2/RC0u5EoQnCRg
	 X8hiV0lwXec/p6zA4fCRuFR+KctBMlSWIS05Ow/Mlv+QfuxgvThA56gFOXLSac1lsw
	 5KQRUhVob08a6ZDvYnFUubnwvsvlCKXOOLsrzXfDEyFEoJNlL7R9CCX1X/q0JGCm/W
	 ogrA0wH04pTxUI0cg2tWDHS3QKWVsw+RVaOsrc+jkXsgOi+gqIU9WH0MI6ny26Jvpf
	 hohZcIVOXlfxQ==
Date: Mon, 11 Nov 2024 16:11:42 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: krzk+dt@kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	martin.blumenstingl@googlemail.com, kernel@salutedevices.com,
	linux-crypto@vger.kernel.org, robh+dt@kernel.org,
	linux-kernel@vger.kernel.org, jbrunet@baylibre.com,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	khilman@baylibre.com, vadim.fedorenko@linux.dev,
	linux-amlogic@lists.infradead.org, clabbe@baylibre.com,
	neil.armstrong@linaro.org
Subject: Re: [PATCH v10 16/22] dt-bindings: crypto: amlogic,gxl-crypto:
 correct clk and interrupt lines
Message-ID: <173136310214.2045472.18188907864270197058.robh@kernel.org>
References: <20241108102907.1788584-1-avromanov@salutedevices.com>
 <20241108102907.1788584-17-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108102907.1788584-17-avromanov@salutedevices.com>


On Fri, 08 Nov 2024 13:29:01 +0300, Alexey Romanov wrote:
> GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
> Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
> engine is hard-wired to a clk81 (CLKID_CLK81). Drop clock-names
> field from schema: name "blkmv" is invalid and "clk81" is confusing
> and sounds like something global.
> 
> Also, GXL crypto IP isn't connected to the second interrupt line.
> This binding is useless, there are no users of this line.
> We must remove it from dt-bindings.
> 
> Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto")
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>  .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

