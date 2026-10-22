Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659902;
	b=NHoHYqyRStfYisgYT8Mt9lHWPJ0pcpfV/jXtlplZx2LMKz25KcqeujHYz3PBzXbgRh9B
	 ILa1MN3uJYkGbdM6zTtzSCqX8PDHpOqGrLzC0EDBu9E/E58hBWIq+B4tCbxUzCzPVU2ZP
	 5JFHsYgbHScorCMJrGfOfUe2w388vAaDvgGWCP24V9e8quVCMhka/loXDMMFqoRvdw3H5
	 masOYt+d6wcVKXOF152m4gixbJbUrBuUgzw3T/9pIvzVMhhyQKgdJi1zACW5O1AK3nifM
	 RjjCo7trUymBLPJllN2IUsKTKrp3FKgDDhMV3kmhSbJD4ClqcPd/NODsqIoe/ak6Z2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659902;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k6a2k6+bok+Su2QyvWInPfvhOUYNQ0l5xS1haQ288Hg=;
	b=b3mQvHH6GTZY670Dd+6q/HX2oDldysZe7/+z7TmNFvaePbpGlTAiMYSKmqzuUmp1si/D
	 dROQcLUvUzcUyivwMSSIvQiRzXtVzJtczITLU/AJUUT35aV1B3JFoE7sgAG+rLt9gXgzd
	 4zw7w+tm3Ef/zqhuAuvHmJFSKym2RFZepsnUn6CC4o0PZBuBC+nkiUzBn3qJ4ln/N21J3
	 ZLar+s0m0qlWaxR0RjfPzUHnafUf6YP8WBNhvdZNfSnOZLMC9sNn+FsTy7ny0ypJJ429F
	 VErNbKaEsh9PTKpsNor4vTOYei4XqVd+TvxyUujq9iG8F8+R5OFkbJeOJLyz+d8YsoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9gRE+Rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A30F606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9gRE+Rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB41F000C3;
	Thu, 22 Oct 2026 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792659902;
	bh=k6a2k6+bok+Su2QyvWInPfvhOUYNQ0l5xS1haQ288Hg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R9gRE+RxLvLxr+V9AltCRxaZ+G4pdN5mhTI3YGnOXOmR2z37X4AjbYOKHEMHtL+H+
	 mN22TftScuPdxqjiTfa0yZr9oDabCyV7imI/NssBInTL3fUaPUJmPDYbDm+KQ9JuQb
	 9zWjK8bkB9uSR1OTfLO4PUPT4u4MaQ//rFSU+e+ayGzoxsa0WGPnC+FJoOAfptz3fv
	 en1kdz/f+xy7vtphVOImuM94t3MdP+d3MUNpb45GB8IxD+Y6eZ7HLMonb9r+DahA9d
	 1Gq8/MemkRu2d7H+VvTwVYUy+NTxh7GnERN/uXYYr2W9gso6nQVz3Oy9ipPXAMMy/x
	 zt0REJrDiVT9A==
Message-ID: <sashiko-outbox-181233@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 1/2] crypto: qce - Only register algos if the user
 really wants it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, "Bartosz
 Golaszewski" <brgl@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Russell King" <linux@armlinux.org.uk>, "Eric
 Biggers" <ebiggers@kernel.org>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Kuldeep
 Singh" <kuldeep.singh@oss.qualcomm.com>, "Pankaj Patil" <pankaj.patil@oss.qualcomm.com>, "Birk
 Skyum" <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261022-qce-fixes-broken-label-v11-1-0d33c34fd0c3@oss.qualcomm.com>
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <20261022-qce-fixes-broken-label-v11-1-0d33c34fd0c3@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 09:05:01 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] crypto: qce: missing kernel-parameters.txt doc for do_register_algos
--

commit 47675c12b3c6637f5e62afe90e1fb4f153328b57
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

crypto: qce - Only register algos if the user really wants it

This commit adds a do_register_algos module parameter to the QCE crypto
driver so that crypto algorithms are not registered by default during
probe unless explicitly enabled by the user.

> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index bf3c1bc3ba7bd..5b1bf7a50f88c 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c

[ ... ]

> @@ -22,6 +23,9 @@
>  #include "sha.h"
>  #include "aead.h"
> =20
> +static bool do_register_algos;
> +module_param(do_register_algos, bool, 0444);

[Severity: Low]
In drivers/crypto/qce/core.c, module_param(do_register_algos, bool, 0444)
exposes qcrypto.do_register_algos as a kernel command-line and module
parameter to gate devm_qce_register_algs(qce) in qce_crypto_probe().

Should Documentation/admin-guide/kernel-parameters.txt also be updated to
document qcrypto.do_register_algos, along with a parameter description in
drivers/crypto/qce/core.c?

> +
>  #define QCE_QUEUE_LENGTH	1
> =20
>  #define QCE_DEFAULT_MEM_BANDWIDTH	393600
> @@ -259,9 +263,11 @@ static int qce_crypto_probe(struct platform_device *=
pdev)
>  	qce->async_req_enqueue =3D qce_async_request_enqueue;
>  	qce->async_req_done =3D qce_async_request_done;
> =20
> -	ret =3D devm_qce_register_algs(qce);
> -	if (ret)
> -		return ret;
> +	if (do_register_algos) {
> +		ret =3D devm_qce_register_algs(qce);
> +		if (ret)
> +			return ret;
> +	}
> =20
>  	/* Configure autosuspend after successful init */
>  	pm_runtime_set_autosuspend_delay(dev, 100);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-qce-fixes-=
broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com?part=3D1
