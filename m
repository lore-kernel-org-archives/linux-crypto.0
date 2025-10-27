Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248698462;
	Mon, 27 Oct 2025 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761555404; cv=none; b=SSz43za3P0t7iAkvOoR96aHGXNLpI/F8B0F+Ex7s5aOMyyaYAj696m8VTG/YeWRHruHLXeeq3K+R50HLw/KCDiIgQ9g0QHY9RVMSLfbMRb5XsMmNrQb3daaBViSX17U9duSTLzgtemj/8MF2yGX9TOrTbUnrAx41izSyziAj2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761555404; c=relaxed/simple;
	bh=9b6W0QmRzkeUAu1Ghtwfl9cBm2zwM2JBNGAe03YlNio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndWRfx3UyBOmzQP6KyUZzEpSmC2QaZm8dGYSOjcFpMT2vbqCRYfcJ0WQmpzJvwSuebQsJToXWPZfuF00Nys7Hd0uUzcgLigseE22fu0KxDR6dNu21hcVWHg2ML6ISuHyz65XpCLAho7aamzRfKAT3z2DPaGqQW6R5BKIr2QYRDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bphR9Cho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bphR9Cho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D82C4CEF1;
	Mon, 27 Oct 2025 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761555403;
	bh=9b6W0QmRzkeUAu1Ghtwfl9cBm2zwM2JBNGAe03YlNio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bphR9Cho3h94IZ5FoT8jp0VL71d6r+Plg4vTODLijrEdWWLVUCNMoMhSEeedtsXWX
	 a0FKQWxuFdVj+jib2zqO/1glnI39HxMPXneyYb/HpQPAEJM0h7fa+16wsifkYBnlfR
	 zK07Yh8l0ULaxWVLEu7yqkss6WB0ViUYzGUaqvO6MF641WYRMS8lJAg3Vk6vdX713Y
	 +wYNKaQWGLAmhn1dBCmPvNyG7XiuoXND0q5oxmdOeQ1frxpa+XQCSBBvxZrvwu7Zxx
	 yqZnKL3TbZgVd5kks3Ze9ROP3KTG5WrYPAUx5dXXByNnMGjdwdVrJEDwb27E0vhn/t
	 VENwJqSON8LjA==
Date: Mon, 27 Oct 2025 09:56:41 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: amd,ccp-seattle-v1a: Allow 'iommus'
 property
Message-ID: <20251027-asp-of-great-art-e20ae9@kuoka>
References: <20251022230403.421699-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251022230403.421699-1-robh@kernel.org>

On Wed, Oct 22, 2025 at 06:04:03PM -0500, Rob Herring (Arm) wrote:
> The AMD Seattle CCP is behind an IOMMU and has 4 entries, so add
> the 'iommus' property.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml        | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

