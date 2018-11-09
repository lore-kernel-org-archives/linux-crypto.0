Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37380 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbeKITcE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:32:04 -0500
Date: Fri, 9 Nov 2018 17:52:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
Message-ID: <20181109095214.mywstlubhttfgsc3@gondor.apana.org.au>
References: <20181019230153.28201-1-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181019230153.28201-1-dbaryshkov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 20, 2018 at 02:01:52AM +0300, Dmitry Eremin-Solenikov wrote:
> crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream with
> IV, rather than with data stream, resulting in incorrect decryption.
> Test vectors will be added in the next patch.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  crypto/cfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
