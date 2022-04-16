Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56721C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 12:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiDPM1K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 08:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiDPM1J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 08:27:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1078D8F76
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 05:24:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z99so12674754ede.5
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 05:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soyVjYvshFiVG1420PAexBffaJlTwpGP3Ykd3beuH1A=;
        b=eoH3r2mOGG+7+MusHAZ2Dv5OzNLMxlMaBdOL6m4ppdJY769LFh7r+SBe5vmjq4dr06
         xqQ+8OE4j844IBJe+YJAoq5mM19wXpPz5PE684hrqkqeHfFsSiG4YAt3UReessbZ0GAG
         uRWw1gfYE5JMNYJDLtKZ6t29TSKvN+VevrE8pIv1M5oA19hKH86xhBk78STRHmg4pq6I
         +p/grGJBrQvej4CUX+cMqg05MDZyfN7Bgp9MyB1/XimaMT1AC8OO9AWt7OXiMKeUevHw
         i3CjCNACoFPJ9T4ECTpIb6VfQ43z1oWKQ8703YIxYMsEdbi+Jptu6TaxSSVPCDqYMhEy
         PiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soyVjYvshFiVG1420PAexBffaJlTwpGP3Ykd3beuH1A=;
        b=RfVQc+X+ycc9kKB0CVVlFDazsYjjUtuRgwpzqGBcnK8wdlk8IYSt558WHBuNAAZF6K
         sO6I/tVnCQO/B+MT7wB50IBs3GPEl7oQcLekhwL67aJfYWPXe7tojgZEo04Lj+cv1/TK
         xmDwdd8FRB4iClS6m9J8D62vAgTJ1St3eaADHYB681tOi6K8uaoy0YoNOwBfpckFY16O
         kpPb0GjNH88im2j4qL3iuIUZFvyRxvp31BCsmoHojBMeEqltyiY69O+DoxawDbqBxvhe
         xLZDlchYAQjOfu72jqyPkS30LLY9rsn3gA2vraStbdHVU5OhG2ItaZ7Petxt2NwPCJru
         4rdQ==
X-Gm-Message-State: AOAM533uzWFtJVJrdGcYECUFiNw1oGRJmAQ9TAT72w2htxL1KtT7ETzI
        gT0V+usSdb/ZtH2dDbu8bjENSSwbPeuowsFwElc=
X-Google-Smtp-Source: ABdhPJzrtPXdMK6C/6zM/etPj9WaqYYU58I3AI2JGY1J4TAFJCRFAgbdVdo9sip3Dxn1qxVwGGkGhyha6AwEgrirlMc=
X-Received: by 2002:a05:6402:34c7:b0:423:d44a:4c6c with SMTP id
 w7-20020a05640234c700b00423d44a4c6cmr1381027edc.356.1650111876564; Sat, 16
 Apr 2022 05:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com> <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
 <AM9PR04MB821114617421652847FFBBF3E8179@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5AUJyrhzM4TJkxWqawZ41d0aLbDa1912F1-71tcpWoJUQ@mail.gmail.com> <AM9PR04MB82119651D9FC652BD982646DE8EF9@AM9PR04MB8211.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB82119651D9FC652BD982646DE8EF9@AM9PR04MB8211.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 16 Apr 2022 09:24:26 -0300
Message-ID: <CAOMZO5DtC+gq+MRMjAjZsTDmGT2r7v+qj48Tk-KxLbJdd1JP0g@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     Varun Sethi <V.Sethi@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Varun,

On Thu, Apr 14, 2022 at 11:56 AM Varun Sethi <V.Sethi@nxp.com> wrote:
>
> Yes Fabio, we will be posting patch by next week.

Is the kernel patch that you plan to send along the lines of the
following U-Boot patch?
https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/

Thanks
