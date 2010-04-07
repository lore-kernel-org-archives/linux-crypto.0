From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Date: Wed, 7 Apr 2010 10:23:00 +0200
Message-ID: <20100407082300.GB6619@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
 <20100405084209.GA16788@gondor.apana.org.au>
 <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
 <20100406124412.GA24488@gondor.apana.org.au>
 <20100406203002.GA1842@Chamillionaire.breakpoint.cc>
 <20100407003109.GA27617@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35797 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205Ab0DGIXB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Apr 2010 04:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20100407003109.GA27617@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-04-07 08:31:09 [+0800]:

>On Tue, Apr 06, 2010 at 10:30:02PM +0200, Sebastian Andrzej Siewior wrote:
>>
>> Good point. All arc4 users don't care about return value of setkey so I
>> think that I just change void to int add the check for the valid key
>> length.
>
>Actually, how about getting arc4_setup_iv to do all the legwork
>and turn it into a real IV? Then we don't need any checks on the
>data path.
So arc4_setup_iv() should do what the internal arc4_ivsetup() does and
we change void to int and check the keysize in there right? The problem
here is that we are bounded to *this* implementation of the algorithm
and are not able to replace it with a different implementation. Not that
this is likely to happen for RC4 but it may be true for other stream
ciphers.

>> While we are here, the .setkey() callback could be removed, couldn't it?
>> It returns 0 even it is doing nothing what looks kinda wrong. However it
>> shouldn't be called at all since min/max key is 0. Any objections on
>> that?
>
>I'm pretty sure testmgr will call setkey even for keylen == 0, no?
Prior patch #3 it has no test case so it should not test it at all.
Patch #3 adds a flag in order to distinguish it. You want to look at
patch #3 now :)

>
>Thanks,

Sebastian
