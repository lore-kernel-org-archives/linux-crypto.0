From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Mon, 29 Jul 2013 16:20:48 -0700
Message-ID: <1375140048.22432.400.camel@schen9-DESK>
References: <51EF3BCC.30102@huawei.com>
	 <20130724070621.GA30415@gondor.apana.org.au>
	 <1375130346.22432.399.camel@schen9-DESK>
	 <20130729230806.GA1506@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3G2XUp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jul 2013 19:20:45 -0400
In-Reply-To: <20130729230806.GA1506@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2013-07-30 at 09:08 +1000, Herbert Xu wrote:
> On Mon, Jul 29, 2013 at 01:39:06PM -0700, Tim Chen wrote:
> >
> > Herbert, what are your thoughts on a proper fix to initrd issue for
> > crct10dif modules not getting included?  Or can we
> > let the config option for the pclmul version to be either compiled 
> > out or compiled in for now for people who do want to use this?
> 
> With the MODULES_SOFTDEP patch that Rusty recently merged, all we
> need to do is to use that in lib/crct10dif module.  Once that patch
> hits mainline I'll take care of the rest.

Great. Thanks.

Tim
