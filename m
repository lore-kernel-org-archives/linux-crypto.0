Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE8EC10F11
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 01:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF6892075B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 01:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbfDKBh5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 21:37:57 -0400
Received: from shelob.surriel.com ([96.67.55.147]:56308 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfDKBh5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 21:37:57 -0400
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <riel@shelob.surriel.com>)
        id 1hEOes-0004xg-7E; Wed, 10 Apr 2019 21:37:42 -0400
Message-ID: <e3efd9c01626aa3bed02f10f845533711864bb17.camel@surriel.com>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
From:   Rik van Riel <riel@surriel.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>
Date:   Wed, 10 Apr 2019 21:37:41 -0400
In-Reply-To: <20190410231156.GB120258@gmail.com>
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
         <20190319170911.GB202956@gmail.com> <20190320185719.GB180195@gmail.com>
         <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
         <20190321175122.GA1587@sol.localdomain>
         <20190410031734.GB7140@sol.localdomain>
         <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
         <20190410190729.GA120258@gmail.com>
         <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
         <20190410231156.GB120258@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-I0iYs52hNxEw6RSke2FZ"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-I0iYs52hNxEw6RSke2FZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-04-10 at 16:11 -0700, Eric Biggers wrote:

> You've explained *what* it does again, but not *why*.  *Why* do you
> want
> hardened usercopy to detect copies across page boundaries, when there
> is no
> actual buffer overflow?

When some subsystem in the kernel allocates multiple
pages without _GFP_COMP, there is no way afterwards
to detect exactly how many pages it allocated.

In other words, there is no way to see how large the
buffer is, nor whether the copy operation in question
would overflow it.

--=20
All Rights Reversed.

--=-I0iYs52hNxEw6RSke2FZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlyummUACgkQznnekoTE
3oN5Ogf+JB1+Q62gA3I1CjbG9J1N9Yo0SopCRnifEmRD5OOuHcTnKtJk9cDddftF
JckxLVhf0YXgLZa78GQhNW74dTw/XBgB1tE59q7eYI3srERNjFc8G9cjLMEu0aKS
wpv4wOL0AB7k1eFPvXkDbQ7mnzxb7s8+wGoH4F6Shs4ls9At//2kofAvES14Cfn8
c8lCTakBYcQ4lEhr7dxQ3v//NoD6/ZC6tacDN5A6mgcwM/VkdNgNskDVX25sTn1P
Kvnes/43AAefodugVLVuXCtXhnBM1aJ1zn+J7VgyC5ZJAktdPSNixT6J7xlC16rZ
U5Uf2fWdPx6UWgcs8agsp1NCrvu31w==
=ewwZ
-----END PGP SIGNATURE-----

--=-I0iYs52hNxEw6RSke2FZ--

