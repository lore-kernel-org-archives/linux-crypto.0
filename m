Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5BF226869;
	Thu,  6 Feb 2025 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738837492; cv=none; b=mzyzYSAUEQMh0tYwjPTn9t7oxF0+nHbfv2lh2IFKGGdQZW+TM5uQP75dpySQnXwHrwNhSHcrleckHZJAxuQUxxEwlcq4HNyj/RCiV55BALant9D9nZsrwRXBKd9nEC96ICFZKxCo4JoU1JevohzRy+jeiKHT6woqJum3BDP5x0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738837492; c=relaxed/simple;
	bh=8NibMNg1KpbAk3gyqnaDTpTU/kJdok1+bj45BuBRHt4=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=J33u9SjfnnPm2r6XtmQTvXkrN+3Ml1Nydgj5RrF+LeulEyp4ygJl9P1BdtWbCpS5+yU9ZyxVUsoLjDKMaBjHu1jhK42W4iLzSNrZo7OUjYezBvFGmi8t+deiC7ciPLRVfRu4vmNcozadkVrMXXme8/HG8AOr6BYbp+iEbzMgWQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW4fVloV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW4fVloV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6924FC4CEDD;
	Thu,  6 Feb 2025 10:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738837491;
	bh=8NibMNg1KpbAk3gyqnaDTpTU/kJdok1+bj45BuBRHt4=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=lW4fVloVz9Io3J8oEN7v4cAKcg7dA4GPvPOKaTZAJwK5PjTxwESlWVLDPvcszxrDk
	 Rs8hatmSaIqc+Rztpi9gUHO0hgVBuQESqNpWC7l5xBNKg/ycmcsV2OnI2eOxm+eIrl
	 aadxYmUpzYn93Uljgk6s/jMnI7v6/P32GfVVicfFwQLcwZl+A1YP2SOSqyGNeo8Y12
	 Ne1J132begwnVpNk3ZgHbP66V28voQXTMoI5Ms8w60i8pk83nbIBpZMA/Lh658Ekhv
	 XJnI59/5yfStDblAYp/tG5czHQ9k9BNDnm/zH9TM9cK25GSOVaguqbykGq3Fh1GfPt
	 KbbKjdSxVD6MQ==
Date: Thu, 06 Feb 2025 04:24:50 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Kamlesh Gurudasani <kamlesh@ti.com>, Will Deacon <will@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Praneeth Bajjuri <praneeth@ti.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Vignesh Raghavendra <vigneshr@ti.com>, 
 Manorit Chawdhry <m-chawdhry@ti.com>, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org
To: T Pratham <t-pratham@ti.com>
In-Reply-To: <20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com>
References: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
 <20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com>
Message-Id: <173883749024.411608.17744779894418319775.robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] dt-bindings: crypto: Add binding for TI DTHE
 V2 driver


On Thu, 06 Feb 2025 14:44:30 +0530, T Pratham wrote:
> Add new DT binding for Texas Instruments DTHE V2 crypto driver.
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

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:22:22: [error] string value is redundantly quoted with any quotes (quoted-strings)
./Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:23:22: [error] string value is redundantly quoted with any quotes (quoted-strings)
./Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:24:22: [error] string value is redundantly quoted with any quotes (quoted-strings)
./Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:45:1: [error] syntax error: found character '\t' that cannot start any token (syntax)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml: ignoring, error parsing file
./Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:45:1: found character '\t' that cannot start any token
make[2]: *** Deleting file 'Documentation/devicetree/bindings/crypto/ti,dthev2.example.dts'
Documentation/devicetree/bindings/crypto/ti,dthev2.yaml:45:1: found character '\t' that cannot start any token
make[2]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/crypto/ti,dthev2.example.dts] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1511: dt_binding_check] Error 2
make: *** [Makefile:251: __sub-make] Error 2

doc reference errors (make refcheckdocs):
Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/crypto/ti,dthe-v2.yaml
MAINTAINERS: Documentation/devicetree/bindings/crypto/ti,dthe-v2.yaml

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

