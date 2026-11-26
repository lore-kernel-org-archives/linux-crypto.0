Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722131;
	b=iulbzQbSmop3t3gW71/qAUM9ju5DXXMhdAxhpNiYKpsdO1LghuGT3Zskb5TDkzlK72xm
	 1lYlCbKZ5ZjSlpIkbX4L34UnQHma1Hkhfzox4dmc53Au4QIMu09oMnf0QG7jyJpH76gmV
	 nh+mdwqKulMT5bJEMLctOihD9MJ2s3UysYdNHdvt859l3p16lgqsdXAl9eInnQnmEpe1r
	 2NWVAeLK/xZbIthh1ew6ZcwBKDGPuYiCm/V1GLQy4lTJ1+MGa7M0rX3qpnLWLvOy/VrfT
	 txlbvXj0TRm49pRBQY9G0jBgwGACpWAAT5jOK8kIs8U8ACcp+qc3VvSrYU41l2DHhBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722131;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FceHbLJv0TZU2/eRKdZZpK7MySJPD+3V05bKGzXmo10=;
	b=KYdNGjlZSgj+dbU4j6yJYrpfioxCDtWvRzvgJYxw2tgxllLDhZ5AzS43e2LIUYms7au3
	 LKzPPA+ZtC1momI1koDbKJlGJ62janyhp+5Jv9NEqkyL9rgpfMzNk3NXpKxwhuyZxbscZ
	 Mn2+xB3JIZOD2n1AIH+lQNM3Am4QXVBhBZRvKfXRQ+ykdJ4lOc++vlO7etvSzJ7rFif85
	 N/qLLBFS64o2HVT+GFCvtqRUVPjF7VjM5tmdAAUMDlt89CyKI1y1Cewde1e34sqna3Dnz
	 W5PqIMaXh7jMfwc3zDx//5SaANyF3QPKMsxmoaC1sTowb53EI+WZoKltrIFO7sGYpXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j3KaNpQm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F4606A31E;
	Thu, 26 Nov 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j3KaNpQm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72CA1F000C6;
	Thu, 26 Nov 2026 19:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722131;
	bh=FceHbLJv0TZU2/eRKdZZpK7MySJPD+3V05bKGzXmo10=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j3KaNpQm+qo6sodjsaNUbl7Kw4YkA7A97cTuPl0VEcuurcKlScZ8MVSOsN5LrNJc+
	 e+2I63dQYvUo2u+JdyYWzfDVlnudDyITNMuGdA+QJXneZwPt7haUfvLwTNCcO2s/83
	 9Vzi5KdeA5JzEbR3B4WVEJFzBkG/keNiJTiPHo2M30lCOzc+P5wouLUdO/sxEnfI2a
	 KLQH7z8tDsKq4D6EbOfvQlzmSgj8hDAaBK9b89ZV84QIBBu3DCebEbJVgmPHxFyMIW
	 mWAfBUnLcqbvXIhwIBvj2PHxUifH2vUFiBV6FwTv35itGf+kTkcxO56h1a76A8SfQ9
	 EZtWPr6AnsGmw==
Message-ID: <sashiko-outbox-236107@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 03/25] crypto: amlogic - Don't hardcode IRQ count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-4-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-4-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:42:10 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] crypto: amlogic - leak on IRQ error in
  meson_allocate_chanlist()
- [Medium] crypto: amlogic - IRQ enabled before init_completion() in
  probe
- [Medium] crypto: amlogic - meson_allocate_chanlist() clobbers
  -EPROBE_DEFER
--

commit b3f5f8c9ed61610fac3de12f0104aa644e360718
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Don't hardcode IRQ count

This commit replaces the hardcoded MAXFLOW constant with a dynamic flow_cnt
obtained via platform_irq_count() and moves per-flow IRQ lookup and
registration into meson_allocate_chanlist().

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 48dbdf4520348..b6933be39a377 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c

[ ... ]

> @@ -154,13 +154,31 @@ static void meson_free_chanlist(struct meson_dev *m=
c, int i)
>   */
>  static int meson_allocate_chanlist(struct meson_dev *mc)
>  {
> +	struct platform_device *pdev =3D to_platform_device(mc->dev);
>  	int i, err;
> =20
> -	mc->chanlist =3D devm_kzalloc_objs(mc->dev, struct meson_flow, MAXFLOW);
> +	mc->flow_cnt =3D platform_irq_count(pdev);
> +	if (mc->flow_cnt <=3D 0) {
> +		dev_err(mc->dev, "No IRQs defined\n");
> +		return -ENODEV;
> +	}

[Severity: Medium]
Does this overwrite -EPROBE_DEFER from platform_irq_count() with -ENODEV?
When the interrupt controller is not ready yet, platform_irq_count()
returns -EPROBE_DEFER, so returning -ENODEV breaks deferred probing and
logs a false error.  Returning mc->flow_cnt when mc->flow_cnt < 0 avoids
this regression.

> +
> +	mc->chanlist =3D devm_kzalloc_objs(mc->dev, struct meson_flow, mc->flow=
_cnt);
>  	if (!mc->chanlist)
>  		return -ENOMEM;
> =20
> -	for (i =3D 0; i < MAXFLOW; i++) {
> +	for (i =3D 0; i < mc->flow_cnt; i++) {
> +		mc->chanlist[i].irq =3D platform_get_irq(pdev, i);
> +		if (mc->chanlist[i].irq < 0)
> +			return mc->chanlist[i].irq;
> +
> +		err =3D devm_request_irq(mc->dev, mc->chanlist[i].irq,
> +				       meson_irq_handler, 0, "aml-crypto", mc);
> +		if (err < 0) {
> +			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
> +			return err;
> +		}

[Severity: Medium]
If platform_get_irq() or devm_request_irq() fails on iteration i > 0, does
returning directly skip meson_free_chanlist() for the earlier channels?

Each completed iteration starts a crypto_engine kthread and allocates
mc->chanlist[i].tl with dma_alloc_coherent().  Returning without unwinding
channels 0 .. i - 1 leaks their coherent DMA buffers and leaves their
kworker threads running after devres frees the struct crypto_engine
objects on probe failure.  Decrementing i and jumping to error_engine
cleans up the initialized channels.

> +
>  		init_completion(&mc->chanlist[i].complete);

[Severity: Medium]
Can meson_irq_handler() fire before init_completion() initializes
mc->chanlist[i].complete?

devm_request_irq() enables the interrupt line while mc->chanlist[i].complete
is still zero-initialized, and meson_irq_handler() calls
complete(&mc->chanlist[flow].complete) when the flow status register is
non-zero, which would dereference a NULL waitqueue pointer.  Calling
init_completion() before devm_request_irq() avoids this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D3
