From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Fri, 2 Jan 2009 22:24:27 +0100
Message-ID: <20090102212427.GA19624@Chamillionaire.breakpoint.cc>
References: <20081219202603.GA31265@lst.de> <20081220032159.GA15615@gondor.apana.org.au> <1230022166.17529.82.camel@yhuang-dev.sh.intel.com> <20081223130154.GA23717@Chamillionaire.breakpoint.cc> <1230083021.17529.98.camel@yhuang-dev.sh.intel.com> <20081224044851.GA20851@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Huang Ying <ying.huang@intel.com>, Christoph Hellwig <hch@lst.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53506 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629AbZABVYf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Jan 2009 16:24:35 -0500
Content-Disposition: inline
In-Reply-To: <20081224044851.GA20851@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-12-24 15:48:51 [+1100]:

>On Wed, Dec 24, 2008 at 09:43:41AM +0800, Huang Ying wrote:
>>
>> I think that is not easy. Not all architecture follow the same directory
>> structure arch/<x>/crypto. And arch/x86/crypto is used by user mode
>> linux too.
>
>Right, relying on link order is hazardous.
You don't have to trick with Makefiles. You could use subsys_initcall()
in cryptomgr & algapi and for instance rootfs_initcall() for the generic
aes to ensure that it comes before the asm version but after the
subsystem. _Or_ you could use late_initcall() in the asm version. After
a second look I thing the late initcall variant looks better.

>However, since the table isn't that large we might as well compute
>it once and for all, like this:
>
>crypto: aes - Precompute tables
That patch is "big" but should not break anything. I still prefer to fix
it the other way via the init call order: it is smaller patch and would
be a nice example for further modules which might rely on each other
like aes does.

No matter what you pick as your final solution, should I send a
's/module_init/subsys_initcall/' patch for cryptomgr & algapi?

Sebastian
