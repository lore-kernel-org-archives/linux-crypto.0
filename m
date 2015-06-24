From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto-jitterentropy: Delete unnecessary checks before the function call "kzfree"
Date: Wed, 24 Jun 2015 09:54:26 +0200
Message-ID: <20504077.rM6dY01J5R@tauon.atsec.com>
References: <5307CAA2.8060406@users.sourceforge.net> <3056833.hq1kqBmzGz@myon.chronox.de> <20150624074819.GR28762@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150624074819.GR28762@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 24. Juni 2015, 10:48:19 schrieb Dan Carpenter:

Hi Dan,

>The other NULL assignment isn't useful either.  Also If
>"entropy_collector" is NULL then we would oops calling
>kzfree(entropy_collector->mem);
>       ^^^^^^^^^^^^^^^^^^^^^^
>Dereference.
>
>I don't understand the patch that you sent.  We shouldn't be introducing
>jent_zalloc() or jent_zfree().  Why are you adding abstractions there?

The one C file should have no dependencies on any kernel header files. Thus, 
all links to kernel functions are wrapped.

>Quite bad ones as well.

What would you suggest to change?

Thanks.

Ciao
Stephan
