Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BF4C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389102245C
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbhADPsx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbhADPsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E1B20735
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jan 2021 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775292;
        bh=j9srTszaeZCa1L2Rr8MxeF/w96fx9GbliDV30OcHtUA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ESHxJzfvaTrXJsSPhEJpKZrNQ8uYXrRb7YPTTJ3Klsugqkj8GhL75IdlJbcDcqnVI
         GNEfvEFrsnk1LSL2H+Q/YUPCkL2NMR/qaqZxsXItb+dZWPbKQIbiBAQJInJQ2V0ZFX
         gMyVXH90tg/F45MZVTEa71ptOTN0Vk6EnFDqE/wQMnzsCD5TCxclN7yXKNCuVJ7vVl
         oQJ9t57R+kE4jx7CukyxZc2FwYhu+BMXC/8ShXHyCkW3iJE23jRhsQsh9p5n7pAQ/E
         9Vs2Kv52omCgSdxxVTi7vOUJ36Z7UEhBVPqdRMAU1cq/o9e46QSWM2CS1oNzBJ3qkO
         QcAiG0DaU8tKQ==
Received: by mail-ot1-f46.google.com with SMTP id 11so26354089oty.9
        for <linux-crypto@vger.kernel.org>; Mon, 04 Jan 2021 07:48:12 -0800 (PST)
X-Gm-Message-State: AOAM53050eYGCfFyFkMbrrQoPeljvhmKhyDZSEUjjQVqH0I2kUvhMPFy
        gpeOlhan4VcUUaRdt2hVDbmDnEGvfTf+H4cWxhs=
X-Google-Smtp-Source: ABdhPJzdq3RbcuhdPUQDjwhoym08sSMi8UA5N3lhlt5mqKpOlEZA0edCZnEJJlqXIwXEEmt06B2zIwM5wbmYomRwgaU=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr52669917oto.90.1609775292046;
 Mon, 04 Jan 2021 07:48:12 -0800 (PST)
MIME-Version: 1.0
References: <20201223205755.GA19858@gondor.apana.org.au> <20210104153515.749496-1-marco.chiappero@intel.com>
In-Reply-To: <20210104153515.749496-1-marco.chiappero@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 4 Jan 2021 16:48:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXED568tx25=ZmUfL4uEDvLnqpTXzYfNbKFj-SPbp-q9Hg@mail.gmail.com>
Message-ID: <CAMj1kXED568tx25=ZmUfL4uEDvLnqpTXzYfNbKFj-SPbp-q9Hg@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in Kconfig
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 4 Jan 2021 at 16:13, Marco Chiappero <marco.chiappero@intel.com> wrote:
>
> Use CRYPTO_LIB_AES in place of CRYPTO_AES in the dependences for the QAT
> common code.
>
> Fixes: c0e583ab2016 ("crypto: qat - add CRYPTO_AES to Kconfig dependencies")
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/crypto/qat/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
> index 846a3d90b41a..77783feb62b2 100644
> --- a/drivers/crypto/qat/Kconfig
> +++ b/drivers/crypto/qat/Kconfig
> @@ -11,7 +11,7 @@ config CRYPTO_DEV_QAT
>         select CRYPTO_SHA1
>         select CRYPTO_SHA256
>         select CRYPTO_SHA512
> -       select CRYPTO_AES
> +       select CRYPTO_LIB_AES
>         select FW_LOADER
>
>  config CRYPTO_DEV_QAT_DH895xCC
> --
> 2.26.2
>
