Return-Path: <SRS0=RoNa=TC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2440CC43219
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 08:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5D121670
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 08:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfEBIIZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 04:08:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:61127 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfEBIIY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 04:08:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="169842708"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 02 May 2019 01:08:19 -0700
Received: by lahna (sSMTP sendmail emulation); Thu, 02 May 2019 11:08:18 +0300
Date:   Thu, 2 May 2019 11:08:18 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@linaro.org, joakim.bech@linaro.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: Re: [PATCH 1/5] i2c: acpi: permit bus speed to be discovered after
 enumeration
Message-ID: <20190502080818.GT26516@lahna.fi.intel.com>
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
 <20190430162910.16771-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430162910.16771-2-ard.biesheuvel@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 30, 2019 at 06:29:05PM +0200, Ard Biesheuvel wrote:
> Currently, the I2C ACPI enumeration code only permits the max bus rate
> to be discovered before enumerating the slaves on the bus. In some
> cases, drivers for slave devices may require this information, e.g.,
> some ATmel crypto drivers need to generate a so-called wake token
> of a fixed duration, regardless of the bus rate.
> 
> So tweak the code so i2c_acpi_lookup_speed() is able to obtain this
> information after enumeration as well.
> 
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks fine by me,

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Adding Jarkko just in case I missed something.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/i2c/i2c-core-acpi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
> index 272800692088..7240cc07abb4 100644
> --- a/drivers/i2c/i2c-core-acpi.c
> +++ b/drivers/i2c/i2c-core-acpi.c
> @@ -115,8 +115,7 @@ static int i2c_acpi_do_lookup(struct acpi_device *adev,
>  	struct list_head resource_list;
>  	int ret;
>  
> -	if (acpi_bus_get_status(adev) || !adev->status.present ||
> -	    acpi_device_enumerated(adev))
> +	if (acpi_bus_get_status(adev) || !adev->status.present)
>  		return -EINVAL;
>  
>  	if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_ids) == 0)
> @@ -151,6 +150,9 @@ static int i2c_acpi_get_info(struct acpi_device *adev,
>  	lookup.info = info;
>  	lookup.index = -1;
>  
> +	if (acpi_device_enumerated(adev))
> +		return -EINVAL;
> +
>  	ret = i2c_acpi_do_lookup(adev, &lookup);
>  	if (ret)
>  		return ret;
> -- 
> 2.20.1
