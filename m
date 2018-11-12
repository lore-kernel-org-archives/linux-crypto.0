Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:55912 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbeKLTIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 14:08:07 -0500
Date: Mon, 12 Nov 2018 17:15:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Something wrong with cryptodev-2.6 tree?
Message-ID: <20181112091545.rndetypqxlljjpde@gondor.apana.org.au>
References: <CAOtvUMfboXWwX2cXQxO-Z-fR8sBQDSnNM1hSEsccChqtZ5wH4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMfboXWwX2cXQxO-Z-fR8sBQDSnNM1hSEsccChqtZ5wH4Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 12, 2018 at 09:44:41AM +0200, Gilad Ben-Yossef wrote:
> Hi,
> 
> It seems that the cryptodev-2.6 tree at
> https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> has somehow rolled back 3 months ago.
> 
> Not sure if it's a git.kernel.org issue or something else but probably
> worth taking a look?

Thanks Gilad.  It should be fixed now.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
