Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC2329A301;
	Mon, 12 May 2025 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083297; cv=none; b=ixz5iBt8kolJ1BOgBKeW8Xt8TGfoxy7BWlpnh7Fe1Ncpa0Y63kHl0GIg79YaswngbTJKM5M21M04g2TlI/nsfIQRs+z0QcFbEC3UevJn9XIfH8q02Sdju2WL42vQZ2bPFeYBYZqqVlsu4npFe844gArtedWFM74CiNIb3zTyVo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083297; c=relaxed/simple;
	bh=WYopPnPUw1i5AsuO8nHMj+s662geBZfWCMLAQjzs1EA=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=NlPrllRXLT2ytvcWlbtRRyKExlEtRHAtD4fNSFNhVq5oTYHrFclZo/88aZfFnDTjh0kb1k6E7jLtbMNEV1lKvvKOkxJdy2TypjpMD8VRK+TQ/mUm+AZ82gSjxBoPXL80A434TQijEopuRuH6Fgc+dM5gNoxUkmuUjO9d9dhA8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZFs/K33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZFs/K33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98243C4CEFE;
	Mon, 12 May 2025 20:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747083296;
	bh=WYopPnPUw1i5AsuO8nHMj+s662geBZfWCMLAQjzs1EA=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=fZFs/K330IkmKc5AuLextmGbByhcgoV45YIH2XjLvi7tflgMS4VqbjL3oPHYmWooS
	 ahtt6gjhkj/JZHfKCwUeT2OsMmxu48eamKn1I1bIhPFbXFXpo/aEkvhx7c9YaqWSdq
	 4gODb+8UBzBXbwDq/5nqB/CjjOT1H+dCrZvcM5uvQZwbvGZ5i3U47kAoU5KE7W64Sa
	 RMB2Y5zoX5RPYxjJzATIG2FxdZkBHfbG9ERizdXozqndZjAR6aKSlSv+CD/0bC4XUa
	 f38sCqkjibSr7bJk43x6JJT9As7jzTylhFyYvB7KmYC7MXWilC4XoptSHfEuclNGJ0
	 7PYowlBSCS20A==
Date: Mon, 12 May 2025 15:54:54 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
 olivia@selenic.com, devicetree@vger.kernel.org, davem@davemloft.net, 
 herbert@gondor.apana.org.au, krzk+dt@kernel.org, 
 linux-kernel@vger.kernel.org, nicolas.ferre@microchip.com, 
 alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, 
 conor+dt@kernel.org
To: Ryan.Wanner@microchip.com
In-Reply-To: <a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
 <a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com>
Message-Id: <174708329324.4035802.9148165987582319414.robh@kernel.org>
Subject: Re: [PATCH 1/9] dt-bindings: crypto: add sama7d65 in Atmel AES


On Mon, 12 May 2025 12:27:27 -0700, Ryan.Wanner@microchip.com wrote:
> From: Ryan Wanner <Ryan.Wanner@microchip.com>
> 
> Add DT bindings for SAMA7D65 SoC in atmel AES.
> 
> Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml     | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml:19:13: [warning] wrong indentation: expected 14 but found 12 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/a5509576e211bcf528e088f78e619575a26bbd8f.1747077616.git.Ryan.Wanner@microchip.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

