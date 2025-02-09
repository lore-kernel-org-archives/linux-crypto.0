Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04B613D28F;
	Sun,  9 Feb 2025 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739104072; cv=none; b=A5bBQC9tBmxrp4F2Ca6sVGsWLMhVKq2p0wDmhN0slIIsFQH42ZxIsq/9vxu9t04iCJ7bQ2Yvql/tDmaOJyrGcyeHfT99c9zg1uKpRjKxRRXG26OJND1QxySQRAgN31tjjykgeSQYoiD3jrp4y5/YWn0CwW6cf78Vx2Bp5g0yLA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739104072; c=relaxed/simple;
	bh=BSXNirLH3zvz2GV0XOlsh3+a7jUDmmAsutL9GmheFYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgXq930noAs3xMIMuBGqTA5QC7eQFTybNdckPdShhniMnW6WyzHPD1Y0K68NePEK78qy+gW2BPqu8QISDiO2lfN3+J9xTJGaJkgKziDujB6i3YqQVAPoPvD9UergzPKP5BNflo2rmmSqoNNO4/f2lQB2PLPPOJJ0+cJtqb7EWs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmvmaZbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmvmaZbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93228C4CEE2;
	Sun,  9 Feb 2025 12:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739104072;
	bh=BSXNirLH3zvz2GV0XOlsh3+a7jUDmmAsutL9GmheFYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NmvmaZbKGIDIztWxHMvUpjMTRqPZK8Rj6b3Q/rMF2jsOQv0Sqg9brnJQlKuA8KUXb
	 4ZOlnI2mj4b8+3W67c8dWEL5W5u4rJ2J1C2ZQ1CeA8cF0t+rUuf9voc9T1MItrRKd2
	 e4Skd25IfhS9nnzUwPCaBfhqBSnnqSrfr2GT8Y+LREV7JvOQlLU+NN41NeRn63keP1
	 IvtS0BLQl6WTFuysOT82FbzCXJ7COBLNJDiV5Q42tnhJSWZMn6VI0I+xZ+F/eFFjHe
	 ViySV4XWVUQpAtu5eD863ujlD5MnB9cnds6SrgHbjfatCbMTYp6Oi86K/NBMfSnufO
	 4tonCTVZYSaAA==
Date: Sun, 9 Feb 2025 13:27:49 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Vignesh Raghavendra <vigneshr@ti.com>, 
	Praneeth Bajjuri <praneeth@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, 
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/3] dt-bindings: crypto: Add binding for TI DTHE V2
 driver
Message-ID: <20250209-sincere-honored-vole-dda3c7@krzk-bin>
References: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
 <20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com>

On Thu, Feb 06, 2025 at 02:44:30PM +0530, T Pratham wrote:
> Add new DT binding for Texas Instruments DTHE V2 crypto driver.

This was never tested so only limited review.

Subject and commit msg: Bindings are for hardware, not driver. Rephrase
to accurately describe the hardware.


> 
> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
> only found in it.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> PS: Please note that the dmas option in dt-bindings is subject to change in
> future as dma driver is not finalized yet. Any updated changes will be
> sent in the next version of the patch.
> 
>  .../devicetree/bindings/crypto/ti,dthev2.yaml      | 50 ++++++++++++++++++++++
>  MAINTAINERS                                        |  6 +++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
> new file mode 100644
> index 0000000000000000000000000000000000000000..9c871fe191ae0a3341d047d4565ec1e1bf1f21ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml

Filename matching compatible.

> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/ti,dthev2.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: K3 SoC DTHE V2 crypto module
> +
> +maintainers:
> +  - T Pratham <t-pratham@ti.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,dthe-v2

NAK, SoC-based compatible instead.


> +
> +  reg:
> +    maxItems: 1
> +
> +  dmas:
> +    items:
> +      - description: 'AES Engine RX DMA Channel'
> +      - description: 'AES Engine TX DMA Channel'
> +      - description: 'SHA Engine TX DMA Channel'
> +
> +  dma-names:
> +    items:
> +      - const: rx
> +      - const: tx1
> +      - const: tx2
> +
> +

Drop stray blank line

> +required:
> +  - compatible
> +  - reg
> +  - dmas
> +  - dma-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +

Drop stray blank line

> +    crypto: crypto@40800000 {

Drop label

> +		compatible = "ti,dthe-v2";
> +		reg = <0x00 0x40800000 0x00 0x10000>;
> +
> +		dmas = <&main_bcdma 0 0xc701 0>, <&main_bcdma 0 0x4700 0>, <&main_bcdma 0 0xc700 0>;

Wrap according to coding style.

Best regards,
Krzysztof

