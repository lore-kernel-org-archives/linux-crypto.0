Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A99C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 05:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05B5D2089E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 05:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbfHAFrJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 01:47:09 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:54614 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728413AbfHAFrJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 01:47:09 -0400
Received: from mr3.cc.vt.edu (mr3.cc.vt.edu [IPv6:2607:b400:92:8500:0:7f:b804:6b0a])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x715l80b021433
        for <linux-crypto@vger.kernel.org>; Thu, 1 Aug 2019 01:47:08 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr3.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x715l3co011407
        for <linux-crypto@vger.kernel.org>; Thu, 1 Aug 2019 01:47:08 -0400
Received: by mail-qk1-f197.google.com with SMTP id t124so60313068qkh.3
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 22:47:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=BIaC2b1UDZwx7XdDPFY2TgT2duJrjp+VXdWjaLmhw8w=;
        b=JP0U28RPijT4AlZQ5v+FPNI0epAAhlTj2HHGPbDN4uS3RZIVcwU/82X1sdLstMYoJS
         PF9AL4e/8CewVyVLyOixTk+0maZigxmQWSLbJEI2bxGRaV6HZhDktfxkoHU1HAI0aFfk
         D1fJRULSNMoXRgTY7coU4bApcqsVaKI3PLLmoOpnYQkNP6YZomyKN605DEPd94d0/iHX
         LUfzFwlybMFgmNaW7N9JD5MaFQHI3RyHAE4fDViaCgrH/icwo82Vhl3JYdoMJ7Crrcxt
         Q3AsPUF3Mk4CXrXow91XYExw90hPi9tfHhCbzHRvHab6rnCWFgLqP4sR9oiv8ZLHRuHi
         f+TQ==
X-Gm-Message-State: APjAAAV9WspYmfnaDAQnfn6snIYgA3JS6U6vam1hA4MXf1+/mA0jX2vE
        dKIsNhm43Pg4Tfw315U5/0fhGcvcfKHjeNCx/SD2uH8hNILKrVOPK6c1TmMTFaMEegDShR/i4yA
        05q2dyP/q/4fMkHZQU2PARu9sz/SilP4gXg8=
X-Received: by 2002:aed:2063:: with SMTP id 90mr88113273qta.307.1564638422885;
        Wed, 31 Jul 2019 22:47:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwqF8ICZoH1tmAtHtEl5W8KWHLigjNPdoAD+HRUxmAy600psn7iIO6Ig+RDac8NonQMyb/M9g==
X-Received: by 2002:aed:2063:: with SMTP id 90mr88113248qta.307.1564638422508;
        Wed, 31 Jul 2019 22:47:02 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::7ca])
        by smtp.gmail.com with ESMTPSA id x24sm29653893qts.63.2019.07.31.22.47.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 22:47:00 -0700 (PDT)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux-next 20190731 - aegis128-core.c fails to build
In-Reply-To: <CAKv+Gu8EF3R05hLWHh7mgbgkUyzBwELctdVvSFMq+6Crw6Tf4A@mail.gmail.com>
References: <13353.1564635114@turing-police>
 <CAKv+Gu8EF3R05hLWHh7mgbgkUyzBwELctdVvSFMq+6Crw6Tf4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1564638419_11794P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Aug 2019 01:46:59 -0400
Message-ID: <32521.1564638419@turing-police>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--==_Exmh_1564638419_11794P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Aug 2019 08:01:54 +0300, Ard Biesheuvel said:

> > ERROR: "crypto_aegis128_decrypt_chunk_simd" [crypto/aegis128.ko] undefined!
> > ERROR: "crypto_aegis128_update_simd" [crypto/aegis128.ko] undefined!
> > ERROR: "crypto_aegis128_encrypt_chunk_simd" [crypto/aegis128.ko] undefined!
> > make[1]: *** [scripts/Makefile.modpost:105: modules-modpost] Error 1
> > make: *** [Makefile:1299: modules] Error 2

> Which compiler version are you using? All references to the
> crypt_aegis128_xx_simd() routines should disappear if
> CONFIG_CRYPTO_AEGIS128_SIMD is not set (in which case have_simd will
> always be false and so the compiler should optimize away those calls).

gcc 9.1.1 obviously doesn't think it can be optimized away. Apparently, it's
not smart enough to realize that nothing sets have_simd in any of the functions
and therefor it's guaranteed to be zero, and  it can do dead code optimization
based on that.

Now, if we had something like:

#ifdef CONFIG_CRYPTO_AEGIS_128_SIMD
static bool have_simd;
#else
#define have_simd (0)
#endif

then that should be enough to tell the compiler it can optimize it away, except
that then runs into problems here:

        if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))
                have_simd = crypto_aegis128_have_simd();

because it will whine about the lack of an lvalue before it optimizes the assignment away...

--==_Exmh_1564638419_11794P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXUJ80gdmEQWDXROgAQLkHg/9ECez7dCQZUrkvB9XBkF4GXqXZEAzg9q3
YhNm4yxBbGrfk2bP8sQMGnrDMMyXnWjRYT5vEzwCqaTTqYSYmEOLsppDpgqLzSf4
wiS59VQaD4/rcyfiUaUpu1yPOV4yFt1C1jA9Y0edRknZ3OItKOxip6WpPG1M2DqQ
25aBzrl0fcNg40vWBQdV+dioh2IcDrhxflKkVZUITiT5/C5wUDFtogS4aEizS6Kn
Xl2sU918ll1k+C5xO9i6OvAxBwSGPuiZBZV1GVe+UtaBGUCLnY6E3p44DMZzBvQ1
8U/8FcTvX0w88vAjdYgOIj+tRG4djgn6qyVxCht94/C8oWGVIffHxsbdu+7W1/vO
6bYwHOKVPt/3Tf8NV8mB42hzSelZ7Ni7T31oTckWQKUcPUMa98PIIU9f+MYSEmzM
n4sLoNtF/8ea61ndWxpheVfxtuaimW3WST7Vx6lIxH8rN7FrRhnPe3VWclIVLBJh
CUJZftTdnZw2VDg+oKLm+XKPfECdxIhAcjrnQsB7pm5Z88cCBq70cwmCbevPJo2A
g9IRpfYumr57CpiDyvJXDdBn/5l1I2FQ8M3gAU/wyuZhFWGCSZ8QD0M6G8Zbap38
qMmtMPCdluP8neXGpmHJRS/s6s40h1XLoXvpNt6czyHVz4DUqujFtFdzF9BVCH++
GyQPMZBDIBE=
=bIND
-----END PGP SIGNATURE-----

--==_Exmh_1564638419_11794P--
