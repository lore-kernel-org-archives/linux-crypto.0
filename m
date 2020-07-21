Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34D5C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 11:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC8F2073A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 11:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGULfg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:35:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49623 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgGULff (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 07:35:35 -0400
Received: from mail-qt1-f199.google.com ([209.85.160.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <marcelo.cerri@canonical.com>)
        id 1jxqYW-00018l-Q8
        for linux-crypto@vger.kernel.org; Tue, 21 Jul 2020 11:35:32 +0000
Received: by mail-qt1-f199.google.com with SMTP id m25so14117641qtk.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 04:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j1nJM1fQy7zet5k/ljBwGsBTKP8Zxzmp3fpVv8uHYCU=;
        b=aRtHLfrWLhIkEL2fd66Ujm7b+sCKUUOEdOhdlxHLUxsOtcWi2Itqwa6E6CRIQfFRWV
         pIey8W6x6Uhm9VEiKDYJw/1FhobXMMZBc5yWJDPXSS3xev4n3+MUFtUjJPnjO1URa0kX
         Hmey66qA5yezVTOMvHb/11t74LdcMPMKpgTsMZGXZovlNMfXiADYWyMjggjAUNJsBBIe
         9OIhj70SMegq3vjqLqXHEi1CfJ5UuFhyasEU4qfR/oDrE9P4OHhrwalMxcfBMlr5FaUT
         A8xh/+RFMkTVG8BbNsrLjcoTLpNRLHTXpwpf0d6LPGdM760iqaVKYT6jUqgAN3XSNOfD
         H8qQ==
X-Gm-Message-State: AOAM531qXsiZEXbL6IG/wFWSfjIuVtG3P4Bl1YUnCfCvZVQwLYfMcNmU
        YTX+4Kl2Fk+QWpZ1jdJUQTUoagZI2Ve9pDS5Ypit6wyE0ldOUJ2e64WOnz9MLr3LJBq8/AMPsqd
        9wNlIPIl9ij7CPyvruVSr47+K56WryePzXE1p9BjR
X-Received: by 2002:ac8:7587:: with SMTP id s7mr28797005qtq.304.1595331331740;
        Tue, 21 Jul 2020 04:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz82JiiYEjOiC7ovIIPUX4RY488QkDunyVYkmiOdNA9/R17DZ7nzM5EdV/z4Zq5tP5qsbnd7Q==
X-Received: by 2002:ac8:7587:: with SMTP id s7mr28796961qtq.304.1595331331297;
        Tue, 21 Jul 2020 04:35:31 -0700 (PDT)
Received: from valinor ([2804:14c:4e6:18:6044:1674:f98f:d11e])
        by smtp.gmail.com with ESMTPSA id r35sm22223584qtb.11.2020.07.21.04.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 04:35:29 -0700 (PDT)
Date:   Tue, 21 Jul 2020 08:35:24 -0300
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v3 0/5] DH: SP800-56A rev 3 compliant validation checks
Message-ID: <20200721113524.kdfs4nwn2oacexqx@valinor>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2544426.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pqj4lohvsb5td2q3"
Content-Disposition: inline
In-Reply-To: <2544426.mvXUDI8C0e@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--pqj4lohvsb5td2q3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

On Mon, Jul 20, 2020 at 07:05:45PM +0200, Stephan M=FCller wrote:
> Hi,
>=20
> This patch set adds the required checks to make all aspects of
> (EC)DH compliant with SP800-56A rev 3 assuming that all keys
> are ephemeral. The use of static keys adds yet additional
> validations which are hard to achieve in the kernel.
>=20
> SP800-56A rev 3 mandates various checks:
>=20
> - validation of remote public key defined in section 5.6.2.2.2
>   is already implemented in:
>=20
>   * ECC: crypto_ecdh_shared_secret with the call of
>     ecc_is_pubkey_valid_partial
>=20
>   * FFC: dh_compute_val when the req->src is read and validated with
>     dh_is_pubkey_valid
>=20
> - validation of generated shared secret: The patch set adds the
>   shared secret validation as defined by SP800-56A rev 3. For
>   ECDH this only implies that the validation of the shared secret
>   is moved before the shared secret is returned to the caller.
>=20
>   For DH, the validation is required to be performed against the prime
>   of the domain parameter set.
>=20
>   This patch adds the MPI library file mpi_sub_ui that is required
>   to calculate P - 1 for the DH check. It would be possible, though
>   to simply set the LSB of the prime to 0 to obtain P - 1 (since
>   P is odd per definition) which implies that mpi_sub_ui would not
>   be needed. However, this would require a copy operation from
>   the existing prime MPI value into a temporary MPI where the
>   modification can be performed. Such copy operation is not available.
>   Therefore, the solution with the addition of mpi_sub_ui was chosen.
>=20
>   NOTE: The function mpi_sub_ui is also added with the patch set
>   "[PATCH v5 2/8] lib/mpi: Extend the MPI library" currently sent
>   to the linux-crypto mailing list.
>=20
> - validation of the generated local public key: Patches 4 and 5 of
>   this patch set adds the required checks.
>=20
> Changes to v2:
>=20
> - add reference to GnuMP providing the basis for patch 2 and updating
>   the copyright note in patch 2
>=20
> Changes to v1:
>=20
> - fix reference to Gnu MP as outlined by Ard Biesheuvel
> - addition of patches 4 and 5
>=20
> Marcelo Henrique Cerri (1):
>   lib/mpi: Add mpi_sub_ui()
>=20
> Stephan Mueller (4):
>   crypto: ECDH - check validity of Z before export
>   crypto: DH - check validity of Z before export
>   crypto: DH SP800-56A rev 3 local public key validation
>   crypto: ECDH SP800-56A rev 3 local public key validation
>=20
>  crypto/dh.c          | 38 +++++++++++++++++++++
>  crypto/ecc.c         | 42 +++++++++++++++++++++---
>  crypto/ecc.h         | 14 ++++++++
>  include/linux/mpi.h  |  3 ++
>  lib/mpi/Makefile     |  1 +
>  lib/mpi/mpi-sub-ui.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 172 insertions(+), 4 deletions(-)
>  create mode 100644 lib/mpi/mpi-sub-ui.c
>=20
> --=20
> 2.26.2
>=20
>=20
>=20
>=20

--=20
Regards,
Marcelo


--pqj4lohvsb5td2q3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEExJjLjAfVL0XbfEr56e82LoessAkFAl8W0vwACgkQ6e82Loes
sAmqgAv/YksrmcmPJVLbzFQPzh2kn1HNr6uMFQ9yBP/0uyLgSuxyiwI5v1iNq3IX
UUE8rb78JH6OtajzTRsAdqfxssiTWMW4UajWxdpLAnrO8LXHyzrqVy9szsPl6GnL
ek7hTRROa4nSg2eKvaG216p+f8z4mbhDhb00uDJAum89l8b/Ou/gCw/058YhqaT0
BfIvd5F+/KfxgPwJ1SrSlMl2UiaJe/auQ0UMDNf29CeKW7fxJ2SB+EQAPKEVX+CH
V8SABJofXUAurynQnIGC8BYiZXWaEcbjyBFkRqEtmizDjtNohs7BGcfpToYp2lDe
l3rw54fnnKS3CChyg6A5jw9lW6CDrXfDv4qvs46eBrrnoMUfbDnGTt8T2iir7nem
Ch5h70TG71klZ99L46ems8Mw5wKz7JG+eJXbNsEuX4eCJrUwTB+HA8Kbl/iOgeiy
Y6hBpyLku42aQU1cjDvsdmmRGrthY4vrelGZ4EotaJdV44QA7QdSURRBKB1T1ACJ
CE35nqtN
=8jDX
-----END PGP SIGNATURE-----

--pqj4lohvsb5td2q3--
