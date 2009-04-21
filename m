From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: VIA Padlock driver no longer loads automatically
Date: Tue, 21 Apr 2009 18:53:27 +0800
Message-ID: <20090421105327.GA17166@gondor.apana.org.au>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com> <20090421055331.GA14062@gondor.apana.org.au> <20090421055613.GA14319@gondor.apana.org.au> <20090421082645.GA22102@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37549 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbZDUKxf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 06:53:35 -0400
Content-Disposition: inline
In-Reply-To: <20090421082645.GA22102@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 21, 2009 at 10:26:45AM +0200, Sebastian Andrzej Siewior wrote:
>
> You changed all algos which need fallback to *-all to get them
> probed/loaded after the generic algorithm. The same load/fallback/test
> pattern exist for the s390 aes for instance. Should it be renamed as
> well?

It was already renamed in the original patch.  The problem here
is that padlock-aes was incorrectly renamed as it doesn't require
a fallback.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
