From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 4/8] crypto: KPP - add API crypto_kpp_set_params
Date: Thu, 20 Apr 2017 09:29:20 +0200
Message-ID: <1605315.3uzyJ0cJt4@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de> <4927943.K0bBmtyjOX@positron.chronox.de> <309B30E91F5E2846B79BD9AA9711D031AC232A@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59018 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966714AbdDTH3X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 03:29:23 -0400
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D031AC232A@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 19. April 2017, 16:51:54 CEST schrieb Benedetto, Salvatore:

Hi Salvatore,

> Hi Stephan,
> 
> > -----Original Message-----
> > From: keyrings-owner@vger.kernel.org [mailto:keyrings-
> > owner@vger.kernel.org] On Behalf Of Stephan Müller
> > Sent: Wednesday, April 19, 2017 12:06 AM
> > To: linux-crypto@vger.kernel.org
> > Cc: keyrings@vger.kernel.org
> > Subject: [PATCH 4/8] crypto: KPP - add API crypto_kpp_set_params
> > 
> > KPP mechanisms like DH require a parameter set to be provided by the
> > caller. That parameter set may be provided by the crypto_kpp_set_secret
> > function. Yet, the parameters hare handled independently from the secret
> > key which implies that they should be able to be set independently from
> > the key.
> > 
> > The new API allows KPP mechanisms to register a callback allowing to set
> > such parameters.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> > 
> >  Documentation/crypto/api-kpp.rst |  2 +-
> >  include/crypto/kpp.h             | 28 ++++++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/crypto/api-
> > kpp.rst
> > index 7d86ab9..7b2c0d4 100644
> > --- a/Documentation/crypto/api-kpp.rst
> > +++ b/Documentation/crypto/api-kpp.rst
> > @@ -11,7 +11,7 @@ Key-agreement Protocol Primitives (KPP) Cipher API
> > 
> >     :doc: Generic Key-agreement Protocol Primitives API
> >  
> >  .. kernel-doc:: include/crypto/kpp.h
> > 
> > -   :functions: crypto_alloc_kpp crypto_free_kpp crypto_kpp_set_secret
> > crypto_kpp_generate_public_key crypto_kpp_compute_shared_secret
> > crypto_kpp_maxsize
> > +   :functions: crypto_alloc_kpp crypto_free_kpp crypto_kpp_set_params
> > + crypto_kpp_set_secret crypto_kpp_generate_public_key
> > + crypto_kpp_compute_shared_secret crypto_kpp_maxsize
> > 
> >  Key-agreement Protocol Primitives (KPP) Cipher Request Handle
> >  -------------------------------------------------------------
> > 
> > diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h index
> > ce8e1f7..5931364 100644
> > --- a/include/crypto/kpp.h
> > +++ b/include/crypto/kpp.h
> > @@ -51,6 +51,9 @@ struct crypto_kpp {
> > 
> >  /**
> >  
> >   * struct kpp_alg - generic key-agreement protocol primitives
> >   *
> > 
> > + * @set_params:	Function allows the caller to set the parameters
> > + *			separately from the key. The format of the
> > parameters
> > + *			is protocol specific.
> > 
> >   * @set_secret:		Function invokes the protocol specific
> > 
> > function to
> > 
> >   *			store the secret private key along with parameters.
> >   *			The implementation knows how to decode thie
> > 
> > buffer
> > @@ -74,6 +77,8 @@ struct crypto_kpp {
> > 
> >   * @base:		Common crypto API algorithm data structure
> >   */
> >  
> >  struct kpp_alg {
> > 
> > +	int (*set_params)(struct crypto_kpp *tfm, const void *buffer,
> > +			  unsigned int len);
> > 
> >  	int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
> >  	
> >  			  unsigned int len);
> >  	
> >  	int (*generate_public_key)(struct kpp_request *req); @@ -259,6
> > 
> > +264,29 @@ struct kpp_secret {  };
> > 
> >  /**
> > 
> > + * crypto_kpp_set_params() - Set parameters needed for kpp operation
> > + *
> > + * Function invokes the specific kpp operation for a given alg.
> > + *
> > + * @tfm:	tfm handle
> > + * @buffer:	Buffer holding the protocol specific representation of the
> > + *		parameters (e.g. PKCS#3 DER for DH)
> > + * @len:	Length of the parameter buffer.
> > + *
> > + * Return: zero on success; error code in case of error  */ static
> > +inline int crypto_kpp_set_params(struct crypto_kpp *tfm,
> > +				        const void *buffer, unsigned int len) {
> > +	struct kpp_alg *alg = crypto_kpp_alg(tfm);
> > +
> > +	if (alg->set_params)
> > +		return alg->set_params(tfm, buffer, len);
> > +	else
> > +		return -EOPNOTSUPP;
> > +}
> > +
> > +/**
> > 
> >   * crypto_kpp_set_secret() - Invoke kpp operation
> >   *
> >   * Function invokes the specific kpp operation for a given alg.
> > 
> > --
> > 2.9.3
> 
> I'm not really in favor of having two ways for setting the params.

I am in full agreement. But setting the key together with the parameters is 
not good, IMHO. Every other crypto lib implements a separate setting.

> As you are probably aware, PKCS3 and set_params was my intial
> approach, but then Herbert suggested a lighter approach like rtnetlink
> which I actually prefer.

I was not aware of that. Considering that PKCS#3 or X9.42 are the common 
formats for setting parameters, I am not in favor of "inventing" a special 
format just for the kernel user space interface. If we would have such special 
format, user space would need to add a conversion step from a common to the 
kernel-special format.

You see with https://github.com/smuellerDD/libkcapi/blob/kpp/test/kcapi-main.c 
starting at line 2500 a full description how the OpenSSL-generated DH 
parameters can be used directly by the AF_ALG interface.

I have no concern to use rtnetlink for in-kernel use cases.
> 
> Can't you expose that through AF_ALG?

As mentioned, exposing rtnetlink means that we have to have an ASN.1-based 
converter from PKCS#3 to rtnetlink. As the kernel already has an ASN.1 parser 
and the additional code to use PKCS#3 in the kernel is very minimal compared 
to adding a ASN.1 parser in user space, I opted for implementing PKCS#3 in 
kernel space.
> 
> Regards,
> Salvatore


Ciao
Stephan
