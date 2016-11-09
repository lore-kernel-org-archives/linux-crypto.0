From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/14] Revert "crypto: caam - get rid of tasklet"
Date: Thu, 10 Nov 2016 00:17:59 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1611092358390.3501@nanos>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com> <1478681184-9442-12-git-send-email-horia.geanta@nxp.com> <20161109085322.GY1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-437637051-1478732497=:3501"
Cc: =?ISO-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59539 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbcKIXUo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 18:20:44 -0500
In-Reply-To: <20161109085322.GY1041@n2100.armlinux.org.uk>
Content-ID: <alpine.DEB.2.20.1611100004200.3501@nanos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-437637051-1478732497=:3501
Content-Type: text/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.20.1611100004201.3501@nanos>

On Wed, 9 Nov 2016, Russell King - ARM Linux wrote:
> Please include Thomas in this.

Thanks!
 
> On Wed, Nov 09, 2016 at 10:46:21AM +0200, Horia Geantã wrote:
> > This reverts commit 66d2e2028091a074aa1290d2eeda5ddb1a6c329c.
> > 
> > Quoting from Russell's findings:
> > https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg21136.html
> > 
> > [quote]
> > Okay, I've re-tested, using a different way of measuring, because using
> > openssl speed is impractical for off-loaded engines.  I've decided to
> > use this way to measure the performance:
> > 
> > dd if=/dev/zero bs=1048576 count=128 | /usr/bin/time openssl dgst -md5
> > 
> > For the threaded IRQs case gives:
> > 
> > 0.05user 2.74system 0:05.30elapsed 52%CPU (0avgtext+0avgdata 2400maxresident)k
> > 0.06user 2.52system 0:05.18elapsed 49%CPU (0avgtext+0avgdata 2404maxresident)k
> > 0.12user 2.60system 0:05.61elapsed 48%CPU (0avgtext+0avgdata 2460maxresident)k
> > 	=> 5.36s => 25.0MB/s
> > 
> > and the tasklet case:
> > 
> > 0.08user 2.53system 0:04.83elapsed 54%CPU (0avgtext+0avgdata 2468maxresident)k
> > 0.09user 2.47system 0:05.16elapsed 49%CPU (0avgtext+0avgdata 2368maxresident)k
> > 0.10user 2.51system 0:04.87elapsed 53%CPU (0avgtext+0avgdata 2460maxresident)k
> > 	=> 4.95 => 27.1MB/s
> > 
> > which corresponds to an 8% slowdown for the threaded IRQ case.  So,
> > tasklets are indeed faster than threaded IRQs.

Each operation involves:

 submit job
 hard irq handler
 wakeup irq thread
 context switch
 wakeup openssl
 context switch

and that repeats over and over.

Russell has provided me traces and the extra wakeup/context switch is what
causes the slowdown vs. the tasklet case which has only one wakeup/context
switch, unless it gets outsourced to ksoftirqd which might get even slower
than the threaded handler.

You might add something like that to the changelog so it's not just a
number comparison which does not explain why this happens.

Thanks,

	tglx





--8323329-437637051-1478732497=:3501--
