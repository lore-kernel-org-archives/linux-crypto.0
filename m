From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC] crypto: drbg - lower reseed threshold if seed source is degraded
Date: Tue, 09 Jun 2015 17:27:46 +0200
Message-ID: <1454819.tTuWU5o0ua@tachyon.chronox.de>
References: <1546948.ChzZZVGUza@tachyon.chronox.de> <3482320.MoAVfHitsv@tachyon.chronox.de> <20150609152605.GA15444@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46183 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbbFIP1v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 11:27:51 -0400
In-Reply-To: <20150609152605.GA15444@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. Juni 2015, 23:26:05 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jun 09, 2015 at 05:22:32PM +0200, Stephan Mueller wrote:
> > Am Dienstag, 9. Juni 2015, 22:25:25 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > Anyway, I'm happy to apply this.  However, the patch is corrupted
> > > so please resend it without the white-space damage/line wrapping.
> > 
> > As this patch would clash with the async seeding patch, shall I develop
> > this patch on top of your async patch set?
> 
> Either way is fine.  I can fix it up when applying as they don't
> conceptually conflict.

I see one: the reset of the threshold to the "normal" value must happen at two 
places: the one place is in the async handler. The 2nd place is when the 
request to random.c returns 0 (i.e. fully initialized). The 2nd location is 
different between both code bases.
> 
> Thanks,


-- 
Ciao
Stephan
