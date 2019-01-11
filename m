Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33214 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfAKGbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:31:32 -0500
Date: Fri, 11 Jan 2019 14:31:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH 0/3] crypto: caam - add support for xcbc(aes)
Message-ID: <20190111063129.2wfbwffeeepwc6l4@gondor.apana.org.au>
References: <20181221155910.6235-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181221155910.6235-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 21, 2018 at 05:59:07PM +0200, Horia Geantă wrote:
> This patch set adds support for xcbc(aes) and improves a few ahash things
> along the way.
> 
> It depends on the following patch:
> [v2] crypto: caam - fix SHA support detection
> https://patchwork.kernel.org/patch/10740373/
> 
> Iuliana Prodan (3):
>   crypto: caam - fix error reporting for caam_hash_alloc
>   crypto: caam - create ahash shared descriptors only once
>   crypto: caam - add support for xcbc(aes)
> 
>  drivers/crypto/caam/caamhash.c      | 199 ++++++++++++++++++++++++++++++++----
>  drivers/crypto/caam/caamhash_desc.c |  58 ++++++++++-
>  drivers/crypto/caam/caamhash_desc.h |   2 +
>  3 files changed, 240 insertions(+), 19 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
