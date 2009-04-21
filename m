From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: VIA Padlock driver no longer loads automatically
Date: Tue, 21 Apr 2009 13:51:54 +0200
Message-ID: <20090421115154.GA25685@Chamillionaire.breakpoint.cc>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com> <20090421055331.GA14062@gondor.apana.org.au> <20090421055613.GA14319@gondor.apana.org.au> <20090421082645.GA22102@Chamillionaire.breakpoint.cc> <20090421105327.GA17166@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45982 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbZDULwE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 07:52:04 -0400
Content-Disposition: inline
In-Reply-To: <20090421105327.GA17166@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-04-21 18:53:27 [+0800]:

>It was already renamed in the original patch.  The problem here
>is that padlock-aes was incorrectly renamed as it doesn't require
>a fallback.

Right, just key computation which is not part of the crypto API.

>Cheers,
>-- 

Sebastian
