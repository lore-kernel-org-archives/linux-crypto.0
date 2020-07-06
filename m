Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD328C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 16:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894FA20775
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 16:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=jamieiles-com.20150623.gappssmtp.com header.i=@jamieiles-com.20150623.gappssmtp.com header.b="graI+dI9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgGFQFo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgGFQFn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 12:05:43 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DFEC061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 09:05:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so30356060wrl.8
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 09:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jamieiles-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eBPnkwcEmj4IleOIZo1SbNNrAcrM3jMcjDLqnc3mvM4=;
        b=graI+dI9hBmdeMJXZyZgAWHjSt1hUmgm9LBS4QABqnLq8Lcgmjo8x9pfbg9lP9kf+n
         ZRVeDcsn9hAIG0hT9rbi261Fo2WwMjWP3CXuOG/sTJb5jtvLpzgM+1S3Cpxg3XpDDmhb
         wlFdSslM7AOFNgZWZOqoNNpUTgNxGbjoCxxtjmF5hWWpunSeKPWSKOiW9/R/dFzffatG
         rSgvWF5ft+ujntg8tbpzDWYlk+ZKQdfpoyPltv5wCMLSmdLVvMam28GoydknZ+DjHr/b
         n2dqdeadOzbuguOrHu+YB5et0IWZT5c2/rM9ajw4ooE6W5T4PguSYx3MknuIf1v6RPAh
         lyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eBPnkwcEmj4IleOIZo1SbNNrAcrM3jMcjDLqnc3mvM4=;
        b=JTPLJ0Zwjsk9gm7FIzI6gIdi83abMqXgyWdnzaFasf2R1rWDZnXA6LxAKNHYpJWb8o
         bbc6qHsNubCIWoYb1lR63cz8ALC+UhTapDV/LqVkvVofwyFiyO/rqKw7dyic9YDPUygr
         KcnUVNqGDfVW7gmuL3yzBGrpjZKpYczcPjhW+26pvm8VPVPfFmlcLlVja0fR7RVpExM3
         NnFeuRgG4MkceaYcpmFFSRgOqdAbWnpa6Vbcf9+ckazET1Ro+z1gdRLJlPdxn0g+Kk8t
         EQ7Z7Y0031m+RiGesBbtgMStdebdfJNvM8EWXA7HctV3Z1oo2oJWkuS+jfX0BeZEW7d4
         bm6Q==
X-Gm-Message-State: AOAM533guf4uviOn5S6vmB1lv6n45cZ41ATayy/B1m420yqUdWdAUT3J
        J2wWRtpVDZ/+DuezgDuzVaXRFA==
X-Google-Smtp-Source: ABdhPJxSC3ddxDtVfXEHhH1Pv6zygUKMZ6FqNEz/oz7ZdCCjbq9B6RkB5dxPQNsjM1llZm6UT+Tnzw==
X-Received: by 2002:adf:f7cb:: with SMTP id a11mr46422170wrq.291.1594051542111;
        Mon, 06 Jul 2020 09:05:42 -0700 (PDT)
Received: from localhost ([82.38.213.95])
        by smtp.gmail.com with ESMTPSA id e17sm24137875wrr.88.2020.07.06.09.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 09:05:40 -0700 (PDT)
Date:   Mon, 6 Jul 2020 17:05:39 +0100
From:   Jamie Iles <jamie@jamieiles.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
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
Subject: Re: [PATCH v3 10/13] crypto: picoxcell - permit asynchronous
 skcipher as fallback
Message-ID: <20200706160539.GE84554@willow>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-11-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-11-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:19:04PM +0200, Ard Biesheuvel wrote:
> Even though the picoxcell driver implements asynchronous versions of
> ecb(aes) and cbc(aes), the fallbacks it allocates are required to be
> synchronous. Given that SIMD based software implementations are usually
> asynchronous as well, even though they rarely complete asynchronously
> (this typically only happens in cases where the request was made from
> softirq context, while SIMD was already in use in the task context that
> it interrupted), these implementations are disregarded, and either the
> generic C version or another table based version implemented in assembler
> is selected instead.
> 
> Since falling back to synchronous AES is not only a performance issue, but
> potentially a security issue as well (due to the fact that table based AES
> is not time invariant), let's fix this, by allocating an ordinary skcipher
> as the fallback, and invoke it with the completion routine that was given
> to the outer request.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Thanks Ard!

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
