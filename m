Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD61925AE;
	Wed, 30 Oct 2024 22:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730327769; cv=none; b=RcF3VPgjRW8ezZOwOauHjSxmqOxBSjfl1fvjQBgziLe94o6EEUbQSbArtdq43V5OravK/7i3cNrYBvoV6Iu8hcxtpP4u1DYwFQEitClOzo6vN6ipCOqO+WvGX92waxLr7nZ0kX0W5H17QrjAWsMDks/91z7HOyvVLUhc6alYWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730327769; c=relaxed/simple;
	bh=0Vb3Wf3/HTZV8uH5OinSanLo9pfuoCfY/xWhB0k2A5k=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=fdH/F8JbO2xpM6lhxj087i/elT00Qu3nkHFGxousLZs7S/dk1rdECUTZW0mURQCcLsZ1/EJtx3XzM04NHdy/vteu6d4HPqBq8v+MoZtwtA4vSzlH8TM2fV/n+KhJeQuY3njHsrWPJRvNd74mG1ICJiOLAz7PNphkIico7OvMW8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pk9TE3W/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pk9TE3W/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B59FC4CECE;
	Wed, 30 Oct 2024 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730327768;
	bh=0Vb3Wf3/HTZV8uH5OinSanLo9pfuoCfY/xWhB0k2A5k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=pk9TE3W/NKsAAr3YQ7Mapx4mtrp1AEeKnH6azllMhmvFuh5y5RarBqRsg8LvRcVgP
	 wsAPwp2lNBHdo3vg6MB2t6aucPUvQ8iqTqm/fZ+u8m2TwGk/bgp3Grx1N1UMjR0Il2
	 C1hnvL79/HI3/99SrptK+KweB5XEEBL6dkAW4PKtPpKl+BbOsQOadUkEPO3nCG2SF2
	 BlMicmPB1YFXu50AglkOPVb26lEuTGKo1Fi5wApRcOndP61xiV5Lu9cBJ1vxpkiay2
	 SgP8eE8pULZpfMeX5rZLRXb3JrSnvPETacAkAzufepbJltUxb6ZoKTlxtZ2w3GMwZY
	 nRKk9Off1WFTw==
Date: Wed, 30 Oct 2024 17:36:06 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Markus Mayer <mmayer@broadcom.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>, 
 Conor Dooley <conor+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, 
 Olivia Mackall <olivia@selenic.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Device Tree Mailing List <devicetree@vger.kernel.org>, 
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Francesco Dolcini <francesco.dolcini@toradex.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20241030213400.802264-2-mmayer@broadcom.com>
References: <20241030213400.802264-1-mmayer@broadcom.com>
 <20241030213400.802264-2-mmayer@broadcom.com>
Message-Id: <173032776639.2368457.1775095489562466317.robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: rng: add binding for BCM74110 RNG


On Wed, 30 Oct 2024 14:33:54 -0700, Markus Mayer wrote:
> Add a binding for the random number generator used on the BCM74110.
> 
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> ---
>  .../bindings/rng/brcm,bcm74110.yaml           | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/rng/brcm,bcm74110.example.dtb: /example-0/rng@83ba000: failed to match any schema with compatible: ['brcm,bcm74110-trng']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20241030213400.802264-2-mmayer@broadcom.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

