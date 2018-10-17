Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37472 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeJQORf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:17:35 -0400
Date: Wed, 17 Oct 2018 14:21:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - add SPDX license identifier to all files
Message-ID: <20181017062145.gqfr527xuy3becbm@gondor.apana.org.au>
References: <20181010112648.23054-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181010112648.23054-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 10, 2018 at 02:26:48PM +0300, Horia Geantă wrote:
> Previously, a tree-wide change added SPDX license identifiers to
> files lacking licensing information:
> b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
> 
> To be consistent update the rest of the files:
> -files with license specified by means of MODULE_LICENSE()
> -files with complete license text
> -Kconfig
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/Kconfig        |  1 +
>  drivers/crypto/caam/caamalg.c      |  1 +
>  drivers/crypto/caam/caamalg_desc.c |  1 +
>  drivers/crypto/caam/caamalg_qi.c   |  1 +
>  drivers/crypto/caam/caamhash.c     |  1 +
>  drivers/crypto/caam/caampkc.c      |  1 +
>  drivers/crypto/caam/caamrng.c      |  1 +
>  drivers/crypto/caam/ctrl.c         |  1 +
>  drivers/crypto/caam/jr.c           |  1 +
>  drivers/crypto/caam/sg_sw_qm.h     | 29 +----------------------------
>  drivers/crypto/caam/sg_sw_qm2.h    | 30 +-----------------------------
>  11 files changed, 11 insertions(+), 57 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
