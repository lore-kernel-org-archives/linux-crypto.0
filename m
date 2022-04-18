Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8846FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 15:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345350AbiDRPdd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 11:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345392AbiDRPdU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 11:33:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2802E0BB
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 07:48:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id ck12so5716356ejb.4
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 07:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QJF5NLazMdZiYijDB/GkPcRRJT2Ju4iv+5YKOlzKGzg=;
        b=ikUFd603oW6xtW2KWShcA2IbR09Lt1JYhhP0gBwxSxA7ROWJdn/UCzAjdQoU633KOZ
         ph/WntExdGsbsPXieAIakc0lpvLbPA7ijfWzMZOrlUbiipfcCFJ5WKttSOa9UUXX459u
         Z6F65Nrthh9BreKWUoyiDSw1JcuzghZSf+ysQvyLX04gVci10/IktTKIeij4ReZGGNOp
         cp6KhrvYBPdUTZ7n9MGOh+uxf5klAjLp1HTijtaNb16Sszq8OHjxJM/3zGZFgskPKabn
         1kuhBV/6wejC9xh2do+Kr0wJdeUZvMlAILhJvE0EyNNCMMKCtuAUmaJ5LTgh+iuze4iw
         p+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QJF5NLazMdZiYijDB/GkPcRRJT2Ju4iv+5YKOlzKGzg=;
        b=ngpXTiYmlOcIZym0UwappeJmr1XAuNMZTWK7FfMTCFobjifr9kyQDUxlCYZR7ISp6f
         QcDRVpqUBE1eKDPPGWxiQ4XoxvGUWt+jpyPxYlLSZtR/eX7q2gtb+N88LyUTpKAo7E0g
         OBCHUwia3rb0EEJ5iTM2QBeFShQjffX7j3BoGpGLREa2oHbxRBVu4PKnL7L8NLpw2Xp+
         Z+/YvH3Q+pD4vyXp43i0zVh9qH3wOYUbNWuW53hRnE+YH6Mw+cIYRn72oCCLsW2tD9g9
         Vgt6v/SXG1CzolQSmZAQZfoj1Zf1NnjLLjGgmwPxZD6TOLjh87dbFEDi9msUgMFedVIc
         N0gw==
X-Gm-Message-State: AOAM533J38kj85gCaKyi4q1RUJjc0ls2J75R7YNP5ZUzsZIQauNGDxdw
        CVKTjCVIcBJZAxHC5CIQJ1xX9lsd64HjcQJRpcJwiiv6
X-Google-Smtp-Source: ABdhPJwTovIn5Oxaw9ImtRR9hSiO0e+JJJuRrtlwb8O1uzaOmiUTNL4USETxgOCL3yI8HyKd2S+IkGlv20z2ZIsT0T8=
X-Received: by 2002:a17:907:7b9d:b0:6df:fb8f:fe82 with SMTP id
 ne29-20020a1709077b9d00b006dffb8ffe82mr9359637ejc.652.1650293279590; Mon, 18
 Apr 2022 07:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220416135412.4109213-1-festevam@gmail.com> <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
 <fc7885ef-1771-b047-699b-517c7f015c9b@nxp.com>
In-Reply-To: <fc7885ef-1771-b047-699b-517c7f015c9b@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 18 Apr 2022 11:47:48 -0300
Message-ID: <CAOMZO5A9HpLvt4_wHx+Agutc=aWM-aDkLiNoEj3MzNGrU6DVng@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 18, 2022 at 11:43 AM Horia Geant=C4=83 <horia.geanta@nxp.com> w=
rote:

> Someone will need to check whether this solves the issue on i.MX6D,
> the root cause might be different.
>
> Besides this, as Varun said, we should check with the HW team,
> such that the value used for entropy delay is optimal.
> IOW we need TRNG characterization for i.MX6D.

Let's focus on the i.MX6SX for now then.

Please check v3 of the patch that I sent today.
