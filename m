Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94884352038;
	Sat, 30 May 2026 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780174115; cv=none; b=KxwUeDXcTfssAwGIrukolswMFvXYv/RxNlxDcQn8rEtmSS98PsuP5sXH3gFWx8AawB5KNzFMmooqxXef6bFrSnlTSVzuWf0bmSn/k78qba0kA29R3cAA0M15X1+Jg4YV83UeX+IosFnJ2zHmNNrV8aRNXzIIkfEbsOegCbgyznY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780174115; c=relaxed/simple;
	bh=xqmU2qr6Mpk04tJ0yn2G0IrJQ4O6nidMwj1OTPu5sR4=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=Y85N7p8CO7MVe3YsQ6bSXUYMBcsIsbnRqbLzmJClGfppu7SQI9WJHVRZwannzwLvTuM/uBTHM8an6AaF69WcZHAZ9KzMi6omRnNk0h3Jrf8+QPb4JuGIzKwVy+dE36wB6f78qgxRFjzxvGKFCZfuwcRcmpcNeeWRoHQz3Gin7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2OtfUrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2OtfUrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87B51F00898;
	Sat, 30 May 2026 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780174113;
	bh=c9vLKWYG42FEGYkXWgIv3uwvb3u+dOyLKJzsNTX1l4A=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=a2OtfUrlXutm5ZE8Fug07AhMbKv2H+ooDEDCNjWQj7Os/kjhxrbeJYEaGpLvKB/6a
	 YQbWhJ2wtFjeCMCUlHRkDZlkL3tyD8t+JLq6uYtmCQ2EskyuV1AUAfyhUezTSM9V6/
	 bG+Ak7oIy0lfr0iB9SM/FKwUXVq2ctDEzne16pGErdYjLE1JME6NAbujLTXfCFImph
	 VEFXOzAkfxac+bgbbn8iO9uOfdMbl7XoL+Z0kP38eElQC5NNbc9nJSA2IbPrZ/V0mB
	 qtS3v266kMpKxXZAFPoCvGXKpE5BubD9bBY83omk70CmdaXpy67bChnc8yx0BL9wna
	 Qul5ncVjOlGZQ==
Date: Sat, 30 May 2026 15:48:31 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: devicetree@vger.kernel.org, clabbe@baylibre.com, 
 linux-rockchip@lists.infradead.org, heiko@sntech.de, 
 linux-arm-kernel@lists.infradead.org, krzk+dt@kernel.org, 
 conor+dt@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Dawid Olesinski <dawidro@gmail.com>
In-Reply-To: <20260530160704.3453555-2-dawidro@gmail.com>
References: <20260530160704.3453555-1-dawidro@gmail.com>
 <20260530160704.3453555-2-dawidro@gmail.com>
Message-Id: <178017410969.3710466.3951554039156108335.robh@kernel.org>
Subject: Re: [PATCH 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588
 crypto engine binding


On Sat, 30 May 2026 17:06:42 +0100, Dawid Olesinski wrote:
> Add a YAML device tree binding for the Rockchip second-generation (V2)
> cryptographic hardware accelerator present on the RK3568 and RK3588 SoCs.
> 
> The IP block exposes AES-ECB, AES-CBC, AES-XTS block ciphers, SHA-1,
> SHA-224, SHA-256, SHA-384, SHA-512, MD5, and SM3 hash algorithms, each
> with a hardware DMA engine controlled via linked-list descriptors.
> 
> The binding covers two compatible strings:
> 
>   - rockchip,rk3568-crypto: clocks and resets are driven directly by the
>     non-secure CRU (accessible to Linux at EL1).
>   - rockchip,rk3588-crypto: clocks and resets live in SECURECRU, a
>     register bank sandboxed to TrustZone. Linux must request them through
>     the ARM SCMI firmware interface (scmi_clk / scmi_reset), as direct
>     MMIO access to SECURECRU from EL1 triggers a bus fault.
> 
> Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
> ---
>  .../crypto/rockchip,rk3588-crypto.yaml        | 69 +++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Lexical error: Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.example.dts:30.33-49 Unexpected 'SCMI_CRYPTO_CORE'
Lexical error: Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.example.dts:31.33-52 Unexpected 'SCMI_ACLK_SECURE_NS'
Lexical error: Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.example.dts:32.33-52 Unexpected 'SCMI_HCLK_SECURE_NS'
Lexical error: Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.example.dts:34.35-56 Unexpected 'SCMI_SRST_CRYPTO_CORE'
FATAL ERROR: Syntax error parsing input tree
make[2]: *** [scripts/Makefile.dtbs:140: Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.example.dtb] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1660: dt_binding_check] Error 2
make: *** [Makefile:248: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260530160704.3453555-2-dawidro@gmail.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

