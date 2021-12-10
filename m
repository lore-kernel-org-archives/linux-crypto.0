Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D31C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Dec 2021 09:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhLJJdv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Dec 2021 04:33:51 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49234
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhLJJdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Dec 2021 04:33:51 -0500
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B32563F1B7
        for <linux-crypto@vger.kernel.org>; Fri, 10 Dec 2021 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639128615;
        bh=TOABqDoDyoZMzu2zyuqzlEXvOXLcnUgJrT4MBvtVpOA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=gXlysmXAxXILTHqJA14oyeUlYguo7l/reCgxVP9qLgEYR/ZdI1NhuQMHKlFPwOK/3
         AHHoXNMjCTpaZg3YVbf8pxTMERCo5+9JTe2ggt5p1JwJzFoqf6zoAfBEmoaa+yu/o6
         19sY+lWRQTP+XRtFMTDgWATriezXNNdAMbUCTBy6MFuZs2UDAz1ziZ2BcR3DDBzq38
         b3Jj2tXlGKYVCYqI1NXQFSk9B1y+8Fu3y1IwAV3SnyXjrEjrhFiyoT9qrIpX/U1Jow
         89ByweDVokbuIz24j37v5yluIdvtMX6PnW5gi+Cer97DGX5QNOTHPBdoqIPe3Fr58s
         BRlui0KacpKjw==
Received: by mail-ua1-f71.google.com with SMTP id q12-20020a9f2b4c000000b002ddac466f76so6270593uaj.12
        for <linux-crypto@vger.kernel.org>; Fri, 10 Dec 2021 01:30:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TOABqDoDyoZMzu2zyuqzlEXvOXLcnUgJrT4MBvtVpOA=;
        b=d4qiRWxC4RcA9ZW/mC4PAP8tyPx+EnaBIXGbmcErfPf+AMUB0iKnJpG7P1woKUmYoq
         oI5iorxCtcEgIon7tJzhTfV+wtZcfAPXSF75+aYQEb5Us9pf9gjHYaVmMa1Kij6tv8u6
         TP+KxC5c8ME0G/CCp6uN1SCfcjZYow1ZCFKfd8eck7/k2NOGbbtyN5Vo1VsEQOsaUzEz
         Sm+nkb/iN8SWiGQeM3WiiwQR4WbQlYrhyDjJrvblAs7gP7y5DAKWYmsKdrbGl+JFT82m
         JiJG6keKyzliQHGjV+u+rV4SSHwyNrNrW3n4QJbwNZZM7xn7hSHDfgOOjx9EkyzmqHk8
         MvLg==
X-Gm-Message-State: AOAM533+4iQJ6IYzyNTYFzaDLUTVMXmQ9ehuagGhcB/n+UlLR6qk4Fau
        Ocb2nUTrZKIMCrUCzOUtc0o8YcJVMUCMm2WA/nc7BAidDZS0/9ES2HiCC8c2isV+iehNRAAD1k6
        5og9MSmi+3ucrgrMkRmQ4Qa2MYUcU2sBz9Hr7fMb1
X-Received: by 2002:a1f:a4c5:: with SMTP id n188mr16813184vke.35.1639128614797;
        Fri, 10 Dec 2021 01:30:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxs6KYO2BNAOeA7k7pCOR/YtUwCzO5VFWwci6JKJ+U36KM1Qb2zQXngD08zqwPFYw72xZFi4A==
X-Received: by 2002:a1f:a4c5:: with SMTP id n188mr16813149vke.35.1639128614509;
        Fri, 10 Dec 2021 01:30:14 -0800 (PST)
Received: from valinor (201-1-104-75.dsl.telesp.net.br. [201.1.104.75])
        by smtp.gmail.com with ESMTPSA id j15sm1592946vsp.8.2021.12.10.01.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:30:13 -0800 (PST)
Date:   Fri, 10 Dec 2021 06:30:03 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Simo Sorce <simo@redhat.com>,
        Jeffrey Walton <noloader@gmail.com>,
        Stephan Mueller <smueller@chronox.de>, Tso Ted <tytso@mit.edu>,
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
Message-ID: <20211210093003.lp6fexzrga3nijxn@valinor>
References: <CAH8yC8nokDTGs8H6nGDkvDxRHN_qoFROAfWnTv-q6UqzYvoSWA@mail.gmail.com>
 <YaYvYdnSaAvS8MAk@kroah.com>
 <ac123d96b31f4a51b167b4e85a205f31a6c97876.camel@redhat.com>
 <YaZHKHjomEivul6U@kroah.com>
 <YaZqVxI1C8RByq+w@gmail.com>
 <CAHmME9p60Ve5XJTVcmGvSpUkg_hRp_i0rGG0R9VhuwLs0o_nXQ@mail.gmail.com>
 <f4a4c9a6a06b6ab00dde24721715abaeca184a0d.camel@redhat.com>
 <CAHmME9qP9eYfPH+8eRvpx_tW8iAtDc-byVMvh4tFL_cABdsiOA@mail.gmail.com>
 <20211210014337.xmin2lu5rhhe3b3t@valinor>
 <YbL3wNBFi2vjyvPj@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u3noeovlywjbaelh"
Content-Disposition: inline
In-Reply-To: <YbL3wNBFi2vjyvPj@kroah.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--u3noeovlywjbaelh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 10, 2021 at 07:46:24AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 09, 2021 at 10:43:37PM -0300, Marcelo Henrique Cerri wrote:
> > Hi, Jason. How do you think we could approach that then?
> >=20
> > Are you willing to discuss the FIPS 140-3 requirements that random.c
> > doesn't currently meet so we can dive deeper on how we could implement
> > them in a way that would improve the kernel other then simply
> > providing compliance to FIPS?
>=20
> Discussing things doesn't usually work well.  Let's see some working
> patches first, that solve problems that you have with the current random
> code, and we can go from there.
>=20
> Again, like any other kernel patch submission, nothing new here at all.

Hi, Greg. I understand your point but we had plenty of patch
submissions already from Stephan, Nicolai and others and that didn't
work. So I am expecting that anybody taking over as the random.c
maintainer can at least provide some direction on that.

>=20
> > I believe all the distros are interested in making progress on that,
> > but without a general guidance it makes very hard for us to
> > collaborate and we end up in the current situation in which each
> > distro is carrying its own "hack", as Simo mentioned before. Canonical
> > is in the same situation as the other distros and we are carrying an
> > workaround to wire up the crypto DRBG to random.c in order to archive
> > compliance.
>=20
> If everyone seems to think their patches are hacks, and are not worthy
> of being submitted, then why do they think that somehow they are viable
> for their users that are actually using them?

Because although some people dislike it, FIPS is still a requirement
for many users. That's the reality and that will not change just
because there are some resistance against it.

The patches that distros are carrying are hacks because they try to
minimize risks while keeping the code as close as possible to
upstream. But that has several drawbacks, such as performance, limited
entropy sources an so on, that to me makes them not suitable for
upstream.

>=20
> {sigh}
>=20
> greg k-h

--=20
Regards,
Marcelo


--u3noeovlywjbaelh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAmGzHhsACgkQ6e82Loes
sAkIFwv/ToB/KAsEJ8MUrJncvDrR0Sul9V3jyn2CTZVF4hxLsQGelb/1QsOs5SOE
6I8BXrYyhwWJjDv/rJUaOH9Mu7alBp/quXZ1ntYHqo2m3k69sRXP7nusgt5wu54c
ImYFzl3VYLaAs4wEfbw2ZvKkeOCiX7ZF2eXLHmbxY/eZ4/SaRt37P72P952Rhz75
K4oa/otLEEJzaLSS1BmsifvlCXA51n5955P0MFs2HMtSeg1zuksPcwWd+ztJY4nl
bH8vr/wpQM1n/aFnFJSluVIEvXgOr8h4KGrYlxvfWkQ5PfZhr/FZE0F6Dm8yesfK
NI6ed7/gpALvq15e/2VunGJhJXBlvnfHALxAZYqx+8YAVRxzLYA6BMWsOTFQCdc+
I6+/CgIC2ZIba3TDhd2PVsOQgZG1K2jS3b9dfz4fKNsmoy9VRK6bt6KOO2EGRu3a
2AgPbvxXcWkn9+l4Z71g7FRMtEafjiAkYW1RVxfTO3Ej08GIsOo7XyDePQdxmIKD
vj9eSAns
=k1Az
-----END PGP SIGNATURE-----

--u3noeovlywjbaelh--
