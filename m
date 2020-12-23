Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1617C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 18:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF3F22287
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 18:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgLWSkl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgLWSkk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 13:40:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD91522287
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608748799;
        bh=vUX9x2rjJIpqCN27dCtMPBApRrG120cLfEn3C3MIebg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QdhntgnfinHKEZVAAaoto0H97bNAoJDmn1+ULGwArSqczsPCBwH1ZWKSGFs33Rh1k
         IBTR838/BXEJUNE4uPsFMjvXbp53r+B2biQv209B8MzvOBjar+a0GpmVh6oIcdKXcW
         Motw0LvuywnVusW1Z061KXVqT6fV2qTp/ZOye03lLtsNOGC7MiGGZ/y7Pq3ZroF+C4
         MJRbxQN9PjO/pUyIBlxzD1renkIoW3aKoBozLGbKQEy3Efqt/uYDMmCRblSnsLHghH
         sLVzmAcWuQv84OKSQobPZ7CbApCPeaPgMlRucsACFz/52KxrUkrwzQ7/2tG1J0MAKw
         peeX4V6wASnRQ==
Received: by mail-ot1-f53.google.com with SMTP id j12so15810286ota.7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Dec 2020 10:39:59 -0800 (PST)
X-Gm-Message-State: AOAM531+Yvm5ds/3EFnyUo4t4NyxeD/0LiGDJD480TSpLUa4c4E9fOim
        oAbtiPyywf+1hzaBTMne/4JHa66LRxBYyK5ENB0=
X-Google-Smtp-Source: ABdhPJxWJkOr49i97SRHcVokdrAKmYZCW7wVjty1rwOsRT6OWN3cAeXlb10fBE6M7+aj9uvaf/bfMtgzX7XW1a4vcCQ=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr20163321otu.77.1608748799155;
 Wed, 23 Dec 2020 10:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20201222130024.694558-1-marco.chiappero@intel.com>
In-Reply-To: <20201222130024.694558-1-marco.chiappero@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 23 Dec 2020 19:39:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGUBQX2HrGSS8OAC2zDS0_WyaiRQzxyFatpUG+Px+WcKQ@mail.gmail.com>
Message-ID: <CAMj1kXGUBQX2HrGSS8OAC2zDS0_WyaiRQzxyFatpUG+Px+WcKQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - add CRYPTO_AES to Kconfig dependencies
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Dec 2020 at 13:39, Marco Chiappero <marco.chiappero@intel.com> wrote:
>
> This patch includes a missing dependency (CRYPTO_AES) which may
> lead to an "undefined reference to `aes_expandkey'" linking error.
>
> Fixes: 5106dfeaeabe ("crypto: qat - add AES-XTS support for QAT GEN4 devices")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
> ---
>  drivers/crypto/qat/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
> index beb379b23dc3..846a3d90b41a 100644
> --- a/drivers/crypto/qat/Kconfig
> +++ b/drivers/crypto/qat/Kconfig
> @@ -11,6 +11,7 @@ config CRYPTO_DEV_QAT
>         select CRYPTO_SHA1
>         select CRYPTO_SHA256
>         select CRYPTO_SHA512
> +       select CRYPTO_AES
>         select FW_LOADER
>
>  config CRYPTO_DEV_QAT_DH895xCC
> --
> 2.26.2
>

This should be 'select CRYPTO_LIB_AES'
