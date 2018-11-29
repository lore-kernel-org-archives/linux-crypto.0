Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:53103 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbeK2Swh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 13:52:37 -0500
Date: Thu, 29 Nov 2018 15:47:56 +0800
From: PanBian <bianpan2016@163.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not free algorithm before using
Message-ID: <20181129074756.GA73370@bp>
Reply-To: PanBian <bianpan2016@163.com>
References: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
 <20181129065711.7renu7xnxzp7sr2d@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129065711.7renu7xnxzp7sr2d@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 29, 2018 at 02:57:11PM +0800, Herbert Xu wrote:
> On Thu, Nov 22, 2018 at 06:00:16PM +0800, Pan Bian wrote:
> > In multiple functions, the algorithm fields are read after its reference
> > is dropped through crypto_mod_put. In this case, the algorithm memory
> > may be freed, resulting in use-after-free bugs. This patch delays the
> > put operation until the algorithm is never used.
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> 
> Patch applied.  Thanks!
> 
> BTW, this problem exists in almost every other skcipher template,
> e.g., in ctr.  Are you working on a fix for them too?

Probably not. Could you please provide patches to fix them?

Thanks,
Pan

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
