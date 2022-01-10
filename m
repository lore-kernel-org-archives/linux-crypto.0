Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8253DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jan 2022 15:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbiAJPIE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jan 2022 10:08:04 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:37634
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbiAJPIE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jan 2022 10:08:04 -0500
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D07383F1A2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jan 2022 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641827282;
        bh=k4Z0FKYBFvD8zuWLkEANuqJoDxX4Vy32CJrotfBvkeA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=ccN7h+wnEUteLuRVNbcQ+7VhJtJIOeamOMstrlhkgA9HNycvTo6YilbJX/Okar4rm
         ehp81oNO+Pox/h3H7zdeD0NGXhd8lSjsuD9MpT3iGCJ1EbbByfPDBAL0WygK8KTPX5
         VkuD3uVXy4bn2USW6EJ4E7SvhMH6i+sdBTrrpbCFnEnXYBBbt86EaS8JyoYFPiOe3L
         kFEu5f5QnwickWXIppPgHij+x5PVBaC1N5vaAJRSFpEqmD/cJKHuFItd5PvcK85mWC
         KENidXpRhQcTuxSeMqZQfuVNnmfuLC2KNHg9JQmfK5uSwtUF+CHHHtb3nZwodwNVj8
         SWlqEfOC3cvpA==
Received: by mail-vk1-f199.google.com with SMTP id r15-20020a1fa80f000000b003133230d1e1so2805717vke.7
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jan 2022 07:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4Z0FKYBFvD8zuWLkEANuqJoDxX4Vy32CJrotfBvkeA=;
        b=IuHn5eqY+u4Bxv0TNlFiOqmbSqExF8tPjdkfsF03K9X4JUWzDr4suRuVRN4hoEm4WW
         BLwxtMOzT7t0VuIevpnGvtT3KnFqWS2Szl0NgUUxypkvj5fB2zN3MCkAAQ1oMdjueUJI
         OkV9SdzwRWl2HYiuX0xCzSWSAokgh5YBmYjG8KoaRnFKBD4YySnKUDh942vdRuro3rHv
         E0QjAentP54S1NIalr7AzqcT3lJ7xPfbf3L+z75NoMieK2z4fjBWufIInCZjYVlrS4DV
         vr+zMwU+wx39C99OsmJ8tIMFKw4HP1cmcnQ+w/QY4Lg4Wyty8eGK66YsP1OZfdNjPJ2x
         +dIw==
X-Gm-Message-State: AOAM530IfH6xrbYVuLVm1Wrhmm/EWeRgtBvIKm+J0AfSSM4MwpOycjHe
        60USZX/v3YZ4Fqj93EJ3GRGj/aWb884tR/U9Lc6trnd/CvEDPgyl2Fr/BdTNoNMKDr2Etk7i8Cj
        +j1/wzlmrDCrpPgFEB/95Qj3wVP0J1oQI+waa8VQo
X-Received: by 2002:a9f:326d:: with SMTP id y42mr38695uad.119.1641827281682;
        Mon, 10 Jan 2022 07:08:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOgt+M2vPY7qOIlhOxsc6l4UH7vrRQWGTR8qeSBbJzHUyEKU35JdlMBarGftYfPnIu7W2XPQ==
X-Received: by 2002:a9f:326d:: with SMTP id y42mr38661uad.119.1641827281380;
        Mon, 10 Jan 2022 07:08:01 -0800 (PST)
Received: from valinor ([177.95.23.3])
        by smtp.gmail.com with ESMTPSA id w62sm3859726vkd.47.2022.01.10.07.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 07:08:00 -0800 (PST)
Date:   Mon, 10 Jan 2022 12:07:51 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Simo Sorce <simo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeffrey Walton <noloader@gmail.com>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
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
        Eric Biggers <ebiggers@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Message-ID: <20220110150751.eyragx5tk7scd5p4@valinor>
References: <ac123d96b31f4a51b167b4e85a205f31a6c97876.camel@redhat.com>
 <YaZHKHjomEivul6U@kroah.com>
 <YaZqVxI1C8RByq+w@gmail.com>
 <CAHmME9p60Ve5XJTVcmGvSpUkg_hRp_i0rGG0R9VhuwLs0o_nXQ@mail.gmail.com>
 <f4a4c9a6a06b6ab00dde24721715abaeca184a0d.camel@redhat.com>
 <CAHmME9qP9eYfPH+8eRvpx_tW8iAtDc-byVMvh4tFL_cABdsiOA@mail.gmail.com>
 <20211210014337.xmin2lu5rhhe3b3t@valinor>
 <20220110132349.siplwka7yhe2tmwc@valinor>
 <CAHmME9oSK5sVVhMewm-oVvn=twP4yyYnLY0OVebYZ0sy1mQAyA@mail.gmail.com>
 <YdxCsI3atPILABYe@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yrkvaum5odjlkfrt"
Content-Disposition: inline
In-Reply-To: <YdxCsI3atPILABYe@mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--yrkvaum5odjlkfrt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2022 at 09:29:04AM -0500, Theodore Ts'o wrote:
> On Mon, Jan 10, 2022 at 03:11:46PM +0100, Jason A. Donenfeld wrote:
> > On Mon, Jan 10, 2022 at 2:24 PM Marcelo Henrique Cerri
> > <marcelo.cerri@canonical.com> wrote:
> > > Hoping that might help with the discussion and to explain why I do
> > > consider those solutions a "hack", that's the patch we've been using
> > > so far to achieve SP 800-90B compliance:
> > >
> > > https://kernel.ubuntu.com/~mhcerri/0001-UBUNTU-SAUCE-random-Use-Crypt=
o-API-DRBG-for-urandom-.patch
> >=20
> > Thanks for sending this in response to my request for it in our private=
 thread.

No problem. And sorry for the delay.

> >=20
> > Just to confirm, this little patch here gives you FIPS certification?

It does because it basically replaces everything in random.c (for
urandom in this case) with the Crypto API DRBG, which is
compliant. Although it might be wiser to replace both urandom and
random in this case.

>=20
> There might be some FIPS certification labs that might be willing to
> be taken in by the jitterentropy story, but when I've had private
> communications from people who are familiar with the Intel
> microarchitecture saying that jitterentropy is mostly "security by
> obscurity", I'd be strongly opposed to replacing the current scheme
> with something which is purely jitteretropy.
>=20
> Perhaps an build-time option where one of the seeds into the CRNG is
> "jitterentropy", but we keep everything else.  That way, jitterentropy
> can still be TSA-style "security theatre", but we're not utterly
> dependant on the "the CPU microarchitecture is SOOOOOOO complicated,
> it *must* be unpredictable".
>

Hi, Theodore.

I might be missing something, but the Crypto API DRBG is seeded by
jitterentropy_rng and by get_random_bytes(), their outputs are both
concatenated and used as the seed. So I don't think that should be a
concern, right?


> 						- Ted

--=20
Regards,
Marcelo


--yrkvaum5odjlkfrt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAmHcS8cACgkQ6e82Loes
sAkzfQv/YFKX+P7lMLHqRDZj2C8ENBjvbx6HOZyNGL9QEucfEHEAlRjjErgxFObs
H0SfkUmIEgg1JGJPCTFrD4Wge4LsU2ZY4seQvl1GM1zpC90icUY//Y1mc+rjpW/A
svYUwA7o7J0+nsZqreMyAgqF3inu6GujSywYHzP71Fjaq61Mu5+5jY//07LpYU4x
uPo2uKiG1d3GjFKWD7QHzgudF+X0/SaVA5NGEDDR0z6G7QS5R2HvDoj8sulCcyr1
nLSkiYQNUAivYPzlgwF/x/ezLdPHvrRWpGJnWkDrPlGfz1cdamdr7z2CgmbX8xZN
q8XUIOrH2d08S4HYh3Z6j3u3E8OQMxQ4vBZKdKs980h65h4AI5gunacKPBBELzED
CCuYycmZlL8BmYW6w1e1Ewnlkfb1xkFW/dElps6RJuJJGbipKCHx9kOgyc6kc6OC
rfuLDaIIb1LJvCuGPsBNGuSMu7wl94f/ueUMTxcFumaQb7GIwzG3/tmKVm2PeAOG
uXF8c05f
=Jjuy
-----END PGP SIGNATURE-----

--yrkvaum5odjlkfrt--
