From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Tue, 7 Dec 2010 19:39:56 +0800
Message-ID: <20101207113956.GA6128@gondor.apana.org.au>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc> <20101104184606.GA1994@gondor.apana.org.au> <20101105141238.GG29793@orbit.nwl.cc> <20101202061441.GA22378@gondor.apana.org.au> <20101207104141.GA24946@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37040 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0LGLkE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Dec 2010 06:40:04 -0500
Content-Disposition: inline
In-Reply-To: <20101207104141.GA24946@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 07, 2010 at 11:41:41AM +0100, Phil Sutter wrote:
>
> Yes, CONFIG_PREEMPT is active in my test system's kernel.

OK, can you see if the problem is still reproducible without
preemption?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
