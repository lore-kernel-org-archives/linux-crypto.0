From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] CPU accelerated implementation for sha512/384 on s390
Date: Thu, 6 Mar 2008 19:56:12 +0800
Message-ID: <20080306115612.GA7373@gondor.apana.org.au>
References: <1204561180.6025.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33888 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756605AbYCFL4Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Mar 2008 06:56:16 -0500
Content-Disposition: inline
In-Reply-To: <1204561180.6025.50.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 03, 2008 at 05:19:40PM +0100, Jan Glauber wrote:
> Hi Herbert,
> 
> this patch series adds hardware acceleration to sha512 & sha384 for s390.
> Beside the hardware support I've added a generic implementation for the
> update and final functions.
> 
> Please add these patches to your crypto tree, so they can go into 2.6.26. 

Thanks Jan.  All applied to cryptodev-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
