Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:39090 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbfARUlF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 15:41:05 -0500
Date: Fri, 18 Jan 2019 23:41:00 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qat-linux@intel.com
Subject: Re: [RFC PATCH v2] akcipher: Introduce verify_rsa/verify for public
 key algorithms
Message-ID: <20190118204100.6o3ovctanb62nvd2@altlinux.org>
References: <20190116164703.9267-1-vt@altlinux.org>
 <24887.1547658740@warthog.procyon.org.uk>
 <20190116182719.j6ii6nmn4ciiurqr@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190116182719.j6ii6nmn4ciiurqr@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

David,

On Wed, Jan 16, 2019 at 09:27:19PM +0300, Vitaly Chikunov wrote:
> On Wed, Jan 16, 2019 at 05:12:20PM +0000, David Howells wrote:
> > Umm...  What do I apply this patch to?
> 
> This should go over "crypto: testmgr - split akcipher tests by a key type"
> which I sent at 20190107 to linux-crypto. Sorry for the mess.
> 
> > In your modified public_key_verify_signature():
> > 
> > > -	sg_init_one(&digest_sg, output, outlen);
> > > -	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
> > > +	sg_init_one(&output_sg, output, outlen);
> > > +	akcipher_request_set_crypt(req, &sig_sg, &output_sg, sig->s_size,
> > >  				   outlen);
> > 
> > Why is the output necessary?  It was there for the decoded hash to be placed
> > in prior to comparison - but now that's not necessary.
> 
> Agreed.

I prepared the patch which factors `output' into public_key_verify_signature().

Also, I try to elucidate my arguments below.

> > > -	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
> > > +	ret = crypto_wait_req(crypto_akcipher_verify(req, sig->digest,
> > > +						     sig->digest_size), &cwait);
> > 
> > I see sig->digest is passed in here.  Should it be passed in in place of
> > output_sg above?

In short, it's passed as parameter to not clutter `struct
akcipher_request' and to distinguish it from encrypt/decrypt scatterlists.

New 'verify' op requires very different parameter set than encrypt,
decrypt, sign. This difference is now most illustrative in testmgr (see
in the next patch).

> (I tried different approaches such as passing additional arguments to
> `akcipher_request_set_crypt' or having additional setter like
> `akcipher_request_set_aux' just to set value of digest and that should
> be used just for verify op.)
> 
> I thought passing input parameter in `struct akcipher_request' in the
> field called 'dst' could be confusing for users. So this should be an
> additional parameter in the request which is never used by any other caller.
> Also, it was unknown if this should be scatterlist or not (I choose that
> it should not). When it's separate argument to crypto_akcipher_verify()
> call user is forced to set it, and there is no cluttering of `struct
> akcipher_request' (which is designed to handle just encryption/decryption)
> with not needed auxiliary parameters, and because it's very separated
> from request parameters which all scatterlists and all other calls
> arguments usually are not scatterlists, so this looked like similar
> approach to what others do.
> 
> > > -	inst->alg.verify = pkcs1pad_verify;
> > > +	inst->alg.verify_rsa = pkcs1pad_verify;
> > 
> > Is there a reason that pkcs1pad_verify() can't do the comparison?
> 
> If you agree that we have two callbacks for a full and a partial
> verification (I assume you do), why should pkcs1pad_verify do a full
> verification if it's allowed to do just partial one, and it's RSA
> cipher which have special partial verification designed for them.
> 
> So I decided that pkcs1pad_verify should implement verify_rsa api only
> and this is beneficial for having minimal code change and somewhat
> backward compatible.
> 
> > > -	.verify = rsa_verify,
> > > +	.verify_rsa = rsa_verify,
> > 
> > Likewise verify_rsa()?
> > 
> > Granted, this might involve pkcs1pad_verify() dressing up the signature in the
> > appropriate wrappings and passing it along to verify_rsa() to do the actual
> > comparison there (ie. what pkcs1pad_verify_complete() does).

a) RSA verify works differently (is it just disguised encrypt),
b) We have separate wrapper module for it (pkcs1pad). Thus:

Old API can not be removed. In other words, we can not replace
.verify_rsa with .verify in these drivers or PKCS1 will not work.

We can replace .verify_rsa with .verify in pkcs1pad, but there is no
need for that if we stay with two API calls, which we can't avoid.

> If we stay with the two api calls (verify and verify_rsa) pkcs1pad_verify
> does not need to do any verification leaving it to the akcipher core.
> 
> There is only potential "problem" that pkcs1pad code will not be able to
> use other akciphers besides rsa family (implementing only verify_rsa),
> but I assumed this is not needed (since only RSA is actually using
> PKCS1) and maybe even beneficial restriction.
> 
> > > -	.verify = caam_rsa_enc,
> > > +	.verify_rsa = caam_rsa_enc,
> > 
> > I presume this is the reason - because this reuses its encrypt operation
> > directly.  But could this instead perform the comparison upon completion, say
> > in rsa_pub_done()?

No, or pkcs1pad will not work.

Thanks,

> > 
> > > -	.verify = qat_rsa_enc,
> > > +	.verify_rsa = qat_rsa_enc,
> > 
> > Again, this could do the comparison, say, in qat_rsa_cb().
> 
> Abandoning idea with two api calls (full verify and partial verify_rsa)
> will require me to modify code for all these drivers for devices that I
> don't have and can't test. So, I choose approach with less new code.
> 
> If you think that partial verify api should be completely removed that
> change will require much bigger rework. Please tell if you would prefer
> that.
> 
> Thanks,
