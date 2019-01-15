Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfAORpn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 12:45:43 -0500
Date: Tue, 15 Jan 2019 09:45:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] crypto: testmgr - add rfc4543(gcm(aes)) decryption
 test to encryption tests
Message-ID: <20190115174538.GA10955@gmail.com>
References: <20190113233228.5851-1-ebiggers@kernel.org>
 <20190113233228.5851-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190113233228.5851-5-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 13, 2019 at 03:32:27PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> One "ccm(aes)" decryption test vector doesn't exactly match any of the
> encryption test vectors with input and result swapped.  In preparation

This should say "rfc4543(gcm(aes))".  If I happen to send v2 of this series I'll
fix it, otherwise Herbert can you fix this when applying?  Thanks!

- Eric

> for removing the AEAD decryption test vectors and testing AEAD
> decryption using the encryption test vectors, add this to the encryption
> test vectors, so we don't lose any test coverage.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/testmgr.h | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 5d8f867b9b837..8d1c2dfe3becb 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -18454,7 +18454,35 @@ static const struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
>  			  "\xe1\x55\x10\x6a\xa8\xdc\xd6\x18"
>  			  "\xe4\x09\x9a\xaa",
>  		.rlen	= 68,
> -	}
> +	}, { /* nearly same as previous, but should fail */
> +		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
> +			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
> +			  "\x22\x43\x3c\x64",
> +		.klen	= 20,
> +		.iv	= zeroed_string,
> +		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07"
> +			  "\x00\x00\x00\x00\x00\x00\x00\x00",
> +		.alen	= 16,
> +		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
> +			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
> +			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
> +			  "\x02\x00\x07\x00\x61\x62\x63\x64"
> +			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
> +			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
> +			  "\x01\x02\x02\x01",
> +		.ilen	= 52,
> +		.novrfy = 1,
> +		.result	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
> +			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
> +			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
> +			  "\x02\x00\x07\x00\x61\x62\x63\x64"
> +			  "\x65\x66\x67\x68\x69\x6a\x6b\x6c"
> +			  "\x6d\x6e\x6f\x70\x71\x72\x73\x74"
> +			  "\x01\x02\x02\x01\xf2\xa9\xa8\x36"
> +			  "\xe1\x55\x10\x6a\xa8\xdc\xd6\x18"
> +			  "\x00\x00\x00\x00",
> +		.rlen	= 68,
> +	},
>  };
>  
>  static const struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
> -- 
> 2.20.1
> 
