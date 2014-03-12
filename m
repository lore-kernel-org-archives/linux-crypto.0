From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC PATCH 00/22] staging: add skein/threefish crypto algos
Date: Wed, 12 Mar 2014 12:55:01 -0400
Message-ID: <20140312165501.GC7811@titan.lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41392 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbaCLQzJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 12:55:09 -0400
Content-Disposition: inline
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 11, 2014 at 09:32:32PM +0000, Jason Cooper wrote:
> To facilitate tinkering with this, One can pull from the following:
> 
>   git://git.infradead.org/users/jcooper/linux.git tags/staging-skein-3.14-rc1
> 
> This is based on v3.14-rc1, and is prone to rebasing based on comments.

Hmmm, apparently, I forgot to tell you *how* to tinker with this :)

Once you've pulled in the series,

$ make ARCH=x86_64 defconfig

enable CRYPTO_SKEIN (implies CRYPTO_THREEFISH) under drivers/staging.

$ git rebase -i v3.14-rc1

In the rebase config file:

#######################################
pick cc77327 scripts: objdiff: detect object code changes between two commits
pick bdb4dad staging: crypto: skein: import code from Skein3Fish.git
pick e3d822c staging: crypto: skein: allow building statically
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o

pick 227c819 staging: crypto: skein: remove brg_*.h includes
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o
x ./scripts/objdiff diff HEAD^ HEAD

pick c175303 staging: crypto: skein: remove skein_port.h
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o
x ./scripts/objdiff diff HEAD^ HEAD

pick a612f45 staging: crypto: skein: remove __cplusplus and an unneeded stddef.h
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o
x ./scripts/objdiff diff HEAD^ HEAD

... lather, rinse, repeat ...

pick 4438372 staging: crypto: skein: remove unnecessary line continuation
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o
x ./scripts/objdiff diff HEAD^ HEAD

pick 641f05d staging: crypto: skein: add TODO file
x kbuild.sh none
x ./scripts/objdiff record drivers/staging/skein/*.o
x ./scripts/objdiff diff HEAD^ HEAD

...
#######################################

Save, quit, let it run (kbuild.sh is my local script for building the
kernel)

If it makes it to the end, then the object code never changed.  Well, it
works here. ;-)

Once you're finished poking around (objdump output in is
/tmp/objdiff-<commit>/):

$ ./scripts/objdiff clean all

Also, it looks like linux-crypto dropped several of the patches for
being too large.  Here's a link to the top of the series (choose the
linuxdriverproject archive):

https://lkml.kernel.org/r/cover.1394570067.git.jason@lakedaemon.net

hth,

Jason.
