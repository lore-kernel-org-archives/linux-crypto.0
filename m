From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Thu, 1 Aug 2013 11:47:59 +1000
Message-ID: <20130801014759.GF24286@gondor.apana.org.au>
References: <51EF3BCC.30102@huawei.com>
 <20130724070621.GA30415@gondor.apana.org.au>
 <1375130346.22432.399.camel@schen9-DESK>
 <20130729230806.GA1506@gondor.apana.org.au>
 <1375140048.22432.400.camel@schen9-DESK>
 <87li4o615p.fsf@rustcorp.com.au>
 <20130730112817.GA5516@gondor.apana.org.au>
 <87vc3r4mke.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59106 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250Ab3HABsM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Jul 2013 21:48:12 -0400
Content-Disposition: inline
In-Reply-To: <87vc3r4mke.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 31, 2013 at 09:39:37AM +0930, Rusty Russell wrote:
>
> You're welcome to it: it's v. unlikely to conflict with anything else.
> 
> Here it is, fresh from my pending-rebases branch, with my Signed-off-by.

Great.  I've added it to the cryptodev tree.  Thanks Rusty!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
