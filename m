Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43264 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbeKWNSp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 08:18:45 -0500
Date: Fri, 23 Nov 2018 10:36:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: PanBian <bianpan2016@163.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not free algorithm before using
Message-ID: <20181123023625.oguwfmhhi2su6etr@gondor.apana.org.au>
References: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
 <20181122144441.tkfmrq3lzibq2g3y@gondor.apana.org.au>
 <20181123010555.GA83154@bp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181123010555.GA83154@bp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 23, 2018 at 09:05:55AM +0800, PanBian wrote:
>
> Thanks for your explanation! But I find that the function
> crypto_init_spawn just lets spawn->alg point to the algorithm without 
> increasing the reference count, i.e., alg->cra_refcnt. So I am confused
> about how this can protect the algorithm from being freed. Maybe I
> missed some key points. Could you please explain it in more details?

Oh you're right! This bug was introduced during the skcipher
conversion.  The spawns are not meant to carry a reference count
with them because they are not supposed to stop the underlying
algorithm from being removed.  So yes we do need to hold a reference
count on alg until the instance is registered.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
