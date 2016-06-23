From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Doing crypto in small stack buffers (bluetooth vs vmalloc-stack
 crash, etc)
Date: Thu, 23 Jun 2016 11:48:25 +0800
Message-ID: <20160623034825.GB7819@gondor.apana.org.au>
References: <CALCETrVJzzKkRsSbgsUmVd_+ArKEgoRSVdG1tVp7CXzFoPyVgA@mail.gmail.com>
 <20160622004214.GA27134@gondor.apana.org.au>
 <CALCETrUnzasc+c5Dxmw+g6U07dTNU4RF0ug1bHj8j2en+7Xj1A@mail.gmail.com>
 <CALCETrUWyNz91WO6O3dNb+YELeZy5q4+oTo6dLRR67P2WvBB8g@mail.gmail.com>
 <CALCETrXJAvtty-zrjZR0URyT92rMZ4HhiTLtd4r5CzFjZOj=-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@kernel.org>, linux-bluetooth@vger.kernel.org,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Gustavo Padovan <gustavo@padovan.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55580 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFWDsm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 23:48:42 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrXJAvtty-zrjZR0URyT92rMZ4HhiTLtd4r5CzFjZOj=-Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:45:46PM -0700, Andy Lutomirski wrote:
>
> *However*, the other offender I've found (net/rxrpc/rxkad.c) uses
> "pcbc(fcrypt)", which doesn't appear to be usable with this API.  Is
> there no way to say "I want synchronous crypto on this VA range" using
> the skcipher API?

No we never had such an API in the kernel.  However, I see that
rxkad does some pretty silly things and we should be able to avoid
using the stack in pretty much all cases.  Let me try to come up with
something.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
