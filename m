Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDB4C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 13:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C48623A7B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 13:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgLRN20 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 08:28:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60676 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLRN2Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 08:28:25 -0500
Received: from mail-qk1-f197.google.com ([209.85.222.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1kqFlD-0000r7-AP
        for linux-crypto@vger.kernel.org; Fri, 18 Dec 2020 13:25:31 +0000
Received: by mail-qk1-f197.google.com with SMTP id n190so1991369qkf.18
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 05:25:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4nRj/x1/BBEIyRLVmwu1D5CTUo0WYepGewTBZBVPXO8=;
        b=doJnGPT5NvKMvRN6cEVlNEZaKiIFhzeNiSgEzcT3xjQI/duFUwG+BiJUXD4jnqNigT
         KTxCG6+XYTEUp1Mvc+Ru/UD8TVyNFwZburxB7xyK0thbIDTHnM5er5Hb8q7TcUnx+6WI
         OM254vmrdj5UGTEpsP2TOYK3BRLM9iA8T/oXTp2MLleOzpoIsSzZnoVoJOGgcxnWkd9Y
         WpWmIbWDeD3uHxWtwwO12jwhm6KA9+ZspKE6lIJrH7Ek59vgwi3YlpJVTubs2Hgg3FBd
         cGzDyNcB2hkOPx7YVqUUcR5vzu+lLE1+RguhRTD31XAqMvF9aC1YAvJETwkdTWpENlep
         w0sA==
X-Gm-Message-State: AOAM532lJyzIa4Z60wQ3/DDV1+lPXhRlxioMujL8HpBpUePeaksMOhxN
        zBQq9hWFOuths3mhmqbejjhKXfhsKsy7BqoptenG9tFZW7wchnYU+vddLrBhBjsYIXIMqoQS3qG
        UPX9/dM9jbds85OWlRGX2i0vv8BpFyiinCPD9T8BT
X-Received: by 2002:a05:620a:2009:: with SMTP id c9mr4723844qka.159.1608297929798;
        Fri, 18 Dec 2020 05:25:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6lw4/LRHks8iglc7NxhPSCLt1LqaykwKOWiWR0B3rqdocAMUE42hTAfUGIAlEYZLFuxQ3uA==
X-Received: by 2002:a05:620a:2009:: with SMTP id c9mr4723816qka.159.1608297929436;
        Fri, 18 Dec 2020 05:25:29 -0800 (PST)
Received: from valinor.lan ([177.62.158.31])
        by smtp.gmail.com with ESMTPSA id p23sm5131963qtu.53.2020.12.18.05.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:25:28 -0800 (PST)
Date:   Fri, 18 Dec 2020 10:25:19 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, duwe@lst.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Subject: Re: drivers/char/random.c needs a (new) maintainer
Message-ID: <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
References: <20201130151231.GA24862@lst.de>
 <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu>
 <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="votwx67fimlhwi32"
Content-Disposition: inline
In-Reply-To: <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--votwx67fimlhwi32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi, Ted and Jason.

Any updates on that?

I don't believe Torsten's concerns are simply about *applying* patches
but more about these long periods of radio silence. That kills
collaboration and disengage people. More than simply reviewing patches
I would expect a maintainer to give directions and drive the
community. Asking Jason to review Nicolai's patches was a step towards
that, but I believe we still could benefit from better communication.

Besides Nicolai's RFC, are you also planning to take another look at
Stephan's patches?

Thank you for your attention.

On Tue, Dec 01, 2020 at 12:42:36PM +0100, Jason A. Donenfeld wrote:
> On Mon, Nov 30, 2020 at 5:56 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> > patches this cycle.  One thing that would help me is if folks
> > (especially Jason, if you would) could start with a detailed review of
> > Nicolai's patches.
>=20
> Sure, I'll take a look.

--=20
Regards,
Marcelo


--votwx67fimlhwi32
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl/crb4ACgkQ6e82Loes
sAm4ZwwAiOHacvNtaLoejMX0U5yxa0JQjDppmTlGdOOXpeWkziCGIUcdE8u2UgJB
oPoUVxeKzw04FIrdk9p+ntYwc0SDqpTQaVC7DR6k6lnkwKPFQJOF1cl5Y+JFVSOh
9iu5IyDqeN4Q7q1ZGLuhP8JgyZoJc8KnnVsC3sOahISvQsloUK0BLQXcKY3Shei3
AzNx9gAVZ6H9qcSOy1nODeekFgRu0pP8L0+nHoDjzLJJ9RX4/SZOrxLeCocImXnx
n7W/a0rvzsfJd3BB+xAwDfAEZAbcqVhK9MSHML+6BuBujrRaLjZxm6FKfNRoUkG5
/XnC3YlmbNb+DF4v93DW6CGJtwusVWzRZJ4U1VtYmeSYUx6I+QZ8M1J9laur0jpd
7Z5HnHWgGSJY9FxzSrYQIYC86ZOeIbMEDeEiL7KSQuTFRumodrsiGaKlpzxuKn+4
qCesN5a/8lhSZyYhnJMASvIzzBOo7M8eEkuSMicHmILlzjyFB07XjqR6gBRnLK0a
ZDsW3XQG
=jOSR
-----END PGP SIGNATURE-----

--votwx67fimlhwi32--
