From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export functions
Date: Sat, 10 Oct 2015 20:07:36 +0200
Message-ID: <201510102007.36214.marex@denx.de>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk> <87d1wn2ewu.fsf@natisbad.org> <20151010112925.GF32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44770 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbbJJSU6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Oct 2015 14:20:58 -0400
In-Reply-To: <20151010112925.GF32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday, October 10, 2015 at 01:29:25 PM, Russell King - ARM Linux wrote:
> On Sat, Oct 10, 2015 at 12:31:29PM +0200, Arnaud Ebalard wrote:
> > Hi Russel,
> 
>            ^
> 
> > Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > > Software:
> > > The 'numbers' are in 1000s of bytes per second processed.
> > > type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> > > bytes md5              13948.89k    42477.61k   104619.41k  
> > > 165140.82k   199273.13k sha1             13091.91k    36463.89k   
> > > 75393.88k   103893.33k   117104.50k sha256           13573.92k   
> > > 30492.25k    52700.33k    64247.81k    68722.69k
> > > 
> > > Hardware:
> > > The 'numbers' are in 1000s of bytes per second processed.
> > > type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> > > bytes md5               3964.55k    13782.11k    43181.71k  
> > > 180263.38k  1446616.18k sha1              4609.16k     8922.35k   
> > > 35422.87k   333575.31k  2122547.20k sha256           13519.62k   
> > > 30484.10k    52547.47k    64285.21k    68530.60k
> 
> Okay, the reason for the difference in SHA256 speed is because the
> "openssl speed" code *totally* *bypasses* the engine support, whereas
> the md5 and sha1 do not.  It even bypasses the normal method used to
> get hold of the sha256 implementation (EVP_sha256), and goes straight
> to using SHA256() directly in openssl/crypto/sha/sha256.c.  It looks
> like the same goes for the AES tests too.
> 
> > I had a lot of performance results at various levels (tcrypt module on
> > variations of the drivers (tasklet, threaded irq, full polling, etc),
> > IPsec tunnel and transport mode through to see how it behaves w/ two
> > mvneta instances also eating CPU cycles for incoming/outgoing packets)
> > but those where done on an encryption use case. Some are provided
> > in [2]. In an early (read dirty) polling-based version of the driver,
> > the CESA on an Armada 370 (mirabox) was verified to be capable of near
> > 100MB/s on buffers of 1500+ bytes for AES CBC encryption. Current
> > version of the driver is not as good (say half that value) but it
> > behaves better. A Mirabox can easily route 1500 bytes packets at 100MB/s
> > between its two interfaces but when you mix both using IPsec in tunnel
> > mode on one side, you end up w/ perfs between 10 to 15MB/s, IIRC. I
> > think it's interesting to see where it ends up w/ the engine exposed to
> > userland consumers (e.g. sth like SSH).
> > 
> > I cannot promise a huge amount of time but I'll try and find some to
> > play w/ AF_ALG using openssl and CESA in the coming weeks.
> 
> I think what we draw from my investigation is that "openssl speed" is
> utterly crap - you don't actually know what's being tested there.  Some
> things test the engine, others bypass the engine infrastructure totally
> and test the openssl software implementation instead.
> 
> So, if you think "openssl speed" is a good way to measure the speed of
> digests and ciphers that openssl supplies to applications, *think again*.
> It doesn't.

Add to that the fact that openssl speed does NOT verify the results of the
transformations, so it's not usable for detecting errors during high load.
It's utter crap, just like you said.

Best regards,
Marek Vasut
