From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 7/8] staging: ccree: replace noop macro with inline
Date: Sat, 9 Sep 2017 12:11:57 +0300
Message-ID: <20170909091157.wsotu253vngrz5rt@mwanda>
References: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
 <1504429011-25514-8-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26070 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIIJMX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Sep 2017 05:12:23 -0400
Content-Disposition: inline
In-Reply-To: <1504429011-25514-8-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 03, 2017 at 11:56:49AM +0300, Gilad Ben-Yossef wrote:
> Replace noop macro with a noop inline function
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/ssi_driver.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
> index 06a3c48..81ba827 100644
> --- a/drivers/staging/ccree/ssi_driver.h
> +++ b/drivers/staging/ccree/ssi_driver.h
> @@ -187,8 +187,8 @@ struct async_gen_req_ctx {
>  #ifdef DX_DUMP_BYTES
>  void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
>  #else
> -#define dump_byte_array(name, array, size) do {	\
> -} while (0);
> +static inline void dump_byte_array(const char *name, const u8 *the_array,
> +				   unsigned long size) {};

Could you put the {} on the next line?  Also there is no need for the
semi-colon after the end of a function.

This is a style thing, so if you want to do it in a follow on patch
that's fine

regards,
dan carpenter
