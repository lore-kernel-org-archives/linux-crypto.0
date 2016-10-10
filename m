From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: cmac - fix alignment of 'consts'
Date: Mon, 10 Oct 2016 10:29:55 -0700
Message-ID: <1476120595.2856.28.camel@perches.com>
References: <1476119715-71397-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476119715-71397-2-git-send-email-ebiggers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2016-10-10 at 10:15 -0700, Eric Biggers wrote:
> The per-transform 'consts' array is accessed as __be64 in
> crypto_cmac_digest_setkey() but was only guaranteed to be aligned to
> __alignof__(long).  Fix this by aligning it to __alignof__(__be64).
[]
> diff --git a/crypto/cmac.c b/crypto/cmac.c
[]
> @@ -57,7 +57,8 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
>  	unsigned long alignmask = crypto_shash_alignmask(parent);
>  	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
>  	unsigned int bs = crypto_shash_blocksize(parent);
> -	__be64 *consts = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
> +	__be64 *consts = PTR_ALIGN((void *)ctx->ctx,
> +				   (alignmask | (__alignof__(__be64) - 1)) + 1);

Using a bitwise or looks very odd there.  Perhaps:

		min(alignmask + 1, __alignof__(__be64))
