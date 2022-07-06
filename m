Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CB5C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 15:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiGFPax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiGFPaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 11:30:52 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6901EC49
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 08:30:49 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id g26so27752233ejb.5
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 08:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=twk/vXD658q3DjxcLi4Lro4RHohe+e+xW9Ig0mF20Ic=;
        b=tn4E17FpyxAzh28FjxWYAIUnaLM3sbHCHNgzOzFUbt5C2gNWMrU9bdcGtwBIUgotUi
         I44J7lM37uj+6+IP7EiAxt5PkpV91SUWOt1W98Clpo6agzlFJ/SlwqaB1vNwrsghDZWL
         7Mh60/HJNfiRcNVIij4/qclUe+ZsVqqsyC00bThZlmIzWc/KzwI+7/o3diP8epe9xZ88
         lFGmNQA7AqxOeh+U2UBcwJNYJUsAIjxZkVx6/Ttzycpt5SpcIiweAOOalETGvaYHJbe5
         s1uiCc3wRqpNkzN2uvQrG4kXEPXS4dB7OXNfTRRgMrwxw1Ma23U9I30COkjcd6uyBE2u
         gAMQ==
X-Gm-Message-State: AJIora9EiZxy7GbYlIYN0or5LAR4KdaJnr2lvddkDrtHqNGorHb+VMYJ
        Xt5bLG4UrskaCz3fl3qoFfQ=
X-Google-Smtp-Source: AGRyM1s47pKNLQhu6GTSdZ21h5M0mXUmoiq3LO9tZW06jpqH+jjNcU47uhy3eKCmkg4G3bZ3qtCSPg==
X-Received: by 2002:a17:907:7287:b0:726:c82f:f1bf with SMTP id dt7-20020a170907728700b00726c82ff1bfmr40330874ejc.284.1657121448251;
        Wed, 06 Jul 2022 08:30:48 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id s11-20020aa7cb0b000000b00438ac12d6b9sm14234087edt.52.2022.07.06.08.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:30:47 -0700 (PDT)
Date:   Wed, 6 Jul 2022 08:30:45 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: Re: [PATCH] crypto: vmx - Fix warning on p8_ghash_alg
Message-ID: <YsWqpe9LZYOE4cpK@gmail.com>
References: <Yr1axU+N4Gr90VuN@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZJACidZoklMdi72p"
Content-Disposition: inline
In-Reply-To: <Yr1axU+N4Gr90VuN@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--ZJACidZoklMdi72p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 30, 2022 at 04:11:49PM +0800, Herbert Xu wrote:
> The compiler complains that p8_ghash_alg isn't declared which is
> because the header file aesp8-ppc.h isn't included in ghash.c.
> This patch fixes the warning.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Breno Leitao <leitao@debian.org>

--ZJACidZoklMdi72p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEErIU5puj0ZwLKSkObNaOTn/x4d20FAmLFqqUACgkQNaOTn/x4
d20CXBAAim5F72rBeHqeD/BcS+0Am3RgYAJ9oURr+rgmyRDSTK8TgxPHPqz8uDDX
L3fWDD1K6ClY4TSfmJbAyPQCXubG63As0bmOIkiHwRk/6r+HpYVyujg1IFQJPngc
2xhPqRpQ/dZNONgXSfLgRpOD22LDB4YK85k1fgFdZk7Sx4zUdwTBEMMb2LcHQtVE
5tg/USmkfXQFsn7JGLBkIf6hkmhhEwmw6AIsNh2OIsCA/E8OUNwCw2lHqWQ6LZ8E
1YXA2D1TDYJ2hx0kTuI+zrBSCpLy+58A+iyt5ysef1ibZ3h8AMohGI86FyyH39JB
zWulzIrUAGmeG2g5Kb2p7t4kvd2LdjznVaJVGNmWdDfwenjo90lRFdLqnq4vMFYR
zcsopd8oqhJDPkcHI1L1FvBStuRAqixoNXcHp8bhGwxMMuqhzKEqYkizkKwmrrMj
yms44oKBPTsU0K50mg/+/7DI+8LGjg8zWhmuTZaGUcpp300H657BQgJNdBCRCVXQ
Z0E+F8L0ICwCRnQkNgsA+HcgjtajmyjOkaCGYGyMw3/j4kq8fTIv2zMDY/rL/XTl
FM1/z2Cz3KB1axaa8Gtdb3J57icUOWuk+iC5TzXKzwyRgpnNx9Bsw3aNdUIca7On
eD+YZdVOrgc5UC8B17DnWHIi5nkSb2fa+oeIwD5tqpeN+WfV2l0=
=/cBn
-----END PGP SIGNATURE-----

--ZJACidZoklMdi72p--
