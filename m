Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37572 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQ1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:27:09 -0500
Date: Fri, 16 Nov 2018 14:16:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecc - check for invalid values in the key
 verification test
Message-ID: <20181116061601.zagzxvsoc6why5ep@gondor.apana.org.au>
References: <20181105083618.29102-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105083618.29102-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 05, 2018 at 11:36:18AM +0300, Vitaly Chikunov wrote:
> Currently used scalar multiplication algorithm (Matthieu Rivain, 2011)
> have invalid values for scalar == 1, n-1, and for regularized version
> n-2, which was previously not checked. Verify that they are not used as
> private keys.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/ecc.c | 42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
