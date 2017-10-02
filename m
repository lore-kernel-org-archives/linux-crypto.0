From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/4] staging: ccree: simplify access to struct device
Date: Mon, 02 Oct 2017 03:00:22 -0700
Message-ID: <1506938422.2274.11.camel@perches.com>
References: <1506935008-14240-1-git-send-email-gilad@benyossef.com>
         <1506935008-14240-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:54135 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750891AbdJBKA1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2017 06:00:27 -0400
In-Reply-To: <1506935008-14240-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-10-02 at 10:03 +0100, Gilad Ben-Yossef wrote:
> Introduce a DEV macro to retrieve struct device from private
> data structure in preparation to replacing custom logging
> macros with proper dev_dbg and friends which require struct
> device.
[]
> diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
[]
> @@ -103,6 +103,8 @@
>  #define SSI_LOG_DEBUG(format, ...) do {} while (0)
>  #endif
>  
> +#define DEV(drvdata) ((&(drvdata)->plat_dev->dev))

The name seems not particularly descriptive.
It seems a longer name would
not be too bad.

Perhaps

static inline struct device *drvdata_to_dev(struct ssi_drvdata *drvdata)
{
	return &drvdata->plat_dev->dev;
}
