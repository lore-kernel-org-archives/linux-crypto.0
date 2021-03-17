Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BEFC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 09:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3030B64F42
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 09:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCQJ1W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCQJ1S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 05:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 294A564F30;
        Wed, 17 Mar 2021 09:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615973237;
        bh=ip6giX6MFw06Q/6f5uhRhfXE+WK36my269US56AWXwY=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=sBdkeGjBuxrerAlY0WdGYLEhvUtg/WNdRmdx8wY5Pn/oTaFSC8ByW4HmOXDxWT/v6
         DOqYgLyaQqAHRPohZX7rECAMELSOviC9xhpOU5M56YUthRix1jZ3/zsvAbT2e7JidW
         n5ZTYFc4C7zbAIhWdGQzQwMyfzCPqE1MuxrgLWWfrfnQjDprP1QWWb6u4P68PMYRbq
         IEdHYCyokEA3RzP8Oq5L3dLjePbfEetrPvT6m08WESGI8RMXHk6hm08QCl4qZkYOHF
         hj1xlZXsJksLTS4s7FdHw4mChxC6vlGgyc3M+GaK72Z7D+KwKGcpEOW/aQCZWsnmJ9
         K3y2C27agFK8A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210317091445.614865-1-unixbhaskar@gmail.com>
References: <20210317091445.614865-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH] crypto: inside-secure: Minor typo fix in the file safexcel.c
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Message-ID: <161597323449.3996.8883737542353351988@kwain.local>
Date:   Wed, 17 Mar 2021 10:27:14 +0100
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Bhaskar Chowdhury (2021-03-17 10:14:45)
>=20
> s/procesing/processing/
>=20
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks,
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/ins=
ide-secure/safexcel.c
> index 6364583b88b2..9ff885d50edf 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -688,7 +688,7 @@ static int safexcel_hw_init(struct safexcel_crypto_pr=
iv *priv)
>                 /* Leave the DSE threads reset state */
>                 writel(0, EIP197_HIA_DSE_THR(priv) + EIP197_HIA_DSE_THR_C=
TRL(pe));
>=20
> -               /* Configure the procesing engine thresholds */
> +               /* Configure the processing engine thresholds */
>                 writel(EIP197_PE_OUT_DBUF_THRES_MIN(opbuflo) |
>                        EIP197_PE_OUT_DBUF_THRES_MAX(opbufhi),
>                        EIP197_PE(priv) + EIP197_PE_OUT_DBUF_THRES(pe));
> --
> 2.30.2
>=20
