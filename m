Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE51C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 04:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B860F208CB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 04:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ZahgWAax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfE1E6N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 00:58:13 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:27711 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfE1E6N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 00:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1559019489;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ATZN/qb53ILeRnmNIzRjCTveWwU5gx2KnqlEdNal0Cc=;
        b=ZahgWAaxGaPjrBufkEKCYYfN9W2RAVPO0cyY0peBcZc7EJVLHrZNHyBax+Y18+4lv+
        IeUsIoDttYZAu4D5R2KkPueZ4xy0+E9xCrucEmFYXqxFPdL8XJFJJ2gPZdcEPGgcmi4w
        xjzL0I+3RIK0wp+XqzCMOjM/Bv4KnsJ1fduK5XK+uYkYoIYJtl9kCxRzovYN8zVZ/KDT
        qyu2X56nXkSG5heGoscFTb/3UQgDmZ6/MxEx9HfHtaK3zU9XllH7rAIeCtHuS629KgHY
        V+WqM91TDHIIYR+w7laQnEnQx/1VYlhibQ79gNDGg4JkC0866Oqg8+41hnUxoDfor6uw
        hJUw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvSfTerW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv4S4w1kss
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 28 May 2019 06:58:01 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, terrelln@fb.com,
        jthumshirn@suse.de
Subject: Re: [PATCH] crypto: xxhash - Implement xxhash support
Date:   Tue, 28 May 2019 06:58:00 +0200
Message-ID: <1778879.ZR4uXBBfnJ@tauon.chronox.de>
In-Reply-To: <20190527191550.GC9394@sol.localdomain>
References: <20190527142810.31472-1-nborisov@suse.com> <1582734.iyJbpUVI2p@tauon.chronox.de> <20190527191550.GC9394@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 27. Mai 2019, 21:15:51 CEST schrieb Eric Biggers:

Hi Eric,

> On Mon, May 27, 2019 at 05:06:53PM +0200, Stephan Mueller wrote:
> > >  obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
> > >  CFLAGS_jitterentropy.o = -O0
> > >  jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
> > > 
> > > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > > index 8386038d67c7..322e906b6b6a 100644
> > > --- a/crypto/testmgr.c
> > > +++ b/crypto/testmgr.c
> > > @@ -3879,6 +3879,13 @@ static const struct alg_test_desc
> > > alg_test_descs[] =
> > > { .alg = "xts512(paes)",
> > > 
> > >  		.test = alg_test_null,
> > >  		.fips_allowed = 1,
> > > 
> > > +	}, {
> > > +		.alg = "xxhash64",
> > > +		.test = alg_test_hash,
> > > +		.fips_allowed = 1,
> > 
> > Why is this intended to be allowed in FIPS mode? This does not seem to be
> > a
> > FIPS approved cipher.
> 
> The other non-cryptographic algorithms like crc32, crc32c, crct10dif, zstd,
> zlib-deflate, lzo, lzohc have the fips_allowed flag set too, the argument
> being the FIPS restrictions don't apply to non-cryptographic algorithms. 
> I'm not very familiar with FIPS, but I'd assume the same would be true for
> xxhash.

FIPS relates to cryptographic mechanisms protecting user data. The mechanisms 
you refer to are non-cryptographic and thus do not fall under 
FIPS-"jurisdiction".

Please correct me if I am wrong, but as far as I see, however, xxhash seems to 
be a cryptographic hash function.

Ciao
Stephan


