From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v3] crypto: des3_ede: permit weak keys unless
	REQ_WEAK_KEY set
Date: Sat, 6 Dec 2008 15:17:20 -0500
Message-ID: <20081206201720.GA18783@localhost.localdomain>
References: <200812041557.49601.jarod@redhat.com> <493942D9.6030807@redhat.com> <20081205152427.GA32475@gondor.apana.org.au> <493A101A.1080500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53581 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYLFUTb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Dec 2008 15:19:31 -0500
Content-Disposition: inline
In-Reply-To: <493A101A.1080500@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 06, 2008 at 12:39:38AM -0500, Jarod Wilson wrote:
> Jarod Wilson wrote:
>> While its a slightly insane to bypass the key1 == key2 ||
>> key2 == key3 check in triple-des, since it reduces it to the
>> same strength as des, some folks do need to do this from time
>> to time for backwards compatibility with des.
>>
>> My own case is FIPS CAVS test vectors. Many triple-des test
>> vectors use a single key, replicated 3x. In order to get the
>> expected results, des3_ede_setkey() needs to honor the weak
>> key flag.
>
> v2: make CRYPTO_TFM_REQ_WEAK_KEY flag usage consistent w/rest
> of crypto subsystem, per comments from Herbert in Red Hat
> bugzilla #474394.
>
> v3: set more appropriate RES flag, also per Herbert.
>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
> ---
>  crypto/des_generic.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/des_generic.c b/crypto/des_generic.c
> index 5d0e458..5bd3ee3 100644
> --- a/crypto/des_generic.c
> +++ b/crypto/des_generic.c
> @@ -868,9 +868,10 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, 
> const u8 *key,
>  	u32 *flags = &tfm->crt_flags;
>
>  	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
> -		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
> +		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
> +		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
>  	{
> -		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
> +		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
>  		return -EINVAL;
>  	}
>
>
Looks good to me.  Thanks Jarod!
Acked-by: Neil Horman <nhorman@tuxdriver.com>
