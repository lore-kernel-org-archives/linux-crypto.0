Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0EEC4321E
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Nov 2022 21:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiK1V3g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiK1V3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2022 16:29:35 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122CF29822
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2022 13:29:33 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 74C535C01B5;
        Mon, 28 Nov 2022 16:29:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 28 Nov 2022 16:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1669670970; x=1669757370; bh=jw
        NH50kkyPaHL4wdl476Ksi+oVtPfBSWQRMUzQmSc/s=; b=B0eEIygB0gB2LIjliq
        tuJF0OIq02okW8U3OGWnb2Rm+EFwhXG5xov+5QpfDrThSINPKrF8kNgjTYrGj8XC
        8OibXGQUG22MzYt5J6X+Qai3pvJgLO/lonEzNAtGCEOujZ/7vbkfyPl/TXke3kPU
        kY0fjjPkoAsPgRxo5ucUQ/uh/C+lJuVGLhGpspZRDWv1SUn2tiqVurs5ZWt1Ym70
        bPdUTWiQ07D/m7SyK9UscSP7s9GF92P+RiWOPGVqcvBi9MoW44hmsME4Gddh16cr
        EJvF9HusXEOdG/jN+wfxjE9nZX8XtJKF8wMk+GZuEyc9YUv3kkj69J3Gaka2Imik
        i2kA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669670970; x=1669757370; bh=jwNH50kkyPaHL4wdl476Ksi+oVtP
        fBSWQRMUzQmSc/s=; b=Rn6fspLVOQrGOCru2s+OyqqRTTa+cuPudgbxOsitHwC7
        v9Vwl2YEEtQhuWF3vGyZ6uVsnuGlSII/Vm6+dZ4LuZGielNqxJum45vqKcXXYari
        hOLR6/Bg19C9mw+sdMmV0IH84mwnaTPgattI+nBDSI0R3IEw7sj0xU9lHOdt0Ewn
        geUF/+qpchDRndTLbWO1VS9vQHlzgoyPfiqhMt7XDk2R36gmoClXVIZ2W8Hysp89
        hifO7f4xAmP5g8lQhuSUdjS9pW4v/byADDVCuujNK7u6Urm6D5XHtKb8CoClVsiX
        /tcu3WPZcp6EW+R7lUvmIIiFdvLV+dsdPexjBIp6Gw==
X-ME-Sender: <xms:OCiFY3qfpttVKWfSnzpb51mSuyfVsFSw1N40fgzaHL42EojhRRdESw>
    <xme:OCiFYxqfp1HJM_XqUDVU6wCJuubgCHSrVziSSR6uxcugvPyHxe5xDPnwehzEwQe5X
    _s2GrFPJkHmbfhsOQ>
X-ME-Received: <xmr:OCiFY0NyqIwPMBEIP4E-ST2yW4p4rpohMSnE9_R5eEjOfvq9gvNf8ffk2cud5rDWbmNhyZTn06AvO2CFvqYcmOC4okRQZXZA5lLPTqsBfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedvgdduheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujghosehttdertddttddvnecuhfhrohhmpeforghr
    khcuifhrvggvrhcuoehmghhrvggvrhesrghnihhmrghltghrvggvkhdrtghomheqnecugg
    ftrfgrthhtvghrnhepuefgjeetgfetgeeiffejjeettdevfeevffefgeekhfdthedtgfef
    veekgeevvdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhm
X-ME-Proxy: <xmx:OCiFY65ECO9AArtUzDnpSt87Bjd49VVLnqafOeoKCF_9VSi6TZuyqQ>
    <xmx:OCiFY25W5aQgRu_wv9ZLMXJ_WSlw0hB_27PYr88LEz7hflkIAzbV4w>
    <xmx:OCiFYyg9m9P41ixxT17q9qcwpVlNcXs0qxIYOxIJ4Epall-Ya_1f2g>
    <xmx:OiiFY8kfb0YMjQxrKdRaFhJ70fDK-qQQRlsiqVB9lJzHKNcYZpZtXw>
Feedback-ID: i9cc843c7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Nov 2022 16:29:28 -0500 (EST)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 49B6B1360146; Mon, 28 Nov 2022 14:29:27 -0700 (MST)
Date:   Mon, 28 Nov 2022 14:29:27 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mgreer@animalcreek.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: omap-sham - Use pm_runtime_resume_and_get() in
 omap_sham_probe()
Message-ID: <20221128212927.GA60395@animalcreek.com>
References: <20221124064940.19845-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124064940.19845-1-shangxiaojing@huawei.com>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 24, 2022 at 02:49:40PM +0800, Shang XiaoJing wrote:
> omap_sham_probe() calls pm_runtime_get_sync() and calls
> pm_runtime_put_sync() latter to put usage_counter. However,
> pm_runtime_get_sync() will increment usage_counter even it failed. Fix
> it by replacing it with pm_runtime_resume_and_get() to keep usage
> counter balanced.
> 
> Fixes: b359f034c8bf ("crypto: omap-sham - Convert to use pm_runtime API")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/crypto/omap-sham.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 655a7f5a406a..cbeda59c6b19 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -2114,7 +2114,7 @@ static int omap_sham_probe(struct platform_device *pdev)
>  
>  	pm_runtime_enable(dev);
>  
> -	err = pm_runtime_get_sync(dev);
> +	err = pm_runtime_resume_and_get(dev);
>  	if (err < 0) {
>  		dev_err(dev, "failed to get sync: %d\n", err);
>  		goto err_pm;

I do not have the hardware to test this anymore but to the best of my
knowledge, this is a good change.  Thanks Shang.

Acked-by: Mark Greer <mgreer@animalcreek.com>
