From: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 07:43:45 +0000
Message-ID: <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
 <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1e8e88ad7de64c528f08c75ff9176ab8-fhY3XlRGNI1pWAYlkNb9jaRtKmQZhJ7pQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

The problem with using the add_device_randomness is that we do not know when to call that API, and we have to make our solution either timer-based or interrupt based, which is not really the correct way of implementing this feature.

Thanks,
Miaoqing

-----Original Message-----
From: Pan, Miaoqing 
Sent: Wednesday, August 10, 2016 3:41 PM
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>; Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>; miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; Valo, Kalle <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org; Sepehrdad, Pouyan <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default

Hi Stephan,

That is set as "optional but highly recommended" in the FIPS doc, plus the fact that we do not have a requirement to have a FIP-approved RNG in our case. Although FIPS might impose higher and stronger requirements on the source of entropy, but not passing those tests does not mean the source of entropy is of bad quality. As I mentioned earlier, we just need to evaluate the amount of entropy it provides correctly and use it accordingly. If we are dealing with a chip which has a HW RNG, we expect extremely high entropy close to full from our source, but this patch is for chips which do not have a dedicated HW RNG in place to improve the quality of random number generation on the platform.

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org]
Sent: Wednesday, August 10, 2016 3:27 PM
To: Pan, Miaoqing <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>; Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>; miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; Valo, Kalle <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org; Sepehrdad, Pouyan <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 07:15:49 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> NIST SP 800-22-rev1a and NIST SP 800-90B are used together to evaluate 
> the amount of min entropy the source provides, and not to decide if 
> the source has passed the tests or failed. See
> 
> https://github.com/usnistgov/SP800-90B_EntropyAssessment
> 
> The goal is often to make sure the input entropy is more than the 
> entropy we expect from the output.

You are correct on the SP800-90B tests (hence I did not refer to them for the binary decision). Yet, SP800-22 with the associated tool delivers a binary decision.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
