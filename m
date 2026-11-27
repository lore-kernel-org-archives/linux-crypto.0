Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781693;
	b=XEfWcAggRQJ6abuKBFO8xZTWmtkM0Ly1YlvRg707rWYGUg9iQSKwk2VI/TCeDKaD0pmC
	 Pdd/WbWq1N47sZavP4yLKmD+03wov3GZmJgdtyazDo605pvtDYG31lObXEcuJrodQbFcX
	 XmRc2Xt9q0iu1DxHMYxsygVfkMIXe+WdwM4q54fqyEHgRqS8kIrAUymmQwScQt3p1b6Nw
	 B7PyWhbUs7cWtdpVYon+C1YJmmtK0LaErBkC5aZorVSX0ABrzSQWUNFUUkioy1RxDukbr
	 g337+ZgQY2A6AhiLKEnax3kXwl/7fV6syXljxnPmwdgEuxlaiW9twQku61pesuTg5dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781693;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cleNDJpyMwlEBL17eRU13w6kn3iEKvIT+1gdk3IytiU=;
	b=vbF+iXTAc5aLB4Be5V5CMEXUax6DCjLWiHqe6nW7IqXP35b6XS6tGT7JbqaVNCqzydNs
	 fJ3Y/WM3vvqD+maHH+pa/4qfGGViLy8GQBmjeGtV1emFvuXPYVq6XPcp7X4U6w2JVu0vo
	 sno1pLpajJDrFk2flUbxKI5i/MNTSA+TYQqZ0gg39bnroPN84gARAwu3+Iv7ZKYrpUctY
	 LH2d04xsNmDhX4k5v6JBmHzBd2so+nzqxmA1o+FywlCTxwW+iWK4MVn/FEP5p9hiVpPbJ
	 xSLRAcvb/dcrhwQ/wqlTuUFEBb4Jdr6VkZ9W7hXb9xMEneWsD9kd8SSUIz9BUOeQaDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8JDFsKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3F606A31C;
	Fri, 27 Nov 2026 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8JDFsKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0261F0089A;
	Fri, 27 Nov 2026 12:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781692;
	bh=cleNDJpyMwlEBL17eRU13w6kn3iEKvIT+1gdk3IytiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V8JDFsKtETP+zHNB131/9ZZTmUEUaWmoJ9uuozJ2Ar7hcOYExlDQQdgaxI66mmw8N
	 x4iOjfSrs9sJPlt+Wh/SLGUePAMmmOHoELDM/qSR+npAVUmZhkFvGK9B/KGlwKi+Lg
	 LBya1hm0uWZZMdhnE2hSnuMcznZ9l4H2IxtsGBi874mWV/5YpF7oALFZs3AGpRQ6/b
	 Z/Lh63eBegZ42isIPHSWx+J6QWJSymLwEIelL00KelbAkyWEW40ZcDbGLUVhddx4+u
	 AUzo4whBGJK0vfLycdG9HgZOEYsuj1kyu0LWUsN6XREtyKbdYNbHnzOfcvJ7DM57Tq
	 UNcQloaHzBbZA==
Message-ID: <sashiko-outbox-237339@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 05/30] crypto: amlogic - Remove clock input
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261127120103.1532882-6-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-6-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:14:51 +0000
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
- [Medium] crypto: amlogic - meson_crypto_probe() drops required DT
  clock enablement
--

commit 4232268afc2acbf7008e7d08e5f42bc81d020538
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Remove clock input

This commit removes the devm_clk_get_enabled() call from meson_crypto_probe=
()
and drops the busclk member from struct meson_dev.

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 24ef7d5a56075..37224d75edfbf 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
[ ... ]
> @@ -267,13 +266,6 @@ static int meson_crypto_probe(struct platform_device=
 *pdev)
>  	if (IS_ERR(mc->base))
>  		return PTR_ERR(mc->base);
> =20
> -	mc->busclk =3D devm_clk_get_enabled(&pdev->dev, "blkmv");
> -	if (IS_ERR(mc->busclk)) {
> -		err =3D PTR_ERR(mc->busclk);
> -		dev_err(&pdev->dev, "Cannot get/enable core clock err=3D%d\n", err);
> -		return err;
> -	}
> -
>  	err =3D meson_allocate_chanlist(mc);
>  	if (err)
>  		return err;

[Severity: Medium]
Should meson_crypto_probe() pass NULL to devm_clk_get_enabled() instead of
dropping clock enablement altogether?

Earlier in this series, commit "dt-bindings: crypto: amlogic,gxl-crypto:
correct clk and interrupt lines" states that the crypto block is clocked by
clk81 rather than blkmv, removes only clock-names, and keeps clocks as a
required property in
Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml:

  required:
    - compatible
    - reg
    - interrupts
    - clocks

Without devm_clk_get_enabled(&pdev->dev, NULL), the required clock defined =
in
the binding and device tree nodes is never claimed or enabled by the driver,
leaving the crypto DMA engine unclocked if the gate is not kept on by the
bootloader or temporary CLK_IS_CRITICAL / CLK_IGNORE_UNUSED flags.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D5
