Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E958728C5A3;
	Tue, 17 Jun 2025 07:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750144307; cv=none; b=RRWPCPsVe4F63fyVUYMmT5yVtaDJOsU22soo7ErDrZlVWCaxcSRSiG5m5bqs1DX8evdj/w+YygFtR1pn3t+JV0YAJB5KdUfV+1OAOCMaHffPk+mtlsy/04Lbzv4Gt2kZHtT+B4jWhdXRmwgA66wzG/vZx9x+gKggW5MCiAm+/qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750144307; c=relaxed/simple;
	bh=16SBmkOZkrr53DEdJsjOJUewxQnLL0IKyT3zlCUJ458=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYMerXLs7Jk1EImzSBL92N20m6wGYxp2fqWVCo67ypY8OQJ/LzkXDpZ21B7DEgR0KG3nrs2/Ul8pLBT4ErPZDQqS/D6TF5VU5xNCgznN0JLLxHnq3H8dt3C3jlZt4yTLs4t9/6+GPcYZ3jzwA5OhEBhtF+BU6FmH3PTprHQ+txk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RK5W/QbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RK5W/QbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6AFC4CEE3;
	Tue, 17 Jun 2025 07:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750144306;
	bh=16SBmkOZkrr53DEdJsjOJUewxQnLL0IKyT3zlCUJ458=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RK5W/QbZ6h4lSx6maUIN0qwCon6YggAY0V4zSn8QeqIH4WpR7YFyDGgX8FeqW9rxU
	 N9yfhFy1s1X1iOMnBIBueTF051Tii8RSRhDfAO6ITR0npo9MIDF2apqqCQz4y6GlYV
	 kdVUEfTCo+OKyPCacPLwXBpeic/lNVrEd8FUTjaLRMHkng7LLmuZyG0YNEoqRc4ufb
	 jnE+ROiM64f8bdsNq+QAqU1qsaXdur8CRmzUevekayh/xBWWUuAPzrDCo8dO4qRgul
	 NJO3mgqGvXXyEpOI65E8dDkcCadIBH/UsUAC1wKJ2Ra366GJjwr0bWE+w4ey1pCOIv
	 079bm3aM7soJQ==
Date: Tue, 17 Jun 2025 09:11:43 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harsh Jain <h.jain@amd.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, mounika.botcha@amd.com, 
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com, michal.simek@amd.com
Subject: Re: [PATCH v3 1/3] dt-bindings: crypto: Add node for True Random
 Number Generator
Message-ID: <20250617-rational-benign-woodpecker-6ee31a@kuoka>
References: <20250612052542.2591773-1-h.jain@amd.com>
 <20250612052542.2591773-2-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612052542.2591773-2-h.jain@amd.com>

On Thu, Jun 12, 2025 at 10:55:40AM GMT, Harsh Jain wrote:
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

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

