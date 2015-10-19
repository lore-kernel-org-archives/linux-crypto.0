From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH 4/6] crypto: marvell: use memcpy_fromio()/memcpy_toio()
Date: Tue, 20 Oct 2015 01:26:55 +0200
Message-ID: <87oafucudc.fsf@natisbad.org>
References: <20151018173039.GA9737@n2100.arm.linux.org.uk>
	<E1Znrnf-00064N-OS@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:59710 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbJSX1O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 19:27:14 -0400
In-Reply-To: <E1Znrnf-00064N-OS@rmk-PC.arm.linux.org.uk> (Russell King's
	message of "Sun, 18 Oct 2015 18:31:15 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russell,

Russell King <rmk+kernel@arm.linux.org.uk> writes:

> Use the IO memcpy() functions when copying from/to MMIO memory.
> These locations were found via sparse.

On recent MVEBU hardware, *_std_* function are not expected to be used
because we will instead use the TDMA-based versions. So the only
possible penalty we could get (if any) from this change on recent
devices is for the copy of the IV in mv_cesa_ablkcipher_process(). Out
of curiosity, I took a quick look at what is generated and it seems this
results in a call to mmiocpy(): 

00000340 <mv_cesa_ablkcipher_process>:
     340:       e1a0c00d        mov     ip, sp
     344:       e92dd830        push    {r4, r5, fp, ip, lr, pc}
     348:       e24cb004        sub     fp, ip, #4
     34c:       e24dd008        sub     sp, sp, #8

     ....

     3a4:       e5943010        ldr     r3, [r4, #16]
     3a8:       e5951008        ldr     r1, [r5, #8]
     3ac:       e594001c        ldr     r0, [r4, #28]
     3b0:       e2811040        add     r1, r1, #64     ; 0x40
     3b4:       e593201c        ldr     r2, [r3, #28]
     3b8:       ebfffffe        bl      0 <mmiocpy>

which if I am not mistaken is provided by arch/arm/lib/memcpy.S via:

ENTRY(mmiocpy)
ENTRY(memcpy)

#include "copy_template.S"

ENDPROC(memcpy)
ENDPROC(mmiocpy)

Am I right in concluding this will end up being the code of a usual
memcpy(), i.e. the change is a noop in the final code compared to
previous version? 

Cheers,

a+


>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/crypto/marvell/cipher.c | 11 ++++++-----
>  drivers/crypto/marvell/hash.c   | 16 ++++++++--------
>  2 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index 4db2d632204f..6edae64bb387 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -98,10 +98,10 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
>  
>  	/* FIXME: only update enc_len field */
>  	if (!sreq->skip_ctx) {
> -		memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
> +		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
>  		sreq->skip_ctx = true;
>  	} else {
> -		memcpy(engine->sram, &sreq->op, sizeof(sreq->op.desc));
> +		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op.desc));
>  	}
>  
>  	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
> @@ -145,8 +145,9 @@ static int mv_cesa_ablkcipher_process(struct crypto_async_request *req,
>  	if (ret)
>  		return ret;
>  
> -	memcpy(ablkreq->info, engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
> -	       crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq)));
> +	memcpy_fromio(ablkreq->info,
> +		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
> +		      crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq)));
>  
>  	return 0;
>  }
> @@ -181,7 +182,7 @@ mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
>  	sreq->size = 0;
>  	sreq->offset = 0;
>  	mv_cesa_adjust_op(engine, &sreq->op);
> -	memcpy(engine->sram, &sreq->op, sizeof(sreq->op));
> +	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
>  }
>  
>  static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 84ddc4cbfa9d..8330815d72fc 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -209,8 +209,8 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	size_t  len;
>  
>  	if (creq->cache_ptr)
> -		memcpy(engine->sram + CESA_SA_DATA_SRAM_OFFSET, creq->cache,
> -		       creq->cache_ptr);
> +		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> +			    creq->cache, creq->cache_ptr);
>  
>  	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
>  		    CESA_SA_SRAM_PAYLOAD_SIZE);
> @@ -251,10 +251,10 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
>  				len &= CESA_HASH_BLOCK_SIZE_MSK;
>  				new_cache_ptr = 64 - trailerlen;
> -				memcpy(creq->cache,
> -				       engine->sram +
> -				       CESA_SA_DATA_SRAM_OFFSET + len,
> -				       new_cache_ptr);
> +				memcpy_fromio(creq->cache,
> +					      engine->sram +
> +					      CESA_SA_DATA_SRAM_OFFSET + len,
> +					      new_cache_ptr);
>  			} else {
>  				len += mv_cesa_ahash_pad_req(creq,
>  						engine->sram + len +
> @@ -272,7 +272,7 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
>  
>  	/* FIXME: only update enc_len field */
> -	memcpy(engine->sram, op, sizeof(*op));
> +	memcpy_toio(engine->sram, op, sizeof(*op));
>  
>  	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
>  		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
> @@ -312,7 +312,7 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
>  
>  	sreq->offset = 0;
>  	mv_cesa_adjust_op(engine, &creq->op_tmpl);
> -	memcpy(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
> +	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
>  }
>  
>  static void mv_cesa_ahash_step(struct crypto_async_request *req)
