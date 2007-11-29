From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] tcrypt.c: Support for more test vectors
Date: Fri, 30 Nov 2007 00:30:33 +1100
Message-ID: <20071129133033.GF8487@gondor.apana.org.au>
References: <fd3e431c0711271519j14fcd71aqc399c1dc524df274@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3748 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754684AbXK2Naf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Nov 2007 08:30:35 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711271519j14fcd71aqc399c1dc524df274@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 28, 2007 at 07:19:17AM +0800, Tan Swee Heng wrote:
> Currently the number of entries in a cipher test vector template is
> limited by TVMEMSIZE/sizeof(struct cipher_testvec). This patch
> circumvents the problem by pointing cipher_tv to each entry in the
> template, rather than the template itself.
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
