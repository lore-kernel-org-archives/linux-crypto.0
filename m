From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Sat, 28 Sep 2013 05:35:33 +0200
Message-ID: <201309280535.33672.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <201309261407.33923.marex@denx.de> <5245AC5B.80800@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawn.guo@linaro.org>
To: Tobias Rauter <tobiasrauter@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:46821 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3I1Dfj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Sep 2013 23:35:39 -0400
In-Reply-To: <5245AC5B.80800@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tobias,

> Hi,
> 
> Here are some thoughts of the design decisions I made when I wrote
> the dcp.c driver. Maybe it helps.

Was the driver not rather forward-ported from some old FSL BSP kernel?

> On 2013-09-26 14:07, Marek Vasut wrote:
> > Dear Fabio Estevam,
> > 
> >> Hi Marek,
> >> 
> >> Why do we need to have two drivers for the same IP block? It looks
> >> confusing to have both.
> > 
> > Sure, I agree. I reviewed the one in mainline just now and I see some
> > deficiencies of the dcp.c driver:
> > 
> > 1) It only supports AES_CBC (mine does support AES_ECB, AES_CBC, SHA1 and
> > SH256)
> 
> Right, but for ECP only the interface is missing (and it is no real
> mode of operation) and hashes should be generally faster in SW.

The ECB is slightly different from CBC, for example the IV handling differs. As 
for the performance, the SHA* hashing was more performant in hardware starting 
with ~8MB chunks. I checked this via the "openssl -speed" test via the linux 
cryptodev patch.

> > 2) The driver was apparently never ran behind anyone working with MXS.
> 
> That is probably right.
> 
> > 3) What are those ugly new IOCTLs in the dcp.c driver?
> 
> When I firstly posted the driver in the mailinglist, there where one
> person who actually used this interface (it was introduced in
> Freescale's SDK) to use the OTP keys for crypto. As far as I have
> seen, the crypto API does not support such keys (i.e. there seems to
> be no way to tell a driver to use some kind of special keys - which
> are not delivered by the user - via the API).
> Therefore I added this miscdevice and adopted Freescale's interface.

The keys are programmed into the OTP registers, correct? There is OCOTP driver 
for the MX23/MX28 OTP hardware. This is what should have been used then.

NOTE: This IOCTL interface seems like quite an abusive way to allow userland to 
access the crypto API in kernel. I understand this is used by some Freescale 
tool, but won't it be better to fix the Freescale tool instead ?

> > 4) The VMI IRQ is never used, yet it even calls the IRQ handler, this is
> > bogus
> 
> That's absolutely right.
> 
> >     -> The DCP always triggers the dcp_irq upon DMA completion
> 
> The IRQ is triggered after every packet, to enable simultaneous work
> for CPU/DCP: While the DCP is computing, the CPU is able to fill more
> packets. I don't know how far this is useful, because the 20 Packets
> which are enabled by default can address up to 80kB of
> plain-/ciphertext. However, I think it is better to do the work
> simultaneously to safe time (actual real world time, not CPU time).

This really depends on how you program the DCP's own DMA controller, or more 
precisely what you write into the DMA descriptors. Each descriptor has a bit 
that signalizes whether the DCP should generate an IRQ upon it's completion. You 
can thus program it to generate IRQ upon competing each descriptor only for the 
last descriptor in a chain or what fits you.

NOTE that chaining multiple DMA descriptors of small size is less performant 
than filling up a large buffer and then running it through the DCP in one longer 
DMA descriptor. This is actually why I have such a large bounce-buffer and not 
only a small one.

> > 5) The IRQ handler can't use usual completion() in the driver because
> > that'd trigger "scheduling while atomic" oops, yes?
> 
> I decided to use the tasklets because of performance reasons. I don't
> remember numbers but a workqueue was significantly slower.  The
> use of a kernel thread may reduce the overhead compared to the wq. I
> was not sure if it is appropriate to create an extra thread for a
> crypto-driver, without real reason (IMHO).

Certainly, my remark was that the FSL driver had this issue and the code here 
didn't change much from the FSL driver. I was thus curious why you don't use 
completion in the driver as usual and whether this was to work around the issue 
the FSL driver had.

> > Finally, because the dcp.c driver only supports AES128 CBC, it depends on
> > kernel _always_ passing the DCP scatterlist such that each of it's
> > elements is 16-bytes long. [...]
> > So, in the AES128 case, if the hardware is passed two (4 bytes + 12 bytes
> > for example) DMA descriptors instead of single 16 bytes descriptor, the
> > DCP will simply stall or produce incorrect result. This can happen if
> > the user of the async crypto API passes such a scatterlist.
> 
> The scatterlist alignment and bounce-buffering to get full 16 Byte
> blocks is done by the ablkcipher_walk API (with the error
> parameter) when needed. As far as I see, you are copying the whole
> buffer to your coherent block and back. Wouldn't it be better to do that
> just for unaligned blocks?

I tried writing a proper driver for this DCP piece of crap hardware about 7 
times. I tried to squeeze as much power from it as possible, among others tried 
to avoid the copying, but there was always some hidden problem somewhere. The 
DCP is really _horribly_ designed hardware. But to answer your question, the 
copying of stuff back and forth is actually not a problem here.

The real question here is, how do we handle the current situation? I think this 
might be a question for Dave or Herbert to answer though.

Best regards,
Marek Vasut
