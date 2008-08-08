From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Fri, 08 Aug 2008 21:35:30 +0800
Message-ID: <E1KRS7u-0005EP-00@gondolin.me.apana.org.au>
References: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com>
Cc: austin_zhang@linux.intel.com, herbert@gondor.apana.org.au,
	bunk@kernel.org, dwmw2@infradead.org, davem@davemloft.net,
	randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: drepper@gmail.com (Ulrich Drepper)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59926 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752352AbYHHNfw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Aug 2008 09:35:52 -0400
In-Reply-To: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ulrich Drepper <drepper@gmail.com> wrote:
>
> I think you want to use
> 
>  #define SCALE_F sizeof(unsigned long)

Yeah in general that's what we should do.  However, this driver
is specific to Intel x86 CPUs.

However if someone were to post a patch to do this I would happily
apply it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
