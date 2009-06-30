From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 2/2] crypto/ansi prng: alloc cipher just in in init()
Date: Tue, 30 Jun 2009 10:51:50 -0400
Message-ID: <20090630145150.GB13116@hmsreliant.think-freely.org>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214508.GB29616@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39654 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZF3Ov7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jun 2009 10:51:59 -0400
Content-Disposition: inline
In-Reply-To: <20090629214508.GB29616@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 29, 2009 at 11:45:08PM +0200, Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> As reported by Eric Sesterhenn the re-allocation of the cipher in reset leads
> to:
> |BUG: sleeping function called from invalid context at kernel/rwsem.c:21
> |in_atomic(): 1, irqs_disabled(): 0, pid: 4926, name: modprobe
> |INFO: lockdep is turned off.
> |Pid: 4926, comm: modprobe Tainted: G   M 2.6.31-rc1-22297-g5298976 #24
> |Call Trace:
> | [<c011dd93>] __might_sleep+0xf9/0x101
> | [<c0777aa0>] down_read+0x16/0x68
> | [<c048bf04>] crypto_alg_lookup+0x16/0x34
> | [<c048bf52>] crypto_larval_lookup+0x30/0xf9
> | [<c048c038>] crypto_alg_mod_lookup+0x1d/0x62
> | [<c048c13e>] crypto_alloc_base+0x1e/0x64
> | [<c04bf991>] reset_prng_context+0xab/0x13f
> | [<c04e5cfc>] ? __spin_lock_init+0x27/0x51
> | [<c04bfce1>] cprng_init+0x2a/0x42
> | [<c048bb4c>] __crypto_alloc_tfm+0xfa/0x128
> | [<c048c153>] crypto_alloc_base+0x33/0x64
> | [<c04933c9>] alg_test_cprng+0x30/0x1f4
> | [<c0493329>] alg_test+0x12f/0x19f
> | [<c0177f1f>] ? __alloc_pages_nodemask+0x14d/0x481
> | [<d09219e2>] do_test+0xf9d/0x163f [tcrypt]
> | [<d0920de6>] do_test+0x3a1/0x163f [tcrypt]
> | [<d0926035>] tcrypt_mod_init+0x35/0x7c [tcrypt]
> | [<c010113c>] _stext+0x54/0x12c
> | [<d0926000>] ? tcrypt_mod_init+0x0/0x7c [tcrypt]
> | [<c01398a3>] ? up_read+0x16/0x2b
> | [<c0139fc4>] ? __blocking_notifier_call_chain+0x40/0x4c
> | [<c014ee8d>] sys_init_module+0xa9/0x1bf
> | [<c010292b>] sysenter_do_call+0x12/0x32
> 
> because a spin lock is held and crypto_alloc_base() may sleep.
> There is no reason to re-allocate the cipher, the state is resetted in
> ->setkey(). This move it to init.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

NAK.  Functionally its, ok. But in the conversion, you set ctx->tfm to NULL, and
then return PTR_ERR(ctx->tfm), which is going to return success erroneously
(NULL == 0 == success).. Grab the value of tfm before setting it to null and
return that instead, please

Regards
Neil

> ---
>  crypto/ansi_cprng.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index ff00b58..259d2de 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -307,17 +307,6 @@ static int reset_prng_context(struct prng_context *ctx,
>  	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
>  	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
>  
> -	if (ctx->tfm)
> -		crypto_free_cipher(ctx->tfm);
> -
> -	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
> -	if (IS_ERR(ctx->tfm)) {
> -		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
> -			ctx);
> -		ctx->tfm = NULL;
> -		goto out;
> -	}
> -
>  	ctx->rand_data_valid = DEFAULT_BLK_SZ;
>  
>  	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
> @@ -342,6 +331,13 @@ static int cprng_init(struct crypto_tfm *tfm)
>  	struct prng_context *ctx = crypto_tfm_ctx(tfm);
>  
>  	spin_lock_init(&ctx->prng_lock);
> +	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
> +	if (IS_ERR(ctx->tfm)) {
> +		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
> +				ctx);
> +		ctx->tfm = NULL;
> +		return PTR_ERR(ctx->tfm);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Use after assignment is bad here :)

> +	}
>  
>  	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0)
>  		return -EINVAL;
> -- 
> 1.6.3.3
> 
> 
