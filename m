From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto-caamhash: Fine-tuning for several function implementations
Date: Thu, 22 Sep 2016 18:44:10 +0800
Message-ID: <20160922104410.GE5884@gondor.apana.org.au>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36836 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753122AbcIVKof (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:44:35 -0400
Content-Disposition: inline
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 15, 2016 at 04:36:35PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 15 Sep 2016 16:27:23 +0200
> 
> Some update suggestions were taken into account
> from static source code analysis.
> 
> Markus Elfring (6):
>   Use kmalloc_array() in ahash_setkey()
>   Rename jump labels in ahash_setkey()
>   Rename a jump label in five functions
>   Return a value directly in caam_hash_cra_init()
>   Delete an unnecessary initialisation in seven functions
>   Move common error handling code in two functions
> 
>  drivers/crypto/caam/caamhash.c | 111 +++++++++++++++++++----------------------
>  1 file changed, 52 insertions(+), 59 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
