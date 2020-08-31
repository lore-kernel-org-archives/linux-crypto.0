Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76064C433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 11:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 539DB20866
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 11:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dj4tOupm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHaLue (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgHaLub (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 07:50:31 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C5EC061573;
        Mon, 31 Aug 2020 04:50:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so3996196wrx.7;
        Mon, 31 Aug 2020 04:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ntaRkESI0KlWO5jlbqkWdKKiUMc6rb52K24dWZmqT6o=;
        b=Dj4tOupmz1KWVBoQsdx3/7r1/Ih6ggXsNelaJvaU2edQ51ThSogx2fjtgKQTG5XaDO
         MGDV4ZS4K3wdSAyjV3AMMQthCh+pN4xdB7WPQ609HnE328BsFEgAleY7c6XI8vj2B7My
         qRhw8Rn+hM/JcnT78AqI8GRtvTShuU2HLL3/HYKhi8/JlTGX/uajN3CjWlOC0gFLyF1s
         ueaZmCd2kLxPhB9C3CAmFwd5PijywcXR1cTORwL1lCWS/ovccX3RVo3jVjNwd81PqkBA
         o/7Yl8u7lS+R9HG57RxZEaFCROdq8CLPzIi5jLFWYRXFPUF1lV9SsrjIkoM0ywohNfKV
         5mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ntaRkESI0KlWO5jlbqkWdKKiUMc6rb52K24dWZmqT6o=;
        b=Ur28FlOKl/3mPHQAKjt3IcH4gZlXTF+zv/Fjds84xz5+QF3D/1ii9FktD3wKlrxR+R
         ZTUSeI2kk7IgEdNeIqFXdR6VLqtuX4FBOMzOWJpmUhB1dzEaIF5zQTW3NSbvewFI1waT
         Mr25mZIUlIsXLOYlwXAKzaX3iLs32kptMA44qldkSRkLOvBhKmfLpFT2dV3tV5l6vuIf
         5IRdd/Gq1/O8Mbo/Hhj6aQNykP+eX9VuAtX+hGcWx2JTPP2XCfGb0BWUxUh4xee/5Pm7
         m00ZNe9ZzQ+TFy23I5tFLIsoS2nIVnwrJBpcW+6JSL8eVcglPEmu1TZkTauHoFk1bQ2u
         qc6Q==
X-Gm-Message-State: AOAM531lHTicUiomLYMeBLUB1GP3Xht7mWnFxfUAKGsPHz6lDsvb/jUN
        ZEate9ycdEbUU/IISgfkaxg=
X-Google-Smtp-Source: ABdhPJzxDWKOd3BFclKVGWV6b5n5xOxHiSCR70fyVnZZZtvN1MY5S1SWpZPiERyZJy0yqiHzlRahhA==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr1273400wrn.161.1598874627021;
        Mon, 31 Aug 2020 04:50:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id z6sm11901158wml.41.2020.08.31.04.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 04:50:26 -0700 (PDT)
Date:   Mon, 31 Aug 2020 13:50:24 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Martin Cerveny <m.cerveny@computer.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 3/3] crypto: sun4i-ss - add the V3s variant of SS
Message-ID: <20200831115024.GA14248@Red>
References: <20200831073101.3608-1-m.cerveny@computer.org>
 <20200831073101.3608-4-m.cerveny@computer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831073101.3608-4-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 31, 2020 at 09:31:01AM +0200, Martin Cerveny wrote:
> Like A33 "sun4i-ss" has a difference, it give SHA1 digest
> directly in BE. So add new compatible.
> 
> Tested-by: Martin Cerveny <m.cerveny@computer.org>
> Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Your commit message is wrong, "sun4i-ss" has no difference, but V3S yes.
Your other patch has the same problem.

Otherwise you could add:
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Regards
