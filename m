From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] modsign: Fix GPL/OpenSSL licence incompatibility
Date: Sun, 4 Oct 2015 21:47:37 +0200
Message-ID: <20151004194737.GC27633@xo-6d-61-c0.localdomain>
References: <20150915150336.14206.34368.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: torvalds@linux-foundation.org, jmorris@namei.org,
	David Woodhouse <David.Woodhouse@intel.com>,
	Julian Andres Klode <jak@jak-linux.org>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58293 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbJDTsH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Oct 2015 15:48:07 -0400
Content-Disposition: inline
In-Reply-To: <20150915150336.14206.34368.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue 2015-09-15 16:03:36, David Howells wrote:
> From: David Woodhouse <dwmw2@infradead.org>
>=20
> The GPL does not permit us to link against the OpenSSL library. Use
> LGPL for sign-file and extract-file instead.

Actually GPL does permit you to link to "system libraries", and it look=
s like=20
OpenSSL is pretty much system library these days.

(But no problem with LGPL).


>=20
> Reported-by: Julian Andres Klode <jak@jak-linux.org>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Julian Andres Klode <jak@jak-linux.org>
> ---
>=20
>  scripts/extract-cert.c |   10 +++++-----
>  scripts/sign-file.c    |   13 ++++++++-----
>  2 files changed, 13 insertions(+), 10 deletions(-)
>=20
> diff --git a/scripts/extract-cert.c b/scripts/extract-cert.c
> index 10d23ca9f617..6ce5945a0b89 100644
> --- a/scripts/extract-cert.c
> +++ b/scripts/extract-cert.c
> @@ -1,15 +1,15 @@
>  /* Extract X.509 certificate in DER form from PKCS#11 or PEM.
>   *
> - * Copyright =A9 2014 Red Hat, Inc. All Rights Reserved.
> - * Copyright =A9 2015 Intel Corporation.
> + * Copyright =A9 2014-2015 Red Hat, Inc. All Rights Reserved.
> + * Copyright =A9 2015      Intel Corporation.
>   *
>   * Authors: David Howells <dhowells@redhat.com>
>   *          David Woodhouse <dwmw2@infradead.org>
>   *
>   * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> + * modify it under the terms of the GNU Lesser General Public Licens=
e
> + * as published by the Free Software Foundation; either version 2.1
> + * of the licence, or (at your option) any later version.
>   */
>  #define _GNU_SOURCE
>  #include <stdio.h>
> diff --git a/scripts/sign-file.c b/scripts/sign-file.c
> index 058bba3103e2..c3899ca4811c 100755
> --- a/scripts/sign-file.c
> +++ b/scripts/sign-file.c
> @@ -1,12 +1,15 @@
>  /* Sign a module file using the given key.
>   *
> - * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
> - * Written by David Howells (dhowells@redhat.com)
> + * Copyright =A9 2014-2015 Red Hat, Inc. All Rights Reserved.
> + * Copyright =A9 2015      Intel Corporation.
> + *
> + * Authors: David Howells <dhowells@redhat.com>
> + *          David Woodhouse <dwmw2@infradead.org>
>   *
>   * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> + * modify it under the terms of the GNU Lesser General Public Licens=
e
> + * as published by the Free Software Foundation; either version 2.1
> + * of the licence, or (at your option) any later version.
>   */
>  #define _GNU_SOURCE
>  #include <stdio.h>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
