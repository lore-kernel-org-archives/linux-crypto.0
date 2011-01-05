From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Wed, 5 Jan 2011 11:19:40 +1100
Message-ID: <20110105001940.GA5558@gondor.apana.org.au>
References: <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan> <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan> <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <4D23B7D8.7090701@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46787 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1AEATr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jan 2011 19:19:47 -0500
Content-Disposition: inline
In-Reply-To: <4D23B7D8.7090701@lwfinger.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 04, 2011 at 06:14:16PM -0600, Larry Finger wrote:
>
> If I didn't get lost in expanding all those macros, I think the above can end up
> with what is essentially a negative value for the index of buf. Shouldn't the
> right-hand side of the statement be
> 
> (u32 *)PTR_ALIGN(&buf[PADLOCK_ALIGNMENT], PADLOCK_ALIGNMENT);
> 
> That resolves to an index for buf from 0 to (PADLOCK_ALIGNMENT - 1).

PTR_ALIGN (and ALIGN) rounds up, not down.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
