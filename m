From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug#552270: Marvell CESA driver and Kirkwood
Date: Fri, 30 Apr 2010 11:20:09 +0200
Message-ID: <20100430092009.GA22852@Chamillionaire.breakpoint.cc>
References: <20091130211531.GK18101@deprecation.cyrius.com>
	<4B144627.7060901@gmail.com>
	<20091204212847.GC28480@deprecation.cyrius.com>
	<4BCB4009.70707@gmail.com>
	<20100418191719.GA2508@Chamillionaire.breakpoint.cc>
	<4BCE125F.30200@gmail.com>
	<20100421081302.GB31506@Chamillionaire.breakpoint.cc>
	<4BCFC120.5010306@jdland.co.il>
	<20100424151207.GB9057@Chamillionaire.breakpoint.cc>
	<4BD33BD7.80400@jdland.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "L.C." <lucorsel@gmail.com>, Martin Michlmayr <tbm@cyrius.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Uri Simchoni <uri@jdland.co.il>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <4BD33BD7.80400@jdland.co.il>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
	<mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

* Uri Simchoni | 2010-04-24 21:43:35 [+0300]:

Sorry for the late reply.

>> I enabled list and sg debugging and a flood ping triggered a couple of
>> warning. Could you please look at this?
>Sure.
It seems that everything is working now.

>> IPsec requests authenc(hmac(sha1),cbc(aes)) so right now it reqeusts two
>> cesa provided algorithms. A single ping results in around 30ms RTT.
>Since the CESA does each operation faster than sw (at least when the packet size exceeds some threshold), I see no reason for it to slow the process down. The slowness probably is somehow caused by the same thing that causes the oops, or by debug warning prints.
Yup looks like it.

>> Disabling hmac(sha1) gives me less than 1ms.
>> Implementing authenc() for IPsec should speed things up. Right I'm stuck
>> with hacking DMA support.
>Well, so far I wasn't able to figure out how it all fits together - sure, the CESA can do AES-CBC+HMAC-SHA1 in one run, but I'm not sure it's suitable for IPSec, or that the crypto infrastructure supports a HW driver for combined operation. (the CESA is probably not suitable for SSL because of alignment problems, IPSec is better in that respect).

It does, AEAD is just for this purpose. The FSL talitos driver does
this. Not sure if it is the only one.
I try to hack DMA support before I focus on this.
 
>>> Thanks,
>>> Uri.

Sebastian
