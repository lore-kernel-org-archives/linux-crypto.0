From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/2] crypto: mxs-dcp: Check the return value of stmp_reset_block()
Date: Wed, 29 Jan 2014 01:58:36 +0100
Message-ID: <201401290158.36968.marex@denx.de>
References: <1390955772-6936-1-git-send-email-festevam@gmail.com> <1390955772-6936-2-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:49535 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA2A6n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jan 2014 19:58:43 -0500
In-Reply-To: <1390955772-6936-2-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, January 29, 2014 at 01:36:12 AM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> stmp_reset_block() may fail, so check its return value and propagate it in
> the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
