From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/8] [CRYPTO] aead: Add authenc
Date: Thu, 30 Aug 2007 19:13:05 +0800
Message-ID: <20070830111305.GA17261@gondor.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au> <E1IQfas-0004C1-00@gondolin.me.apana.org.au> <B9FFC3F97441D04093A504CEA31B7C4101BB3D4D@msilexch01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Graf <tgraf@suug.ch>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ronen Shitrit <rshitrit@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3123 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755317AbXH3LNK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 07:13:10 -0400
Content-Disposition: inline
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C4101BB3D4D@msilexch01.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 30, 2007 at 02:00:43PM +0300, Ronen Shitrit wrote:
>
> Is this the combined mode that was discussed on the mailing list before?

Authenc is just the first user of the crypto_aead interface.
Once IPsec moves across we will add others such as the CCM
algorithm.

> Is there a plan to add support for HW engines that can run the
> encryption and authentication as one operation?

Yep this interface will support those hardware engines.

> BTW: will the kernel IPsec patch that uses this AEAD API will be
> submitted on this mailing list as well?

It'll be submitted on netdev@vger.kernel.org.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
