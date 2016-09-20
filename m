From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: crypto: caam from tasklet to threadirq
Date: Tue, 20 Sep 2016 17:12:28 +0100
Message-ID: <20160920161228.GQ1041@n2100.armlinux.org.uk>
References: <DB5PR04MB130229BBD433C8FF7BDD975FEEF90@DB5PR04MB1302.eurprd04.prod.outlook.com>
 <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia Geanta Neag <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Cata Vasile <cata.vasile@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45628 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932963AbcITQMj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 12:12:39 -0400
Content-Disposition: inline
In-Reply-To: <DB5PR04MB1302AD00536D2E37E726E104EEF30@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Okay, I've re-tested, using a different way of measuring, because using
openssl speed is impractical for off-loaded engines.  I've decided to
use this way to measure the performance:

dd if=/dev/zero bs=1048576 count=128 | /usr/bin/time openssl dgst -md5

For the threaded IRQs case gives:

0.05user 2.74system 0:05.30elapsed 52%CPU (0avgtext+0avgdata 2400maxresident)k
0.06user 2.52system 0:05.18elapsed 49%CPU (0avgtext+0avgdata 2404maxresident)k
0.12user 2.60system 0:05.61elapsed 48%CPU (0avgtext+0avgdata 2460maxresident)k
	=> 5.36s => 25.0MB/s

and the tasklet case:

0.08user 2.53system 0:04.83elapsed 54%CPU (0avgtext+0avgdata 2468maxresident)k
0.09user 2.47system 0:05.16elapsed 49%CPU (0avgtext+0avgdata 2368maxresident)k
0.10user 2.51system 0:04.87elapsed 53%CPU (0avgtext+0avgdata 2460maxresident)k
	=> 4.95 => 27.1MB/s

which corresponds to an 8% slowdown for the threaded IRQ case.  So,
tasklets are indeed faster than threaded IRQs.

I guess the reason is that tasklets are much simpler, being able to
run just before we return to userspace without involving scheduler
overheads, but that's speculation.

I've tried to perf it, but...

Samples: 31K of event 'cycles', Event count (approx.): 3552246846
  Overhead  Command          Shared Object     Symbol
+   33.22%  kworker/0:1      [kernel.vmlinux]  [k] __do_softirq
+   15.78%  irq/311-2101000  [kernel.vmlinux]  [k] __do_softirq
+    7.49%  irqbalance       [kernel.vmlinux]  [k] __do_softirq
+    7.26%  openssl          [kernel.vmlinux]  [k] __do_softirq
+    5.71%  ksoftirqd/0      [kernel.vmlinux]  [k] __do_softirq
+    3.64%  kworker/0:2      [kernel.vmlinux]  [k] __do_softirq
+    3.52%  swapper          [kernel.vmlinux]  [k] __do_softirq
+    3.14%  kworker/0:1      [kernel.vmlinux]  [k] _raw_spin_unlock_irq

I was going to try to get the threaded IRQ case, but I've ended up with
perf getting buggered because of the iMX6 SMP perf disfunctionality:

[ 3448.810416] irq 24: nobody cared (try booting with the "irqpoll" option)
...
[ 3448.824528] Disabling IRQ #24

caused by FSL's utterly brain-dead idea of routing all the perf
interrupts to single non-CPU local interrupt input, and the refusal of
kernel folk to find an acceptable solution to support this.

So, sorry, I'm not going to bother trying to get any further with this.
If the job was not made harder stupid hardware design and kernel
politics, then I might be more inclined to do deeper investigation, but
right now I'm finding that I'm not interested in trying to jump through
these stupid hoops.

I think I've proven from the above that this patch needs to be reverted
due to the performance regression, and that there _is_ most definitely
a deterimental effect of switching from tasklets to threaded IRQs.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
