From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 0/3] Update for ux500 CRYP and HASH
Date: Thu, 10 May 2012 10:55:11 +0000
Message-ID: <201205101055.11562.arnd@arndb.de>
References: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, sfr@canb.auug.org.au,
	lee.jones@linaro.org, linus.walleij@linaro.org
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab2EJKzU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 06:55:20 -0400
In-Reply-To: <1336637648-10064-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 10 May 2012, Andreas Westin wrote:
> Hi,
> 
> V2 of the patches.
> 
> * Removed symbol export
> * Removed usage of SOC specific functions in the drivers.
> * Readded overlooked config for DMA in mach-ux500.
> 
> After some internal discussion we felt that the now implemented
> hardware identification solution is cleaner than the suggested
> solution.
> 
> The hardware identification patch applies cleanly to
> the cryptodev tree.

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
