Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1033859D1;
	Tue,  3 Mar 2026 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772520248; cv=none; b=dnWhEcsswSASHWIWC/2lWqFhqyYFjgupGUgYcPYwY6rBlEm+ltKqRdAkOdkGb1f7OV60qj2Hnwz0Qb1l9lfUxrLKAQibSYvbqG3mRGV0tW/k20pwyZLzInVvi76lcHrwpx0WuqvGiHluG8wV93JPyLJ0Qi4vYBvF5N8pYC0jioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772520248; c=relaxed/simple;
	bh=9zYNNRI2Q7A4txbtHEUZ0XbB7KUSfcEmFITlL2iLQ38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkM1rG/aS9eeRUz4cqqEpZElRs3XbNbNvJLynIkqaK0CnClEC+HfIdXMM1j1F0DW/agoTl1wdhVfmeNfnNUdwJE/J5a8+LY0f7nF0hBcaJkGZTvZtRz4slozA+CqjVcWnqQ0ovzow5qPyP8o9jAwmdN2HeFfV2xDkLOQ1PDo014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBUe/JSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBUe/JSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03677C116C6;
	Tue,  3 Mar 2026 06:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772520247;
	bh=9zYNNRI2Q7A4txbtHEUZ0XbB7KUSfcEmFITlL2iLQ38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rBUe/JSu+08xGAhX5bdw/+KOyZFqyiSky5ZMFVDFKo+6sJMzrQSXiE+oMLTrl9Q8W
	 qy9xj2q9RW1aoPlGTSlpMDhWcYQGkm14UiNz7v8ccYAQlpxD/GY0c1vnTJhKrP4vHJ
	 uPyuRyVh7++255oup1e00jxcf//n0J0aBkqSj+VjuR+HyZhKWzvq2FmWMi6dUGJ4Vt
	 ydyyIpDaF4teM/y4iRgYung1XVvT1sJ7jTrrLrW98NC3YoB6J5YnrqfAzJSFQzMaRV
	 IvAhF4251bSn9/PjiBxI0u5oTpM4F2MbyL0PSH9gmmP3FauLNXm/1NKAHGIbGNWJA2
	 s944xsSdpcAlw==
Date: Tue, 3 Mar 2026 07:44:05 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, matthias.bgg@gmail.com, 
	angelogioacchino.delregno@collabora.com, atenart@kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: inside-secure,safexcel: add
 compatible for MT7981
Message-ID: <20260303-brainy-dalmatian-of-proficiency-adbc3b@quoll>
References: <20260302230100.70240-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260302230100.70240-1-olek2@wp.pl>

On Tue, Mar 03, 2026 at 12:00:38AM +0100, Aleksander Jan Bajkowski wrote:
> The MT7981 as well as the MT7986 have a built-in EIP-97 crypto accelerator.
> This commit adds a compatible string for MT7981.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v2:
> - just add compatible strings
> ---
>  .../devicetree/bindings/crypto/inside-secure,safexcel.yaml  | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
> index 3dc6c5f89d32..6c797b7ce603 100644
> --- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
> @@ -18,6 +18,7 @@ properties:
>        - items:
>            - enum:
>                - marvell,armada-3700-crypto
> +              - mediatek,mt7981-crypto
>                - mediatek,mt7986-crypto
>            - const: inside-secure,safexcel-eip97ies
>        - const: inside-secure,safexcel-eip197b
> @@ -80,7 +81,10 @@ allOf:
>          compatible:
>            not:
>              contains:
> -              const: mediatek,mt7986-crypto
> +              oneOf:

Drop oneOf, you have only one enum there. This is just enum directly.

Best regards,
Krzysztof

