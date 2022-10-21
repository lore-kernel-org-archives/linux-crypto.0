Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47FAC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 12:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJUMDT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 08:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJUMDS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 08:03:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C8125F8D0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 05:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666353759;
        bh=7moO+cn/c0IbAogTQnuI3UkG/msrk5zyoqH0Ss0iOY4=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=YgcrovJMOoYKAITqIDQ3c0lLlhPX+TmxzbWQcOZPNUql0hUXs3yKJV5wsm0morh6u
         f4FcL5WrRrLhiiiN5eyqj4ZdZ4Rgx3NrHhSrFqWS45oxn5sp2cPalrc927BFQNie1B
         i8bPLlhfJnoszra/xmib4slTx99RBNRYxjovmMwg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.0.2.15] ([94.31.86.22]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mplc7-1pSvv01THp-00q6nG; Fri, 21
 Oct 2022 14:02:39 +0200
Message-ID: <9d24aab7df6898e4da6d9510cdab8a7bd6323cfc.camel@gmx.de>
Subject: Re: [PATCH 3/6] crypto/realtek: hash algorithms
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Fri, 21 Oct 2022 14:02:37 +0200
In-Reply-To: <Y1J5amO8CWp23Rk7@gondor.apana.org.au>
References: <Y1J5amO8CWp23Rk7@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:ThckU+Wa0N3FvTXPVqpzkHj4Hm2GCsNvD2nuy5XQgEp60JE9lar
 EtTUsQ2ULt3YUZ6d8VOJRVUV2W5SyzoKCEjTmTqVE8PlJFbKyTjknFG0WDjW43Qxn+f/xI2
 FzKno+YjMY96GErtHcMV9PU2a9kFq6rDns+Z3RbSEul8bOPDRcwIwmiBo9marSpACV/uERN
 voGwPmg6NvrH3oDOlEzug==
X-UI-Out-Filterresults: notjunk:1;V03:K0:22iBgbXE53g=:MPO5WVQUWd2829IU1+HtS3
 8xhm/BVUCY2ehNbSiM20HwCG/f28y6dKRL+ZAhRGENJnZBuD55mCWVltRSQ76ZVje+mkW9PQa
 LjzIWhTIsrNwBDJcKHtVvll/hhDwz3cnTXYsRynF0shwRBOmK3v03o+yNgknP3DtsvuviAEQJ
 IFO4pizpi4JsgUSE0QBIN8l1yBdRdmXZdz4i6e12zNtPOm+6oayPUgNlSI9ey/PgewgSs+/aX
 5lUKXhcgePNwaJiOPvhVW+rY51aZDAf+WDB68dGPVvg8rzbd1WfSKCcZvyY4dY/VzElJcjW9L
 G5NfsVVL5nkTtip8wyX2qglqdCnP15RTyVkeOYvGlZuSisTIw8vQcW68dW5FpLE398OsWfwZ4
 kjkqfoqBpCtblOrDdwGXwdUKuegWp15syT+z/YJG9qW1DvGHZRBLHnLfkNnmsu9ppt1is6Oa6
 gDJE7ffjKLo7nX+CkMn41D1i/xu5p01QEzC7nkCcAmeA/UX9DJX29eCajXyt1aTvbQ3Wt2h1P
 /FH816DAR4Wke86gJ1CLx6U7lkdevOczcCpWvLUX9gTvmByOgyOOJVthoDsJM4TeXJTokAtwP
 HCu2GLmvMmtL0aD8QZqbiO5UIzsDFSqDZDWuJUcdZhPz7N18qk0yq4R1Zj2R29k2nuSyPu2Z7
 7tzvulapdHHEVbq5bKrfqHjIcjExL8WhxvVJUzbaqYiBua36StRAz9KxXOXngUyiANYqA+YZa
 guPfFeh1nbLTDLFuXZi2XXHMvYMOIe+ncYYrXDLv2VvAmMaQD+PUMoXydzTpjQikomOvyc4XO
 5wKH5uIbmUGLjDnqpBxvANay6SLsn7QtG+qFR5e1q2NicFu0AY9O57ZX7McjY1jXffn13rJUA
 q4N29uXMpwIUFK4FDYxWw0LlZbrSV79Ww8noA1USdPAe2j+otCdJLESb98Hik2hgy4cwxUB78
 +PqeTVb/RSxF1lZkLdSZSQu0XnFPLAkjkTdKEHMUl8nrLruEw97FY6XBuqLbdhPQ54V73XaVb
 m1qcVX2EEt64e/uF07pDoaOKwWWNcapftB6wjVPi48wiVQS36GcWHffwMQGGSS9/MajX3mhM1
 xBFaz+N7FIwMNPZF/p5KyBMZ7TlFfZyJiefDYZC0qeR2FyQ18KkEb0CumGIEMgl36VE+I8rhl
 jbrdiM3wjvjDQKWDho/bTkV30Sgyt3us5FUzO4xP3/oolD3JEQLZVTtuAUyqhWeH3ZKbHp0X8
 BcpQaGhHpZ9uQRGAfAoHphspDECYU9adl5ZzLvbl+P57HHhftdu2ZCz3D/7/wj8/ga0x4qFoL
 Ygz6uu6/yXd08QugnOLFMUmhbOqL86O17tAfpD/Q09bnl4SAJaxKRZcy4GuxV0+FiB6xmqGRy
 CJy0ohNu6IFZZy6D9gWlTEYdCEeJArysjL+6jNY0dt8lMRZw0wzftnDgSGDfDYfl3NMjEa2eG
 St5qQQKMwVljlw0tKglVlOX6xEDCnFxdEWqQVriERBqyu5KYEFE2u6VM/5OSi7s2zKc4Z8fer
 PClIAlM4BI3Hh2ctFBiSBV3ULL8mGH9BdRQmIXFC8wGXJ
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 21.10.2022 um 18:50 +0800 schrieb Herbert Xu:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rtcr_check_fallback(areq))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return crypto_ahash_import(freq, fexp);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(hreq, hexp, sizeof(struct =
rtcr_ahash_req));
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > +}
>=20
> What happens when you import a fallback export but
> rtcr_check_fallback
> returns false?

Hi Herbert,

rtcr_ahash_export() will always generate a consistent state prior to
export because it calls rtcr_check_fallback() too. So the export state
will be one of the following:

- fallback active flag not set + normal state data=20
- fallback active flag set + fallback state data

Thus said a fallback export will always have the fallback active flag
set. So rtcr_check_fallback() cannot return false in this case.

Best regards.

Markus
