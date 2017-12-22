From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - limit mask and type
Date: Fri, 22 Dec 2017 08:41:10 +0100
Message-ID: <1779114.sJA4SrkMo1@tauon.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com> <3658547.Hu7AXH7hma@positron.chronox.de> <20171222073606.GC27149@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ebiggers3@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44304 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdLVHlM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 02:41:12 -0500
In-Reply-To: <20171222073606.GC27149@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 22. Dezember 2017, 08:36:07 CET schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 19, 2017 at 07:25:04AM +0100, Stephan Müller wrote:
> > The user space interface allows specifying the type and the mask field
> > used to allocate the cipher. As user space can precisely select the
> > desired cipher by using either the name or the driver name, additional
> > selection options for cipher are not considered necessary and relevant
> > for user space.
> > 
> > This fixes a bug where user space is able to cause one cipher to be
> > registered multiple times potentially exhausting kernel memory.
> > 
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> This will break users of CRYPTO_ALG_KERN_DRIVER_ONLY.  I think
> we should add CRYPTO_ALG_TESTED to the blacklist since there is
> no sane reason to use it here.

Shouldn't we then rather use a white list instead of a black list?
> 
> Most other problems however would be bugs in the template code.
> The first thing a template does when it creates an instance is
> to check whether the resulting algorithm would fulfil the requested
> type/mask using crypto_check_attr_type.  So if that's not working
> then we should fix it there as it may also be triggered via other
> code paths that can create instances.

I think I understand that, but does user space need to utilize this logic?
> 
> Thanks,



Ciao
Stephan
