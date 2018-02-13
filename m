From: Dave Watson <davejwatson@fb.com>
Subject: Re: [PATCH 14/14] x86/crypto: aesni: Update aesni-intel_glue to use
 scatter/gather
Date: Tue, 13 Feb 2018 10:42:21 -0800
Message-ID: <20180213184221.GB2122@davejwatson-mba.local>
References: <cover.1518211765.git.davejwatson@fb.com>
 <20180212195128.GA61087@davejwatson-mba.local>
 <54235286.FU8BX9VrCl@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54235286.FU8BX9VrCl@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/13/18 08:42 AM, Stephan Mueller wrote:
> > +static int gcmaes_encrypt_sg(struct aead_request *req, unsigned int
> > assoclen, +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> > +{
> > +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> > +	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
> > +	struct gcm_context_data data AESNI_ALIGN_ATTR;
> > +	struct scatter_walk dst_sg_walk = {};
> > +	unsigned long left = req->cryptlen;
> > +	unsigned long len, srclen, dstlen;
> > +	struct scatter_walk src_sg_walk;
> > +	struct scatterlist src_start[2];
> > +	struct scatterlist dst_start[2];
> > +	struct scatterlist *src_sg;
> > +	struct scatterlist *dst_sg;
> > +	u8 *src, *dst, *assoc;
> > +	u8 authTag[16];
> > +
> > +	assoc = kmalloc(assoclen, GFP_ATOMIC);
> > +	if (unlikely(!assoc))
> > +		return -ENOMEM;
> > +	scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);
> 
> Have you tested that this code does not barf when assoclen is 0?
> 
> Maybe it is worth while to finally add a test vector to testmgr.h which 
> validates such scenario. If you would like, here is a vector you could add to 
> testmgr:
> 
> https://github.com/smuellerDD/libkcapi/blob/master/test/test.sh#L315

I tested assoclen and cryptlen being 0 and it works, yes.  Both
kmalloc and scatterwalk_map_and_copy work correctly with 0 assoclen.

> This is a decryption of gcm(aes) with no message, no AAD and just a tag. The 
> result should be EBADMSG.
> > +
> > +	src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
> 
> Why do you use assoclen in the map_and_copy, and req->assoclen in the ffwd?

If I understand correctly, rfc4106 appends extra data after the assoc.
assoclen is the real assoc length, req->assoclen is assoclen + the
extra data length.  So we ffwd by req->assoclen in the scatterlist,
but use assoclen when memcpy and testing.

> > 
> > +static int gcmaes_decrypt_sg(struct aead_request *req, unsigned int
> > assoclen, +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> > +{
> 
> This is a lot of code duplication.

I will merge them and send a V2.

> Ciao
> Stephan
> 
> 

Thanks!
