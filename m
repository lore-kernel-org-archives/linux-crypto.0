From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 5/5] crypto: talitos - add IPsec ESN support
Date: Mon, 6 Aug 2012 20:47:51 -0500
Message-ID: <20120806204751.1f6277ba8f7b1de92fd128ac@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
	<1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:48384
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab2HGBt6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2012 21:49:58 -0400
In-Reply-To: <1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2 Aug 2012 17:16:41 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

> +			.cra_name = "authencesn(hmac(sha1),cbc(aes))",
> +			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",

the driver name should be authencesn, too, no?

Also: if the algorithm name is really all that changes, can it be
done more space-efficiently with some string manipulation in the
algorithm registration loop?:  If registering an "authenc"
algorithm, also register an "authencesn" version.

The rest of the patchseries looks fine.

Thanks,

Kim
