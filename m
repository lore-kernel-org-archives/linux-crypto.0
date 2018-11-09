Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37414 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbeKITdz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:33:55 -0500
Date: Fri, 9 Nov 2018 17:54:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
Message-ID: <20181109095401.aof4j52ootfac5mr@gondor.apana.org.au>
References: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 04, 2018 at 10:05:24AM +0000, Gilad Ben-Yossef wrote:
> As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
> allowed as a FIPS mode algorithm. Mark it as such.
> 
> [1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  crypto/testmgr.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
