From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 22 Jun 2007 15:34:48 +0800
Message-ID: <20070622073448.GB27341@gondor.apana.org.au>
References: <20070604134248.GA9645@2ka.mipt.ru> <20070605125604.GA16327@Chamillionaire.breakpoint.cc> <20070605130731.GA4643@2ka.mipt.ru> <20070605150245.GA29400@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2264 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbXFVHew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 03:34:52 -0400
Content-Disposition: inline
In-Reply-To: <20070605150245.GA29400@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 05, 2007 at 07:02:45PM +0400, Evgeniy Polyakov wrote:
> 
> Herbert, could you please elaborate how to provide a private pointer
> into cra_init without searching via static lists of all devices?

The crypto_alg object should contain a back pointer to the device.
In setkey, you have access to a tfm object which has a pointer to
the crypto_alg object.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
