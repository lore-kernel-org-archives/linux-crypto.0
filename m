Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbfAPRM1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 12:12:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190116164703.9267-1-vt@altlinux.org>
References: <20190116164703.9267-1-vt@altlinux.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: dhowells@redhat.com, Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qat-linux@intel.com
Subject: Re: [RFC PATCH v2] akcipher: Introduce verify_rsa/verify for public key algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24886.1547658740.1@warthog.procyon.org.uk>
Date: Wed, 16 Jan 2019 17:12:20 +0000
Message-ID: <24887.1547658740@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Umm...  What do I apply this patch to?

In your modified public_key_verify_signature():

> -	sg_init_one(&digest_sg, output, outlen);
> -	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
> +	sg_init_one(&output_sg, output, outlen);
> +	akcipher_request_set_crypt(req, &sig_sg, &output_sg, sig->s_size,
>  				   outlen);

Why is the output necessary?  It was there for the decoded hash to be placed
in prior to comparison - but now that's not necessary.

> -	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
> +	ret = crypto_wait_req(crypto_akcipher_verify(req, sig->digest,
> +						     sig->digest_size), &cwait);

I see sig->digest is passed in here.  Should it be passed in in place of
output_sg above?

> -	inst->alg.verify = pkcs1pad_verify;
> +	inst->alg.verify_rsa = pkcs1pad_verify;

Is there a reason that pkcs1pad_verify() can't do the comparison?

> -	.verify = rsa_verify,
> +	.verify_rsa = rsa_verify,

Likewise verify_rsa()?

Granted, this might involve pkcs1pad_verify() dressing up the signature in the
appropriate wrappings and passing it along to verify_rsa() to do the actual
comparison there (ie. what pkcs1pad_verify_complete() does).

> -	.verify = caam_rsa_enc,
> +	.verify_rsa = caam_rsa_enc,

I presume this is the reason - because this reuses its encrypt operation
directly.  But could this instead perform the comparison upon completion, say
in rsa_pub_done()?

> -	.verify = qat_rsa_enc,
> +	.verify_rsa = qat_rsa_enc,

Again, this could do the comparison, say, in qat_rsa_cb().

David
