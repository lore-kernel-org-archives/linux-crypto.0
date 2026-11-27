Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781512;
	b=y08q/1/i+FRRCgYbkcO8l4V4sukOhBZZuM78DjD2PGpMGnnXLNhxwpnv3OK4oSOYkf1J
	 K4gsWX5X9ln1lfy4fmyHqn6Zf9pfQR+/g15Bo8UDlMg3fDskXveQhHQIR3Mk2LeqBHdOH
	 Orj2dwE3dDWKqTG3HamNTuhwWxHPheLi651Pz2LRV9qnFrtiEh/TFiZsaPRa5n1M3prsu
	 4DV+5RnPLCOHPtYT0PXFJcicqGV5BXcz/4At1dBEMGPdKYS7/9oEe/6fvLGumtDJ/npcx
	 EiGp7FD987cNXDJ/5hpjSru9M7/ZkRm+U8FZT9Q8D78KpRVX3xF3gIO2ttpWH3vfd4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781512;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=U2UKqho7RiqZPSkkcPut/1/ppKVpudTdBMODtt9mKNk=;
	b=EzJ0TGo4IPlPETZoco75TEXxzFYKkBK111/PChsF7ZOlO3HXnzfJs9IxAKS6SVKPQwsh
	 1KMoG7Y/m/kfj2fuueq659K2xEh90HeBmqjFx1Z7Cw4AOHc3ak4Ek+7jyAkVGSxkp2mdZ
	 IrQUQ0i8GGGRDLDyAhn0IfdmLQ93fcsqQT9AwfJqPinpr2AwxU3GYI6UsK9oXx1iffy2k
	 mRzaexVN5APljYlp/ICCRL78GC5h5al7e0rptya1E7EBB04wk7jP2WpVkk/6Akoxh2b/Z
	 QmyRNiSw22BOG2A07wBnBZJBqteAkSyKx6y/qS/Fa7KeqlgQ86GbRpfGiRFQwsPkgtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxYJjrQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D850606A31C;
	Fri, 27 Nov 2026 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SxYJjrQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C861F0089B;
	Fri, 27 Nov 2026 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781511;
	bh=U2UKqho7RiqZPSkkcPut/1/ppKVpudTdBMODtt9mKNk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SxYJjrQCoXn8jKpccGPJV92RABj6dtqWFrQ+kJnGiCfY0XOjMjtJSgws8GZXXDA/A
	 bAW4mMITA5O0Y6A5PUke3SL9+twwjt83hNafHGIWXt8jp6T3wwy96ZE45oTPvuOcbJ
	 6CnS27JzH/XecIX0kzp9fujcqV29vwZlWw8SKR9ycL67FCXHmr4eLgvIoe3KWGX6Wc
	 uf57GL5l5OJ2rVAX1bdHPVDgvfW5V+ovSlUeSDieDqW/DoVjwoOOXi37N/co2Yui1/
	 IQmKI2tfk1WDUtbPyHemX+6U72wEkVSuVRak8sY0Tj+1PPNoe8F7jOLbQvaKAnhh14
	 LueO+DMUR4w+w==
Message-ID: <sashiko-outbox-237327@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 03/30] crypto: amlogic - Don't hardcode IRQ count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-4-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-4-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:11:50 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: amlogic - IRQ requested before init_completion() in
  probe
--

commit b42c58d2650be1044e0fec0a7ef8758413b304b6
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Don't hardcode IRQ count

This commit replaces the hardcoded MAXFLOW constant with a dynamic flow
count queried via platform_irq_count() and moves per-flow IRQ registration
into meson_allocate_chanlist().

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
> +
>  		init_completion(&mc->chanlist[i].complete);

[Severity: Medium]
Can meson_irq_handler() fire before init_completion() initializes
mc->chanlist[i].complete?

Moving devm_request_irq() ahead of init_completion() enables the IRQ
while mc->chanlist[i].complete is still zero-filled, so a pending
interrupt with a non-zero flow status register will call complete() on an
uninitialized swait_queue_head and dereference a NULL task_list.next
pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D3
