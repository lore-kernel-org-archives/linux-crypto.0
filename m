From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/5] KEYS: DH: don't feed uninitialized result memory into KDF
Date: Thu, 20 Apr 2017 15:27:17 +0200
Message-ID: <2035658.QVN4rZd2FW@positron.chronox.de>
References: <20170420054633.14572-1-ebiggers3@gmail.com> <20170420054633.14572-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59022 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944757AbdDTN1U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 09:27:20 -0400
In-Reply-To: <20170420054633.14572-4-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 20. April 2017, 07:46:31 CEST schrieb Eric Biggers:

Hi Eric,

> From: Eric Biggers <ebiggers@google.com>
> 
> The result of the Diffie-Hellman computation may be shorter than the
> input prime number.  Only calculate the KDF over the actual result;
> don't include additional uninitialized memory.

Thank you for catching that (and all the rest). But I think this patch is not 
correct. If the DH operation results in a shorter value, the trailing part 
must be set to null and the KDF calculated over the entire prime length.

Thus, if the DH result is shorter than the prime, the memory should look like 
DH result || 0x00 <as often as needed to make it prime length> || otherinfo.

Thus, instead of this patch, I would think that the kmalloc call should be 
changed to a kzalloc.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  security/keys/dh.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/security/keys/dh.c b/security/keys/dh.c
> index 1c1cac677041..a3a8607107f5 100644
> --- a/security/keys/dh.c
> +++ b/security/keys/dh.c
> @@ -313,17 +313,6 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user
> *params, goto error4;
>  	}
> 
> -	/*
> -	 * Concatenate SP800-56A otherinfo past DH shared secret -- the
> -	 * input to the KDF is (DH shared secret || otherinfo)
> -	 */
> -	if (kdfcopy &&
> -	    copy_from_user(kbuf + resultlen, kdfcopy->otherinfo,
> -			   kdfcopy->otherinfolen) != 0) {
> -		ret = -EFAULT;
> -		goto error5;
> -	}
> -
>  	ret = do_dh(result, base, private, prime);
>  	if (ret)
>  		goto error5;
> @@ -333,8 +322,17 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user
> *params, goto error5;
> 
>  	if (kdfcopy) {
> +		/*
> +		 * Concatenate SP800-56A otherinfo past DH shared secret -- the
> +		 * input to the KDF is (DH shared secret || otherinfo)
> +		 */
> +		if (copy_from_user(kbuf + nbytes, kdfcopy->otherinfo,
> +				   kdfcopy->otherinfolen) != 0) {
> +			ret = -EFAULT;
> +			goto error5;
> +		}
>  		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, kbuf,
> -					    resultlen + kdfcopy->otherinfolen);
> +					    nbytes + kdfcopy->otherinfolen);
>  	} else {
>  		ret = nbytes;
>  		if (copy_to_user(buffer, kbuf, nbytes) != 0)



Ciao
Stephan
