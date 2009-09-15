From: Octavian Purdila <opurdila@ixiacom.com>
Subject: Re: ESP hardware acceleration
Date: Tue, 15 Sep 2009 20:57:56 +0300
Message-ID: <200909152057.56987.opurdila@ixiacom.com>
References: <20090915171252.GA30986@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dimitris@siganos.org, linux-crypto@vger.kernel.org,
	abadea@ixiacom.com, ddogaru@ixiacom.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:18852 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbZIOSAZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 14:00:25 -0400
In-Reply-To: <20090915171252.GA30986@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 15 September 2009 20:12:52 you wrote:

> > However, I think that the best results for hw accel will be obtained if
> > you accelerate the AEAD interface.
> 
> If your driver benefits from seeing both the hashing request and the
> cipher request at the same time then by all means go for the AEAD
> interface.  But don't feel compelled to use it just because it's
> there :)

I think this interface has the advantage of doing only one DMA transfer per 
ESP packet instead of two such transfers required when using separate encr + 
auth. (of course this may not matter at all on some architectures)

> > Speaking of hw accel, we are also playing with it and we got moderately
> > good results. We are now running into two major software bottlenecks:
> > memcpy (because of the copy required by TCP traffic) and CRC computation.
> 
> What platform is this? 
> 

Its a ppc750 CPU clocked at 1GHz - pretty low end compared with today's 
hardware. We were able to get about 360Mbits L2 throughput (TCP traffic) with 
our hw accel engine although theoretically the hw engine can go up much higher 
(and profiling the the hw engine itself shows that it is significantly idle).

>  And where does CRC come into this?

Sorry, what I meant was TCP checksum. 

tavi





