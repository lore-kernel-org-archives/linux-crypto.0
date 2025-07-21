Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DA5487A5;
	Mon, 21 Jul 2025 09:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753090521; cv=none; b=YyosiW2HoTr2WTo8HHxCChj8UEOfXZlBZT9kbwPql5hqEGBii8UfFCNsjlgemLDkR7mkp4SwIPCbXN60hXnA+1owZr8yCBvvq/vk7kpVwNDduG9M9ucQNje7uRYLny706PKwWyF54sADFK8PCHM1JxNBj+g73Rw7RG+e2O6EOFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753090521; c=relaxed/simple;
	bh=X8v0vyphKABw6mn9MwF3K64kGeZMYpZRS3X8znvpDDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgYmc7LSPJ0YKmzRqpKPH+AW/D50OxPcBI1WmEiSXBDBoFcRdGi37ivXV3KyHK9hRA7b3jqT4ht1IvQWIOk6pjXa234HDtu5l9PRE7N8FE8KE7oZqd8/udikIndpYTWOhibWnQ1xaTNtvMjiSx37xd0Qn+2gQ0UNCTPnZLLh6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4khWPmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4khWPmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C2BC4CEED;
	Mon, 21 Jul 2025 09:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753090521;
	bh=X8v0vyphKABw6mn9MwF3K64kGeZMYpZRS3X8znvpDDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K4khWPmnVZphjAbFKboI0FSmd3tz3XjB48JFWgQMxBkdhtRUqkLuPZ/WQM+YtW/Sk
	 kvnT4Zbi1WHSjCOm+0CkRKFvOIRLJUPmbZjXpLpim8de/LSP0U/2wkiY4NgSCh8Dii
	 rQ5f+nx2gWPmKs8InPBNUpBAB6/iMExS1HUuhuUguy8qeMiOCB3eYU5l8ORSDZdzuA
	 9td3HTwLrd3thWxQ/LhgV6u9OSkjoZlMsGM93Zk74GSDZsUi4cxeysomfMlvjiF4kD
	 SJjlDSvyWOOyEWFPCUQcla2SqaPzksJyBpIe2FQrW9ThzvInu6+oeAzLfebMclPQ9F
	 +qRQF7pqt3fqA==
Date: Mon, 21 Jul 2025 11:35:18 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, matthias.bgg@gmail.com, 
	angelogioacchino.delregno@collabora.com, atenart@kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Sam Shih <sam.shih@mediatek.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: inside-secure,safexcel: make
 eip/mem IRQ optional
Message-ID: <20250721-utopian-jumping-yak-8cc53e@kuoka>
References: <20250720174903.1321533-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250720174903.1321533-1-olek2@wp.pl>

On Sun, Jul 20, 2025 at 07:49:02PM +0200, Aleksander Jan Bajkowski wrote:
> Binding for this cryptographic engine defined 6 interrupts since its
> beginning. It seems however only 4 rings IRQs are really required for
> operating this hardware. Linux driver doesn't use "eip" or "mem" IRQs

Are the lines there in hardware or not? See writing bindings - they
exactly cover this case.

> and it isn't clear if they are always available (MT7986 devicetree
> doesn't specify them).

You need SoC specific compatibles which will narrow this per variant of
the block.

>=20
> The hardware reference manual [1] for the EIP-197 IP core only defines
> ring interrupts and a global interrupt ("eip"). Ring interrupts can
> optionaly be routed via the main interrupt. Role of the "mem" interrupt
> is unknown.
>=20
> This deals with:
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000=
: interrupts: [[0, 116, 4], [0, 117, 4], [0, 118, 4], [0, 119, 4]] is too s=
hort
>         from schema $id: http://devicetree.org/schemas/crypto/inside-secu=
re,safexcel.yaml#
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000=
: interrupt-names: ['ring0', 'ring1', 'ring2', 'ring3'] is too short
>         from schema $id: http://devicetree.org/schemas/crypto/inside-secu=
re,safexcel.yaml#
>=20
> [1] https://www.scribd.com/document/665924595/Security-IP-197-HW3-4-Hardw=
are-Reference-Manual-RevA
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Sam Shih <sam.shih@mediatek.com>
> CC: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  .../crypto/inside-secure,safexcel.yaml        | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safex=
cel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.=
yaml
> index 343e2d04c797..97af96bfe5f6 100644
> --- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
> @@ -26,16 +26,23 @@ properties:
>      maxItems: 1
> =20
>    interrupts:
> +    minItems: 4
>      maxItems: 6
> =20
>    interrupt-names:
> -    items:
> -      - const: ring0
> -      - const: ring1
> -      - const: ring2
> -      - const: ring3
> -      - const: eip
> -      - const: mem

You just miss minItems: 4 and no need for all the rest.

Best regards,
Krzysztof

