Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474DCECAAD5
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 14:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbiIFOrY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 10:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiIFOqv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 10:46:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCFF9E2F4
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 07:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97F26155D
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 14:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1617C433D6;
        Tue,  6 Sep 2022 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662473136;
        bh=drS0mLtx6beSy7EjFtb0nRfwc3YlIt+GhmVaLJivPbU=;
        h=In-Reply-To:References:Cc:From:Subject:To:Date:From;
        b=LVD9GRTlcZBAVk7G7RKd8aOKygr6rotS9QjCA0CcCGqk9pKm7zgCQSohOj2AtOuVE
         2KWkka1MDpn9GAyFQDWqWTN1W1aJey1q+rhTWCMhCpsldDHpLmZWuY8Oh1coblKrKq
         vOk6xaQNEZ1wMW75MqT/3kT+a9hRxPPIrgym3Q2OCrydMe9xZ8tSicILxL3GzxTmb+
         3yVb5OVup4fkDrofZE862D0nUH0YnfjMoiINKoSNkA9b/qwCPHyXdi5qFSsoa5D6Zq
         dJ/X6vlMvhGHmLvDEOw3/GBz2a8AImc6wxK1FcA3ZDts+Zsk1s+l1xfTVurfpTcQXo
         MzMM8SNa2S0Hw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com> <60cb9b954bb079b1f12379821a64faff00bb368e.1662432407.git.pliem@maxlinear.com>
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 2/2] crypto: inside-secure - Select CRYPTO_AES config
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Message-ID: <166247313358.3585.5988889047992659412@kwain>
Date:   Tue, 06 Sep 2022 16:05:33 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-06 04:51:50)
> CRYPTO_AES is needed for aes-related algo (e.g.
> safexcel-gcm-aes, safexcel-xcbc-aes, safexcel-cmac-aes).
> Without it, we observe failures when allocating transform
> for those algo.
>=20
> Fixes: 363a90c2d517 ("crypto: safexcel/aes - switch to library version of=
 key expansion routine")

The above commit explicitly switched crypto drivers to use the AES
library instead of the generic AES cipher one, which seems like a good
move. What are the issues you're encountering and why the AES lib makes
the driver to fail?

> Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
> ---
> v2:
>  Add fixes tag
>=20
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 3e6aa319920b..b12d222e49a1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -740,6 +740,7 @@ config CRYPTO_DEV_SAFEXCEL
>         select CRYPTO_SHA512
>         select CRYPTO_CHACHA20POLY1305
>         select CRYPTO_SHA3
> +       select CRYPTO_AES
>         help
>           This driver interfaces with the SafeXcel EIP-97 and EIP-197 cry=
ptographic
>           engines designed by Inside Secure. It currently accelerates DES=
, 3DES and
> --=20
> 2.17.1
>=20
