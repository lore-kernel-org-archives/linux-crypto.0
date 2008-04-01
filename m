From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Tue, 01 Apr 2008 20:38:46 +0200
Message-ID: <47F28136.3080502@the2masters.de>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:35937 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYDASjE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2008 14:39:04 -0400
In-Reply-To: <20080330210152.GA25597@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> * Stefan Hellermann | 2008-03-30 21:03:18 [+0200]:
> 
>> Hi,
> Hi,
> 
>> I tested this patch with success, "512 bit key, 8192 byte blocks" is 29% faster!
> That's something.
> 
>> Thanks for this work!
> np :)
> 
>> Tested-By: Stefan Hellermann
>>
>> (Or what is the appropriate line here?)
> I thing that is okey if we add some numbers you provided.
> 
>> Here's tcrypt mode=200 output for xts without this patch
> As far as I remember you posted once some MiB/sec dm-crypt numbers the
> last time. Could you please post them as well since I don't which block
> size is the majority of the read/write request.

Now I have more numbers :)
read from a device through dm-crypt with aes-cts-plain, 256-bit mode (512bit keysize for
cryptsetup)
without this patch: 54MB/s with plain dd(blocksize 512b), 51MB/s with dd and a blocksize
of 512kib (Yes, it's slower with a larger blocksize!)
with this patch: 63MB/s with dd and a blocksize of 512b, 64MB/s with a blocksize of 512k
(This time the larger blocksize was a little bit faster in each test)
I did 5 tests for each combination, top shows everytime ~90% user and ~0% wait

Stefan
