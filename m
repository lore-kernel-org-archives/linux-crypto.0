Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129CFC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 19:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34652083D
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 19:29:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eb6ymmbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfBYT3C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 14:29:02 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41813 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfBYT3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 14:29:02 -0500
Received: by mail-ot1-f68.google.com with SMTP id t7so8871710otk.8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Feb 2019 11:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJilMqWf/gD0dHb936/E+CrdNR9SmkQ/zdhDKmWVW9Q=;
        b=eb6ymmbMFNhrKBWf9Jhfy7o6I3H4PcP2fO8HFRbTVlk45ZFrR/02Fpw1S7opQrzjEN
         bACqNjI49UgA9J9IvsvmMJMRu/ZPfW2EVRVxw0SbbB8AiQCAZCuFGJCB6jvTD8S9h+Fc
         lhzN6d7Wf79dUIwbL2iA39gstv/gliir0gd2jLss2hHUy60oFIiMtFfb5++hwoUW2s47
         fKEt8sE3W5b4oB5L/X2sZU/hK4JVRvF11IDwHNuCbemcrBjip0DqFY8qW0Wdm+Cwx5GP
         xGWLsuzoajXmhWJbYKcDmYxI2hq1Ui9SUTAr86b2R2AKEY/pHSQRyKiB8Jp+u7qoMHrh
         wnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJilMqWf/gD0dHb936/E+CrdNR9SmkQ/zdhDKmWVW9Q=;
        b=ZpmADI9d8/2saZZpifMiOvaT57WVnuL48lLFLqoQCk/pJ2aqHE28e4LWOyOMzUehCc
         xyDdazLha7nhOjHf2zqJHVSxrcStQfroSR3lLYLMUzm2UtOjswdWP+c44uiRxAdCQH3T
         R8u+AmMyJjAO0TVPRWed4sKLTh9otKYTuY3wTfLouHqZKDx24AIQ+gwvHDyR/QmtSJIg
         jOORo0uINQG1V3WDtb7aSzjskas6gap9UqShGLW4pUpxZF2GVoVmu3L5nSzo5VWU4ZV3
         5x68dFssrcs5z2ZN6DeX3+LtkDeqo719zAFEczQC3Br5+8iKSJA+m1N9vhldNqYp+/9P
         7QOg==
X-Gm-Message-State: AHQUAuaCjLyTel1+aldwooiXnKKQDjbHleZ+lFRPTg8pO2YoPmoRdeJY
        0QyhHJp1n5NGW0VlGirZjtqjI1l/bTIovTq7W+0=
X-Google-Smtp-Source: AHgI3IYdPgnwaaWmGEqE0WXL7fZ2+jL4qqUrxnngcJmfLIw1KeoV5PaBMgjzAY6Qt14CKynEwM7+EqFS38PFRwAI1TU=
X-Received: by 2002:a9d:e92:: with SMTP id 18mr13239364otj.134.1551122940924;
 Mon, 25 Feb 2019 11:29:00 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <VI1PR0402MB348578FE91831D11CDCC91D5987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAGUNXRTe_G91TN-3qP-TAACB6kLXgJn-on5VGCJWbMqrv+rBWw@mail.gmail.com>
In-Reply-To: <CAGUNXRTe_G91TN-3qP-TAACB6kLXgJn-on5VGCJWbMqrv+rBWw@mail.gmail.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Mon, 25 Feb 2019 19:28:49 +0000
Message-ID: <CAGUNXRSZRMj_DeMnV=4fKeqNKFaDhVeYJkZfE5T1yivVsz7APA@mail.gmail.com>
Subject: Re: [RFC 0/4] crypto: caam - Add i.MX8MQ support
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 Feb 2019 at 14:17, Chris Spencer <spencercw@gmail.com> wrote:
> On Mon, 25 Feb 2019 at 14:03, Horia Geanta <horia.geanta@nxp.com> wrote:
> > The code looks *very* similar to what was developed by NXP.
> > Why have you stripped off the S-O-Bs?
>
> Hi Horia,
>
> Apologies, I was struggling to find any guidance about what to do with
> the tags when upstreaming changes. I will add them in the next
> version.
>
> Thanks,
> Chris

Horia,

Just want to clear this up a bit to make sure I'm doing the right
thing (this is my first kernel patch so forgive my missteps). These
are the origins of the patches and the SOBs I will add:

2/4 is based entirely on [1], except I have only applied the changes
relevant to the i.MX8MQ. I will add:
Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>

3/4 is an amalgamation of [2], [3] and [4], as well as a fix of my own
(in the downstream version of pdb.h, rsa_priv_f2_pdb and
rsa_priv_f3_pdb use dma_addr_t which causes a test failure; they
should be using caam_dma_addr_t). I will add:
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>

4/4 is an amalgamation of [5], [6] and [7], lightly modified to drop
the i.MX8Q bits. I will add:
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>

It's not really clear to me what the From address should be. They are
all under my name in my repo, but the changes are almost entirely
based on those authored by NXP, so I'm not sure whether that's
ok/correct.

Thanks,
Chris

[1] MLK-15473-1: crypto: caam: Add CAAM driver support for iMX8 soc family
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=afa53c2c96a54b4432a26372e3b5e7dbccbb9671
[2] MLK-18082: crypto: caam: Fix DMA coherency configuration
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=d07274fcddde4258e63edf2a77dc29aef19a0d27
[3] MLK-17233: Fix CAAM pointer size error for i.MX8
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=09a35f4ff6e7a6fb93db6f0b0ec30c1c6c25df34
[4] MLK-18082: crypto: caam: Check ret value of dma_set_mask_and_coherent
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=278d4b127292943eaeb49f23d8a99598ea8954bd
[5] MLK-18082: crypto: caam: Move RNG instantation
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=5fd8fe866172c38e8cd07741d98d79b995f05bc9
[6] MLK-17111-1: crypto: caam: Fix RNG instantiation retry
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=031caf182221da24cd41d4cacf4c81fe1897249f
[7] MLK-17227: crypto: caam: Update CAAM driver verbosity while RNG init
https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam?h=imx_4.14.78_1.0.0_ga&id=bc328d847a575082472d7aebbfe0610c5adde32a
