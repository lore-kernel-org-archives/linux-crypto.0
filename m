From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Tue, 30 Jul 2013 09:08:06 +1000
Message-ID: <20130729230806.GA1506@gondor.apana.org.au>
References: <51EF3BCC.30102@huawei.com>
 <20130724070621.GA30415@gondor.apana.org.au>
 <1375130346.22432.399.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42813 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754155Ab3G2XIU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jul 2013 19:08:20 -0400
Content-Disposition: inline
In-Reply-To: <1375130346.22432.399.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 29, 2013 at 01:39:06PM -0700, Tim Chen wrote:
>
> Herbert, what are your thoughts on a proper fix to initrd issue for
> crct10dif modules not getting included?  Or can we
> let the config option for the pclmul version to be either compiled 
> out or compiled in for now for people who do want to use this?

With the MODULES_SOFTDEP patch that Rusty recently merged, all we
need to do is to use that in lib/crct10dif module.  Once that patch
hits mainline I'll take care of the rest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
