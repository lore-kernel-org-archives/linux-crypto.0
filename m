From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Max data limit for AEAD operation
Date: Fri, 22 Jul 2016 12:40:19 +0800
Message-ID: <20160722044019.GA17416@gondor.apana.org.au>
References: <CAFXBA==j+6fGuWrjNroGWnnBc13ev+6EB2Ae7SnwAVVxjTWBrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59668 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcGVEkX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jul 2016 00:40:23 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA==j+6fGuWrjNroGWnnBc13ev+6EB2Ae7SnwAVVxjTWBrw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Harsh Jain <harshjain.prof@gmail.com> wrote:
> 
> There is maximum limit of data which crypto user can send(in encrypt)
> to get TAG in AEAD operations. We do not have update/final like
> implementation for AEAD algo's. why is this so?

Because our users haven't needed it so far.  Also algorithms like CCM
cannot support such an operation.

If you have a valid use case for it then I'll consider it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
