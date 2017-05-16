From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 2/4] crypto: drbg wait for crypto op not signal safe
Date: Tue, 16 May 2017 15:39:46 -0700
Message-ID: <20170516223946.GC113464@gmail.com>
References: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
 <1494503626-15877-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36645 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdEPWju (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2017 18:39:50 -0400
Content-Disposition: inline
In-Reply-To: <1494503626-15877-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Gilad,

On Thu, May 11, 2017 at 02:53:43PM +0300, Gilad Ben-Yossef wrote:
> drbg_kcapi_sym_ctr() was using wait_for_completion_interruptible() to
> wait for completion of async crypto op but if a signal occurs it
> may return before DMA ops of HW crypto provider finish, thus
> corrupting the output buffer.
> 
> Resolve this by using wait_for_completion() instead.
> 
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: stable@vger.kernel.org
> ---
>  crypto/drbg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index fa749f4..fa9054d 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1767,8 +1767,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
>  			break;
>  		case -EINPROGRESS:
>  		case -EBUSY:
> -			ret = wait_for_completion_interruptible(
> -				&drbg->ctr_completion);
> +			ret = wait_for_completion(&drbg->ctr_completion);
>  			if (!ret && !drbg->ctr_async_err) {
>  				reinit_completion(&drbg->ctr_completion);
>  				break;
> -- 

wait_for_completion() doesn't return a value.  This was fixed in the next patch,
but it should be done in this patch.

Eric
