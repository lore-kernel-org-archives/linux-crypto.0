Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13103C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 13:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiDPNbX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 09:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiDPNbV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 09:31:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555F989310
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 06:28:49 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v4so12770981edl.7
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 06:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oa17SrJjKK6fmQmyzunecCxaWKrt8dkxFwex7Ql3Gks=;
        b=MBEszC9ir1dkUP+gC2wCNRlI65n90W/3aVZBveXDM7JWgCsJyR7WJESBRpPHSdTV9W
         RDtLDQJs+8w1ZBD4W6IrfNlQ9e2sQpxVUa1OM70E5x/pq7ISvus46jPCkC3XGeyqMTrD
         anwqnAhPqSnzRAOsonJxQukVaDvPpVbcXgW5yS7hNdAvBt1xJ1ALHjDPO8SJF/R9dVOj
         wFNp++bR0EZoHWbpUzoBZ7YnVJNepjij0H6F9+q46Rd8FXv2rvVKMUGkz8NdP+xWlmkR
         Mo8x2b8OGjLEhPH6KZa08lI0hNxw+12cnVNOFZcAbatcEAWEHsYMfwHTJJojcOZVdjOR
         VFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oa17SrJjKK6fmQmyzunecCxaWKrt8dkxFwex7Ql3Gks=;
        b=aI+ceILtv4KdtmMFCTbxxN3OwNnZ563B1bP3oLot7bmaLZXiX2sAD+CtyjMW+fZ4k6
         +gUPwOOjpX9Ebc7S9PHU/xc4c84sW3cWHcoUTeBniZlBLlDuX/jsdOj678zNPyoUd4Bb
         hOfM2iryggw+vpxTbMXPBq5zYnZKNNh9jUbE1RDTzmpoVdrJ8Xz4cQ66xmHnF06CDVE6
         i8uwLHD4vUtQb7mpT/sir6e8GsiIlz4T7M/EaIgvrdgRnobLCWxW7O2kJC4DcvWLSQ/w
         h8Qe9cFIlyOMeC/wlmYX1nk4gdNLsqOkEq6lgEbwDmMDPzEZhbAxlKykmIihHeytNCor
         G2ew==
X-Gm-Message-State: AOAM533F9dpS+QzPhhNOBRQxGbT7xolWHumh4qc5U9IuOtgGskvPITKs
        4FlJVLj11aDPwYP+B6sNeCoiK9Jgbr0SXuznz4Y=
X-Google-Smtp-Source: ABdhPJxGjgvzoKKja4Nz0WRGlwXx1uZ0/6QsWXZTeEJEUH8bXTPqxkWNb0qlCzOSIEPF8XA+a2CTPL+6PJH76OMku8M=
X-Received: by 2002:a05:6402:190d:b0:41b:a70d:1367 with SMTP id
 e13-20020a056402190d00b0041ba70d1367mr3710967edz.155.1650115727817; Sat, 16
 Apr 2022 06:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com> <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
 <AM9PR04MB821114617421652847FFBBF3E8179@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5AUJyrhzM4TJkxWqawZ41d0aLbDa1912F1-71tcpWoJUQ@mail.gmail.com>
 <AM9PR04MB82119651D9FC652BD982646DE8EF9@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5DtC+gq+MRMjAjZsTDmGT2r7v+qj48Tk-KxLbJdd1JP0g@mail.gmail.com>
In-Reply-To: <CAOMZO5DtC+gq+MRMjAjZsTDmGT2r7v+qj48Tk-KxLbJdd1JP0g@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 16 Apr 2022 10:28:37 -0300
Message-ID: <CAOMZO5BT83uTtORAa2aP0q6st6_4Mg4D6XDcSg+wv6YHZDDk+A@mail.gmail.com>
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

On Sat, Apr 16, 2022 at 9:24 AM Fabio Estevam <festevam@gmail.com> wrote:

> Is the kernel patch that you plan to send along the lines of the
> following U-Boot patch?
> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/

Following the U-Boot fix, the kernel patch would look like this:

--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -648,6 +648,8 @@ static int caam_probe(struct platform_device *pdev)
                        return ret;
        }

+       if (of_machine_is_compatible("fsl,imx6sx"))
+               ent_delay = 12000;

        /* Get configuration properties from device tree */
        /* First, get register page */
@@ -871,6 +873,8 @@ static int caam_probe(struct platform_device *pdev)
                         */
                        ret = instantiate_rng(dev, inst_handles,
                                              gen_sk);
+                       if (of_machine_is_compatible("fsl,imx6sx"))
+                               break;
                        if (ret == -EAGAIN)
                                /*
                                 * if here, the loop will rerun,

What do you think?
