Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913CDC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbiBEEcv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:32:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34040 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355428AbiBEEcv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:32:51 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCkT-00027S-4B; Sat, 05 Feb 2022 15:32:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:32:33 +1100
Date:   Sat, 5 Feb 2022 15:32:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, anoobj@marvell.com,
        Srujana Challa <schalla@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        chiminghao <chi.minghao@zte.com.cn>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: octeontx2: remove CONFIG_DM_CRYPT check
Message-ID: <Yf394bPkveX8ONCk@gondor.apana.org.au>
References: <3ef09bf0c4adf7bc33f01f60cb8ce96e8f77b58c.1642786900.git.sthotton@marvell.com>
 <2ea465e8bde7f4d03757ae398d38f62a350dd28c.1643378034.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea465e8bde7f4d03757ae398d38f62a350dd28c.1643378034.git.sthotton@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 28, 2022 at 07:27:42PM +0530, Shijith Thotton wrote:
> No issues were found while using the driver with dm-crypt enabled. So
> CONFIG_DM_CRYPT check in the driver can be removed.
> 
> This also fixes the NULL pointer dereference in driver release if
> CONFIG_DM_CRYPT is enabled.
> 
> ...
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
> ...
> Call trace:
>  crypto_unregister_alg+0x68/0xfc
>  crypto_unregister_skciphers+0x44/0x60
>  otx2_cpt_crypto_exit+0x100/0x1a0
>  otx2_cptvf_remove+0xf8/0x200
>  pci_device_remove+0x3c/0xd4
>  __device_release_driver+0x188/0x234
>  device_release_driver+0x2c/0x4c
> ...
> 
> Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>
> ---
>  .../crypto/marvell/octeontx2/otx2_cptvf_algs.c  | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
