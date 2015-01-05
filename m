From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 05 Jan 2015 12:00:36 +0100
Message-ID: <1533111.7lv9uhtZ5L@tachyon.chronox.de>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de> <1656062.b6mnFyMzhb@tachyon.chronox.de> <20150105105540.GA25665@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59376 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbbAELAm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 06:00:42 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SE1D7> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 5 Jan 2015 12:00:39 +0100
In-Reply-To: <20150105105540.GA25665@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 5. Januar 2015, 21:55:40 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jan 05, 2015 at 11:53:38AM +0100, Stephan Mueller wrote:
> > Could you please check: I am unable to find the function.
> 
> It's in crypto/authenc.c.
> 
> > Note, there is no size parameter provided in crypto_aead_decrypt. To
> > obtain
> > the size, I would need to walk the scatterlists, no?
> 
> The cryptlen is supposed to contain the entire input apart from the
> AD, including the authentication tag if one is present.

Thanks a lot for the pointer, I overlooked the cryptlen member variable. I 
will update the patch to replace the scatterlist walk with such small check.

-- 
Ciao
Stephan
