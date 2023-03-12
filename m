Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0044DC6FD1F
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Mar 2023 07:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCLH1a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Mar 2023 03:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLH13 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Mar 2023 03:27:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE05F574C2;
        Sat, 11 Mar 2023 23:27:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pbG6o-003DeW-Er; Sun, 12 Mar 2023 15:27:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Mar 2023 15:27:10 +0800
Date:   Sun, 12 Mar 2023 15:27:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Demote BUG_ON() in crypto_unregister_alg() to a
 WARN_ON()
Message-ID: <ZA1+zr0NapJlsKk9@gondor.apana.org.au>
References: <20230311162513.6746-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230311162513.6746-1-toke@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 11, 2023 at 05:25:12PM +0100, Toke Høiland-Jørgensen wrote:
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index d08f864f08be..e9954fcb61be 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -493,7 +493,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
>  	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
>  		return;
>  
> -	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
> +	WARN_ON(refcount_read(&alg->cra_refcnt) != 1);

I think we should return here instead of continuing to destroy
the algorithm since we know that it's still in use.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
