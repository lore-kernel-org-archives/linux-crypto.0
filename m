From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC] how to handle AAD copy operation for algif_aead
Date: Thu, 09 Mar 2017 11:08:32 +0100
Message-ID: <9194388.iDFJIB4SCo@tauon.atsec.com>
References: <13406914.zeok8basum@positron.chronox.de> <78373946.kaJU5cUr5f@tauon.atsec.com> <20170309100554.GA6945@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57950 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753528AbdCIKXT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 05:23:19 -0500
In-Reply-To: <20170309100554.GA6945@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. März 2017, 11:05:54 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 09, 2017 at 11:02:41AM +0100, Stephan Müller wrote:
> > > > The patch
> > > > 0001-crypto-algif_aead-copy-AAD-from-src-to-dst_separate.patch
> > > > simply copies the AAD over from TX SGL to RX SGL. The pro is that the
> > > > patch is small. The con is that this approach does *not* provide an
> > > > in-place crypto operation.
> > > 
> > > I prefer this patch with the proviso that it copy the whole thing
> > > instead of just the AD.  That way you can just feed the dst memory
> > > to crypto_aead for in-place operation.  Of course you have to mangle
> > > the tag data onto the dst SG list for decryption but it shouldn't
> > > be too hard.
> > 
> > I thought that is exactly the second patch. It copies the entire data to
> > the dst SGL and extends the SGL with the tag in case of decryption.
> 
> Are you sure? The patch says:
> 
> +       /* copy AAD from src to dst */
> +       err = crypto_aead_copy_sgl(ctx->null, areq->tsgl,
> +                                  areq->first_rsgl.sgl.sg,
> ctx->aead_assoclen);
> 
> Which seems to only copy the AD.

This is the first patch (0001-crypto-algif_aead-copy-AAD-from-src-to-
dst_separate.patch).

The second alternative patch (0001-crypto-algif_aead-copy-AAD-from-src-to-
dst_inplace.patch) does:

+	if (ctx->enc) {
+		/* Copy AAD || PT to RX SGL buffer for in-place operation. */
+		err = crypto_aead_copy_sgl(ctx->null, tsgl->sg,
+					   areq->first_rsgl.sgl.sg, processed);
+		if (err)
+			goto free;
+		aead_pull_tsgl(sk, processed, NULL, 0);
+	} else {
+		/* Copy AAD || CT to RX SGL buffer for in-place operation. */
+		err = crypto_aead_copy_sgl(ctx->null, tsgl->sg,
+					   areq->first_rsgl.sgl.sg, outlen);
+		if (err)
+			goto free;
+
+		/* Create TX SGL for tag and chain it to RX SGL. */
+		areq->tsgl_entries = aead_count_tsgl(sk, processed);
+		if (!areq->tsgl_entries)
+			areq->tsgl_entries = 1;
+		areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) *
+					      areq->tsgl_entries,
+					  GFP_KERNEL);
+		if (!areq->tsgl) {
+			err = -ENOMEM;
+			goto free;
+		}
+		sg_init_table(areq->tsgl, areq->tsgl_entries);
+
+		/* Release TX SGL, except for tag data. */
+		aead_pull_tsgl(sk, processed, areq->tsgl, processed - as);
+
+		/* chain the areq TX SGL holding the tag with RX SGL */
+		if (!last_rsgl) {
+			/* no RX SGL present (e.g. only authentication) */
+			sg_init_table(areq->first_rsgl.sgl.sg, 2);
+			sg_chain(areq->first_rsgl.sgl.sg, 2, areq->tsgl);
+		} else {
+			/* RX SGL present */
+			struct af_alg_sgl *sgl_prev = &last_rsgl->sgl;
+
+			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
+			sg_chain(sgl_prev->sg, sgl_prev->npages + 1, areq->tsgl);
+		}
 	}

Ciao
Stephan
