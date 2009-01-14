From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
Date: Wed, 14 Jan 2009 19:23:44 +1100
Message-ID: <20090114082344.GA16692@gondor.apana.org.au>
References: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com> <20090114065359.GA16044@gondor.apana.org.au> <1231916511.5937.151.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59982 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753305AbZANIXs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 03:23:48 -0500
Content-Disposition: inline
In-Reply-To: <1231916511.5937.151.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 03:01:51PM +0800, Huang Ying wrote:
> 
> Current cryptd works well for AES-NI implementation. But how about
> somebody want cryptd(cbc(aes)), and don't care about the driver.

That's not an issue, if the user wants then all he has to do is
create cryptd(cbc(aes)) (how that is done is a different matter,
hopefully something that we will address as part of the user-space
API to crypto API), and then just using cbc(aes) will be sufficient.

In any case, the algorithm name has to be cbc(aes) for it to work,
since that is what it is.
 
> Yes, not an issue for AES-NI case until now. But, for example there is
> no aes-ni, if someone request cryptd(cbc(aes-asm)), other user will get
> cryptd(cbc(aes-asm)) instead of cbc(aes-asm) when request cbc(aes), is
> this a good behavior?

The idea is to allow user-space to control priorities in future
through a netlink interface.  Then this simply becomes a matter
of system administration.

For now you simply don't create the cryptd object if you don't
intend to use it as the system default for that algorithm.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
