From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Wed, 27 Jun 2007 14:24:20 +0400
Message-ID: <20070627102420.GA11016@2ka.mipt.ru>
References: <20070626225952.GA4571@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33207 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXF0KY4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2007 06:24:56 -0400
Content-Disposition: inline
In-Reply-To: <20070626225952.GA4571@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2007 at 12:59:52AM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> This driver adds support for AES on SPU. Patch is for review only because
> some parts of the code are not upstream yet.
> Patch one contains the main driver (which uses ablkcipher_ctx_cast()), 
> patch two is for clarity (parts of the missing API that is used).
> 
> Currently only ECB block mode is supported. I plan support for CBC but the
> way the IV currently handled is unfavorable (later more).

Interesting. Do you have any benchmark of the SPU handling AES crypto?

-- 
	Evgeniy Polyakov
