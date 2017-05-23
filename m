From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/9] crypto: add HMAC IPAD/OPAD constant
Date: Tue, 23 May 2017 13:03:45 +0800
Message-ID: <20170523050345.GF17569@gondor.apana.org.au>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.lendacky@amd.com, gary.hook@amd.com,
        boris.brezillon@free-electrons.com, arno@natisbad.org,
        matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
        salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:48018 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752380AbdEWFEO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 01:04:14 -0400
Content-Disposition: inline
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 19, 2017 at 08:53:22AM +0200, Corentin Labbe wrote:
> Hello
> 
> Many HMAC users directly use directly 0x36/0x5c values.
> It's better with crypto to use a name instead of directly some crypto constant.
> 
> Changes since v1:
> - Moved constant to include/crypto/hmac.h
> - Added <crypto/hmac.h> to includes
> 
> Corentin Labbe (9):
>   crypto: add hmac IPAD/OPAD constant
>   crypto: brcm - Use IPAD/OPAD constant
>   crypto: ixp4xx - Use IPAD/OPAD constant
>   crypto: marvell - Use IPAD/OPAD constant
>   crypto: mv_cesa - Use IPAD/OPAD constant
>   crypto: omap-sham - Use IPAD/OPAD constant
>   crypto: qat - Use IPAD/OPAD constant
>   crypto: mediatek - Use IPAD/OPAD constant
>   crypto: ccp - Use IPAD/OPAD constant

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
