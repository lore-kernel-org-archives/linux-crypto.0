Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1E3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 16:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97D320789
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 16:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343899AbhA0QNq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jan 2021 11:13:46 -0500
Received: from mail-40140.protonmail.ch ([185.70.40.140]:21406 "EHLO
        mail-40140.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343837AbhA0QNA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jan 2021 11:13:00 -0500
Date:   Wed, 27 Jan 2021 16:12:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1611763933;
        bh=CXG+0jciHe2vDbT437FM3Qo95DNVBYkdhL5WZaYUPoY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=soC1P8y5fbrH54We/uaS8kb/dds+4mQBpXZy35ILyJjxvA7AiwxabAYh4pvwxNXoo
         sJd2t2PH7IVYBhWLFvnCrNo+hPtPM1ZejKxhc3NLHZ9YAHPXrOXkLzXeFUIYdAwfM9
         0DlB1Lw9h8W/zKKX63lNfW2kdfm8askULqa6Nv10=
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
From:   Nym Seddon <unseddd@protonmail.com>
Cc:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "patrick@puiterwijk.org" <patrick@puiterwijk.org>,
        Stefan Berger <stefanb@linux.ibm.com>
Reply-To: Nym Seddon <unseddd@protonmail.com>
Subject: Re: [PATCH v3 0/3] Add support for x509 certs with NIST p256 and p192 keys
Message-ID: <yOgLSllWWtGlr6OYcQxe8CeFwK4H9cWzWbalszgSv4xN_DxK6AGG_vNRyuVX6aKHzesDaj0LK9pB0q8SIQWXQETX26J6KXe428OPMHJYvus=@protonmail.com>
In-Reply-To: <20210127123350.817593-1-stefanb@linux.vnet.ibm.com>
References: <20210127123350.817593-1-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stefan,

In the recommendations from SafeCurves (https://safecurves.cr.yp.to/twist.h=
tml) there are a number of attacks against ECC twists. Two of those attacks=
 are relevant against NIST P192: invalid-curve attacks and invalid-curve at=
tacks against ladders.

Both attacks can be mitigated by checking the supplied public key is on the=
 correct curve, before performing curve operations.

Not sure if the right place for those checks are in the signature verificat=
ion code provided in these patches, or when reading public keys from the ce=
rtificates. Does the kernel provide functions for checking curve points sat=
isfy their respective curve equations?

There are also tables describing the cost of combined attacks on various cu=
rves, where NIST P224 already falls below the safe threshold. Because of th=
at, I would recommend not implementing support for NIST P192 (since it woul=
d fair even worse).

What are your thoughts?

Best,
Nym

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Wednesday, January 27, 2021 12:33 PM, Stefan Berger <stefanb@linux.vnet.=
ibm.com> wrote:

> From: Stefan Berger stefanb@linux.ibm.com
>
> This series of patches adds support for x509 certificates signed by a CA
> that uses NIST p256 or p192 keys for signing. It also adds support for
> certificates where the public key is a NIST p256 or p192 key. The math
> for ECDSA signature verification is also added.
>
> Since self-signed certificates are verified upon loading, the following
> script can be used for testing:
>
> k=3D$(keyctrl newring test @u)
>
> while :; do
> for hash in sha1 sha224 sha256 sha384 sha512; do
> openssl req \
> -x509 \
> -${hash} \
> -newkey ec \
> -pkeyopt ec_paramgen_curve:prime256v1 \
> -keyout key.pem \
> -days 365 \
> -subj '/CN=3Dtest' \
> -nodes \
> -outform der \
> -out cert.der
> keyctl padd asymmetric testkey $k < cert.der
> if [ $? -ne 0 ]; then
> echo "ERROR"
> exit 1
> fi
> done
> done
>
> It also works with restricted keyrings where an RSA key is used to sign
> a NIST P256/P192 key. Scripts for testing are here:
>
> https://github.com/stefanberger/eckey-testing
>
> The ECDSA signature verification will be used by IMA Appraisal where ECDS=
A
> file signatures stored in RPM packages will use substantially less space
> than if RSA signatures were to be used.
>
> Stefan
>
> v2->v3:
>
> -   patch 2 now includes linux/scatterlist.h
>
>     v1->v2:
>
> -   using faster vli_sub rather than newly added vli_mod_fast to 'reduce'
>     result
>
> -   rearranged switch statements to follow after RSA
>
> -   3rd patch from 1st posting is now 1st patch
>
>     Stefan Berger (3):
>     x509: Detect sm2 keys by their parameters OID
>     x509: Add support for parsing x509 certs with NIST p256 keys
>     x509: Add support for NIST p192 keys in certificates and akcipher
>
>     crypto/Makefile | 9 +-
>     crypto/asymmetric_keys/public_key.c | 19 ++
>     crypto/asymmetric_keys/x509_cert_parser.c | 45 ++-
>     crypto/ecc.c | 318 ++++++++++++++++++++++
>     crypto/ecc.h | 2 +
>     crypto/ecc_curve_defs.h | 4 +
>     crypto/eccsignature.asn1 | 4 +
>     include/linux/oid_registry.h | 6 +
>     8 files changed, 404 insertions(+), 3 deletions(-)
>     create mode 100644 crypto/eccsignature.asn1
>
>     --
>     2.25.4
>


