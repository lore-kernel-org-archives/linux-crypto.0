Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33224 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfAKGbk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:31:40 -0500
Date: Fri, 11 Jan 2019 14:31:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto4xx: add prng crypto support
Message-ID: <20190111063138.mkzbe4exdbuahick@gondor.apana.org.au>
References: <20181223011613.24145-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181223011613.24145-1-chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 23, 2018 at 02:16:13AM +0100, Christian Lamparter wrote:
> This patch adds support for crypto4xx's ANSI X9.17 Annex C compliant
> pseudo random number generator which provides a pseudo random source
> for the purpose of generating  Initialization Vectors (IV's) for AES
> algorithms to the Packet Engine and other pseudo random number
> requirements.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c    | 87 +++++++++++++++++++++++++
>  drivers/crypto/amcc/crypto4xx_core.h    |  4 ++
>  drivers/crypto/amcc/crypto4xx_reg_def.h |  1 +
>  3 files changed, 92 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
