From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 5 Mar 2008 13:01:53 +0100
Message-ID: <20080305120153.GA18425@Chamillionaire.breakpoint.cc>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Stefan Hellermann <stefan@the2masters.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51351 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736AbYCEMBy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 07:01:54 -0500
Content-Disposition: inline
In-Reply-To: <20080305115203.GA28021@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-03-05 19:52:03 [+0800]:

>On Wed, Mar 05, 2008 at 12:46:52PM +0100, Sebastian Siewior wrote:
>>
>> I'm not sure if we are allowed to modify the IV or if it should
>> remain untouched. If it is possible to modify it, I could encrypt it
>> inplace and save two memcpy().
>> I will check this tonight.
>
>I just had a quick look and it seems that you should be able to
>store the result in the IV.
Okey,

>However this won't work for LRW since we need the IV to increment
>it.  But then again LRW seems to be fine as it is since its
>arguments are already aligned by the blkcipher walker.
I just browsed LRW and it seems that it does not encrypt the IV at all.

Stefan: Didn't you report that both, XTS and LRW are broken on your
padlock? If so, could you please post the backtrace?

>
>Thanks,

Sebastian
