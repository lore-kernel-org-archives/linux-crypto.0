Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE27618660A;
	Wed, 16 Oct 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729100143; cv=none; b=SJLIcrIaToPeL6IG1yG9Ir2hPll4dHn2Yo4op+CYCHie/ZiBY4wNNNALnlqI0fcMQqXuwOX45PH5Vh9FP3woICODv+qt+zcLm/9YQ1XErwfXccnHVx6CJUBPwO32pYLuff5VUs/MEaQqlZ9pXoma9uizVNKAbLP4YZZwXa0ftBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729100143; c=relaxed/simple;
	bh=ROiqOKc+y+FMS/tbuJk2v1Iu+PyGJTcxIghGmgkwt3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rfUJW7m5fAd4ulK7c2P6xCeaqCVi4roMEr4/KZA5eldXLqepUiRheefg7+JjU+lpqN+l4QXYkTwmb7zW0WLBumhyV+6DHs+EKjA3qxZ7AwubM0FX+qsge2wjeZrjmeaV35miapA2l3weMC6J1PYRA+wUXP6shWkIn+1+96OjuSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5LUU7qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5LUU7qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA1BC4CEC5;
	Wed, 16 Oct 2024 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729100143;
	bh=ROiqOKc+y+FMS/tbuJk2v1Iu+PyGJTcxIghGmgkwt3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5LUU7qEFpvKqi3O2xhYVd43GB0ADaT7hxeehOdOcOcEi4Fog3Px8Mx6PMmURQQo3
	 jVdfeS1Ux65MfJNnd0/7OaIu/lAmBR+wsE6/Ibhjuwxp2uLnVSsKMlmMKwpKMDeKfy
	 aatMYhD45+l9c/az4Bbc9R4N5i4u1I7c5G8/BDlfTNmAs12NXTbqiZxnIbNVhqoGZi
	 Z0US7eucQo6p+GFkDjl+0U6FcADFLyxc7zLaNb4uDfMJQ+FgsBVkr+mji58P50W8w2
	 bG+v5wBwVd3caDLvUDbaSRctTGVhMbJmPgu0N7CBibfOmZxg8rGwn/j1o8Y0zL/yay
	 h5xL438CW5JMw==
Date: Wed, 16 Oct 2024 12:35:42 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: upstream@airoha.com, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, Conor Dooley <conor+dt@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lorenzo Bianconi <lorenzo@kernel.org>, linux-kernel@vger.kernel.org,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 1/2] dt-bindings: rng: add support for Airoha EN7581 TRNG
Message-ID: <172910014160.2079862.17744202694058478290.robh@kernel.org>
References: <20241016151845.23712-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016151845.23712-1-ansuelsmth@gmail.com>


On Wed, 16 Oct 2024 17:18:41 +0200, Christian Marangi wrote:
> Add support for Airoha EN7581 True Random Number generator.
> 
> This module can generate up to 4bytes of raw data at times and support
> self health test at startup. The module gets noise for randomness from
> various source from ADC, AP, dedicated clocks and other devices attached
> to the SoC producing true random numbers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../bindings/rng/airoha,en7581-trng.yaml      | 38 +++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

