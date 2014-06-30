From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [crypto] BUG: unable to handle kernel paging request at ffff88000bb88000
Date: Mon, 30 Jun 2014 15:39:37 +0200
Message-ID: <1485256.DS9rzaQkMP@tauon>
References: <20140629145246.GA9134@localhost> <42550233.Kxs179MjQV@myon.chronox.de> <20140630053126.GA13887@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
	Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	aris@redhat.com, aquini@redhat.com
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50564 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaF3NmX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jun 2014 09:42:23 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S228> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 30 Jun 2014 15:41:07 +0200
In-Reply-To: <20140630053126.GA13887@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 30. Juni 2014, 13:31:26 schrieb Fengguang Wu:

Hi Fengguang,

>Hi Stephan,
>
>On Sun, Jun 29, 2014 at 09:45:48PM +0200, Stephan Mueller wrote:
>> Am Sonntag, 29. Juni 2014, 22:52:46 schrieb Fengguang Wu:
>> 
>> Hi Fengguang,
>> 
>> > Greetings,
>> > 
>> > 0day kernel testing robot got the below dmesg and the first bad
>> > commit is> 
>> May I ask whether there is anything special in your kernel config?
>
>It's an x86_64 randconfig. You may find it in the attachment of the
>original report email.

Thanks, I used that config. I was just wondering whether there were some 
special config options that changed the memory allocation mechanism. The 
kernel configs I used never triggered the issue albeit it should have 
had.

I ran stress tests months ago (with the bug present) where I invoked the 
DRBG for one day, causing billions of rounds of RNG operation where each 
round should have triggered the bug.
>
>> This very bug should have been triggered already in all previous code
>> levels! I am seriously wondering why this bug was not triggered
>> before -- does kalloc somehow allocates more memory than you
>> requested? And only your specific kernel config made kalloc to
>> allocate the exact amount of memory that was requested?
>
>Yeah the bug may have been triggered in other places. If you see
>anything valuable from this bisect result, it would be great. Judging
>from the comparison of 64d1cdfbe2 and its parent commit 3332ee2a17,
>it's pretty reproducible, so easy to verify the possible fixes.

Well, it is not so reproducible as you may think. And I as far as I can 
see the other oops that you send was caused by the same issue.

When I was debugging the issue and just adding some printk statements, 
the crasher went away (reliably) or it crashed at some other random 
places. It was very bizarre. But after adding my fix, I did not see any 
crash any more.

Ciao
Stephan
