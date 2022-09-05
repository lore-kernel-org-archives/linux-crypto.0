Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5776ECAAD5
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 08:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiIEIvo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 04:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiIEIvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 04:51:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6973C17E
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 01:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F107FB80F9B
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 08:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D25EC433D6;
        Mon,  5 Sep 2022 08:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662367899;
        bh=jcrZlJoAva4a/Fg4oyZTqrdZd3rjylPVUASIAKfeIxU=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=MIa0cxo/VuoZXA5VH6ba+4vN2zJ70WrUrIio2Xc07zkdUzw4HlsMJgfAAuI1QEBwO
         529Wg+ZgkH5QgZEOsqFejynXxS8QSt+KgxQubzktcmRk7tRPGmsfEKO0mXUWmpyZLC
         9kTyORUvGCNih2IyE3oEA29n6jTWxqoXNAbfZTxJ0fNxCuXQRjObnyynovaor95K+/
         seRhuHndQuxPXOx5LAoJFHgAX3pqNFuW9a78/SyIzI43/3wT9d2oI/8RPdcTpy9v9Y
         3fR86nVYpszmrQyoTDxg40J/VluN8Wv7E4/MBUjENgQwc1yeHFLlesQricbQLs/zCt
         Q+aI+mza0md0w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ba011c14c0467c094afb062c3fe2cafe16c2b6b0.1662351087.git.pliem@maxlinear.com>
References: <b08e76c7ff0e46e25e21ee0827fcf3b0e94556bf.1662351087.git.pliem@maxlinear.com> <ba011c14c0467c094afb062c3fe2cafe16c2b6b0.1662351087.git.pliem@maxlinear.com>
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 2/2] crypto: inside-secure - Select CRYPTO_AES config
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <166236789651.3222.3650490724066850314@kwain>
Date:   Mon, 05 Sep 2022 10:51:36 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

Quoting Peter Harliman Liem (2022-09-05 06:14:44)
> CRYPTO_AES is needed for aes-related algo (e.g.
> safexcel-gcm-aes, safexcel-xcbc-aes, safexcel-cmac-aes).
> Without it, we observe failures when allocating transform
> for those algo.
>=20
> Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>

This looks like a fix, can you add a Fixes: tag?

Thanks!

> ---
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
