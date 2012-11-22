From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Tcrypt  hmac(crc32) test can work only on Blackfin
Date: Thu, 22 Nov 2012 10:33:08 +0800
Message-ID: <20121122023308.GA19138@gondor.apana.org.au>
References: <50AB8DB3.6040008@redhat.com>
 <DB904C5425BA6F4E8424B3B51A1414D173F34B2A37@NWD2CMBX1.ad.analog.com>
 <50ACC2AD.2060100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Zhang, Sonic" <Sonic.Zhang@analog.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:35710 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753572Ab2KVWkM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2012 17:40:12 -0500
Content-Disposition: inline
In-Reply-To: <50ACC2AD.2060100@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 21, 2012 at 01:01:49PM +0100, Milan Broz wrote:
> 
> On 11/21/2012 12:29 PM, Zhang, Sonic wrote:
> > Is there a policy that the CRC test vector
> > in testmgr.h should support all CRC drivers?
> > If so, I am fine to drop this test vector.
> 
> Question for Herbert...
> But the problem I see is that it confuses people, it simply
> returns fail everytime (except Blackfin platform).
> 
> My mail originates from bug report "tcrypt tests started failing",
> and it was not obvious why (for people not familiar with tcrypt
> internals, they just tried all test modes available).

We should just make a generic version of crc32 available.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
