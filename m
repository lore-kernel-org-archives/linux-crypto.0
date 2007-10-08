From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Tue, 9 Oct 2007 00:07:23 +0800
Message-ID: <20071008160723.GA32301@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071006215857.GB3645@Chamillionaire.breakpoint.cc> <20071008031510.GA32087@gondor.apana.org.au> <20071008154939.GE31712@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4519 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084AbXJHQHZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 12:07:25 -0400
Content-Disposition: inline
In-Reply-To: <20071008154939.GE31712@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 08, 2007 at 05:49:39PM +0200, Sebastian Siewior wrote:
> 
> After thinking I realized that he does not need to provide an alias
> because his driver should be auto loaded due to the PCI-IDs right?

Good point.

> But while you mention it: Should the alias cbc(aes), etc. also be
> provided by the s390 and padlock driver which don't have PCI-IDs?
> Currently they have the aes alias (what they also provide) so it might
> be enough.

Because they do actually provide the aes algorithm it should
be sufficient.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
