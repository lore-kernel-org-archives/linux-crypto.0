Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59498 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfAJNKP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 08:10:15 -0500
Date: Thu, 10 Jan 2019 21:09:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/qi2 - add a CRYPTO_DEV_FSL_CAAM dependency
Message-ID: <20190110130956.j7nitx5sw2xgr3pc@gondor.apana.org.au>
References: <20181220152815.3613164-1-arnd@arndb.de>
 <VI1PR0402MB3485B39F40CFFDED08D8701698BF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485B39F40CFFDED08D8701698BF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 20, 2018 at 09:27:16PM +0000, Horia Geanta wrote:
>
> This indeed solves the issue, but as you mentioned won't allow for
> CRYPTO_DEV_FSL_DPAA2_CAAM=y when CRYPTO_DEV_FSL_CAAM=m.
> 
> I think a better solution is the following:
> 
> -- >8 --
> Subject: [PATCH] crypto: caam - move shared symbols in a common location

Hi Horia:

Please resend this patch with a new Subject line as patchwork
no longer tracks patches sent in reply to existing patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
