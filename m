Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660024;
	b=q9QPhBw854gHW3wVh3PrP++29ic9zAFfwePMHQhEfMQjlKUWoE4CZl/Fr0kiM7n4sHu4
	 EYjbQ3sjHRpoTVIpO35JmiEKnYi/kWtXH8XYsju41Tf8zyqGhczmEQ0h5Qaiga7q7ipSh
	 wDlZTN3yrTI1eMIfHaa2X4B2WJC6NpYJE+Gd10lBvS99TAP2xbaK6PkIaFASMNwLAyM1b
	 nu8MS5AtmIAQmymjEdzo3xZheJZGJwfBJLH2KtoKqkNV7jRBlkTs0mgbCapO8rZmeSwpL
	 DNqBXBKgjJkwILtqz+L132ctbVoo8hHuvBRB/J8lg7mqg0i4qq8uxwmlC2h/PlB2eOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rD6igMSJ74QvpTdVNRSuo11IRXt2E2oOsBOksy+Goo0=;
	b=BLTf45MfLYRvOcisuhvZ4jRv+NXRuEELLk2vEM/htaQojTZSYKaX1H4iKtxGk4OFXNDm
	 ys5lFBxILO0BpYjUgrPIaCp4RgE9pLwakdcyrElvCSUPkKT133Y/36c/G2wzc0A9yUJVJ
	 65mEKZuQCGdauFOwh/pWgZU0SOGs9XOFc8fBnMkCi+d6HqeyzKmrGWcBdqkOM+M1n8oTy
	 UQ6XRub166tzyRsOCMLmFNNhAnFLgzklvnHQCXa6l8y1DeQIXJ5H/0i3iXzgFmoAv+kZK
	 wDRLQAxo5OxiJjJUD+5ykrsjqLtMAI7q/pfDMMSrIVaENETCh9Kt3wb0OaWpe6jCL0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=el13Ewvz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13CE606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=el13Ewvz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE381F000C1;
	Thu, 22 Oct 2026 09:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792660023;
	bh=rD6igMSJ74QvpTdVNRSuo11IRXt2E2oOsBOksy+Goo0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=el13EwvzuHt44hWnzMzHxxhILfeJSNIr67hJv4n0WRQcDThR4KFpWeZc59sbTotkI
	 CPZIy/bmznMqEGrU1rxPC/qH4JmETnriuRaqSif8aX/Hcj6qyCRwQ5vP+5GcrWgF8+
	 pe2iNIyYfAftXTtPjP4UYNORtGsdL1G2N055qJTMIoXn5D28MoEltfBtiysB52vN4a
	 6sGOgR7IGa/yjacNec+Klyg1BdjzjCHqRkAp0XwIWmsKiSHqFfD8Mp/2x6GFT4Xcaj
	 dqpiPZu/K7f6kT8b0lNG16z58Xjj5Sal2BvAsCs0nv0RrWygbzv5VcwwZJPtnPY3Vw
	 RvcVrvewv8ztQ==
Message-ID: <sashiko-outbox-181234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 2/2] Revert "crypto: qce - Mark QCE as BROKEN"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>, "Bartosz
 Golaszewski" <brgl@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Russell King" <linux@armlinux.org.uk>, "Eric
 Biggers" <ebiggers@kernel.org>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Kuldeep
 Singh" <kuldeep.singh@oss.qualcomm.com>, "Pankaj Patil" <pankaj.patil@oss.qualcomm.com>, "Birk
 Skyum" <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261022-qce-fixes-broken-label-v11-2-0d33c34fd0c3@oss.qualcomm.com>
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <20261022-qce-fixes-broken-label-v11-2-0d33c34fd0c3@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 09:07:02 +0000
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
- [Low] crypto: qce: missing documentation for qcrypto.do_register_algos pa=
rameter
--

commit 7402540901cd549c757f6e4846f133d63cd4febc
Author: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Revert "crypto: qce - Mark QCE as BROKEN"

This commit reverts marking the Qualcomm crypto engine driver as broken now
that self-tests are fixed and algorithm registration is gated behind the
do_register_algos module parameter. It also updates the Kconfig help text to
describe the parameter and re-enables the driver in arm and arm64 defconfig=
s.

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 0189dfdcbbe11..adcbe15851899 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -527,17 +527,21 @@ source "drivers/crypto/marvell/Kconfig"
>  source "drivers/crypto/intel/Kconfig"
> =20
>  config CRYPTO_DEV_QCE
> -	tristate "Qualcomm crypto engine accelerator"
> -	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
> +	tristate "Qualcomm crypto engine offloader"
> +	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on HAS_IOMEM
>  	help
> -	  This driver supports Qualcomm crypto engine accelerator
> -	  hardware. To compile this driver as a module, choose M here. The
> -	  module will be called qcrypto.
> -
> -	  This driver does not have exclusive access to the
> -	  hardware, causing races with the secure world.  It
> -	  is also slower than the CPU.
> +	  This driver supports Qualcomm crypto engine offloader hardware. To
> +	  compile this driver as a module, choose M here. The module will be
> +	  called qcrypto.
> +
> +	  NOTE: With qcrypto.do_register_algos module parameter set to true,
> +	  this driver does not have exclusive access to the hardware, and may
> +	  cause races with the secure world. It is also *slower* than the
> +	  CPU for the same algorithms. By default it will not register crypto
> +	  algorithms and only scale down the interconnect bandwidth and disable
> +	  the relevant clocks. Use qcrypto.do_register_algos=3D1 at your own
> +	  risk!

[Severity: Low]
The help text for CRYPTO_DEV_QCE in drivers/crypto/Kconfig instructs users =
to
pass the qcrypto.do_register_algos=3D1 parameter, which was introduced in
commit 47675c12b3c6 ("crypto: qce - Only register algos if the user really
wants it"):

drivers/crypto/qce/core.c:
    static bool do_register_algos;
    module_param(do_register_algos, bool, 0444);

However, neither commit adds an entry for qcrypto.do_register_algos to
Documentation/admin-guide/kernel-parameters.txt or provides a
MODULE_PARM_DESC() in drivers/crypto/qce/core.c (unlike aes_sw_max_len in
drivers/crypto/qce/skcipher.c).

Should qcrypto.do_register_algos be documented in
Documentation/admin-guide/kernel-parameters.txt and given a
MODULE_PARM_DESC() entry?

> =20
>  config CRYPTO_DEV_QCE_SKCIPHER
>  	bool

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-qce-fixes-=
broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com?part=3D2
