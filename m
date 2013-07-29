From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Mon, 29 Jul 2013 13:39:06 -0700
Message-ID: <1375130346.22432.399.camel@schen9-DESK>
References: <51EF3BCC.30102@huawei.com>
	 <20130724070621.GA30415@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3G2UjE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jul 2013 16:39:04 -0400
In-Reply-To: <20130724070621.GA30415@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2013-07-24 at 17:06 +1000, Herbert Xu wrote:
> On Wed, Jul 24, 2013 at 10:28:28AM +0800, Zhao Hongjiang wrote:
> > When i boot my system with the latest 3.11-rc2 kernel, something occur as follow:
> > 
> > Waiting for device /dev/disk/by-id/... to appear: ............ Could not find //dev/disk/by-id/...
> > Want me to fall back to /dev/disk/by-id/..... ?
> > 
> > I found out the patch commit id: 2d31e518a42828df7877bca23a958627d60408bc (crypto: crct10dif - 
> > Wrap crc_t10dif function all to use crypto transform framework) cause this problem by bisect.
> > 
> > I revert this patch and this problem go away, the boot become successful.
> 
> OK, I will revert this until we have a proper solution in place
> that does not break boot on systems like yours.

> commit e70308ec0e4bff344fcfdf160de40e1150552c5f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Jul 24 17:04:16 2013 +1000
> 
>     Revert "crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework"
>     
>     This reverts commits
>         67822649d7305caf3dd50ed46c27b99c94eff996
>         39761214eefc6b070f29402aa1165f24d789b3f7
>         0b95a7f85718adcbba36407ef88bba0a7379ed03
>         31d939625a9a20b1badd2d4e6bf6fd39fa523405
>         2d31e518a42828df7877bca23a958627d60408bc
>     
>     Unfortunately this change broke boot on some systems that used an
>     initrd which does not include the newly created crct10dif modules.
>     As these modules are required by sd_mod under certain configurations
>     this is a serious problem.


Herbert, what are your thoughts on a proper fix to initrd issue for
crct10dif modules not getting included?  Or can we
let the config option for the pclmul version to be either compiled 
out or compiled in for now for people who do want to use this?

Thanks.

Tim
