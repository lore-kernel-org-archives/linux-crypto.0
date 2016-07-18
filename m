From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] crypto: img-hash - Add support for export and import
Date: Mon, 18 Jul 2016 14:13:49 +0800
Message-ID: <20160718061349.GA12163@gondor.apana.org.au>
References: <20160712074929.GA29737@gondor.apana.org.au>
 <578649C2.801@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, james.hartley@imgtec.com
To: Will Thomas <will.thomas@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcGRGNy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 02:13:54 -0400
Content-Disposition: inline
In-Reply-To: <578649C2.801@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 13, 2016 at 03:01:38PM +0100, Will Thomas wrote:
> 
> I don't see any other drivers explicitly requesting a fallback
> driver by name. Anyways, should this be done using  "sha1-generic"

The problem is that you're relying on the fallback to implement
import/export.  So if the fallback changes, then your algorithm
parameters will change which is not allowed.

> in the crypto_alloc_ahash call when setting up the fallback tfm?

Yes that should be sufficient.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
