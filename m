Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153BAECDE32
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 13:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE56921529
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 13:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XayVh2GW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE56921529
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbeJQU6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:58:09 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44974 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbeJQU6J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:58:09 -0400
Received: by mail-oi1-f195.google.com with SMTP id u74-v6so20953207oia.11;
        Wed, 17 Oct 2018 06:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rc0peB4/dUiUAP3ETkB7kdJ80KDzLwkt8TY2q5Yqj9w=;
        b=XayVh2GWLqknItZso81nu+24xbbdoGo+PGbcib/rXiU+TihP6bH3y6P7GsPcSL0xAC
         2+cCCTqvD8q1Y8F4heGuQqkmyYh3ABxeo+p/FO8GVIHFYeg6F/7a7HkAtZ1DFwr68U1i
         6AYF/xqff1WarrCc2VbWN7W7C39LYWgk5Gn08Tzl9jm4L7qiw82GBnj1ux0hO8+SKIpt
         77GlY+AdzQ47wRC/H79uXd9JyIs1ROA7JfCU4NCiRLuapbtDdJKxnrXVK0Th9VNiuQL1
         Att0aeHcz1UXUshB6RpkCGLwWk4kJn28b/SaHjLuvAk6ycNWRhr3uD56y2A38Io+NOLc
         gp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rc0peB4/dUiUAP3ETkB7kdJ80KDzLwkt8TY2q5Yqj9w=;
        b=BfNaYveM92F0MyHKhSJKD0fjHYhnU2GbOJD1RidbTFIynNAKEB29Pzn4Nv9oOZ6viK
         5Jp+vAnvE5Frq/rMfg9ZzivTLO3736h5WdCaEKRjaKxDMTv6HFLsMJqS13imlyLX/2jK
         ludIJgmZ8rDavYlnHX2QMO253VQkuLO/Xv3oDKoxYWYTnaO8E+nR9iQkks7iBhjTGl35
         SrzIyo5zTATj1FTgv3EBCRF9iSPdPwclKVP7xqDaBwbUWpvQltNpG8qZxf5apKDtj7nn
         Y6h23w/Gmi1nt+877XYGty4lqqesqmgJKlJadeETFxM+tC+NPgGaHW6SjlWUN9WbqQ05
         jIDQ==
X-Gm-Message-State: ABuFfogm/OBIf1D3oHeDBp4c2HFy7FptMFOCJDk1e5+RsYR+I9Fs34Ss
        X3KNBZQtkKGSLCPQXnmQ941KYtXz90KekvSLK18=
X-Google-Smtp-Source: ACcGV62swqX/q6QOWdux8VxUxoGtqbcRh+Qs8/UO/DobUxukSZQMRrKplzRKdRL1TLarqruOLh0Tr60MSva6z/WhNOo=
X-Received: by 2002:aca:470f:: with SMTP id u15-v6mr14397347oia.259.1539781352700;
 Wed, 17 Oct 2018 06:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539779579.git.leonard.crestez@nxp.com> <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
 <CAOMZO5BMeHjsyZWhUb5RmEBRCYViUN-Vx8KyLBWtDJGKBHHpCg@mail.gmail.com> <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
In-Reply-To: <a97517bf72f649915bccf555ab7d3c8c4551298d.camel@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 17 Oct 2018 10:02:41 -0300
Message-ID:
 <CAOMZO5DCzM_NnqD4tHTAn4pAaUdQGo38Ami1h3pu9SzgyQ7GnQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marek Vasut <marek.vasut@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017130241.llCwTKD9jM5bhqO9B9cL-Ucbp76_BN9f3rWXXNd0xL4@z>

On Wed, Oct 17, 2018 at 9:59 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:

> There is a changelog in the cover letter.

It did not show up:
https://lkml.org/lkml/2018/10/17/673

> This only looks slightly odd in git diff but it's not unrelated.
>
> I placed clk get/prepare/enable just before stmp_reset_block and made
> stmp_reset_block print a message and goto err_disable_unprepare_clk on
> failure instead of just "if (ret) return ret;"

Got it! Then it looks fine, thanks:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
