Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD59C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 12:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiDRMoD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 08:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239863AbiDRMiM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 08:38:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBDF2459A
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 05:28:47 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ks6so26614721ejb.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 05:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8qhYfMicAk9wiY5ZT8HYPE/KMpg3STl66Hvdmt4si2o=;
        b=melahjHcVmoJNHNTirsrnTCAnO6N3Hsd+exGZEWvmyykB14AAgxczoQjJCP3ZvjpHB
         4hOh+TDCE2X8p79iVba/K/tUQWbt6fRHTlV0TrJQD9wh33Dc+K3vyQIDVxB2oSJw/7sD
         hcLgAFeoRy0E2Zv3K23YKakp11U7e5zCjpA52gFDNdoITdQc4gM/pcguAj3xcbL1KmCJ
         Yf+bqz2poYdQgdlXzZ7lAAeb2idb3jFH3ht0SzjTLHoHqUu59U4bsLiLNNevhEmI64mV
         XUgQAc5l8QVCy04Q4oUQRC99Pd+X3EwBmceKOD0OHmNx++CCs+y2c3//z9JM/3WZa2pE
         aCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8qhYfMicAk9wiY5ZT8HYPE/KMpg3STl66Hvdmt4si2o=;
        b=S9aNaom/auwc3VZ0rXNprrMqmw/3275FAWWmNWA4ZRw3zGMNVctJovg38r3Wy9kIdU
         CxFjGqJiy4CMRrL+alj4f12LOZORuuTF6xcPaiGm703fN5v2Q2QHnR5kdAzaUMWp+CKM
         hXHrb8FBthZbaTfmfHdWTB60VI04LP6mhuoWgjV+wwYVIMRtFrprKGDiFZ8WzH81tBmA
         YBUAFyz+Y/FYnW8ZAQImDoRXb0R72Cr5On44SPYjuz4ugSugK+sOOvS9Ap8F/ceIP2i6
         2VqzWBx7/khchhmv56Ul4GMIrZ9lOp3r98vBCPDGwqLBBHyzRYEW/w0xPAajsKiARVnk
         AnYw==
X-Gm-Message-State: AOAM532BMuoqVVIsWUYIyVaBiOjkO/IEmjVvn7Cl/UZ6xHo4jCyXGBiL
        IzIjTWUYlTYxQv+L8e/W+lcQo4AJEN7wH1HML0E=
X-Google-Smtp-Source: ABdhPJzfmz/4iB3dsn0YJkp0u1JuHcItOzK/aQA2yAWgrJe7sx1MByreO8NcdxAOucb90jJGgY3k5PseFo4wXX2DRCc=
X-Received: by 2002:a17:907:7f19:b0:6ef:a121:ff36 with SMTP id
 qf25-20020a1709077f1900b006efa121ff36mr4577275ejc.214.1650284926135; Mon, 18
 Apr 2022 05:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220416135412.4109213-1-festevam@gmail.com> <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com> <8f51bb57-8671-5eb0-694c-9134801ab09f@nxp.com>
In-Reply-To: <8f51bb57-8671-5eb0-694c-9134801ab09f@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 18 Apr 2022 09:28:34 -0300
Message-ID: <CAOMZO5BYcH5jHrDf65TH9gtz=tktdRfmLR1AGBX1GeXw9crK3A@mail.gmail.com>
Subject: Re: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Varun Sethi <V.Sethi@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Mon, Apr 18, 2022 at 9:10 AM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:

> The alternative is to merge this patch (btw, please add a Fixes tag)
> and then the DT-based solution would also include its removal.

Sounds good. I have sent a v3 with a Fixes tag.
