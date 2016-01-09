From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Sat, 9 Jan 2016 11:14:52 +0100
Message-ID: <5690DD9C.4010408@gmail.com>
References: <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de> <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au> <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au> <568A66B2.4090307@gmail.com>
 <20160108124851.GA5425@gondor.apana.org.au> <568FFE18.6090900@gmail.com>
 <20160109054103.GA11188@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35620 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbcAIKO4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jan 2016 05:14:56 -0500
In-Reply-To: <20160109054103.GA11188@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/09/2016 06:41 AM, Herbert Xu wrote:
> On Fri, Jan 08, 2016 at 07:21:12PM +0100, Milan Broz wrote:
>>
>>> Yes algif_hash would need the same compatibility patch and I'm
>>> working on that.
>>
>> Ok, I fixed this already.
> 
> Can you please test the two patches that I sent for algif_hash?

I have stack of 7 patches on top of Linus' 4.4.0-rc8 tree, just to be sure
that I am testing the right versions, I created a git branch with
imported series here:
  http://git.kernel.org/cgit/linux/kernel/git/mbroz/linux.git/log/?h=crypto-api-compat

With these patches it works (except that cipher_null setkey issue).
I'll reply with tested-by to the patch thread.

> 
>> So it is used in production but just for this specific case.
> 
> OK I will add something similar to the algif_hash has_setkey
> logic for cipher_null.

Thanks!

Milan
