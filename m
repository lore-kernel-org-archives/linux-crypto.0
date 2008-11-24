From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Have HW invalidate src and dest descriptors after
	processing
Date: Mon, 24 Nov 2008 22:09:34 +0800
Message-ID: <20081124140934.GA18981@gondor.apana.org.au>
References: <12271034133347-git-send-email-zbr@ioremap.net> <12271034132587-git-send-email-zbr@ioremap.net> <12271034131753-git-send-email-zbr@ioremap.net> <20081124135352.GC18313@gondor.apana.org.au> <492AB38D.5000200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55603 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbYKXOJk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 09:09:40 -0500
Content-Disposition: inline
In-Reply-To: <492AB38D.5000200@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 24, 2008 at 03:00:45PM +0100, Patrick McHardy wrote:
>
> It seems the previous patch got mixed up, this is what I have in
> my old tree (just for reference, I don't know whether Evgeniy made
> any changes):

Thanks Patrick.  Evgeniy, please let us know if this move is
still needed or not.  The rest of your seies actually applied
without this but I'll hold onto it for a while so you can see
if this is intended or not.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
