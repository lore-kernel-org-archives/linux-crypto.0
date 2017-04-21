From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Fri, 21 Apr 2017 17:25:41 +0200
Message-ID: <8205294.2qxUD6mCvD@tauon.chronox.de>
References: <20170421121820.GA14381@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59128 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1041930AbdDUSdS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 14:33:18 -0400
In-Reply-To: <20170421121820.GA14381@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. April 2017, 14:18:20 CEST schrieb Herbert Xu:

Hi Herbert,

> Milan Broz <gmazyland@gmail.com> wrote:
> > The cipher_null is not a real cipher, FIPS mode should not restrict its
> > use.
> > 
> > It is used for several tests (for example in cryptsetup testsuite) and
> > also
> > temporarily for reencryption of not yet encrypted device in
> > cryptsetup-reencrypt tool.
> > 
> > Problem is easily reproducible with
> > 
> >  cryptsetup benchmark -c null
> > 
> > Signed-off-by: Milan Broz <gmazyland@gmail.com>
> 
> Stephan?

Acked-by: Stephan Müller <smueller@chronox.de>

Ciao
Stephan
