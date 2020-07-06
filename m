Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE43C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFB0206CB
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 17:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUs/FRiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgGFRl7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgGFRl7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 13:41:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4D8C061755
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 10:41:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so39057049wrw.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDQFt0k/K1zuIlTzgTpSBtqc5bi3QwYG0bVafd0RHVI=;
        b=eUs/FRiWaOKDaRYsOrkxWmbJzWTn9OV//9aCqvRdXmdXBfCfF/VjmqWMBTLDPpKTMB
         JHV50FwstwM62MuMs3uLWqzvAZFcbO1LsRriMfFTP8t/1Yvn4/KPrlL7xk8vie9wG8m8
         MTZybaSNgWJ5U2J3OjyCdgWWqL5FDMBvIOXF/d7wC0T2fR2IF1GxDdkyCjKyYnuBRihE
         DuPtwufH/1zl9vYIYCeHKGdiivUiN8ksYQ4ST2jE0nl3C/8QnobR4zGbq9GyvJ9csiLp
         +bq/qk7USPIALTfXanWjUUljlV3EqJ6EGW0sCurAgD4KA755iVEI92loYeYTSUCsshlb
         wCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDQFt0k/K1zuIlTzgTpSBtqc5bi3QwYG0bVafd0RHVI=;
        b=ljsvKUjiKil6a4GC7xNT0YwavOt2oEW81x/j4GfrKe50zrodhzRLZgBwD+rpFWvZHp
         fsVroMFxItUN3c1dVDQaBqZ3Lmj3hG4ADiU0OzU6taHPsu92yw6UqCy0cuuCtHnCnmPD
         FEtnSUH6awa6dxBZchIGbGp+abI2OP2V/KYrvZ0WhFHYpdqPXtYeUm4J9Vd58eViHdcg
         wNv0FdqLqWKmzbI2fQC1Fom6GVepXlEoOk3BPiBGcQMn4foYIsPIKw8sjFRrML0TXAXz
         d1gh8zCKe9QZYbcW96RgHXk+a+eYUteIyQ18D6VofggtNKeiSDBlaCGUEFsb5z8KBIUj
         XnFg==
X-Gm-Message-State: AOAM5326mWl7tNjljqbidwOubrcAJz2Ir2KKKmnKs9cLkgs4H8Z8Dtsj
        jf1XXVP+QbwDbg0P0zDcMEE=
X-Google-Smtp-Source: ABdhPJyEcFS8VO8UqcEPbNLlPJt2YfDepFKS4P7X9Mv6lzBQ8jvYn26QpPi910JK238rw7uOSgR09w==
X-Received: by 2002:a5d:69c5:: with SMTP id s5mr49867830wrw.197.1594057317787;
        Mon, 06 Jul 2020 10:41:57 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id p25sm162835wmg.39.2020.07.06.10.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 10:41:57 -0700 (PDT)
Date:   Mon, 6 Jul 2020 19:41:55 +0200
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
Subject: Re: [PATCH v3 01/13] crypto: amlogic-gxl - default to build as module
Message-ID: <20200706174155.GA29043@Red>
References: <20200630121907.24274-1-ardb@kernel.org>
 <20200630121907.24274-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630121907.24274-2-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 02:18:55PM +0200, Ard Biesheuvel wrote:
> The AmLogic GXL crypto accelerator driver is built into the kernel if
> ARCH_MESON is set. However, given the single image policy of arm64, its
> defconfig enables all platforms by default, and so ARCH_MESON is usually
> enabled.
> 
> This means that the AmLogic driver causes the arm64 defconfig build to
> pull in a huge chunk of the crypto stack as a builtin as well, which is
> undesirable, so let's make the amlogic GXL driver default to 'm' instead.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/crypto/amlogic/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Tested-by: Corentin Labbe <clabbe@baylibre.com>

Note: you didnt CC my work address, so I answer with my personnal one.
I fear to fake some message-id.
