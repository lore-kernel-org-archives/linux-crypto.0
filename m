From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix DECO RSR polling
Date: Tue, 22 Jul 2014 16:31:56 -0500
Message-ID: <20140722163156.b5442a93fdfa17c2fd10ae62@freescale.com>
References: <53CCC5A5.1070004@freescale.com>
	<1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:41543
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752460AbaGVVhR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jul 2014 17:37:17 -0400
In-Reply-To: <1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 21 Jul 2014 16:03:21 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

> RSR (Request Source Register) is not used when
> virtualization is disabled, thus don't poll for Valid bit.
> 
> Besides this, if used, timeout has to be reinitialized.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
> Only compile-tested.
> Ruchika / Kim, please review / test.

Acked-by: Kim Phillips <kim.phillips@freescale.com>

fwiw, it would be nice if virt_en were a bool...can you also please
start using get_maintainer.pl?

Thanks,

Kim
