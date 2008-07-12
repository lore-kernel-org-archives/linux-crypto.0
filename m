From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] check for s390 crypto facility availablility
Date: Sat, 12 Jul 2008 15:42:59 +0800
Message-ID: <20080712074259.GA11866@gondor.apana.org.au>
References: <1215702043.12011.6.camel@localhost.localdomain> <20080711122938.GA4140@gondor.apana.org.au> <1215801280.9088.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51428 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751813AbYGLHnI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Jul 2008 03:43:08 -0400
Content-Disposition: inline
In-Reply-To: <1215801280.9088.12.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 11, 2008 at 06:34:40PM +0000, Jan Glauber wrote:
> [PATCH] respect STFL bit for s390 crypto
> 
> From: <jang@linux.vnet.ibm.com>
> 
> Bevore issuing any s390 crypto operation check whether the
> CPACF facility is enabled in the facility list. That way a
> virtualization layer can prevent usage of the CPACF facility
> regardless of the availability of the crypto instructions.
> 
> Signed-off-by: <jang@linux.vnet.ibm.com>

Applied to cryptodev-2.6.  Thank you!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
