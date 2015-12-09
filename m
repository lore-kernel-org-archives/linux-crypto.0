From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 00/13] Further iMX CAAM updates
Date: Wed, 9 Dec 2015 17:06:03 +0200
Message-ID: <5668435B.3020000@freescale.com>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:38626
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977AbbLIPVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 10:21:33 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/7/2015 9:11 PM, Russell King - ARM Linux wrote:
> Here are further imx-caam updates that I've had since before the
> previous merge window.  Please review and (I guess) if Freescale
> folk can provide acks etc that would be nice.  Thanks.

Thanks Russell.

Note that the patch set does not apply cleanly, please rebase on latest
cryptodev-2.6 tree.

I'll add specific comments where needed.

Horia
