Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A966C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 07:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiGOHjz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 03:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGOHjz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 03:39:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48E36753BD
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jul 2022 00:39:53 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-230-Zdk9jsXtNyOoeT-KRok3lQ-1; Fri, 15 Jul 2022 08:39:50 +0100
X-MC-Unique: Zdk9jsXtNyOoeT-KRok3lQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 15 Jul 2022 08:39:48 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 15 Jul 2022 08:39:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Biggers' <ebiggers@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: lib/arc4 - expose library interface
Thread-Topic: [PATCH] crypto: lib/arc4 - expose library interface
Thread-Index: AQHYl+8/6/YJ+ntYHUS15FnqMmtHD61/CrlQ
Date:   Fri, 15 Jul 2022 07:39:48 +0000
Message-ID: <872b3792d96946b48236120a057b99bc@AcuMS.aculab.com>
References: <20220714051221.22525-1-ansuelsmth@gmail.com>
 <YtDLMmwffn6p/rSV@sol.localdomain>
In-Reply-To: <YtDLMmwffn6p/rSV@sol.localdomain>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers
> Sent: 15 July 2022 03:05
> 
> On Thu, Jul 14, 2022 at 07:12:21AM +0200, Christian Marangi wrote:
> > Permit to compile the arc4 crypto lib without any user. This is required
> > by the backports project [1] that require this lib for any wireless
> > driver.
> >
> > [1] https://backports.wiki.kernel.org/index.php/Main_Page
> >
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  lib/crypto/Kconfig | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> > index 2082af43d51f..2dfc785a7817 100644
> > --- a/lib/crypto/Kconfig
> > +++ b/lib/crypto/Kconfig
> > @@ -6,7 +6,11 @@ config CRYPTO_LIB_AES
> >  	tristate
> >
> >  config CRYPTO_LIB_ARC4
> > -	tristate
> > +	tristate "ARC4 library interface"
> > +	help
> > +	  Enable the ARC4 library interface. This interface is mainly
> > +	  used by wireless drivers and is required by the backports
> > +	  project.
> >
> >  config CRYPTO_ARCH_HAVE_LIB_BLAKE2S
> >  	bool
> 
> I don't think this is appropriate for upstream, as the upstream kernel doesn't
> support out-of-tree code.  This is also an internal API that can change from one
> kernel version to the next.

Out-of-tree code always has to allow for arbitrary changes to
kernel interfaces between kernel versions.
So the fact that the API might change isn't relevant.
The continual API changes keep some of us in a job :-)

(It has to be said that if I needed RC4 I'd probably add a local copy.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

