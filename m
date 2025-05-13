Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2951E9B34;
	Tue, 13 May 2025 21:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747172047; cv=none; b=EOUBHEgX7kbaBOnuQ3fLDck69gRuSMfvZdERlXbaiZD6FoiJdhwijZC+wM5iuvmpAGZRZiJfQIBkMZjVYG6LLn1ypKTxVS3GVSoNzoOO/LmGdS07oIGbl7Sy3FKF+FiCGKqJYYOkyM+hTiinUy97juKdcbewKIu1jIwdQQsPVnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747172047; c=relaxed/simple;
	bh=+88zOYnvDFvxjqE/Y5p6i3D0kIHC3vjAVXfBRRI6uC4=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=Tr8uQHyUPFZbu5S/MA600cp2uPcLqBq1CmGVT/E1FlUyA18Eqc2jZEMOexETDqv02o5VY37WxnClc7aqyxwCVYJnHEW8rYHppI1BNUz0f99zQ6P+dMvstMR1eKUSreELCC2iz6W9ly5t+4cBj7uhC8SzSJ1hj0A1MH7e0jjnM8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZw4cAGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZw4cAGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A63C4CEE4;
	Tue, 13 May 2025 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747172047;
	bh=+88zOYnvDFvxjqE/Y5p6i3D0kIHC3vjAVXfBRRI6uC4=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=QZw4cAGrXnSwAKANm1o5Y3J0p5WweuPSkV8pVZxIJ56kIj32UTuTNkhFAlpCpCKXL
	 rI/78bnkIYHbTh+gjaRfdIRC1U0HvvV+S+ongG0s3tJ9ABVpRzr7JDYP+tGkYVAIbd
	 sWc4cKmIf8oiVyDjklHDAa5E2t0zgpFef2Z1xVaXQKik3ggcBNNHyrtmjBZ1qaPD11
	 vI1rrJM5aL/PGlAPft+t0KDtAVLsOI8Zi9RF8IRggf0I30e5ncbFwJbQpv6YTxuNTa
	 BOPn2i71dlKG2HoQiiUxwKJEbpeNf8o/gjIvG0hKpa/RJ3ALRxGaDrj3308rMPw/+7
	 XwYeEN+euzrEg==
Date: Tue, 13 May 2025 16:34:04 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Roger Quadros <rogerq@kernel.org>, 
 linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Tony Lindgren <tony@atomide.com>, Conor Dooley <conor+dt@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Kevin Hilman <khilman@baylibre.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
 Andreas Kemnade <andreas@kemnade.info>
To: "Rob Herring (Arm)" <robh@kernel.org>
In-Reply-To: <20250513184148.3053317-1-robh@kernel.org>
References: <20250513184148.3053317-1-robh@kernel.org>
Message-Id: <174717204490.3717333.9556861729299597344.robh@kernel.org>
Subject: Re: [PATCH] dt-bindings: crypto: Convert ti,omap4-des to DT schema


On Tue, 13 May 2025 13:41:47 -0500, Rob Herring (Arm) wrote:
> Convert the TI OMAP DES binding to DT schema format.
> 
> Drop "ti,hwmods" as it is not actually used for this binding. Only
> OMAP2 platforms are using it.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../devicetree/bindings/crypto/omap-des.txt   | 30 ---------
>  .../bindings/crypto/ti,omap4-des.yaml         | 66 +++++++++++++++++++
>  2 files changed, 66 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/ti,omap4-des.example.dtb: des@480a5000 (ti,omap4-des): 'ti,hwmods' is a required property
	from schema $id: http://devicetree.org/schemas/ti,omap4-des.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250513184148.3053317-1-robh@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

