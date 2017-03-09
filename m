From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 9 Mar 2017 18:05:54 +0800
Message-ID: <20170309100554.GA6945@gondor.apana.org.au>
References: <13406914.zeok8basum@positron.chronox.de>
 <20170309100011.GA6844@gondor.apana.org.au>
 <78373946.kaJU5cUr5f@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52627 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754393AbdCIKGd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:06:33 -0500
Content-Disposition: inline
In-Reply-To: <78373946.kaJU5cUr5f@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 09, 2017 at 11:02:41AM +0100, Stephan Müller wrote:
>
> > > The patch 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch
> > > simply copies the AAD over from TX SGL to RX SGL. The pro is that the
> > > patch is small. The con is that this approach does *not* provide an
> > > in-place crypto operation.
> > 
> > I prefer this patch with the proviso that it copy the whole thing
> > instead of just the AD.  That way you can just feed the dst memory
> > to crypto_aead for in-place operation.  Of course you have to mangle
> > the tag data onto the dst SG list for decryption but it shouldn't
> > be too hard.
> 
> I thought that is exactly the second patch. It copies the entire data to the 
> dst SGL and extends the SGL with the tag in case of decryption.

Are you sure? The patch says:

+       /* copy AAD from src to dst */
+       err = crypto_aead_copy_sgl(ctx->null, areq->tsgl,
+                                  areq->first_rsgl.sgl.sg, ctx->aead_assoclen);

Which seems to only copy the AD.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
