From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Tue, 8 May 2012 19:37:24 +0000
Message-ID: <201205081937.24450.arnd@arndb.de>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com> <1336476513-17145-2-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, sfr@canb.auug.org.au,
	lee.jones@linaro.org
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab2EHThd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2012 15:37:33 -0400
In-Reply-To: <1336476513-17145-2-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 08 May 2012, Andreas Westin wrote:
> This adds the required platform data and calls to enable
> the CRYP/HASH driver.
> 
> index 15a0f63..a69db46 100644
> --- a/arch/arm/mach-ux500/id.c
> +++ b/arch/arm/mach-ux500/id.c
> @@ -17,7 +17,10 @@
>  #include <mach/hardware.h>
>  #include <mach/setup.h>
>  
> +#include <linux/module.h>
> +
>  struct dbx500_asic_id dbx500_id;
> +EXPORT_SYMBOL(dbx500_id);
>  
>  static unsigned int ux500_read_asicid(phys_addr_t addr)
>  {

This needs an explanation! Why do you export an internal data structure
to non-GPL modules?

On a more general topic, I wonder if it's really necessary to add new
devices to the legacy probing path in mach-ux500. Why not make new drivers
for this platform dt-only, so we don't need to add code now that we will
have to remove again in one or two kernel releases?

	Arnd
