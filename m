Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963628C87B;
	Wed, 28 May 2025 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748449811; cv=none; b=rsTVEku6fpNAG9vJA9/oQlMTsIT32xMBa81Q5H1BcvvAnnBBmR52mbXXfReP17FXzxc06/BRG/6VKFqyqz/R61eBd16+F8xoJ8D8Um+O5hOHe44T5BPF9JGgm1FC48XzS2j0pC7Ftoov+Hxpi2JYGpb2PwHlGg6IqOOt7xf4suM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748449811; c=relaxed/simple;
	bh=HHKUmYQYx+MVj6W9eglzPGornr6ttUWJyuK8q87x0h4=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=uonzh1QfDI7EVZgRFMUllVO6eyP8QPeURnHzBFIN2VTl0xq7KBvOmW1AYJzxd0ftC3HnSu/RlNQsGggPLn7oxFVQQb5EbRjJm+nM7izyxWcdLpbknn6OTOuXfBCWHvZmkCF9dZV6ynVXEDLSLeLeuh2jUFsTPsaxEgHmKZYyWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5BpTKer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5BpTKer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A22C4CEE3;
	Wed, 28 May 2025 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748449811;
	bh=HHKUmYQYx+MVj6W9eglzPGornr6ttUWJyuK8q87x0h4=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=Q5BpTKerQXKj/oCa+Z2coUymzeTVRHNlRuCXTGKbTkE1UCGTjPUPEkSsiCJQjO7X1
	 j0eD5Cu+JeVNhAMdhxpoK4BjKR73YE+7Ocohv5EcY7GgZcY9wsIZtBdq937UkCnQa3
	 zqrGjY2D6XV7W+ulRlTIKtR52wC6Ng/2PWKn/oRKEhxqKseXvxQP+B28pyTHhcwHC4
	 v/SVjLVS3+6xAJDIWcZ1PFfluUVEk9ed8HnpQkAcbvLGcJx+gk44awPymP38gqCAfe
	 6YauEPhQgUOwfw6mpTevElSL+Up083ZM++lpUUygg+iekjWQPQMmWrkW0azjayUyDP
	 LM6RoNXr3DXiA==
Date: Wed, 28 May 2025 11:30:09 -0500
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Gaurav Jain <gaurav.jain@nxp.com>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Thomas Richard <thomas.richard@bootlin.com>, devicetree@vger.kernel.org, 
 imx@lists.linux.dev, Frank Li <Frank.li@nxp.com>, 
 linux-arm-kernel@lists.infradead.org, Sascha Hauer <s.hauer@pengutronix.de>, 
 Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
 "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Shawn Guo <shawnguo@kernel.org>, 
 Fabio Estevam <festevam@gmail.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Herbert Xu <herbert@gondor.apana.org.au>
To: John Ernberg <john.ernberg@actia.se>
In-Reply-To: <20250528144259.2603914-4-john.ernberg@actia.se>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-4-john.ernberg@actia.se>
Message-Id: <174844980849.122008.12781867693102871804.robh@kernel.org>
Subject: Re: [PATCH v3 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP


On Wed, 28 May 2025 14:43:07 +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.
> 
> Allow specifying them for such SoCs.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> 
> ---
> 
> v3:
>  - Fix warnings discovered by Rob Herring's bot
>  - Declare the compatibles correctly (Krzysztof Kozlowski)
> 
> v2:
>  - Adjust commit message (Frank Li)
>  - Only allow power-domains when compatible with imx8qm (Frank Li)
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 45 ++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml:114:17: [warning] wrong indentation: expected 18 but found 16 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250528144259.2603914-4-john.ernberg@actia.se

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

