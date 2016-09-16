From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: crypto: caam from tasklet to threadirq
Date: Fri, 16 Sep 2016 17:53:50 +0100
Message-ID: <20160916165350.GI1041@n2100.armlinux.org.uk>
References: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com>
 <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Horia Geanta Neag <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Cata Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42929 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbcIPQx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 12:53:59 -0400
Content-Disposition: inline
In-Reply-To: <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 16, 2016 at 02:01:00PM +0000, Cata Vasile wrote:
> Hi,
> 
> We've tried to test and benchmark your submitted work[1].
> 
> Cryptographic offloading is also used in IPsec in the Linux Kernel. In
> heavy traffic scenarios, the NIC driver competes with the crypto device
> driver. Most NICs use the NAPI context, which is one of the most
> prioritized context types. In IPsec scenarios  the performance is
> trashed because, although raw data gets in to device, the data is
> encrypted/decrypted and the dequeue code in CAAM driver has a hard time
> being scheduled to actually call the callback to notify the networking
> stack it can continue working with  that data.

Having received a reply from Thomas Gleixner today, there appears to be
some disagreement with your findings, and a suggestion that the problem
needs proper and more in-depth investigation.

Thomas indicates that the NAPI processing shows an improvement when
moved to the same context that threaded interrupts run in, as opposed
to the current softirq context - which also would run the tasklets.

What I would say is that if threaded IRQs are causing harm, then there
seems to be something very wrong somewhere.

> Being this scenario, at heavy load, the Kernel warns on rcu stalls and
> the forwarding path has a lot of latency.  Have you tried benchmarking
> the board you used for testing?

It's way too long ago for me to remember - these patches were created
almost a year ago - October 20th 2015, which is when I'd have tested
them.  So, I'm afraid I can't help very much at this point, apart from
trying to re-run some benchmarks.

I'd suggest testing the openssl (with AF_ALG support), which is probably
what I tested and benchmarked.  However, as I say, it's far too long
ago for me to really remember at this point.

> I have ran some on our other platforms. The after benchmark fails to
> run at the top level of the before results.

Sorry, that last sentence doesn't make any sense to me.

I don't have the bandwidth to look at this, and IPsec doesn't interest
me one bit - I've never been able to work out how to setup IPsec
locally.  From what I remember when I looked into it many years ago,
you had to have significant information about ipsec to get it up and
running.  Maybe things have changed since then, I don't know.

If you want me to reproduce it, please send me a step-by-step idiots
guide on setting up a working test scenario which reproduces your
problem.

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
