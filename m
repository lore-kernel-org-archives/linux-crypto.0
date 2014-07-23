From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix DECO RSR polling
Date: Wed, 23 Jul 2014 21:36:27 +0800
Message-ID: <20140723133627.GE29756@gondor.apana.org.au>
References: <53CCC5A5.1070004@freescale.com>
 <1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
 <20140722163156.b5442a93fdfa17c2fd10ae62@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia Geanta <horia.geanta@freescale.com>,
	linux-crypto@vger.kernel.org,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56377 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaGWNga (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 09:36:30 -0400
Content-Disposition: inline
In-Reply-To: <20140722163156.b5442a93fdfa17c2fd10ae62@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 22, 2014 at 04:31:56PM -0500, Kim Phillips wrote:
> On Mon, 21 Jul 2014 16:03:21 +0300
> Horia Geanta <horia.geanta@freescale.com> wrote:
> 
> > RSR (Request Source Register) is not used when
> > virtualization is disabled, thus don't poll for Valid bit.
> > 
> > Besides this, if used, timeout has to be reinitialized.
> > 
> > Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> > ---
> > Only compile-tested.
> > Ruchika / Kim, please review / test.
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
