From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 12:59:26 +0000
Message-ID: <201302211259.26763.arnd@arndb.de>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3BUM7t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 07:59:49 -0500
In-Reply-To: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 21 February 2013, Javier Martin wrote:
> This series of patches provide AES-ECB and AES-CBC support
> for the SAHARA2 cryptographic accelerator which is inside the i.MX27 SoC.
> It is expected that more algorithms will be supported in the future.
> 
> For testing, a Visstrim M10 board has been used and the code related
> to this platform has been included too.

As a new device driver, this needs to be supported on the DT based imx27
machines, while support for the individual board files seems unnecessary.

How about converting the Visstrim M10 board file over to DT so you don't
have to add any more infrastructure for imx that we will just have to
remove again one day?

	Arnd
