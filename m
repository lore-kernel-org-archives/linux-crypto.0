From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Tue, 30 Jul 2013 15:26:50 +0930
Message-ID: <87li4o615p.fsf@rustcorp.com.au>
References: <51EF3BCC.30102@huawei.com> <20130724070621.GA30415@gondor.apana.org.au> <1375130346.22432.399.camel@schen9-DESK> <20130729230806.GA1506@gondor.apana.org.au> <1375140048.22432.400.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:51560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab3G3G0E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jul 2013 02:26:04 -0400
In-Reply-To: <1375140048.22432.400.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tim Chen <tim.c.chen@linux.intel.com> writes:
> On Tue, 2013-07-30 at 09:08 +1000, Herbert Xu wrote:
>> On Mon, Jul 29, 2013 at 01:39:06PM -0700, Tim Chen wrote:
>> >
>> > Herbert, what are your thoughts on a proper fix to initrd issue for
>> > crct10dif modules not getting included?  Or can we
>> > let the config option for the pclmul version to be either compiled 
>> > out or compiled in for now for people who do want to use this?
>> 
>> With the MODULES_SOFTDEP patch that Rusty recently merged, all we
>> need to do is to use that in lib/crct10dif module.  Once that patch
>> hits mainline I'll take care of the rest.
>
> Great. Thanks.
>
> Tim

Does this imply that you want me to push that to Linus now, and/or CC
stable?  Was planning for *next* merge window...

Cheers,
Rusty.
