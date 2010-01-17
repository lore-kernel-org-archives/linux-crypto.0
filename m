From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: vmac test fails on s390
Date: Sun, 17 Jan 2010 22:05:46 +1100
Message-ID: <20100117110546.GA32690@gondor.apana.org.au>
References: <1263477930.5880.22.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>,
	Shane Wang <shane.wang@intel.com>,
	Joseph Cihula <joseph.cihula@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36537 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751589Ab0AQLFy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 06:05:54 -0500
Content-Disposition: inline
In-Reply-To: <1263477930.5880.22.camel@bender>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 14, 2010 at 02:05:30PM +0000, Jan Glauber wrote:
> Hi,
> 
> Jan 14 14:47:38 h42lp52 kernel: alg: hash: Test 1 failed for vmac(aes-s390)
> Jan 14 14:47:38 h42lp52 kernel: 00000000: e7 79 33 b7 fd 8a d7 cb
> 
> Looking at the digest from the failing test vector:
> 
> .digest = "\xcb\xd7\x8a\xfd\xb7\x33\x79\xe7",
> 
> the output looks somehow familiar... Maybe a missing endian conversion?
> The patch fixes the test for me but it is just a wild guess and maybe
> it should be done at another place?

Shane, please look into this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
