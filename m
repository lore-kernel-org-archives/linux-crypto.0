Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EBAC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 16:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4989B21738
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550594488;
	bh=sfZYBVk66xHud6tmaMQKnDaOJjpsmCJtq2cgfZFEPSU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yNzyaQSONHf9pUoQJeW+hcIvRKuJj/Tal8H5q25svHff5mu58BaUMI7kd7Kyf+JKN
	 o+0hmb9lMZWQzXwJzWrcUOxfEIxGygVrNIzicGnP7qqpTqcmD8YadJ3Zs/2G0qcCWB
	 Nc/9/ankuIGaumcFlcZfgJul3VpbjFtYAagkYwno=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfBSQl1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 11:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfBSQl1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 11:41:27 -0500
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A0EE2183E;
        Tue, 19 Feb 2019 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550594486;
        bh=sfZYBVk66xHud6tmaMQKnDaOJjpsmCJtq2cgfZFEPSU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dxTrp1NkKP5FMmWxf4SvjWYXUdScTw2urzt2nevCmUSkc6kdvW21qznxNRBGJedhA
         6OLgBLFTCpeEE+l070keXunniLO7bhkbJhcAMgNhMoVLidmd7VGuKKHT7Cve4DhdjT
         LgVqMhbAb2DGPPm0+8s6KRsYG2O+GwofDNm4kFgA=
Received: by mail-lj1-f171.google.com with SMTP id v16so17977543ljg.13;
        Tue, 19 Feb 2019 08:41:26 -0800 (PST)
X-Gm-Message-State: AHQUAuYYo7SLShrGNs874ZwnKfMlRJzc+cZWGBBhRu4N3eiMN9WeOxTP
        /GQ/QlfECOjCaYPysGSZpXSCjrNw7cW+4Lm/idw=
X-Google-Smtp-Source: AHgI3IYDlwyOdNCzFtVQLPH2b+TllIuSkBQi60fqfCoix+6aaQ4g6x5i9B5iWF+aihqQ3/WB8pW+sjrM9m3RNy2xqTs=
X-Received: by 2002:a2e:3a10:: with SMTP id h16-v6mr23218lja.184.1550594484402;
 Tue, 19 Feb 2019 08:41:24 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190219160249eucas1p17f521e74a9acab6a330e72a3c682adce@eucas1p1.samsung.com>
 <20190219160232.22084-1-k.konieczny@partner.samsung.com>
In-Reply-To: <20190219160232.22084-1-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 19 Feb 2019 17:41:13 +0100
X-Gmail-Original-Message-ID: <CAJKOXPcA-P8GJmbR7rVx+-2ac0Logk=TarcWOeY93LHHJDbRSA@mail.gmail.com>
Message-ID: <CAJKOXPcA-P8GJmbR7rVx+-2ac0Logk=TarcWOeY93LHHJDbRSA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: s5p: update iv after AES-CBC op end
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Feb 2019 at 17:02, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Fix bug "s5p-sss crypto driver doesn't set next AES-CBC IV". While at this,
> fix also AES-CTR mode. Tested on Odroid U3 with Eric Biggers branch
> "iv-out-testing".
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> ---
> Changes since v1:
>  - reworded Subject and commit message
>  - changed code according to comments by Krzysztof Kozlowski
>  - added Reported-by line
> ---
>  drivers/crypto/s5p-sss.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
