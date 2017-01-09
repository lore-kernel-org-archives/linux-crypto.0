From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 11/12] crypto: atmel-authenc: add support to authenc(hmac(shaX),Y(aes)) modes
Date: Mon, 09 Jan 2017 19:34:36 +0100
Message-ID: <1593848.VVZBeNLOu9@tauon.atsec.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com> <1548507.knvAQkH9bK@tauon.atsec.com> <6301d79c-f1c5-d86c-823c-dfdbb5100e74@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@atmel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6301d79c-f1c5-d86c-823c-dfdbb5100e74@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 9. Januar 2017, 19:24:12 CET schrieb Cyrille Pitchen:

Hi Cyrille,

> >> +static int atmel_aes_authenc_copy_assoc(struct aead_request *req)
> >> +{
> >> +	size_t buflen, assoclen = req->assoclen;
> >> +	off_t skip = 0;
> >> +	u8 buf[256];
> >> +
> >> +	while (assoclen) {
> >> +		buflen = min_t(size_t, assoclen, sizeof(buf));
> >> +
> >> +		if (sg_pcopy_to_buffer(req->src, sg_nents(req->src),
> >> +				       buf, buflen, skip) != buflen)
> >> +			return -EINVAL;
> >> +
> >> +		if (sg_pcopy_from_buffer(req->dst, sg_nents(req->dst),
> >> +					 buf, buflen, skip) != buflen)
> >> +			return -EINVAL;
> >> +
> >> +		skip += buflen;
> >> +		assoclen -= buflen;
> >> +	}
> > 
> > This seems to be a very expansive operation. Wouldn't it be easier, leaner
> > and with one less memcpy to use the approach of
> > crypto_authenc_copy_assoc?
> > 
> > Instead of copying crypto_authenc_copy_assoc, what about carving the logic
> > in crypto/authenc.c out into a generic aead helper code as we need to add
> > that to other AEAD implementations?
> 
> Before writing this function, I checked how the crypto/authenc.c driver
> handles the copy of the associated data, hence crypto_authenc_copy_assoc().
> 
> I have to admit I didn't perform any benchmark to compare the two
> implementation but I just tried to understand how
> crypto_authenc_copy_assoc() works. At the first look, this function seems
> very simple but I guess all the black magic is hidden by the call of
> crypto_skcipher_encrypt() on the default null transform, which is
> implemented using the ecb(cipher_null) algorithm.

The magic in the null cipher is that it not only performs a memcpy, but 
iterates through the SGL and performs a memcpy on each part of the source/
destination SGL.

I will release a patch set later today -- the coding is completed, but testing 
is yet under way. That patch now allows you to make only one function call 
without special init/deinit code.
> 
> When I wrote my function I thought that this ecb(cipher_null) algorithm was
> implemented by combining crypto_ecb_crypt() from crypto/ecb.c with
> null_crypt() from crypto/crypto_null.c. Hence I thought there would be much
> function call overhead to copy only few bytes but now checking again I
> realize that the ecb(cipher_null) algorithm is directly implemented by
> skcipher_null_crypt() still from crypto/crypto_null.c. So yes, maybe you're
> right: it could be better to reuse what was done in
> crypto_authenc_copy_assoc() from crypto/authenc.c.
> 
> This way we could need twice less memcpy() hence I agree with you.

In addition to the additional memcpy, the patch I want to air shortly (and 
which I hope is going to be accepted) should reduce the complexity of your 
code in this corner.

...

> >> +static int atmel_aes_authenc_crypt(struct aead_request *req,
> >> +				   unsigned long mode)
> >> +{
> >> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> >> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> >> +	struct atmel_aes_base_ctx *ctx = crypto_aead_ctx(tfm);
> >> +	u32 authsize = crypto_aead_authsize(tfm);
> >> +	bool enc = (mode & AES_FLAGS_ENCRYPT);
> >> +	struct atmel_aes_dev *dd;
> >> +
> >> +	/* Compute text length. */
> >> +	rctx->textlen = req->cryptlen - (enc ? 0 : authsize);
> > 
> > Is there somewhere a check that authsize is always < req->cryptlen (at
> > least it escaped me)? Note, this logic will be exposed to user space
> > which may do funky things.
> 
> I thought those 2 sizes were always set by the kernel only but I admit I
> didn't check my assumption. If you tell me they could be set directly from
> the userspace, yes I agree with you, I need to add a test.

Then I would like to ask you adding that check -- as this check is cheap, it 
should not affect performance.
Ciao
Stephan
