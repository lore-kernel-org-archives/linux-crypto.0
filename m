From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2 v2] talitos: Freescale integrated security engine
 (SEC) driver
Date: Thu, 5 Jun 2008 16:44:15 -0500
Message-ID: <20080605164415.d486a299.kim.phillips@freescale.com>
References: <20080530185830.60f4e1d4.kim.phillips@freescale.com>
	<20080605052224.GA23150@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:40492 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYFEVqc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2008 17:46:32 -0400
In-Reply-To: <20080605052224.GA23150@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 5 Jun 2008 15:22:24 +1000
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, May 30, 2008 at 06:58:30PM -0500, Kim Phillips wrote:
> >
> > +	/* get random IV */
> > +	get_random_bytes(req->giv, crypto_aead_ivsize(authenc));
> 
> Sorry but this is unworkable given our current RNG infrastructure.
> Draining 16 bytes for every packet is going to make /dev/random
> unuseable (if it wasn't already :).

it is :).  I'm working on it :).

> Perhaps just use eseqiv (it should be pretty cheap sinec it just
> tacks on an extra block to the encryption) for now until we have
> a PRNG?

the h/w has a IV out feature we should probably be using.  How about
something like this (UNTESTED):

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index cf2e6f3..5ebb0f1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -566,6 +566,7 @@ struct talitos_ctx {
 	struct device *dev;
 	__be32 desc_hdr_template;
 	u8 key[TALITOS_MAX_KEY_SIZE];
+	u8 iv[TALITOS_AES_IV_LENGTH];
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
@@ -873,8 +874,9 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 	}
 
-	/* optional iv out - entry points use random IVs instead */
-	desc->ptr[6].len = 0;
+	/* iv out */
+	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
+			       DMA_FROM_DEVICE);
 
 	return talitos_submit(dev, desc, callback, areq);
 }
@@ -1020,8 +1022,7 @@ static int aes_cbc_sha1_hmac_authenc_givencrypt(
 	/* set encrypt */
 	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_AESU_ENC;
 
-	/* get random IV */
-	get_random_bytes(req->giv, crypto_aead_ivsize(authenc));
+	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
 
 	return ipsec_esp(edesc, areq, req->giv, req->seq,
 			 ipsec_esp_encrypt_done);
@@ -1081,6 +1082,9 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	/* copy descriptor header template value */
 	ctx->desc_hdr_template = talitos_alg->desc_hdr_template;
 
+	/* random first IV */
+	get_random_bytes(ctx->iv, TALITOS_AES_IV_LENGTH);
+
 	return 0;
 }
 
Kim
