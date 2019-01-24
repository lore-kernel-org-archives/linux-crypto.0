Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95948C282C5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C6552084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 10:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548324105;
	bh=Dnyvg710uL1VW6na1laCNJK+x3jDqabiSZuMtVPQ9N4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XBTyh78Z03Ph+sYNDh12fuNGYcR+WicHBLG62zzEqEPNux0Aiji7L5jNRfF4qOWuo
	 PJIJK0i4PQAKggyVDQkUxjteWnFrBjnEUph4N4a2Q2iJW203oCvZIzMFJQwZ7hBdaJ
	 Tj/g69xZpPaAVo7Fpq0/8cGMM0UVqpHBAOv5CmnY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfAXKBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbfAXKBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 05:01:39 -0500
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56592218AF;
        Thu, 24 Jan 2019 10:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548324098;
        bh=Dnyvg710uL1VW6na1laCNJK+x3jDqabiSZuMtVPQ9N4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NdZ7SCKzvOS39Y9ljeq26sGbOO91OnlFHjGseLOagC7uMp1lZEUTWUqdDzgklS2O2
         cbXGNwiuUBc1usJBpYlcNdgJesPc63i2UWMuAxi4eEhtkJFAEyiIFrhkl3hHgGLHxN
         46nklz//55v7tgews3VBrqTAefcXnW4yP24A7in8=
Received: by mail-lf1-f48.google.com with SMTP id e26so3857662lfc.2;
        Thu, 24 Jan 2019 02:01:38 -0800 (PST)
X-Gm-Message-State: AJcUukd6os6cjT3BC9K6vNx02D3ytiIqJeQuEva9xGoC6YkD4tlJSNZx
        3XLxXGi6WTrOdHmy0vLChoGQCuXx4VN6HGlOfWg=
X-Google-Smtp-Source: ALg8bN5nsXDbhS31z7waiyUUDiEi7IbC9ueQN6NoxxnTzeoTiau4grJi6vIuuXUdwQfEBDU00Zyllj6SThxHLGzaHGg=
X-Received: by 2002:a19:f115:: with SMTP id p21mr4624454lfh.20.1548324096352;
 Thu, 24 Jan 2019 02:01:36 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190123165551eucas1p2bb80cfe58535b5f665271c7448cffc30@eucas1p2.samsung.com>
 <20190123165533.29645-1-k.konieczny@partner.samsung.com> <20190123165533.29645-3-k.konieczny@partner.samsung.com>
In-Reply-To: <20190123165533.29645-3-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 24 Jan 2019 11:01:25 +0100
X-Gmail-Original-Message-ID: <CAJKOXPe1_XwYdgRjqO7hena-YtLFuX-Mcw01mx9M9yUAhD36Zw@mail.gmail.com>
Message-ID: <CAJKOXPe1_XwYdgRjqO7hena-YtLFuX-Mcw01mx9M9yUAhD36Zw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Jan 2019 at 17:55, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
> SubSystem) IP.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  .../devicetree/bindings/crypto/samsung-sss.txt     | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
