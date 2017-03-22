From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead
 when outlen is zero
Date: Wed, 22 Mar 2017 10:57:42 +0800
Message-ID: <20170322025742.GA29214@gondor.apana.org.au>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
 <3894659.2TbsNqkGul@tauon.atsec.com>
 <CAFXBA==5EOXOJV4UFaG+1AxAmuEo9PzFKsHe25YTMa8LGfKkkQ@mail.gmail.com>
 <1593289.epxWzXFfWH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38449 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757932AbdCVDko (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 23:40:44 -0400
Content-Disposition: inline
In-Reply-To: <1593289.epxWzXFfWH@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 21, 2017 at 04:00:04PM +0100, Stephan Müller wrote:
> Am Dienstag, 21. März 2017, 14:23:31 CET schrieb Harsh Jain:
> 
> Hi Harsh,
> 
> > Yes, Driver can figure out when to discard dst SGL but for that Driver
> > has to put checks before accessing dst SGL. Isn't better if AF_ALG
> > sends NULL for dst SGL.
> 
> With the code in [1], the first longer patch is planned to be merged after the 
> memory management changes are agreed upon. That patch contains:
> 
> +               /* chain the areq TX SGL holding the tag with RX SGL */
> +               if (!last_rsgl) {
> +                       /* no RX SGL present (e.g. only authentication) */
> +                       sg_init_table(areq->first_rsgl.sgl.sg, 2);
> +                       sg_chain(areq->first_rsgl.sgl.sg, 2, areq->tsgl);
> +               } else {
> +                       /* RX SGL present */
> +                       struct af_alg_sgl *sgl_prev = &last_rsgl->sgl;
> +
> +                       sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
> +                       sg_chain(sgl_prev->sg, sgl_prev->npages + 1, areq-
> >tsgl);
> +               }
> 
> 
> This code snipped would exactly do what you want: the SGL is always 
> initialized. Besides, the code will do an in-place cipher operation.
> 
> https://www.spinics.net/lists/linux-crypto/msg24343.html

Even if we fix this one user of the crypto API, new users could
still feed you bogus SG lists.  The API does not require the user
to specify a NULL SG list so please fix this in the driver.

We should also strength testmgr so that it provides something
bogus to catch buggy drivers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
