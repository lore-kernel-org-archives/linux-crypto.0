Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE25C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jun 2022 14:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiFNOPk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242601AbiFNOPj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jun 2022 10:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AA9633A0A
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jun 2022 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655216135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JctC2m2+QZN18u2MNb2HvFmHLpXv366LEOSyUu6TasQ=;
        b=iDnpfzdKKza6TuZmcvl+vbofoPO7jDrSkkz7OdC8+TPKF9DR8BL3KseY8nqTMPGuFn9O2h
        6DZ9KPeUG5NQWnBHQaCI+YJ7puia/mzwaJRfCSIrT+Xwyh4VTvPZOSGQJARQRJ5CM5TkWk
        c9SHn7ojEpCT2axlHqkg6JSovCbIegs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-W1nI5BIIM06fc2d3Bl9xgg-1; Tue, 14 Jun 2022 10:15:34 -0400
X-MC-Unique: W1nI5BIIM06fc2d3Bl9xgg-1
Received: by mail-qv1-f70.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso5996402qvb.15
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jun 2022 07:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:content-transfer-encoding:user-agent
         :mime-version;
        bh=JctC2m2+QZN18u2MNb2HvFmHLpXv366LEOSyUu6TasQ=;
        b=Cso4Mi3SPvIYH1aJLnFLfuqe/zts/zXSJJKlOmxArjt6AWYHsG0e/kp4J3vNxWwo5u
         7yiQ9cp7vEbZmrUcgxex79hsO1s7OLaQQvG0EHB6q+YD4+5Qm+2tYH2wM4z0diDOw5UO
         2ON3LW0AieCYNylrnQbxTf7/6T6Lia97kRydzttRzwRpKJaPf0QuPN7BLwDEBlvSZ1n9
         52I706pC0Ytqty7wZR8T9e0igHr3kHaHSeJ/WldFP7EYzVc8S4QNMRrG+61KDkxmCPkp
         CxhNMqRiAPyypQq+EU/7Nmt0FBmSHXCDK5Cad3/yhTVB1nhWUqZGZQHiwM+4HiTcfBtV
         Dm2g==
X-Gm-Message-State: AJIora+LgD8gk5fmBpzJJ3b+RC4Gr8k4cFKuhhYm1/Z29F2OsoQ58WNq
        3gEvM0UWzby7RfZHuUDzvne5QICubpxVIxW3HjfaUjmTyPmafxYiA7wVAEtLxSxaY+aMUP/BI17
        LWjd5b+dere4E8DJGt1gQapj5
X-Received: by 2002:ad4:5c4a:0:b0:464:5920:7c1a with SMTP id a10-20020ad45c4a000000b0046459207c1amr3579679qva.58.1655216133915;
        Tue, 14 Jun 2022 07:15:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sUmVYfieNEUEGblxVDH6VoXBlZfAPSf7IbUAfA0HBAtNoDeIhDejnqioeqYTK2ssE5LXtTUg==
X-Received: by 2002:ad4:5c4a:0:b0:464:5920:7c1a with SMTP id a10-20020ad45c4a000000b0046459207c1amr3579632qva.58.1655216133401;
        Tue, 14 Jun 2022 07:15:33 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([93.56.163.49])
        by smtp.gmail.com with ESMTPSA id h20-20020a05620a245400b006a32bf19502sm9394754qkn.60.2022.06.14.07.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:15:32 -0700 (PDT)
Message-ID: <831c7380f7d89fd8fb3a3043cf3b3d01001ae0be.camel@redhat.com>
Subject: Re: [PATCH 0/2] certs: Add FIPS self-test for signature verification
From:   Simo Sorce <simo@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 14 Jun 2022 10:15:24 -0400
In-Reply-To: <165515741424.1554877.9363755381201121213.stgit@warthog.procyon.org.uk>
References: <165515741424.1554877.9363755381201121213.stgit@warthog.procyon.org.uk>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2022-06-13 at 22:56 +0100, David Howells wrote:
> Hi Herbert,
>=20
> If you could look over this pair of patches?  The second patch adds a sim=
ple
> selftest to allow the signature verification code so that it can be FIPS
> compliant.  The first moves load_certificate_list() to the asymmetric key=
 code
> to make this easier and renames it.
>=20
> I generated the test data myself, but I'm open to using some standard tes=
t
> data if you know of some; we don't want too much, however, as it's
> incompressible.  Also, it has avoid blacklist checks on the keys it is us=
ing,
> lest the UEFI blacklist cause the selftest to fail.
>=20
> The patches can be found on the following branch:
>=20
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/lo=
g/?h=3Dkeys-fixes
>=20
> David
> ---
> David Howells (2):
>       certs: Move load_certificate_list() to be with the asymmetric keys =
code
>       certs: Add FIPS selftests
>=20
>=20
>  certs/Makefile                           |   4 +-
>  certs/blacklist.c                        |   8 +-
>  certs/common.c                           |  57 ------
>  certs/common.h                           |   9 -
>  certs/system_keyring.c                   |   6 +-
>  crypto/asymmetric_keys/Kconfig           |  10 +
>  crypto/asymmetric_keys/Makefile          |   2 +
>  crypto/asymmetric_keys/selftest.c        | 224 +++++++++++++++++++++++
>  crypto/asymmetric_keys/x509_loader.c     |  57 ++++++
>  crypto/asymmetric_keys/x509_parser.h     |   9 +
>  crypto/asymmetric_keys/x509_public_key.c |   8 +-
>  include/keys/asymmetric-type.h           |   3 +
>  12 files changed, 321 insertions(+), 76 deletions(-)
>  delete mode 100644 certs/common.c
>  delete mode 100644 certs/common.h
>  create mode 100644 crypto/asymmetric_keys/selftest.c
>  create mode 100644 crypto/asymmetric_keys/x509_loader.c
>=20
>=20

Reviewed-by: Simo Sorce <simo@redhat.com>

--=20
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



