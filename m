From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/6] drivers/crypto/caam/caamalg.c: introduce missing
 kfree
Date: Fri, 1 Apr 2011 14:42:05 -0500
Message-ID: <20110401144205.b050c598.kim.phillips@freescale.com>
References: <1301667827-20056-2-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<kernel-janitors@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>,
	Dan Carpenter <error27@gmail.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:23875
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab1DATnS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Apr 2011 15:43:18 -0400
In-Reply-To: <1301667827-20056-2-git-send-email-julia@diku.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 1 Apr 2011 16:23:43 +0200
Julia Lawall <julia@diku.dk> wrote:

> Error handling code following a kmalloc should free the allocated data.

> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Kim
