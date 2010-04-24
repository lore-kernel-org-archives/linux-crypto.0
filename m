From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug#552270: Marvell CESA driver and Kirkwood
Date: Sat, 24 Apr 2010 17:12:07 +0200
Message-ID: <20100424151207.GB9057@Chamillionaire.breakpoint.cc>
References: <4B12F9E7.1020207@gmail.com>
 <20091130211531.GK18101@deprecation.cyrius.com>
 <4B144627.7060901@gmail.com>
 <20091204212847.GC28480@deprecation.cyrius.com>
 <4BCB4009.70707@gmail.com>
 <20100418191719.GA2508@Chamillionaire.breakpoint.cc>
 <4BCE125F.30200@gmail.com>
 <20100421081302.GB31506@Chamillionaire.breakpoint.cc>
 <4BCFC120.5010306@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "L.C." <lucorsel@gmail.com>, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>, linux-crypto@vger.kernel.org
To: Uri Simchoni <uri@jdland.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44438 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab0DXPML (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Apr 2010 11:12:11 -0400
Content-Disposition: inline
In-Reply-To: <4BCFC120.5010306@jdland.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Uri Simchoni | 2010-04-22 06:23:12 [+0300]:

>I have some IPSec background but am not familiar with the Linux implementation (I'm using the mv_cesa for SSL acceleration through a usermode interface I'm working on). Can you point me to the nearest howto? I suppose I could have a look.

If it is possible, please post some patches which describe the user land
interface.

For IPSec I use this[0] shell script which sets up a connection. Good for
testing :) So you need two boxes, start the script on both machines and
the first ping that reached my orion box triggered that error. I just
sent something that looked like a fix.

I enabled list and sg debugging and a flood ping triggered a couple of
warning. Could you please look at this?

IPsec requests authenc(hmac(sha1),cbc(aes)) so right now it reqeusts two
cesa provided algorithms. A single ping results in around 30ms RTT.
Disabling hmac(sha1) gives me less than 1ms.
Implementing authenc() for IPsec should speed things up. Right I'm stuck
with hacking DMA support.

For now I think lowering priority of hmac() should fix the problem. A
direct request "mv-hmac-sha1" should still returned the mv driver. What
do you thing?

Need to run now....

>Thanks,
>Uri.

Sebastian
