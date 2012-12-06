From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Thu, 6 Dec 2012 17:07:10 +0800
Message-ID: <20121206090710.GA15642@gondor.apana.org.au>
References: <50AB8DB3.6040008@redhat.com>
 <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
 <50ACC2AD.2060100@redhat.com>
 <20121122023308.GA19138@gondor.apana.org.au>
 <DB904C5425BA6F4E8424B3B51A1414D173F34B2D8E@NWD2CMBX1.ad.analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50716 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964788Ab2LFJHT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2012 04:07:19 -0500
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D173F34B2D8E@NWD2CMBX1.ad.analog.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 22, 2012 at 03:38:45AM -0500, Zhang, Sonic wrote:
> 
> >On Wed, Nov 21, 2012 at 01:01:49PM +0100, Milan Broz wrote:
> >>
> >> On 11/21/2012 12:29 PM, Zhang, Sonic wrote:
> >> > Is there a policy that the CRC test vector in testmgr.h should
> >> > support all CRC drivers?
> >> > If so, I am fine to drop this test vector.
> >>
> >> Question for Herbert...
> >> But the problem I see is that it confuses people, it simply returns
> >> fail everytime (except Blackfin platform).
> >>
> >> My mail originates from bug report "tcrypt tests started failing", and
> >> it was not obvious why (for people not familiar with tcrypt internals,
> >> they just tried all test modes available).
> >
> >We should just make a generic version of crc32 available.
> >
> 
> Hi Herbert and Broz,
> 
> Unfortunately, after investigating the hardware manual of Blackfin CRC engine and the CRC algorithm, I have to say the Blackfin CRC driver can't use current crc32c test vector in testmgr.h. Blackfin CRC engine only supports big endian CRC algorithm, while current crypto crc32c driver uses little endian CRC algorithm. The big endian CRC digest is different from that of the little endian.
> 
> There are 2 solutions. One is to add a big endian crc32c test vector. The other is to keep the Blackfin specific test vector. However, neither meets Broz's expectation of a generic crc32 test vector.
> 
> Any idea?

I think we should just remove the blackfin crc driver altogether
as nothing in the kernel ever uses hmac(crc32).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
