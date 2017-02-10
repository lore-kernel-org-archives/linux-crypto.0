From: "weiyongjun (A)" <weiyongjun1@huawei.com>
Subject: RE: [PATCH -next] crypto: asymmetric_keys - Fix error return code
 on failure
Date: Fri, 10 Feb 2017 02:11:26 +0000
Message-ID: <6AADFAC011213A4C87B956458587ADB475DC1D@SZXEMI508-MBX.china.huawei.com>
References: <20170209155724.19737-1-weiyj.lk@gmail.com>
 <27512.1486659476@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>,
        Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:59743 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdBJCRw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 21:17:52 -0500
In-Reply-To: <27512.1486659476@warthog.procyon.org.uk>
Content-Language: zh-CN
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

> > --- a/crypto/asymmetric_keys/public_key.c
> > +++ b/crypto/asymmetric_keys/public_key.c
> > @@ -184,8 +184,10 @@ static int software_key_eds_op(struct
> kernel_pkey_params *params,
> >  		return PTR_ERR(tfm);
> >
> >  	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> > -	if (!req)
> > +	if (!req) {
> > +		ret = -ENOMEM;
> 
> Ummm...  What should I apply your patch to?

This one introduced by patch " KEYS: Implement encrypt, decrypt and sign for software asymmetric key".

> 
> >  		goto error_free_tfm;
> > +	}
> >
> >  	if (pkey->key_is_private)
> >  		ret = crypto_akcipher_set_priv_key(tfm,
> > @@ -268,8 +270,10 @@ int public_key_verify_signature(const struct
> public_key *pkey,
> >  		return PTR_ERR(tfm);
> >
> >  	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> > -	if (!req)
> > +	if (!req) {
> > +		ret = -ENOMEM;
> >  		goto error_free_tfm;
> 
> This shouldn't be necessary.  ret should already be -ENOMEM from
> initialisation of the variable at the top of the function.

Introduced by patch " KEYS: Provide software public key query function", ret have
been overwritten to 0 after ret = software_key_determine_akcipher(...).

Regards,
Wei Yongjun
