From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos - add IPsec ESN support
Date: Wed, 8 Aug 2012 20:22:15 -0500
Message-ID: <20120808202215.da5ef82b25f655956cabae80@freescale.com>
References: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:29988
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab2HIBY0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Aug 2012 21:24:26 -0400
In-Reply-To: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 8 Aug 2012 18:46:45 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

> Support for ESNs (extended sequence numbers).
> Tested with strongswan on a P2020RDB back-to-back setup.
> Extracted from /etc/ipsec.conf:
> esp=aes-sha1-esn-modp4096!
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---

series:

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim
