Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795722100;
	b=T5L0lhXXGy9Ez0NZztcqBZ4xX5pp6vEY/7cqcYlgM9h2OGbPLs/JupIjlfa/82Cpi/6Z
	 MpOx/gxFP3mGrRIn8ZMw1ktU/BO/XGVZLYjZ4p/2YSOXA4/aBZZb0PEg9mrO3uvRO1tT0
	 vd3Nf5tJpIKgasg5dS6xq7AP7Gjvc4OFyT6jEbYQKAwEpp8sVRTY3XN+Jr7sjtmtVOAk6
	 lyqGFLX7SJa4bePi5niwr57jYIs+DQ3C+40QcHAzsX6JVOSevBWlDL/CBSh6q1w+j8pIF
	 y33ujk1bHVvzd5Sp/X80Nv7/EYzk83B7LA1UChHZmOIbNkBKPFLyohhx8N4bD27BvIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795722100;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1bzMSOb08TutL6tdk9EvyHWnytggQnUyUPgR7/5Ax1g=;
	b=WbLYLdMzuLQgUIZdIjVrBBvKnwUtg3VxEseX05RCdmU0oG97hSAbdW8glRKZ4gmxXW9e
	 C9yTYEIJdqp0BnslOR0QuRJbVPVEpATkTNZPaLPkcttyp6rU0uZT4d8etwBzZeVmIYSMO
	 82iVR7K23gYyYpe+JehT4KPfao2etZ2c8fZX90vKxxBw6egbX4uqebPpq69wheZJhaZFd
	 2KKvJFAzUOUTGhN2K8s0Drj38NiGiOoPP2DSC7F5cLQvih+s/FA0Lk4eypcq86n6U4Xbz
	 3qqr7PTryV4+RfuR3P5FboxGiyW8YBNX10M7UqgAQfiHRR/RWHhtNKfDX5+ymBPlyHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RJyHOeUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D5C606A321;
	Thu, 26 Nov 2026 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RJyHOeUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F172F1F000C4;
	Thu, 26 Nov 2026 19:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795722099;
	bh=1bzMSOb08TutL6tdk9EvyHWnytggQnUyUPgR7/5Ax1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RJyHOeUIEeC4Opp8QFsV81f+qYjsAvLPwI7+bGk4iDFoCIPxc6iCPch6snp1d2RYt
	 FUzcUO52Bh7g+JNthXYMfRJKM+IOcbiiOBsDtQ8nItU2lnebtUr/Rm9GvTQ1a8Zb1d
	 QWowuURkwHLhaUqH4pWaId8JlZ+Y/Ff5UN1yoLWBBtGc3FNLpbpiEqrQyq1rmU7KCa
	 D24DI3gWB4edqqaqIp4ldOFHBRvalQHG1euu8xG6TFEEkh+De8yfDn2TAQ7lo7nKJk
	 I9Lg5rDnJQY/s6MaGp1cWG5k0nEcc/uw/ESk+HKTmEXyXrc78C2J5HZvxRtfQ33axG
	 msYvFVxcEesNA==
Message-ID: <sashiko-outbox-236105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 09/25] crypto: amlogic - Move algs definition and
 cipher API to cipher.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-10-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-10-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 19:41:38 +0000
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
- [Medium] crypto: amlogic - unregistering failed alg in
  meson_register_algs()
- [Low] crypto: amlogic - meson_handle_cipher_request() left non-static
--

commit 08352ca67e625f03f4ad6f02c380a0279142c7e8
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

crypto: amlogic - Move algs definition and cipher API to cipher.c

This commit moves the skcipher algorithm templates and cipher callbacks
from amlogic-gxl-core.c to amlogic-gxl-cipher.c and exposes registration
and debugfs helpers.

[ ... ]

> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/a=
mlogic/amlogic-gxl-core.c
> index 81d0e8731ab16..68d394e90f660 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c

[ ... ]

> @@ -227,19 +155,20 @@ static int meson_allocate_chanlist(struct meson_dev=
 *mc)
>  	return err;
>  }
> =20
> -static int meson_register_algs(struct meson_dev *mc)
> +int meson_register_algs(struct meson_dev *mc, struct meson_alg_template =
*algs,
> +			unsigned int count)
>  {
>  	int err, i;
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(mc_algs); i++) {
> -		mc_algs[i].mc =3D mc;
> -		switch (mc_algs[i].type) {
> +	for (i =3D 0; i < count; i++) {
> +		algs[i].mc =3D mc;
> +		switch (algs[i].type) {
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
> -			err =3D crypto_engine_register_skcipher(&mc_algs[i].alg.skcipher);
> +			err =3D crypto_engine_register_skcipher(&algs[i].alg.skcipher);
>  			if (err) {
>  				dev_err(mc->dev, "Fail to register %s\n",
> -					mc_algs[i].alg.skcipher.base.base.cra_name);
> -				mc_algs[i].mc =3D NULL;
> +					algs[i].alg.skcipher.base.base.cra_name);
> +				meson_unregister_algs(mc, algs, count);
>  				return err;
>  			}
>  			break;
> @@ -249,16 +178,17 @@ static int meson_register_algs(struct meson_dev *mc)
>  	return 0;
>  }
> =20
> -static void meson_unregister_algs(struct meson_dev *mc)
> +void meson_unregister_algs(struct meson_dev *mc, struct meson_alg_templa=
te *algs,
> +			   unsigned int count)
>  {
>  	int i;
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(mc_algs); i++) {
> -		if (!mc_algs[i].mc)
> +	for (i =3D 0; i < count; i++) {
> +		if (!algs[i].mc)
>  			continue;
> -		switch (mc_algs[i].type) {
> +		switch (algs[i].type) {
>  		case CRYPTO_ALG_TYPE_SKCIPHER:
> -			crypto_engine_unregister_skcipher(&mc_algs[i].alg.skcipher);
> +			crypto_engine_unregister_skcipher(&algs[i].alg.skcipher);
>  			break;
>  		}
>  	}

[Severity: Medium]
Does meson_register_algs() end up calling
crypto_engine_unregister_skcipher() on the algorithm whose registration
just failed?

algs[i].mc is set to mc before crypto_engine_register_skcipher(), and the
error path no longer clears algs[i].mc =3D NULL before calling
meson_unregister_algs().  Because meson_unregister_algs() unregisters
every entry with a non-NULL algs[i].mc, it unregisters the failed entry
at index i, whose zero-initialized cra_list causes a NULL pointer
dereference in crypto_remove_alg() -> list_del_init(&alg->cra_list).
meson_unregister_algs() also leaves algs[i].mc non-NULL after
unregistering, so a failure on a later probe attempt would try to
unregister entries that were already unregistered.

[ ... ]

> diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogi=
c/amlogic-gxl.h
> index cf07c5fbc5bf5..608ce75f027a3 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl.h
> +++ b/drivers/crypto/amlogic/amlogic-gxl.h
> @@ -161,10 +161,12 @@ int meson_get_engine_number(struct meson_dev *mc);
> =20
>  void meson_dma_start(struct meson_dev *mc, int flow);
> =20
> -int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
> -		     unsigned int keylen);
> -int meson_cipher_init(struct crypto_tfm *tfm);
> -void meson_cipher_exit(struct crypto_tfm *tfm);
> -int meson_skdecrypt(struct skcipher_request *areq);
> -int meson_skencrypt(struct skcipher_request *areq);
> +int meson_register_algs(struct meson_dev *mc, struct meson_alg_template =
*algs,
> +			unsigned int count);
> +void meson_unregister_algs(struct meson_dev *mc, struct meson_alg_templa=
te *algs,
> +			   unsigned int count);
> +
> +int meson_cipher_register(struct meson_dev *mc);
> +void meson_cipher_unregister(struct meson_dev *mc);
> +void meson_cipher_debugfs_show(struct seq_file *seq, void *v);
>  int meson_handle_cipher_request(struct crypto_engine *engine, void *areq=
);

[Severity: Low]
This isn't a bug, but since algs[] moved to amlogic-gxl-cipher.c,
meson_handle_cipher_request() is now only referenced in that file and can
also be made static and dropped from amlogic-gxl.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D9
