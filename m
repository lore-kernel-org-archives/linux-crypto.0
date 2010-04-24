From: Uri Simchoni <uri@jdland.co.il>
Subject: Re: Bug#552270: Marvell CESA driver and Kirkwood
Date: Sat, 24 Apr 2010 21:43:35 +0300
Message-ID: <4BD33BD7.80400@jdland.co.il>
References: <4B12F9E7.1020207@gmail.com> <20091130211531.GK18101@deprecation.cyrius.com> <4B144627.7060901@gmail.com> <20091204212847.GC28480@deprecation.cyrius.com> <4BCB4009.70707@gmail.com> <20100418191719.GA2508@Chamillionaire.breakpoint.cc> <4BCE125F.30200@gmail.com> <20100421081302.GB31506@Chamillionaire.breakpoint.cc> <4BCFC120.5010306@jdland.co.il> <20100424151207.GB9057@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www011.intervision.co.il ([80.244.168.31]:38436 "EHLO
	www011.intervision.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0DXSnw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Apr 2010 14:43:52 -0400
In-Reply-To: <20100424151207.GB9057@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/24/2010 6:12 PM, Sebastian Andrzej Siewior wrote:
> * Uri Simchoni | 2010-04-22 06:23:12 [+0300]:
> 
> For IPSec I use this[0] shell script which sets up a connection. Good for
> testing :) 
Thanks, That'll save time setting it up...
> I enabled list and sg debugging and a flood ping triggered a couple of
> warning. Could you please look at this?
Sure.
> 
> IPsec requests authenc(hmac(sha1),cbc(aes)) so right now it reqeusts two
> cesa provided algorithms. A single ping results in around 30ms RTT.
Since the CESA does each operation faster than sw (at least when the packet size exceeds some threshold), I see no reason for it to slow the process down. The slowness probably is somehow caused by the same thing that causes the oops, or by debug warning prints.

> Disabling hmac(sha1) gives me less than 1ms.
> Implementing authenc() for IPsec should speed things up. Right I'm stuck
> with hacking DMA support.
Well, so far I wasn't able to figure out how it all fits together - sure, the CESA can do AES-CBC+HMAC-SHA1 in one run, but I'm not sure it's suitable for IPSec, or that the crypto infrastructure supports a HW driver for combined operation. (the CESA is probably not suitable for SSL because of alignment problems, IPSec is better in that respect).
> 
> For now I think lowering priority of hmac() should fix the problem. A
> direct request "mv-hmac-sha1" should still returned the mv driver. What
> do you thing?
> 
I think there's a bug here I should find and fix. Till then perhaps the mv-hmac-sha1 driver should not be registered at all.
> Need to run now....
> 
>> Thanks,
>> Uri.
> 
> Sebastian

