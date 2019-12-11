Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8687C2D0C6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 20:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92BC92173E
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 20:38:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="qD1PQgWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfLKUiB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 15:38:01 -0500
Received: from ozlabs.org ([203.11.71.1]:34943 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfLKUiB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 15:38:01 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47Y7zV6Cfbz9sR7;
        Thu, 12 Dec 2019 07:37:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576096679;
        bh=TqGBa9RdBOyz6xcAX/wv4TSVKSa+idsg3abp07UvJLk=;
        h=Date:From:To:Cc:Subject:From;
        b=qD1PQgWRLTvewnvTCIT5SUEQezIMQynjhMSmcBWOq83b4V3/cFgKZbRK9iUuP1pya
         bAawTvI228Q1fNzP4kRuqoj278xzOfzesC3umyO6vfer8ILlstLRto0t9L27Qja9hA
         5OtKiXi+nUxMYt3Yvpyx8v4uc8JR4xBtmDKtHqurm4dbfIWHTfxOjJyHA1bvP4856R
         bRPN4wlDtc/aQLTUBCkUJP2y3WFtsiRu+opY+DgpHqXfmuAUHaAcV4Wq8lbT7HiMAm
         f8YNsJ+oEO7c1sRWup5Xs9LOQXBv3a+Gz6gOPSmFjbC9dkb4Fo4h9Z+Z673bLSuVD7
         u+B2Iq0sWlhwQ==
Date:   Thu, 12 Dec 2019 07:37:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: linux-next: Fixes tag needs some work in the crypto tree
Message-ID: <20191212073750.62a974dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YThANIE2iXQVlG+Kq.23wPW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--Sig_/YThANIE2iXQVlG+Kq.23wPW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7278fa25aa0e ("crypto: caam - do not reset pointer size from MCFGR regist=
er")

Fixes tag

  Fixes: a1cf573ee95 ("crypto: caam - select DMA address size at runtime")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/YThANIE2iXQVlG+Kq.23wPW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3xU54ACgkQAVBC80lX
0GwWrQgAnRRG1FHbQHrQCQ2UrHc9f8sBoAOaENCMuiw+GZwFN48SC5wlm4bWui+r
AOJ+B90RFl9tbGX7cUbvTwfQO6LKx18dqP3AdWcCtSRO7/FteXJnT6Ry0k/oz5dU
voAHWjwYDCmg9LWRlDGoMHhRemUEmRj7HMVM5+5zAxumoNMI84olB/DwhICGUDLU
n3CIDxgptPGerGQ8w1luxuA8Un9IeuyIrrhqqAMFGGkyiVyT3PXwp8PwSyT3uGa7
0HF584uS0yY4pntbsebAa0WYOzJo7eq8my8vIIDH8R4OlcmX6sfWs1HPgeaD2hXU
Tz0L2mW178H5rReqsliwiR9iUMiybg==
=l8JG
-----END PGP SIGNATURE-----

--Sig_/YThANIE2iXQVlG+Kq.23wPW--
