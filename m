From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Mon, 15 Aug 2011 16:55:46 +0800
Message-ID: <20110815085546.GA30341@gondor.apana.org.au>
References: <20110811112603.GD16877@secunet.com> <20110811112639.GE16877@secunet.com> <20110815071928.GA29761@gondor.apana.org.au> <20110815080257.GU16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57378 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1HOIzu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 04:55:50 -0400
Content-Disposition: inline
In-Reply-To: <20110815080257.GU16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 15, 2011 at 10:02:57AM +0200, Steffen Klassert wrote:
>
> I don't think it is broken. It's just easier to handle if an underlying
> algorithm changes it's priority. If the user changes the priority of a
> certain algorithm, I take the difference of the old and new priority
> value and add this to all subsequent algorithms. So this can not take the
> weight into account without some 'per algorithm' priority update functions.

Oh I see.  I don't think we need to go that far.

Here are two simpler ways of handling this:

1) Liquidate all instances on top of the algorithm being changed
(this is what we already do when you register a new implementation
of an algorithm with a higher priority).

2) Do nothing and let the user change everything manually.

My take would be to just do 1) considering that the usage scenario
is that the user is either going to change something like AES at
the very bottom of the pile or something complex at the top.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
