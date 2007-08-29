From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 1/1] spufs: SPU-AES support (kspu+ablkcipher user)
Date: Wed, 29 Aug 2007 15:15:07 +0800
Message-ID: <20070829071507.GA5108@gondor.apana.org.au>
References: <20070816200105.735608000@ml.breakpoint.cc> <20070816200137.867399000@ml.breakpoint.cc> <20070828154637.GA21007@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, arnd@arndb.de, jk@ozlabs.org,
	cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4975 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712AbXH2HPT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 03:15:19 -0400
Content-Disposition: inline
In-Reply-To: <20070828154637.GA21007@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 28, 2007 at 05:46:37PM +0200, Sebastian Siewior wrote:
>
> Herbert, could you please ACK / NACK your bits?
> I added ablkcipher_request() in the driver with a proper type as you
> suggested.

The crypto bits look alright.

Do you plan to use this for anything beyond AES? If so it
would be good to come up a way to share some of the crypto
code between the main kernel and what runs on the SPUs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
