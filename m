From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ixp4xx_crypto: avoid firmware loading during module initialisation
Date: Tue, 19 Aug 2008 14:55:10 +1000
Message-ID: <E1KVJFO-0007Vh-00@gondolin.me.apana.org.au>
References: <20080818064455.GK22567@mail3.prorata.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: christian@hohnstaedt.de (Christian Hohnstaedt)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44128 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752086AbYHSEzO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Aug 2008 00:55:14 -0400
In-Reply-To: <20080818064455.GK22567@mail3.prorata.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt <christian@hohnstaedt.de> wrote:
> By moving the firmware-loading to the transform initialisation,
> the driver may be compiled in.
> 
> Notify the user if the firmware does not support AES, or even
> no crypto at all.

What happens when two tfms are constructed at the same time?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
