Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F9A28ECE5;
	Tue, 17 Jun 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750150670; cv=none; b=FsZtp59ksyzr58+Nn2oVUBUVfoH/Df78t3XYD8eVjy0SApBWeHsFZxYMLqSRSf6VFSF9U312/1bsEfLCmPW93+O/eRFdigSuhw3orVrkiso/uakmLGmw9CZmJCROAjp1JdrgOTP/3B1C5vBAml2oluYQPfb3l+ktrvLBMRVIx/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750150670; c=relaxed/simple;
	bh=OndFjdGQSMdHXbp6oKdW4CTqpiHNZf4ADOwowIeeuDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JEji+aPZQ8Si7e7OoXL1FsRp6LCooK6Gn3auCYuPakn+49+MUtONlEe4CKJ4AMyqZ47/kmjfDLVjRrA2G5f5do85nkHdEOCDIp36BNYl7BomPR1VSbgtFTIXrD1ts7DtuygISxQ+eNcY6wC9Qd8mNfszwhA7O1BO7Sg/mQzrZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSWyRb3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSWyRb3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDFEC4CEE3;
	Tue, 17 Jun 2025 08:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750150670;
	bh=OndFjdGQSMdHXbp6oKdW4CTqpiHNZf4ADOwowIeeuDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kSWyRb3P8yFR8O8ky88vyZz48+xQw0ZvrBVFy5DsUStvDVK2G8o6uxl7dGCJvlCas
	 Iog8PC7rkJ9lCVwHpZS0O6MHgPayGRLVzmhsgkM5d9IJC33GS3a80tbkbShIfsXG09
	 pElI0a3KvBwgLfN4NmmU8dTMM9c98Ehpz9FIyJjcjsT2w7nemI92htcY6cEWSl2UtB
	 x6M7cc1aCiq5jDm3lDNvDv/qzORWwRp6jH0um91cxaY9UvZolN41/tHxGTbsjA+oGl
	 de1LKmx/GW/uOCFrKZhIw5bv7qdyyN4FR/bn9Vd8Q8IXpDlDbEfcLNIF+lbUsw8Hqa
	 iWOnScA14ikww==
Date: Tue, 17 Jun 2025 10:57:47 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: Convert ti,omap4-des to DT schema
Message-ID: <20250617-perfect-panda-of-champagne-ef2f55@kuoka>
References: <20250611231058.1402457-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250611231058.1402457-1-robh@kernel.org>

On Wed, Jun 11, 2025 at 06:10:56PM GMT, Rob Herring (Arm) wrote:
> Convert the TI OMAP DES binding to DT schema format.
> 
> Drop "ti,hwmods" as it is not actually used for this binding. Only
> OMAP2 platforms are using it.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v2:
>  - Drop ti,hwmods from required too
> ---
>  .../devicetree/bindings/crypto/omap-des.txt   | 30 ---------
>  .../bindings/crypto/ti,omap4-des.yaml         | 65 +++++++++++++++++++
>  2 files changed, 65 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

