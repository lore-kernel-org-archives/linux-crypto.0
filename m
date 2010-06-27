From: David Miller <davem@davemloft.net>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Sat, 26 Jun 2010 21:07:28 -0700 (PDT)
Message-ID: <20100626.210728.90806559.davem@davemloft.net>
References: <cover.1276284559.git.mcuelenaere@gmail.com>
	<4C129341.2060407@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: mcuelenaere@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34755
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab0F0EHR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Jun 2010 00:07:17 -0400
In-Reply-To: <4C129341.2060407@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Date: Fri, 11 Jun 2010 21:49:21 +0200

> This patch adds support for the Samsung crypto engine driver available in the
> S3C64XX and S5PC100 SoCs. Currently this supports AES and (T)DES with ECB and
> CBC block ciphers (also CTR for AES). Support for (HMAC)-SHA1 acceleration is
> also available in this engine, but isn't used in the driver yet.
> 
> Support for DMA has been added in the code but is currently disabled due to
> issues with data transfers.
> 
> Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>

I would personally queue up new crypto requests directly when there are
no queued up requests and ->cur_req is NULL, instead of doing all of
that work to do the submission in the tasklet.  I would also do the
completion and queue running directly in the hw IRQ handler.

The tasklet is just pure overhead.

Basically, when doing async crypto, every cycle that is consumed just
to implement crypto job submission and completion takes away from the
gains you get by doing it in hw at all.

You can see this clearly if you do performance comparisons between the
synchronous crypto routines and your async ones done in HW.
