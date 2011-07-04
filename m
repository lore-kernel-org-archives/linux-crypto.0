From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390: support hardware accelerated SHA-224
Date: Mon, 4 Jul 2011 21:52:01 +0800
Message-ID: <20110704135201.GA25829@gondor.apana.org.au>
References: <1309350196.20428.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52492 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab1GDNwI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2011 09:52:08 -0400
Content-Disposition: inline
In-Reply-To: <1309350196.20428.10.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2011 at 02:23:16PM +0200, Jan Glauber wrote:
> On recent s390 machines hardware acceleration is available for SHA-256.
> SHA-224 is based on SHA-256 so it can also be accelerated by hardware.
> Do this by adding the proper algorithm description and initialization.
> 
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

Patch applied.  Thanks Jan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
