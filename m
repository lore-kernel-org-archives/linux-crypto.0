From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Subject: RE: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Thu, 22 Nov 2012 03:38:45 -0500
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D173F34B2D8E@NWD2CMBX1.ad.analog.com>
References: <50AB8DB3.6040008@redhat.com>
 <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
 <50ACC2AD.2060100@redhat.com> <20121122023308.GA19138@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.208] ([213.199.154.208]:25365 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755340Ab2KVSm2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2012 13:42:28 -0500
In-Reply-To: <20121122023308.GA19138@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



>-----Original Message-----
>From: Herbert Xu [mailto:herbert@gondor.hengli.com.au]
>Sent: Thursday, November 22, 2012 10:33 AM
>To: Milan Broz
>Cc: Zhang, Sonic; linux-crypto@vger.kernel.org
>Subject: Re: Tcrypt hmac(crc32) test can work only on Blackfin
>
>On Wed, Nov 21, 2012 at 01:01:49PM +0100, Milan Broz wrote:
>>
>> On 11/21/2012 12:29 PM, Zhang, Sonic wrote:
>> > Is there a policy that the CRC test vector in testmgr.h should
>> > support all CRC drivers?
>> > If so, I am fine to drop this test vector.
>>
>> Question for Herbert...
>> But the problem I see is that it confuses people, it simply returns
>> fail everytime (except Blackfin platform).
>>
>> My mail originates from bug report "tcrypt tests started failing", and
>> it was not obvious why (for people not familiar with tcrypt internals,
>> they just tried all test modes available).
>
>We should just make a generic version of crc32 available.
>

Hi Herbert and Broz,

Unfortunately, after investigating the hardware manual of Blackfin CRC engine and the CRC algorithm, I have to say the Blackfin CRC driver can't use current crc32c test vector in testmgr.h. Blackfin CRC engine only supports big endian CRC algorithm, while current crypto crc32c driver uses little endian CRC algorithm. The big endian CRC digest is different from that of the little endian.

There are 2 solutions. One is to add a big endian crc32c test vector. The other is to keep the Blackfin specific test vector. However, neither meets Broz's expectation of a generic crc32 test vector.

Any idea?

Regard,

Sonic
