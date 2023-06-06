Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FB5C7EE2F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 11:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbjFFLgu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 07:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbjFFLgt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 07:36:49 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C428F196;
        Tue,  6 Jun 2023 04:36:48 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-39c503bc770so306517b6e.0;
        Tue, 06 Jun 2023 04:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686051408; x=1688643408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R92KuS7gawSx2LWw+ooVWTPC6JkJv9bdowpbo01HVAw=;
        b=KWM8ThY/M3uM372kffwhthc6oRXcuseLvAve9vjPRRuzhSZxcV1WgKQCyntbH7Esu7
         cZlAzbtguAWGAxejMBdHHv7Ibvu3VWnpXyGRw51hrlfbOSnejVz5vCPbsh/1WI68Tp91
         +2zdkEy/aDO0dcopt49vPZlstLrxUbp3PTlfEZTa6+LPHMdIllJ4PoXLh07CjiT7nuQ8
         zvPy+HIydi7yjsqanQcMr/fRwI8lILVvDkxnyN3ALPKafYzdFFsXqpoREvA2TTNqZd8Q
         qPXyI1Qq9XWu8GIrE7whBTX+FxVv/27CHPmeIfnsdcKICNNIHkymjVSYNnEZNgQMLg8X
         E+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686051408; x=1688643408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R92KuS7gawSx2LWw+ooVWTPC6JkJv9bdowpbo01HVAw=;
        b=V5w5nPzymjIZOVSOF9Cwjg4LjVkKPXDyEP+xAa+sRAnzh3fipUAf1Rm/bPV0vpRAzO
         j+XgWfnPX33SIZcsiQdt+rWHDSUl9thhVznhypkSF1tTo+e+L7sBaJf27YEiyzg5Z1oR
         xE6Vpl5eizeopF6jMplH6q7tiKx/CXLBnhUvRAGfGToLfJku45C0PkZL8biAy7MVh+AP
         HwEsP2wR2S7ncBlR1blrF07Dmpiu74wwIMpBB8iCFn+5X3k+WUyOKbdPyYQw0w/rYR3N
         UcpBhbOrfyvaUAsmLSN9IPSkclx0Zam+O5Qmt7hJwR3lhwK53cRQWxMknrQdA4GM/XHV
         zsJA==
X-Gm-Message-State: AC+VfDxlULC5abDy8BDp/keCUxy3OCjOF305h0DbpOIoklTtBIPOqvHp
        X5e3LKc/3//j5dkcxLkxlHzoTEhOnv4=
X-Google-Smtp-Source: ACHHUZ6076hhAKQCiN1ZGGrVzz/fYBz/bp2CAfqnll20uGWpIG1MlOWX50Uveq2xE2o3dLht+3Ugsw==
X-Received: by 2002:aca:130c:0:b0:396:3b9b:d217 with SMTP id e12-20020aca130c000000b003963b9bd217mr2133146oii.18.1686051407914;
        Tue, 06 Jun 2023 04:36:47 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-71.three.co.id. [223.255.225.71])
        by smtp.gmail.com with ESMTPSA id g12-20020a63e60c000000b00502ecc282e2sm7244378pgh.5.2023.06.06.04.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:36:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id BD9E2106A3A; Tue,  6 Jun 2023 18:36:43 +0700 (WIB)
Date:   Tue, 6 Jun 2023 18:36:43 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Franziska Naepelt <franziska.naepelt@googlemail.com>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Franziska Naepelt <franziska.naepelt@gmail.com>,
        Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
        Linux Kernel Janitors <kernel-janitors@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto: frcypt Fix checkpatch warnings
Message-ID: <ZH8aS-rMMKaxRD50@debian.me>
References: <20230606111042.96855-1-franziska.naepelt@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dC9uVHJs6Xkabe7S"
Content-Disposition: inline
In-Reply-To: <20230606111042.96855-1-franziska.naepelt@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--dC9uVHJs6Xkabe7S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Also Cc: linux-spdx list and original author mentioned in the license
boilerplate]

On Tue, Jun 06, 2023 at 01:10:42PM +0200, Franziska Naepelt wrote:
> The following checkpatch warnings have been fixed:
> - WARNING: Missing or malformed SPDX-License-Identifier tag
> - WARNING: Block comments use a trailing */ on a separate line

Two different logical changes in a patch - please break them into a
2-patch series, with each patch do one job. And please write the patch
description in imperative mood instead (e.g. "Do foo").

> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /* FCrypt encryption algorithm
>   *
>   * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.

NAK!

There is also BSD 3-clause boilerplate (from original code that fcrypt.c
is based on). Thus, the proper SPDX tag should have been:

```
// SPDX-License-Identifier: GPL-2.0-or-later AND BSD-3-Clause
```

And please also delete the boilerplate.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--dC9uVHJs6Xkabe7S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH8aSAAKCRD2uYlJVVFO
o+5nAQDtfVmY2eW2DPOLirsfAmVGuQiWkV0+NL/MsYP9RNXafwD/ZPj7b2dzkhai
PZb6kQJeq9muOKeXuk5Bf4e3ZxhizAI=
=p0tN
-----END PGP SIGNATURE-----

--dC9uVHJs6Xkabe7S--
