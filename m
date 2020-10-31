Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0947C388F7
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 18:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 844512071A
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 18:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQU90Rrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgJaSzQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 14:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJaSzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 14:55:16 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C151C0617A6
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 11:55:16 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id x11so2646311vsx.12
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ihn/9P+mI1TrpSLseBlkeoMR2PdaTo/ADbJQl9C/IIU=;
        b=nQU90Rrs9I2q8LielzG3CHQ9BdmI3+TrMcefvHN8QoZr4xUAA9khecRuhiV3s1l/XY
         1BSmdGdGwXnfpvThJrRfw6KL4Bare+f196eZ+x6MknAtRLKnI6TXai4uauwnZWAUxs3Q
         C3EOoUeHWIdfooJePelKZ7nBVDAKjxMhA0IwQuVq5+UVwopeKlly3DTT0sy1XjLZN45w
         +4jiZgwa0q05L4EDXWXZM5njJV6hvZtZkvB7a6FyILewuMrvbZSZ/AMWJpxN7VXw+Bpd
         0LtuPKXqEqz2hUgQZ7OshzvRZyYYbQNmk2wes7dj7moa3rjk+8U0jfOnID6rHFXNxxAJ
         s9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ihn/9P+mI1TrpSLseBlkeoMR2PdaTo/ADbJQl9C/IIU=;
        b=lpfCzsuAPeGpqobd83ie6DJNHml8RZth7XthxuxpqHF44jC2wHhE+XRDenc5luPbRR
         OEpYRS7lUrfFzp1hkFq+FvXYmEt7fcSnAxU+CYcWYSN31FiVkUJ9gSP9DkaVZABwQTPy
         7jm49t29vSSBCUsx8dCayMTBaKxIpx0DHWY5bgL+PA4uVx4O9CwDW6E+MmscKT5LdFdF
         C8ZhGgTJZ4bZNlRxf9gJ7dZ6gYph6DFheanCAJQl1cbcCowHxIIVGodPyPjP9l7wBFDp
         buT5OiH7A3KuJ0Cq0Xc0Q2fGL3/2SK7xBuEId0AM2VyjrZuEQGvPAd4kPwZaz4naElT8
         RWnw==
X-Gm-Message-State: AOAM533rILIi19uzjoFhKr5FjXb51lBbErs03DRjxAlb2M3hSblnFgd2
        ngYgIf5F6cQlbTe+uGTdhfrJy6/rLT4=
X-Google-Smtp-Source: ABdhPJyjo8VeToXiSjZrnsgDhpYRCNaqkUmt++liiRWdHQR2sL3eL19l/M3lyWEg61U/1VVV2HMWdQ==
X-Received: by 2002:a67:2647:: with SMTP id m68mr11033016vsm.39.1604170514983;
        Sat, 31 Oct 2020 11:55:14 -0700 (PDT)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id g123sm1316198vsg.5.2020.10.31.11.55.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 11:55:14 -0700 (PDT)
Received: by mail-vk1-f173.google.com with SMTP id a8so2163293vkm.2
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 11:55:13 -0700 (PDT)
X-Received: by 2002:a1f:c149:: with SMTP id r70mr10316795vkf.1.1604170513281;
 Sat, 31 Oct 2020 11:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-13-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-13-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 14:54:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTScj_mRU0Eor2-_awn7s=AOAx_x57NOJscmmWV-BtwaFmA@mail.gmail.com>
Message-ID: <CA+FuTScj_mRU0Eor2-_awn7s=AOAx_x57NOJscmmWV-BtwaFmA@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 5:43 PM Srujana Challa <schalla@marvell.com> wrote:
>
> CPT offload module utilises the linux crypto framework to offload
> crypto processing. This patch registers supported algorithms by
> calling registration functions provided by the kernel crypto API.
>
> The module currently supports:
> - AES block cipher in CBC,ECB,XTS and CFB mode.
> - 3DES block cipher in CBC and ECB mode.
> - AEAD algorithms.
>   authenc(hmac(sha1),cbc(aes)),
>   authenc(hmac(sha256),cbc(aes)),
>   authenc(hmac(sha384),cbc(aes)),
>   authenc(hmac(sha512),cbc(aes)),
>   authenc(hmac(sha1),ecb(cipher_null)),
>   authenc(hmac(sha256),ecb(cipher_null)),
>   authenc(hmac(sha384),ecb(cipher_null)),
>   authenc(hmac(sha512),ecb(cipher_null)),
>   rfc4106(gcm(aes)).
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/crypto/marvell/Kconfig                |    4 +
>  drivers/crypto/marvell/octeontx2/Makefile     |    3 +-
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |    1 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++

These files are almost verbatim copies of
.../marvell/octeontx/otx_cptvf_algs.(ch), with the usual name changes
otx_ to otx2_

Is there some way to avoid code duplication? I guess this is not
uncommon for subsequent hardware device drivers from the same vendor.

If nothing else, knowing this makes reviewing a lot easier.
