From: Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Thu, 11 Aug 2016 13:14:24 +0000
Message-ID: <20160811131424.GI2013@io.lakedaemon.net>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
 <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com>
 <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
 <20160810132449.GH2013@io.lakedaemon.net>
 <14a3879458f3bfc36068c2e8294ca448@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14a3879458f3bfc36068c2e8294ca448-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 11, 2016 at 10:54:11AM +0800, miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> On 2016-08-10 21:24, Jason Cooper wrote:
> >The fact is, barring userspace expectations of /dev/hwrng, hw_random is
> >the appropriate place for it.  It's not a devicetree blob, mac address,
> >or pci config space.  Which are things we feed in once for the heck of
> >it.  This is a *continuous* source or questionable quality.
> >
> >I'm seriously considering putting this and timeriomem-rng into a
> >subdirectory under hw_random/, maybe environ/.  Anything in there gets
> >quality=0 for default, and *doesn't* contribute to /dev/hwrng.
> >
> >Regardless which path we take, I think we should include 'adc' in the
> >name.  I've heard countless times about "Atheros cards come with an rng
> >on board". :-/
> 
> If I understand correctly, you want to bind the ADC source to
> /dev/hwrng, and then change rng-tools to set the entropy to zero in
> the ioctl call ?  There are two major problems with that approach,

Nope.  I want to leverage the hwrng framework to facilitate feeding the
*kernel* entropy pools like all the other hwrngs do currently.  The
difference for *environmental* sources is that when userspace read()s
from /dev/hwrng, they will *not* contribute.

If the environmental sources are the only sources, then no /dev/hwrng
should appear.

> 1) We already tried once before to bind our solution to /dev/hwrng,
> and got so much complaints. The conclusion was that maybe we know that
> the output of /dev/hwrng does not have perfect entropy, but a normal
> user does not know and will misuse it. You mentioned in
> https://www.kernel.org/doc/Documentation/hw_random.txt we have
> 
> "This data is NOT CHECKED by any
> 	fitness tests, and could potentially be bogus (if the
> 	hardware is faulty or has been tampered with).  Data is only
> 	output if the hardware "has-data" flag is set, but nevertheless
> 	a security-conscious person would run fitness tests on the
> 	data before assuming it is truly random."
> 
> But this is not enough to convince upstream to switch to /dev/hwrng.
> I think the concern of users misusing the solution is a very valid
> concern.

Agreed.

> 2) If we set the entropy to zero in rng-tools, we cannot tolerate the
> load.  Rng-tools is not a timer-based solution. Similar to our
> solution, it is based on
> /proc/sys/kernel/random/write_wakeup_threshold. If we do not increase
> the entropy counter, rng-tools keep writing into the pool, and both
> rng-tools and WiFi chip will be overloaded.

That's why I propose a change to the hwrng framework to permit noise
sources while not wiring them up to feed /dev/hwrng.  timeriomem-rng
should have the same problem ath9k-rng does.

Basically, if it wasn't designed to be an rng, it shouldn't be wired up
to /dev/hwrng.

thx,

Jason.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
