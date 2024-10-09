Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DE1E22F5;
	Wed,  9 Oct 2024 21:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728508317; cv=none; b=eHPKppTh4OiTZUaAkm74G9mzdm4QljRXr/kIMUIimFUaucvNM9HlU4D3Q+giQkIgvpiEjxlUbdmI5XM0mx2L5Kv7v3LdXBPpfBrCBrf0Hj0KLudbSADQSKw/NoWL8EpBKTEKRjQS68scM+8HUNayHqNjuqJMcY/kikZCVdJ46Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728508317; c=relaxed/simple;
	bh=SSEHLLE9E7vCAzBWkV5vZ6fQtopJqQEGP1MH9fioIJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpwuIaqULjirR1sxeXAT75bgRRopdEy1lTjllqidPtvyzA2UYxiImnt+NVCKM43FlsJ5iva9q/uOtsAOr6nJd4/WG2T/6OPEsZl3DCJyFqYuO/JE5j5wifSK/zFU4GBY8y0jmMA6eKrHy26++bx1w2NxfzIV/MLTrWBBeF69NRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqEfWuoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqEfWuoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48074C4CECF;
	Wed,  9 Oct 2024 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728508316;
	bh=SSEHLLE9E7vCAzBWkV5vZ6fQtopJqQEGP1MH9fioIJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QqEfWuoSbjpD7q/yfTNvMzFWbN7EgjwvBzidkvuR6WELzolAiEBPs0nZpdf3cQWbW
	 NE35cdHPa3g7z9OS0929vwYCJRX01TCN1qB8umPozVVq8HYYqy25USqcLhKB1BBFlH
	 dxJkozOhcd77iFgxjzVcXOaZTcMA9F5OpFjbIFjR6OPSRHX7v/Ej1c4y0b4NC91kIC
	 3TnJRtL0b1gBtWoYKkHpeK7Cx02hGHsvegVQYyQMVErTdRYArKRzfYqFFCXXyJq+3X
	 Cz014B7os5WuCtVTWojRYoV+c27Sq9VCmC98h/fWAofz6KKGzca4ztL7ZMgcATadtY
	 boWcoV5VjxVZQ==
Date: Wed, 9 Oct 2024 16:11:55 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Fabio Estevam <festevam@denx.de>, olivia@selenic.com,
	krzk+dt@kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: imx-rng: Allow passing only "fsl,imx31-rnga"
Message-ID: <172850831492.720293.5604676857893121245.robh@kernel.org>
References: <20241009125144.560941-1-festevam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009125144.560941-1-festevam@gmail.com>


On Wed, 09 Oct 2024 09:51:44 -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> On imx31.dtsi the rng compatible string contains "fsl,imx31-rnga" only.
> 
> Adjust the binding to accept passing "fsl,imx31-rnga" only.
> 
> This fixes the following dt-schema warning:
> 
> imx31-lite.dtb: rng@53fb0000: compatible: 'oneOf' conditional failed, one must be fixed:
> 	['fsl,imx31-rnga'] is too short
> 	'fsl,imx21-rnga' was expected
> 	'fsl,imx25-rngb' was expected
> 	'fsl,imx31-rnga' is not one of ['fsl,imx6sl-rngb', 'fsl,imx6sll-rngb', 'fsl,imx6ull-rngb']
> 	'fsl,imx35-rngc' was expected
> 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
>  Documentation/devicetree/bindings/rng/imx-rng.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

