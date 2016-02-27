From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Is a crypto_ahash_init required before invoking
 crypto_ahash_import?
Date: Sat, 27 Feb 2016 07:35:33 +0000
Message-ID: <20160227073533.GA3693@gondor.apana.org.au>
References: <56CF788F.5050209@amd.com>
 <20160225221134.GA27728@gondor.apana.org.au>
 <56CF7FAE.6060402@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55784 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbcB0Hf7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 02:35:59 -0500
Content-Disposition: inline
In-Reply-To: <56CF7FAE.6060402@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2016 at 04:26:54PM -0600, Tom Lendacky wrote:
>
> Thanks for the clarification Herbert.  I'll send in a patch to perform
> the memset during the import.  I know it's late in the cycle, but will
> you be able to apply it to the current cryptodev-2.6 tree which contains
> the ccp import/export patches?

Yes I will add it on top.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
