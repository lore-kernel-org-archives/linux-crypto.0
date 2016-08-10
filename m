From: Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 13:24:49 +0000
Message-ID: <20160810132449.GH2013@io.lakedaemon.net>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
 <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com>
 <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <389c3c1fdde2447aacf31a8b4aadfc08-fhY3XlRGNI1pWAYlkNb9jaRtKmQZhJ7pQQ4Iyu8u01E@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Miaoqing Pan, Stephen,

*gentle reminder: others are reading which may not be directly included
in the conversation.  Including the archives.  Please avoid top posting.
:)

On Wed, Aug 10, 2016 at 07:43:45AM +0000, Pan, Miaoqing wrote:
> The problem with using the add_device_randomness is that we do not
> know when to call that API, and we have to make our solution either
> timer-based or interrupt based, which is not really the correct way of
> implementing this feature.

Exactly.  I think we're dancing around the problem by discussing the
quality of what the ath9k adc provides.

The fact is, barring userspace expectations of /dev/hwrng, hw_random is
the appropriate place for it.  It's not a devicetree blob, mac address,
or pci config space.  Which are things we feed in once for the heck of
it.  This is a *continuous* source or questionable quality.

I'm seriously considering putting this and timeriomem-rng into a
subdirectory under hw_random/, maybe environ/.  Anything in there gets
quality=0 for default, and *doesn't* contribute to /dev/hwrng.

Regardless which path we take, I think we should include 'adc' in the
name.  I've heard countless times about "Atheros cards come with an rng
on board". :-/

thx,

Jason.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
