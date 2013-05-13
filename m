From: "Fernandes, Joel A" <joelagnel@ti.com>
Subject: RE: [PATCH] OMAP: AES: Don't idle/start AES device between Encrypt
 operations
Date: Mon, 13 May 2013 19:39:24 +0000
Message-ID: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4D6E5F@DLEE08.ent.ti.com>
References: <1368293024-6654-1-git-send-email-joelagnel@ti.com>
 <878v3i6dne.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: Kevin Hilman <khilman@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52115 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab3EMTj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 15:39:28 -0400
In-Reply-To: <878v3i6dne.fsf@linaro.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kevin,
Thanks for your review.

> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@linaro.org]
> Sent: Monday, May 13, 2013 11:36 AM
> To: Fernandes, Joel A
> Cc: linux-crypto@vger.kernel.org; linux-omap@vger.kernel.org; Mark A. Greer
> Subject: Re: [PATCH] OMAP: AES: Don't idle/start AES device between Encrypt
> operations
> 
> Joel A Fernandes <joelagnel@ti.com> writes:
> 
> > Calling runtime PM API for every block causes serious perf hit to
> > crypto operations that are done on a long buffer.
> > As crypto is performed on a page boundary, encrypting large buffers
> > can cause a series of crypto operations divided by page. The runtime
> > PM API is also called those many times.
> >
> > We call runtime_pm_get_sync only at beginning of the session
> > (cra_init) and runtime_pm_put at the end. This result in upto a 50% speedup
> as below:
> >
> > Before:
> > root@beagleboard:~# time -v openssl speed -evp aes-128-cbc Doing
> > aes-128-cbc for 3s on 16 size blocks: 13310 aes-128-cbc's in 0.01s
> > Doing aes-128-cbc for 3s on 64 size blocks: 13040 aes-128-cbc's in
> > 0.04s Doing aes-128-cbc for 3s on 256 size blocks: 9134 aes-128-cbc's
> > in 0.03s Doing aes-128-cbc for 3s on 1024 size blocks: 8939
> > aes-128-cbc's in 0.01s Doing aes-128-cbc for 3s on 8192 size blocks:
> > 4299 aes-128-cbc's in 0.00s
> >
> > After:
> > root@beagleboard:~# time -v openssl speed -evp aes-128-cbc Doing
> > aes-128-cbc for 3s on 16 size blocks: 18911 aes-128-cbc's in 0.02s
> > Doing aes-128-cbc for 3s on 64 size blocks: 18878 aes-128-cbc's in
> > 0.02s Doing aes-128-cbc for 3s on 256 size blocks: 11878 aes-128-cbc's
> > in 0.10s Doing aes-128-cbc for 3s on 1024 size blocks: 11538
> > aes-128-cbc's in 0.05s Doing aes-128-cbc for 3s on 8192 size blocks:
> > 4857 aes-128-cbc's in 0.03s
> >
> > While at it, also drop enter and exit pr_debugs, in related code.
> > tracers are exactly used for that.
> >
> > Tested on a Beaglebone (AM335x SoC) board.
> >
> > Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> 
> Did you explore using runtime PM autosuspend timeouts for this instead?
> They are intended for exactly this kind of thing, and the timeouts can have sane
> defaults, but can be configured from userspace to allow a power/performance
> trade-off.
[Joel] Actually, I feel there is no real benefit in calling runtime PM api so many
times in between crypto operations. The patch just moves the runtime pm usage
to the beginning and end of a crypto session which will have to be created anyway.
Imagine encrypting a 20M block- this means runtime PM API is called
20 * 1024 / 4 =~ 5000 times. The slow down in my opinion doesn't make it worth it.
What is your opinion about this?
I can explore runtime-pm timeouts and propose the numbers to describe what would
the speedup w/ my patch and w/ timeouts.

> [...]
> 
> >  static void omap_aes_cra_exit(struct crypto_tfm *tfm)  {
> > -	pr_debug("enter\n");
> > +	struct omap_aes_dev *dd = NULL;
> > +
> > +	/* Find AES device, currently picks the first device */
> > +	spin_lock_bh(&list_lock);
> > +	list_for_each_entry(dd, &dev_list, list) {
> > +		break;
> > +	}
> > +	spin_unlock_bh(&list_lock);
> > +
> > +	pm_runtime_put_sync(dd->dev);
> 
> nit: Why use the synchronous call here?  The original was async.
[Joel] Async was required there because that was in interrupt context. It was originally sync but changed to
async in another separate patch.

Thanks,
Joel
