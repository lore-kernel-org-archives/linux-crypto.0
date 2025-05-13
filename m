Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A342C53365;
	Tue, 13 May 2025 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747167519; cv=none; b=gM90wMyefkJOVL28elwgNd7XRGvsyMom5WfBA+sZvHanzo0iwywyEwV8D8VZk5fojq1CUwSoSlyUPOZkkGdKrDlZP4Kbob07p0VTi16zKUkKVgTSNSbgQk0yzlOn5V2oziVE/lbpt83czDMCPCeapKiJh9qE/vom3hDZJJniXrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747167519; c=relaxed/simple;
	bh=W2HZtgcVRLwrzw8OFQsURV+IrvEQCSt78nnFRktnFhk=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=i/1Lje4HHKlF04B2gJtDu6Sc7lV/P7RGe3ZMnFrkD4Bzqg7/Gz5lcTziWbjowWoI9GlDD0qjRK9Tus90dUUsRPCFMvS/xfmtI2hXw3hLDPJaEGh2zWyyFSRXn1CUbNYwiS+P0xBFdW9K0pURqo+Dv+nz8FPvzlGPl9ZyNpf4XsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXmqi+2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXmqi+2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B1C4CEE4;
	Tue, 13 May 2025 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747167519;
	bh=W2HZtgcVRLwrzw8OFQsURV+IrvEQCSt78nnFRktnFhk=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=jXmqi+2Q+0jkFNWooWOIT7Aih7IvZ12wHyH+FWXvip1Op+q557DzK/663wdHxvU6I
	 QiF8P3z60WGIRIc5cMukVeZFC05t9GQQJJaRClnDSLy15kAjozrIMXWTDOVGC7eXUk
	 obbSCmiWATjZdUrmHiY3fU0E+M5yZ719CPM2aZtSdZwfACm81hZ/mPCRCm6qy00gt9
	 HAKUjSbJ1rY3MoA3s0hkXT4UdjwKj1HFVj7kITvKMKuAk8RikzbHkR5XyWtyChm3Wr
	 hlxKATJgx/2OY85QOx5yVS9X58QR/0aJEpMvRVed9iEDiQYqiFSrIyoO3keyq3vnpl
	 LQvVtYuZYy+sg==
Date: Tue, 13 May 2025 15:18:37 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Kevin Hilman <khilman@baylibre.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Tony Lindgren <tony@atomide.com>, 
 Aaro Koskinen <aaro.koskinen@iki.fi>, Conor Dooley <conor+dt@kernel.org>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
 Roger Quadros <rogerq@kernel.org>, Andreas Kemnade <andreas@kemnade.info>, 
 "David S. Miller" <davem@davemloft.net>
To: "Rob Herring (Arm)" <robh@kernel.org>
In-Reply-To: <20250513184142.3053112-1-robh@kernel.org>
References: <20250513184142.3053112-1-robh@kernel.org>
Message-Id: <174716751717.3427555.12286267219054671052.robh@kernel.org>
Subject: Re: [PATCH] dt-bindings: crypto: Convert ti,omap2-aes to DT schema


On Tue, 13 May 2025 13:41:41 -0500, Rob Herring (Arm) wrote:
> Convert the TI OMAP AES binding to DT schema format. It's a straight
> forward conversion.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../devicetree/bindings/crypto/omap-aes.txt   | 31 ----------
>  .../bindings/crypto/ti,omap4-aes.yaml         | 59 +++++++++++++++++++
>  2 files changed, 59 insertions(+), 31 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-aes.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/crypto/ti,omap4-aes.example.dtb: aes@53500000 (ti,omap4-aes): 'ti,hwmods' is a required property
	from schema $id: http://devicetree.org/schemas/ti,omap4-aes.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20250513184142.3053112-1-robh@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

