From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH RFC 06/11] crypto: caam: ensure that we clean up after an
 error
Date: Wed, 9 Dec 2015 17:08:41 +0200
Message-ID: <566843F9.6000508@freescale.com>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
 <E1a61Cz-0007mm-QP@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:19071
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbbLIPIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 10:08:50 -0500
In-Reply-To: <E1a61Cz-0007mm-QP@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/7/2015 9:12 PM, Russell King wrote:
> Ensure that we clean up allocations and DMA mappings after encountering
> an error rather than just giving up and leaking memory and resources.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

I guess the error cleanup code should be grouped under an "err" label,
instead of duplicating it.

Horia
