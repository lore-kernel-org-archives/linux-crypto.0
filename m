From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: unaligned access in pkcs7_verify
Date: Tue, 13 Oct 2015 21:36:43 +0800
Message-ID: <20151013133643.GA7267@gondor.apana.org.au>
References: <20151002140014.GI18263@oracle.com>
 <20151008131519.GA24362@gondor.apana.org.au>
 <20151008144343.GE19655@oracle.com>
 <20151012133209.GA27746@gondor.apana.org.au>
 <20151013132928.GK20800@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37117 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbbJMNgw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:36:52 -0400
Content-Disposition: inline
In-Reply-To: <20151013132928.GK20800@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 09:29:28AM -0400, Sowmini Varadhan wrote:
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index d20c0b4..958ac01 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -46,14 +46,15 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
>  		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
>  
>  	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> -	sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
> -
> +	sinfo->sig.digest_size = crypto_shash_digestsize(tfm);
> +	digest_size = crypto_shash_digestsize(tfm) +
> +		ALIGN(crypto_shash_digestsize(tfm), __alignof__(*desc));

You should leave digest_size as is but round it up when you use
it in kzalloc.  Otherwise you are essentially rounding it up
twice which happens to work but looks rather odd.  It may also
lead to bugs later on if somebody uses digest_size as the digest
size.

>  	ret = -ENOMEM;
>  	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);

So I would replace this with

	digest = kzalloc(ALIGN(digest_size, desc_align) + desc_size, GFP_KERNEL);

>  	if (!digest)
>  		goto error_no_desc;
>  
> -	desc = digest + digest_size;
> +	desc = PTR_ALIGN(digest + digest_size, __alignof__(*desc));

This looks good.

BTW when you submit this please add a sign-off as specified by
Documentation/SubmittingPatches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
