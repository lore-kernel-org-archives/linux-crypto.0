From: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sun, 18 Nov 2007 11:27:27 +0100
Message-ID: <200711181127.28326.mb@bu3sch.de>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <473FB1E0.600@trash.net> <20071118040401.GA25625@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46162
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXKRK2g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 05:28:36 -0500
In-Reply-To: <20071118040401.GA25625@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sunday 18 November 2007 05:04:01 Herbert Xu wrote:
> On Sun, Nov 18, 2007 at 04:30:40AM +0100, Patrick McHardy wrote:
> >
> > On a related issue, I think the rng interface is not very suitable
> > for chips like HIFN that have a constant random bandwidth, it would
> > make a lot more sense to return the time to wait to the core, instead
> > of waiting 10us in all cases. 256 cycles at a speed of 266MHz comes
> > down to 0.96us, so we're waiting about 10 times as long as necessary.
> > Since its busy waiting anyway, I'd think that from a performance POV
> > constant polling or returning the exact amount of time would be more
> > reasonable.
> 
> I agree, a better interface would be to let the hardware do the
> blocking where necessary.
> 
> Michael, what do you think about this?

Patches are welcome. ;)

-- 
Greetings Michael.
