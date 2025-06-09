Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF40610D;
	Mon,  9 Jun 2025 06:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749451055; cv=none; b=d1O8aeLu+05XciiGE7cuoQX/U1SnzEd90WCyUJPMjSkXywpB/62OfxWsnHZ7nZKu1iWgwX1rdBqwZ5kNe96JYlPpNHks5WijBduuYUrpju0x/bVw600Izjl+qcHfvi1JYCCd5LV4TFhDxm0qHKUR3XINgEDNTRITLRU+ucIWUzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749451055; c=relaxed/simple;
	bh=PzPxuWTz0u4ZdESLKo1cP6MTOvIeW+qr8Pz1HoSaTws=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=mpNE+CNnp0B+xb1WPD0IW/E3L+J637WYlESgb8MCwYqv4/ulZdVg68PN52DpwN14AC704wRk2Bdadf955bz0YDBgq2BKFMFLch5vVn2hCBb33cL99eTyDtjUtCB4OFAOrZLyoWlh3F7D6elQhEyQNDejlz0zwtuU4xCHgdSgVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8ZNxTSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8ZNxTSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4CFC4CEEB;
	Mon,  9 Jun 2025 06:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749451055;
	bh=PzPxuWTz0u4ZdESLKo1cP6MTOvIeW+qr8Pz1HoSaTws=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=V8ZNxTSLqo34AjPTIBPoxYV+v+Dt0J3rX2PsFN+vffXNhBZeLS6SeBFpuV0525ngC
	 s1uta5iUMsIDfEX5ms5m/EcdQNy432shhW1Pd+bLCZ9EtfR6JmCM7QW7Uz3+rUOIP1
	 INXL/A+LDsSonJPr9zizKZ6ir7sGweiqoMurTdqzuAqvHophaExI37FMvyOWOsJ18S
	 Lp0mk4urYcaO0x3HJT9xgpoZuH3rSzHhwv8rHKq2cLF59Ql7jFai/Ktf10EiaVAeOO
	 f+4rSLZ4XXuSVgwdGHG7jO2Qg5aNE6sGbKuCI5GaVI6Oz9iFBlOPwQ4eYHy4wV8IY+
	 uS3Td6CybmxQQ==
Date: Mon, 09 Jun 2025 01:37:34 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: mohan.dhanawade@amd.com, devicetree@vger.kernel.org, 
 davem@davemloft.net, herbert@gondor.apana.org.au, michal.simek@amd.com, 
 mounika.botcha@amd.com, sarat.chand.savitala@amd.com, 
 linux-crypto@vger.kernel.org
To: Harsh Jain <h.jain@amd.com>
In-Reply-To: <20250609045110.1786634-2-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
 <20250609045110.1786634-2-h.jain@amd.com>
Message-Id: <174945105401.1083809.6139700384718518785.robh@kernel.org>
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random
 Number Generator


On Mon, 09 Jun 2025 10:21:05 +0530, Harsh Jain wrote:
> From: Mounika Botcha <mounika.botcha@amd.com>
> 
> Add TRNG node compatible string and reg properities.
> 
> Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml: $id: Cannot determine base path from $id, relative path/filename doesn't match actual path or filename
 	 $id: http://devicetree.org/schemas/crypto/xlnx,versal-rng.yaml
 	file: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250609045110.1786634-2-h.jain@amd.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

