From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question about error codes
Date: Wed, 17 Jun 2009 11:52:43 +1000
Message-ID: <20090617015243.GA21685@gondor.apana.org.au>
References: <4A37CC93.8040905@lotspeich.org> <20090616203406.GA19710@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Erik Lotspeich <erik@lotspeich.org>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@redhat.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38531 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751770AbZFQBwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2009 21:52:53 -0400
Content-Disposition: inline
In-Reply-To: <20090616203406.GA19710@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2009 at 10:34:06PM +0200, Sebastian Andrzej Siewior wrote:
>
> >Any help would be greatly appreciated.
> I guess the number of bytes to decrypt/encrypt ist not always a modulos
> of the blockmode.

Yes that's probably what it is.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
