From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Tue, 04 Jan 2011 19:38:52 -0600
Message-ID: <4D23CBAC.4000506@lwfinger.net>
References: <4D1D27E7.7030301@lwfinger.net> <20101231022550.GA2512@darkside.kls.lan> <20101231024653.GA24879@gondor.apana.org.au> <20101231085103.GA31935@darkside.kls.lan> <20110104043338.GA27604@gondor.apana.org.au> <20110104121957.GA27114@darkside.kls.lan> <20110104123824.GA31557@gondor.apana.org.au> <20110104125722.GC27114@darkside.kls.lan> <20110104224238.GA4978@gondor.apana.org.au> <4D23B7D8.7090701@lwfinger.net> <20110105001940.GA5558@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50745 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1AEBio (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jan 2011 20:38:44 -0500
In-Reply-To: <20110105001940.GA5558@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/04/2011 06:19 PM, Herbert Xu wrote:
> 
> PTR_ALIGN (and ALIGN) rounds up, not down.

I see where I got lost in the macro expansions.

I'm still trying to understand the need for the __attribute__ on the definition
for buf.

Larry
