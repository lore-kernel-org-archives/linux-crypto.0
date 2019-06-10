Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB726C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 16:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9E420859
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560184341;
	bh=UkqZ0Jl3vryYDHYYRNtJ4WUs4XPXH9S11Cgidt4ttX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rjPaO/lQXSTFPMOlDwQDBRYtGOnKs+VAWsvyTESlzUIUzEW1FlfnV9fDy0TxYOpni
	 +XknbNtqY1d5RHgVZM8iYh2dCyds/odn9aC2i3lxJrU2e6fLg8oUgbmZ9Zd7V27n3c
	 BSlSoro1ROcPjQJSDEa7TXlGFmvewC6bceYUBrbE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfFJQcU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfFJQcU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 12:32:20 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F5720859;
        Mon, 10 Jun 2019 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560184339;
        bh=UkqZ0Jl3vryYDHYYRNtJ4WUs4XPXH9S11Cgidt4ttX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KnkKNRtSVs1+gEvc92EQLAj++e6iiEhaXsPQWQ++Xb8R6QQFekG2/UyARHARS8UoZ
         LCzB6+2G1DwDnvoLFTF9ePRJi9UKjdxl5fbKijQ47xkDwitZmwdhKD0UxTNIQ9HrAa
         WWoieZS4voNUPioS0fmDTmHgajWbkp4Q32mmRTmU=
Date:   Mon, 10 Jun 2019 09:32:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/7] crypto: arc4 - refactor arc4 core code into
 separate library
Message-ID: <20190610163216.GC63833@gmail.com>
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
 <20190609115509.26260-2-ard.biesheuvel@linaro.org>
 <20190610160622.GA63833@gmail.com>
 <CAKv+Gu-az2BBVLpKqw=m_5ttXYRT95CE8toxt8-+W13A_jmuAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-az2BBVLpKqw=m_5ttXYRT95CE8toxt8-+W13A_jmuAg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 10, 2019 at 06:10:41PM +0200, Ard Biesheuvel wrote:
> On Mon, 10 Jun 2019 at 18:06, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Just some bike shedding:
> >
> > On Sun, Jun 09, 2019 at 01:55:03PM +0200, Ard Biesheuvel wrote:
> > > diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
> > > index 5b2c24ab0139..62ac95ec6860 100644
> > > --- a/include/crypto/arc4.h
> > > +++ b/include/crypto/arc4.h
> > > @@ -6,8 +6,21 @@
> > >  #ifndef _CRYPTO_ARC4_H
> > >  #define _CRYPTO_ARC4_H
> > >
> > > +#include <linux/types.h>
> > > +
> > >  #define ARC4_MIN_KEY_SIZE    1
> > >  #define ARC4_MAX_KEY_SIZE    256
> > >  #define ARC4_BLOCK_SIZE              1
> > >
> > > +struct crypto_arc4_ctx {
> > > +     u32 S[256];
> > > +     u32 x, y;
> > > +};
> > > +
> > > +int crypto_arc4_set_key(struct crypto_arc4_ctx *ctx, const u8 *in_key,
> > > +                     unsigned int key_len);
> > > +
> > > +void crypto_arc4_crypt(struct crypto_arc4_ctx *ctx, u8 *out, const u8 *in,
> > > +                    unsigned int len);
> >
> > How about naming these just arc4_* instead of crypto_arc4_*?  The crypto_*
> > prefix is already used mostly for crypto API helper functions, i.e. functions
> > that take take one of the abstract crypto API types like crypto_skcipher,
> > shash_desc, etc.  For lib functions, the bare name seems more appropriate.  See
> > e.g. sha256_update() vs. crypto_sha256_update().
> >
> 
> That is also fine, although I am slightly concerned that we may run
> into trouble with other algorithms in the future. But I do agree it
> makes sense to make a clear distinction with the full blown API.
> 
> > > +++ b/lib/crypto/Makefile
> > > @@ -0,0 +1,3 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +
> > > +obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
> > > diff --git a/lib/crypto/libarc4.c b/lib/crypto/libarc4.c
> > > new file mode 100644
> > > index 000000000000..b828af2cc03b
> > > --- /dev/null
> > > +++ b/lib/crypto/libarc4.c
> > > @@ -0,0 +1,74 @@
> >
> > How about arc4.c instead of libarc4.c?  The second "lib" is redundant, given
> > that the file is already in the lib/ directory.
> >
> 
> The problem here is that we'll end up with two modules named arc4.ko,
> one in crypto/ and one in lib/crypto/. Perhaps we should rename the
> other one? (especially once it implements ecb(arc4) only.)

Another option is to do:

obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
libarc4-y := arc4.o

Also, CONFIG_CRYPTO_LIB_ARC4 needs to actually be a tristate.
It seems you accidentally made it a bool:

> +config CRYPTO_LIB_ARC4
> +	bool
> +

- Eric
