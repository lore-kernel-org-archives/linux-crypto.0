Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665C73C01;
	Tue, 27 May 2025 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748338196; cv=none; b=uq/d3QJEaDgkx6dw/MTh3gGHDzjpFpvqGLsBLgectLbhF0bYlsmmSx6M3F7BSYR1pbtFN8+RfJORfeWl0bDebx6ymyD9TgMKQ5Vo2NIVSeBhBPdZR+C5pSp8ajoBPDIz3bWl5NZFXGCGwthGYxqZGqtWlj/Fph+iYxqoZ49VB2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748338196; c=relaxed/simple;
	bh=yx44wKhyWSIIz+gEiInWp3kNE5EdMe0ABsYt3dl6KlE=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=ENmcsxdHIk7TNBAW1Sc9MtW3wh26/L2W+NmP8AUYFIGR62dOFQd0R/JcZKiGVPodnaYjGOofjgKW5I7pmeSvPZ2wQUxGkv79zem2LM4CuWp7RsJcOZThZmEZpw1ryghheagqiL61yet8/HqDbHPC+BRCqwlrclRw+UltzzqR2KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VZMy6YLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZMy6YLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A10C4CEE9;
	Tue, 27 May 2025 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748338195;
	bh=yx44wKhyWSIIz+gEiInWp3kNE5EdMe0ABsYt3dl6KlE=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=VZMy6YLIzi0E+tQikW/k2S3coZ3itQpR7Mk9hxf6fnCc54gCAzsqhOtNJTvFe5vgM
	 xjfF2OO8kayX4YwTLScTKkK22fQ5iwCT6WFL8J+JophziiQltlMzyUjrzwRhiUCP/f
	 p1JIKY91iLQM9mCIjkhqRMMOV9t00vnyLx8qYoR5/RbZoWYQSYQIbjop79M4nTsomU
	 VJzUGOkR97aRojNaoV3l6mmkxQvRTnC5POowQxwOsSyj5n42D4dZbu4tzsSUYPtnSv
	 l+d8XYzaiCn6VNQQcm0xNiLMbIa7vcCRY/VDVtce7NSsHJ32cFMH/JJj8jpRxR5emG
	 3jN9vw6i843fA==
Date: Tue, 27 May 2025 04:29:53 -0500
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Sascha Hauer <s.hauer@pengutronix.de>, 
 Thomas Richard <thomas.richard@bootlin.com>, linux-crypto@vger.kernel.org, 
 Frank Li <Frank.li@nxp.com>, imx@lists.linux.dev, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 linux-arm-kernel@lists.infradead.org, Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org, 
 Gaurav Jain <gaurav.jain@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
 linux-kernel@vger.kernel.org, Pankaj Gupta <pankaj.gupta@nxp.com>
To: John Ernberg <john.ernberg@actia.se>
In-Reply-To: <20250527071552.1424997-4-john.ernberg@actia.se>
References: <20250527071552.1424997-1-john.ernberg@actia.se>
 <20250527071552.1424997-4-john.ernberg@actia.se>
Message-Id: <174833819381.3537254.5508047100817417003.robh@kernel.org>
Subject: Re: [PATCH v2 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP


On Tue, 27 May 2025 07:16:03 +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.
> 
> Allow specifying them for such SoCs.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> 
> ---
> 
> v2:
>  - Adjust commit message (Frank Li)
>  - Only allow power-domains when compatible with imx8qm (Frank Li)
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml: patternProperties:^jr@[0-9a-f]+$: 'if' is not one of ['type', 'description', 'dependencies', 'dependentRequired', 'dependentSchemas', 'properties', 'patternProperties', 'additionalProperties', 'unevaluatedProperties', 'deprecated', 'required', 'not', 'allOf', 'anyOf', 'oneOf', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/nodes.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml: patternProperties:^jr@[0-9a-f]+$: 'then' is not one of ['type', 'description', 'dependencies', 'dependentRequired', 'dependentSchemas', 'properties', 'patternProperties', 'additionalProperties', 'unevaluatedProperties', 'deprecated', 'required', 'not', 'allOf', 'anyOf', 'oneOf', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/nodes.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml: patternProperties:^jr@[0-9a-f]+$: 'else' is not one of ['type', 'description', 'dependencies', 'dependentRequired', 'dependentSchemas', 'properties', 'patternProperties', 'additionalProperties', 'unevaluatedProperties', 'deprecated', 'required', 'not', 'allOf', 'anyOf', 'oneOf', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/nodes.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250527071552.1424997-4-john.ernberg@actia.se

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

