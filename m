Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752A0C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 10:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43700217BC
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 10:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bofh-nu.20150623.gappssmtp.com header.i=@bofh-nu.20150623.gappssmtp.com header.b="jJ1yhaLn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfK2KC6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:02:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40777 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfK2KC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 05:02:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id y5so14324063wmi.5
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 02:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bofh-nu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UrKqSRJKoGBPMgO2/jdCKMQcuQ7A1Ss66dwsiix9b0=;
        b=jJ1yhaLnNR0CYGklrHbhvyokqlCl72QlSTMfSa4E21afa0fYB8h7HwmCoSh8aVQe6U
         iu5bAl6x2CbffFH/bawfVtQgwanXgHO+iS1Gb+OOA06PXIu/PIpL/HJn6LjoQyAkRO70
         fxLYUtGpmfos2QR3CnLxgKJc59EDfltbblF2X6VKh+1o5HkGi+iyOiEa1L1YEFNfaPVi
         Ni5VDKVwx/4bFy8RwrxZNNrw86cFlsDODmaLZv0yCr5qRZSmRt10SSWPFopZ4auPDcDq
         dY3UsZ//d3BFZG6YSXWhh0M8Id1A0ugvSDqZdrW2smTbAWpG+H1lgDdlT80mzZ4SNjNj
         /cPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UrKqSRJKoGBPMgO2/jdCKMQcuQ7A1Ss66dwsiix9b0=;
        b=JMQ+jwxh6EI31PUPp25+d5y5TD3kxzU+6Tn6mMPubt9Ti4sz7aWCPBMbVc68Uy3h5m
         BKfJffofX2PX++9YPRdQDheGCHgLW7j8LSGO4ijz+OPCJtBhJD6gATH3BmVkpYrBhohw
         54aQ+NMbdmKHX/IKhvvY+DPhx0pfTuASyJ3lSga6kk4PNkMkXwZYf7FpoNLE4ocf7pde
         ibxhsli4PbdXFqrsWfmo5GVYNXjao2ZP15nTTZeRDut5HV32FFlhdmIy4dzvAqt2p42B
         TdoM0ergIZksKnrf3IOJ7pu/R99XP0PTjjX+ZNsc9ByW2umffhEq/w+5VSliomgEbBnj
         /fEA==
X-Gm-Message-State: APjAAAVOkns2myeZIhJ8CmUdOVYo6kXByVqV9wWA1jj7IzoHDc4OF2RK
        Bw2E+WUEsfXLAMPUT5z5elhrq5qGq8aFN4GHrjIul2tGw0Q=
X-Google-Smtp-Source: APXvYqzTAFXNZGcwafQIeJec73W3RgozsYABeK30eaJTije1g+7R6/B3hF2p2eSWHt317C9cAPOBhlSgllb4GK9GIO4=
X-Received: by 2002:a1c:7708:: with SMTP id t8mr13713623wmi.29.1575021776664;
 Fri, 29 Nov 2019 02:02:56 -0800 (PST)
MIME-Version: 1.0
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com> <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
From:   Lars Persson <lists@bofh.nu>
Date:   Fri, 29 Nov 2019 11:02:45 +0100
Message-ID: <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        linux-crypto@vger.kernel.org, DTML <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wsd_upstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Neal,

On Wed, Nov 27, 2019 at 3:23 PM Neal Liu <neal.liu@mediatek.com> wrote:
>
> For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
> entropy sources is not accessible from normal world (linux) and
> rather accessible from secure world (ATF/TEE) only. This driver aims
> to provide a generic interface to ATF rng service.
>

I am working on several SoCs that also will need this kind of driver
to get entropy from Arm trusted firmware.
If you intend to make this a generic interface, please clean up the
references to MediaTek and give it a more generic name. For example
"Arm Trusted Firmware random number driver".

It will also be helpful if the SMC call number is configurable.

- Lars
