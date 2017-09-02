From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Sat, 02 Sep 2017 23:42:36 +1000
Message-ID: <1504359756.4728.7.camel@neuling.org>
References: <1500699702.23205.8.camel@hbabu-laptop>
         <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com>
         <59AA6E71.8070704@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:54865 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdIBNmi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Sep 2017 09:42:38 -0400
In-Reply-To: <59AA6E71.8070704@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> > > +static int nx842_powernv_crypto_init_vas(struct crypto_tfm *tfm)
> > > +{
> > > +       struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
> > > +       struct nx842_workmem *wmem;
> > > +       struct nx842_coproc *coproc;
> > > +       int ret;
> > > +
> > > +       ret = nx842_crypto_init(tfm, &nx842_powernv_driver);
> > > +
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       wmem = PTR_ALIGN((struct nx842_workmem *)ctx->wmem,
> > > WORKMEM_ALIGN);
> > > +       coproc = per_cpu(coproc_inst, smp_processor_id());
> > 
> > this is wrong.  the crypto transform init function is not guaranteed
> > to be called by the same processor that later uses it.  Just because
> > that happens to be how zswap operates doesn't guarantee other crypto
> > users will do the same.
> 
> Dan, Sorry missed this comment. 
> 
> Right, The actual crypto request can be executed on other processor than the
> CPU when the init is executed. The main goal is open send window on the NX
> engine which is on the same chip for the corresponding CPU. So we are OK if
> the request is scheduled on other CPU as long as it belongs to same chip.
> Otherwise in the worst case we will end up using remote NX.  

You want the NX to be close to the requester CPU, but probably more importantly
you want the NX close to the memory it's going to be operating on. 

Preferably they would all be on the same node.

Mikey 
