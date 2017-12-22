From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - limit mask and type
Date: Fri, 22 Dec 2017 18:36:07 +1100
Message-ID: <20171222073606.GC27149@gondor.apana.org.au>
References: <001a1141c43ad30ccf055efb76ed@google.com>
 <4450500.tGvsruIfR8@positron.chronox.de>
 <3658547.Hu7AXH7hma@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ebiggers3@gmail.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46008 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbdLVHgZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 02:36:25 -0500
Content-Disposition: inline
In-Reply-To: <3658547.Hu7AXH7hma@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 07:25:04AM +0100, Stephan Müller wrote:
> The user space interface allows specifying the type and the mask field
> used to allocate the cipher. As user space can precisely select the
> desired cipher by using either the name or the driver name, additional
> selection options for cipher are not considered necessary and relevant
> for user space.
> 
> This fixes a bug where user space is able to cause one cipher to be
> registered multiple times potentially exhausting kernel memory.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

This will break users of CRYPTO_ALG_KERN_DRIVER_ONLY.  I think
we should add CRYPTO_ALG_TESTED to the blacklist since there is
no sane reason to use it here.

Most other problems however would be bugs in the template code.
The first thing a template does when it creates an instance is
to check whether the resulting algorithm would fulfil the requested
type/mask using crypto_check_attr_type.  So if that's not working
then we should fix it there as it may also be triggered via other
code paths that can create instances.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
