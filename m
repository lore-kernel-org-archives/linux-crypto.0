From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: unable to finish booting when "crypto: crct10dif - Wrap
 crc_t10dif function all to use crypto transform framework" applied
Date: Tue, 09 Jul 2013 09:00:11 -0700
Message-ID: <1373385611.22432.230.camel@schen9-DESK>
References: <51D8420C.7010602@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36965 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3GIQAM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jul 2013 12:00:12 -0400
In-Reply-To: <51D8420C.7010602@internode.on.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2013-07-07 at 01:43 +0930, Arthur Marsh wrote:
> Hi, when I have tried to boot recent kernels with the "crypto: crct10dif 
> - Wrap crc_t10dif function all to use crypto transform framework" patch 
> applied, I get a time-out waiting for the UUID of the root disk to appear.
> 
> git-bisect revealed this as the patch that started the problems:
> 
> am64:/usr/src/linux# git bisect good
> 2d31e518a42828df7877bca23a958627d60408bc is the first bad commit
> commit 2d31e518a42828df7877bca23a958627d60408bc
> Author: Tim Chen <tim.c.chen@linux.intel.com>
> Date:   Wed May 1 12:52:48 2013 -0700
> 
>      crypto: crct10dif - Wrap crc_t10dif function all to use crypto 
> transform framework
> 
>      When CRC T10 DIF is calculated using the crypto transform framework, we
>      wrap the crc_t10dif function call to utilize it.  This allows us to
>      take advantage of any accelerated CRC T10 DIF transform that is
>      plugged into the crypto framework.
> 
>      Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>      Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> :040000 040000 f7691bd794b6c2060bca786cf8c2971d57c7cd21 
> aff2510c6400c736b89c40fbafab77c5b577ae0d M      crypto
> :040000 040000 220b9199c2418dfd2d534298e7374f404f1ab233 
> d3f635c9c0d504e16f3915b82f80691bd48b12b4 M      include
> :040000 040000 dee4ecf93146d700eb95d5804bfd57b5cf0c395f 
> b66e0ffcef7ed9bda5e56f8629696344858db624 M      lib
> am64:/usr/src/linux#

Arthur,

Thanks for reporting the problem.

Can you provide info on to help me trace the issue:
1) What kind of cpu you're using? (can you send info in /proc/cpu)
2) Does your root disk use crct10dif integrity check?

Thanks.

Tim
