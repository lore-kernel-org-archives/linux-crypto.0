Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23E7C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 11:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiA1Lfy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 06:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiA1Lfx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 06:35:53 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554B7C061714
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 03:35:53 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w25so8420278edt.7
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 03:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vZoYuOKN8ZxRwApGpCT8Q4WFjzDm6PlyuG25G9djrBU=;
        b=nyZVAvbTCGoike0rl6LA5yxyB9QSgYDc8ra0suCmcnuZlwIuJAk5yu/XlLnLSBj800
         e5bOECrE9HhgRAdFxbyD6cyU+aDY7vdl2XlQTgXuUkXbrQibBbnH4+EIS7KdcbhPeRgI
         IqUHCNb6Q3Id2nRHM374WrtFinZcdlAXsYDOmds7IzladstPSdPiAuu2oo1ZWib6/oy5
         R3qrgLplsOMDO4lRgH3IB+UaOIKy5I9hySIviIoxtDuKQ4Kb+qIfKe+9OAcowvbYRX6x
         yfLet3IReiYEpzKrGiUaAYwAFloKVCMBxb5lZDoWJAuZywfZfJJ001G6+PgbZTwYebTk
         Bdjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vZoYuOKN8ZxRwApGpCT8Q4WFjzDm6PlyuG25G9djrBU=;
        b=qk+Hng5seHDVlwvgnpVC4vCGGxeDSVRm9cowP/Y9PoqOQEa+tqK9kOoUQ4+6NtLzjv
         A5W3Ne8MpkjRFBr3KdKyHzg2d8/UZgUrAc9dynHPFxx1F+4n4rx60ddEhe+6Zd1AhP6y
         h1Qt9pc5YIkCzxJunVVtfnrzMkAxPfE6lc0jD5/S5RJwd1TLvxwDEQGdwMmIgjt2md5L
         z3r+SNhcjzKn9dgThzSidZQQ0NDf8aqAVUTgi482/hC9VIDb0pe9iwSEAeUEqp18LLvC
         LepP938TAJsBHzARrjPvMSfXptjK+7kvaOKfyorRxcThiVDsQRG7PIA6S7L5k9MLq4BB
         y6dQ==
X-Gm-Message-State: AOAM530kO9npE829Qh5qu0nqgR033t73f3eyWOapyWF17qsuOdr63Qmw
        m4WUtR0nQqaBZ9TObNx+qkaX4AzJ2BWOfD2IK6XDdKFMqjoAiA==
X-Google-Smtp-Source: ABdhPJzpoccbHi3xmfV4Saf0vidQMK8Uv5w6RL1cMXepvdJC0KAovDgXz+s6LG1KZLPYJtwmGuKSA9gp6Bh60APuiHI=
X-Received: by 2002:a05:6402:518e:: with SMTP id q14mr7645353edd.155.1643369751666;
 Fri, 28 Jan 2022 03:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
In-Reply-To: <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 28 Jan 2022 08:35:40 -0300
Message-ID: <CAOMZO5Cdz7Q89UoEJ=97+QD9BVkFrTpd0e=j_kpjQCDRX64=vQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Fri, Jan 28, 2022 at 4:44 AM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:

> What parts exactly?
> Anything besides i.MX6 SX, S/DL?

I see it on i.MX6SX, but in this report, it is mentioned i.MX6D:
https://www.spinics.net/lists/linux-crypto/msg52319.html

Lucas always saw it on i.MX6D:
https://linuxlists.cc/l/4/linux-crypto/t/3843436/caam_rng_trouble

> We've been in contact with Fabio and we're working on a solution.
> Now I realize the list hasn't been Cc-ed - sorry for the confusion
> and for not providing an explicit Nack.

Varun on Cc said he would work on a proper solution as he was able to
reproduce it.

Any progress, Varun?

Thanks
