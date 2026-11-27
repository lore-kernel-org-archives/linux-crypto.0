Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782079;
	b=ZM+ial6T/8bSwHonRkh1xc105qfgz16GWq6RA7SDotkS8Tgf6L4WIPtDQzADc2VLzjhr
	 o4X/ZSHxSTPkz+Qo4FDQ4jUDj9EWwM+t05z4vfBSXVeaaLShY6AyDC0orszbKVV2iMea6
	 CQT4clKErvOwmN3yXLTttPirKeDLW/AhxpbUy77abU3iKtP76wvbp6onZ+oNK/KuljAhx
	 +HMuTdUwV60vUHR6IhNAzFJXIHLaW1qfqaCPEZ4gCqIt13Xis2+Q2xMcG85GdPLuVD6X8
	 Tjsmf/8UJIknNAwRmZzoc/RUvem5rtn+LjhZPIOBrcE706S2dLARtZTzdRrx+bXeiRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782079;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZFwKN1Fa/NE4ipfk2II223W7kJwBqBxqrAot+Ny010o=;
	b=TasIHJmtBTfjIk3yaufRjgGTutSGGmSjnFgWkbmjugRDH64d6A87UxJxYq+bpnQq5Ozh
	 Y22YE5VB/53Dv090TXIul/8QvBd1bKcXHgdunon050P0YxyvbYGLt7z7iiCJyydWYmM6T
	 2iQPU00o8tbzES8yN9m/nZ0a3/CrjCcSJFVLTcgq6VRwlSzxcF1wxrryWxcyx4i0cCswy
	 Wmel2Bahc4zNN/YmOofpLMlp6IHn0pfanObnwQYDYqD0orW0hlOGWWed0An/7zlrYehN/
	 6pWEBHQbCC512EP6x5v0s6BDPgq12LeUJT8x3qdesrKLJcM8JzgRIBa8JUnh3Glui5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWxrjGMr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1B9606A335;
	Fri, 27 Nov 2026 12:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWxrjGMr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4357F1F00924;
	Fri, 27 Nov 2026 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782078;
	bh=ZFwKN1Fa/NE4ipfk2II223W7kJwBqBxqrAot+Ny010o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RWxrjGMrLFKBHEJheFxE7/iq0h4YMlWz6RPpUp3+P81zuuC+O+ihcEnzFmD7v4oc+
	 RogJ6bK4vz9CQYgTlFKZFrXJNpeTZFrrq68XDObdZjNoHGdtW2yr5TeExZH7mtOTjN
	 KKM3LCPsaJW0jXoKWpFMIQ+2JaQBX0WZvvaYg7xrvP/AUF+xeRKbJKwbuuCXmTDfhD
	 X8rrSWwXLhG3nAKOK9v64goz6Wq/CvEq2UrLEENAaQ9+rZMKD1M953XJwUaNt9Vqsd
	 pnq4t5m3GMibofju4oHUdC6sNTH/rZquv4skOs9x7wkoYpWf4G+fHnpGznNtcyxULi
	 VkreUYCuGNDiw==
Message-ID: <sashiko-outbox-237356@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 27/30] crypto: amlogic: fix probe and algorithm
 registration error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>
In-Reply-To: <20261127120103.1532882-28-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-28-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:21:17 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] crypto: amlogic: stale mc pointers left by
  meson_unregister_algs()
- [Medium] crypto: amlogic: completion initialized after IRQ in
  meson_allocate_chanlist()
--

commit 6f6ab6fadcd8280a6a563ddcf1e8fea62b447b00
Author: Jose Nieto <jnieto.alaber@gmail.com>

crypto: amlogic: fix probe and algorithm registration error paths

This commit updates meson_allocate_chanlist() to propagate negative
return values from platform_irq_count() and unwind allocated channels on
IRQ failure, and clears algs[i].mc on registration failure in
meson_register_algs().

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 8ce3f66407537..c11d7d8250eae 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c

[ ... ]

> @@ -117,14 +119,18 @@ static int meson_allocate_chanlist(struct meson_dev=
 *mc)
> =20
>  	for (i =3D 0; i < mc->flow_cnt; i++) {
>  		mc->chanlist[i].irq =3D platform_get_irq(pdev, i);
> -		if (mc->chanlist[i].irq < 0)
> -			return mc->chanlist[i].irq;
> +		if (mc->chanlist[i].irq < 0) {
> +			err =3D mc->chanlist[i].irq;
> +			i--;
> +			goto error_engine;
> +		}
> =20
>  		err =3D devm_request_irq(mc->dev, mc->chanlist[i].irq,
>  				       meson_irq_handler, 0, "aml-crypto", mc);
>  		if (err < 0) {
>  			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
> -			return err;
> +			i--;
> +			goto error_engine;
>  		}
> =20
>  		init_completion(&mc->chanlist[i].complete);

[Severity: Medium]
Can meson_irq_handler() fire before mc->chanlist[i].complete is
initialized?

devm_request_irq() enables the interrupt before init_completion() runs.
If a pending interrupt is raised in that window, meson_irq_handler()
calls complete(&mc->chanlist[flow].complete) on a zeroed completion whose
wait.task_list pointers are still NULL, causing a NULL pointer
dereference in swake_up_locked().  Initializing the completion before
requesting the IRQ avoids this window.

> @@ -169,6 +175,7 @@ int meson_register_algs(struct meson_dev *mc, struct =
meson_alg_template *algs,
>  			if (err) {
>  				dev_err(mc->dev, "Fail to register %s\n",
>  					algs[i].alg.skcipher.base.base.cra_name);
> +				algs[i].mc =3D NULL;
>  				meson_unregister_algs(mc, algs, count);
>  				return err;
>  			}
> @@ -178,6 +185,7 @@ int meson_register_algs(struct meson_dev *mc, struct =
meson_alg_template *algs,
>  			if (err) {
>  				dev_err(mc->dev, "Fail to register %s\n",
>  					algs[i].alg.ahash.base.halg.base.cra_name);
> +				algs[i].mc =3D NULL;
>  				meson_unregister_algs(mc, algs, count);
>  				return err;
>  			}

[Severity: Medium]
Does meson_unregister_algs() leave stale non-NULL algs[i].mc pointers in
the static algorithm template arrays?

drivers/crypto/amlogic/amlogic-gxl-core.c:meson_unregister_algs() {
	for (i =3D 0; i < count; i++) {
		if (!algs[i].mc)
			continue;
		switch (algs[i].type) {
		case CRYPTO_ALG_TYPE_SKCIPHER:
			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
			break;
		case CRYPTO_ALG_TYPE_AHASH:
			crypto_engine_unregister_ahash(&algs[i].alg.ahash);
			break;
		}
	}
}

Because the template arrays in amlogic-gxl-cipher.c and
amlogic-gxl-hasher.c are static and meson_unregister_algs() does not clear
algs[i].mc after unregistering, any unbind or probe rollback leaves
dangling mc pointers across all entries.  If a later probe fails partway
through meson_register_algs() at index i < count - 1, clearing only
algs[i].mc still leaves algs[i + 1 .. count - 1].mc non-NULL from the
previous run, so meson_unregister_algs(mc, algs, count) will try to
unregister algorithms that were not registered and hit WARN_ON() in
crypto_unregister_alg().  Clearing algs[i].mc =3D NULL in
meson_unregister_algs() (or passing i instead of count on rollback) would
prevent this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127120103.1532=
882-1-jnieto.alaber@gmail.com?part=3D27
