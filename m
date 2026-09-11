Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1266403B1E;
	Fri, 11 Sep 2026 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789107868; cv=none; b=c8ocBNO97MkQyAwHIJZPgqqQGZOkkWgf4Vl07BsLrIWpcOwITI4n+dxIRCMgemgjifPWNT4KzmsmGtzDPXPmcff81ywEKCJUG+DpvMqmKytGVRkOz8rRML0BhYs701uA7FNbzEzhazYutNiF71uhYp25MbhX5mOxXJ4brVtjui8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789107868; c=relaxed/simple;
	bh=cnt50FePNe+Jk/w3vIOgLk7hE8kpsmUFeZEwLkEm/Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BuIy69hRetwkI6WvKk/HQjwAdXbLgp9naqQ6xE781nyHuKXr/QPMD3+Rz8vglps7UNeX20uG+IiJZdAVrKi/OMhxa3rx0k+srTxPvyRSyeLOTCxIb3aQcpHi80Z98x5Ku08k5fY2UU7109Wb0Kz0lVfstC+Yyy4Xw52/sEEQA+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=R4Wnqk/V; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="R4Wnqk/V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=tNI0SH70ZtDdmVS2JUVOZmi2MDCOhm5iayYFnH6g5I8=; t=1789107860; x=1790317460; 
	b=R4Wnqk/VlLzPnu1Ur4o+4PYyBzvORrtbEPDWmFxxAhhfDPKXqtZh7PP8Nd6ia6HBTaU4HWBB8zm
	l7RBDOrWq8Tn0Zalx+IEmRhdqMCL1xurOHYx1ctsfH2XGta2gO/XhqpaFJ2RwEd3DQ2Mbh6s3V83X
	YT38fPK8WjYjckFL3p7lu0qQXjhYyYe9bWbq7GexC5nXBM3mf8nIeNPRZ2XaK8zxKYuRL4l/be6vh
	oOEYlAj9DjxtWx04tYsP2XeYAT8TR+bAkv6Wc33Wf61O4qA5FR6n95eBQlOEpYuUBbm9FLlZJYXjP
	ORAU9tPIjySdhyqXhJVi+0qjrd+ynEiykkmw==;
Date: Fri, 11 Sep 2026 08:24:06 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Bhargav Joshi <j.bhargav.u@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Kevin Hilman
 <khilman@baylibre.com>, Roger Quadros <rogerq@kernel.org>, Tony Lindgren
 <tony@atomide.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: crypto: ti,omap-sham: Add OMAP3
 compatible and deprecate ti,hwmods
Message-ID: <20260911082406.05e2a212@kemnade.info>
In-Reply-To: <20260911-ti-dra7-omap-sham-fix-v1-2-c430f01b4e13@gmail.com>
References: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
	<20260911-ti-dra7-omap-sham-fix-v1-2-c430f01b4e13@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Sep 2026 03:41:58 +0530
Bhargav Joshi <j.bhargav.u@gmail.com> wrote:

> The OMAP SHAM driver supports OMAP3 SoCs, and "ti,omap3-sham" is
> actively used in existing dts. However, it was previously missing from
> binding. Add "ti,omap3-sham" to the list of valid compatibles.
> 
> The legacy "ti,hwmods" property is no longer needed as TI OMAP mirgrated
> to "ti-sysc". Mark it as deprecated and remove it from the required
> properties.
> 
> Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>

What about also removing ti,hwmods usage while you are deprecating it?

Regards,
Andreas
> ---
>  Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> index d69b50228009..3ef05890e13a 100644
> --- a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> +++ b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
> @@ -13,6 +13,7 @@ properties:
>    compatible:
>      enum:
>        - ti,omap2-sham
> +      - ti,omap3-sham
>        - ti,omap4-sham
>        - ti,omap5-sham
>  
> @@ -32,6 +33,7 @@ properties:
>      description: Name of the hwmod associated with the SHAM module
>      $ref: /schemas/types.yaml#/definitions/string
>      enum: [sham]
> +    deprecated: true
>  
>  dependencies:
>    dmas: [dma-names]
> @@ -40,7 +42,6 @@ additionalProperties: false
>  
>  required:
>    - compatible
> -  - ti,hwmods
>    - reg
>    - interrupts
>  
> 

