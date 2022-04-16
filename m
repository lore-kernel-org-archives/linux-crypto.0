Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ADBC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 19:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiDPTNz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 15:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiDPTNy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 15:13:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29D13E0CD
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 12:11:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l7so20646236ejn.2
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 12:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7f9hzlC0S9E4wJ5S3GtPWz4T5gOZM6q0pLzKxL5hF34=;
        b=VluIbiEzmKAQ1nvS/n90Viy8/kx4JVmSK1atdlT68xTehQc9APWNyrEsfObOIbWM1B
         F4vrc4QcLuk/nPoACBM2f+GfdSk6jUNZshwBKIBu3w3dDVAc9/rZM2qWFdyTLVtZM3Ze
         4hXsD7CLWvcRZzSDUYDhifng2F33AqNbuuBJe9851K5XgpiUhDDi4pngDgrWlajR21te
         pWDVlqusd31PJg4OuzbVc6afssn9Fm+oine43nbH2b3SU1Me/oiTIs1fiBZqsM5CPvMT
         4rUk0L/mhMUAgC2a4p5cW6YUfSu47eTmY7EEPGMmDcM+JVnQ6cSSYuV3aHpQewYmXDn9
         6+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7f9hzlC0S9E4wJ5S3GtPWz4T5gOZM6q0pLzKxL5hF34=;
        b=wS/WG6WQzbtLxE2NTjUAB8pH9EMW57WV5qRk0iOhA52oXKdmCn8OF6sAkybQjaBiVc
         LLhUdqW99Jy70Vdbt3m3CxO88+E4fOkatly0yNCed8wiua2JwhAN9egcMraYCZxVBIv3
         iZs7ncgwk8RKsazq0gts2A9UetQj8iOsofma/xCEhKjYAcLIUTvkJz0REbdgdwb48DbX
         mr40YR78Mk7Zni/C8muf0029SMl7q33TFtWmmiBhAhR1LmJooGD0zJp65DmujvXd18JT
         DYt/d7+2KBNTyngbOlbmpjzi6FIcWVi/ywl2sd85u1qRc16kJAkgG747CAZ7myCfIEcS
         84Ow==
X-Gm-Message-State: AOAM5330fHO7xabMUky1Tx4ahp7oT8YHZK2vicjZsjWxfVdc+ldcdUh/
        LfpnjvGAhlTLQhbSKK820EoJGkmcWA9O4uv3QPQ=
X-Google-Smtp-Source: ABdhPJzxWWn3TuJnKMyBLiVXjT3G5QSw6z8eLKDzcq51ZrPL5P4/npSvUWasKsM8EbE8QPTTuWudt6lOzN4IW1TOT8g=
X-Received: by 2002:a17:907:3f1a:b0:6e8:b17c:e353 with SMTP id
 hq26-20020a1709073f1a00b006e8b17ce353mr3582151ejc.626.1650136279454; Sat, 16
 Apr 2022 12:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220416135412.4109213-1-festevam@gmail.com> <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 16 Apr 2022 16:11:09 -0300
Message-ID: <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
Subject: Re: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
To:     Varun Sethi <V.Sethi@nxp.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Varun,

On Sat, Apr 16, 2022 at 3:00 PM Varun Sethi <V.Sethi@nxp.com> wrote:
>
> Hi Fabio,
> Vabhav is working on a fix for the Linux driver. He would be introducing a new property in the CAAM device tree node, which would be used for specifying the entropy delay value. This would make the solution generic. This property is optional.

Unfortunately, a devicetree property solution via optional property
would not work.

Such a solution would not be backported to stable kernels and people running old
devicetree with new kernels would still face the problem.

This problem is seen since kernel 5.10, so we need a kernel-only fix.

Thanks
