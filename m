From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hanging modprobe aes_s390
Date: Wed, 25 Feb 2009 11:51:37 +0800
Message-ID: <20090225035137.GA31538@gondor.apana.org.au>
References: <1235501524.17311.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57295 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821AbZBYDvm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 22:51:42 -0500
Content-Disposition: inline
In-Reply-To: <1235501524.17311.24.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jan Glauber <jang@linux.vnet.ibm.com> wrote:
>
> That only happens if the aes_generic module isn't loaded. If
> aes_generic is already present the aes_s390 loads without problems.
> 
> Any idea how to solve this? Is something missing in the fallback code
> that uses aes_generic?

Yeah it looks like it's waiting for the fallback to come up.
However, the interesting bit is in the other processes, i.e., the
one that's actually testing aes_s390 or constructing the aes-generic.

Could you get those back traces please?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
