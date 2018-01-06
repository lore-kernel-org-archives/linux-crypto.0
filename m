From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: ccree: shorten lengthy lines with breaks
Date: Sat, 06 Jan 2018 09:03:57 -0800
Message-ID: <1515258237.21222.45.camel@perches.com>
References: <20180106154726.10465-1-gebulmer@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: George Edward Bulmer <gebulmer@googlemail.com>,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:52379 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753694AbeAFREB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Jan 2018 12:04:01 -0500
In-Reply-To: <20180106154726.10465-1-gebulmer@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2018-01-06 at 15:47 +0000, George Edward Bulmer wrote:
> This fixes five instances of checkpatch warning:
> WARNING: line over 80 characters
[]
> diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
[]
> @@ -32,15 +32,26 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
>  	int offset = 0;
>  
>  	register_value = cc_ioread(drvdata, CC_REG(HOST_SIGNATURE));
> -	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
> +	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
> +			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ",

trivia:

Using %-21s would do the same as padding the format
string argument and would create smaller object code.

	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
			    "%-21s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE",

Using an extra space before a tab is odd.

Using a space after a tab is odd too.

> +			    DX_HOST_SIGNATURE_REG_OFFSET, register_value);
>  	register_value = cc_ioread(drvdata, CC_REG(HOST_IRR));
> -	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
> +	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
> +			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ",

etc...

> +			    DX_HOST_IRR_REG_OFFSET, register_value);
>  	register_value = cc_ioread(drvdata, CC_REG(HOST_POWER_DOWN_EN));
> -	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
> +	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
> +			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ",
> +			    DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
>  	register_value =  cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
> -	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
> +	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
> +			    "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ",
> +			    DX_AXIM_MON_ERR_REG_OFFSET, register_value);
>  	register_value = cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
> -	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
> +	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
> +			    "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT",
> +			    DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET,
> +			    register_value);
>  	return offset;
>  }
>  
