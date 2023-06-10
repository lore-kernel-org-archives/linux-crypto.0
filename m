Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E245C7EE2E
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 07:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjFJHZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Jun 2023 03:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjFJHZm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2023 03:25:42 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875AC3AA4
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 00:25:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-65311774e52so2086483b3a.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 00:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686381941; x=1688973941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kG/skBrK2yNu2Lynfk5oBWsSuqrNyFnFTv0dJ8YQThE=;
        b=Yc05dPakHlE4UiKVz1abW6knYkfP3XNQ3ogJFSPBgSO+YxV05PhvWd+Mh4bwoZaNGc
         woAeKmGfunJ1sgi8WpRc9f549f/S2IbWvm5Kc+Yw3s+9CQ5mHeO2mQpEFbXWZWqkKIQP
         /4rYUCb9PThTRhQm9SYqwoPnzBviVMyPXmvp+zDLEdfBjDXbBP2q6pq6/dcq1R6zknj2
         s9CWAx/hWIatb+PHIq9EQ8zVY9BIYJMON7NhsAkcsFW9U25RiOSbOvatu9kK8zqnqHYE
         tS9x7tanggRuN+gC5g1fWEc8L4ZYpnzKS28CH99aiEuK1IGicXaC/TFxaElIpTD3x/Mu
         iJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686381941; x=1688973941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kG/skBrK2yNu2Lynfk5oBWsSuqrNyFnFTv0dJ8YQThE=;
        b=kgf47kimVgVI+vdx0GPnMn6OSNGTYgXuFqVoc/x/o9i9yAAMK+uBdVDQbc9vpCB9Vl
         yChEiKd4yG6mmVuCFpSpv3Xdz5EwzzvoxEjxwyPqLj0bFqYelSxF6od1BDwDLVMEbe7P
         ohG1r30dx8iF5RDDgNvgIrAMiSD/nLTuaK9dp9dt+Z5OVUBD78pQjH/MspHjDgQup8Cy
         F92qeV6SnOapp2a4zM6l19fKa+lpz4n6KlfPK4oupyQMW6Sd/Acjd1rmxsViXWfx/f3e
         mzrX6rk4/bY3Q4R6zd4Q/JFlWnLOnlIAANi/HUAsKE1oq6554w4wSLcozNBWQOmqSHfU
         vVDw==
X-Gm-Message-State: AC+VfDyPFgei7TMU30yNmauW7hsZ69Pssm+XCskBYvq+7yTFlLHXsgne
        KQTeagePGBUOym3BziNfQEE=
X-Google-Smtp-Source: ACHHUZ6c35Ir32Kh664VRJNfK4H/RJYRZGM3ADkAcPYjZ89CZOYi6VYR5lnkQloGQwz+sOh8WS0s/g==
X-Received: by 2002:a05:6a21:328d:b0:10b:2214:7ab0 with SMTP id yt13-20020a056a21328d00b0010b22147ab0mr3933191pzb.21.1686381940862;
        Sat, 10 Jun 2023 00:25:40 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-69.three.co.id. [223.255.225.69])
        by smtp.gmail.com with ESMTPSA id l13-20020a654c4d000000b005307501cfe4sm3629551pgr.44.2023.06.10.00.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 00:25:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 6434C106AB1; Sat, 10 Jun 2023 14:25:37 +0700 (WIB)
Date:   Sat, 10 Jun 2023 14:25:37 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Richard Fontana <rfontana@redhat.com>
Subject: Re: [PATCH 0/3] crypto - some SPDX cleanups for arch code
Message-ID: <ZIQlcc_9lyWtP0Jg@debian.me>
References: <20230606173127.4050254-1-ardb@kernel.org>
 <20230607043730.GB941@sol.localdomain>
 <20230610031248.GC872@sol.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="drldH6IlG99tuUVB"
Content-Disposition: inline
In-Reply-To: <20230610031248.GC872@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--drldH6IlG99tuUVB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 09, 2023 at 08:12:48PM -0700, Eric Biggers wrote:
> Actually, given the discussion on the other thread
> https://lore.kernel.org/r/20230607053940.39078-10-bagasdotme@gmail.com, m=
aybe it
> would be best to hold off on this for now?  Or at least split this series=
 into
> more patches, such that each patch does only one "type" of SPDX replaceme=
nt.

Thanks for pointing to my thread! (and Cc'ing Richard of course ...)

If we continue on the conversion, I definitely agree with your latter
option (as I have done there).

>=20
> I still think these conversions are probably fine, but some points that p=
erhaps
> need an explicit explanation are:
>=20
> * Using GPL-2.0-only for files like chacha-neon-core.S whose file header =
says
>   GPL v2, but also says GPL v2 or later.

In that case, IMO, err to the safe side and assume the most restrictive
(GPL-2.0-only).

>=20
> * Replacing with SPDX on files that explicitly say "DO NOT ALTER OR REMOVE
>   COPYRIGHT NOTICES OR THIS FILE HEADER."

Just add the SPDX tag...

>=20
> * Using BSD-3-Clause when the license text in the file header has the cop=
yright
>   holder name instead of "copyright holder", thus making it not an exact
>   word-for-word match with LICENSES/preferred/BSD-3-Clause.  (It seems th=
ere are
>   specific rules for variations that have been approved, e.g. see
>   https://github.com/spdx/license-list-XML/blob/main/src/BSD-3-Clause.xml=
 and
>   https://spdx.github.io/spdx-spec/v2.2.2/license-matching-guidelines-and=
-templates)

Above case is wording variation (for which we conclude that only license
boilerplate with exact wording can be replaced by the tag).

>=20
> * Using "GPL-2.0-only OR BSD-3-Clause" for the two crct10dif-ce-core.S fi=
les.
>   They have an unusual file header, and it could be argued that some
>   contributions to those files were intended to be licensed under GPL-2.0=
-only.
>   FWIW, I am fine with either license for my contributions to those files.

Dunno.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--drldH6IlG99tuUVB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIQlbgAKCRD2uYlJVVFO
o4GXAQDS2OcDpcmPm55DAxSmH9pIieibikQ3Rlw1AH5/h4COdwEAyVK7nbFoB6gw
aUBlS3fY56IKGTmFwUFWjYeNyW+cOQw=
=KWcA
-----END PGP SIGNATURE-----

--drldH6IlG99tuUVB--
