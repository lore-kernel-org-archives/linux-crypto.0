Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85ADC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B158464F4D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhCDAHM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843068AbhCCKZM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 05:25:12 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE55C0698E4;
        Wed,  3 Mar 2021 01:29:05 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l22so4565426wme.1;
        Wed, 03 Mar 2021 01:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KtYq1HpTP4qG/Z06G3RGzOfRpApu9Eyff7VBR8UtufM=;
        b=iOmmLlLg/Gob/PMma78QYCpMSid4zLKb1asO3y15tjAzdE9yf9GfdHDCxIgp/2XQyd
         lf36YKZ09D+DkKBJMriB+O6ppxh92EDMldkwYoYxYqKcFTnz5yaR0UQrv4ZBTukL0SiO
         HKbJwe4A4nSq4FsOR5LmM0FIoV/cfcCQ5orjSJHwAg1xLSaVWEHZ3EzuTpzqY6vtZWJF
         ocGMZJdtFoimBk2Yji2qcADR36xGTYYp7xTE7LoCuvuieOILU95XSa63n+He0W/LuoOI
         kFTdKwfjq7Z47kMv7V9bT0t82Ba+Hrc7M7QWF0LZWvyt7+2dzVaN/nfUtSsvHyabU/OB
         vZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KtYq1HpTP4qG/Z06G3RGzOfRpApu9Eyff7VBR8UtufM=;
        b=WF4n4tgTBAPk9UvD2VrfpC/RVQGpMa8kzItiKjdvKsJS+fS0lA/LViNlPkSUDCNQ+5
         K7/hJd1OWARc+IYdsKkBzWWrxVzhpeMbeMs6Q94hGBH7buYGRVfuc+EhfDegJZGXXktW
         Jss2qdQPf+NToY5qPkrS4XsKwEikl9vUcNlouDYjaMt94df7BlvwhKfuGB6MC+hFUgdV
         IcwgaNDWSyoDgHCHmb2NRop8xTETZ65Y5RA+S2QvErxkXrDU12Ewj/7+rcL/iH8f+jZf
         n5+e9Eke66m7449WgV9N5IZU63QLggAsBjgfO9KoyAFXCdP1eLuPSPjVU1XwZBrpt+OT
         nqVw==
X-Gm-Message-State: AOAM533moz0a+06GbUd0x5G39M1H0lT+4W6Pppe2Y92/Bmi9EPghkhvO
        A5BfazUQAEgaUBPVtExb1qQ=
X-Google-Smtp-Source: ABdhPJwgxJXWk89e2L4A2Xtp6aMebx3SL+bnYSRlPl07xQAykbvm0TseDj8JNeJ6ozF3qoINBKytmw==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr8132965wml.44.1614763744509;
        Wed, 03 Mar 2021 01:29:04 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id v9sm31780266wrn.86.2021.03.03.01.29.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 01:29:04 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <20210303092019.GB8134@gondor.apana.org.au>
Date:   Wed, 3 Mar 2021 10:29:02 +0100
Cc:     Andrew Lunn <andrew@lunn.ch>, Matt Mackall <mpm@selenic.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Content-Transfer-Encoding: quoted-printable
Message-Id: <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch> <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
 <20210303092019.GB8134@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

> El 3 mar 2021, a las 10:20, Herbert Xu <herbert@gondor.apana.org.au> =
escribi=C3=B3:
>=20
> On Sat, Feb 20, 2021 at 08:12:45PM +0100, =C3=81lvaro Fern=C3=A1ndez =
Rojas wrote:
>>=20
>> I ran rngtest and this is what I got:
>=20
> This is meaningless except for sources that have not been whitened.
>=20
> Your justification needs to be based on what the hardware does or
> is documented to do.

Ok, so I guess that we=E2=80=99re never setting that value to anything =
since there=E2=80=99s no public documentation about that =C2=AF\_(=E3=83=84=
)_/=C2=AF.

>=20
> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Best regards,
=C3=81lvaro.=
