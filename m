Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B05C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jun 2022 01:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiFXBxK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiFXBxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 21:53:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D31B2AC7A
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 18:53:07 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k127so1241971pfd.10
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 18:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YbzzHcMwoB9A4qb0bxOEME0h6FTH87qos3732jTjiHc=;
        b=yvDGQokLmq1ntk6WuWz76IQEi+sx6FL2wERQwAQkVbZndyMjoqSBeO0j4Mikb+j51m
         ZWS73/EPrbSp7uBFwMy/0SFO/QSHN2z92yaW1rBprZCxyIUN75xh/4RuzuXlETxOxkcP
         8m4dS2hXHGB5XQWGh9x81E/HiE+pUEJL4m6N4Kfy96GifnwB2Wbd7qEl75PTdZz2Yx2/
         Hdhq2bNpsVRFykvdjT4MpKLaTpvq1Lpgz4Zpdva/fRXt/EQZ58CyH6yOY6ezJuViWIms
         BmC2kH7dqXp6zisZwE61AIY8GlyUx3RLByad2GKwZLzEIixG0MANUZBxE9KHhv6lf1zK
         Fa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YbzzHcMwoB9A4qb0bxOEME0h6FTH87qos3732jTjiHc=;
        b=69uVhdazdLZI4l/FIzAqF5oKKm0nQy4KLaUdd4ZBVR+M3rN+RebuSFfk6V0/qswa3d
         zOKIyBsjSp7T2RVrAZiD38o2EcNgGffT3Pmq2eqyD/QqumIfZPADYTnxh0OzudOz6/ZJ
         x4J1bu0r6NA5XBmcbloHToAHaNVwEDGJSdQJcj/uPnMIbJwXyTSywJaTIiiolNVP9D8G
         d0m8BhwdGfVUvZXohZcajuJS3Edf5dQPdYzhaoW8kLJnmJJmteBxAy0VP0cEtwUCzP0L
         gGKuc+iK6JmqbXN5K6+XsAHYUxGXNyWN/+OlAJvJx35DJC979hGTZScbZbss6ZyfIriM
         bv4Q==
X-Gm-Message-State: AJIora+gdCMBC/EQdjBSzDwtUpxmKicJdD9Lq8txR1KhJKPfoPdxc1UW
        YQepFsRgtJXCuaccHyRzrmAgiA==
X-Google-Smtp-Source: AGRyM1s5z/kz3pqEvC8FBcC2VjlszNEzTxIoeozQ6KuHP60KqBV0JtNdjKPCFwpAobh+y7IPXMGAXg==
X-Received: by 2002:a63:88c3:0:b0:40d:5f26:bfa8 with SMTP id l186-20020a6388c3000000b0040d5f26bfa8mr3914138pgd.608.1656035587095;
        Thu, 23 Jun 2022 18:53:07 -0700 (PDT)
Received: from ?IPv6:fdbd:ff1:ce00:422:789e:9b27:74d9:5af1? ([2404:9dc0:cd01::20])
        by smtp.gmail.com with ESMTPSA id je20-20020a170903265400b00161f9e72233sm434651plb.261.2022.06.23.18.53.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 18:53:06 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: PING: [PATCH] crypto: testmgr - fix version number of RSA tests
From:   =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
In-Reply-To: <20220615091317.36995-1-helei.sig11@bytedance.com>
Date:   Fri, 24 Jun 2022 09:53:02 +0800
Cc:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>,
        pizhenwei@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0610F5ED-98B5-49AD-9D58-4D5960EFB3A8@bytedance.com>
References: <20220615091317.36995-1-helei.sig11@bytedance.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PING=EF=BC=81

> On Jun 15, 2022, at 5:13 PM, Lei He <helei.sig11@bytedance.com> wrote:
>=20
> From: lei he <helei.sig11@bytedance.com>
>=20
> According to PKCS#1 standard, the 'otherPrimeInfos' field contains
> the information for the additional primes r_3, ..., r_u, in order.
> It shall be omitted if the version is 0 and shall contain at least
> one instance of OtherPrimeInfo if the version is 1, see:
> 	https://www.rfc-editor.org/rfc/rfc3447#page-44
>=20
> Replace the version number '1' with 0, otherwise, some drivers may
> not pass the run-time tests.
>=20
> Signed-off-by: lei he <helei.sig11@bytedance.com>
> ---
> crypto/testmgr.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 4d7449fc6a65..d57f24b906f1 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -186,7 +186,7 @@ static const struct akcipher_testvec =
rsa_tv_template[] =3D {
> #ifndef CONFIG_CRYPTO_FIPS
> 	.key =3D
> 	"\x30\x81\x9A" /* sequence of 154 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
> 	"\x02\x41" /* modulus - integer of 65 bytes */
> 	=
"\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
> 	=
"\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
> @@ -216,7 +216,7 @@ static const struct akcipher_testvec =
rsa_tv_template[] =3D {
> 	}, {
> 	.key =3D
> 	"\x30\x82\x01\x1D" /* sequence of 285 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
> 	"\x02\x81\x81" /* modulus - integer of 129 bytes */
> 	=
"\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
> 	=
"\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
> @@ -260,7 +260,7 @@ static const struct akcipher_testvec =
rsa_tv_template[] =3D {
> #endif
> 	.key =3D
> 	"\x30\x82\x02\x20" /* sequence of 544 bytes */
> -	"\x02\x01\x01" /* version - integer of 1 byte */
> +	"\x02\x01\x00" /* version - integer of 1 byte */
> 	"\x02\x82\x01\x01\x00" /* modulus - integer of 256 bytes */
> 	=
"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
> 	=
"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
> --=20
> 2.20.1
>=20

