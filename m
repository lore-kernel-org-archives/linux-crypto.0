From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: caam - IV source for IPsec decryption
Date: Fri, 26 Aug 2016 19:39:04 +0800
Message-ID: <20160826113904.GD20096@gondor.apana.org.au>
References: <DB4PR04MB0847411DA278511045969E6998ED0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55047 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbcHZLjM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2016 07:39:12 -0400
Content-Disposition: inline
In-Reply-To: <DB4PR04MB0847411DA278511045969E6998ED0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 25, 2016 at 04:12:35PM +0000, Horia Ioan Geanta Neag wrote:
> Herbert,
> 
> Commits
> 7021b2e1cddd "esp4: Switch to new AEAD interface"
> 000ae7b2690e "esp6: Switch to new AEAD interface"
> removed the following:
> 	/* Get ivec. This can be wrong, check against another impls. */
> 	iv = esph->enc_data;
> from IPsec decryption - esp{4,6}_input(),
> so the IV in req->iv received by the implementer is no longer valid.
> 
> Thus, the load of IV in caam driver - caamalg.c, init_authenc_job():
>         if (ivsize && (is_rfc3686 || !(alg->caam.geniv && encrypt)))
>                 append_load_as_imm(desc, req->iv, ivsize,
>                                    LDST_CLASS_1_CCB |
>                                    LDST_SRCDST_BYTE_CONTEXT |
>                                    (ivoffset << LDST_OFFSET_SHIFT));
> is not suited for case mentioned above.
> 
> Instead, the IV should be read from the req->src scatterlist
> (which consists of assoc data, iv, ciphertext).
> Please let me know if this is accurate, so I could prepare a fix.

For authenc req->iv will be set by echainiv.  But yes I seem to
have screwed this up for the echainiv ones in caam.  You need to
change aead_givdecrypt to set req->iv.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
