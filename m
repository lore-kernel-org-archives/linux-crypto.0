Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF903C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 06:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D16564F4C
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 06:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCEG0e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 01:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCEG0d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 01:26:33 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF37AC061574;
        Thu,  4 Mar 2021 22:26:32 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o2so417148wme.5;
        Thu, 04 Mar 2021 22:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NNNoVrG5d7tOM41mvwYb60m8dYDHF6mZjSC7fCCIN1A=;
        b=Dm/OS2p4akwEji3N23M8kqsSx89IRPazBAgfT1S8RhLIGtWAGCRGwXPjPp2bB4hPYx
         AQKRV92rdvMIRXFGCQPw/HMlORVGbMVKjTRCVFaXJ7h71q6xqdjRvF59tKNUtSfWkIPh
         1vZ+l8ZLX24504HMOeTPFfh9vgNJNfHnL1wmqt+QizK0oOyLIE3RCHO93LEXWEFfmYGA
         UCoV9wZ8pGtXKXYyI/m3pErwsypP/5VbRXs4ho6m4On1upzL3Y30pDgRocAy45b1bTr0
         WJnIAY+gIEf84+r1ZU7AzyS6e1fz9XHv+G4VKXT3qmtUFZQK/TJq+DLJei95Ji04ohBF
         4J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NNNoVrG5d7tOM41mvwYb60m8dYDHF6mZjSC7fCCIN1A=;
        b=Hq5XnIa0tY+Uq47JsbQ3h24U3ZQ93mer34TmNmzSKxgsjFZMrYYk+QGMQEsCgnDidZ
         E5P65pFtvsHrxQOHxP+jVbSle2c2W/9P/d5Mt4qO9uiwMKH5/YPN7hIf3Pg4QQUTjPgv
         r8w+X9vwRW/8n+CwFBTC+pMlVjzIrmOw7jlnqzyGO79Bibjn1+9jIKucwAe+xXYiRWDl
         wn18+1lsUr+S1u1gpRC0WmqZkclMv4xuPOzJhGzjknXMbcMS43V6BCHwnWBz3QB1ppgu
         BLjUMTfj4hsJtbVoC6uYAhowUB5jNHb3z4Lwgb97RzqkOKcITfwq4qoffG96g5ULLprM
         uVdg==
X-Gm-Message-State: AOAM53008aLbUtleQHpBVrMWojFrKDpes7Pr6GkkQW0kOYvZ846cINTA
        haX6nSCL3d72D0Tp1zFiP9g=
X-Google-Smtp-Source: ABdhPJxPzDs6HeUpfqwXJ7krgAyG4WR5WyH9O4SZwe4iqskvtgG5yPgiivWaJBtlfdCHuau9C4UDrg==
X-Received: by 2002:a1c:df8a:: with SMTP id w132mr7112323wmg.53.1614925591409;
        Thu, 04 Mar 2021 22:26:31 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id f126sm2796782wmf.17.2021.03.04.22.26.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Mar 2021 22:26:31 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <b0cf1be0-4c7c-57ee-fea5-789fe215b85d@gmail.com>
Date:   Fri, 5 Mar 2021 07:26:29 +0100
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Lunn <andrew@lunn.ch>, Matt Mackall <mpm@selenic.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stijn Tintel <stijn@linux-ipv6.be>, ynezz@true.cz
Content-Transfer-Encoding: quoted-printable
Message-Id: <6D1459DF-A7E1-422C-AA05-655156AEBA23@gmail.com>
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch> <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
 <20210303092019.GB8134@gondor.apana.org.au>
 <66AED5A4-3227-47CA-A4A2-B5AD6A571AAC@gmail.com>
 <c76c82668142710ba5a7a8454759c9aa2423d72f.camel@suse.de>
 <b0cf1be0-4c7c-57ee-fea5-789fe215b85d@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Florian,

> El 4 mar 2021, a las 23:28, Florian Fainelli <f.fainelli@gmail.com> =
escribi=C3=B3:
>=20
> On 3/4/21 7:11 AM, Nicolas Saenz Julienne wrote:
>> On Wed, 2021-03-03 at 10:29 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>>> Hi Herbert,
>>>=20
>>>> El 3 mar 2021, a las 10:20, Herbert Xu =
<herbert@gondor.apana.org.au> escribi=C3=B3:
>>>>=20
>>>> On Sat, Feb 20, 2021 at 08:12:45PM +0100, =C3=81lvaro Fern=C3=A1ndez =
Rojas wrote:
>>>>>=20
>>>>> I ran rngtest and this is what I got:
>>>>=20
>>>> This is meaningless except for sources that have not been whitened.
>>>>=20
>>>> Your justification needs to be based on what the hardware does or
>>>> is documented to do.
>>>=20
>>> Ok, so I guess that we=E2=80=99re never setting that value to =
anything since there=E2=80=99s
>>> no public documentation about that =C2=AF\_(=E3=83=84)_/=C2=AF.
>>=20
>> @Florian, is there a way you might be able to get the official value?
>=20
> I will be looking into the documentation this weekend and let you know
> whether we can change the driver's quality accordingly.

Could you do that for iproc-rng200.c too?

> --=20
> Florian

Best regards,
=C3=81lvaro.=
