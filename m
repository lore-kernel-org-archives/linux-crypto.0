From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] Have HW invalidate src and dest descriptors after processing
Date: Mon, 24 Nov 2008 17:23:22 +0300
Message-ID: <20081124142322.GB10587@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net> <12271034132587-git-send-email-zbr@ioremap.net> <12271034131753-git-send-email-zbr@ioremap.net> <20081124135352.GC18313@gondor.apana.org.au> <492AB38D.5000200@trash.net> <20081124140934.GA18981@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tservice.ru ([195.178.208.66]:54645 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYKXOXY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 09:23:24 -0500
Content-Disposition: inline
In-Reply-To: <20081124140934.GA18981@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Nov 24, 2008 at 10:09:34PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > It seems the previous patch got mixed up, this is what I have in
> > my old tree (just for reference, I don't know whether Evgeniy made
> > any changes):
> 
> Thanks Patrick.  Evgeniy, please let us know if this move is
> still needed or not.  The rest of your seies actually applied
> without this but I'll hold onto it for a while so you can see
> if this is intended or not.

Weird. patch/diff and hands all messed up. In the version which was
tested there is no that changes, so just drop it.

-- 
	Evgeniy Polyakov
