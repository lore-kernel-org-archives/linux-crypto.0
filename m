From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH -next] crypto: asymmetric_keys - Fix error return code on failure
Date: Thu, 09 Feb 2017 16:57:56 +0000
Message-ID: <27512.1486659476@warthog.procyon.org.uk>
References: <20170209155724.19737-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Wei Yongjun <weiyongjun1@huawei.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753503AbdBIQ6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 11:58:23 -0500
In-Reply-To: <20170209155724.19737-1-weiyj.lk@gmail.com>
Content-ID: <27511.1486659476.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:

> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -184,8 +184,10 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  		return PTR_ERR(tfm);
>  
>  	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> -	if (!req)
> +	if (!req) {
> +		ret = -ENOMEM;

Ummm...  What should I apply your patch to?

>  		goto error_free_tfm;
> +	}
>  
>  	if (pkey->key_is_private)
>  		ret = crypto_akcipher_set_priv_key(tfm,
> @@ -268,8 +270,10 @@ int public_key_verify_signature(const struct public_key *pkey,
>  		return PTR_ERR(tfm);
>  
>  	req = akcipher_request_alloc(tfm, GFP_KERNEL);
> -	if (!req)
> +	if (!req) {
> +		ret = -ENOMEM;
>  		goto error_free_tfm;

This shouldn't be necessary.  ret should already be -ENOMEM from
initialisation of the variable at the top of the function.

David
