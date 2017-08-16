From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 11/22] staging: ccree: fix line indentation and breaks
Date: Wed, 16 Aug 2017 15:08:05 -0700
Message-ID: <20170816220805.GA29988@kroah.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
 <1502778412-16255-12-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752623AbdHPWIF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 18:08:05 -0400
Content-Disposition: inline
In-Reply-To: <1502778412-16255-12-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 15, 2017 at 09:26:39AM +0300, Gilad Ben-Yossef wrote:
> Fix wrong indentation and line breaks, including missing tabs,
> breaking lines longer then 80 char or wrongly broken.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/ssi_driver.c | 107 +++++++++++++++++++++++--------------
>  1 file changed, 67 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
> index 81cb63d..0ce2f57 100644
> --- a/drivers/staging/ccree/ssi_driver.c
> +++ b/drivers/staging/ccree/ssi_driver.c
> @@ -87,27 +87,31 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
>  
>  	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ", name, size);
>  	if (ret < 0) {
> -		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
> +		SSI_LOG_ERR
> +		    ("snprintf returned %d . aborting buffer array dump\n",
> +		     ret);

As Joe said, this is pretty bad.  Just move "ret);" to the next line,
and then fix it up so that there are not SSI_LOG_ERR() macros and use
the normal in-kernel printing functions instead, then you will not get
this type of warning.

thanks,

greg k-h
