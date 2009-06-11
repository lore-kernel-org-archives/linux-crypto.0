From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] crypto: s390 des3 - permit weak keys unless
	REQ_WEAK_KEY set
Date: Thu, 11 Jun 2009 15:38:59 +0200
Message-ID: <20090611133859.GC3146@osiris.boeblingen.de.ibm.com>
References: <200906081332.10608.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56858 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZFKNjI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 09:39:08 -0400
Content-Disposition: inline
In-Reply-To: <200906081332.10608.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 01:32:09PM -0400, Jarod Wilson wrote:
> Just started running fips cavs test vectors through an s390x system
> for giggles, and discovered that I missed patching s390's arch-specific
> des3 implementation w/an earlier des3 patch to permit weak keys.
> 
> This change adds the same flag tweaks as ad79cdd77fc1466e45cf923890f66bcfe7c43f12
> for s390's des3 implementation, yields expected test results now.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  arch/s390/crypto/des_s390.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
> index 4aba83b..2bc479a 100644
> --- a/arch/s390/crypto/des_s390.c
> +++ b/arch/s390/crypto/des_s390.c
> @@ -250,8 +250,9 @@ static int des3_128_setkey(struct crypto_tfm *tfm, const u8 *key,
>  	const u8 *temp_key = key;
>  	u32 *flags = &tfm->crt_flags;
> 
> -	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE))) {
> -		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
> +	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE)) &&
> +	    (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
> +		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
>  		return -EINVAL;

I think this should go in via crypt-dev. Herbert?
