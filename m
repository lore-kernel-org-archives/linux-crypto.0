From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/27] Drivers: ccree: ssi_fips_ll.c - align block
 comments
Date: Mon, 29 May 2017 16:53:38 +0200
Message-ID: <20170529145338.GA32447@kroah.com>
References: <20170524044352.30423-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Derek Robson <robsonde@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbdE2PHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 11:07:39 -0400
Content-Disposition: inline
In-Reply-To: <20170524044352.30423-1-robsonde@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 24, 2017 at 04:43:52PM +1200, Derek Robson wrote:
> Fixed block comment alignment, Style fix only
> Found using checkpatch
> 
> Signed-off-by: Derek Robson <robsonde@gmail.com>
> ---
>  drivers/staging/ccree/ssi_fips_ll.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
> index 7c7c922f0788..cb487d747ee8 100644
> --- a/drivers/staging/ccree/ssi_fips_ll.c
> +++ b/drivers/staging/ccree/ssi_fips_ll.c
> @@ -15,9 +15,9 @@
>   */
>  
>  /**************************************************************
> -This file defines the driver FIPS Low Level implmentaion functions,
> -that executes the KAT.
> -***************************************************************/
> + * This file defines the driver FIPS Low Level implmentaion functions,
> + * that executes the KAT.
> + ***************************************************************/
>  #include <linux/kernel.h>
>  
>  #include "ssi_driver.h"
> @@ -816,7 +816,8 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
>  		       dma_addr_t digest_bytes_len_dma_addr)
>  {
>  	/* The implemented flow is not the same as the one implemented in ssi_hash.c (setkey + digest flows).
> -	   In this flow, there is no need to store and reload some of the intermidiate results. */
> +	 * In this flow, there is no need to store and reload some of the intermidiate results.
> +	 */
>  
>  	/* max number of descriptors used for the flow */
>  	#define FIPS_HMAC_MAX_SEQ_LEN 12
> @@ -948,9 +949,9 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
>  	idx++;
>  
>  	/* at this point:
> -	   tmp_digest = H(o_key_pad)
> -	   k0 = H(i_key_pad || m)
> -	   */
> +	 * tmp_digest = H(o_key_pad)
> +	 * k0 = H(i_key_pad || m)
> +	 */
>  
>  	/* Loading hash opad xor key state */
>  	HW_DESC_INIT(&desc[idx]);
> @@ -1413,8 +1414,10 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
>  	idx++;
>  
>  	/* Configure Hash Engine to work with GHASH.
> -	   Since it was not possible to extend HASH submodes to add GHASH,
> -	   The following command is necessary in order to select GHASH (according to HW designers)*/
> +	 * Since it was not possible to extend HASH submodes to add GHASH,
> +	 * The following command is necessary in order to 

You added a coding style issue that was not previously here in this
patch, which isn't ok :(

I've stopped here with this series, please fix up the reset of this
series (hint, this wasn't the only place you messed this up) and resend.

thanks,

greg k-h
