From: Peter Griffin <peter.griffin@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v2 0/7] hwrng: Add support for
 STMicroelectronics' RNG IP
Date: Tue, 29 Sep 2015 10:20:47 +0100
Message-ID: <20150929092047.GA16955@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com, kernel@stlinux.com
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37395 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbbI2JUx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Sep 2015 05:20:53 -0400
Received: by wicfx3 with SMTP id fx3so6262737wic.0
        for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2015 02:20:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Lee,

On Thu, 17 Sep 2015, Lee Jones wrote:

> v1 => v2:
>  - New patch: Also fixing /dev/hw_random => /dev/hwrng in Kconfig
>  - Fix 2099 => 2009 typo in commit log
>  - Fix 'number of random numbers sourced' return value
>  - Treat devm_clk_get()'s return value correctly
>  - Check return value of clk_prepare_enable()
>  - Use sysfs_streq() instead of manually stripping '\n' from sysfs
> 
> The main aim of this set is to allow users to access ST's hardware
> random number generator.  It's a simple device, which only requires
> a simple driver.
> 
> We're also taking the liberty to update some out of date HWRNG
> documentation and making the sysfs interface a little easier to
> use by ignoring any '\n' which may have been inadvertently passed.

Looks good, for the series: -

Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
