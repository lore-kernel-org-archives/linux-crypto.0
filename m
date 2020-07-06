Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2AFC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD606206E6
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u1yaQckz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgGFRcx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgGFRcw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 13:32:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE4FC061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 10:32:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so39025454wrw.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4re96D1Eti1S0FH6YUvJn/YvkqNs2BY/FYr9VaM++00=;
        b=u1yaQckz5NyNaEIAZGrI7uBbFy0+8vPJQ9I6i2x34FD+fQv5r2hJ/5IJm/ZoKBdZ4x
         53H68V/oPsPEjgkUfCCo+RUhWgzhfacCXRhhCXY6SBjGyeP/kfWZgteryDXRecFU0ZB1
         VTkUe3DN4Xwf8Ky3iN0LfseCIrD5ChI6OqgDaV8sfqko/qW71GZIOAtx/jcG9b2OtzdY
         c7eP8Dkp+w8RXeKkAXOlAVWJ28dlqx513D5gQCjRGw9JbfFLk8YciquVoAiFyr8Av6Ak
         DJAlya/d+mPaqNLqjJRt6mMolo08qcKGpEjIfJNdAj9JWKUDG3SwG6YtkJo6MJ+nSAVw
         jzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4re96D1Eti1S0FH6YUvJn/YvkqNs2BY/FYr9VaM++00=;
        b=ppMGPAMC1qcWwgdL8g9TGhDXcccEEKfwlHZb9CosY8q4D27qp5F0Krzff/M17km9oT
         lmsPgYfmChL1uAdHzmmglnuCGuTKIlbE4rdg8F8InGJlVrUeFmpIh76eLtFD3/zUYxMU
         ZIvqhOgesvUnHevE9CVuigCIv95q0CY26iBe7b2rK2Li6dVU5UdVfsBoJ9cpRFL6wo8q
         BQ7FSVbLQ+AlIExQikLvkY6Qt48L9xO+GuKtQYmbqAbf8QqAo6dY+7BCE+aw+O8E3HFC
         AvZeiIjbjT/1j1cD8T1Kzx1czM3ZyrIst81KbIBKqy6oFF0z+eIfWVI90Sb0XJa7hKuc
         a0NQ==
X-Gm-Message-State: AOAM533WSZ5+tkmgK0dckSB/HoPM1o994UXT9QGy8tfZfiPnqTCBpP3Y
        Btpjxkko4ibnecXsZ7GtLmXAs4XQ
X-Google-Smtp-Source: ABdhPJzpaKuhrcj4Spk4NpcJl4gqBEhaqtnNDlxhEk9Q8juAXHiO+RkpfSw10IVHxewM23Rd+D5DGA==
X-Received: by 2002:adf:fd8e:: with SMTP id d14mr49970532wrr.202.1594056771324;
        Mon, 06 Jul 2020 10:32:51 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a3sm194035wmb.7.2020.07.06.10.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 10:32:50 -0700 (PDT)
Date:   Mon, 6 Jul 2020 19:32:48 +0200
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
Subject: Re: [PATCH v3 04/13] crypto: sun4i - permit asynchronous skcipher as
 fallback
Message-ID: <20200706173248.GA25769@Red>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-5-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-5-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:18:58PM +0200, Ard Biesheuvel wrote:
> Even though the sun4i driver implements asynchronous versions of ecb(aes)
> and cbc(aes), the fallbacks it allocates are required to be synchronous.
> Given that SIMD based software implementations are usually asynchronous
> as well, even though they rarely complete asynchronously (this typically
> only happens in cases where the request was made from softirq context,
> while SIMD was already in use in the task context that it interrupted),
> these implementations are disregarded, and either the generic C version
> or another table based version implemented in assembler is selected
> instead.
> 
> Since falling back to synchronous AES is not only a performance issue, but
> potentially a security issue as well (due to the fact that table based AES
> is not time invariant), let's fix this, by allocating an ordinary skcipher
> as the fallback, and invoke it with the completion routine that was given
> to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 46 ++++++++++----------
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h        |  3 +-
>  2 files changed, 25 insertions(+), 24 deletions(-)
> 

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
