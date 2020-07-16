Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65FFC433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13DD2067D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 08:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594888890;
	bh=UfILHqeGuXflAqkn8DJhglwizrm3+RlAHJ5MI8iyvpk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IbTrCE1u1dXAP9cn1dGdurNQ0qcZV0AVWDiRtjb4MrtuNswax+2Kbk2PkBRayfELo
	 oMZJDkwaRM/pisHAUAQVQbUOtZfYcEHpF+YK9x/GFU8v1f9SJfpmGXrDtWTHW1KjE+
	 8rIUqWslBBVqnRF5NqeZEENx6VykUFP9ZWwn/21g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgGPIla (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGPIl3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 04:41:29 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191FB2067D
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594888889;
        bh=UfILHqeGuXflAqkn8DJhglwizrm3+RlAHJ5MI8iyvpk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zW2VpktSoGR+7NxY0amEo4JoW44caiL4fV6A13OKp8jKq5wUCuH6rypSvpnV/31mj
         sVqhN/fmNSwtn3W5QUOo2lhjeWsImwhWupU2QaCJrNPp8WFq2yqzVD/Y/uUhKKBfPD
         Okv7n1+Jt5SS/UdPXq2GdshCBH476OZ14XX+hjSo=
Received: by mail-oi1-f173.google.com with SMTP id t198so4474585oie.7
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 01:41:29 -0700 (PDT)
X-Gm-Message-State: AOAM530oPJRXBg+uCT/HEgVUL9+UuoKz5ogiSRmuNe1ZEqhmjmEPaSK6
        QiLBT4ibUTJvASlk+QMHhdcVVCPR7IWecVtB51c=
X-Google-Smtp-Source: ABdhPJwdL3O44TWYHi4nOEsqZcjAaNdMISBnmX1ZgdHqK9MLqkPGxM9Ur2EF6EGO63XipbVWStorfTj7wARhK2OCLME=
X-Received: by 2002:aca:d643:: with SMTP id n64mr3033847oig.33.1594888888443;
 Thu, 16 Jul 2020 01:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
 <4650810.GXAFRqVoOG@positron.chronox.de> <20200716073032.GA28173@gondor.apana.org.au>
In-Reply-To: <20200716073032.GA28173@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 16 Jul 2020 11:41:17 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
Message-ID: <CAMj1kXHNM5pwjSuVgxP2SA5juTnVxpj0ULUkjNWuoHqVTjuE8Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] lib/mpi: Add mpi_sub_ui()
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, nhorman@redhat.com,
        simo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 16 Jul 2020 at 10:30, Herbert Xu <herbert@gondor.apana.org.au> wrot=
e:
>
> On Sun, Jul 12, 2020 at 06:39:54PM +0200, Stephan M=C3=BCller wrote:
> >
> > diff --git a/lib/mpi/mpi-sub-ui.c b/lib/mpi/mpi-sub-ui.c
> > new file mode 100644
> > index 000000000000..fa6b085bac36
> > --- /dev/null
> > +++ b/lib/mpi/mpi-sub-ui.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* mpi-sub-ui.c  -  MPI functions
> > + *      Copyright 1991, 1993, 1994, 1996, 1999-2002, 2004, 2012, 2013,=
 2015
> > + *      Free Software Foundation, Inc.
> > + *
> > + * This file is part of GnuPG.
> > + *
> > + * Note: This code is heavily based on the GNU MP Library.
> > + *    Actually it's the same code with only minor changes in the
> > + *    way the data is stored; this is to support the abstraction
> > + *    of an optional secure memory allocation which may be used
> > + *    to avoid revealing of sensitive data due to paging etc.
> > + *    The GNU MP Library itself is published under the LGPL;
> > + *    however I decided to publish this code under the plain GPL.
> > + */
>
> Hmm, you said that this code is from GNU MP.  But this notice clearly
> says that it's part of GnuPG and is under GPL.  Though it doesn't
> clarify what version of GPL it is.  Can you please clarify this with
> the author?
>

GnuPG was relicensed under GPLv3 in ~2007, IIRC, so given the
copyright years and the explicit statements that the file is part of
GnuPG and not under the original LGPL license, there is no way we can
take this code under the kernel's GPLv2 license.
