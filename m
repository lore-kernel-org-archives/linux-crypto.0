From: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 06:46:31 +0000
Message-ID: <82844e4b56c9475fabf22b3fe12b53bb@aptaiexm02f.ap.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1543667.vXsZDTRgbm@positron.chronox.de>
 <866e31b50f364a87aabe94d2af03ecb8@aptaiexm02f.ap.qualcomm.com>
 <14565196.xaXq375WQg@tauon.atsec.com>
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
In-Reply-To: <14565196.xaXq375WQg-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

Would you please provide a recent NIST document which asks the entropy source to pass the NIST randomness tests ?

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org] 
Sent: Wednesday, August 10, 2016 2:25 PM
To: Pan, Miaoqing <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>; Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>; miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org; Valo, Kalle <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org; Sepehrdad, Pouyan <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 06:04:32 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> FIPS RNG test is supposed to be run on the output of an RNG, and not 
> on the RNG entropy source. It is not surprising that the RNG input 
> fails the entropy tests from NIST. Check the following example.
> 
> Imagine you have a perfectly random sequence, a_1, a_2, .., a_n, where 
> each a_i is a byte. And imagine, this sequence passes all randomness tests.
> 
> Now, let's say I create a new sequence a_1, 0, a_2, 0, a_3, 0, ..., 0, 
> a_n, where each zero is a byte
> 
> If you give this sequence (as an entropy source) to a randomness test, 
> it will fail most of the tests, if not all. This does not mean this 
> sequence is not appropriate as an entropy source, it just means we 
> need twice more bytes to gain the same amount of entropy.

Agreed. But that is a very simplistic view.
> 
> I can give this 2n byte sequence to an RNG as an entropy source and it 
> provides the same amount of security as if I give the n byte stream.

Well, I am working with standards bodies like NIST and BSI on RNG assessments. They all require that the noise source (pre-whitening, of
course) pass statistical tests like the AIS20 tests, SP800-22 and similar. If you fail, you better have a good argument.

And the only argument that is kind of allowed is that you oversample your noise source to seed a DRNG from (i.e. have an entropy to data ratio of significantly below 1). And the argument for the oversampling rate is always a very interesting discussion. You apply 10/32. In private, I am wondering about that ratio, but this should not be discussed here as I hope you have a valid argument for that.

As we are talking about the current rngd, we have to consider that it does
*not* perform an oversampling (yet) as mentioned in the previous emails.

Do not get me wrong on my initial patch: your RNG may provide some entropy. 
But there are quite some folks who want to understand and audit a noise source before using it. Your current implementation simply does not allow switching the noise source off to feed the input_pool with data that increases the entropy estimator (at runtime).

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
