Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2AB278E51;
	Fri, 11 Apr 2025 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744367021; cv=none; b=fyLSdbLmy5uRm2rLpdp48FFIrYKk2VuS159l3ENAEQzD08E1R29szLUvVFVbu0eANRPwLrg206SS+6f5Lx0os3ssVH1MDdwlLqlqXp/K5JiesLZJgNii9cylby/5UDUU98E7Eg98oPg8RhAnhykNR2dBTSBQ2FfwAIBdtItiXAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744367021; c=relaxed/simple;
	bh=nNnGjXRPBz3YI4SaNY8a/CQRpAOQ1B60ZYfwjDXFrKY=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=RKv+parpZBw1Bhk5xE5YOM4v3O0v849QwELWSOZFXIlL5xNYrR/GdbmGigKr7+Ju+HuFYWIvc3Lynql/ivxy0ssVveW+UelQ7mRJ/aZiyjroUDCquEFkrgEL3lIFWOUK3O597Xx8/cIZ+nQ8v037Hmj07LR0J8MotC0ePDpuweI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XyuP/H1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XyuP/H1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952FCC4CEE2;
	Fri, 11 Apr 2025 10:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744367020;
	bh=nNnGjXRPBz3YI4SaNY8a/CQRpAOQ1B60ZYfwjDXFrKY=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=XyuP/H1Gp/7DQAflyk4VGPWDyysyouA9qc5HJ51r/8AM0Ud98Zw7XFi2ejPohS2p0
	 XFq8/ZPqkkFYVDOcu9AaPo2S14PcsIxBNOFBCpAwzdv/Aw6l2x/vKKV/kunnvB0WzF
	 QF8Ra6n2R/bWcrT3KGlYnepg7gwXdW0GpwI02xd+BlqlbXme63NtKjEm8+2agVaAEe
	 8yzy03kLjfA1b15SaWQdyZUPrCR9oKww497PdDKZT2QicsjRMGn2rE6btPbj0sUkJG
	 mGxW/DK3JYu2FDz1MLFU2IfpGyAFRRROIg+hZGLQfU9ldKQT7vsz8gv0XFIEnpiZvm
	 fLNZnHX/OIkMg==
Date: Fri, 11 Apr 2025 05:23:39 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 Praneeth Bajjuri <praneeth@ti.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Vignesh Raghavendra <vigneshr@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, Conor Dooley <conor+dt@kernel.org>, 
 Manorit Chawdhry <m-chawdhry@ti.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org, 
 Kamlesh Gurudasani <kamlesh@ti.com>
To: T Pratham <t-pratham@ti.com>
In-Reply-To: <20250411091321.2925308-2-t-pratham@ti.com>
References: <20250411091321.2925308-1-t-pratham@ti.com>
 <20250411091321.2925308-2-t-pratham@ti.com>
Message-Id: <174436701744.2577578.5675041796960889580.robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: Add binding for TI DTHE V2


On Fri, 11 Apr 2025 14:43:21 +0530, T Pratham wrote:
> Add DT binding for Texas Instruments DTHE V2 crypto accelerator.
> 
> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
> only found in it.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,dthev2.yaml | 50 +++++++++++++++++++
>  MAINTAINERS                                   |  6 +++
>  2 files changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/ti,dthev2.example.dtb: crypto@40800000 (ti,am62l-dthev2): reg: [[0, 1082130432], [0, 65536]] is too long
	from schema $id: http://devicetree.org/schemas/crypto/ti,dthev2.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250411091321.2925308-2-t-pratham@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

