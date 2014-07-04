From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] DRBG: use of kernel linked list
Date: Fri, 4 Jul 2014 22:11:36 +0800
Message-ID: <20140704141135.GA27229@gondor.apana.org.au>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
 <40132217.1npinMrGoS@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60847 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaGDOMi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2014 10:12:38 -0400
Content-Disposition: inline
In-Reply-To: <40132217.1npinMrGoS@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 28, 2014 at 09:58:24PM +0200, Stephan Mueller wrote:
> The DRBG-style linked list to manage input data that is fed into the
> cipher invocations is replaced with the kernel linked list
> implementation.
> 
> The change is transparent to users of the interfaces offered by the
> DRBG. Therefore, no changes to the testmgr code is needed.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
