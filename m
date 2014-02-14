From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: mxs-dcp: Fix platform_get_irq() error handling
Date: Fri, 14 Feb 2014 09:22:03 +0100
Message-ID: <201402140922.03163.marex@denx.de>
References: <1392347084-7801-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51825 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaBNJDy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 04:03:54 -0500
In-Reply-To: <1392347084-7801-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, February 14, 2014 at 04:04:44 AM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> We should test the error case for each platform_get_irq() assignment and
> propagate the error accordingly.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
