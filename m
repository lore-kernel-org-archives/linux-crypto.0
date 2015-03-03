From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Tue, 3 Mar 2015 17:44:21 +0200
Message-ID: <54F5D6D5.8070407@freescale.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
 <54F464E4.8080204@freescale.com> <54F475A8.6030105@gmail.com>
 <20150302220923.GC30523@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Martin Hicks <mort@bork.org>, Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0117.outbound.protection.outlook.com ([207.46.100.117]:28621
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756999AbbCCPok (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 10:44:40 -0500
In-Reply-To: <20150302220923.GC30523@darwin.bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/3/2015 12:09 AM, Martin Hicks wrote:
> 
> On Mon, Mar 02, 2015 at 03:37:28PM +0100, Milan Broz wrote:
>>
>> If crypto API allows to encrypt more sectors in one run
>> (handling IV internally) dmcrypt can be modified of course.
>>
>> But do not forget we can use another IV (not only sequential number)
>> e.g. ESSIV with XTS as well (even if it doesn't make much sense, some people
>> are using it).
> 
> Interesting, I'd not considered using XTS with an IV other than plain/64.
> The talitos hardware would not support aes/xts in any mode other than
> plain/plain64 I don't think...Although perhaps you could push in an 8-byte
> IV and the hardware would interpret it as the sector #.
> 

For talitos, there are two cases:

1. request data size is <= data unit / sector size
talitos can handle any IV / tweak scheme

2. request data size > sector size
since talitos internally generates the IV for the next sector by
incrementing the previous IV, only IV schemes that allocate consecutive
IV to consecutive sectors will function correctly.

Let's not forget what XTS standard says about IVs / tweak values:
- each data unit (sector in this case) is assigned a non-negative tweak
value and
- tweak values are assigned *consecutively*, starting from an arbitrary
non-negative value
- there's no requirement for tweak values to be unpredictable

Thus, in theory ESSIV is not supposed to be used with XTS mode: the IVs
for consecutive sectors are not consecutive values.
In practice, as Milan said, the combination is sometimes used. It
functions correctly in SW (and also in talitos as long as req. data size
<= sector size).

>> Maybe the following question would be if the dmcrypt sector IV algorithms
>> should moved into crypto API as well.
>> (But because I misused dmcrypt IVs hooks for some additional operations
>> for loopAES and old Truecrypt CBC mode, it is not so simple...)
> 
> Speaking again with talitos in mind, there would be no advantage for this
> hardware.  Although larger requests are possible only a single IV can be
> provided per request, so for algorithms like AES-CBC and dm-crypt 512byte IOs
> are the only option (short of switching to 4kB block size).

Right, as explained above talitos does what the XTS mode standard
mandates. So it won't work properly in case of cbc-aes:essiv with
request sizes larger than sector size.

Still, in SW at least, XTS could be improved to process more sectors in
one shot, regardless of the IV scheme used - as long as there's a
IV.next() function and both data size and sector size are known.

Horia
