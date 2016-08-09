From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Subject: RE: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Tue, 9 Aug 2016 06:30:03 +0000
Message-ID: <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Ted Tso <tytso@mit.edu>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31922 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbcHIGaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 02:30:11 -0400
In-Reply-To: <20160808172930.GD4511@io.lakedaemon.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jason, Stephan,

Agree with Jason's point, also  understand Stephan's concern.  The date rate can be roughly estimated by 'cat /dev/random |rngtest -c 1000',  the average speed is 1111.294Kibits/s. I will sent the patch to disable ath9k RNG by default. 

Thanks,
Miaoqing

-----Original Message-----
From: Jason Cooper [mailto:jason@lakedaemon.net] 
Sent: Tuesday, August 09, 2016 1:30 AM
To: Stephan Mueller <smueller@chronox.de>
Cc: Pan, Miaoqing <miaoqing@qti.qualcomm.com>; Ted Tso <tytso@mit.edu>; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>; herbert@gondor.apana.org.au; linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org; Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy

Hi Stephan, Miaoqing Pan,

On Mon, Aug 08, 2016 at 08:41:36AM +0200, Stephan Mueller wrote:
> Am Montag, 8. August 2016, 02:03:36 CEST schrieb Pan, Miaoqing:
> > The entropy was evaluated by crypto expert,  the analysis report 
> > show the ADC with at least 10bits and up to 22 bits of min-entropy 
> > for a 32 bits value, we conservatively assume the min-entropy is 10 
> > bits out of 32 bits, so that's why set entropy quality  to  320/1024 = 10/32.

Ok, so the relevant commit is:

  ed14dc0af7cce ath9k: feeding entropy in kernel from ADC capture

Which refers to a previous commit:

  6301566e0b2d ath9k: export HW random number generator

> > Also we have explained in the commit message why can't use the HW 
> > RNG framework.

>From ed14dc0af7cce:

"""
Since ADC was not designed to be a dedicated HW RNG, we do not want to bind it to /dev/hwrng framework directly.
"""

> Where is the description of the RNG, where is the test implementation? 
> > 
> > Otherwise, your patch will cause high CPU load,  as continuously 
> > read ADC data if entropy bits under write_wakeup_threshold.
> 
> The issue is that although you may have analyzed it, others are unable 
> to measure the quality of the RNG and assess the design as well as the 
> implementation of the RNG. This RNG is the only implementation of a 
> hardware RNG that per default and without being able to change it at 
> runtime injects data into the input_pool where the noise source cannot 
> be audited. Note, even other respected RNG noise sources like the 
> Intel RDRAND will not feed into / dev/random per default in a way that dominates all other noise sources.
> 
> I would like to be able to deactivate that noise source to the extent 
> that it does not cause /dev/random to unblock. The reason is that your 
> noise source starts to dominate all other noise sources.

I think the short-term problem here is the config logic:

config ATH9K_HWRNG
       bool "Random number generator support"
       depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
       default y

If you have *any* hwrngs you want to use and you have an ath9k card (HW_RANDOM = y and ATH9K != n), you get the behavior Stephan is pointing out.

Short term, we should just default no here.

> If you think that this patch is a challenge because your driver starts 
> to spin, please help and offer another solution.

Well, I don't buy the reasoning listed above for not using the hwrng framework.  Interrupt timings were never designed to be a source of entropy either.  We need to grab it where ever we can find it, especially on embedded systems.  Documentation/hw_random.txt even says:

"""
This data is NOT CHECKED by any fitness tests, and could potentially be bogus (if the hardware is faulty or has been tampered with).
"""

I really don't think there's a problem with adding these sorts of sources under char/hw_random/.  I think the only thing we would be concerned about, other than the already addressed entropy estimation, would be constraining the data rate.

Is ath9k the only wireless card that exposes ADC registers?  What about sound cards?

thx,

Jason.
