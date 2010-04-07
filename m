From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Date: Wed, 7 Apr 2010 08:31:09 +0800
Message-ID: <20100407003109.GA27617@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc> <20100405084209.GA16788@gondor.apana.org.au> <20100405170406.GA24215@Chamillionaire.breakpoint.cc> <20100406124412.GA24488@gondor.apana.org.au> <20100406203002.GA1842@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60039 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932237Ab0DGAbN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Apr 2010 20:31:13 -0400
Content-Disposition: inline
In-Reply-To: <20100406203002.GA1842@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 06, 2010 at 10:30:02PM +0200, Sebastian Andrzej Siewior wrote:
>
> Good point. All arc4 users don't care about return value of setkey so I
> think that I just change void to int add the check for the valid key
> length.

Actually, how about getting arc4_setup_iv to do all the legwork
and turn it into a real IV? Then we don't need any checks on the
data path.

> While we are here, the .setkey() callback could be removed, couldn't it?
> It returns 0 even it is doing nothing what looks kinda wrong. However it
> shouldn't be called at all since min/max key is 0. Any objections on
> that?

I'm pretty sure testmgr will call setkey even for keylen == 0, no?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
