From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 9/28] crypto/drbg.c:526 drbg_ctr_df() error:
 we previously assumed 'tempstr' could be null (see line 523)
Date: Wed, 25 Jun 2014 17:07:33 +0800
Message-ID: <20140625090733.GC8727@gondor.apana.org.au>
References: <20140620202418.GZ5015@mwanda>
 <1455308.iM4tBB0QjZ@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34066 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaFYJHl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 05:07:41 -0400
Content-Disposition: inline
In-Reply-To: <1455308.iM4tBB0QjZ@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 21, 2014 at 02:45:33PM +0200, Stephan Mueller wrote:
> Am Freitag, 20. Juni 2014, 23:24:18 schrieb kbuild test robot:
> 
> Hi,
> 
> first of all, thanks for the information. As you have seen, I created a patch 
> covering your comments on the NULL pointer handling.
> > 
> > The kernel also provides standard linked list features and you should
> > consider using those instead of rolling your own.
> 
> There is a reason for this approach: the very same code (with exception of the 
> interface code part) is also available for libgcrypt -- see [1] and gcrypt-
> devel. I did not want to have different code, because any bug fix relevant to 
> the one implementation is also important to the other. Thus, I feel that it is 
> beneficial to use the linked list feature as implemented in the current DRBG.
> 
> [1] http://www.chronox.de/drbg.html

This is unacceptable.  We are not going to add crap to the kernel
just because the same crap exists elsewhere.

Please fix this or I will be reverting your patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
