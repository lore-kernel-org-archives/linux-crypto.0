Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F33DCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D34020650
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oGAKSPe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404850AbfJWLsa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:48:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37199 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404768AbfJWLsa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:48:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id e11so13025840wrv.4
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 04:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yE4YnAn9SZKLzznNbPsY5PhammBc80afB9/X/EjOBf8=;
        b=oGAKSPe1kQA6lMrI0brxudM7CZAJUzszAEPY5498i2LNSwlUw3nxfgK9uC/XJOPqfi
         3NhhY4M0EgXLKuWwroXunwD9hBt7DCb41XaU0SJRTY/NOJK/vgJgv0ZJ7/qiQsc7+6tE
         t9wWZgSOIzsl8b/571CCTDa7NcLIdcC6D+/+MdY5bnPWji+MSV9RNW9rYD37ZqoBvy2s
         7IA2tr5BUs84kcrgvf6oIFtwuKf5JrdWrgsoFgSwTmGEunV2lAdPlANfSf2wIfTMmCp3
         kWTRXBomIt5sGhGKvrpzYxoJYEDUNQ+gbagL5YDK0NYFxMNp79pZIBGsStlY28R44FT7
         4jhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yE4YnAn9SZKLzznNbPsY5PhammBc80afB9/X/EjOBf8=;
        b=gz+7JCw/0YfV4PxwyCc/7oeXQuW7dP4/m4WLXsFgWDrrjXSIqCzY7UcOkj06Vp4z+8
         6NAMvb7cVfENFiu1v7azST3c4FG0Q19p0+q8ekCOGDRq4jDsvE5mikQyETCWHu/exfD4
         CjchrklQF8cz1wllxEUyrY8vVnXSj29h+/gMeWGtsSC4/a2bp+bJVPc1WLnOcKuSHBCC
         zraP6V9wJyXh78BHakz/B1eX2OCNBD3/0uJKSM1N+RJCd0/aEPvH4eD7NJLgF6tmhJfY
         DuqGskvtlf04/dGPxmBSmMcqQE0tGUvARKxob2BsG5mOxOUgIDoNoiYhE8qnIVeQxVH6
         MbRw==
X-Gm-Message-State: APjAAAWRlaONZhLL4Cf7Sv/n35CMEsbV8b21SByb1fpcP7/PlC7T+z4u
        xiDEAeOzApHqs2jlUVxXb3AEWjiLDEIR/yhdT20hVQ==
X-Google-Smtp-Source: APXvYqxYKzDUTh69mf5PJRYZh4SniTCSMTM3HAEA58AC6X94eunzW1bXxce0wVrabQNQ80Rx5QO2sYlmO9bdYVYdjVI=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr7660096wrf.325.1571831308148;
 Wed, 23 Oct 2019 04:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com> <119557a5db5cc55c0e88f1543c0fabf0c820cb92.1571817675.git.Rijo-john.Thomas@amd.com>
In-Reply-To: <119557a5db5cc55c0e88f1543c0fabf0c820cb92.1571817675.git.Rijo-john.Thomas@amd.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 23 Oct 2019 13:48:16 +0200
Message-ID: <CAKv+Gu8Dtqr-=71e_P-h=+yBLxzyTcnp4EKsh8q_nGsXYvLL4A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] crypto: ccp - rename psp-dev files to sev-dev
To:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Thomas,

On Wed, 23 Oct 2019 at 13:27, Thomas, Rijo-john
<Rijo-john.Thomas@amd.com> wrote:
>
> This is a preliminary patch for creating a generic PSP device driver
> file, which will have support for both SEV and TEE (Trusted Execution
> Environment) interface.
>
> This patch does not introduce any new functionality, but simply renames
> psp-dev.c and psp-dev.h files to sev-dev.c and sev-dev.h files
> respectively.
>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

This is not the correct way to credit a co-author.

You are sending the patch, so your signoff should come last.

If Devaraj is a co-author of this work, you should add the following
lines *before* your signoff

Co-authored-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

If Devaraj is the sole author of this work, and you are just sending
it out, you should set the authorship on the patch to Devaraj (so it
will be From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>)

> ---
>  drivers/crypto/ccp/Makefile  |    2 +-
>  drivers/crypto/ccp/psp-dev.c | 1087 ------------------------------------------
>  drivers/crypto/ccp/psp-dev.h |   66 ---
>  drivers/crypto/ccp/sev-dev.c | 1087 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   66 +++
>  drivers/crypto/ccp/sp-pci.c  |    2 +-
>  6 files changed, 1155 insertions(+), 1155 deletions(-)
>  delete mode 100644 drivers/crypto/ccp/psp-dev.c
>  delete mode 100644 drivers/crypto/ccp/psp-dev.h
>  create mode 100644 drivers/crypto/ccp/sev-dev.c
>  create mode 100644 drivers/crypto/ccp/sev-dev.h
>

Please regenerate the patch so that the rename is reflected in the diffstat.
