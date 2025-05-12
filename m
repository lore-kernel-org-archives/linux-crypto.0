Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B60C29AAE5;
	Mon, 12 May 2025 20:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083301; cv=none; b=Yw/azJazzp8oTdoLd/4mTh7P3zRoSMcy2BVIP6P+YERd/5YVNyTXIWTkxZsqHonMBw03K87FI++GghXqd2T/EG6dB2S6rQQTYtvM1uDjXPiqR4U8VEKY8wKPj4xZ8Y4abTynwfE7GB+VcB0hA0hvveJPdhC5tXi17084umOFT0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083301; c=relaxed/simple;
	bh=1Wb+WsqVMEuJbQLKe8Gt2DrmhyU52bmcmcDDaS0ZKGM=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=STTvfd5MzFS9vZLc2McOMiVUSpCkrul6IlKMxFhElMWV1ad8HFU+vKcIiDc7JTY/ZRCRWRpE1gW5HDWnNP5DOYnM5170W8mmwk3slWTD1s46n99sXLRCjmGxQR//LPc5lQ5OnhDPiGC+VbQqKAf/3P6vyS3fKJZ4Jte5F8hyWKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j91pA5Yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j91pA5Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59535C4CEF2;
	Mon, 12 May 2025 20:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747083300;
	bh=1Wb+WsqVMEuJbQLKe8Gt2DrmhyU52bmcmcDDaS0ZKGM=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=j91pA5YqJOECZEmryiT5l3eX4hV0AuxbWjsTsrMlWWDn5zyzR47CwRWqoZHtT9dBr
	 /UjK3+vR48nO1OS29TJe+i2IYrwZhC81RB5ufv4bhlhUF1R93NsqNjrh9PUW5P/kYy
	 kaox+g6mX6dw+D0WwjUvR1YqGpBjAvKASKjPen4oybX/MZW/rVm+BXrKvw4Aj/2ZHd
	 8FQv3oElcivsirQYuC1D7c+aBdrBPohHH6VRTGDedaxDP6FjOqiteP0Q9V4rvb/L1O
	 YoXYXggIrTTPcpxJIVg33jvU0p9EZVHemdjOFl4YuZ4bKc5RLH7SctCIKuTSJZLlPN
	 Rnxip5KxZHOsw==
Date: Mon, 12 May 2025 15:54:59 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, 
 alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com, 
 olivia@selenic.com, devicetree@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 conor+dt@kernel.org, claudiu.beznea@tuxon.dev, krzk+dt@kernel.org, 
 herbert@gondor.apana.org.au
To: Ryan.Wanner@microchip.com
In-Reply-To: <ea33a6222dda7c60fd404a4b0e9c4824e19ee1bf.1747077616.git.Ryan.Wanner@microchip.com>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <ea33a6222dda7c60fd404a4b0e9c4824e19ee1bf.1747077616.git.Ryan.Wanner@microchip.com>
Message-Id: <174708329457.4035885.12979027152382055790.robh@kernel.org>
Subject: Re: [PATCH 3/9] dt-bindings: crypto: add sama7d65 in Atmel TDES


On Mon, 12 May 2025 12:27:29 -0700, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC Atmel TDES.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml    | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml:19:13: [warning] wrong indentation: expected 14 but found 12 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/ea33a6222dda7c60fd404a4b0e9c4824e19ee1bf.1747077616.git.Ryan.Wanner@microchip.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

