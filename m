Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53044 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbeK2Tdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 14:33:46 -0500
Date: Thu, 29 Nov 2018 16:29:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: PanBian <bianpan2016@163.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not free algorithm before using
Message-ID: <20181129082908.ao3uxs4q5bncbctn@gondor.apana.org.au>
References: <1542880816-63838-1-git-send-email-bianpan2016@163.com>
 <20181129065711.7renu7xnxzp7sr2d@gondor.apana.org.au>
 <20181129074756.GA73370@bp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129074756.GA73370@bp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 29, 2018 at 03:47:56PM +0800, PanBian wrote:
> On Thu, Nov 29, 2018 at 02:57:11PM +0800, Herbert Xu wrote:
> > On Thu, Nov 22, 2018 at 06:00:16PM +0800, Pan Bian wrote:
> > > In multiple functions, the algorithm fields are read after its reference
> > > is dropped through crypto_mod_put. In this case, the algorithm memory
> > > may be freed, resulting in use-after-free bugs. This patch delays the
> > > put operation until the algorithm is never used.
> > > 
> > > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > 
> > Patch applied.  Thanks!
> > 
> > BTW, this problem exists in almost every other skcipher template,
> > e.g., in ctr.  Are you working on a fix for them too?
> 
> Probably not. Could you please provide patches to fix them?

OK, I'll work on it then.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
