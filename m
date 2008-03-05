From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 05 Mar 2008 15:02:29 +0100
Message-ID: <47CEA7F5.2080700@the2masters.de>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc> <20080305115203.GA28021@gondor.apana.org.au> <20080305120153.GA18425@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:43194 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYCEODW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 09:03:22 -0500
In-Reply-To: <20080305120153.GA18425@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> * Herbert Xu | 2008-03-05 19:52:03 [+0800]:
> 
>> On Wed, Mar 05, 2008 at 12:46:52PM +0100, Sebastian Siewior wrote:
>>> I'm not sure if we are allowed to modify the IV or if it should
>>> remain untouched. If it is possible to modify it, I could encrypt it
>>> inplace and save two memcpy().
>>> I will check this tonight.
>> I just had a quick look and it seems that you should be able to
>> store the result in the IV.
> Okey,
> 
>> However this won't work for LRW since we need the IV to increment
>> it.  But then again LRW seems to be fine as it is since its
>> arguments are already aligned by the blkcipher walker.
> I just browsed LRW and it seems that it does not encrypt the IV at all.
> 
> Stefan: Didn't you report that both, XTS and LRW are broken on your
> padlock? If so, could you please post the backtrace?

I think it crashed one time, but I haven't really tried using LRW since XTS is said to
provide better security. Now I'm not able to reproduce the crash, it works with vanilla
2.6.25-rc4.

I have other problems in 2.6.25-rc[1-3], I get segfaults every here and then. I tried
compiling gcc several time, 90% of the time it crashed somewhere. I have the feeling it
segfaults faster when I do the compile in a tmpfs-mounted directory. 2.6.24 works fine, I
haven't tested 2.6.25-rc4. I have to check my RAM, if it's good I will report this to LKML.
I think the LRW-crash I reported could be related to this.

Thanks
Stefan

PS: I'm away from Thursday 12:00 UTC till Tuesday.


> 
>> Thanks,
> 
> Sebastian
