Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33188 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfAKG1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:27:45 -0500
Date: Fri, 11 Jan 2019 14:27:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH RESEND] crypto: caam - move shared symbols in a common
 location
Message-ID: <20190111062721.47a52keto3u6jfdi@gondor.apana.org.au>
References: <20190110135812.12457-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190110135812.12457-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2019 at 03:58:12PM +0200, Horia Geantă wrote:
> There are several issues with symbols shared b/w:
> -caam/jr and caam/qi drivers on one hand
> -caam/qi2 driver on the other hand
> 
> Commit 52813ab24959 ("crypto: caam/qi2 - avoid double export") fixed
> some of them, however compilation still fails for CRYPTO_DEV_FSL_CAAM=m
> and CRYPTO_DEV_FSL_DPAA2_CAAM=y.
> 
> Another issue is related to dependency cycles reported by depmod when
> CRYPTO_DEV_FSL_CAAM=n and CRYPTO_DEV_FSL_DPAA2_CAAM=m, as mentioned in
> 82c7b351be3f ("Revert "arm64: defconfig: Enable FSL_MC_BUS and FSL_MC_DPIO"")
> 
> To fix all these, move the symbols shared by these drivers in a common
> location. The only existing possibility is error.c file (note that naming
> doesn't help and should probably change).
> 
> Fixes: 52813ab24959 ("crypto: caam/qi2 - avoid double export")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
> 
> Resending to fix patchwork tracking.
> Initial submission done inline here:
> https://patchwork.kernel.org/patch/10739071/
> 
>  drivers/crypto/caam/caamalg_qi2.c | 7 -------
>  drivers/crypto/caam/ctrl.c        | 4 ----
>  drivers/crypto/caam/error.c       | 6 ++++++
>  3 files changed, 6 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
