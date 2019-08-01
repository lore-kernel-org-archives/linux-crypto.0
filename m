Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51B3C32753
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 15:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0122087E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564672819;
	bh=A5WVsf7G2kFJI6lI2lC6kb+wdtK4qcYkyJefqOmwKnE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1RPEP2RT/QDsmG8A3YUY2pnEXf/u4bzcxkjMm5A5vJv+3bRFbJUNTjR2e4mnSOqSd
	 ZKWTDsczE4fTGBC9nVtbdBmeCm2ROuHzT8E3o5q4AS7BKcQf1hjo9kus0CDqH7nUwP
	 e+xKLHJ/LAqmoUlutWLpfdfDMk8d410N/K06ya+g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbfHAPUS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 11:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbfHAPUS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 11:20:18 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ADEC2171F;
        Thu,  1 Aug 2019 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564672817;
        bh=A5WVsf7G2kFJI6lI2lC6kb+wdtK4qcYkyJefqOmwKnE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iPvinyI9HCcagqoyjJOmSXdt/1odOuDy24qOv1sHtO2tFYo60EpDtdKR/vJkNTLxQ
         p1YslmBdSI7GE9rHshrM3LJXBthjFmaRgRZ9sLnG6U5C+jCVIzUBAcJCSQjEKodcOE
         71A/4oGB0Wb1P3jtkbdnyfpUrr3DzyZXYWLie7KI=
Received: by mail-qk1-f171.google.com with SMTP id t8so52311763qkt.1;
        Thu, 01 Aug 2019 08:20:17 -0700 (PDT)
X-Gm-Message-State: APjAAAUhQtWm2yMF57edw3SiqTqvh8y85xNfkgv0moKbWm6+3XY9gZRk
        OU7rCs9BMzjKS837zryKDyNaw/oCewbsLzILHA==
X-Google-Smtp-Source: APXvYqyOTDfIkp0PiGP+4XgmfZUgR81KtILQm6TcrNNBpWndNc5glbXR+cfHFaU1qak5P984zIWlLDST+tVjYpRqtxI=
X-Received: by 2002:a37:a44a:: with SMTP id n71mr21061481qke.393.1564672816295;
 Thu, 01 Aug 2019 08:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190801135644.12843-1-narmstrong@baylibre.com>
In-Reply-To: <20190801135644.12843-1-narmstrong@baylibre.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 1 Aug 2019 09:20:03 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL7FEAJ9S5j9JSwfj+t8434KsEOcxKEMWNFnG00b07JMA@mail.gmail.com>
Message-ID: <CAL_JsqL7FEAJ9S5j9JSwfj+t8434KsEOcxKEMWNFnG00b07JMA@mail.gmail.com>
Subject: Re: [RFC 0/9] dt-bindings: first tentative of conversion to yaml format
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     linux-amlogic@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        LINUX-WATCHDOG <linux-watchdog@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 1, 2019 at 7:56 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> This is a first tentative to convert some of the simplest Amlogic
> dt-bindings to the yaml format.

Great to see this.

I've gone thru all of the patches. Some of the same minor comments I
made also apply to the patches I didn't comment on.

Rob
