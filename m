From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hanging modprobe aes_s390
Date: Sat, 28 Feb 2009 22:29:53 +0800
Message-ID: <20090228142953.GA2091@gondor.apana.org.au>
References: <20090225035137.GA31538@gondor.apana.org.au> <1235583230.17311.57.camel@localhost.localdomain> <20090226060618.GA11303@gondor.apana.org.au> <20090228120636.GA26999@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41964 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752071AbZB1OaF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2009 09:30:05 -0500
Content-Disposition: inline
In-Reply-To: <20090228120636.GA26999@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 28, 2009 at 01:06:36PM +0100, Sebastian Andrzej Siewior wrote:
>
> Yup. I am not sure if we have a problem with the geode here. That one
> is loaded via PCI id probing. I'm going to check on that once I figured
> out where the devel board is.....

Well not everybody uses udev :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
