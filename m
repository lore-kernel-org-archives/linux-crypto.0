Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72765C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4819D20675
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 20:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQPoW/q6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgGFUmj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFUmj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 16:42:39 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C720C061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 13:42:39 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so40625429wme.5
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fvIgccMvXabmUtTKPNt+brvNtU3IWZlaL8TG8XofFmc=;
        b=FQPoW/q6yh/Quk/H/EP84/3m3YG88Y/36oJwgVldNFRdLewmIGKP9Xj5KnXGQGtPgu
         SFJpDaF2WGKCw+beknFa+9gwODjF0X+hKVuqV11cPaHC3zeR/4F7yOBXYMis3mX3QfnF
         rN29XPcaGsjwh5xoYynYLYqD+P6Fx1lUrii7IVerj0rqGeSxnTIaT09iexaTIi1sBK6q
         rKmNogo99n0ocT6zpWXyXlOJVW6+Key4xNASeF2ASbd6tlitQyy74TM+SCISLddE6mPK
         5jV+nvXhYhBTJxrCuNgUTPQ3mj2bd4BFeku1CsSjlh1YVv8hoFR3hTXp5s9F6Xip+Z/C
         XxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fvIgccMvXabmUtTKPNt+brvNtU3IWZlaL8TG8XofFmc=;
        b=ogpoefQfh+QF+XlNTJMD+DjdrjJXH1wz5CRvDkczjg6UannkgkiKmJ++1eWbPPfyFL
         3ECxVnePec6qeYbcOp3RbLH8FA3GrU1xL8OaIQ3XHbjFTD4bt1hv0aYYCR436cR8zn69
         cb6zEGg4RhNNKV6wsLT8cpsJLpZxxojyKIG4ZgfAkMmLTS5Zh0ouVdTJgVuRTk1CkWBq
         j5Yq3nMzddsQcIbwZNBHxqqrN5QAdwr+xc64NE140HGg9xDFbHSQDcZujPTqe3If8Jb2
         wb5a3NxWWQgDaAU4zYfZgSoxRh1U33FcFlF/Xfil1rY4Z3d4orZf9YJCCuPxiTExqjIA
         W3aw==
X-Gm-Message-State: AOAM533VKHguOD7Lci3ep5/vHSTaSIrnLjxIIv+DwnHn0wQCuaHjf6aH
        BepZSLn7cfxtiIJLWxa8RSo=
X-Google-Smtp-Source: ABdhPJyuPG9W6HepyS6vcgc5LtTWT9S2Q8uSNnXd7rKJ0251ve11aiWH0BYbZchkjDIC7IkAji5gzA==
X-Received: by 2002:a7b:cc17:: with SMTP id f23mr872463wmh.41.1594068157947;
        Mon, 06 Jul 2020 13:42:37 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u186sm734422wmu.10.2020.07.06.13.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:42:37 -0700 (PDT)
Date:   Mon, 6 Jul 2020 22:42:35 +0200
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
Subject: Re: [PATCH v3 05/13] crypto: sun8i-ce - permit asynchronous skcipher
 as fallback
Message-ID: <20200706204235.GB25432@Red>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-6-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-6-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:18:59PM +0200, Ard Biesheuvel wrote:
> Even though the sun8i-ce driver implements asynchronous versions of
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
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 41 ++++++++++----------
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        |  3 +-
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> index 0e9eac397e1b..4ac0f91e2800 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> @@ -187,6 +187,7 @@ struct sun8i_ce_dev {
>  struct sun8i_cipher_req_ctx {
>  	u32 op_dir;
>  	int flow;
> +	struct skcipher_request fallback_req;   // keep at the end
>  };
>  
>  /*

Hello

Same as sun8i-ss, it miss the kerneldoc
otherwise
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
