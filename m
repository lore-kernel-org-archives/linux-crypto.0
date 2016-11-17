From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: BUG: algif_hash crash with extra recv() in 4.9-rc5
Date: Thu, 17 Nov 2016 08:50:06 -0800 (PST)
Message-ID: <alpine.OSX.2.20.1611170845410.98102@mjmartin-mac01.local>
References: <alpine.OSX.2.20.1611161027010.67352@mjmartin-mac01.local> <20161117140757.GA1149@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:6572 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932176AbcKQQ7Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 11:59:16 -0500
In-Reply-To: <20161117140757.GA1149@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert,

On Thu, 17 Nov 2016, Herbert Xu wrote:

> On Wed, Nov 16, 2016 at 11:17:33AM -0800, Mat Martineau wrote:
>>
>> Herbert -
>>
>> Following commit 493b2ed3f7603a15ff738553384d5a4510ffeb95, there is a NULL
>> dereference crash in algif_hash when recv() is called twice like this:
>>
>> send(sk, data, len, MSG_MORE);
>> recv(sk, hash1, len, 0);
>> recv(sk, hash2, len, 0);
>>
>> In 4.8 and earlier, the two recvs return identical data. In 4.9-rc5, the
>> second recv triggers this:
>>
>> [   53.041287] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>> [   53.042048] IP: [<ffffffffa73fdfb3>] shash_ahash_digest+0x23/0x130
>
> Ugh.  It looks like the shash wrapper is incorrectly dereferencing
> the SG list even when the length is zero.  Rather than fixing it
> I'm just going to make algif_hash do the safe thing of doing an
> init followed by a final.

Thanks for the patch. For my test code, it fixed the crash and restored 
the previous behavior.

Regards,
Mat


> ---8<---
> Subject: crypto: algif_hash - Fix NULL hash crash with shash
>
> Recently algif_hash has been changed to allow null hashes.  This
> triggers a bug when used with an shash algorithm whereby it will
> cause a crash during the digest operation.
>
> This patch fixes it by avoiding the digest operation and instead
> doing an init followed by a final which avoids the buggy code in
> shash.
>
> This patch also ensures that the result buffer is freed after an
> error so that it is not returned as a genuine hash result on the
> next recv call.
>
> The shash/ahash wrapper code will be fixed later to handle this
> case correctly.
>
> Fixes: 493b2ed3f760 ("crypto: algif_hash - Handle NULL hashes correctly")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 2d8466f..05e21b4 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -214,23 +214,26 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>
> 	ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
>
> -	if (ctx->more) {
> +	if (!result) {
> +		err = af_alg_wait_for_completion(
> +				crypto_ahash_init(&ctx->req),
> +				&ctx->completion);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +	if (!result || ctx->more) {
> 		ctx->more = 0;
> 		err = af_alg_wait_for_completion(crypto_ahash_final(&ctx->req),
> 						 &ctx->completion);
> 		if (err)
> 			goto unlock;
> -	} else if (!result) {
> -		err = af_alg_wait_for_completion(
> -				crypto_ahash_digest(&ctx->req),
> -				&ctx->completion);
> 	}
>
> 	err = memcpy_to_msg(msg, ctx->result, len);
>
> -	hash_free_result(sk, ctx);
> -
> unlock:
> +	hash_free_result(sk, ctx);
> 	release_sock(sk);
>
> 	return err ?: len;
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

--
Mat Martineau
Intel OTC
