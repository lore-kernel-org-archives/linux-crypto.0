Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F894C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F374206CB
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tnW2RfcR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgGFRme (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGFRme (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 13:42:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6EC061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 10:42:33 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f139so43013453wmf.5
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 10:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gqv534YkUnFYr+r76ikVWT2HQqldNaFcBABCuVprGcY=;
        b=tnW2RfcR+axpdw5n+7fO1pcgng20fbUD8mUrH4ZQdXO870r1WqOnLHuIQMtDFhOK+R
         wbGI9EBXY6tclQ9Nq9Ce+uGmjEare9S6vlfHr8hFoPtPA2afIEitoEdNYiJkmWayTNlT
         ba+OTYSW2GafPl8p6JK7qq8Ft+nvQaAH+gNza/zH12RT6sfY0RjU3S69AuYWgAwJlhhP
         p/FmwPhl5zXBlHyObmvNiP7Yy8cs5pzO1K3F5mDHqFtRfghrsyyJ8uQOa0PuuG9cv3Pf
         p0wbbMeS7LK9xikZxpbBvQAyBxfmWL4ddEbVvOoplv2vn9ayVVEuyDO9ZhZ5WsEbTgH4
         n7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gqv534YkUnFYr+r76ikVWT2HQqldNaFcBABCuVprGcY=;
        b=M5iwYxNkX18QbRlRxr43HUDyxsVq0+zTsTT+YUxWUhyiiwWQtqVc1Fu2GnDeJNPnKU
         aIWMbfpbIq3P7Vv/qJULFT8pFSsnwvj2/5YF2SWlMwcUxwwQZdoRqoGYk+IzE5Cszr6k
         nV8VBKKp1dgk0/JZoo+r62n0M8vzTJb2CJKyuXTdP63Xv3mxQjybCfdikr63fSlXOA7y
         DW9WxbnYj9HX51YFD41PHxq+qg78wPr5oZsVzeshfpoUEWnvGfGYLr1D2ohq1p1XiDD+
         qqVvq5Zi3h2Nma47wudzKPoVwQnOCGgY/Y3ET+xx4OkTkkLOmyhcXGGypJ7fWPvZFl+9
         NJnw==
X-Gm-Message-State: AOAM533SZzc5nLgagX0HqG3rmVWp1g6G0ubZK1hNS4ttqj7MtacJCskc
        +fU8KKqOV4XviHfnQClZalE=
X-Google-Smtp-Source: ABdhPJzN4K9a1CDusLe7YHZWIm9s/LGzpTci3h7ITL6iEGjKjgmrJGYmy4IJH8PwXFk+pzPLcX3PLg==
X-Received: by 2002:a1c:e910:: with SMTP id q16mr300505wmc.188.1594057352701;
        Mon, 06 Jul 2020 10:42:32 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n16sm167704wmc.40.2020.07.06.10.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 10:42:32 -0700 (PDT)
Date:   Mon, 6 Jul 2020 19:42:30 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Eric Biggers <ebiggers@google.com>,
        Tero Kristo <t-kristo@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH v3 02/13] crypto: amlogic-gxl - permit async skcipher as
 fallback
Message-ID: <20200706174230.GB29043@Red>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-3-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:18:56PM +0200, Ard Biesheuvel wrote:
> Even though the amlogic-gxl driver implements asynchronous versions of
> ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
> synchronous. Given that SIMD based software implementations are usually
> asynchronous as well, even though they rarely complete asynchronously
> (this typically only happens in cases where the request was made from
> softirq context, while SIMD was already in use in the task context that
> it interrupted), these implementations are disregarded, and either the
> generic C version or another table based version implemented in assembler
> is selected instead.
> 
> Since falling back to synchronous AES is not only a performance issue,
> but potentially a security issue as well (due to the fact that table
> based AES is not time invariant), let's fix this, by allocating an
> ordinary skcipher as the fallback, and invoke it with the completion
> routine that was given to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 27 ++++++++++----------
>  drivers/crypto/amlogic/amlogic-gxl.h        |  3 ++-
>  2 files changed, 15 insertions(+), 15 deletions(-)
> 

Tested-by: Corentin Labbe <clabbe@baylibre.com>
