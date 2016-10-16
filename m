From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: [PATCH 7/7] crypto: doc - clarify AEAD memory structure
Date: Sun, 16 Oct 2016 15:11:38 +0200
Message-ID: <62B7147E-395E-4615-AB9D-DA6B3E932FCD@darmarit.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de> <2836054.OXHgEonhSr@positron.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, Harsh Jain <harshjain.prof@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:48832 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754313AbcJPNLw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Oct 2016 09:11:52 -0400
In-Reply-To: <2836054.OXHgEonhSr@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Am 16.10.2016 um 05:22 schrieb Stephan Mueller <smueller@chronox.de>:

> The previous description have been misleading and partially incorrect.
> 
> Reported-by: Harsh Jain <harshjain.prof@gmail.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
> crypto/algif_aead.c   | 14 ++------------
> include/crypto/aead.h | 35 +++++++++++------------------------
> 2 files changed, 13 insertions(+), 36 deletions(-)
> 
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 80a0f1a..a0d8377 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -551,18 +551,8 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
> 	lock_sock(sk);
> 
> 	/*
> -	 * AEAD memory structure: For encryption, the tag is appended to the
> -	 * ciphertext which implies that the memory allocated for the ciphertext
> -	 * must be increased by the tag length. For decryption, the tag
> -	 * is expected to be concatenated to the ciphertext. The plaintext
> -	 * therefore has a memory size of the ciphertext minus the tag length.
> -	 *
> -	 * The memory structure for cipher operation has the following
> -	 * structure:
> -	 *	AEAD encryption input:  assoc data || plaintext
> -	 *	AEAD encryption output: cipherntext || auth tag
> -	 *	AEAD decryption input:  assoc data || ciphertext || auth tag
> -	 *	AEAD decryption output: plaintext
> +	 * Please see documentation of aead_request_set_crypt for the
> +	 * description of the AEAD memory structure expected from the caller.
> 	 */
> 
> 	if (ctx->more) {
> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
> index 1bd3a2f..b7f3373 100644
> --- a/include/crypto/aead.h
> +++ b/include/crypto/aead.h
> @@ -483,30 +483,17 @@ static inline void aead_request_set_callback(struct aead_request *req,
> * destination is the ciphertext. For a decryption operation, the use is
> * reversed - the source is the ciphertext and the destination is the plaintext.
> *
> - * For both src/dst the layout is associated data, plain/cipher text,
> - * authentication tag.
> - *
> - * The content of the AD in the destination buffer after processing
> - * will either be untouched, or it will contain a copy of the AD
> - * from the source buffer.  In order to ensure that it always has
> - * a copy of the AD, the user must copy the AD over either before
> - * or after processing.  Of course this is not relevant if the user
> - * is doing in-place processing where src == dst.
> - *
> - * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
> - *		  the caller must concatenate the ciphertext followed by the
> - *		  authentication tag and provide the entire data stream to the
> - *		  decryption operation (i.e. the data length used for the
> - *		  initialization of the scatterlist and the data length for the
> - *		  decryption operation is identical). For encryption, however,
> - *		  the authentication tag is created while encrypting the data.
> - *		  The destination buffer must hold sufficient space for the
> - *		  ciphertext and the authentication tag while the encryption
> - *		  invocation must only point to the plaintext data size. The
> - *		  following code snippet illustrates the memory usage
> - *		  buffer = kmalloc(ptbuflen + (enc ? authsize : 0));
> - *		  sg_init_one(&sg, buffer, ptbuflen + (enc ? authsize : 0));
> - *		  aead_request_set_crypt(req, &sg, &sg, ptbuflen, iv);
> + * The memory structure for cipher operation has the following structure:
> + *	AEAD encryption input:  assoc data || plaintext
> + *	AEAD encryption output: assoc data || cipherntext || auth tag
> + *	AEAD decryption input:  assoc data || ciphertext || auth tag
> + *	AEAD decryption output: assoc data || plaintext
> + *

Hi Stephan,

as I wrote before in 3/7, you can use the reST markup in source
code comments. If you want a list markup, I recommend to write:

* The memory structure for cipher operation has the following structure:
*
* - AEAD encryption input:  assoc data || plaintext
* - AEAD encryption output: assoc data || cipherntext || auth tag
* - AEAD decryption input:  assoc data || ciphertext || auth tag
* - AEAD decryption output: assoc data || plaintext
*

And if you want a inline literal you can use the backquotes

* - AEAD decryption output: ``assoc data || plaintext``

reST is a simple ASCII markup, I can't advice excessive markup
in source code, but simple inline- or block-markups like lists
and code-blocks are sometimes helpful. For this, the the first
half of the reST primer is advisable:

http://www.sphinx-doc.org/en/stable/rest.html 

These are only my 2cent in hope that helps ... there is no rule 
to use any special markup ... use markup as you prefer ;-)

--Markus --

> + * Albeit the kernel requires the presence of the AAD buffer, however,
> + * the kernel does not fill the AAD buffer in the output case. If the
> + * caller wants to have that data buffer filled, the caller must either
> + * use an in-place cipher operation (i.e. same memory location for
> + * input/output memory location).
> */
> static inline void aead_request_set_crypt(struct aead_request *req,
> 					  struct scatterlist *src,
> -- 
> 2.7.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
