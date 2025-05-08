Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A5221725;
	Thu,  8 May 2025 11:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746702678; cv=none; b=sSrdlkDBbDIAtgVoWJMMTIvaFMD5g2KJLAI1r1lHiHHrhGjTVHNsZEHuqWviibRM7Gnwr8NSDNCHalvUfPtktSykIwCbpkU/SCYl8SU/Zi6t/btgBgwcrofJEr9e4U6S6l3TNud7Gu7iemSvqCGjpfoFrlVn3M0ru4I+mbtiVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746702678; c=relaxed/simple;
	bh=L35sGjV2JrIlqaBbVZ6eGeAVbUamQLlJvTICiOeQnE4=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=hVRlJ0MBoEkDQQHMyWZU5/PuEmBE28G+KA/agYlP5M8PyPMBl+O88lLbRWsOUKrd1BRj2b5icWwFj9+wZYZef3OE7yHOHlEqcm2FEvYbneeRw4OR2/VR3xhtcQpCmW7492RZAzr0Sy6f+yMjsr72T83Aoq2/aKktI6ykhQmsBAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3kx4mg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3kx4mg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276ACC4CEEF;
	Thu,  8 May 2025 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746702676;
	bh=L35sGjV2JrIlqaBbVZ6eGeAVbUamQLlJvTICiOeQnE4=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=h3kx4mg9C2kCK86ER0JwCWUDEfF0t+gky3hig4tD+OVQXOutcj3Qy9DJdUiAKYre9
	 +7xcw73nNMJqqlOWVb8K0tEyk8B2ZnAfvd4UxWiHespaffWQDatwfaxsqmCPv5f3yR
	 cImIpETBBaotfX7NaMbT7n6I2NbbtDUqfP3uhIzCS8rGCmU2WreSNJ4VMep0iGUPTO
	 pv8cBXhsKOmhSPUwabeT6waPNx9ptljb6mDscwwL+9BK2OibySbFFIdD2LwDkv2wKR
	 rjOV14itw4lKb5xt9m6F3YZ22ocXuf5g/xZf/xNmNJfvdfsBEZqfVeDxjx8KneeGfd
	 UJgaLoWsWRKaA==
Date: Thu, 08 May 2025 06:11:14 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
 Praneeth Bajjuri <praneeth@ti.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Manorit Chawdhry <m-chawdhry@ti.com>, devicetree@vger.kernel.org, 
 Vignesh Raghavendra <vigneshr@ti.com>, Conor Dooley <conor+dt@kernel.org>, 
 Kamlesh Gurudasani <kamlesh@ti.com>, linux-crypto@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>
To: T Pratham <t-pratham@ti.com>
In-Reply-To: <20250508101723.846210-3-t-pratham@ti.com>
References: <20250508101723.846210-2-t-pratham@ti.com>
 <20250508101723.846210-3-t-pratham@ti.com>
Message-Id: <174670267292.3889463.9488828665934209667.robh@kernel.org>
Subject: Re: [PATCH v4 1/2] dt-bindings: crypto: Add binding for TI DTHE V2


On Thu, 08 May 2025 15:37:40 +0530, T Pratham wrote:
> Add DT binding for Texas Instruments DTHE V2 crypto accelerator.
> 
> DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
> only found in it.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  .../bindings/crypto/ti,am62l-dthev2.yaml      | 50 +++++++++++++++++++
>  MAINTAINERS                                   |  6 +++
>  2 files changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:


doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250508101723.846210-3-t-pratham@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

