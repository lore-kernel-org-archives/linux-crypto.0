From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Tue, 30 Jul 2013 21:28:17 +1000
Message-ID: <20130730112817.GA5516@gondor.apana.org.au>
References: <51EF3BCC.30102@huawei.com>
 <20130724070621.GA30415@gondor.apana.org.au>
 <1375130346.22432.399.camel@schen9-DESK>
 <20130729230806.GA1506@gondor.apana.org.au>
 <1375140048.22432.400.camel@schen9-DESK>
 <87li4o615p.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39795 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342Ab3G3L2k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jul 2013 07:28:40 -0400
Content-Disposition: inline
In-Reply-To: <87li4o615p.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 30, 2013 at 03:26:50PM +0930, Rusty Russell wrote:
>
> Does this imply that you want me to push that to Linus now, and/or CC
> stable?  Was planning for *next* merge window...

Next merge window is fine.  However, it would be good to restore
the new driver for that as well.  So I see two ways to do this,
either we push the crct10dif driver patches through your tree,
on top of the MODULES_SOFTDEP patch, or I pull the MODULES_SOFTDEP
patch into the crypto tree.

What would you like to do?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
