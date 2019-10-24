Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98E7CA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFB9A2084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xv2iN//o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502520AbfJXNXD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:23:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55364 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502518AbfJXNXD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:23:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id g24so2821799wmh.5
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J3r1/BMIFSEKKYtNdVplRyzM8ILcKY2JkMVIZNu5Jtc=;
        b=xv2iN//ou7wvZe4dQvz4p7gYOHke1ZCdbtmBLQfimWNZDYbAVqiVPQyCUCJxMqece4
         aTf2PD8/afiim1yNKntcyuvi9LiFy0b3pFhSYWThLc5Mbb9BTPQ1HjnlktrNCAYA9+W5
         +DOvqpZ/dbXsEMEGLiVVoJXZJ8PxbH9dggSwA09csXhotkk6Kh3paZ/4nS1aMT0bdvZQ
         rftuSFeoS1cx8Pnpt0X1CLTwpX2D/kb0g7SOYtNLRYPKruKY6OON6Tik2fVYCi527YP8
         gv83EvQaCfcjysWn+Se2Kwy4/5CRDqwDoq4ZRuEF5y8sxs/CzcJaGwgCgBN7bKbTsCIV
         lXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J3r1/BMIFSEKKYtNdVplRyzM8ILcKY2JkMVIZNu5Jtc=;
        b=UPcYB1HwXu7xmR3n0+NKHO2mm+em8ghBJJq4E6CQ0IAb7LgV1xzhd2Dgk8F0Ks/cUW
         uKr3mpKIgOP4BDS/mtsmavjRcM39/MRkoR1WFSwnkGv/z4D+EAuJ03OXu3f+OL8m6JmW
         hz9Fl8U1/UTWS25hZMNmEO3/Lf4oHh02J4BkuLB+1u/8aXsTle7JVm2OIr931wT/bsF+
         nwA0xRiITcEKly/23kx3ICdCLZMJOEC8lfsg4mjLpGpeEpizDudlxGErXjR0A2sJSdkq
         HYxUJ4ab6QILPJeJ6+1q0W7lzepDaMcMGU//mP9qjMQ8SZQJWiqIsUII9U01whsialKM
         wHgA==
X-Gm-Message-State: APjAAAU4OD9du3netdnoiOHbcX7HMzWUD8j6myFMojBsKuT69H5Q/Vrt
        BkqiXbKVgiyd5v2bbIL7F3n2YUW4nfNvFv4pXm5MZmD/M8I/zdFn
X-Google-Smtp-Source: APXvYqyazGpMPmtIt+YYW94tw6ViYj+GufWh42EVqbTHP10h13iXosAuHKbiNnCh+r8Q1LOifp8gaqImYluW2r6Nd48=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr4978873wme.53.1571923381345;
 Thu, 24 Oct 2019 06:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <1570792690-74597-1-git-send-email-wangzhou1@hisilicon.com>
In-Reply-To: <1570792690-74597-1-git-send-email-wangzhou1@hisilicon.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Oct 2019 15:22:50 +0200
Message-ID: <CAKv+Gu-6BBC4KQ6Ld+=8XBSdxmyJkBu-3ur_=XAkhSOJnhRcwQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm Kconfig
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Oct 2019 at 13:21, Zhou Wang <wangzhou1@hisilicon.com> wrote:
>
> To avoid compile error in some platforms, select NEED_SG_DMA_LENGTH in
> qm Kconfig.
>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/crypto/hisilicon/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 82fb810d..a71f2bf 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -18,6 +18,7 @@ config CRYPTO_DEV_HISI_QM
>         tristate
>         depends on ARM64 || COMPILE_TEST
>         depends on PCI && PCI_MSI
> +       select NEED_SG_DMA_LENGTH
>         help
>           HiSilicon accelerator engines use a common queue management
>           interface. Specific engine driver may use this module.

CONFIG_NEED_SG_DMA_LENGTH shouldn't be set by an arbitrary driver -
the arch code will set this if needed, and if it doesn't, the
additional dma_length field shouldn't be expected to have a meaning.

If you are fixing a COMPILE_TEST failure, just add NEED_SG_DMA_LENGTH
as a dependency, or drop the COMPILE_TEST altogether (why was that
added in the first place?)
