From: Michal Ludvig <michal@logix.cz>
Subject: Re: PadLock XSHA
Date: Mon, 01 Sep 2008 13:32:48 +1200
Message-ID: <48BB4640.1040407@logix.cz>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz> <20080831020941.GA25048@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bubetka.logix.cz ([208.84.148.239]:44034 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752363AbYIABbb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Aug 2008 21:31:31 -0400
In-Reply-To: <20080831020941.GA25048@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Sat, Aug 30, 2008 at 09:55:00PM +1200, Michal Ludvig wrote:
>> IIRC The first versions of VIA PadLock required the input data to be
>> aligned on 16-bytes boundaries and more importantly they always
>> finalised the hash. Therefore we had to collect all data before hashing
>> them.
> 
> Hmm, the current manual states that it does a bswap on the input
> and therefore alignment isn't required.  There is no mention about
> older processors requiring 16-byte alignment.

That's right, I confused SHA with AES in PadLock, sorry. With AES the 
first versions required 16-byte alignment on input and output data as 
well as on the control word and there's a flag in newer PadLocks that 
allow doing AES on unaligned data.

>> AFAIK Recent versions of PadLock don't insist on finalising the hash and
>>  don't insist on input data alignment either and this workaround isn't
>> needed anymore. I don't know if VIA still sells their motherboard models
>> with the older CPUs or not.
> 
> Interesting.  I couldn't find anything in the manual about not
> requireing finalisation.  Do you know where I can find out more
> about this?

I can't find any PadLock guide newer than 2005-05-03 (probably the same 
one that you have). I'll check with VIA what the status of this is.

Michal
