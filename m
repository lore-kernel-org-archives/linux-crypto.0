From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] Have HW invalidate src and dest descriptors after processing
Date: Mon, 24 Nov 2008 17:53:10 +0300
Message-ID: <20081124145310.GB13844@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net> <12271034132587-git-send-email-zbr@ioremap.net> <12271034131753-git-send-email-zbr@ioremap.net> <20081124135352.GC18313@gondor.apana.org.au> <492AB38D.5000200@trash.net> <20081124140934.GA18981@gondor.apana.org.au> <20081124142322.GB10587@ioremap.net> <20081124143427.GA19314@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from netgear.net.ru ([195.178.208.66]:35372 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYKXOxM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 09:53:12 -0500
Content-Disposition: inline
In-Reply-To: <20081124143427.GA19314@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2008 at 10:34:27PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Mon, Nov 24, 2008 at 05:23:22PM +0300, Evgeniy Polyakov wrote:
> >
> > Weird. patch/diff and hands all messed up. In the version which was
> > tested there is no that changes, so just drop it.
> 
> OK I've applied everything bar the first two and pushed it out.
> Please let me know if there's anything broken.

Thank you.

I will check it and report back if there are mismatches.

-- 
	Evgeniy Polyakov
