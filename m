Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066D01C84A2;
	Thu,  5 Jun 2025 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133747; cv=none; b=MGE9RlnQ2VJgarO28fNIf7XdhNzWRREnNoLlrJfnZE9qfbx8pL9psujRIRCeK+JFhUBLxDNqatw+O+PbIEaS9hnRlujXPDnMsAndfPrNII7KF1ul8Pi4qtNZrO0dyqJe828utL6SJ5wH2skNB2kVUOnAXnHfjkjfSD6B9ICK5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133747; c=relaxed/simple;
	bh=SAK1eCG6q30aTdJmw9lTFOqLAVILbrbvQ+z1shYGO1I=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=bmu9FuKTuPakRWOog/nDHvOvcVXvSrRBg/TfWUAsKj3F5h0qQAe5hEXA5c78ld9IaxMxBn9d8K1xf9GIUMIYtYHv94/ObujtMTI4qXpZQb2FEvrqwLtNGDczjUTqRUeYLmMYUyRMoSfEn6Zo5ctks6SW7nqzzZgrqO9Ab3RxDI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZe/8R3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZe/8R3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A88C4CEE7;
	Thu,  5 Jun 2025 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749133746;
	bh=SAK1eCG6q30aTdJmw9lTFOqLAVILbrbvQ+z1shYGO1I=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=nZe/8R3AcLEvnjMDtpcPxvHPl9htAqqxUfWnCfPeVtEALXURX+X1eClc/1kxSL/t3
	 NRjS70aAIVd1HT7OY8CQpCz7SUdsExAatXnNB7ZMw3AEljwwKzLP2WpTbFaOy/hxQ1
	 BzDi2pF+eiO8CV47eTDm5heAYVVTjA4+Eqrrrvffyfwgd5daxBP9lzUVEmbFDt1kKZ
	 6z2MlnTwVMPQUt7up3R2VKF8ru8O1rJZ7S1+l258aXwYlPkhSQioz/WAhYplUay7wC
	 m5ZXUn7HgxyqAP6DtwIuXblxH3uKBGPV8B2bUBcov9tqrHDOt6sZRpULu/60SYe8Gp
	 l2cKYrev88IWw==
Date: Thu, 05 Jun 2025 09:29:04 -0500
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>, Frank Li <Frank.li@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, imx@lists.linux.dev, 
 Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org, 
 Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Conor Dooley <conor+dt@kernel.org>, 
 Gaurav Jain <gaurav.jain@nxp.com>, "David S . Miller" <davem@davemloft.net>, 
 Sascha Hauer <s.hauer@pengutronix.de>, linux-crypto@vger.kernel.org
To: John Ernberg <john.ernberg@actia.se>
In-Reply-To: <20250605132754.1771368-4-john.ernberg@actia.se>
References: <20250605132754.1771368-1-john.ernberg@actia.se>
 <20250605132754.1771368-4-john.ernberg@actia.se>
Message-Id: <174913374447.2520926.5612887459467477896.robh@kernel.org>
Subject: Re: [PATCH v4 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP


On Thu, 05 Jun 2025 13:28:02 +0000, John Ernberg wrote:
> NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> resource management.
> 
> Add compatible strings for these SoCs (QXP and DXP gets to share as their
> only difference is a core-count, Q=Quad core and D=Dual core), and allow
> power-domains for them only. Keep the old restriction for others.
> 
> Signed-off-by: John Ernberg <john.ernberg@actia.se>
> 
> ---
> 
> v4:
>  - Reword commit message (Frank Li)
>  - Add explicit imx8qxp compatible (Frank Li)
>  - Move the job-ring constraints back to the job-ring section under an
>    'allOf:' to avoid the warning from v2 (Rob Herring)
> 
> v3:
>  - Fix warnings discovered by Rob Herring's bot
>  - Declare the compatibles correctly (Krzysztof Kozlowski)
> 
> v2:
>  - Adjust commit message (Frank Li)
>  - Only allow power-domains when compatible with imx8qm (Frank Li)
> ---
>  .../bindings/crypto/fsl,sec-v4.0.yaml         | 41 ++++++++++++++++++-
>  1 file changed, 40 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml:115:17: [warning] wrong indentation: expected 18 but found 16 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250605132754.1771368-4-john.ernberg@actia.se

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

