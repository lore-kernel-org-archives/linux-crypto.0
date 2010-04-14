From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 2/2] crypto: omap-sham - omap sha1 & md5 driver
Date: Wed, 14 Apr 2010 14:20:52 +0800
Message-ID: <20100414062052.GA20395@gondor.apana.org.au>
References: <a5a7f43a44753854ac0e9bc7dceb95bde31c2bb0.1271145726.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tony@atomide.com, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:38419 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469Ab0DNGU6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Apr 2010 02:20:58 -0400
Content-Disposition: inline
In-Reply-To: <a5a7f43a44753854ac0e9bc7dceb95bde31c2bb0.1271145726.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
> was not ported to new crypto APIs and removed from the source tree.
> 
> - implements async and sync crypto API using dma and cpu.
> - supports multiple sham instances if available
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

You have not addressed my objections raised earlier.

Also, why are you exporting a shash object? You cannot sleep during
shash operations (except for setkey).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
