From: Milan Broz <mbroz@redhat.com>
Subject: Re: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Wed, 21 Nov 2012 13:01:49 +0100
Message-ID: <50ACC2AD.2060100@redhat.com>
References: <50AB8DB3.6040008@redhat.com> <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2KUMCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2012 07:02:18 -0500
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 11/21/2012 12:29 PM, Zhang, Sonic wrote:
> Is there a policy that the CRC test vector
> in testmgr.h should support all CRC drivers?
> If so, I am fine to drop this test vector.

Question for Herbert...
But the problem I see is that it confuses people, it simply
returns fail everytime (except Blackfin platform).

My mail originates from bug report "tcrypt tests started failing",
and it was not obvious why (for people not familiar with tcrypt
internals, they just tried all test modes available).

>> IMHO either it should provide crc32c (as do generic, sparc or x86 hw drivers) or
>> the block size for crc32c should be 4... (and test vector is wrong then)
>>
> 
> I can set the default polynomials to that of crc32c for blackfin crc32 driver.
> But, it should not be limited to crc32c.

Sure, my question was just about test vector, hw driver support
for something more is of course good thing.

But it would be nice to have "crc32c" directly supported/accelerated as well.

Thanks,
Milan
