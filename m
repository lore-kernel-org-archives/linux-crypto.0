Return-Path: <SRS0=akto=2H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D8FC2D0C5
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5842082E
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Dec 2019 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576574592;
	bh=FApipSdfsAMEsktvgc8mIG5R0LeSSG9ADCVylSkXRUY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=wxz1JqY/mntwgCIbFuUh48rsqbaikCa19uZFkF/LASOqkU9mSRtW0ffKLvDX+a8vP
	 apc4sFLE8KzczHE+rZnjQrTjypFvwegw0UidZIUQrZRHmIvot5LaRbI+Hbv0IXm0+v
	 KfYNd/Gexv9FH7JBl7cEFBz8tX+UCBH83c0YaoOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLQJXI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 04:23:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51894 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfLQJXH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 04:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Mime-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CrwtHR4Dny85Y2PIB0EDR3u2w3QOGOAA0nzDYKM9vNM=; b=1qh8GTgFQ64Dtn+OS3j3i4WY2i
        MmmWDqbH99Rmmxn4awZXa/ZIHsqSPspboSp/G8wL51+bee/Mkm9SgoJxm0zTltRwzUk0IMANk2c3S
        6/sqSw8ik0CBKEslCcbL4xWCKvQ8fzcMR+V/SwaCQ+wiWTMxdS93LlhuqQdZhj/dnw2D1hZeODr2e
        vl69fiZEngwgpgUvFA/pO7zLHSs3RbyG8YM6qYcmo/KSA1MczRe0EBu1KxwhyC0mQOI0iYKGen1uB
        gH85C0F5mZz7mhM4kVfTKwPdnU1+zcTvpZWVmulefgd9udhLv7Q6YIw7rxnI1VlyfDLZu+GoYO7r+
        Al1OOJGA==;
Received: from [54.239.6.185] (helo=u0c626add9cce5a.drs10.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ih94F-0002pV-VV; Tue, 17 Dec 2019 09:23:00 +0000
Message-ID: <bcf52e98b1743410a87107b8430da49aec81fddd.camel@kernel.org>
Subject: Re: [PATCH v3] hwrng: core: Freeze khwrng thread during suspend
From:   Amit Shah <amit@kernel.org>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andrey Pronin <apronin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Amit Shah <amit@kernel.org>
Date:   Tue, 17 Dec 2019 10:22:54 +0100
In-Reply-To: <fe7e608e-d94d-a15c-bdc0-8431e9fce5c1@maciej.szmigiero.name>
References: <20190805233241.220521-1-swboyd@chromium.org>
         <4a45b3e0-ed3a-61d3-bfc6-957c7ba631bb@maciej.szmigiero.name>
         <5db85058.1c69fb81.202d7.e3d0@mx.google.com>
         <fbe7268f-3cda-ee0f-d02a-f2e78a599de5@maciej.szmigiero.name>
         <5dc0c12e.1c69fb81.2ce1c.01ee@mx.google.com>
         <fe7e608e-d94d-a15c-bdc0-8431e9fce5c1@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(Apologies for the really late response.)

On Sun, 2019-11-10 at 01:30 +0100, Maciej S. Szmigiero wrote:
> On 05.11.2019 01:24, Stephen Boyd wrote:
> > Quoting Maciej S. Szmigiero (2019-10-29 08:50:52)
> > > On 29.10.2019 15:44, Stephen Boyd wrote:
> > > > Quoting Maciej S. Szmigiero (2019-10-28 16:45:31)
> > > > > Hi Stephen,
> > > > > 
> > > > > On 06.08.2019 01:32, Stephen Boyd wrote:
> > > > > > The hwrng_fill() function can run while devices are
> > > > > > suspending and
> > > > > > resuming. If the hwrng is behind a bus such as i2c or SPI
> > > > > > and that bus
> > > > > > is suspended, the hwrng may hang the bus while attempting
> > > > > > to add some
> > > > > > randomness. It's been observed on ChromeOS devices with
> > > > > > suspend-to-idle
> > > > > > (s2idle) and an i2c based hwrng that this kthread may run
> > > > > > and ask the
> > > > > > hwrng device for randomness before the i2c bus has been
> > > > > > resumed.
> > > > > > 
> > > > > > Let's make this kthread freezable so that we don't try to
> > > > > > touch the
> > > > > > hwrng during suspend/resume. This ensures that we can't
> > > > > > cause the hwrng
> > > > > > backing driver to get into a bad state because the device
> > > > > > is guaranteed
> > > > > > to be resumed before the hwrng kthread is thawed.
> > > > > 
> > > > > This patch broke suspend with virtio-rng loaded (it hangs).
> > > > > 
> > > > > The problematic call chain is:
> > > > > virtrng_freeze() -> remove_common() -> hwrng_unregister() ->
> > > > > kthread_stop().
> > > > > 
> > > > > 
> > > > > It looks like kthread_stop() can't finish on a frozen khwrng
> > > > > thread.
> > > > 
> > > > Can you provide the suspend/resume logs?
> > > 
> > > There isn't much in the kernel log, the closest thing I can get
> > > is
> > > with dyndbg="file drivers/base/power/main.c +p":
> > > [   58.441073][ T3511] virtio-pci 0000:00:06.0: bus freeze
> > > [   58.448744][ T3511] virtio-pci 0000:00:05.0: bus freeze
> > > [   58.454500][ T3511] virtio-pci 0000:00:04.0: bus freeze
> > > [   58.456873][ T3511] virtio-pci 0000:00:03.0: bus freeze
> > > 
> > > And then the VM hangs.
> > > 
> > > The 0000:00:03.0 pci device is virtio-rng.
> > > 
> > > If I add printks around that kthread_stop() in hwrng_unregister()
> > > only the first one gets printed.
> > 
> > Ok. I don't know why virtio rng wants to remove itself and then
> > reprobe
> > across suspend/resume. Do you know the history there?
> 
> Hard to tell, I have added Amit, who had implemented these PM
> callbacks
> back in 2012, to CC now.

The virtio queues need to be in sync with the host across suspend-
resume.  The usual workflow is qemu creates a device, Linux registers
the driver and maybe requests entropy at boot-up.  Later, when the
hibernation image is restored, the previously-running Linux's queue
indexes are used, which don't match with qemu's idea of where the
indexes will be.  This makes qemu terminate the guest.

To overcome this problem, the queues are removed before hibernate, and
recreated after resume -- which ensures both are in sync again.

I can imagine an addition to the virtio spec to re-initialize queues
for the hibernation use-case; but the current code path will have to be
around for the old-qemu usecase.


> 
> > Can you enable the dynamic debug printk in __refrigerator()?
> > 
> > 	file kernel/freezer.c +p
> > 
> > That will let us know when the kthread has been frozen/thawed.
> > 
> > Either way, it sounds like maybe it's what you say, virtio rng
> > wants to
> > call kthread_stop() on a kthread that's been frozen already and
> > then it
> > just hangs waiting for the thread to wake up, which it never does.
> > I
> > can't convince myself that the schedule() inside __refrigerator()
> > won't
> > wake up though. I would think it leaves the refrigerator when
> > kthread_stop() is called because the kthread will wakeup from
> > wake_up_process() in kthread_stop(), see it should stop in
> > __refrigerator() and eventually exit. Maybe the hwrng thread is
> > stuck
> > somewhere else?
> > 
> 
> Yes, it turns out the hwrng kthread is actually stuck inside
> add_hwgenerator_randomness() in wait_event_freezable() call
> introduced
> by commit 59b569480dc8
> ("random: Use wait_event_freezable() in
> add_hwgenerator_randomness()").
> 
> wait_event_freezable() ultimately calls __refrigerator() with its
> check_kthr_stop argument set to false, which causes it to keep the
> kthread frozen even if somebody calls kthread_stop() on it.
> 
> Calling wait_event_freezable() with kthread_should_stop() as a
> condition
> seems racy because it doesn't take into account the situation where
> this
> condition becomes true on a kthread marked for freezing only after it
> has been checked.
> 
> I was able to make the VM write a s2disk image with the following
> change:
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -2500,8 +2500,8 @@ void add_hwgenerator_randomness(const char
> *buffer, size_t count,
>  	 * We'll be woken up again once below
> random_write_wakeup_thresh,
>  	 * or when the calling thread is about to terminate.
>  	 */
> -	wait_event_freezable(random_write_wait,
> -			kthread_should_stop() ||
> +	wait_event_interruptible(random_write_wait,
> +			kthread_should_stop() || freezing(current) ||
>  			ENTROPY_BITS(&input_pool) <=
> random_write_wakeup_bits);
>  	mix_pool_bytes(poolp, buffer, count);
>  	credit_entropy_bits(poolp, entropy);
> 
> Calling freezing() should avoid the issue that the commit
> 59b569480dc8
> has fixed, as it is only a checking function, it doesn't actually do
> the freezing.
> 
> However, while the written image seems valid (the machine will resume
> successfully from it) the suspend process still hangs, only now a bit
> later.
> 
> It turns out there is a second issue where the set_freezable() call
> at the beginning of hwrng_fillfn() will freeze this kthread with
> (again) check_kthr_stop argument set to false when this kthread gets
> relaunched when devices are resumed to write the hibernation image
> at the suspend time.
> 
> That makes the frozen kthread impossible to stop on shutdown, so the
> VM hangs there.
> 
> If I only clear the PF_NOFREEZE flag instead of calling
> set_freezable()
> at the beginning of hwrng_fillfn() the suspend process will complete
> successfully.
> 
> However, it seems to me that the real solution here would be to
> change the virtio-rng driver to not unregister / reregister itself
> on PM events rather than fight the freezer / kthread_stop()
> interactions.
> 
> Maciej







